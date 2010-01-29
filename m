Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728Ab0A2HHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab0A2HHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 02:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381Ab0A2HHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 02:07:52 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab0A2HG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 02:06:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5875"; a="33015132"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [PATCH v2 3/4] GIC: Add callback for mask_ack
Date: Thu, 28 Jan 2010 23:06:03 -0800
Message-Id: <1264748764-5319-4-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1264748764-5319-1-git-send-email-adharmap@codeaurora.org>
References: <1264748764-5319-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Add gic_mask_ack for faster processing of interrupts.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/common/gic.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 8a2bfae..240f6b6 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -108,6 +108,15 @@ static void gic_unmask_irq(unsigned int irq)
 	spin_unlock(&irq_controller_lock);
 }
 
+static void gic_mask_ack_irq(unsigned int irq)
+{
+	u32 mask = 1 << (irq % 32);
+	spin_lock(&irq_controller_lock);
+	writel(mask, gic_dist_base(irq) + GIC_DIST_ENABLE_CLEAR + (gic_irq(irq) / 32) * 4);
+	writel(gic_irq(irq), gic_cpu_base(irq) + GIC_CPU_EOI);
+	spin_unlock(&irq_controller_lock);
+}
+
 #ifdef CONFIG_SMP
 static int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 {
@@ -160,6 +169,7 @@ static struct irq_chip gic_chip = {
 	.name		= "GIC",
 	.ack		= gic_ack_irq,
 	.mask		= gic_mask_irq,
+	.mask_ack	= gic_mask_ack_irq,
 	.unmask		= gic_unmask_irq,
 #ifdef CONFIG_SMP
 	.set_affinity	= gic_set_cpu,
-- 
1.5.6.3

