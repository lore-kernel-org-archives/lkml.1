Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbZA1U5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbZA1U5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZA1UdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:33:25 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47916 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbZA1UdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:33:22 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:41 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 11/13] OMAP3 clock: optimize DPLL rate rounding algorithm
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Peter de Schrijver <peter.de-schrijver@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:08:41 -0700
Message-ID: <20090128190838.12092.58393.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous DPLL rate rounding algorithm counted the divider (N) down
from the maximum to 1.  Since we currently use a broad DPLL rate
tolerance, and lower N values are more power-efficient, we can often
bypass several iterations through the loop by counting N upwards from
1.

Peter de Schrijver <peter.de-schrijver@nokia.com> put up with several
test cycles of this patch - thanks Peter.

linux-omap source commit is 6f6d82bb2f80fa20a841ac3e95a6f44a5a156188.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Peter de Schrijver <peter.de-schrijver@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 4c3d962..cd13972 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -46,7 +46,7 @@
 #define DPLL_MIN_DIVIDER		1
 
 /* Possible error results from _dpll_test_mult */
-#define DPLL_MULT_UNDERFLOW		(1 << 0)
+#define DPLL_MULT_UNDERFLOW		-1
 
 /*
  * Scale factor to mitigate roundoff errors in DPLL rate rounding.
@@ -874,7 +874,7 @@ static int _dpll_test_mult(int *m, int n, unsigned long *new_rate,
 			   unsigned long target_rate,
 			   unsigned long parent_rate)
 {
-	int flags = 0, carry = 0;
+	int r = 0, carry = 0;
 
 	/* Unscale m and round if necessary */
 	if (*m % DPLL_SCALE_FACTOR >= DPLL_ROUNDING_VAL)
@@ -895,13 +895,13 @@ static int _dpll_test_mult(int *m, int n, unsigned long *new_rate,
 	if (*m < DPLL_MIN_MULTIPLIER) {
 		*m = DPLL_MIN_MULTIPLIER;
 		*new_rate = 0;
-		flags = DPLL_MULT_UNDERFLOW;
+		r = DPLL_MULT_UNDERFLOW;
 	}
 
 	if (*new_rate == 0)
 		*new_rate = _dpll_compute_new_rate(parent_rate, *m, n);
 
-	return flags;
+	return r;
 }
 
 /**
@@ -940,21 +940,27 @@ long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate)
 
 	dd->last_rounded_rate = 0;
 
-	for (n = dd->max_divider; n >= DPLL_MIN_DIVIDER; n--) {
+	for (n = DPLL_MIN_DIVIDER; n <= dd->max_divider; n++) {
 
 		/* Compute the scaled DPLL multiplier, based on the divider */
 		m = scaled_rt_rp * n;
 
 		/*
-		 * Since we're counting n down, a m overflow means we can
-		 * can immediately skip to the next n
+		 * Since we're counting n up, a m overflow means we
+		 * can bail out completely (since as n increases in
+		 * the next iteration, there's no way that m can
+		 * increase beyond the current m)
 		 */
 		if (m > scaled_max_m)
-			continue;
+			break;
 
 		r = _dpll_test_mult(&m, n, &new_rate, target_rate,
 				    clk->parent->rate);
 
+		/* m can't be set low enough for this n - try with a larger n */
+		if (r == DPLL_MULT_UNDERFLOW)
+			continue;
+
 		e = target_rate - new_rate;
 		pr_debug("clock: n = %d: m = %d: rate error is %d "
 			 "(new_rate = %ld)\n", n, m, e, new_rate);
@@ -966,16 +972,11 @@ long omap2_dpll_round_rate(struct clk *clk, unsigned long target_rate)
 			min_e_n = n;
 
 			pr_debug("clock: found new least error %d\n", min_e);
-		}
 
-		/*
-		 * Since we're counting n down, a m underflow means we
-		 * can bail out completely (since as n decreases in
-		 * the next iteration, there's no way that m can
-		 * increase beyond the current m)
-		 */
-		if (r & DPLL_MULT_UNDERFLOW)
-			break;
+			/* We found good settings -- bail out now */
+			if (min_e <= clk->dpll_data->rate_tolerance)
+				break;
+		}
 	}
 
 	if (min_e < 0) {


