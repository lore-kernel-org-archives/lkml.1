Return-Path: <linux-kernel-owner+w=401wt.eu-S965918AbXDIVXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965918AbXDIVXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965913AbXDIVXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:23:01 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26317 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965661AbXDIVWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:22:45 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 2/18] ARM: OMAP: Add function to print clock usecounts
Date: Mon,  9 Apr 2007 17:22:07 -0400
Message-Id: <11761537491968-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <117615374683-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Useful for debugging power management code.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/clock.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

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

