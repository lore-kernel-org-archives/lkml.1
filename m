Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZCAFLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZCAFLi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 00:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbZCAFLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 00:11:30 -0500
Received: from mail.openmoko.org ([88.198.124.205]:37439 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZCAFLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 00:11:30 -0500
Date: Sun, 1 Mar 2009 10:41:04 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       Andy Green <andy@openmoko.com>
Subject: Re: [PATCH 0/2] spi: Add support for non-blocking synchronous
	transfers
Message-ID: <20090301051103.GA3103@fedora.yogi>
References: <20090228081036.31964.80618.stgit@fedora.yogi> <200902281233.50612.david-b@pacbell.net> <20090228221247.GA3107@fedora.yogi> <200902281519.55341.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902281519.55341.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 03:19:55PM -0800, David Brownell wrote:
> > > > During the course of development of an accelerometer driver, we saw the
> > > > necessity to execute spi transfers synchronously within an interrupt handler.
> > > 
> > > This sounds like a bad design.  How can you know that no other
> > > transfers are going on ... or are queued in front of the transfer
> > > you're requesting?
> > > 
> > > You'd need to wait for all the other transfers to work their
> > > way through the transfer queue.  There are *much* better things
> > > to do in interrupt handlers.
> > > 
> > 
> > Please do look at the patches. We *don't* use a transfer queue.
> 
> Another example of a conceptual bug.  Because SPI is a shared
> bus, transfers to some other device may be happening when you
> issue a request.  And accordingly, you'd need to wait for that
> transfer to complete.  The SPI I/O queue is at least a logical
> abstraction for that reality.  I have a hard time imagining any
> spi_master driver not having some kind of queue data structure.
> 
> Plus, see Documentation/spi/spi-summary:
> 
> | SPI requests always go into I/O queues.  Requests for a given SPI device
> | are always executed in FIFO order, and complete asynchronously through
> | completion callbacks.  There are also some simple synchronous wrappers
> | for those calls, including ones for common transaction types like writing
> | a command and then reading its response.
> 
> Note that the queueing discipline is explicitly unspecified,
> except in the context of a given spi_device.  If you want
> your spi_master controller to prioritize one device, that's
> fine ... but it's not part of the interface used by portable
> drivers (it'd be platform-specific).
> 
> 
> > Transfers requested through our proposed function should/will complete the
> > transfer when it returns without sleeping in between. (Which is the whole
> > point of this patch).
> 
> So instead of "non-blocking" you mean "non-sleeping".
> 
> That leaves un-answered the question of what to do when
> the SPI bus is busy performing some other transfer.  I
> looked at your [2/2] patch, and saw it ignoring that very
> basic issue ... this new call will just poke at the bus,
> trashing any transfer that was ongoing.
> 

We use s3c24xx_gpio as the master, which is a very simple gpio based
bitbang. 

Yes, it is with this intention, interrupts are disabled around the
actual bitbang code, so that it completes without being interrupted.
Doesn't this guarantee atomicity ?


> > > Why are you even trying to touch SPI devices from hardirq
> > > context?  That's never going to be OK; "can't-sleep" contexts
> > > don't mix with "must-sleep" calls.
> > 
> > Accelerometers can produce a huge amount of data and we need to quickly
> > read them to avoid overruns. Also, scheduling workers for this greatly
> > increases the number of context switches, unnecessarily.
> 
> That sounds like a performance issue with the spi_master driver
> you're using.  Using the bitbang framework, and worker tasks, is
> a good way to get something going quickly.  But if I wanted high
> performance, I'd likely use a more traditional driver structure
> (with no tasks, IRQ driven, DMA).  Or I might just increase the
> priority of the relevant tasks; depends on what bottlenecks turn
> up when I measure things.
> 

OK, true. But since the master here is a simple s3c24xx based gpio
bitbang, we can't do DMA, or bitbang is the only way to go.

> That might combine with sub-optimal design for your accelerometer
> driver or hardware.  Can you keep multiple transfers queued?  Are
> you using async messaging intelligently?
> 

No, we can't queue multiple transfers. It would be very helpful if it
were so.

> 
> > > > This series adds a new interface for this and modifies no existing ones.
> > > 
> > > NAK on these two patches.
> > > 
> > 
> > Ok, it will be helpful if you please suggest an alternative keeping in
> > mind the huge amount of data produced by the accelerometer and the need
> > to read them quickly ?
> 
> If your spi_master driver isn't using DMA, fix that.  Nothing
> else addresses "huge amount of data" well at all.
> 
> If some driver -- spi_master, accelerometer, or whatever -- is
> introducing context switch delays in critical paths, get rid of
> those.  The gap between one DMA transfer and the next can be on
> the order of one IRQ latency, using current interfaces, if the
> drivers are decently written.

Since it's a simple gpio bitbang we are using, we cannot do DMA, isn't
it ? Sorry, I'm still not convinced of a way to make it work with
queueable transfers. Do you still say that spi_async is the way to go ?
Please explain.

Thanks a lot for your time.

- Balaji
