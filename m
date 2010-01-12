Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865Ab0ALG6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0ALG6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180Ab0ALG6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:58:45 -0500
Received: from ozlabs.org ([203.10.76.45]:45445 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab0ALG6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:58:44 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,PATCH 7/7 v2] arm/icst307: remove icst307_ps_to_vco
Message-Id: <1263279511.162732.415109166708.7.gpush@pororo>
In-Reply-To: <1263279511.160127.576969496193.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Tue, 12 Jan 2010 17:58:31 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

icst307_ps_to_vco isn't used, so remove it.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 arch/arm/common/icst307.c |   62 --------------------------------------
 1 file changed, 62 deletions(-)

diff --git a/arch/arm/common/icst307.c b/arch/arm/common/icst307.c
index cd45b88..9d8d087 100644
--- a/arch/arm/common/icst307.c
+++ b/arch/arm/common/icst307.c
@@ -96,68 +96,6 @@ icst307_khz_to_vco(const struct icst307_params *p, unsigned long freq)
 	return vco;
 }
 
-static struct icst307_vco
-icst307_ps_to_vco(const struct icst307_params *p, unsigned long period)
-{
-	struct icst307_vco vco = { .s = 1, .v = p->vd_max, .r = p->rd_max };
-	unsigned long f, ps;
-	unsigned int i = 0, rd, best = (unsigned int)-1;
-
-	ps = 1000000000UL / p->vco_max;
-
-	/*
-	 * First, find the PLL output divisor such
-	 * that the PLL output is within spec.
-	 */
-	do {
-		f = period / s2div[idx2s[i]];
-
-		/*
-		 * f must be between 6MHz and 200MHz (3.3 or 5V)
-		 */
-		if (f >= ps && f < 1000000000UL / 6000 + 1)
-			break;
-	} while (i < ARRAY_SIZE(idx2s));
-
-	if (i >= ARRAY_SIZE(idx2s))
-		return vco;
-
-	vco.s = idx2s[i];
-
-	ps = 500000000UL / p->ref;
-
-	/*
-	 * Now find the closest divisor combination
-	 * which gives a PLL output of 'f'.
-	 */
-	for (rd = p->rd_min; rd <= p->rd_max; rd++) {
-		unsigned long f_in_div, f_pll;
-		unsigned int vd;
-		int f_diff;
-
-		f_in_div = ps * rd;
-
-		vd = (f_in_div + f / 2) / f;
-		if (vd < p->vd_min || vd > p->vd_max)
-			continue;
-
-		f_pll = (f_in_div + vd / 2) / vd;
-		f_diff = f_pll - f;
-		if (f_diff < 0)
-			f_diff = -f_diff;
-
-		if ((unsigned)f_diff < best) {
-			vco.v = vd - 8;
-			vco.r = rd - 2;
-			if (f_diff == 0)
-				break;
-			best = f_diff;
-		}
-	}
-
-	return vco;
-}
-
 static unsigned long clk_icst307_get_rate(struct clk *clk)
 {
 	return to_clk_icst307(clk)->rate;
