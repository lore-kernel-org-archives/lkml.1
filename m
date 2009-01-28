Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZA1Uhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZA1Uhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZA1U3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:31 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32917 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZA1U30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:26 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:45 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 06/14] PM: OMAP3: Make sure clk_disable_unused() order is
	correct
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Tero Kristo <tero.kristo@nokia.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Date: Wed, 28 Jan 2009 12:27:45 -0700
Message-ID: <20090128192742.29333.70826.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tero Kristo <tero.kristo@nokia.com>

Current implementation will disable clocks in the order defined in clock34xx.h,
at least DPLL4_M2X2 will hang in certain cases (and prevent retention / off)
if clocks are not disabled in correct order. This patch makes sure the parent
clocks will be active when disabling a clock.

linux-omap source commit is 672680063420ef8c8c4e7271984bb9cc08171d29.

Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 arch/arm/mach-omap2/clock.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 9c62ada..d4d2e7b 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -1078,6 +1078,10 @@ void omap2_clk_disable_unused(struct clk *clk)
 		return;
 
 	printk(KERN_INFO "Disabling unused clock \"%s\"\n", clk->name);
-	_omap2_clk_disable(clk);
+	if (cpu_is_omap34xx()) {
+		omap2_clk_enable(clk);
+		omap2_clk_disable(clk);
+	} else
+		_omap2_clk_disable(clk);
 }
 #endif


