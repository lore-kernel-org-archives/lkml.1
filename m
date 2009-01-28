Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbZA1Uts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbZA1Uts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbZA1UcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:22 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47838 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbZA1UcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:19 -0500
MBOX-Line: From nobody Wed Jan 28 12:35:15 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH F 06/12] OMAP2/3 clock: every clock must have a clkdm
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:35:15 -0700
Message-ID: <20090128193512.2396.75340.stgit@localhost.localdomain>
In-Reply-To: <20090128193326.2396.9437.stgit@localhost.localdomain>
References: <20090128193326.2396.9437.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every OMAP2/3 clock must now have an assigned clockdomain, so we can
remove the checks from clk_enable()/clk_disable().  Instead, verify
that the clockdomain is present only at clock init time via the
arch_clock clk_register() hook.

linux-omap source commit is 60b8b431e47d8c5b8c02a2e4fa9af388aae20790.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index c93a5aa..600b2f4 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -199,11 +199,6 @@ void omap2_init_clk_clkdm(struct clk *clk)
 {
 	struct clockdomain *clkdm;
 
-	if (!clk->clkdm.name) {
-		pr_err("clock: %s: missing clockdomain", clk->name);
-		return;
-	}
-
 	clkdm = clkdm_lookup(clk->clkdm.name);
 	if (clkdm) {
 		pr_debug("clock: associated clk %s to clkdm %s\n",
@@ -479,8 +474,7 @@ void omap2_clk_disable(struct clk *clk)
 		_omap2_clk_disable(clk);
 		if (clk->parent)
 			omap2_clk_disable(clk->parent);
-		if (clk->clkdm.ptr)
-			omap2_clkdm_clk_disable(clk->clkdm.ptr, clk);
+		omap2_clkdm_clk_disable(clk->clkdm.ptr, clk);
 
 	}
 }
@@ -498,14 +492,12 @@ int omap2_clk_enable(struct clk *clk)
 			return ret;
 		}
 
-		if (clk->clkdm.ptr)
-			omap2_clkdm_clk_enable(clk->clkdm.ptr, clk);
+		omap2_clkdm_clk_enable(clk->clkdm.ptr, clk);
 
 		ret = _omap2_clk_enable(clk);
 
 		if (ret != 0) {
-			if (clk->clkdm.ptr)
-				omap2_clkdm_clk_disable(clk->clkdm.ptr, clk);
+			omap2_clkdm_clk_disable(clk->clkdm.ptr, clk);
 
 			if (clk->parent) {
 				omap2_clk_disable(clk->parent);
@@ -1090,6 +1082,12 @@ void omap2_clk_disable_unused(struct clk *clk)
 
 int omap2_clk_register(struct clk *clk)
 {
+	if (!clk->clkdm.name) {
+		pr_debug("clock: %s: missing clockdomain", clk->name);
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	omap2_init_clk_clkdm(clk);
 	return 0;
 }


