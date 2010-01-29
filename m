Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714Ab0A2HHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0A2HHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893Ab0A2HHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:07:21 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21370 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab0A2HG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:06:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5875"; a="33015133"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [PATCH v2 4/4] GIC: Dont disable INT in ack callback
Date: Thu, 28 Jan 2010 23:06:04 -0800
Message-Id: <1264748764-5319-5-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1264748764-5319-1-git-send-email-adharmap@codeaurora.org>
References: <1264748764-5319-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Unless gic_ack_irq is called from __do_IRQ, interrupt should not
be disabled in the ack function. Disabling the interrupt causes
handle_edge_irq to never enable it again.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/common/gic.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 240f6b6..f44167c 100644
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
-	u32 mask = 1 << (irq % 32);
 
 	spin_lock(&irq_controller_lock);
+
+#ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
+	u32 mask = 1 << (irq % 32);
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

