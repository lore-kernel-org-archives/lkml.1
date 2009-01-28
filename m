Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZA1UzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZA1UzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZA1UdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:33:21 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47908 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbZA1UdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:33:19 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:32 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 08/13] OMAP3 clock: put DPLL into bypass if bypass rate =
	clk->rate, not hardware rate
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>, Tero Kristo <tero.kristo@nokia.com>
Date: Wed, 28 Jan 2009 12:08:32 -0700
Message-ID: <20090128190829.12092.86115.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a non-CORE DPLL is enabled via omap3_noncore_dpll_enable(), use
the user's desired rate in clk->rate to determine whether to put the
DPLL into bypass or lock mode, rather than reading the DPLL's current
idle state from its hardware registers.

This fixes a bug observed when leaving retention. Non-CORE DPLLs were
not being relocked when downstream clocks re-enabled; rather, the DPLL
entered bypass mode.

Problem reported by Tero Kristo <tero.kristo@nokia.com>.

linux-omap source commit is 8b1f0bd44fe490ec631230c8c040753a2bda8caa.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tero Kristo <tero.kristo@nokia.com>
---
 arch/arm/mach-omap2/clock34xx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 844fe82..424eed6 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -280,9 +280,7 @@ static int omap3_noncore_dpll_enable(struct clk *clk)
 	if (!dd)
 		return -EINVAL;
 
-	rate = omap2_get_dpll_rate(clk);
-
-	if (dd->bypass_clk->rate == rate)
+	if (clk->rate == dd->bypass_clk->rate)
 		r = _omap3_noncore_dpll_bypass(clk);
 	else
 		r = _omap3_noncore_dpll_lock(clk);


