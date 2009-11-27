Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZK0NxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZK0NxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZK0NxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:53:06 -0500
Received: from mail1.radix.net ([207.192.128.31]:33843 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZK0NxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:53:04 -0500
Subject: Re: linux-next: workqueues tree build failure
From: Andy Walls <awalls@radix.net>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <4B0F3331.3070107@kernel.org>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>
	 <4B0E3677.6000603@kernel.org> <200911261016.58810.peter.ujfalusi@nokia.com>
	 <4B0E467A.8080201@kernel.org> <1259239225.3062.16.camel@palomino.walls.org>
	 <4B0F3331.3070107@kernel.org>
Content-Type: text/plain
Date: Fri, 27 Nov 2009 08:50:32 -0500
Message-Id: <1259329832.3053.33.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-27 at 11:02 +0900, Tejun Heo wrote:
> Hello,
> 
> 11/26/2009 09:40 PM, Andy Walls wrote:
> >> * If you need to respond fast, wouldn't you be doing that from IRQ
> >>   handler or softirq?  Do you need task context?
> > 
> > I'm not sure doing things like I2C transactions in the in the top half
> > of the IRQ handler is generally viable.

I'll back off on this statement a little as Mark Brown pointed out.  Two
16 bit exchanges on a 100 kHz I2C bus is, as a lower bound, 32/100000 =
320 microseconds (ignoring stop and start bits, turn-around times, I2C
master register access times, etc.).  320 usec isn't bad.

But in general having a slow top half can have bad effects on other
drivers sharing an IRQ line.

>   On shared IRQ lines, wouldn't
> > this hold off the interrupt for another device for too long?
> > 
> > For example, I already ran across the case of an error path in the ahci
> > disk controller driver interrupt handler holding off interrupts from the
> > cx18 driver longer than the CX23418 firmware would tolerate on a shared
> > interrupt line.
> 
> Sounds like it should be using bottom half tasklet not workqueue.
> Tasklet is exactly designed to handle situations like this.  Is there
> any reason tasklet can't be used?

Well if we're talking about the cx18 driver:

1. I recall reading a while ago that tasklets were on the way out.
Here's a recent reference:
http://lwn.net/Articles/2.6-kernel-api/
and an older one:
http://lwn.net/Articles/239633/

2. CX23418 IRQs that need deferred work can come in in very close
succession.  This is due to *one* mailbox of information from firmware
to the cx18 driver and buffer notifications for multiple streams coming
in on that mailbox and the firmware doesn't have a long timeout waiting
for the mailbox to be handled by the cx18 driver.  I needed to make sure
sequential events get queued up properly and none of them dropped.
Queueing up multiple defered work items with a tasklet seemed
problematic compared to a workqueue.

(3. Once upon a time, the cx18 buffer queues where protected by mutexes,
which can sleep.  Sleeping wasn't allowed in a tasklet but was in
workhandlers.  Those queue locks are now spinlocks though.)


But in the case I mentioned above for the cx18 and ahci drivers with
devices that share an interrupt - tasklet vs. workqueue doesn't matter.

There is a variable, but often short, time interval from CX23418 raising
the IRQn to provide notification of a completed buffer DMA, until the
CX23418 gives up waiting for cx18 driver ack and begins to overwrite
that notification with a new one.

If the ahci driver is servicing an interrupt for the shared IRQn and
leaving it masked for a very long time, like it does in an error
handling path, it is the ahci driver's interrupt service routine that is
consuming the cx18 driver's timeline, not the workqueue delays.

The fix for that is a system level one: don't have a data acquisition
type peripherial like a CX23418 based TV capture card, share an IRQ with
some other peripherial whose linux driver might have a sometimes slow
top-half.  Unfortunately, a normal home end user doesn't know to do that
until he asks for help.


Thanks.

Regards,
Andy


> Thanks.


