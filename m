Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802Ab0A0TdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0A0TdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331Ab0A0Tcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:32:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12510 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab0A0Tch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:32:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5874"; a="32894958"
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
Subject: [PATCH 3/5] gic: Add set_type callback
Date: Wed, 27 Jan 2010 11:32:27 -0800
Message-Id: <1264620749-24527-4-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Add gic_set_type callback to set an irq as level or edge triggered type

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/common/gic.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 00172c4..709cf53 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -165,6 +165,48 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 	chip->unmask(irq);
 }
 
+static int gic_set_type(unsigned int irq, unsigned int flow_type)
+{
+	unsigned int register_index;
+	unsigned int bit_index;
+	unsigned int reg_value;
+
+	if (irq > 1020)
+		return -1;
+
+	/*
+	* Two bits each, calc the register and bit, 16 per 32 bit register
+	* accessible long word only
+	* But the field is NxN 1xN and rising/falling
+	*/
+	register_index = (irq/16)<<2;
+	bit_index = (irq & 0xF)<<1;
+
+	spin_lock(&irq_controller_lock);
+	reg_value = readl(gic_dist_base(irq) + GIC_DIST_CONFIG +
+						register_index);
+	/*
+	* keep the nxn and 1xn , mask the edge level
+	* Edge is 1, level 0
+	*/
+	reg_value = (reg_value & ~(2<<bit_index));
+	if (flow_type & (IRQ_TYPE_EDGE_RISING|IRQ_TYPE_EDGE_FALLING)) {
+		reg_value |= (2<<bit_index);
+		writel(reg_value, gic_dist_base(irq) + GIC_DIST_CONFIG
+							+ register_index);
+		__set_irq_handler_unlocked(irq, handle_edge_irq);
+	}
+
+	if (flow_type & (IRQ_TYPE_LEVEL_HIGH|IRQ_TYPE_LEVEL_LOW)) {
+		writel(reg_value, gic_dist_base(irq) + GIC_DIST_CONFIG
+							+ register_index);
+		__set_irq_handler_unlocked(irq, handle_level_irq);
+	}
+
+	spin_unlock(&irq_controller_lock);
+	return 0;
+}
+
 static struct irq_chip gic_chip = {
 	.name		= "GIC",
 	.ack		= gic_ack_irq,
@@ -174,6 +216,7 @@ static struct irq_chip gic_chip = {
 #ifdef CONFIG_SMP
 	.set_affinity	= gic_set_cpu,
 #endif
+	.set_type	= gic_set_type,
 };
 
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
-- 
1.5.6.3

