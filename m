Return-Path: <linux-kernel-owner+w=401wt.eu-S1761884AbXGZMfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761884AbXGZMfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758065AbXGZMeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:34:50 -0400
Received: from mx2.go2.pl ([193.17.41.42]:35915 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757445AbXGZMes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:34:48 -0400
Date: Thu, 26 Jul 2007 14:44:01 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marcin ??lusarz <marcin.slusarz@gmail.com>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, Jeff Garzik <jeff@garzik.org>
Subject: [PATCH][netdrvr] lib8390: comment on locking by Alan Cox Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070726124401.GC3423@ff.dom.local>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com> <20070629150759.GC2771@ff.dom.local> <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com> <20070724080534.GC18740@elte.hu> <20070724094202.GA11610@elte.hu> <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org> <20070724200431.GA22190@elte.hu> <1185322771.4175.102.camel@chaos> <20070725135718.GB1843@ff.dom.local> <20070725154656.54fd6f13@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725154656.54fd6f13@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Very below is my patch proposal with a comment, which in my opinion
is precious enough to save it for future help in reading and
understanding the code.

I hope Alan will not blame me I've not asked for his permission before
sending, and he would ack this patch as it is or at least most of this.

Thanks & regards,
Jarek P.

On Wed, Jul 25, 2007 at 03:46:56PM +0100, Alan Cox wrote:
> > > The code in question lib8390.c does
> > > 
> > > 	disable_irq();
> > > 	fiddle_with_the_network_card_hardware()
> > > 	enable_irq();
> > ...
> > > 
> > > No idea how this affects the network card, as the code there must be
> > > able to handle interrupts, which are not originated from the card due to
> > > interrupt sharing.
> > 
> > I think, in this last yesterday's patch Ingo could be right, yet!
> > The comment at the beginnig points this is done like that because
> > of chip's slowness. And problems with timing are mysterious.
> > 
> > On the other hand author of this code didn't use spin_lock_irqsave
> > for some reason, probably after testing this option too. So, I hope
> > this is the right path, but alas, I'm not sure this patch has to
> > prove this 100%.
> 
> The author (me) didn't use spin_lock_irqsave because the slowness of the
> card means that approach caused horrible problems like losing serial data
> at 38400 baud on some chips. Rememeber many 8390 nics on PCI were ISA
> chips with FPGA front ends.
> 
> > Anyway, in my opinion this situation where interrupts could/have_to
> > be used for such strange things should confirm the need of more
> > options for handling irqs individually.
> 
> Ok the logic behind the 8390 is very simple:
> 
> Things to know
> 	- IRQ delivery is asynchronous to the PCI bus
> 	- Blocking the local CPU IRQ via spin locks was too slow
> 	- The chip has register windows needing locking work
> 
> So the path was once (I say once as people appear to have changed it
> in the mean time and it now looks rather bogus if the changes to use
> disable_irq_nosync_irqsave are disabling the local IRQ)
> 
> 
> 	Take the page lock
> 	Mask the IRQ on chip
> 	Disable the IRQ (but not mask locally- someone seems to have
> 		broken this with the lock validator stuff)
> 		[This must be _nosync as the page lock may otherwise
> 			deadlock us]
> 	Drop the page lock and turn IRQs back on
> 	
> 	At this point an existing IRQ may still be running but we can't
> 	get a new one
> 
> 	Take the lock (so we know the IRQ has terminated) but don't mask
> the IRQs on the processor
> 	Set irqlock [for debug]
> 
> 	Transmit (slow as ****)
> 
> 	re-enable the IRQ
> 
> 
> We have to use disable_irq because otherwise you will get delayed
> interrupts on the APIC bus deadlocking the transmit path.
> 
> Quite hairy but the chip simply wasn't designed for SMP and you can't
> even ACK an interrupt without risking corrupting other parallel
> activities on the chip.
> 
> Alan
> 
------>

From: Jarek Poplawski <jarkao2@o2.pl>

Subject: lib8390: comment on locking by Alan Cox

Additional explanation of problems with locking by Alan Cox.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Jeff Garzik <jeff@garzik.org>

---

diff -Nurp 2.6.23-rc1-/drivers/net/lib8390.c 2.6.23-rc1/drivers/net/lib8390.c
--- 2.6.23-rc1-/drivers/net/lib8390.c	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc1/drivers/net/lib8390.c	2007-07-26 13:55:17.000000000 +0200
@@ -143,6 +143,52 @@ static void __NS8390_init(struct net_dev
  *	annoying the transmit function is called bh atomic. That places
  *	restrictions on the user context callers as disable_irq won't save
  *	them.
+ *
+ *	Additional explanation of problems with locking by Alan Cox:
+ *
+ *	"The author (me) didn't use spin_lock_irqsave because the slowness of the
+ *	card means that approach caused horrible problems like losing serial data
+ *	at 38400 baud on some chips. Rememeber many 8390 nics on PCI were ISA
+ *	chips with FPGA front ends.
+ *	
+ *	Ok the logic behind the 8390 is very simple:
+ *	
+ *	Things to know
+ *		- IRQ delivery is asynchronous to the PCI bus
+ *		- Blocking the local CPU IRQ via spin locks was too slow
+ *		- The chip has register windows needing locking work
+ *	
+ *	So the path was once (I say once as people appear to have changed it
+ *	in the mean time and it now looks rather bogus if the changes to use
+ *	disable_irq_nosync_irqsave are disabling the local IRQ)
+ *	
+ *	
+ *		Take the page lock
+ *		Mask the IRQ on chip
+ *		Disable the IRQ (but not mask locally- someone seems to have
+ *			broken this with the lock validator stuff)
+ *			[This must be _nosync as the page lock may otherwise
+ *				deadlock us]
+ *		Drop the page lock and turn IRQs back on
+ *		
+ *		At this point an existing IRQ may still be running but we can't
+ *		get a new one
+ *	
+ *		Take the lock (so we know the IRQ has terminated) but don't mask
+ *	the IRQs on the processor
+ *		Set irqlock [for debug]
+ *	
+ *		Transmit (slow as ****)
+ *	
+ *		re-enable the IRQ
+ *	
+ *	
+ *	We have to use disable_irq because otherwise you will get delayed
+ *	interrupts on the APIC bus deadlocking the transmit path.
+ *	
+ *	Quite hairy but the chip simply wasn't designed for SMP and you can't
+ *	even ACK an interrupt without risking corrupting other parallel
+ *	activities on the chip." [lkml, 25 Jul 2007]
  */
 
 
