Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbZA1Uxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbZA1Uxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbZA1Ucl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:41 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47810 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbZA1UcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:13 -0500
MBOX-Line: From nobody Wed Jan 28 12:35:09 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH F 04/12] OMAP clock: drop clk_get_usecount()
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:35:09 -0700
Message-ID: <20090128193506.2396.29611.stgit@localhost.localdomain>
In-Reply-To: <20090128193326.2396.9437.stgit@localhost.localdomain>
References: <20090128193326.2396.9437.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is race-prone and mistakenly conveys the impression to
drivers that it is part of the clock interface.  Get rid of it: core
code that absolutely needs this can just check clk->usecount.  Drivers
should not use it at all.

linux-omap source commit is 5df9e4adc2f6a6d55aca53ee27b8baad18897c05.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/clock.c              |   16 ----------------
 arch/arm/plat-omap/include/mach/clock.h |    1 -
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 2a4819f..f4a89c5 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -260,22 +260,6 @@ out:
 }
 EXPORT_SYMBOL(clk_disable);
 
-int clk_get_usecount(struct clk *clk)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	if (clk == NULL || IS_ERR(clk))
-		return 0;
-
-	spin_lock_irqsave(&clockfw_lock, flags);
-	ret = clk->usecount;
-	spin_unlock_irqrestore(&clockfw_lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(clk_get_usecount);
-
 unsigned long clk_get_rate(struct clk *clk)
 {
 	unsigned long flags;
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 9d38a25..2a30268 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -142,7 +142,6 @@ extern void followparent_recalc(struct clk *clk, unsigned long parent_rate,
 				u8 rate_storage);
 extern void clk_allow_idle(struct clk *clk);
 extern void clk_deny_idle(struct clk *clk);
-extern int clk_get_usecount(struct clk *clk);
 extern void clk_enable_init_clocks(void);
 #ifdef CONFIG_CPU_FREQ
 extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);


