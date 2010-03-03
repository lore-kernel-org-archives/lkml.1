Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0CCUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:01:38 -0500
Received: from tenax.loup.net ([209.169.16.66]:59246 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab0CCUBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:01:33 -0500
Date: Wed, 3 Mar 2010 12:49:53 -0700
Message-Id: <201003031949.o23Jnrsn009100@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: alan@lxorguk.ukuu.org.uk
CC: linux-kernel@vger.kernel.org, kasey.erickson@gmail.com
In-reply-to: <20100303115012.51ac89c7@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Wed, 3 Mar 2010 11:50:12 +0000)
Subject: Re: O_NONBLOCK is NOOP on block devices
References: <201003030826.o238QWXK015588@alien.loup.net> <20100303115012.51ac89c7@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > > If O_NONBLOCK is meaningful whatsoever (see man page docs for
 > > semantics) against block devices, one would expect a nonblocking io
 > 
 > It isn't...

Thanks for the reply.  It's good to get confirmation that I am not all
alone in an alternate non blocking universe.  The linux man pages
actually had me convinced O_NONBLOCK would actually keep a process
from blocking on device io :-)

 > The manual page says "When possible, the file is opened in non-blocking
 > mode" . Your write is probably not blocking - but the memory allocation
 > for it is forcing other data to disk to make room. ie it didn't block it
 > was just "slow".

Even though I know quit well what blocking is, I am not sure how we
define "slowness".  Perhaps when we do define it, we can also define
"immediately" to mean anything less than five seconds ;-)

You are correct that io to the disk is precisely what must happen to
complete, and last time I checked, that was the very definition of
blocking.  Not only are writes blocking, even reads are blocking.  The
docs for read(2) also says it will return EAGAIN if "Non-blocking I/O
has been selected using O_NONBLOCK and no data was immediately
available for reading."

There is no doubt the kernel is blocking the process whether or not
O_NONBLOCK is specified.  Look again at the timings I sent; the flag
doesn't affect io at all.  I think we can probably agree that reading
from an empty buffer cache should by definition return EAGAIN within a
few microseconds if it isn't going to block the process.  But it
doesn't.  I can easily make a process "run slowly" for an entire half
of a second or longer just trying to perform a 512 byte "non blocking"
read on a system with a virtually idle cpu.

Writing is no different from reading when the buffer cache cannot
immediately service either kind of request (i.e. all pages are dirty,
writing a page not in the cache, and there is no more free ram).  If a
process can't run while the kernel performs io to a device to service
a writev call, it is by definition blocking said process.  I certainly
concur that blocking is also both slow and not very immediate :-)

Why is blocking io an issue?  As an example, time non blocking reads
to a drive and it takes say 5ms to return from a 64k read.  Run
several processes simultaneously doing the same thing and it takes say
10ms to service each "non blocking" read request.  Do a couple hundred
ios per second in each process and you'll soon find out your processes
(or threads) have nearly zero time at the cpu despite the fact that
the system is virtually idle and you are performing 100% "linux non
blocking" device io.

I've been doing unix io for a very long time and can assure you that
this is precisely why most high performance io applications use
asynchronous io libraries or multiple threads.  It isn't that they are
necessarily compute intensive, but if read and write are going to
blocking your process, how else can you simultaneously execute ios to
different devices or perform computation while waiting on device io?

----------------------------------------------------------------------
There is currently and quite literally no point in specifying
O_NONBLOCK in Linux when opening a block device to affect anything
other than locking semantics, since it doesn't do anything.
----------------------------------------------------------------------

I'm not arguing that linux either should or should not provide non
blocking read and write calls, but pointing out that the documentation
claims it does when clearly O_NONBLOCK doesn't do anything related to
io, at least not with a block device.  Probably it doesn't do anything
related to read or write against file systems either.

 > > probably be documented for clarity and it would be straight forward
 > > for it to return an error if these contradictory behaviors are
 > > simultaneously specified, unintentionally of course.
 > 
 > and risk breaking existing apps.

Changing anything risks breaking an app somewhere :-) You are right, I
completely agree it isn't appropriate to remove it since it's meaning
has been overloaded and it affects locking semantics with O_DIRECT.

Perhaps the man pages are partly derived from POSIX specs and non
blocking read and write calls are where linux eventually wants to be?
Updating the docs to describe it's actual behavior as it stands (or
rather, lack thereof) should be fairly low impact on existing apps.

How much effort do you think it would take to build consensus to
update the man pages?  Accurate man pages don't really break code and
should really cut down on a lot of confusion, emails, and wasted
effort going forward.  Do you think we should post a documentation
defect as opposed to a kernel defect?

- Mike
