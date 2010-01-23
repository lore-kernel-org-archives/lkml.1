Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690Ab0AWCKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0AWCKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 21:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401Ab0AWCKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 21:10:08 -0500
Received: from rgmadvisors.com ([207.71.26.250]:33653 "EHLO
	mail.rgmadvisors.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754368Ab0AWCKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 21:10:07 -0500
X-Greylist: delayed 1523 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jan 2010 21:10:07 EST
Date: Fri, 22 Jan 2010 19:44:25 -0600
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: linux-kernel@vger.kernel.org
Cc: Nathaniel Bauernfeind <nbauernfeind@rgmadvisors.com>
Subject: Strange delays and CPU usage reading mmapped file
Message-ID: <20100123014424.GA2497@BohrerMBP.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm seeing some strange delays and high CPU usage when reading from a
memory mapped file.  It appears there is some threshold of number of
pages read, that triggers the problem and that threshold varies
depending on the machine.  I'm hoping someone can help explain what is
happening here.  See the simple example program at the end.


$ gcc mmap_read.c -o mmap_read
$ dd if=/dev/urandom of=testfile bs=4096 count=35000
$ /usr/bin/time ./mmap_read testfile 5000
Pages Touched: 35000
0.54user 0.17system 0:05.68elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+35122minor)pagefaults 0swaps

Which is what I would expect, but if I increase the number of pages:

$ dd if=/dev/urandom of=testfile bs=4096 count=40000
$ /usr/bin/time ./mmap_read testfile 5000
Pages Touched: 40000
5.00user 0.05system 0:10.06elapsed 50%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+40122minor)pagefaults 0swaps

The user time jumps to 5.00s and I get 50% CPU usage.  I've run this
on a couple of machines with the same result, but the number of pages
required to trigger the problem seems to vary.  The specs of this
machine are:

$ uname -a
Linux BohrerMBP 2.6.31.12-174.2.3.fc12.x86_64 #1 SMP Mon Jan 18 19:52:07 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux

$ cat /proc/cpuinfo | grep "model name"
model name      : Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
model name      : Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz

$ free
             total       used       free     shared    buffers     cached
Mem:       4035088     849936    3185152          0      44268     420356
-/+ buffers/cache:     385312    3649776
Swap:      4244472          0    4244472



The example program used:


#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/epoll.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
	struct stat sb;
	off_t len;
	char *p;
	int sum, i, cnt;
	int fd;
	int epfd = epoll_create(1);

	if (argc < 3){
		fprintf(stderr, "usage: %s <file> <iterations>\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDONLY);
	if (fd == -1) {
		perror("open");
		return 1;
	}

	if (fstat(fd, &sb) == -1) {
		perror ("fstat");
		return 1;
	}

	if (!S_ISREG(sb.st_mode)) {
		fprintf(stderr, "%s is not a file\n", argv[1]);
		return 1;
	}

	p = mmap(0, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (p == MAP_FAILED) {
		perror("mmap");
		return 1;
	}

	if (close(fd) == -1) {
		perror("close");
		return 1;
	}

	cnt = atoi(argv[2]);
	for (i = 0; i < cnt; ++i) {
		for (len =0; len < sb.st_size; len += 4096) {
			sum += p[len];
		}
                /* Sleep 1ms */
		epoll_wait(epfd, 0, 1, 1);
	}
	printf("Pages Touched: %d\n", len/4096);

	if (munmap(p, sb.st_size) == -1) {
		perror("munmap");
		return 1;
	}

	return 0;
}
