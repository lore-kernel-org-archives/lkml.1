Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXBNARp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXBNARp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932073AbXBNARp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:17:45 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55961 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbXBNARo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:17:44 -0500
Subject: Re: [PATCH 12/22] elevate write count files are open()ed
From: Dave Hansen <hansendc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20070213095817.d2a8a380.akpm@linux-foundation.org>
References: <20070209225329.27619A62@localhost.localdomain>
	 <20070209225337.C8EC7257@localhost.localdomain>
	 <20070212211148.c9069c97.akpm@linux-foundation.org>
	 <1171385896.6202.20.camel@localhost.localdomain>
	 <20070213095817.d2a8a380.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 16:17:37 -0800
Message-Id: <1171412257.30997.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 09:58 -0800, Andrew Morton wrote:
> > On Tue, 13 Feb 2007 08:58:16 -0800 Dave Hansen <hansendc@us.ibm.com> wrote:
> > > yipes.  A new mount-wide spin_lock/unlock for each for-writing open() and close().
> > > Can we have a microbenchmark on this please?
> > 
> > Yeah, I'll schedule some dbench time on a NUMA machine.
> 
> dbench doesn't do open() a lot.  To assess the worst-case we'd need one
> process per cpu camping in an open/close loop.

This is definitely a worst-case scenario.  A 32-way x86_64 NUMA machine
(with a pretty crappy interconnect) with a process-per-cpu all beating
on the same filesystem.  

no patch:
real: 30.111s
user: 0.031s
 sys: 2.685s

r/o bind mount patch:
real: 48.359s
user: 0.146s
 sys: 47.984s

It definitely makes a huge difference in system time, although not a
fatal one.  Christoph, what do you think?  Back to caching the
superblock flag in the mount?

#!/bin/sh
# go.sh
name=`uname -r`
grep -q /mnt/ram /proc/mounts || mount -t ramfs ram /mnt/ram;
make openbench;
nr_cpus=`cat /proc/cpuinfo | grep -c ^processor`
for ((run=0;run<5;run++)); do
        dir=$name.run.$run;
        mkdir -p $dir;
        for ((i=0;i<nr_cpus;i++)); do
                { time taskset -c $i ./openbench $((1<<16))  & } \
                > $dir/openbench.time.$i 2>&1
        done;
        wait
        echo run $run done
done

// openbench.c
#include <stdio.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

void main(int argc, char **argv)
{
        pid_t pid = getpid();
        char buf[100];
        int ret;
        int fd;
        int i;
        int loops = atoi(argv[1]);
        sprintf(&buf[0], "/mnt/ram/openbench.%d", pid);

        for (i=0; i< loops; i++) {
                fd = open(&buf[0], O_WRONLY|O_CREAT);
                if (fd < 0) {
                        perror("open error");
                        exit(fd);
                }
                write(fd, "foo");
                close(fd);
        }
        ret = unlink(&buf[0]);
        if (ret)
                perror("unlink error");
}

-- Dave

