Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZA1UbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZA1UbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbZA1U2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:28:00 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:60961 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZA1U1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:27:35 -0500
MBOX-Line: From nobody Wed Jan 28 12:18:41 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH D 09/11] OMAP2/3 clock: encode target IDLEST bits
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>
Date: Wed, 28 Jan 2009 12:18:41 -0700
Message-ID: <20090128191838.16688.71653.stgit@localhost.localdomain>
In-Reply-To: <20090128191638.16688.33452.stgit@localhost.localdomain>
References: <20090128191638.16688.33452.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each OMAP module that has a target IDLEST bit, add the appropriate
bits to the clock tree on both the module interface clock and the appropriate
functional clock.  Add a new clock bit, "WAIT_READY", that indicates that
the clock code must wait for the clock's module to come out of idle after
both the target functional clock and interface clocks are enabled.  Fix
some clock flag comments while there to indicate that clocks marked
as "3430ES2" clocks also are valid for later 3430 revisions.

Several OMAP3xxx clocks must be split into platform-specific variants,
since some early silicon revisions do not have target idle state bits
available. DSS, HSOTGUSB, and SSI clocks are affected.  In the future, it
would be ideal to #ifdef out those clocks for kernels that don't need to
run on 3430ES1 chips to save memory.

This patch also includes a later fix for a bug that caused the clock
code to not wait for the DSS to come out of idle.  Reported by Rajendra
Nayak <rnayak@ti.com>.

linux-omap source commits are e9ea612457bbf244d1a6fc38b08453d5a4ec7bf6,
a63efb1547ac35dcb0f007090396a3c7510eb691, and part of
9fe6b6cf8d9e0cbb429fd64553a4b3160a9e99e1.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Rajendra Nayak <rnayak@ti.com>
---
 arch/arm/mach-omap2/clock24xx.h         |  194 +++++++++----
 arch/arm/mach-omap2/clock34xx.h         |  447 ++++++++++++++++++++++---------
 arch/arm/mach-omap2/cm-regbits-24xx.h   |    1 
 arch/arm/plat-omap/include/mach/clock.h |    8 -
 4 files changed, 453 insertions(+), 197 deletions(-)

diff --git a/arch/arm/mach-omap2/clock24xx.h b/arch/arm/mach-omap2/clock24xx.h
index 178f46d..929a257 100644
--- a/arch/arm/mach-omap2/clock24xx.h
+++ b/arch/arm/mach-omap2/clock24xx.h
@@ -1233,10 +1233,11 @@ static struct clk usb_l4_ick = {	/* FS-USB interface clock */
 	.parent		= &core_l3_ck,
 	.prcm_mod	= CORE_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				DELAYED_APP | CONFIG_PARTICIPANT,
+				DELAYED_APP | CONFIG_PARTICIPANT | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_USB_SHIFT,
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_USB_MASK,
 	.clksel		= usb_l4_ick_clksel,
@@ -1306,11 +1307,12 @@ static struct clk ssi_ssr_sst_fck = {
 	.name		= "ssi_fck",
 	.parent		= &core_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY |
 				DELAYED_APP,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_SSI_SHIFT,
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP24XX_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_sst_fck_clksel,
@@ -1328,9 +1330,10 @@ static struct clk ssi_l4_ick = {
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP24XX_EN_SSI_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_SSI_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1573,10 +1576,11 @@ static struct clk gpt1_ick = {
 	.name		= "gpt1_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= WKUP_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_GPT1_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1601,10 +1605,11 @@ static struct clk gpt2_ick = {
 	.name		= "gpt2_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT2_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1627,10 +1632,11 @@ static struct clk gpt3_ick = {
 	.name		= "gpt3_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT3_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1653,10 +1659,11 @@ static struct clk gpt4_ick = {
 	.name		= "gpt4_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT4_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1679,10 +1686,11 @@ static struct clk gpt5_ick = {
 	.name		= "gpt5_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT5_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1705,10 +1713,11 @@ static struct clk gpt6_ick = {
 	.name		= "gpt6_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT6_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT6_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1731,10 +1740,11 @@ static struct clk gpt7_ick = {
 	.name		= "gpt7_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT7_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT7_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1757,10 +1767,11 @@ static struct clk gpt8_ick = {
 	.name		= "gpt8_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT8_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT8_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1783,10 +1794,11 @@ static struct clk gpt9_ick = {
 	.name		= "gpt9_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT9_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT9_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1809,10 +1821,11 @@ static struct clk gpt10_ick = {
 	.name		= "gpt10_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT10_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT10_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1835,10 +1848,11 @@ static struct clk gpt11_ick = {
 	.name		= "gpt11_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT11_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT11_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1861,10 +1875,11 @@ static struct clk gpt12_ick = {
 	.name		= "gpt12_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_GPT12_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPT12_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1888,10 +1903,11 @@ static struct clk mcbsp1_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCBSP1_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MCBSP1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1912,10 +1928,11 @@ static struct clk mcbsp2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCBSP2_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MCBSP2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1936,10 +1953,11 @@ static struct clk mcbsp3_ick = {
 	.id		= 3,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP3_SHIFT,
+	.idlest_bit	= OMAP2430_ST_MCBSP3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1960,10 +1978,11 @@ static struct clk mcbsp4_ick = {
 	.id		= 4,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP4_SHIFT,
+	.idlest_bit	= OMAP2430_ST_MCBSP4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -1984,10 +2003,11 @@ static struct clk mcbsp5_ick = {
 	.id		= 5,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MCBSP5_SHIFT,
+	.idlest_bit	= OMAP2430_ST_MCBSP5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2009,9 +2029,10 @@ static struct clk mcspi1_ick = {
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
 	.clkdm		= { .name = "core_l4_clkdm" },
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCSPI1_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MCSPI1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2032,10 +2053,11 @@ static struct clk mcspi2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MCSPI2_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MCSPI2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2056,10 +2078,11 @@ static struct clk mcspi3_ick = {
 	.id		= 3,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MCSPI3_SHIFT,
+	.idlest_bit	= OMAP2430_ST_MCSPI3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2079,10 +2102,11 @@ static struct clk uart1_ick = {
 	.name		= "uart1_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_UART1_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_UART1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2101,10 +2125,11 @@ static struct clk uart2_ick = {
 	.name		= "uart2_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_UART2_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_UART2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2123,10 +2148,11 @@ static struct clk uart3_ick = {
 	.name		= "uart3_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP24XX_EN_UART3_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_UART3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2145,10 +2171,11 @@ static struct clk gpios_ick = {
 	.name		= "gpios_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= WKUP_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2156,10 +2183,11 @@ static struct clk gpios_fck = {
 	.name		= "gpios_fck",
 	.parent		= &func_32k_ck,
 	.prcm_mod	= WKUP_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_EN_GPIOS_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_GPIOS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2168,10 +2196,11 @@ static struct clk mpu_wdt_ick = {
 	.name		= "mpu_wdt_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= WKUP_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2180,10 +2209,11 @@ static struct clk mpu_wdt_fck = {
 	.name		= "mpu_wdt_fck",
 	.parent		= &func_32k_ck,
 	.prcm_mod	= WKUP_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP24XX_EN_MPU_WDT_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MPU_WDT_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2192,10 +2222,11 @@ static struct clk sync_32k_ick = {
 	.parent		= &l4_ck,
 	.prcm_mod	= WKUP_MOD,
 	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X |
-				ENABLE_ON_INIT,
+				ENABLE_ON_INIT | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_32KSYNC_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_32KSYNC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2208,6 +2239,7 @@ static struct clk wdt1_ick = {
 	.clkdm		= { .name = "prm_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_WDT1_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_WDT1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2220,6 +2252,7 @@ static struct clk omapctrl_ick = {
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP24XX_EN_OMAPCTRL_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_OMAPCTRL_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2227,10 +2260,11 @@ static struct clk icr_ick = {
 	.name		= "icr_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= WKUP_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP2430_EN_ICR_SHIFT,
+	.idlest_bit	= OMAP2430_ST_ICR_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2265,10 +2299,11 @@ static struct clk mailboxes_ick = {
 	.name		= "mailboxes_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MAILBOXES_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MAILBOXES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2276,10 +2311,11 @@ static struct clk wdt4_ick = {
 	.name		= "wdt4_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_WDT4_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_WDT4_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2298,10 +2334,11 @@ static struct clk wdt3_ick = {
 	.name		= "wdt3_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
+	.idlest_bit	= OMAP2420_ST_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2309,10 +2346,11 @@ static struct clk wdt3_fck = {
 	.name		= "wdt3_fck",
 	.parent		= &func_32k_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_WDT3_SHIFT,
+	.enable_bit	= OMAP2420_ST_WDT3_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2320,10 +2358,11 @@ static struct clk mspro_ick = {
 	.name		= "mspro_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2331,10 +2370,11 @@ static struct clk mspro_fck = {
 	.name		= "mspro_fck",
 	.parent		= &func_96m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_MSPRO_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_MSPRO_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2342,10 +2382,11 @@ static struct clk mmc_ick = {
 	.name		= "mmc_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
+	.idlest_bit	= OMAP2420_ST_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2353,10 +2394,11 @@ static struct clk mmc_fck = {
 	.name		= "mmc_fck",
 	.parent		= &func_96m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_MMC_SHIFT,
+	.idlest_bit	= OMAP2420_ST_MMC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2364,10 +2406,11 @@ static struct clk fac_ick = {
 	.name		= "fac_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2375,10 +2418,11 @@ static struct clk fac_fck = {
 	.name		= "fac_fck",
 	.parent		= &func_12m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_FAC_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_FAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2386,10 +2430,11 @@ static struct clk eac_ick = {
 	.name		= "eac_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
+	.idlest_bit	= OMAP2420_ST_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2397,10 +2442,11 @@ static struct clk eac_fck = {
 	.name		= "eac_fck",
 	.parent		= &func_96m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_EAC_SHIFT,
+	.idlest_bit	= OMAP2420_ST_EAC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2408,10 +2454,11 @@ static struct clk hdq_ick = {
 	.name		= "hdq_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2419,10 +2466,11 @@ static struct clk hdq_fck = {
 	.name		= "hdq_fck",
 	.parent		= &func_12m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP24XX_EN_HDQ_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_HDQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2431,10 +2479,11 @@ static struct clk i2c2_ick = {
 	.id		= 2,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
+	.idlest_bit	= OMAP2420_ST_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2443,10 +2492,11 @@ static struct clk i2c2_fck = {
 	.id		= 2,
 	.parent		= &func_12m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_I2C2_SHIFT,
+	.idlest_bit	= OMAP2420_ST_I2C2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2467,10 +2517,11 @@ static struct clk i2c1_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP242X | CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
+	.idlest_bit	= OMAP2420_ST_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2479,10 +2530,11 @@ static struct clk i2c1_fck = {
 	.id		= 1,
 	.parent		= &func_12m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_I2C1_SHIFT,
+	.idlest_bit	= OMAP2420_ST_I2C1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2527,10 +2579,11 @@ static struct clk vlynq_ick = {
 	.name		= "vlynq_ick",
 	.parent		= &core_l3_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
+	.idlest_bit	= OMAP2420_ST_VLYNQ_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2563,10 +2616,11 @@ static struct clk vlynq_fck = {
 	.name		= "vlynq_fck",
 	.parent		= &func_96m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP,
+	.flags		= CLOCK_IN_OMAP242X | DELAYED_APP | WAIT_READY,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP2420_EN_VLYNQ_SHIFT,
+	.idlest_bit	= OMAP2420_ST_VLYNQ_SHIFT,
 	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= CM_CLKSEL1,
 	.clksel_mask	= OMAP2420_CLKSEL_VLYNQ_MASK,
@@ -2580,10 +2634,11 @@ static struct clk sdrc_ick = {
 	.name		= "sdrc_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X | ENABLE_ON_INIT,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY | ENABLE_ON_INIT,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN3,
 	.enable_bit	= OMAP2430_EN_SDRC_SHIFT,
+	.idlest_bit	= OMAP2430_ST_SDRC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2591,10 +2646,11 @@ static struct clk des_ick = {
 	.name		= "des_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_DES_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_DES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2602,10 +2658,11 @@ static struct clk sha_ick = {
 	.name		= "sha_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_SHA_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_SHA_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2613,10 +2670,11 @@ static struct clk rng_ick = {
 	.name		= "rng_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_RNG_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_RNG_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2624,10 +2682,11 @@ static struct clk aes_ick = {
 	.name		= "aes_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_AES_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_AES_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2635,10 +2694,11 @@ static struct clk pka_ick = {
 	.name		= "pka_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= OMAP24XX_CM_ICLKEN4,
 	.enable_bit	= OMAP24XX_EN_PKA_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_PKA_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2646,10 +2706,11 @@ static struct clk usb_fck = {
 	.name		= "usb_fck",
 	.parent		= &func_48m_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X,
+	.flags		= CLOCK_IN_OMAP243X | CLOCK_IN_OMAP242X | WAIT_READY,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= OMAP24XX_CM_FCLKEN2,
 	.enable_bit	= OMAP24XX_EN_USB_SHIFT,
+	.idlest_bit	= OMAP24XX_ST_USB_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2657,10 +2718,11 @@ static struct clk usbhs_ick = {
 	.name		= "usbhs_ick",
 	.parent		= &core_l3_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_USBHS_SHIFT,
+	.idlest_bit	= OMAP2430_ST_USBHS_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2668,10 +2730,11 @@ static struct clk mmchs1_ick = {
 	.name		= "mmchs_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MMCHS1_SHIFT,
+	.idlest_bit	= OMAP2430_ST_MMCHS1_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2691,10 +2754,11 @@ static struct clk mmchs2_ick = {
 	.id		= 1,
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MMCHS2_SHIFT,
+	.idlest_bit	= OMAP2430_ST_MMCHS2_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2714,10 +2778,11 @@ static struct clk gpio5_ick = {
 	.name		= "gpio5_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_GPIO5_SHIFT,
+	.idlest_bit	= OMAP2430_ST_GPIO5_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
@@ -2736,10 +2801,11 @@ static struct clk mdm_intc_ick = {
 	.name		= "mdm_intc_ick",
 	.parent		= &l4_ck,
 	.prcm_mod	= CORE_MOD,
-	.flags		= CLOCK_IN_OMAP243X,
+	.flags		= CLOCK_IN_OMAP243X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP2430_EN_MDM_INTC_SHIFT,
+	.idlest_bit	= OMAP2430_ST_MDM_INTC_SHIFT,
 	.recalc		= &followparent_recalc,
 };
 
diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index aef5049..70a1532 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -1346,10 +1346,11 @@ static struct clk gpt10_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_GPT10_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT10_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT10_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1361,10 +1362,11 @@ static struct clk gpt11_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_GPT11_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT11_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT11_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -1375,7 +1377,8 @@ static struct clk cpefuse_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= OMAP3430ES2_CM_FCLKEN3,
 	.enable_bit	= OMAP3430ES2_EN_CPEFUSE_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.idlest_bit	= OMAP3430ES2_ST_CPEFUSE_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "cm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1397,7 +1400,8 @@ static struct clk usbtll_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= OMAP3430ES2_CM_FCLKEN3,
 	.enable_bit	= OMAP3430ES2_EN_USBTLL_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.idlest_bit	= OMAP3430ES2_ST_USBTLL_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1420,7 +1424,8 @@ static struct clk mmchs3_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.idlest_bit	= OMAP3430ES2_ST_MMC3_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1432,7 +1437,8 @@ static struct clk mmchs2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MMC2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1443,7 +1449,8 @@ static struct clk mspro_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MSPRO_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1454,7 +1461,8 @@ static struct clk mmchs1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MMC1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1466,7 +1474,8 @@ static struct clk i2c3_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_I2C3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1478,7 +1487,8 @@ static struct clk i2c2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_I2C2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1490,7 +1500,8 @@ static struct clk i2c1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_I2C1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1535,7 +1546,8 @@ static struct clk mcbsp5_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP5_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1560,7 +1572,8 @@ static struct clk mcbsp1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1583,7 +1596,8 @@ static struct clk mcspi4_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI4_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCSPI4_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1595,7 +1609,8 @@ static struct clk mcspi3_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCSPI3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1607,7 +1622,8 @@ static struct clk mcspi2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCSPI2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1619,7 +1635,8 @@ static struct clk mcspi1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCSPI1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1630,7 +1647,8 @@ static struct clk uart2_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_UART2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_UART2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1641,18 +1659,21 @@ static struct clk uart1_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_UART1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_UART1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
+/* XXX doublecheck: is this idle or standby? */
 static struct clk fshostusb_fck = {
 	.name		= "fshostusb_fck",
 	.parent		= &core_48m_fck,
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430ES1_EN_FSHOSTUSB_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES1,
+	.idlest_bit	= OMAP3430ES1_ST_FSHOSTUSB_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES1 | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1674,7 +1695,8 @@ static struct clk hdq_fck = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_FCLKEN1,
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_HDQ_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1696,7 +1718,7 @@ static const struct clksel ssi_ssr_clksel[] = {
 	{ .parent = NULL }
 };
 
-static struct clk ssi_ssr_fck = {
+static struct clk ssi_ssr_fck_3430es1 = {
 	.name		= "ssi_ssr_fck",
 	.init		= &omap2_init_clksel_parent,
 	.prcm_mod	= CORE_MOD,
@@ -1705,16 +1727,41 @@ static struct clk ssi_ssr_fck = {
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_SSI_MASK,
 	.clksel		= ssi_ssr_clksel,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
 
-static struct clk ssi_sst_fck = {
+static struct clk ssi_ssr_fck_3430es2 = {
+	.name		= "ssi_ssr_fck",
+	.init		= &omap2_init_clksel_parent,
+	.prcm_mod	= CORE_MOD,
+	.enable_reg	= CM_FCLKEN1,
+	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
+	.idlest_bit	= OMAP3430ES2_ST_SSI_IDLE_SHIFT,
+	.clksel_reg	= CM_CLKSEL,
+	.clksel_mask	= OMAP3430_CLKSEL_SSI_MASK,
+	.clksel		= ssi_ssr_clksel,
+	.flags		= CLOCK_IN_OMAP3430ES2 | RATE_PROPAGATES | WAIT_READY,
+	.clkdm		= { .name = "core_l4_clkdm" },
+	.recalc		= &omap2_clksel_recalc,
+};
+
+/* It's unfortunate that we need to duplicate this clock. */
+static struct clk ssi_sst_fck_3430es1 = {
 	.name		= "ssi_sst_fck",
-	.parent		= &ssi_ssr_fck,
+	.parent		= &ssi_ssr_fck_3430es1,
 	.fixed_div	= 2,
-	.flags		= CLOCK_IN_OMAP343X | PARENT_CONTROLS_CLOCK,
+	.flags		= CLOCK_IN_OMAP3430ES1 | PARENT_CONTROLS_CLOCK,
+	.clkdm		= { .name = "core_l4_clkdm" },
+	.recalc		= &omap2_fixed_divisor_recalc,
+};
+
+static struct clk ssi_sst_fck_3430es2 = {
+	.name		= "ssi_sst_fck",
+	.parent		= &ssi_ssr_fck_3430es2,
+	.fixed_div	= 2,
+	.flags		= CLOCK_IN_OMAP3430ES2 | PARENT_CONTROLS_CLOCK,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_fixed_divisor_recalc,
 };
@@ -1736,13 +1783,25 @@ static struct clk core_l3_ick = {
 	.recalc		= &followparent_recalc,
 };
 
-static struct clk hsotgusb_ick = {
+static struct clk hsotgusb_ick_3430es1 = {
 	.name		= "hsotgusb_ick",
 	.parent		= &core_l3_ick,
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_HSOTGUSB_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP3430ES1,
+	.clkdm		= { .name = "core_l3_clkdm" },
+	.recalc		= &followparent_recalc,
+};
+
+static struct clk hsotgusb_ick_3430es2 = {
+	.name		= "hsotgusb_ick",
+	.parent		= &core_l3_ick,
+	.prcm_mod	= CORE_MOD,
+	.enable_reg	= CM_ICLKEN1,
+	.enable_bit	= OMAP3430_EN_HSOTGUSB_SHIFT,
+	.idlest_bit	= OMAP3430ES2_ST_HSOTGUSB_IDLE_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1753,7 +1812,8 @@ static struct clk sdrc_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_SDRC_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT,
+	.idlest_bit	= OMAP3430_ST_SDRC_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT | WAIT_READY,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1784,7 +1844,8 @@ static struct clk pka_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_PKA_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_PKA_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l3_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1806,7 +1867,8 @@ static struct clk usbtll_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN3,
 	.enable_bit	= OMAP3430ES2_EN_USBTLL_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.idlest_bit	= OMAP3430ES2_ST_USBTLL_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1818,7 +1880,8 @@ static struct clk mmchs3_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430ES2_EN_MMC3_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.idlest_bit	= OMAP3430ES2_ST_MMC3_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1830,7 +1893,8 @@ static struct clk icr_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_ICR_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_ICR_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1841,7 +1905,8 @@ static struct clk aes2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_AES2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_AES2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1852,7 +1917,8 @@ static struct clk sha12_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_SHA12_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_SHA12_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1863,7 +1929,8 @@ static struct clk des2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_DES2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_DES2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1875,7 +1942,8 @@ static struct clk mmchs2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MMC2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MMC2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1886,7 +1954,8 @@ static struct clk mmchs1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MMC1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MMC1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1897,7 +1966,8 @@ static struct clk mspro_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MSPRO_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MSPRO_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1908,7 +1978,8 @@ static struct clk hdq_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_HDQ_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_HDQ_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1920,7 +1991,8 @@ static struct clk mcspi4_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI4_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCSPI4_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1932,7 +2004,8 @@ static struct clk mcspi3_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCSPI3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1944,7 +2017,8 @@ static struct clk mcspi2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCSPI2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1956,7 +2030,8 @@ static struct clk mcspi1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCSPI1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCSPI1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1968,7 +2043,8 @@ static struct clk i2c3_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_I2C3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1980,7 +2056,8 @@ static struct clk i2c2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_I2C2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -1992,7 +2069,8 @@ static struct clk i2c1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_I2C1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_I2C1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2003,7 +2081,8 @@ static struct clk uart2_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_UART2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_UART2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2014,7 +2093,8 @@ static struct clk uart1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_UART1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_UART1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2025,7 +2105,8 @@ static struct clk gpt11_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_GPT11_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT11_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2036,7 +2117,8 @@ static struct clk gpt10_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_GPT10_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT10_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2048,7 +2130,8 @@ static struct clk mcbsp5_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCBSP5_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP5_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2060,7 +2143,8 @@ static struct clk mcbsp1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MCBSP1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2071,7 +2155,8 @@ static struct clk fac_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430ES1_EN_FAC_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES1,
+	.idlest_bit	= OMAP3430ES1_ST_FAC_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES1 | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2082,7 +2167,8 @@ static struct clk mailboxes_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_MAILBOXES_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MAILBOXES_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2093,7 +2179,8 @@ static struct clk omapctrl_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_OMAPCTRL_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT,
+	.idlest_bit	= OMAP3430_ST_OMAPCTRL_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | ENABLE_ON_INIT | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2109,20 +2196,33 @@ static struct clk ssi_l4_ick = {
 	.recalc		= &followparent_recalc,
 };
 
-static struct clk ssi_ick = {
+static struct clk ssi_ick_3430es1 = {
 	.name		= "ssi_ick",
 	.parent		= &ssi_l4_ick,
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP3430ES1,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
-/* REVISIT: Technically the TRM claims that this is CORE_CLK based,
- * but l4_ick makes more sense to me */
+static struct clk ssi_ick_3430es2 = {
+	.name		= "ssi_ick",
+	.parent		= &ssi_l4_ick,
+	.prcm_mod	= CORE_MOD,
+	.enable_reg	= CM_ICLKEN1,
+	.enable_bit	= OMAP3430_EN_SSI_SHIFT,
+	.idlest_bit	= OMAP3430ES2_ST_SSI_IDLE_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
+	.clkdm		= { .name = "core_l4_clkdm" },
+	.recalc		= &followparent_recalc,
+};
 
+/*
+ * REVISIT: Technically the TRM claims that this is CORE_CLK based,
+ * but l4_ick makes more sense to me
+ */
 static const struct clksel usb_l4_clksel[] = {
 	{ .parent = &l4_ick, .rates = div2_rates },
 	{ .parent = NULL },
@@ -2135,10 +2235,11 @@ static struct clk usb_l4_ick = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_ICLKEN1,
 	.enable_bit	= OMAP3430ES1_EN_FSHOSTUSB_SHIFT,
+	.idlest_bit	= OMAP3430ES1_ST_FSHOSTUSB_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430ES1_CLKSEL_FSHOSTUSB_MASK,
 	.clksel		= usb_l4_clksel,
-	.flags		= CLOCK_IN_OMAP3430ES1,
+	.flags		= CLOCK_IN_OMAP3430ES1 | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2162,7 +2263,8 @@ static struct clk aes1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_AES1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_AES1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2173,7 +2275,8 @@ static struct clk rng_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_RNG_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_RNG_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2184,7 +2287,8 @@ static struct clk sha11_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_SHA11_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_SHA11_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2195,19 +2299,33 @@ static struct clk des1_ick = {
 	.prcm_mod	= CORE_MOD,
 	.enable_reg	= CM_ICLKEN2,
 	.enable_bit	= OMAP3430_EN_DES1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_DES1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "core_l4_clkdm" },
 	.recalc		= &followparent_recalc,
 };
 
 /* DSS */
-static struct clk dss1_alwon_fck = {
+static struct clk dss1_alwon_fck_3430es1 = {
 	.name		= "dss1_alwon_fck",
 	.parent		= &dpll4_m4x2_ck,
 	.prcm_mod	= OMAP3430_DSS_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_DSS1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP3430ES1,
+	.clkdm		= { .name = "dss_clkdm" },
+	.recalc		= &followparent_recalc,
+};
+
+static struct clk dss1_alwon_fck_3430es2 = {
+	.name		= "dss1_alwon_fck",
+	.parent		= &dpll4_m4x2_ck,
+	.init		= &omap2_init_clksel_parent,
+	.prcm_mod	= OMAP3430_DSS_MOD,
+	.enable_reg	= CM_FCLKEN,
+	.enable_bit	= OMAP3430_EN_DSS1_SHIFT,
+	.idlest_bit	= OMAP3430ES2_ST_DSS_IDLE_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "dss_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2245,14 +2363,27 @@ static struct clk dss2_alwon_fck = {
 	.recalc		= &followparent_recalc,
 };
 
-static struct clk dss_ick = {
+static struct clk dss_ick_3430es1 = {
 	/* Handles both L3 and L4 clocks */
 	.name		= "dss_ick",
 	.parent		= &l4_ick,
 	.prcm_mod	= OMAP3430_DSS_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_CM_ICLKEN_DSS_EN_DSS_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP3430ES1,
+	.clkdm		= { .name = "dss_clkdm" },
+	.recalc		= &followparent_recalc,
+};
+
+static struct clk dss_ick_3430es2 = {
+	/* Handles both L3 and L4 clocks */
+	.name		= "dss_ick",
+	.parent		= &l4_ick,
+	.prcm_mod	= OMAP3430_DSS_MOD,
+	.enable_reg	= CM_ICLKEN,
+	.enable_bit	= OMAP3430_CM_ICLKEN_DSS_EN_DSS_SHIFT,
+	.idlest_bit	= OMAP3430ES2_ST_DSS_IDLE_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "dss_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2312,7 +2443,8 @@ static struct clk usbhost_48m_fck = {
 	.prcm_mod	= OMAP3430ES2_USBHOST_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USBHOST1_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.idlest_bit	= OMAP3430ES2_ST_USBHOST_IDLE_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "usbhost_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2324,7 +2456,8 @@ static struct clk usbhost_ick = {
 	.prcm_mod	= OMAP3430ES2_USBHOST_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USBHOST_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.idlest_bit	= OMAP3430ES2_ST_USBHOST_IDLE_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "usbhost_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2361,10 +2494,11 @@ static struct clk usim_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
+	.idlest_bit	= OMAP3430ES2_ST_USIMOCP_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430ES2_CLKSEL_USIMOCP_MASK,
 	.clksel		= usim_clksel,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2376,10 +2510,11 @@ static struct clk gpt1_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT1_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT1_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2398,7 +2533,8 @@ static struct clk gpio1_dbck = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2409,7 +2545,8 @@ static struct clk wdt2_fck = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_WDT2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2422,15 +2559,14 @@ static struct clk wkup_l4_ick = {
 	.recalc		= &followparent_recalc,
 };
 
-/* 3430ES2 only */
-/* Never specifically named in the TRM, so we have to infer a likely name */
 static struct clk usim_ick = {
 	.name		= "usim_ick",
 	.parent		= &wkup_l4_ick,
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430ES2_EN_USIMOCP_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
+	.idlest_bit	= OMAP3430ES2_ST_USIMOCP_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES2 | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2441,7 +2577,8 @@ static struct clk wdt2_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_WDT2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_WDT2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2452,7 +2589,8 @@ static struct clk wdt1_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_WDT1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_WDT1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2463,7 +2601,8 @@ static struct clk gpio1_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2474,7 +2613,8 @@ static struct clk omap_32ksync_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_32KSYNC_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_32KSYNC_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2485,7 +2625,8 @@ static struct clk gpt12_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT12_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT12_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2496,7 +2637,8 @@ static struct clk gpt1_ick = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2529,7 +2671,8 @@ static struct clk uart3_fck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_UART3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2540,10 +2683,11 @@ static struct clk gpt2_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT2_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT2_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT2_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2554,10 +2698,11 @@ static struct clk gpt3_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT3_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT3_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT3_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2568,10 +2713,11 @@ static struct clk gpt4_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT4_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT4_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT4_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2582,10 +2728,11 @@ static struct clk gpt5_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT5_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT5_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT5_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2596,10 +2743,11 @@ static struct clk gpt6_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT6_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT6_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT6_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2610,10 +2758,11 @@ static struct clk gpt7_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT7_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT7_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT7_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2624,10 +2773,11 @@ static struct clk gpt8_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT8_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT8_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT8_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2638,10 +2788,11 @@ static struct clk gpt9_fck = {
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPT9_SHIFT,
+	.idlest_bit	= OMAP3430_ST_GPT9_SHIFT,
 	.clksel_reg	= CM_CLKSEL,
 	.clksel_mask	= OMAP3430_CLKSEL_GPT9_MASK,
 	.clksel		= omap343x_gpt_clksel,
-	.flags		= CLOCK_IN_OMAP343X,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2660,7 +2811,8 @@ static struct clk gpio6_dbck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO6_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2671,7 +2823,8 @@ static struct clk gpio5_dbck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO5_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2682,7 +2835,8 @@ static struct clk gpio4_dbck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO4_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2693,7 +2847,8 @@ static struct clk gpio3_dbck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2704,7 +2859,8 @@ static struct clk gpio2_dbck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2715,7 +2871,8 @@ static struct clk wdt3_fck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_WDT3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2735,7 +2892,8 @@ static struct clk gpio6_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO6_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2746,7 +2904,8 @@ static struct clk gpio5_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO5_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2757,7 +2916,8 @@ static struct clk gpio4_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO4_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2768,7 +2928,8 @@ static struct clk gpio3_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2779,7 +2940,8 @@ static struct clk gpio2_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPIO2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2790,7 +2952,8 @@ static struct clk wdt3_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_WDT3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_WDT3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2801,7 +2964,8 @@ static struct clk uart3_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_UART3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_UART3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2812,7 +2976,8 @@ static struct clk gpt9_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT9_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT9_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2823,7 +2988,8 @@ static struct clk gpt8_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT8_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT8_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2834,7 +3000,8 @@ static struct clk gpt7_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT7_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT7_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2845,7 +3012,8 @@ static struct clk gpt6_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT6_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT6_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2856,7 +3024,8 @@ static struct clk gpt5_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT5_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT5_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2867,7 +3036,8 @@ static struct clk gpt4_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT4_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT4_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2878,7 +3048,8 @@ static struct clk gpt3_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2889,7 +3060,8 @@ static struct clk gpt2_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_GPT2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_GPT2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2901,7 +3073,8 @@ static struct clk mcbsp2_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2913,7 +3086,8 @@ static struct clk mcbsp3_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2925,7 +3099,8 @@ static struct clk mcbsp4_ick = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_ICLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP4_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -2956,7 +3131,8 @@ static struct clk mcbsp2_fck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -2981,7 +3157,8 @@ static struct clk mcbsp3_fck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP3_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP3_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -3006,7 +3183,8 @@ static struct clk mcbsp4_fck = {
 	.prcm_mod	= OMAP3430_PER_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_MCBSP4_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
+	.idlest_bit	= OMAP3430_ST_MCBSP4_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | WAIT_READY,
 	.clkdm		= { .name = "per_clkdm" },
 	.recalc		= &omap2_clksel_recalc,
 };
@@ -3171,7 +3349,8 @@ static struct clk sr1_fck = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_SR1_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.idlest_bit	= OMAP3430_ST_SR1_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -3183,7 +3362,8 @@ static struct clk sr2_fck = {
 	.prcm_mod	= WKUP_MOD,
 	.enable_reg	= CM_FCLKEN,
 	.enable_bit	= OMAP3430_EN_SR2_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES,
+	.idlest_bit	= OMAP3430_ST_SR2_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -3198,11 +3378,12 @@ static struct clk sr_l4_ick = {
 
 /* SECURE_32K_FCK clocks */
 
-/* XXX This clock no longer exists in 3430 TRM rev F */
+/* XXX Make sure idlest_bit/wait_ready with no enable_bit works */
 static struct clk gpt12_fck = {
 	.name		= "gpt12_fck",
 	.parent		= &secure_32k_fck,
-	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED,
+	.idlest_bit	= OMAP3430_ST_GPT12_SHIFT,
+	.flags		= CLOCK_IN_OMAP343X | ALWAYS_ENABLED | WAIT_READY,
 	.clkdm		= { .name = "prm_clkdm" },
 	.recalc		= &followparent_recalc,
 };
@@ -3309,10 +3490,13 @@ static struct clk *onchip_34xx_clks[] __initdata = {
 	&fshostusb_fck,
 	&core_12m_fck,
 	&hdq_fck,
-	&ssi_ssr_fck,
-	&ssi_sst_fck,
+	&ssi_ssr_fck_3430es1,
+	&ssi_ssr_fck_3430es2,
+	&ssi_sst_fck_3430es1,
+	&ssi_sst_fck_3430es2,
 	&core_l3_ick,
-	&hsotgusb_ick,
+	&hsotgusb_ick_3430es1,
+	&hsotgusb_ick_3430es2,
 	&sdrc_ick,
 	&gpmc_fck,
 	&security_l3_ick,
@@ -3345,18 +3529,21 @@ static struct clk *onchip_34xx_clks[] __initdata = {
 	&mailboxes_ick,
 	&omapctrl_ick,
 	&ssi_l4_ick,
-	&ssi_ick,
+	&ssi_ick_3430es1,
+	&ssi_ick_3430es2,
 	&usb_l4_ick,
 	&security_l4_ick2,
 	&aes1_ick,
 	&rng_ick,
 	&sha11_ick,
 	&des1_ick,
-	&dss1_alwon_fck,
+	&dss1_alwon_fck_3430es1,
+	&dss1_alwon_fck_3430es2,
 	&dss_tv_fck,
 	&dss_96m_fck,
 	&dss2_alwon_fck,
-	&dss_ick,
+	&dss_ick_3430es1,
+	&dss_ick_3430es2,
 	&cam_mclk,
 	&cam_ick,
 	&csi2_96m_fck,
diff --git a/arch/arm/mach-omap2/cm-regbits-24xx.h b/arch/arm/mach-omap2/cm-regbits-24xx.h
index 297a2fe..a9a0df5 100644
--- a/arch/arm/mach-omap2/cm-regbits-24xx.h
+++ b/arch/arm/mach-omap2/cm-regbits-24xx.h
@@ -147,6 +147,7 @@
 
 /* CM_IDLEST3_CORE */
 /* 2430 only */
+#define OMAP2430_ST_SDRC_SHIFT				2
 #define OMAP2430_ST_SDRC_MASK				(1 << 2)
 
 /* CM_IDLEST4_CORE */
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index 847b122..1b74119 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -71,6 +71,7 @@ struct clk {
 	u16			enable_reg;
 	__u8			enable_bit;
 	__s8			usecount;
+	u8			idlest_bit;
 	void			(*recalc)(struct clk *);
 	int			(*set_rate)(struct clk *, unsigned long);
 	long			(*round_rate)(struct clk *, unsigned long);
@@ -144,7 +145,8 @@ extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 #define CONFIG_PARTICIPANT	(1 << 10)	/* Fundamental clock */
 #define ENABLE_ON_INIT		(1 << 11)	/* Enable upon framework init */
 #define INVERT_ENABLE		(1 << 12)	/* 0 enables, 1 disables */
-/* bits 13-20 are currently free */
+#define WAIT_READY		(1 << 13)	/* wait for dev to leave idle */
+/* bits 14-20 are currently free */
 #define CLOCK_IN_OMAP310	(1 << 21)
 #define CLOCK_IN_OMAP730	(1 << 22)
 #define CLOCK_IN_OMAP1510	(1 << 23)
@@ -154,14 +156,14 @@ extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 #define CLOCK_IN_OMAP343X	(1 << 27)	/* clocks common to all 343X */
 #define PARENT_CONTROLS_CLOCK	(1 << 28)
 #define CLOCK_IN_OMAP3430ES1	(1 << 29)	/* 3430ES1 clocks only */
-#define CLOCK_IN_OMAP3430ES2	(1 << 30)	/* 3430ES2 clocks only */
+#define CLOCK_IN_OMAP3430ES2	(1 << 30)	/* 3430ES2+ clocks only */
 
 /* Clksel_rate flags */
 #define DEFAULT_RATE		(1 << 0)
 #define RATE_IN_242X		(1 << 1)
 #define RATE_IN_243X		(1 << 2)
 #define RATE_IN_343X		(1 << 3)	/* rates common to all 343X */
-#define RATE_IN_3430ES2		(1 << 4)	/* 3430ES2 rates only */
+#define RATE_IN_3430ES2		(1 << 4)	/* 3430ES2+ rates only */
 
 #define RATE_IN_24XX		(RATE_IN_242X | RATE_IN_243X)
 


