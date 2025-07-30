FROM ubuntu:24.04

# Author label
LABEL maintainer="Yucheng Zhang <Yucheng.Zhang@tufts.edu>"

# Help message
LABEL description="This container contains miniforge installed on ubuntu:24.04."

# Set environment variables
ENV PATH=/opt/miniforge/bin:$PATH \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8
    
# Download and install Anaconda
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends build-essential wget git ca-certificates locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/conda-forge/miniforge/releases/download/25.3.1-0/Miniforge3-25.3.1-0-Linux-x86_64.sh \
    && bash Miniforge3-25.3.1-0-Linux-x86_64.sh  -b -p /opt/miniforge \
    && rm -f Miniforge3-25.3.1-0-Linux-x86_64.sh

# Update conda and clean
RUN conda update --all \
    && conda clean --all --yes \
    && rm -rf /root/.cache/pip

# Update some common python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
    
# Set default shell to bash
SHELL ["/bin/bash", "-c"]