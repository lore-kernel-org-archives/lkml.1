Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZC3SB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZC3SB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZC3SBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:01:44 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:31336 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZC3SBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:01:42 -0400
Subject: Re: Linux 2.6.29
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0903300946050.3948@localhost.localdomain>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	 <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
	 <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>
	 <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx>
	 <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>
	 <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca>
	 <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca>
	 <49D0DDFE.5080701@redhat.com> <49D0E35E.9080003@rtr.ca>
	 <49D0E4E8.20508@redhat.com>
	 <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain>
	 <49D0F399.5010407@rtr.ca>
	 <alpine.LFD.2.00.0903300946050.3948@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-LZOyXtdvv099/p+Sb6Wc"
Date: Mon, 30 Mar 2009 13:57:12 -0400
Message-Id: <1238435832.30488.83.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49D107FE.0150:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LZOyXtdvv099/p+Sb6Wc
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-03-30 at 09:58 -0700, Linus Torvalds wrote:
> 
> On Mon, 30 Mar 2009, Mark Lord wrote:
> >
> > I spent an entire day recently, trying to see if I could significantly fill
> > up the 32MB cache on a 750GB Hitach SATA drive here.
> > 
> > With deliberate/random write patterns, big and small, near and far,
> > I could not fill the drive with anything approaching a full second
> > of latent write-cache flush time.
> > 
> > Not even close.  Which is a pity, because I really wanted to do some testing
> > related to a deep write cache.  But it just wouldn't happen.
> > 
> > I tried this again on a 16MB cache of a Seagate drive, no difference.
> > 
> > Bummer.  :)
> 
> Try it with laptop drives. You might get to a second, or at least hundreds 
> of ms (not counting the spinup delay if it went to sleep, obviously). You 
> probably tested desktop drives (that 750GB Hitachi one is not a low end 
> one, and I assume the Seagate one isn't either).

I had some fun trying things with this, and I've been able to reliably
trigger stalls in write cache of ~60 seconds on my seagate 500GB sata
drive.  The worst I saw was 214 seconds.

It took a little experimentation, and I had to switch to the noop
scheduler (no idea why).  

Also, I had to watch vmstat closely.  When the test first started,
vmstat was reporting 500kb/s or so write throughput.  After the test ran
for a few minutes, vmstat jumped up to 8MB/s.

My guess is that the drive has some internal threshold for when it
decides to only write in cache.  The switch to 8MB/s is when it switched
to cache only goodness.  Or perhaps the attached program is buggy and
I'll end up looking silly...it was some quick coding.

The test forks two procs.  One proc does 4k writes to the first 26MB of
the test file (/dev/sdb for me).  These writes are O_DIRECT, and use a
block size of 4k.

The idea is that we fill the cache with work that is very beneficial to
keep in cache, but that the drive will tend to flush out because it is
filling up tracks.

The second proc O_DIRECT writes to two adjacent sectors far away from
the hot writes from the first proc, and it puts in a timestamp from just
before the write.  Every second or so, this timestamp is printed to
stderr.  The drive will want to keep these two sectors in cache because
we are constantly overwriting them.

(It's worth mentioning this is a destructive test.  Running it
on /dev/sdb will overwrite the first 64MB of the drive!!!!)

Sample output:

# ./wb-latency /dev/sdb
Found tv 1238434622.461527
starting hot writes run
starting tester run
current time 1238435045.529751
current time 1238435046.531250
...
current time 1238435063.772456
current time 1238435064.788639
current time 1238435065.814101
current time 1238435066.847704

Right here, I pull the power cord.  The box comes back up, and I run:

# ./wb-latency -c /dev/sdb
Found tv 1238435067.347829

When -c is passed, it just reads the timestamp out of the timestamp
block and exits.  You compare this value with the value printed just
before you pulled the block.

For the run here, the two values are within .5s of each other.  The
tester only prints the time every one second, so anything that close is
very good.  I had pulled the plug before the drive got into that fast
8MB/s mode, so the drive was doing a pretty good job of fairly servicing
the cache.

My drive has a cache of 32MB.  Smaller caches probably need a smaller
hot zone.

-chris


--=-LZOyXtdvv099/p+Sb6Wc
Content-Disposition: attachment; filename="wb-latency.c"
Content-Type: text/x-csrc; name="wb-latency.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * wb-latency.c
 *
 * This file may be redistributed under the terms of the GNU Public
 * License, version 2.
 */
#define _FILE_OFFSET_BITS 64
#define _XOPEN_SOURCE 600
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <signal.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>

#ifndef O_DIRECT
#define O_DIRECT         040000 /* direct disk access hint */
#endif

static int page_size = 4096;

static float timeval_subtract(struct timeval *tv1, struct timeval *tv2)
{
	return ((tv1->tv_sec - tv2->tv_sec) +
		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
}

/*
 * the magic offset is where we write our timestamps.
 * The idea is that we write constantly to the magic offset
 * and then pull the power.
 * After the OS comes back, we read the timestamp stored and compare
 * it with the time stamp printed.  Any difference over 1s is time the
 * IO spent stalled in cache.
 */
static loff_t magic_offset(loff_t total)
{
	loff_t cur = total - ((loff_t)64) * 1024;
	cur = cur / page_size;
	cur = cur * page_size;
	return cur;
}

/*
 * this function runs in a loop overwriting two nearby
 * sectors.  The idea is to create something the
 * drive is likely to store in cache and not send down very often.
 *
 * It writes a timestamp to the sector and to stderr.  After
 * crashing, compare the output of wb-latency -c with the last
 * thing printed on stderr.
 */
static void timestamp_io(int fd, char *buf, loff_t total)
{
	loff_t cur = magic_offset(total);
	struct timeval tv;
	struct timeval print_tv;
	int ret;

	cur = cur / page_size;
	cur = cur * page_size;

	printf("starting tester run\n");
	gettimeofday(&print_tv, NULL);
	while(1) {
		gettimeofday(&tv, NULL);
		memcpy(buf, &tv, sizeof(tv));

		if (timeval_subtract(&tv, &print_tv) >= 1) {
			fprintf(stderr, "current time %lu.%lu\n",
				tv.tv_sec, tv.tv_usec);
			gettimeofday(&print_tv, NULL);
		}

		ret = pwrite(fd, buf, page_size, cur);
		if (ret < page_size) {
			fprintf(stderr, "short write ret %d cur %llu\n",
				ret, (unsigned long long)cur);
			exit(1);
		}

		ret = pwrite(fd, buf, page_size, cur + page_size * 2);
		if (ret < page_size) {
			fprintf(stderr, "short write ret %d cur %llu\n",
				ret, (unsigned long long)cur);
			exit(1);
		}

	}
}

/*
 * just print out the timestamp in our magic sector
 */
static void check_timestamp_io(int fd, char *buf, loff_t total)
{
	int ret;
	struct timeval tv;
	loff_t cur = magic_offset(total);

	ret = pread(fd, buf, page_size, cur);
	if (ret < page_size) {
		perror("read");
		exit(1);
	}
	memcpy(&tv, buf, sizeof(tv));
	printf("Found tv %lu.%lu\n", tv.tv_sec, tv.tv_usec);
}

int main(int argc, char **argv)
{
	int	fd;
	struct stat st;
	pid_t pid;
	int ret;
	int i;
	int status;
	loff_t total_size = 128 * 1024 * 1024;
	loff_t hot_size = 26 * 1024 * 1024;
	loff_t cur;
	char *buf;
	char *filename = NULL;
	int check_only = 0;

	ret = posix_memalign((void *)(&buf), page_size, page_size);
	if (ret) {
		perror("memalign\n");
		exit(1);
	}

	memset(buf, 0, page_size);

	if (argc < 2) {
		fprintf(stderr, "usage: wb-latency [-c] file\n");
		exit(1);
	}
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-c") == 0)
			check_only = 1;
		else
			filename = argv[i];
	}

	fd = open(filename, O_RDWR | O_DIRECT | O_CREAT);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	ret = fstat(fd, &st);
	if (ret < 0) {
		perror("fstat");
		exit(1);
	}

	check_timestamp_io(fd, buf, total_size);

	if (check_only)
		exit(0);

	/* setup the file if we aren't doing a block device */
	if (!S_ISBLK(st.st_mode) && st.st_size < total_size) {
		printf("setting up file %s\n", filename);
		while(cur < total_size) {
			ret = write(fd, buf, page_size);
			if (ret <= 0) {
				fprintf(stderr, "short write\n");
				exit(1);
			}
			cur += ret;
		}
		printf("done setting up %s\n", filename);
	}

	pid = fork();
	if (pid == 0) {
		timestamp_io(fd, buf, total_size);
		exit(0);
	}
	waitpid(pid, &status, WNOHANG);

	/*
	 * here we run the hot IO.  This is something the drive isn't
	 * going to bypass the cache on, but something the drive will
	 * tend to allow to dominate the cache.
	 */
	printf("starting hot writes run\n");
	cur = 0;
	while(1) {
		pwrite(fd, buf, page_size, cur);
		cur += page_size;
		if (cur > hot_size)
			cur = 0;
	}

	return 0;
}

--=-LZOyXtdvv099/p+Sb6Wc--

