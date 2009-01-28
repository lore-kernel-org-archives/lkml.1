Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbZA1Uzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbZA1Uzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZA1UdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:33:22 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47910 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbZA1UdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:33:19 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:38 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 10/13] OMAP3 clock: remove unnecessary dpll_data dereferences
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:08:38 -0700
Message-ID: <20090128190835.12092.41686.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some clutter from omap2_dpll_round_rate().

linux-omap source commit is 4625dceb8583c02a6d67ededc9f6a8347b6b8cb7.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index b517469..4c3d962 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -925,19 +925,22 @@ long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate)
 	int m, n, r, e, scaled_max_m;
 	unsigned long scaled_rt_rp, new_rate;
 	int min_e = -1, min_e_m = -1, min_e_n = -1;
+	struct dpll_data *dd;
 
 	if (!clk || !clk->dpll_data)
 		return ~0;
 
+	dd = clk->dpll_data;
+
 	pr_debug("clock: starting DPLL round_rate for clock %s, target rate "
 		 "%ld\n", clk->name, target_rate);
 
 	scaled_rt_rp = target_rate / (clk->parent->rate / DPLL_SCALE_FACTOR);
-	scaled_max_m = clk->dpll_data->max_multiplier * DPLL_SCALE_FACTOR;
+	scaled_max_m = dd->max_multiplier * DPLL_SCALE_FACTOR;
 
-	clk->dpll_data->last_rounded_rate = 0;
+	dd->last_rounded_rate = 0;
 
-	for (n = clk->dpll_data->max_divider; n >= DPLL_MIN_DIVIDER; n--) {
+	for (n = dd->max_divider; n >= DPLL_MIN_DIVIDER; n--) {
 
 		/* Compute the scaled DPLL multiplier, based on the divider */
 		m = scaled_rt_rp * n;
@@ -957,7 +960,7 @@ long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate)
 			 "(new_rate = %ld)\n", n, m, e, new_rate);
 
 		if (min_e == -1 ||
-		    min_e >= (int)(abs(e) - clk->dpll_data->rate_tolerance)) {
+		    min_e >= (int)(abs(e) - dd->rate_tolerance)) {
 			min_e = e;
 			min_e_m = m;
 			min_e_n = n;
@@ -980,17 +983,17 @@ long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate)
 		return ~0;
 	}
 
-	clk->dpll_data->last_rounded_m = min_e_m;
-	clk->dpll_data->last_rounded_n = min_e_n;
-	clk->dpll_data->last_rounded_rate =
-		_dpll_compute_new_rate(clk->parent->rate, min_e_m,  min_e_n);
+	dd->last_rounded_m = min_e_m;
+	dd->last_rounded_n = min_e_n;
+	dd->last_rounded_rate = _dpll_compute_new_rate(clk->parent->rate,
+						       min_e_m,  min_e_n);
 
 	pr_debug("clock: final least error: e = %d, m = %d, n = %d\n",
 		 min_e, min_e_m, min_e_n);
 	pr_debug("clock: final rate: %ld  (target rate: %ld)\n",
-		 clk->dpll_data->last_rounded_rate, target_rate);
+		 dd->last_rounded_rate, target_rate);
 
-	return clk->dpll_data->last_rounded_rate;
+	return dd->last_rounded_rate;
 }
 
 /*-------------------------------------------------------------------------


