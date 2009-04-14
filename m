Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZDOAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZDOAA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZDOAAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:00:08 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:17969 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZDOAAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:00:06 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 20:00:05 EDT
Date: Tue, 14 Apr 2009 16:53:48 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [ext3 performance regression] internal fragmentation on ftruncate+MAP_SHARED allocations
Message-ID: <20090414235348.GA32477@hexapodia.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm seeing really dramatic internal fragmentation (the file gets a
squential set of blocks assigned, but the virtual->physical mapping is
severely nonlinear) on ext3 with a test program that basically does

   open(O_CREAT)
   ftruncate()
   mmap(MAP_SHARED)
   ... write to random offsets in the mmap region eventually filling
   entire file ...

filefrag(8) reports:

/home/andy/tmp/big: 50435 extents found, perfection would be 9 extents

and filefrag -v reports:

Filesystem type is: ef53
Filesystem cylinder groups is approximately 5423
Blocksize of file /home/andy/tmp/big is 4096
File size of /home/andy/tmp/big is 1073741824 (262144 blocks)
First block: 59605576
Last block: 68838012
Discontinuity: Block 1 is at 59563360 (was 59605576)
Discontinuity: Block 3 is at 59563365 (was 59563361)
Discontinuity: Block 8 is at 59563362 (was 59563369)
Discontinuity: Block 10 is at 59563370 (was 59563363)
Discontinuity: Block 12 is at 59563372 (was 59563372)
Discontinuity: Block 16 is at 59563381 (was 59563375)
Discontinuity: Block 17 is at 59605568 (was 59563381)
...

The resulting 50,000-fragment file is very painful to read:

% dd if=/home/andy/tmp/big of=/dev/null bs=1M
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 58.4419 s, 18.4 MB/s

(this on a 7200rpm disk that can do 70MB/s sequential; on a slow laptop
HDD the behavior is vastly worse, with reports of it taking 10 minutes
to read a 1GB file.)

I've tested on multiple kernels including 2.6.25, 2.6.28, 2.6.29-pre,
2.6.29.1, and 2.6.30-pre with similar results observed.

On RHEL4's 2.6.9-55.ELsmp less fragmentation is observed if the file
fits in memory -- I've seen around 9-20 fragments.  On RHEL
fragmentation is observed if the file exceeds the size of physical
memory.  (On modern kernels fragmentation occurs in both the in-memory
and out-of-core cases.)  Anecdotally the behavior got worse around
2.6.18, but unfortunately I can't easily test kernels that old (the RHEL
system is a special case).

I'm using the default mount options and the destination filesystem has
lots of free space:

% grep ' /home' /proc/mounts
/dev/sda9 /home ext3 rw,errors=continue,data=ordered 0 0
% df -h /home
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda9             678G  170G  474G  27% /home

There's nothing special about the particular area of the disk being
allocated from; I created 9 1GB files "to fill in the holes" (wildly
speculating that some property of the "head of the free list" might be
causing the fragmentation) and did not see any changes in behavior.

I'm using cfq; tried noop, deadline, and anticipatory with no change.

The test system is an amd64 quad-core 6GB running 2.6.29.

Test program is attached.  Sample output:

% gcc -O2 -Wall alloctest.c -o alloctest
% rm -f ~/tmp/big && time ./alloctest ~/tmp/big $((1024*1024*1024))
touched 262144 pages in 14.552441 seconds (55.51 usec/page, 70.37 MB/s)
msync took  23.309054 seconds
munmap took 0.048076 seconds
close took  0.000013 seconds
total throughput 27.011429 MB/sec
./alloctest ~/tmp/big $((1024*1024*1024))  0.10s user 3.00s system 8% cpu 37.911 total
% sudo filefrag ~/tmp/big
/home/andy/tmp/big: 50435 extents found, perfection would be 9 extents


POTENTIAL WORKAROUNDS:

1. Using posix_fallocate(3) is somewhat helpful, but on ext3 it falls
back to doing block IO over the entire region -- which leads to a
significant delay at application startup time.

2. Behavior on ext4 and xfs is better, either with posix_fallocate(3) or
with random allocations.  Neither shows the same terrible fragmentation
pattern, and of course posix_fallocate() can simply allocate an extent.

3. Increasing vm.dirty_ratio so that synchronous writeout is never
triggered.  This does improve the behavior:

% sudo sysctl -w vm.dirty_background_ratio=5 vm.dirty_ratio=90
vm.dirty_background_ratio = 5
vm.dirty_ratio = 90
% rm -f ~/tmp/big && time ./alloctest ~/tmp/big $((1024*1024*1024))
touched 262144 pages in 1.281706 seconds (4.89 usec/page, 798.94 MB/s)
msync took  20.630176 seconds
munmap took 0.044767 seconds
close took  0.000014 seconds
total throughput 46.637147 MB/sec
./alloctest ~/tmp/big $((1024*1024*1024))  0.11s user 2.87s system 13% cpu 21.966 total
% sudo filefrag ~/tmp/big
/home/andy/tmp/big: 483 extents found, perfection would be 9 extents

but I'm concerned (1) that it's setting us up for poor behavior
elsewhere and (2) that ext3 requires this when ext4 does not.

Thanks,
-andy

--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="alloctest.c"

/* alloctest.c - create files which demonstrate internal fragmentation on
 * modern Linux kernels and filesystems.  Tested on 2.6.23, .28, .29
 * with ext2, ext3; filefrag(8) reports 10,000 to 20,000 frags for
 * a 1GB file.   Less fragmentation is observed on RHEL4 2.6.9-55.ELsmp,
 * with filefrag reporting up to a dozen extents.  Less fragmentation is
 * also observed on ext4, with around 30-40 extents reported.
 *
 * Written by Andrew Isaacson <adi@hexapodia.org> for VMware.
 * Copyright 2009 VMware, Inc.  All rights reserved.
 * Parts of this program are derived from work
 * Copyright 2002-2009 Andrew Isaacson <adi@hexapodia.org>
 * This program is free software, licensed under the GNU GPL v2.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>

#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <sys/ioctl.h>

void die(char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    exit(1);
}

double rtc(void)
{
    struct timeval t;
    static struct timeval t0;

    if(t0.tv_sec == 0) {
	gettimeofday(&t0, 0);
	return 0;
    }

    gettimeofday(&t, 0);
    return t.tv_sec - t0.tv_sec + 1e-6 * (t.tv_usec - t0.tv_usec);
}

long long rnd(long long x, long long period)
{
    return ((x + 23) * 1000000007 % period);
}

int o_touch = 0, o_write = 0, o_touchdown = 0;

void usage(char *prog)
{
    fprintf(stderr, "usage: %s [-t] file len\n", prog);
    fprintf(stderr, "  -t: touch pages (read) sequentially before writing\n");
    exit(1);
}

int main(int argc, char **argv)
{
    int i, fd, c;
    int pgsz = getpagesize(), npg;
    char *map;
    size_t sz;
    double t01, t0, t1, t2, t3, t4, t5;

    while((c = getopt(argc, argv, "dtw")) != EOF) {
	switch(c) {
	    case 'd': o_touchdown++; break;
	    case 't': o_touch++; break;
	    case 'w': o_write++; break;
	    default:
		  usage(argv[0]);
	}
    }

    if(argc < optind+2)
	usage(argv[0]);

    if((fd = open(argv[optind], O_RDWR|O_CREAT, 0666)) == -1)
	die("%s: %s\n", argv[optind]);

    sz = strtoll(argv[optind+1], 0, 0);
    npg = sz / pgsz;

    if(ftruncate(fd, sz) == -1)
	die("ftruncate(%d, %lld): %s\n", fd, (long long)sz);

    if((map = mmap(0, sz, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0)) == MAP_FAILED)
	die("mmap: %s\n", strerror(errno));

    t01 = rtc();
    if(o_touch || o_write || o_touchdown) {
	char t = 0;
	for(i = 0; i < npg; i++) {
	    int idx = o_touchdown ? (npg - i - 1) : i;
	    if(o_write)
		map[pgsz * idx] ^= t;
	    else
		t ^= map[pgsz * idx];
	}
	map[0] = t;
    }
    t0 = rtc();
    for(i = 0; i < npg; i++) {
	int pgno = (rnd(i, npg) % npg);
	int *p = (void *)(map + (long long)pgsz * pgno);

	if(*p)
	    printf("i=%d pgno=%d npg=%d p=%p hit %d\n", i, pgno, npg, p, *p);
	*p = i;
    }
    t1 = rtc();
    if(o_touch) {
	printf("streaming %s %d pages in %f seconds (%.2f usec/page, %.2f MB/s)\n",
		o_write ? "dirtied" : "touched", npg, t0-t01,
		1e6 * (t0-t01) / npg, sz / (1024.*1024) / (t0-t01));
    }
    printf("touched %d pages in %f seconds (%.2f usec/page, %.2f MB/s)\n",
	    npg, t1-t0, 1e6 * (t1-t0) / npg, sz / (1024.*1024) / (t1-t0));

    t2 = rtc();
    if(msync(map, sz, MS_SYNC) == -1)
	die("msync: %s\n", strerror(errno));
    t3 = rtc();
    if(munmap(map, sz) == -1)
	die("munmap: %s\n", strerror(errno));
    t4 = rtc();
    close(fd);
    t5 = rtc();

    printf("msync took  %f seconds\n", t3 - t2);
    printf("munmap took %f seconds\n", t4 - t3);
    printf("close took  %f seconds\n", t5 - t4);

    printf("total throughput %f MB/sec\n", sz / (1024.*1024) / (t5 - t01));

    return 0;
}

--9jxsPFA5p3P2qPhR--
