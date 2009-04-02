Return-Path: <linux-kernel-owner+w=401wt.eu-S1765566AbZDBRBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765566AbZDBRBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbZDBRBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:01:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbZDBRBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:01:38 -0400
Date: Thu, 2 Apr 2009 09:57:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Rees <drees76@gmail.com>, Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090402094247.9d7ac19f.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
 <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Apr 2009, Andrew Morton wrote:
> 
> A suitable design for the streaming might be, every 4MB:
> 
> - run sync_file_range(SYNC_FILE_RANGE_WRITE) to get the 4MB underway
>   to the disk
> 
> - run fadvise(POSIX_FADV_DONTNEED) against the previous 4MB to
>   discard it from pagecache.

Here's an example. I call it "overwrite.c" for obvious reasons.

Except I used 8MB ranges, and I "stream" random data. Very useful for 
"secure delete" of harddisks. It gives pretty optimal speed, while not 
destroying your system experience.

Of course, I do think the kernel could/should do this kind of thing 
automatically. We really could do something like this with a "dirty LRU" 
queue. Make the logic be:

 - if you have more than "2*limit" pages in your dirty LRU queue, start 
   writeout on "limit" pages (default value: 8MB, tunable in /proc). 
   Remove from LRU queues.

 - On writeback IO completion, if it's not on any LRU list, insert page 
   into "done_write" LRU list.

 - if you have more than "2*limit" pages on the done_write LRU queue, 
   try to just get rid of the first "limit" pages.

It would probably work fine in general. Temp-files (smaller than 8MB 
total) would go into the dirty LRU queue, but wouldn't be written out to 
disk if they get deleted before you've generated 8MB of dirty data.

But this does the queue-handling by hand, and gives you a throughput 
indicator. It should get fairly close to disk speeds.

		Linus

---
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <linux/fs.h>

#define BUFSIZE (8*1024*1024ul)

int main(int argc, char **argv)
{
	static char buffer[BUFSIZE];
	struct timeval start, now;
	unsigned int index;
	int fd;

	mlockall(MCL_CURRENT | MCL_FUTURE);
	fd = open("/dev/urandom", O_RDONLY);
	if (read(fd, buffer, BUFSIZE) != BUFSIZE) {
		perror("/dev/urandom");
		exit(1);
	}
	close(fd);
	fd = open(argv[1], O_RDWR | O_CREAT, 0666);
	if (fd < 0) {
		perror(argv[1]);
		exit(1);
	}
	gettimeofday(&start, NULL);
	for (index = 0; ;index++) {
		double s;
		unsigned long MBps;
		unsigned long MB;

		if (write(fd, buffer, BUFSIZE) != BUFSIZE)
			break;
		sync_file_range(fd, index*BUFSIZE, BUFSIZE, SYNC_FILE_RANGE_WRITE);
		if (index)
			sync_file_range(fd, (index-1)*BUFSIZE, BUFSIZE, SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER);
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
