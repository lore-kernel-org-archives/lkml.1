Return-Path: <linux-kernel-owner+w=401wt.eu-S1765043AbXHFTIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765043AbXHFTIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXHFTIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:08:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49054 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbXHFTIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:08:32 -0400
Date: Mon, 6 Aug 2007 21:08:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070806190812.GD26868@elte.hu>
References: <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos> <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com> <20070731132037.GC1046@ff.dom.local> <4bacf17f0708060000n5a00bb77i74adc3b4b28ac42b@mail.gmail.com> <20070806070300.GA4509@elte.hu> <46B75DD4.5080709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B75DD4.5080709@redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chuck Ebbert <cebbert@redhat.com> wrote:

> Before, they would print:
> 
> eth0: transmit timed out, tx_status 00 status e601.
>   diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
> eth0: Interrupt posted but not delivered -- IRQ blocked by another device?
>   Flags; bus-master 1, dirty 295757(13) current 295757(13)
>   Transmit list 00000000 vs. f7150a20.
>   0: @f7150200  length 80000070 status 0c010070
>   1: @f71502a0  length 80000070 status 0c010070
>   2: @f7150340  length 8000005c status 0c01005c
> 
> Now they just work, apparently...

could you please try the patch below? If this doesnt do the trick then i 
guess we need to revert that change.

	Ingo

------------>
(take 2)

Subject: genirq: fix simple and fasteoi irq handlers

After the "genirq: do not mask interrupts by default" patch interrupts
should be disabled not immediately upon request, but after they happen.
But, handle_simple_irq() and handle_fasteoi_irq() can skip this once or
more if an irq is just serviced (IRQ_INPROGRESS), possibly disrupting a
driver's work.

The main reason of problems here, pointing the broken patch and making
the first patch which can fix this was done by Marcin Slusarz.
Additional test patches of Thomas Gleixner and Ingo Molnar tested by
Marcin Slusarz helped to narrow possible reasons even more. Thanks.

PS: this patch fixes only one evident error here, but there could be
more places affected by above-mentioned change in irq handling.

PS 2:
After rethinking, IMHO, there are two most probable scenarios here:

1. After hw resend there could be a conflict between retriggered
edge type irq and the next level type one: e.g. if this level type
irq (io_apic is enabled then) is triggered while retriggered irq is
serviced (IRQ_INPROGRESS) there is goto out with eoi, and probably
the next such levels are triggered and looping, so probably kind of
flood in io_apic until this retriggered edge service has ended. 
2. There is something wrong with ioapic_retrigger_irq (less probable
because this should be probably seen with 'normal' edge retriggers,
but on the other hand, they could be less common).

So, if there is #1, this fixed patch should work.

But, since level types don't need this retriggers too much I think
this "don't mask interrupts by default" idea should be rethinked:
is there enough gain to risk such hard to diagnose errors?
  
So, IMHO, there should be at least possibility to turn this off for
level types in config (it should be a visible option, so people could
find & try this before writing for help or changing a network card).


Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

---

diff -Nurp 2.6.23-rc1-/kernel/irq/chip.c 2.6.23-rc1/kernel/irq/chip.c
--- 2.6.23-rc1-/kernel/irq/chip.c	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc1/kernel/irq/chip.c	2007-08-05 21:49:46.000000000 +0200
@@ -295,12 +295,11 @@ handle_simple_irq(unsigned int irq, stru
 
 	spin_lock(&desc->lock);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out_unlock;
 	kstat_cpu(cpu).irqs[irq]++;
 
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
+	if (unlikely(!action || (desc->status & (IRQ_INPROGRESS |
+						 IRQ_DISABLED)))) {
 		if (desc->chip->mask)
 			desc->chip->mask(irq);
 		desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
@@ -318,6 +317,8 @@ handle_simple_irq(unsigned int irq, stru
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
+	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
+		desc->chip->unmask(irq);
 out_unlock:
 	spin_unlock(&desc->lock);
 }
@@ -392,18 +393,16 @@ handle_fasteoi_irq(unsigned int irq, str
 
 	spin_lock(&desc->lock);
 
-	if (unlikely(desc->status & IRQ_INPROGRESS))
-		goto out;
-
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_cpu(cpu).irqs[irq]++;
 
 	/*
-	 * If its disabled or no action available
+	 * If it's running, disabled or no action available
 	 * then mask it and get out of here:
 	 */
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
+	if (unlikely(!action || (desc->status & (IRQ_INPROGRESS |
+						 IRQ_DISABLED)))) {
 		desc->status |= IRQ_PENDING;
 		if (desc->chip->mask)
 			desc->chip->mask(irq);
@@ -420,6 +419,8 @@ handle_fasteoi_irq(unsigned int irq, str
 
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
+	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
+		desc->chip->unmask(irq);
 out:
 	desc->chip->eoi(irq);
 
