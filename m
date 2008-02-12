Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbYBLGTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbYBLGTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYBLGTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:19:03 -0500
Received: from rex.snapgear.com ([203.143.235.140]:50303 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753958AbYBLGTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:19:01 -0500
Date: Tue, 12 Feb 2008 16:16:06 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802120616.m1C6G6rw009982@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix profile timer
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Waddel <Matt.Waddel@freescale.com>

I was looking at timers in the Coldfire system and I
noticed that the CONFIG_HIGHPROFILE option seems to
be a little out of date.

This patch gets it compiling and running on a 2.6.23
uClinux kernel.  Please apply if you think it's OK.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc1/arch/m68knommu/platform/coldfire/timers.c linux-2.6.x/arch/m68knommu/platform/coldfire/timers.c
--- linux-2.6.25-rc1/arch/m68knommu/platform/coldfire/timers.c	2008-02-11 14:50:21.000000000 +1000
+++ linux-2.6.x/arch/m68knommu/platform/coldfire/timers.c	2008-02-12 14:05:13.000000000 +1000
@@ -148,25 +148,32 @@ irqreturn_t coldfire_profile_tick(int ir
 	/* Reset ColdFire timer2 */
 	__raw_writeb(MCFTIMER_TER_CAP | MCFTIMER_TER_REF, PA(MCFTIMER_TER));
 	if (current->pid)
-		profile_tick(CPU_PROFILING, regs);
+		profile_tick(CPU_PROFILING);
 	return IRQ_HANDLED;
 }
 
 /***************************************************************************/
 
+static struct irqaction coldfire_profile_irq = {
+	.name	 = "profile timer",
+	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.handler = coldfire_profile_tick,
+};
+
 void coldfire_profile_init(void)
 {
-	printk(KERN_INFO "PROFILE: lodging TIMER2 @ %dHz as profile timer\n", PROFILEHZ);
+	printk(KERN_INFO "PROFILE: lodging TIMER2 @ %dHz as profile timer\n", 
+	       PROFILEHZ);
+
+	setup_irq(mcf_profilevector, &coldfire_profile_irq);
 
 	/* Set up TIMER 2 as high speed profile clock */
 	__raw_writew(MCFTIMER_TMR_DISABLE, PA(MCFTIMER_TMR));
 
-	__raw_writetrr(((MCF_CLK / 16) / PROFILEHZ), PA(MCFTIMER_TRR));
+	__raw_writetrr(((MCF_BUSCLK / 16) / PROFILEHZ), PA(MCFTIMER_TRR));
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, PA(MCFTIMER_TMR));
 
-	request_irq(mcf_profilevector, coldfire_profile_tick,
-		(IRQF_DISABLED | IRQ_FLG_FAST), "profile timer", NULL);
 	mcf_settimericr(2, 7);
 }
 
