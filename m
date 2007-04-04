Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbXDDSeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbXDDSeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXDDSIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:08:46 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36863 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbXDDSIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:08:24 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 28/90] ARM: OMAP: USB peripheral support on H4
Date: Wed,  4 Apr 2007 14:05:07 -0400
Message-Id: <11757100403021-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1175710033286-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

H4 has two peripheral ports, one for "download" and one for OTG.
The one to use is selected through Kconfig.

NOTE:  not yet working; I suspect there's a clock still turned off
or something like that, since neither port responds.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig    |   21 ++++++++++++++++++
 arch/arm/mach-omap2/board-h4.c |   46 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 47c8b57..d4a366d 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -26,6 +26,27 @@ config MACH_OMAP_H4
 	depends on ARCH_OMAP2 && ARCH_OMAP24XX
 	select OMAP_DEBUG_DEVICES
 
+config MACH_OMAP_H4_OTG
+	bool "Use USB OTG connector, not device connector (S1.10)"
+	depends on MACH_OMAP_H4
+	help
+	  Set this if you've set S1.10 (on the mainboard) to use the
+	  Mini-AB (OTG) connector and OTG transceiver with the USB0
+	  port, instead of the Mini-B ("download") connector with its
+	  non-OTG transceiver.
+
+	  Note that the "download" connector can be used to bootstrap
+	  the system from the OMAP mask ROM.  Also, since this is a
+	  development platform, you can also force the OTG port into
+	  a non-OTG operational mode.
+
+config MACH_OMAP2_H4_USB1
+	bool "Use USB1 port, not UART2 (S3.3)"
+	depends on MACH_OMAP_H4
+	help
+	  Set this if you've set SW3.3 (on the CPU card) so that the
+	  expansion connectors receive USB1 signals instead of UART2.
+
 config MACH_OMAP_APOLLON
 	bool "OMAP 2420 Apollon board"
 	depends on ARCH_OMAP2 && ARCH_OMAP24XX
diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index f125f43..b1cebdd 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -278,7 +278,11 @@ static void __init omap_h4_init_irq(void)
 }
 
 static struct omap_uart_config h4_uart_config __initdata = {
+#ifdef	CONFIG_MACH_OMAP2_H4_USB1
+	.enabled_uarts = ((1 << 0) | (1 << 1)),
+#else
 	.enabled_uarts = ((1 << 0) | (1 << 1) | (1 << 2)),
+#endif
 };
 
 static struct omap_mmc_config h4_mmc_config __initdata = {
@@ -295,10 +299,44 @@ static struct omap_lcd_config h4_lcd_config __initdata = {
 	.ctrl_name	= "internal",
 };
 
+static struct omap_usb_config h4_usb_config __initdata = {
+#ifdef	CONFIG_MACH_OMAP2_H4_USB1
+	/* NOTE:  usb1 could also be used with 3 wire signaling */
+	.pins[1]	= 4,
+#endif
+
+#ifdef	CONFIG_MACH_OMAP_H4_OTG
+	/* S1.10 ON -- USB OTG port
+	 * usb0 switched to Mini-AB port and isp1301 transceiver;
+	 * S2.POS3 = OFF, S2.POS4 = ON ... to allow battery charging
+	 */
+	.otg		= 1,
+	.pins[0]	= 4,
+#ifdef	CONFIG_USB_GADGET_OMAP
+	/* use OTG cable, or standard A-to-MiniB */
+	.hmc_mode	= 0x14,	/* 0:dev/otg 1:host 2:disable */
+#elif	defined(CONFIG_USB_OHCI_HCD) || defined(CONFIG_USB_OHCI_HCD_MODULE)
+	/* use OTG cable, or NONSTANDARD (B-to-MiniB) */
+	.hmc_mode	= 0x11,	/* 0:host 1:host 2:disable */
+#endif	/* XX */
+
+#else
+	/* S1.10 OFF -- usb "download port"
+	 * usb0 switched to Mini-B port and isp1105 transceiver;
+	 * S2.POS3 = ON, S2.POS4 = OFF ... to enable battery charging
+	 */
+	.register_dev	= 1,
+	.pins[0]	= 3,
+//	.hmc_mode	= 0x14,	/* 0:dev 1:host 2:disable */
+	.hmc_mode	= 0x00,	/* 0:dev|otg 1:disable 2:disable */
+#endif
+};
+
 static struct omap_board_config_kernel h4_config[] = {
 	{ OMAP_TAG_UART,	&h4_uart_config },
 	{ OMAP_TAG_MMC,		&h4_mmc_config },
 	{ OMAP_TAG_LCD,		&h4_lcd_config },
+	{ OMAP_TAG_USB,	&h4_usb_config },
 };
 
 static void __init omap_h4_init(void)
@@ -321,6 +359,14 @@ static void __init omap_h4_init(void)
 	}
 #endif
 
+#ifdef	CONFIG_MACH_OMAP2_H4_USB1
+	/* S3.3 controls whether these pins are for UART2 or USB1 */
+	omap_cfg_reg(N14_24XX_USB1_SE0);
+	omap_cfg_reg(P15_24XX_USB1_DAT);
+	omap_cfg_reg(W20_24XX_USB1_TXEN);
+	omap_cfg_reg(V19_24XX_USB1_RCV);
+#endif
+
 	platform_add_devices(h4_devices, ARRAY_SIZE(h4_devices));
 	omap_board_config = h4_config;
 	omap_board_config_size = ARRAY_SIZE(h4_config);
-- 
1.4.4.2

