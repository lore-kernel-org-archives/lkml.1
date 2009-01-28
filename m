Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbZA1Uw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbZA1Uw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbZA1Uci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:38 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47900 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbZA1Uce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:34 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:26 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 06/13] OMAP3 clock: DPLLs should enter bypass if new rate is
	sys_ck
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:08:26 -0700
Message-ID: <20090128190823.12092.2638.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch causes a DPLL to enter bypass when it is instructed to set
its rate to that of its bypass clock.  Previously this was only possible
after setting the DPLL rate, then disabling and re-enabling it.

linux-omap source commit is 9c909ac90902a9c0ecca2bc9ac36289cb84990f5.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.c |   40 ++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index c5efd7e..0f058c3 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -371,13 +371,17 @@ static int omap3_noncore_dpll_program(struct clk *clk, u16 m, u8 n, u16 freqsel)
  * @clk: struct clk * of DPLL to set
  * @rate: rounded target rate
  *
- * Program the DPLL with the rounded target rate.  Returns -EINVAL upon
- * error, or 0 upon success.
+ * Set the DPLL CLKOUT to the target rate.  If the DPLL can enter
+ * low-power bypass, and the target rate is the bypass source clock
+ * rate, then configure the DPLL for bypass.  Otherwise, round the
+ * target rate if it hasn't been done already, then program and lock
+ * the DPLL.  Returns -EINVAL upon error, or 0 upon success.
  */
 static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 {
 	u16 freqsel;
 	struct dpll_data *dd;
+	int ret;
 
 	if (!clk || !rate)
 		return -EINVAL;
@@ -389,18 +393,32 @@ static int omap3_noncore_dpll_set_rate(struct clk *clk, unsigned long rate)
 	if (rate == omap2_get_dpll_rate(clk))
 		return 0;
 
-	if (dd->last_rounded_rate != rate)
-		omap2_dpll_round_rate(clk, rate);
+	if (dd->bypass_clk->rate == rate &&
+	    (clk->dpll_data->modes & (1 << DPLL_LOW_POWER_BYPASS))) {
 
-	if (dd->last_rounded_rate == 0)
-		return -EINVAL;
+		pr_debug("clock: %s: set rate: entering bypass.\n", clk->name);
+
+		ret = _omap3_noncore_dpll_bypass(clk);
+
+	} else {
+
+		if (dd->last_rounded_rate != rate)
+			omap2_dpll_round_rate(clk, rate);
 
-	freqsel = _omap3_dpll_compute_freqsel(clk, dd->last_rounded_n);
-	if (!freqsel)
-		WARN_ON(1);
+		if (dd->last_rounded_rate == 0)
+			return -EINVAL;
 
-	omap3_noncore_dpll_program(clk, dd->last_rounded_m, dd->last_rounded_n,
-				   freqsel);
+		freqsel = _omap3_dpll_compute_freqsel(clk, dd->last_rounded_n);
+		if (!freqsel)
+			WARN_ON(1);
+
+		pr_debug("clock: %s: set rate: locking rate to %lu.\n",
+			 clk->name, rate);
+
+		ret = omap3_noncore_dpll_program(clk, dd->last_rounded_m,
+						 dd->last_rounded_n, freqsel);
+
+	}
 
 	omap3_dpll_recalc(clk);
 


