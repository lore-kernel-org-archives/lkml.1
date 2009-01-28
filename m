Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbZA1UrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbZA1UrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZA1Ubu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:31:50 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47764 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbZA1Ubs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:31:48 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:11 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 01/13] OMAP3 clock: fix DPLL jitter correction and rate
	programming
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:08:11 -0700
Message-ID: <20090128190805.12092.73106.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix DPLL jitter correction programming.  Previously,
omap3_noncore_dpll_program() stored the FREQSEL jitter correction
parameter to the wrong register.  This caused jitter correction to be set
incorrectly and also caused the DPLL divider to be programmed incorrectly.

Also, fix DPLL divider programming.  An off-by-one error existed in
omap3_noncore_dpll_program(), causing DPLLs to be programmed with a higher
divider than intended.

linux-omap source commit is 5c0ec88a2145cdf2f2c9cc5fae49635c4c2476c7.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index b6fe2c9..ff43058 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -346,14 +346,17 @@ static int omap3_noncore_dpll_program(struct clk *clk, u16 m, u8 n, u16 freqsel)
 	/* 3430 ES2 TRM: 4.7.6.9 DPLL Programming Sequence */
 	_omap3_noncore_dpll_bypass(clk);
 
+	/* Set jitter correction */
+	v = __raw_readl(dd->control_reg);
+	v &= ~dd->freqsel_mask;
+	v |= freqsel << __ffs(dd->freqsel_mask);
+	__raw_writel(v, dd->control_reg);
+
+	/* Set DPLL multiplier, divider */
 	v = __raw_readl(dd->mult_div1_reg);
 	v &= ~(dd->mult_mask | dd->div1_mask);
-
-	/* Set mult (M), div1 (N), freqsel */
 	v |= m << __ffs(dd->mult_mask);
-	v |= n << __ffs(dd->div1_mask);
-	v |= freqsel << __ffs(dd->freqsel_mask);
-
+	v |= (n - 1) << __ffs(dd->div1_mask);
 	__raw_writel(v, dd->mult_div1_reg);
 
 	/* We let the clock framework set the other output dividers later */


