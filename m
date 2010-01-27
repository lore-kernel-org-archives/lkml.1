Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723Ab0A0Tc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0A0Tc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332Ab0A0Tcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:32:42 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65043 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0A0Tch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:32:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5874"; a="32894959"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Yinghai Lu <yinghai@kernel.org>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Kalle Valo <kalle.valo@iki.fi>, Jean Pihet <jpihet@mvista.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Colin Tuckley <colin.tuckley@arm.com>,
       Philby John <pjohn@in.mvista.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Alessandro Rubini <rubini@unipv.it>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [PATCH 4/5] gic: dont disable INT in ack callback
Date: Wed, 27 Jan 2010 11:32:28 -0800
Message-Id: <1264620749-24527-5-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Unless gic_ack_irq is called from __do_IRQ, interrupt should not
be disabled in the ack function. Disabling the interrupt causes
handle_edge_irq to never enable it again.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/common/gic.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 709cf53..d47a1d7 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -67,25 +67,30 @@ static inline unsigned int gic_irq(unsigned int irq)
 
 /*
  * Routines to acknowledge, disable and enable interrupts
- *
- * Linux assumes that when we're done with an interrupt we need to
- * unmask it, in the same way we need to unmask an interrupt when
- * we first enable it.
- *
- * The GIC has a separate notion of "end of interrupt" to re-enable
- * an interrupt after handling, in order to support hardware
- * prioritisation.
- *
- * We can make the GIC behave in the way that Linux expects by making
- * our "acknowledge" routine disable the interrupt, then mark it as
- * complete.
  */
 static void gic_ack_irq(unsigned int irq)
 {
 	u32 mask = 1 << (irq % 32);
 
 	spin_lock(&irq_controller_lock);
+
+#ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
+
+	 /*
+	  * Linux assumes that when we're done with an interrupt we need to
+	  * unmask it, in the same way we need to unmask an interrupt when
+	  * we first enable it.
+	  *
+	  * The GIC has a separate notion of "end of interrupt" to re-enable
+	  * an interrupt after handling, in order to support hardware
+	  * prioritisation.
+	  *
+	  * We can make the GIC behave in the way that Linux expects by making
+	  * our "acknowledge" routine disable the interrupt, then mark it as
+	  * complete.
+	  */
 	writel(mask, gic_dist_base(irq) + GIC_DIST_ENABLE_CLEAR + (gic_irq(irq) / 32) * 4);
+#endif
 	writel(gic_irq(irq), gic_cpu_base(irq) + GIC_CPU_EOI);
 	spin_unlock(&irq_controller_lock);
 }
-- 
1.5.6.3

