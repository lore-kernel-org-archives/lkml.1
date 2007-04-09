Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXDIV2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXDIV2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030237AbXDIV0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:26:49 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:29283 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965959AbXDIV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:26:17 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 2/6] ARM: OMAP: omap camera builds again; Mistral init and mux
Date: Mon,  9 Apr 2007 17:25:40 -0400
Message-Id: <11761539511877-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176153948771-git-send-email-tony@atomide.com>
References: <1176153944991-git-send-email-tony@atomide.com> <1176153948771-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Support the camera connector on the OSK Mistral add-on board:

  - define muxing for both camera controllers
  - mux both of them for Mistral
  - teach ov9640 glue about mistral powerup/powerdown

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-osk.c |   32 ++++++++++++++++++++++++++++++++
 arch/arm/mach-omap1/mux.c       |   24 ++++++++++++++++++++++++
 include/asm-arm/arch-omap/mux.h |   23 +++++++++++++++++++++++
 3 files changed, 79 insertions(+), 0 deletions(-)

Index: linux-2.6/arch/arm/mach-omap1/board-osk.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/board-osk.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/board-osk.c	2007-04-09 14:49:51.000000000 -0400
@@ -342,6 +342,38 @@ static void __init osk_mistral_init(void
 	 * can't talk to the ads or even the i2c eeprom.
 	 */
 
+	/* parallel camera interface */
+	omap_cfg_reg(J15_1610_CAM_LCLK);
+	omap_cfg_reg(J18_1610_CAM_D7);
+	omap_cfg_reg(J19_1610_CAM_D6);
+	omap_cfg_reg(J14_1610_CAM_D5);
+	omap_cfg_reg(K18_1610_CAM_D4);
+	omap_cfg_reg(K19_1610_CAM_D3);
+	omap_cfg_reg(K15_1610_CAM_D2);
+	omap_cfg_reg(K14_1610_CAM_D1);
+	omap_cfg_reg(L19_1610_CAM_D0);
+	omap_cfg_reg(L18_1610_CAM_VS);
+	omap_cfg_reg(L15_1610_CAM_HS);
+	omap_cfg_reg(M19_1610_CAM_RSTZ);
+	omap_cfg_reg(Y15_1610_CAM_OUTCLK);
+
+	/* serial camera interface */
+	omap_cfg_reg(H19_1610_CAM_EXCLK);
+	omap_cfg_reg(W13_1610_CCP_CLKM);
+	omap_cfg_reg(Y12_1610_CCP_CLKP);
+	/* CCP_DATAM CONFLICTS WITH UART1.TX (and serial console) */
+	// omap_cfg_reg(Y14_1610_CCP_DATAM);
+	omap_cfg_reg(W14_1610_CCP_DATAP);
+
+	/* CAM_PWDN */
+	if (omap_request_gpio(11) == 0) {
+		omap_cfg_reg(N20_1610_GPIO11);
+		omap_set_gpio_direction(11, 0 /* out */);
+		omap_set_gpio_dataout(11, 0 /* off */);
+	} else
+		pr_debug("OSK+Mistral: CAM_PWDN is awol\n");
+
+
 	// omap_cfg_reg(P19_1610_GPIO6);	// BUSY
 	omap_cfg_reg(P20_1610_GPIO4);	// PENIRQ
 	set_irq_type(OMAP_GPIO_IRQ(4), IRQT_FALLING);
Index: linux-2.6/arch/arm/mach-omap1/mux.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/mux.c	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap1/mux.c	2007-04-09 14:49:51.000000000 -0400
@@ -283,6 +283,30 @@ MUX_CFG("R11_1610_CF_IOIS16",	 B,    0, 
 MUX_CFG("V10_1610_CF_IREQ",	 A,   24,    3,	  2,   14,   0,	  2,	 0,  1)
 MUX_CFG("W10_1610_CF_RESET",	 A,   18,    3,	  2,   12,   1,	  2,	 1,  1)
 MUX_CFG("W11_1610_CF_CD1",	10,   15,    3,	  3,    8,   1,	  3,	 1,  1)
+
+/* parallel camera */
+MUX_CFG("J15_1610_CAM_LCLK",	 4,   24,    0,   0,  18,   1,    0,     0,  0)
+MUX_CFG("J18_1610_CAM_D7",	 4,   27,    0,   0,  19,   1,    0,     0,  0)
+MUX_CFG("J19_1610_CAM_D6",	 5,    0,    0,   0,  20,   1,    0,     0,  0)
+MUX_CFG("J14_1610_CAM_D5",	 5,    3,    0,   0,  21,   1,    0,     0,  0)
+MUX_CFG("K18_1610_CAM_D4",	 5,    6,    0,   0,  22,   1,    0,     0,  0)
+MUX_CFG("K19_1610_CAM_D3",	 5,    9,    0,   0,  23,   1,    0,     0,  0)
+MUX_CFG("K15_1610_CAM_D2",	 5,   12,    0,   0,  24,   1,    0,     0,  0)
+MUX_CFG("K14_1610_CAM_D1",	 5,   15,    0,   0,  25,   1,    0,     0,  0)
+MUX_CFG("L19_1610_CAM_D0",	 5,   18,    0,   0,  26,   1,    0,     0,  0)
+MUX_CFG("L18_1610_CAM_VS",	 5,   21,    0,   0,  27,   1,    0,     0,  0)
+MUX_CFG("L15_1610_CAM_HS",	 5,   24,    0,   0,  28,   1,    0,     0,  0)
+MUX_CFG("M19_1610_CAM_RSTZ",	 5,   27,    0,   0,  29,   0,    0,     0,  0)
+MUX_CFG("Y15_1610_CAM_OUTCLK",	 A,    0,    6,   2,   6,   0,    2,     0,  0)
+
+/* serial camera */
+MUX_CFG("H19_1610_CAM_EXCLK",	 4,   21,    0,   0,  17,   0,    0,     0,  0)
+	/* REVISIT 5912 spec sez CCP_* can't pullup or pulldown ... ? */
+MUX_CFG("Y12_1610_CCP_CLKP",	 8,   18,    6,   1,  24,   1,    1,     0,  0)
+MUX_CFG("W13_1610_CCP_CLKM",	 9,    0,    6,   1,  28,   1,    1,     0,  0)
+MUX_CFG("W14_1610_CCP_DATAP",	 9,   24,    6,   2,   4,   1,    2,     0,  0)
+MUX_CFG("Y14_1610_CCP_DATAM",	 9,   21,    6,   2,   3,   1,    2,     0,  0)
+
 };
 #endif	/* CONFIG_ARCH_OMAP15XX || CONFIG_ARCH_OMAP16XX */
 
Index: linux-2.6/include/asm-arm/arch-omap/mux.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/mux.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/mux.h	2007-04-09 14:49:51.000000000 -0400
@@ -406,6 +406,29 @@ enum omap1xxx_index {
 	V10_1610_CF_IREQ,
 	W10_1610_CF_RESET,
 	W11_1610_CF_CD1,
+
+	/* parallel camera */
+	J15_1610_CAM_LCLK,
+	J18_1610_CAM_D7,
+	J19_1610_CAM_D6,
+	J14_1610_CAM_D5,
+	K18_1610_CAM_D4,
+	K19_1610_CAM_D3,
+	K15_1610_CAM_D2,
+	K14_1610_CAM_D1,
+	L19_1610_CAM_D0,
+	L18_1610_CAM_VS,
+	L15_1610_CAM_HS,
+	M19_1610_CAM_RSTZ,
+	Y15_1610_CAM_OUTCLK,
+
+	/* serial camera */
+	H19_1610_CAM_EXCLK,
+	Y12_1610_CCP_CLKP,
+	W13_1610_CCP_CLKM,
+	W14_1610_CCP_DATAP,
+	Y14_1610_CCP_DATAM,
+
 };
 
 enum omap24xx_index {
