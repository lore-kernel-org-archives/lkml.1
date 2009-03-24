Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZCXNV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZCXNV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759745AbZCXNVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:21:10 -0400
Received: from THUNK.ORG ([69.25.196.29]:38824 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202AbZCXNVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:21:08 -0400
Date: Tue, 24 Mar 2009 09:20:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324132032.GK5814@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324103111.GA26691@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:31:11AM +0100, Ingo Molnar wrote:
> > 
> > "Give kjournald a IOPRIO_CLASS_RT io priority"
> > 
> > October 2007 (yes its that old)
> 
> thx. A more recent submission from Arjan would be:
> 
>     http://lkml.org/lkml/2008/10/1/405
> 
> Resolution was that Tytso indicated it went into some sort of ext4 
> patch queue:
> 
> | I've ported the patch to the ext4 filesystem, and dropped it into 
> | the unstable portion of the ext4 patch queue.
> |
> |   ext4: akpm's locking hack to fix locking delays
> 
> but 6 months down the line and i can find no trace of this upstream 
> anywhere.

Andrew really didn't like Arjan's patch because it forces
non-synchronous writes to have a real-time I/O priority.  He suggested
an alternative approach which I coded up as "akpm's locking hack to
fix locking delays"; unfortunately, it doesn't work.

In ext4, I quietly put in a mount option, journal_ioprio, and set the
default to be slightly higher than the default I/O priority (but no a
real-time class priority) to prevent the write starvation problem.
This definitely helps for some workloads (when some task is reading
enough to starve out the rights).  

More recently (as in this past weekend), I went back to the ext3
problem, and found a better solution, here:

	 http://lkml.org/lkml/2009/3/21/304
	 http://lkml.org/lkml/2009/3/21/302
	 http://lkml.org/lkml/2009/3/21/303

These patches cause the synchronous writes caused by an fsync() to be
submitted using WRITE_SYNC, instead of WRITE, which definitely helps
in the case where there is a heavy read workload in the background.

They don't solve the problem where there is a *huge* amount of writes
going on, though --- if something is dirtying pages at a rate far
greater than the local disk can write it out, say, either "dd
if=/dev/zero of=/mnt/make-lots-of-writes" or a massive distcc cluster
driving a huge amount of data towards a single system or a wget over a
local 100 megabit ethernet from a massive NFS server where everything
is in cache, then you can have a major delay with the fsync().

However, what I've found, though, is that if you're just doing a local
copy from one hard drive to another, or downloading a huge iso file
from an ftp server over a wide area network, the fsync() delays really
don't get *that* bad, even with ext3.  At least, I haven't found a
workload that doesn't involve either dd if=/dev/zero or a massive
amount of data coming in over the network that will cause fsync()
delays in the > 1-2 second category.  Ext3 has been around for a long
time, and it's only been the last couple of years that people have
really complained about this; my theory is that it was the rise of >
10 megabit ethernets and the use of systems like distcc that really
made this problem really become visible.  The only realistic workload
I've found that triggers this requires a fast network dumping data to
a local filesystem.

(I'm sure someone will be ingeniuous enough to find something else
though, and if they're interested, I've attached an fsync latency
tester to this note.  If you find something; let me know, I'd be
interested.)

> <let-me-rant-too>
> 
> The thing is ... this is a _bad_ ext3 design bug affecting ext3 
> users in the last decade or so of ext3 existence. Why is this issue 
> not handled with the utmost high priority and why wasnt it fixed 5 
> years ago already? :-)

OK, so there are a couple of solutions to this problem.  One is to use
ext4 and delayed allocation.  This solves the problem by simply not
allocating the blocks in the first place, so we don't have to force
them out to solve the security problem that data=ordered was trying to
solve.  Simply mounting an ext3 filesystem using ext4, without making
any change to the filesystem format, should solve the problem.

Another is to use the mount option data=writeback.  The whole reason
for forcing the writes out to disk was simply to prevent a security
problem that occurs if your system crashes before the data blocks get
forced out to disk.  This could expose previously written data, which
could belong to another user, and might be his e-mail or p0rn.
Historically, this was always a problem with the BSD Fast Filesystem;
it sync'ed out data every 30 seconds, and metadata every 5 seconds.
(This is where the default ext3 commit interval of 5 seconds, and the
default /proc/sys/vm/dirty_expire_centiseconds came from.)  After a
system crash, it was possible for files written just before the crash
to point to blocks that had not yet been written, and which contain
some other users' data files.  This was the reason for Stephen Tweedie
implementing the data=ordered mode, and making it the default.

However, these days, nearly all Linux boxes are single user machines,
so the security concern is much less of a problem.  So maybe the best
solution for now is to make data=writeback the default.  This solves
the problem too.  The only problem with this is that there are a lot
of sloppy application writers out there, and they've gotten lazy about
using fsync() where it's necessary; combine that with Ubuntu shipping
massively unstable video drivers that crash if you breath on the
system wrong (or exit World of Goo :-), and you've got the problem
which was recently slashdotted, and which I wrote about here:

http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/

> It does not matter whether we have extents or htrees when there are 
> _trivially reproducible_ basic usability problems with ext3.

Try ext4, I think you'll like it.  :-)

Failing that, data=writeback for single-user machines is probably your
best bet.

						- Ted

/*
 * fsync-tester.c
 *
 * Written by Theodore Ts'o, 3/21/09.
 *
 * This file may be redistributed under the terms of the GNU Public
 * License, version 2.
 */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>

#define SIZE (32768*32)

static float timeval_subtract(struct timeval *tv1, struct timeval *tv2)
{
	return ((tv1->tv_sec - tv2->tv_sec) +
		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
}

int main(int argc, char **argv)
{
	int	fd;
	struct timeval tv, tv2;
	char buf[SIZE];

	fd = open("fsync-tester.tst-file", O_WRONLY|O_CREAT);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	memset(buf, 'a', SIZE);
	while (1) {
		pwrite(fd, buf, SIZE, 0);
		gettimeofday(&tv, NULL);
		fsync(fd);
		gettimeofday(&tv2, NULL);
		printf("fsync time: %5.4f\n", timeval_subtract(&tv2, &tv));
		sleep(1);
	}
}
	

