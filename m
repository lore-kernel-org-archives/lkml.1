Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbXFALI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbXFALI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbXFALIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:08:48 -0400
Received: from rex.snapgear.com ([203.143.235.140]:43135 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750719AbXFALIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:08:47 -0400
Date: Fri, 1 Jun 2007 21:07:31 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200706011107.l51B7VQl023531@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: fix ColdFire timer off by 1
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The coldfire timer runs from 0 to TRR included, then 0 again and so on.
It counts thus actually TRR + 1 steps for 1 tick, not TRR.  Fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.21/arch/m68knommu/platform/5307/timers.c linux-2.6.21-uc0/arch/m68knommu/platform/5307/timers.c
--- linux-2.6.21/arch/m68knommu/platform/5307/timers.c	2007-05-01 17:12:41.000000000 +1000
+++ linux-2.6.21-uc0/arch/m68knommu/platform/5307/timers.c	2007-05-01 17:16:11.000000000 +1000
@@ -62,10 +62,13 @@
 
 /***************************************************************************/
 
+static int ticks_per_intr;
+
 void coldfire_timer_init(irq_handler_t handler)
 {
 	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
-	__raw_writetrr(((MCF_BUSCLK / 16) / HZ), TA(MCFTIMER_TRR));
+	ticks_per_intr = (MCF_BUSCLK / 16) / HZ;
+	__raw_writetrr(ticks_per_intr - 1, TA(MCFTIMER_TRR));
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
 
@@ -81,11 +84,10 @@
 
 unsigned long coldfire_timer_offset(void)
 {
-	unsigned long trr, tcn, offset;
+	unsigned long tcn, offset;
 
 	tcn = __raw_readw(TA(MCFTIMER_TCN));
-	trr = __raw_readtrr(TA(MCFTIMER_TRR));
-	offset = (tcn * (1000000 / HZ)) / trr;
+	offset = ((tcn + 1) * (1000000 / HZ)) / ticks_per_intr;
 
 	/* Check if we just wrapped the counters and maybe missed a tick */
 	if ((offset < (1000000 / HZ / 2)) && mcf_timerirqpending(1))
