Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZDCCBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZDCCBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZDCCBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:01:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47942 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZDCCBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:01:33 -0400
Message-ID: <49D56DF6.5020300@garzik.org>
Date: Thu, 02 Apr 2009 22:01:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D53787.9060503@garzik.org> <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------050203060508000602010903"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050203060508000602010903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> Feel free to give it a try. It _should_ maintain good write speed while 
> not disturbing the system much. But I bet if you added the "fadvise()" it 
> would disturb things even _less_.
> 
> My only point is really that you _can_ do streaming writes well, but at 
> the same time I do think the kernel makes it too hard to do it with 
> "simple" applications. I'd love to get the same kind of high-speed 
> streaming behavior by just doing a simple "dd if=/dev/zero of=bigfile"
> 
> And I really think we should be able to.
> 
> And no, we clearly are _not_ able to do that now. I just tried with "dd", 
> and created a 1.7G file that way, and it was stuttering - even with my 
> nice SSD setup. I'm in my MUA writing this email (obviously), and in the 
> middle it just totally hung for about half a minute - because it was 
> obviously doing some fsync() for temporary saving etc while the "sync" was 
> going on.
> 
> With the "overwrite.c" thing, I do get short pauses when my MUA does 
> something, but they are not the kind of "oops, everything hung for several 
> seconds" kind. 

Attached is my slightly-modified version of overwrite.c, modded to bound 
the file size and to use fadvise().

On a 128GB, 3.0 Gbps no-name SATA SSD, x86-64, ext3, 2.6.29 vanilla kernel:

+ ./overwrite -b 3000 /spare/tmp/test.dat
writing 3000 buffers of size 8m
       23.429 GB written in 1019.25 (23 MB/s)

real	17m0.211s
user	0m0.028s
sys	1m5.800s


+ ./overwrite -b 3000 -f /spare/tmp/test.dat
using fadvise()
writing 3000 buffers of size 8m
       23.429 GB written in 1060.54 (22 MB/s)

real	17m41.446s
user	0m0.036s
sys	1m9.016s


The most interesting thing I found:  the SSD does 80 MB/s for the first 
~1 GB or so, then slows down dramatically.  After ~2GB, it is down to 32 
MB/s.  After ~4GB, it reaches a steady speed around 23 MB/s.


--------------------------------------------------

On a 500GB, 3.0Gbps Seagate SATA drive, x86-64, ext3, 2.6.29 vanilla kernel:

+ ./overwrite -b 3000 /garz/tmp/test.dat
writing 3000 buffers of size 8m
       23.429 GB written in 539.06 (44 MB/s)

real	9m0.348s
user	0m0.064s
sys	1m2.704s


+ ./overwrite -b 3000 -f /garz/tmp/test.dat
using fadvise()
writing 3000 buffers of size 8m
       23.429 GB written in 535.08 (44 MB/s)

real	8m55.971s
user	0m0.044s
sys	1m6.600s


There is a similar performance fall-off for the Seagate, but much less 
pronounced:
	After 1GB:	52 MB/s
	After 2GB:	44 MB/s
	After 3GB:	steady state




There appears to be a small increase in system time with "-f" (use 
fadvise), but I'm guessing time(1) does not really give a good picture 
of overall system time used, when you include background VM activity.

	Jeff




--------------050203060508000602010903
Content-Type: text/plain;
 name="overwrite.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="overwrite.c"


#define _GNU_SOURCE
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <ctype.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <linux/fs.h>

#define BUFSIZE (8*1024*1024ul)

static unsigned int maxbuf = ~0U;
static int do_fadvise;

static void parse_opt(int argc, char **argv)
{
	int ch;

	while (1) {
		ch = getopt(argc, argv, "fb:");
		if (ch == -1)
			break;

		switch (ch) {
		case 'f':
			do_fadvise = 1;
			fprintf(stderr, "using fadvise()\n");
			break;
		case 'b':
			if (atoi(optarg) > 1)
				maxbuf = atoi(optarg);
			else
				fprintf(stderr, "invalid bufcount '%s'\n",
					optarg);
			break;
		default:
			fprintf(stderr, "invalid option 0%o (%c)\n",
				ch,
				isprint(ch) ? ch : '-');
			break;
		}
	}
}

int main(int argc, char **argv)
{
	static char buffer[BUFSIZE];
	struct timeval start, now;
	unsigned int index;
	int fd;

	parse_opt(argc, argv);

	mlockall(MCL_CURRENT | MCL_FUTURE);
	fd = open("/dev/urandom", O_RDONLY);
	if (read(fd, buffer, BUFSIZE) != BUFSIZE) {
		perror("/dev/urandom");
		exit(1);
	}
	close(fd);

	fd = open(argv[optind], O_RDWR | O_CREAT, 0666);
	if (fd < 0) {
		perror(argv[optind]);
		exit(1);
	}

	if (maxbuf != ~0U)
		fprintf(stderr, "writing %u buffers of size %lum\n",
			maxbuf, BUFSIZE / (1024 * 1024ul));

	gettimeofday(&start, NULL);
	for (index = 0; index < maxbuf; index++) {
		double s;
		unsigned long MBps;
		unsigned long MB;

		if (write(fd, buffer, BUFSIZE) != BUFSIZE)
			break;
		sync_file_range(fd, index*BUFSIZE, BUFSIZE, SYNC_FILE_RANGE_WRITE);
		if (index)
			sync_file_range(fd, (index-1)*BUFSIZE, BUFSIZE, SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER);
		if (do_fadvise)
			posix_fadvise(fd, (index-1)*BUFSIZE, BUFSIZE,
				      POSIX_FADV_DONTNEED);
		gettimeofday(&now, NULL);
		s = (now.tv_sec - start.tv_sec) + ((double) now.tv_usec - start.tv_usec)/ 1000000;

		MB = index * (BUFSIZE >> 20);
		MBps = MB;
		if (s > 1)
			MBps = MBps / s;
		printf("%8lu.%03lu GB written in %5.2f (%lu MB/s)           \r",
			MB >> 10, (MB & 1023) * 1000 >> 10, s, MBps);
		fflush(stdout);
	}
	close(fd);
	printf("\n");
	return 0;
}

--------------050203060508000602010903--
