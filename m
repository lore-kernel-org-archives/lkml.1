Return-Path: <linux-kernel-owner+w=401wt.eu-S1762334AbXEPFry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762334AbXEPFry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761166AbXEPFrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:47:48 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:49120 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761111AbXEPFrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:47:47 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 01:47:47 EDT
Date: Tue, 15 May 2007 22:41:06 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21 numa policy and huge pages not working
Message-ID: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

prior to 2.6.21 i could "numactl --interleave=all" and use SHM_HUGETLB and 
the interleave policy would be respected.  as of 2.6.21 it doesn't seem to 
respect the policy on SHM_HUGETLB request.

see test program below.

output from pre-2.6.21:

2ab196200000 interleave=0-3 file=/2\040(deleted) huge dirty=32 N0=8 N1=8 N2=8 N3=8
2ab19a200000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096

output from 2.6.21:

2b49b1c00000 default file=/10\040(deleted) huge dirty=32 N3=32
2b49b5c00000 default file=/SYSV00000000\040(deleted) dirty=16384 active=0 N0=4096 N1=4096 N2=4096 N3=4096

was this an intentional behaviour change?  it seems to be only affecting 
SHM_HUGETLB allocations.  (i haven't tested hugetlbfs yet.)

run with "numactl --interleave=all ./shmtest"

-dean

/* shmtest.c */

#include <sys/mman.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>


static void *alloc_arena_shm(size_t arena_size, unsigned flags)
{
	FILE *fh;
	char buf[512];
	size_t huge_page_size;
	char *p;
	int shmid;
	void *arena;

	// find Hugepagesize in /proc/meminfo
	if ((fh = fopen("/proc/meminfo", "r")) == NULL) {
		perror("open(/proc/meminfo)");
		exit(1);
	}
	for (;;) {
		if (fgets(buf, sizeof(buf)-1, fh) == NULL) {
			fprintf(stderr, "didn't find Hugepagesize in /proc/meminfo");
			exit(1);
		}
		buf[sizeof(buf)-1] = '\0';
		if (strncmp(buf, "Hugepagesize:", 13) == 0) break;
	}
	p = strchr(buf, ':') + 1;
	huge_page_size = strtoul(p, 0, 0) * 1024;
	fclose(fh);

	// round the size up to multiple of huge_page_size
	arena_size = (arena_size + huge_page_size - 1) & ~(huge_page_size - 1);

	shmid = shmget(IPC_PRIVATE, arena_size, IPC_CREAT|IPC_EXCL|flags|0600);
	if (shmid == -1) {
		perror("shmget");
		exit(1);
	}

	arena = shmat(shmid, NULL, 0);
	if (arena == (void *)-1) {
		perror("shmat");
		exit(1);
	}

	if (shmctl(shmid, IPC_RMID, 0) == -1) {
		perror("shmctl warning");
	}

	return arena;
}

int main(int argc, char **argv)
{
        char buf[1024];
        const size_t sz = 64*1024*1024;
        void *arena = alloc_arena_shm(sz, SHM_HUGETLB);
        memset(arena, 0, sz);
        snprintf(buf, sizeof(buf), "grep ^%llx /proc/%d/numa_maps", (unsigned long long)arena, (int)getpid());
        system(buf);

        arena = alloc_arena_shm(sz, 0);
        memset(arena, 0, sz);
        snprintf(buf, sizeof(buf), "grep ^%llx /proc/%d/numa_maps", (unsigned long long)arena, (int)getpid());
        system(buf);

        return 0;
}
