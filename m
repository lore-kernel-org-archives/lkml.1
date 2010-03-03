Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab0CCVXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:23:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47587 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753235Ab0CCVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:23:17 -0500
Date: Wed, 3 Mar 2010 21:25:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Hayward <hayward@loup.net>
Cc: linux-kernel@vger.kernel.org, kasey.erickson@gmail.com
Subject: Re: O_NONBLOCK is NOOP on block devices
Message-ID: <20100303212555.4dd9af74@lxorguk.ukuu.org.uk>
In-Reply-To: <201003031949.o23Jnrsn009100@alien.loup.net>
References: <201003030826.o238QWXK015588@alien.loup.net>
	<20100303115012.51ac89c7@lxorguk.ukuu.org.uk>
	<201003031949.o23Jnrsn009100@alien.loup.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> blocking.  Not only are writes blocking, even reads are blocking.  The
> docs for read(2) also says it will return EAGAIN if "Non-blocking I/O
> has been selected using O_NONBLOCK and no data was immediately
> available for reading."

The read case is more clearly blocking. We don't implement non blocking
disk I/O in that sense, although AIO sort of does and threads are very
cheap for I/O tasks.

> There is no doubt the kernel is blocking the process whether or not
> O_NONBLOCK is specified.  Look again at the timings I sent; the flag
> doesn't affect io at all.  I think we can probably agree that reading
> from an empty buffer cache should by definition return EAGAIN within a
> few microseconds if it isn't going to block the process. 

That might make sense in its own way but there would then be no reason
for the I/O ever to complete. Non blocking tends to mean "don't wait for
some external non kernel event" (eg serial data arriving, hitting a
button)

> I've been doing unix io for a very long time and can assure you that
> this is precisely why most high performance io applications use
> asynchronous io libraries or multiple threads.  It isn't that they are
> necessarily compute intensive, but if read and write are going to
> blocking your process, how else can you simultaneously execute ios to
> different devices or perform computation while waiting on device io?

The big challenge is that you may need to do disk I/O in many situations
you don't expect. Eg to find out which disk block in the cache you want
to see is available might require disk I/O itself.

You would end up with an implementation model in the kernel that was
essentially

	if (O_NDELAY) {
		try_op
		if blocking create thread
	}

which would badly underperform threading it in the first place.

Unix perhaps never got it entirely right, but we inherited that model.
VMS SYS$QIO v SYS$QIOW is a good deal more elegantly structured.

> claims it does when clearly O_NONBLOCK doesn't do anything related to
> io, at least not with a block device.  Probably it doesn't do anything
> related to read or write against file systems either.

Correct - except for things like mandatory locks where it has a real
meaning.

> Perhaps the man pages are partly derived from POSIX specs and non
> blocking read and write calls are where linux eventually wants to be?
> Updating the docs to describe it's actual behavior as it stands (or
> rather, lack thereof) should be fairly low impact on existing apps.

I've not read the SuS entries on this for a while. There was some
discussion a while ago on what was needed to create an behaviour where
as soon as something blocked it created a thread that continued to
perform the I/O side and returned an error. It's not an easy problem to
solve and it's not clear that solving it is actually worth it versus
using threads and making sure our thread implemntation is fast and has
fast synchronization primitives.

> How much effort do you think it would take to build consensus to
> update the man pages?  Accurate man pages don't really break code and
> should really cut down on a lot of confusion, emails, and wasted
> effort going forward.  Do you think we should post a documentation
> defect as opposed to a kernel defect?

I would go one further... post a documentation patch to:
linux-man@vger.kernel.org for discussion merging.

Alan
