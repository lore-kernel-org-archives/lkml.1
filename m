Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXB1UkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXB1UkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932225AbXB1UkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:40:15 -0500
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:34299 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932224AbXB1UkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:40:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QbQqp5K0tMTZXcWbgD8+L3QkslS4v9E2gB3pH/d63Y/rF8xlhx60MCpCfKH7swb4DgTPgySSNILUHVlo12MrGWw197bZ0oen7XeftCyCreQKQhDUWbW8kAC7KF8XnPgAYl/nE+9MW5heRkBUAgeqQjBQKX+JiJlMb10cx4BNHaM=  ;
X-YMail-OSG: mmExHmkVM1l8r1CCMA1VxgrRtWzESBfaijyb1eBdGRogGm.CXBm2XeTRIlhgoMsTMy.TPYw7EIOnn5SOyQ_H5P27H5p6N7V97pjYsX5v13YPrpAT1mWT
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] usbfs2: Why asynchronous I/O?
Date: Wed, 28 Feb 2007 12:03:57 -0800
User-Agent: KMail/1.7.1
Cc: Sarah Bailey <saharabeara@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       usb-hacking@svcs.cs.pdx.edu
References: <20070225085755.GA4886@localdomain> <Pine.LNX.4.44L0.0702251147500.25265-100000@netrider.rowland.org> <20070226085431.GA16499@localdomain>
In-Reply-To: <20070226085431.GA16499@localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281203.58409.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 February 2007 12:54 am, Sarah Bailey wrote:
> On Sun, Feb 25, 2007 at 08:53:03AM -0800, David Brownell wrote:
> > On Sunday 25 February 2007 12:57 am, Sarah Bailey wrote:
> > > I haven't seen any evidence that the kernel-side aio is substantially
> > > more efficient than the GNU libc implementation,
> > 
> > Face it:  spawning a new thread is fundamentally not as lightweight
> > as just submitting an aiocb plus an URB.  And spawning ten threads
> > costs a *LOT* more than submitting ten aiocbs and URBs.  (Count just
> > the 4KB stacks associated with each thread, vs memory consumed by
> > using AIO ... and remember to count the scheduling overheads.)
> 
> Yes, spawning a new thread is costly.  However, if someone writes their
> own thread-based program and allocates the threads from a pool, that
> argument is irrelevant. 

I don't see how that would follow from that assumption.  But even if
it did, the assumption isn't necessarily valid.  People who can write
threaded programs are the minority; people who can write correct ones
are even more rare!

We all hope that changes.  It's been hoped for at least a decade now.
Maybe in another decade or two, such skills can safely be assumed.


> Even with fibrils, you have a stack and 
> scheduling overhead.  With kernel AIO, you have also have some memory
> overhead, and you also have context switch overhead when you call
> kick_iocb or aio_complete.
> 
> Can someone point me at hard evidence one way or another?

(stack_size + other_thread_costs + urb_size) > (aoicb_size + urb_size)

There was recent discussion on another LKML thread pointing out how an
event-driven server ran at basically 100% of hardware capacity, where
a thread-one ran at 60%.  (That was, as I infer by skimming archives of
that threadlet discussion, intended to be a fair comparison...)


> > > so it seems like it would be better to leave the complexity in
> > > userspace. 
> > 
> > Thing is, the kernel *already* has URBs.  And the concept behind them
> > maps one-to-one onto AIOCBs.  All the kernel needs to expose is:
> > mechanisms to submit (and probably cancel) async requests, then collect
> > the responses when they're done.
> 
> It seems to me that you're arguing that URBs and AIOCBs go together on
> the basis that they are both asynchronous and both have some sort of
> completion function.  Just because two things are alike doesn't mean
> that it's better to use them together.

I pointed out that any other approach must accordingly add overhead.
One of the basic rules of thumb in system design is to avoid such
needless additions.


> > You're right that associating a thread with an URB is complexity.
> 
> That's not what I said.

No ... but you *were* avoiding that consequence what you did say, though.


> > I can't much help application writers that don't bother to read the
> > relevant documentation (after it's been pointed out to them).
> 
> Where is this documentation?  There's a man page on io_submit, etc., but
> how would an application writer know to look for it?

How did *you* know to look for it?  How did *I* know to look for it?

ISTR asking Google, and finding that "libaio" is how to get access
to the Linux kernel AIO facility.  Very quickly.  I didn't even need
to make the mistake of trying to use POSIX calls then finding they
don't work ...


> > The gap between POSIX AIO and kernel AIO has been an ongoing problem.  This
> > syslet/fibril/yadda-yadda stuff is just the latest spin.
> 
> Do you think that fibrils will replace the kernel AIO?

Still under discussion, but I hope not.  But remember two different things
are being called AIO -- while in my book, only one of them is really AIO.

 - The AIO VFS interface ... which is mostly ok, though the retry stuff
   is wierd as well as misnamed, and the POSIX hookery should also be
   improved.  (Those POSIX APIs omit key functionality, like collecting
   multiple results with one call, and are technically inferior.  Usually
   that's so that vendors can claim conformance without kernel updates.
   It could also be that the functionality is "optional", and so not part
   of what I find in my systems's libc.)

 - Filesystem hookery and direct-io linkage ... which has been trouble,
   and I suspect was never the right design.  The filesystem stacks in
   Linux were designed around thread based synch, so trying to slide
   an event model around the edges was probably never a good idea.

I see fibrils/threadlets/syslets/etc as a better approach to that hookery;
something like EXT4 over a RAID is less likely to break if that complex
code is not forced to restructure itself into an event model.

But for things that are already using event models ... the current AIO
is a better fit.  And maybe getting all that other stuff out of the mix
will finally let some of the "real I/O, not disks" AIO issues get fixed.

All of the "bad" things I've heard about AIO in Linux boil down to either
(a) criticisms about direct-IO and that filesystem hookery, rather than
about the actual AIO infrastructure; or else (b) some incarnation of the
can-never-end threads-vs-events discussion, taking a quasi-religious
stance against the notion of events.


> It seems like a 
> logicial conclusion, but does the kernel AIO give you anything more?

I'm repeating myself here:  it's the lowest overhead access to the
underlying I/O interface, which is fundamentally asynchronous ... so
there's no impedence mismatch.

Trying to match impedence of the "async I/O" core to threads gives
a lot of opportunities for bugs to join the party, of course.

And a lot of the most reliable systems code (in both user space and
kernel space) tends to follow event models.  Real time systems, for
example, like the way event handling costs can be bounded.  (A better
way to view "real time" systems is as "guaranteed response time"
systems".)  The analysis needed to prove correctness is usually less
difficult using event models than threading.

On the other hand, threads can be very quick-to-code, and if you
don't need/want such an "is it correct" analysis/review (i.e. it's
OK to hit bugs-in-the-field that are really painful to discover).


> For example, I think it currently allows drivers to guarantee that the
> requests will be queued in the order they are submitted.  GNU libc and
> fibrils can't make that guarantee because the operations may block
> before the request enters the hardware queue.  

That'd be an important issue, yes.  Though I'd certainly expect that if
userspace synchronized its submissions correctly (W1 then W2 then W3),
then no lower level code (libc, kernel, etc) would even contemplate
re-ordering that as W2, W1, W3 ...

- Dave
