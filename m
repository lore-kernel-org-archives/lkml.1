Return-Path: <linux-kernel-owner+w=401wt.eu-S965036AbXBYRmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbXBYRmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965037AbXBYRme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:42:34 -0500
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:26818 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965036AbXBYRmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:42:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:Subject:Date:User-Agent:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eap9Cpo6HoaOmCrxr3VrHbhT2uoGGuRxW3qPcmXBwBV7KgWIQtGRjPWxMXw8hzLiTt/dWlOWS5NX6SFiJzblxDCAnkQzo8bcAhpsQ+Cm9nH7mRCps9XalqHrleHDEZa76hlHSFOcCX8ncc1KcB4W2VSjJ9rWSxy+aq2BpEiolbU=  ;
X-YMail-OSG: LhT0B9QVM1l5wnBRE6seG.k4R7HIsVwnKghDa1k7JNhGDqEQT54BRTDo3h9HTDfdEVX34QKUZ6jtFkucMNrgI33nqL8qxAAc3hSRcp.kmJ6sIjOV0_m6TgoQeeNamAkZgzMj2ObQgD8FsYk-
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] usbfs2: Why asynchronous I/O?
Date: Sun, 25 Feb 2007 09:42:30 -0800
User-Agent: KMail/1.7.1
To: Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702250942.31045.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Since Alan forwarded part the original question to LKML ... if you
follow up, please adjust CC's appropriately ]

----------  Forwarded Message  ----------

Subject: Re: [linux-usb-devel] usbfs2: Why asynchronous I/O?
Date: Sunday 25 February 2007 8:53 am
From: David Brownell <david-b@pacbell.net>
To: Sarah Bailey <saharabeara@gmail.com>
Cc: greg@kroah.com, usb-hacking@svcs.cs.pdx.edu, linux-usb-devel@lists.sourceforge.net

On Sunday 25 February 2007 12:57 am, Sarah Bailey wrote:
> I've been doing some research into how asynchronous I/O is implemented,
> and I'm beginning to doubt the usefulness of implementing aio_read
> and aio_write in usbfs2.  More detail on what I've learned can be found
> at http://wiki.cs.pdx.edu/usb/asyncdebate.html

Those two links at the bottom aren't clickable ... :)


> It was a surprise to me that aio_read(3) and aio_write(3) don't actually
> end up calling aio_read and aio_write file operations.  Instead, GNU
> libc spawns threads that call the blocking read and write file
> operations.

As you observed, the answer is to use libaio instead of the GNU libc calls.
GNU libc does not use the Linux kernel AIO capabilities.

They're not all that closely matched, for reasons I won't speculate on here.
The gap between POSIX AIO and kernel AIO has been an ongoing problem.  This
syslet/fibril/yadda-yadda stuff is just the latest spin. 


> I haven't seen any evidence that the kernel-side aio is substantially
> more efficient than the GNU libc implementation,

Face it:  spawning a new thread is fundamentally not as lightweight
as just submitting an aiocb plus an URB.  And spawning ten threads
costs a *LOT* more than submitting ten aiocbs and URBs.  (Count just
the 4KB stacks associated with each thread, vs memory consumed by
using AIO ... and remember to count the scheduling overheads.)

Or to put it differently:  *adding thick layers* can hardly improve
things when the current layer (e.g. URB) already exposes the right
model.  In such cases you want as thin a layer as possible (or none).


> so it seems like it 
> would be better to leave the complexity in userspace. 

Thing is, the kernel *already* has URBs.  And the concept behind them
maps one-to-one onto AIOCBs.  All the kernel needs to expose is:
mechanisms to submit (and probably cancel) async requests, then collect
the responses when they're done.

You're right that associating a thread with an URB is complexity.

Presumably in your operating systems studies you have come across
the notion of a behavioral duality between (async) event models
and (synchronous) task models, as applied to systems.  Often a
great source of heated discussion; LKML no exception.  Both kinds of
model can be used to describe the same complex system.  In various
contexts, each modeling approach has advantages.

One point that's often (IMO) misstated is the one about "complexity".

All intro programming classes present single-threaded non-event models,
which biases many students (and graduates!) to think that model is
somehow less complex than event based models.    Yet the real world is
more often event based ... and hiding those events beyind a synchronous
model is often more complex (and error prone, and slower) than working
directly with the async/event model.  (Hence irqs, timers, etc).

When the problem is interfacing an event based reality with a stack of
legacy synch code, it's unfair to blame those translation costs on reality 
(asynchrony) not the _desire_ to coexist with that synchronous code.
For example, many operating systems have been written _only_ with async
interfaces exposed to userspace, and thus don't need these particular
silly arguments.  :)



> I also doubt that 
> most userspace application writers know they aren't getting kernel-side
> aio when they use aio_read(3) and aio_write(3).  Why implement something
> that isn't going to be used?

I can't much help application writers that don't bother to read the
relevant documentation (after it's been pointed out to them).


> There are few examples in the kernel where the aio API is implemented in
> a truly asynchronous manner, and that leads me to wonder if the aio
> system has been thoroughly tested.  The majority of aio_read and
> aio_write file operations simply block and wait for their transactions
> to complete.

It bothers me too that the current AIO framework is so little used
except in the context of the block layer.  The folk doing AIO work
seem to have been aiming to support database loads, more than doing
real work to support async IO ... which, historically, generalized
from I/O to filesystems (rather than, as with Linux AIO, starting
with filesystems).  And the changes they have made to the AIO stack
over the past few years have not (AFAICT) been done with the least
reference to non-database scenarios; certainly, consulting anyone
other than blockdev-oriented developers was exception-not-rule.

On the other hand, that infrastructure is in place and works today.


> The only "proper" async examples I could find were gadgetfs, NFS, and
> block devices.  NFS and block devices only use aio when the O_DIRECT
> flag is set, so that code may not be well tested.  I just found a bug in
> gadgetfs that has been there for six months that means the code wasn't
> tested for when io_submit is called in readv mode.

That's the problem you noticed with the vectorized I/O?  Added by the
AIO team, but not in a gadgetfs AIO path that had previously been used.
As you noted, easily fixed.  And as you implied, not previously present.
It's something that a "must provide test suite for API" rule would have
prevented in the first place.


> So, why do I want a non-blocking aio_read and aio_write file operation?

Without it, how would you achieve I/O overlap, and thus maximize the
I/O throughput accessible when streaming data to/from userspace?  The
description you gave of glibc aio support sure sounded to me like it
was incapable of achieving much in the way of I/O overlap.

Treat your target data rate as 24 MB/sec high bandwidth ISO or interrupt
data streams.  USB hardware can sustain those transfer rates without any
real hiccups ... but *ONLY* if the driver stack never lets the transfer
queue empty.  (Now think about costs on a low-MIPS processor... where
context switch costs are disproportionately high; ARMv5 at 200 MIPS.)


> It's useful to have read and readv implemented automatically from
> aio_read, but I see no substantial benefit to implementing aio_read in a
> non-blocking way.

Actually I wouldn't care much at all about readv/writev, those are
just nice things to fall out.  The main motivation IMO is to make
sure that data can stream at peak USB bus rates, without any regular
stuttering associated with task scheduling.

- Dave

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel


-------------------------------------------------------
