Return-Path: <linux-kernel-owner+w=401wt.eu-S932314Ab0A2HGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0A2HGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856Ab0A2HG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:06:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0A2HG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:06:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5875"; a="33015130"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [PATCH v2 1/4] GIC: Disable unused interrupts
Date: Thu, 28 Jan 2010 23:06:01 -0800
Message-Id: <1264748764-5319-2-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1264748764-5319-1-git-send-email-adharmap@codeaurora.org>
References: <1264748764-5319-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Disable all interrupts of a gic in distributor initialization function.
This way interrupts beyond NR_IRQS stay disabled.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/common/gic.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 337741f..cd92ce0 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -175,6 +175,11 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 	set_irq_chained_handler(irq, gic_handle_cascade_irq);
 }
 
+/*
+ * In case of multiple cascaded GICs, order calls to gic_dist_init with
+ * ascending irq_start
+ */
+
 void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 			  unsigned int irq_start)
 {
@@ -200,11 +205,10 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 
 	/*
 	 * The GIC only supports up to 1020 interrupt sources.
-	 * Limit this to either the architected maximum, or the
-	 * platform maximum.
+	 * Limit this to either the architected maximum
 	 */
-	if (max_irq > max(1020, NR_IRQS))
-		max_irq = max(1020, NR_IRQS);
+	if (max_irq > 1020)
+		max_irq = 1020;
 
 	/*
 	 * Set all global interrupts to be level triggered, active low.
-- 
1.5.6.3

