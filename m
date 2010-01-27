Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654Ab0A0Tco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0A0Tco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614Ab0A0Tck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:32:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12510 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0A0Tcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:32:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5874"; a="32894956"
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
Subject: [PATCH 1/5] gic: prevent gic from crossing NR_IRQ
Date: Wed, 27 Jan 2010 11:32:25 -0800
Message-Id: <1264620749-24527-2-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

The gic code tries to initialize interrupts beyond NR_IRQ. Prevent
code from doing that.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@quicinc.com>
---
 arch/arm/common/gic.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 337741f..e763c4c 100644
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
@@ -233,7 +238,7 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 	/*
 	 * Setup the Linux IRQ subsystem.
 	 */
-	for (i = irq_start; i < gic_data[gic_nr].irq_offset + max_irq; i++) {
+	for (i = irq_start; i < NR_IRQS && i < gic_data[gic_nr].irq_offset + max_irq; i++) {
 		set_irq_chip(i, &gic_chip);
 		set_irq_chip_data(i, &gic_data[gic_nr]);
 		set_irq_handler(i, handle_level_irq);
-- 
1.5.6.3

