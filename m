Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZKAVdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZKAVdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZKAVds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:33:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58355 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZKAVdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:33:47 -0500
Date: Sun, 1 Nov 2009 22:33:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-arm-kernel@lists.infradead.org, Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       utx@penguin.cz
Subject: Re: Possible suspend/resume regression in .32-rc?
Message-ID: <20091101213343.GA31345@elf.ucw.cz>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
 <20091101205449.GT14091@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101205449.GT14091@buzzloop.caiaq.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Is anyone using suspend/resume with a recent git mainline kernel on PXA
> > or other ARM embedded boards? My platform used to suspend and resume
> > just fine on 2.6.31 but now as I rebased it, it fails the resume part.
> > 
> > Unfortunately, I can't bisect it as the platform is not mainline yet and
> > so I always have mandatory patches (without my platform won't do
> > anything) on top of the git repository. Which breaks the bisect logic.
> > 
> > What puzzles me is that I see the current raising at wakeup time, so at
> > least the processor seems to resume, but I can't see any serial console
> > output, just like if the kernel crashed very early after wakeup.
> > 'no_console_suspend' didn't help either.
> 
> Ok, got it. The culprit is commit d2c37068 ("[ARM] pxa: initialize
> default interrupt priority and use ICHP for IRQ handling"). Reverting it
> make suspend/resume work again on my board.
> 
> Haojian, Eric, could you have a look at this?

Okay, patch is this one: I'll test reverting it shortly.

commit d2c37068429b29d6549cf3486fc84b836689e122
Author: Haojian Zhuang <haojian.zhuang@marvell.com>
Date:   Wed Aug 19 19:49:31 2009 +0800

    [ARM] pxa: initialize default interrupt priority and use ICHP for IRQ handling
    
    Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

diff --git a/arch/arm/mach-pxa/include/mach/entry-macro.S b/arch/arm/mach-pxa/include/mach/entry-macro.S
index f6b4bf3..2418806 100644
--- a/arch/arm/mach-pxa/include/mach/entry-macro.S
+++ b/arch/arm/mach-pxa/include/mach/entry-macro.S
@@ -24,34 +24,27 @@
 		mov	\tmp, \tmp, lsr #13
 		and	\tmp, \tmp, #0x7		@ Core G
 		cmp	\tmp, #1
-		bhi	1004f
+		bhi	1002f
 
+		@ Core Generation 1 (PXA25x)
 		mov	\base, #io_p2v(0x40000000)	@ IIR Ctl = 0x40d00000
 		add	\base, \base, #0x00d00000
 		ldr	\irqstat, [\base, #0]		@ ICIP
 		ldr	\irqnr, [\base, #4]		@ ICMR
-		b	1002f
 
-1004:
-		mrc	p6, 0, \irqstat, c6, c0, 0	@ ICIP2
-		mrc	p6, 0, \irqnr, c7, c0, 0	@ ICMR2
 		ands	\irqnr, \irqstat, \irqnr
-		beq	1003f
+		beq	1001f
 		rsb	\irqstat, \irqnr, #0
 		and	\irqstat, \irqstat, \irqnr
 		clz	\irqnr, \irqstat
-		rsb	\irqnr, \irqnr, #31
-		add	\irqnr, \irqnr, #(32 + PXA_IRQ(0))
+		rsb	\irqnr, \irqnr, #(31 + PXA_IRQ(0))
 		b	1001f
-1003:
-		mrc	p6, 0, \irqstat, c0, c0, 0	@ ICIP
-		mrc	p6, 0, \irqnr, c1, c0, 0	@ ICMR
 1002:
-		ands	\irqnr, \irqstat, \irqnr
+		@ Core Generation 2 (PXA27x) or Core Generation 3 (PXA3xx)
+		mrc	p6, 0, \irqstat, c5, c0, 0	@ ICHP
+		tst	\irqstat, #0x80000000
 		beq	1001f
-		rsb	\irqstat, \irqnr, #0
-		and	\irqstat, \irqstat, \irqnr
-		clz	\irqnr, \irqstat
-		rsb	\irqnr, \irqnr, #(31 + PXA_IRQ(0))
+		bic	\irqstat, \irqstat, #0x80000000
+		mov	\irqnr, \irqstat, lsr #16
 1001:
 		.endm
diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index f6e0300..d694ce2 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -120,7 +120,7 @@ static void __init pxa_init_low_gpio_irq(set_wake_t fn)
 
 void __init pxa_init_irq(int irq_nr, set_wake_t fn)
 {
-	int irq;
+	int irq, i;
 
 	pxa_internal_irq_nr = irq_nr;
 
@@ -129,6 +129,12 @@ void __init pxa_init_irq(int irq_nr, set_wake_t fn)
 		_ICLR(irq) = 0;	/* all IRQs are IRQ, not FIQ */
 	}
 
+	/* initialize interrupt priority */
+	if (cpu_is_pxa27x() || cpu_is_pxa3xx()) {
+		for (i = 0; i < irq_nr; i++)
+			IPR(i) = i | (1 << 31);
+	}
+
 	/* only unmasked interrupts kick us out of idle */
 	ICCR = 1;
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
