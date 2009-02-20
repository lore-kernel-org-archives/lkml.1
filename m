Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZBTXRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZBTXRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZBTXRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:17:13 -0500
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:7364 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753100AbZBTXRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:17:12 -0500
X-BigFish: VPS5(z34a4jzzzzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KFE0O0-01-K3F-01
Date: Sat, 21 Feb 2009 00:16:35 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Mark Hounschell <markh@compro.net>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/3] x86: hpet: stop HPET_COUNTER when programming periodic
	mode
Message-ID: <20090220231635.GK6298@alberich.amd.com>
References: <20090220230729.GK4834@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090220230729.GK4834@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 23:16:56.0716 (UTC) FILETIME=[52F6A4C0:01C993B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix system hang on some systems operating with HZ_1000

On a system that stalled with HZ_1000, the first value written to
T0_CMP (when the main counter was not stopped) did not trigger an
interrupt. Instead after the main counter wrapped around (after
several minutes) an interrupt was triggered and afterwards the
periodic interrupt took effect.

This can be fixed by implementing HPET spec recommendation for
programming the periodic mode (i.e. stopping the main counter).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/hpet.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 20acc6a..46be008 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -309,29 +309,22 @@ static int hpet_setup_msi_irq(unsigned int irq);
 static void hpet_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt, int timer)
 {
-	unsigned long cfg, cmp, now;
+	unsigned long cfg;
 	uint64_t delta;
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
+		hpet_stop_counter();
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
 		delta >>= evt->shift;
-		now = hpet_readl(HPET_COUNTER);
-		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		/* Make sure we use edge triggered interrupts */
 		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
-		/*
-		 * The first write after writing TN_SETVAL to the
-		 * config register sets the counter value, the second
-		 * write sets the period.
-		 */
-		hpet_writel(cmp, HPET_Tn_CMP(timer));
-		udelay(1);
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_start_counter();
 		hpet_print_config();
 		break;
 
-- 
1.6.1.3



