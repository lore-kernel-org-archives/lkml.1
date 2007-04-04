Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbXDDRzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbXDDRzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXDDRzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:55:06 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:36057 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXDDRzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:55:05 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5/90] ARM: OMAP: Add function to print clock usecounts
Date: Wed,  4 Apr 2007 13:46:32 -0400
Message-Id: <11757088883638-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1175708886798-git-send-email-tony@atomide.com>
References: omap-2007-04-04-133556 <11757088774110-git-send-email-tony@atomide.com> <11757088791107-git-send-email-tony@atomide.com> <11757088822930-git-send-email-tony@atomide.com> <11757088844012-git-send-email-tony@atomide.com> <1175708886798-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Useful for debugging power management code.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/clock.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index f1179ad..3d017b0 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -33,6 +33,41 @@ static DEFINE_SPINLOCK(clockfw_lock);
 
 static struct clk_functions *arch_clock;
 
+#ifdef CONFIG_PM_DEBUG
+
+static void print_parents(struct clk *clk)
+{
+	struct clk *p;
+	int printed = 0;
+
+	list_for_each_entry(p, &clocks, node) {
+		if (p->parent == clk && p->usecount) {
+			if (!clk->usecount && !printed) {
+				printk("MISMATCH: %s\n", clk->name);
+				printed = 1;
+			}
+			printk("\t%-15s\n", p->name);
+		}
+	}
+}
+
+void clk_print_usecounts(void)
+{
+	unsigned long flags;
+	struct clk *p;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	list_for_each_entry(p, &clocks, node) {
+		if (p->usecount)
+			printk("%-15s: %d\n", p->name, p->usecount);
+		print_parents(p);
+
+	}
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+}
+
+#endif
+
 /*-------------------------------------------------------------------------
  * Standard clock functions defined in include/linux/clk.h
  *-------------------------------------------------------------------------*/
-- 
1.4.4.2

