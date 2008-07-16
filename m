Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbYGPPWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbYGPPWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbYGPPTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:19:19 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:61418 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760073AbYGPPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:19:17 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+udWde2D/d00405J39FFRN
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       =?utf-8?q?H=C3=B6gander=20Jouni?= <jouni.hogander@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 10/10] ARM: OMAP2: Clock: Combine 34xx l3_icks and l4_icks
Date: Wed, 16 Jul 2008 18:19:15 +0300
Message-Id: <1216221555-18958-11-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.5.6.rc3.21.g8c6b5
In-Reply-To: <1216221555-18958-10-git-send-email-tony@atomide.com>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
 <1216221555-18958-2-git-send-email-tony@atomide.com>
 <1216221555-18958-3-git-send-email-tony@atomide.com>
 <1216221555-18958-4-git-send-email-tony@atomide.com>
 <1216221555-18958-5-git-send-email-tony@atomide.com>
 <1216221555-18958-6-git-send-email-tony@atomide.com>
 <1216221555-18958-7-git-send-email-tony@atomide.com>
 <1216221555-18958-8-git-send-email-tony@atomide.com>
 <1216221555-18958-9-git-send-email-tony@atomide.com>
 <1216221555-18958-10-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Högander Jouni <jouni.hogander@nokia.com>

E.g dss_l3_ick and dss_l4_ick have same gating control. Having own
clock for both of them causes race condition between enable / disable.

This patch combines this kind of clocks and names new clock as <module>_ick.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Acked-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index e8f22c4..a1db551 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -1189,27 +1189,34 @@ static const struct clksel gfx_l3_clksel[] = {
 	{ .parent = NULL }
 };
 
-static struct clk gfx_l3_fck = {
-	.name		= "gfx_l3_fck",
+/* Virtual parent clock for gfx_l3_ick and gfx_l3_fck */
+static struct clk gfx_l3_ck = {
+	.name		= "gfx_l3_ck",
 	.parent		= &l3_ick,
 	.init		= &omap2_init_clksel_parent,
 	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_ICLKEN),
 	.enable_bit	= OMAP_EN_GFX_SHIFT,
+	.flags		= CLOCK_IN_OMAP3430ES1,
+	.recalc		= &followparent_recalc,
+};
+
+static struct clk gfx_l3_fck = {
+	.name		= "gfx_l3_fck",
+	.parent		= &gfx_l3_ck,
+	.init		= &omap2_init_clksel_parent,
 	.clksel_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_CLKSEL),
 	.clksel_mask	= OMAP_CLKSEL_GFX_MASK,
 	.clksel		= gfx_l3_clksel,
-	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES,
+	.flags		= CLOCK_IN_OMAP3430ES1 | RATE_PROPAGATES |
+				PARENT_CONTROLS_CLOCK,
 	.clkdm_name	= "gfx_3430es1_clkdm",
 	.recalc		= &omap2_clksel_recalc,
 };
 
 static struct clk gfx_l3_ick = {
 	.name		= "gfx_l3_ick",
-	.parent		= &l3_ick,
-	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(GFX_MOD, CM_ICLKEN),
-	.enable_bit	= OMAP_EN_GFX_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES1,
+	.parent		= &gfx_l3_ck,
+	.flags		= CLOCK_IN_OMAP3430ES1 | PARENT_CONTROLS_CLOCK,
 	.clkdm_name	= "gfx_3430es1_clkdm",
 	.recalc		= &followparent_recalc,
 };
@@ -2153,19 +2160,9 @@ static struct clk cam_mclk = {
 	.recalc		= &omap2_clksel_recalc,
 };
 
-static struct clk cam_l3_ick = {
-	.name		= "cam_l3_ick",
-	.parent		= &l3_ick,
-	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_ICLKEN),
-	.enable_bit	= OMAP3430_EN_CAM_SHIFT,
-	.flags		= CLOCK_IN_OMAP343X,
-	.clkdm_name	= "cam_clkdm",
-	.recalc		= &followparent_recalc,
-};
-
-static struct clk cam_l4_ick = {
-	.name		= "cam_l4_ick",
+static struct clk cam_ick = {
+	/* Handles both L3 and L4 clocks */
+	.name		= "cam_ick",
 	.parent		= &l4_ick,
 	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_ICLKEN),
@@ -2199,19 +2196,9 @@ static struct clk usbhost_48m_fck = {
 	.recalc		= &followparent_recalc,
 };
 
-static struct clk usbhost_l3_ick = {
-	.name		= "usbhost_l3_ick",
-	.parent		= &l3_ick,
-	.init		= &omap2_init_clk_clkdm,
-	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_ICLKEN),
-	.enable_bit	= OMAP3430ES2_EN_USBHOST_SHIFT,
-	.flags		= CLOCK_IN_OMAP3430ES2,
-	.clkdm_name	= "usbhost_clkdm",
-	.recalc		= &followparent_recalc,
-};
-
-static struct clk usbhost_l4_ick = {
-	.name		= "usbhost_l4_ick",
+static struct clk usbhost_ick = {
+	/* Handles both L3 and L4 clocks */
+	.name		= "usbhost_ick",
 	.parent		= &l4_ick,
 	.init		= &omap2_init_clk_clkdm,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430ES2_USBHOST_MOD, CM_ICLKEN),
@@ -3093,6 +3080,7 @@ static struct clk *onchip_34xx_clks[] __initdata = {
 	&l3_ick,
 	&l4_ick,
 	&rm_ick,
+	&gfx_l3_ck,
 	&gfx_l3_fck,
 	&gfx_l3_ick,
 	&gfx_cg1_ck,
@@ -3174,12 +3162,10 @@ static struct clk *onchip_34xx_clks[] __initdata = {
 	&dss2_alwon_fck,
 	&dss_ick,
 	&cam_mclk,
-	&cam_l3_ick,
-	&cam_l4_ick,
+	&cam_ick,
 	&usbhost_120m_fck,
 	&usbhost_48m_fck,
-	&usbhost_l3_ick,
-	&usbhost_l4_ick,
+	&usbhost_ick,
 	&usbhost_sar_fck,
 	&usim_fck,
 	&gpt1_fck,
