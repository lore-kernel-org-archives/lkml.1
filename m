Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZJBWi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZJBWi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZJBWi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:38:57 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62622 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZJBWi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:38:57 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/WfeA5EQ03vy3UiIr1KGR2
Subject: [PATCH 2/8] omap: Lock DPLL5 at boot
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rajendra Nayak <rnayak@ti.com>, Anand Gadiyar <gadiyar@ti.com>
Date: Fri, 02 Oct 2009 15:38:59 -0700
Message-ID: <20091002223859.11962.20369.stgit@localhost>
In-Reply-To: <20091002223510.11962.21751.stgit@localhost>
References: <20091002223510.11962.21751.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

Lock DPLL5 at 120MHz at boot. The USBHOST 120MHz f-clock and
USBTLL f-clock are the only users of this DPLL, and 120MHz is
is the only recommended rate for these clocks.

With this patch, the 60 MHz ULPI clock is generated correctly.

Tested on an OMAP3430 SDP.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index fafcd32..489556e 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -338,6 +338,13 @@ static struct omap_clk omap34xx_clks[] = {
  */
 #define SDRC_MPURATE_LOOPS		96
 
+/*
+ * DPLL5_FREQ_FOR_USBHOST: USBHOST and USBTLL are the only clocks
+ * that are sourced by DPLL5, and both of these require this clock
+ * to be at 120 MHz for proper operation.
+ */
+#define DPLL5_FREQ_FOR_USBHOST		120000000
+
 /**
  * omap3430es2_clk_ssi_find_idlest - return CM_IDLEST info for SSI
  * @clk: struct clk * being enabled
@@ -1056,6 +1063,28 @@ void omap2_clk_prepare_for_reboot(void)
 #endif
 }
 
+static void omap3_clk_lock_dpll5(void)
+{
+	struct clk *dpll5_clk;
+	struct clk *dpll5_m2_clk;
+
+	dpll5_clk = clk_get(NULL, "dpll5_ck");
+	clk_set_rate(dpll5_clk, DPLL5_FREQ_FOR_USBHOST);
+	clk_enable(dpll5_clk);
+
+	/* Enable autoidle to allow it to enter low power bypass */
+	omap3_dpll_allow_idle(dpll5_clk);
+
+	/* Program dpll5_m2_clk divider for no division */
+	dpll5_m2_clk = clk_get(NULL, "dpll5_m2_ck");
+	clk_enable(dpll5_m2_clk);
+	clk_set_rate(dpll5_m2_clk, DPLL5_FREQ_FOR_USBHOST);
+
+	clk_disable(dpll5_m2_clk);
+	clk_disable(dpll5_clk);
+	return;
+}
+
 /* REVISIT: Move this init stuff out into clock.c */
 
 /*
@@ -1148,6 +1177,12 @@ int __init omap2_clk_init(void)
 	 */
 	clk_enable_init_clocks();
 
+	/*
+	 * Lock DPLL5 and put it in autoidle.
+	 */
+	if (omap_rev() >= OMAP3430_REV_ES2_0)
+		omap3_clk_lock_dpll5();
+
 	/* Avoid sleeping during omap2_clk_prepare_for_reboot() */
 	/* REVISIT: not yet ready for 343x */
 #if 0

