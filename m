Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZA1UlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZA1UlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZA1UaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:10 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32994 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZA1UaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:08 -0500
MBOX-Line: From nobody Tue Jan 27 19:12:57 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 04/10] OMAP3: move USBHOST SAR handling from clock framework
	to powerdomain layer
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
       linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:12:57 -0700
Message-ID: <20090128021254.7244.13579.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove usbhost_sar_fclk from the OMAP3 clock framework.  The bit that
the clock was tweaking doesn't actually enable or disable a clock; it
controls whether the hardware will save and restore USBHOST state
when the powerdomain changes state.  (That happens to coincidentally
enable a clock for the duration of the operation, hence the earlier
confusion.)

In place of the clock, mark the USBHOST powerdomain as supporting
hardware save-and-restore functionality.

linux-omap source commit is f3ceac86a9d425d101d606d87a5af44afef27179.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h        |   12 ------------
 arch/arm/mach-omap2/powerdomains34xx.h |    1 +
 2 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 877b274..23b909d 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -2216,17 +2216,6 @@ static struct clk usbhost_ick = {
 	.recalc		= &followparent_recalc,
 };
 
-static struct clk usbhost_sar_fck = {
-	.name		= "usbhost_sar_fck",
-	.parent		= &osc_sys_ck,
-	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_PRM_REGADDR(OMAP3430ES2_USBHOST_MOD, PM_PWSTCTRL),
-	.enable_bit	= OMAP3430ES2_SAVEANDRESTORE_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "usbhost_clkdm",
-	.recalc		= &followparent_recalc,
-};
-
 /* WKUP */
 
 static const struct clksel_rate usim_96m_rates[] = {
@@ -3174,7 +3163,6 @@ static struct clk *onchip_34xx_clks[] __initdata = {
 	&usbhost_120m_fck,
 	&usbhost_48m_fck,
 	&usbhost_ick,
-	&usbhost_sar_fck,
 	&usim_fck,
 	&gpt1_fck,
 	&wkup_32k_fck,
diff --git a/arch/arm/mach-omap2/powerdomains34xx.h b/arch/arm/mach-omap2/powerdomains34xx.h
index f573f71..3a8e4fb 100644
--- a/arch/arm/mach-omap2/powerdomains34xx.h
+++ b/arch/arm/mach-omap2/powerdomains34xx.h
@@ -312,6 +312,7 @@ static struct powerdomain usbhost_pwrdm = {
 	.sleepdep_srcs	  = dss_per_usbhost_sleepdeps,
 	.pwrsts		  = PWRSTS_OFF_RET_ON,
 	.pwrsts_logic_ret = PWRDM_POWER_RET,
+	.flags		  = PWRDM_HAS_HDWR_SAR, /* for USBHOST ctrlr only */
 	.banks		  = 1,
 	.pwrsts_mem_ret	  = {
 		[0] = PWRDM_POWER_RET, /* MEMRETSTATE */


