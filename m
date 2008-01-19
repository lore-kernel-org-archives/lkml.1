Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbYASOhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbYASOhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbYASOfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:35:54 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:42115 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761417AbYASOfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:35:51 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: david-b@pacbell.net, tony@atomide.com, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH] USB: OTG: Make otg_tpl come from platform_data
Date: Sat, 19 Jan 2008 16:37:26 +0200
Message-Id: <1200753446-9378-6-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc3.24.gb53139
In-Reply-To: <1200753446-9378-5-git-send-email-me@felipebalbi.com>
References: <1200753446-9378-1-git-send-email-me@felipebalbi.com>
 <1200753446-9378-2-git-send-email-me@felipebalbi.com>
 <1200753446-9378-3-git-send-email-me@felipebalbi.com>
 <1200753446-9378-4-git-send-email-me@felipebalbi.com>
 <1200753446-9378-5-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is applicable to n8X0. It makes otg tpl come
from musb_platform_data and be initialized in otg.c

This provides a better code style and better handling
of otg capable devices.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 arch/arm/mach-omap2/board-n800-usb.c |   14 +++++++++++
 drivers/usb/core/otg.c               |   43 ++++------------------------------
 drivers/usb/musb/musb_core.c         |    4 +++
 include/linux/usb/musb.h             |    5 ++++
 include/linux/usb/otg.h              |    5 ++++
 5 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n800-usb.c b/arch/arm/mach-omap2/board-n800-usb.c
index 7599f64..a2ea1a0 100644
--- a/arch/arm/mach-omap2/board-n800-usb.c
+++ b/arch/arm/mach-omap2/board-n800-usb.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/usb/musb.h>
+#include <linux/usb.h>
 #include <asm/arch/gpmc.h>
 #include <asm/arch/gpio.h>
 #include <asm/arch/pm.h>
@@ -35,6 +36,16 @@ static int tusb_set_clock(struct clk *osc_ck, int state);
 #	define BOARD_MODE	MUSB_HOST
 #endif
 
+#ifdef CONFIG_USB_OTG_WHITELIST
+struct usb_device_id otg_tpl[] __initdata = {
+		/* Support known mass storage devices */
+		{ USB_DEVICE(0x0421, 0x0431), }, /* N770 */
+		{ USB_DEVICE(0x0421, 0x04c3), }, /* N800 */
+		{ USB_DEVICE(0x0421, 0x0096), }, /* RX44 */
+		{  } /* Terminating entry */
+};
+#endif
+
 static struct musb_hdrc_platform_data tusb_data = {
 	.mode		= BOARD_MODE,
 	.multipoint	= 1,
@@ -43,6 +54,9 @@ static struct musb_hdrc_platform_data tusb_data = {
 	.min_power	= 25,	/* x2 = 50 mA drawn from VBUS as peripheral */
 	.power		= 100,	/* Max 100 mA VBUS for host mode */
 	.clock		= "osc_ck",
+#ifdef	CONFIG_USB_OTG_WHITELIST
+	.otg_tpl	= otg_tpl,
+#endif
 };
 
 /*
diff --git a/drivers/usb/core/otg.c b/drivers/usb/core/otg.c
index 9a2ce7e..8795382 100644
--- a/drivers/usb/core/otg.c
+++ b/drivers/usb/core/otg.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/usb/otg.h>
+#include <linux/platform_device.h>
 
 static struct otg_transceiver *xceiv;
 
@@ -60,43 +61,6 @@ EXPORT_SYMBOL(otg_set_error);
 
 #ifdef	CONFIG_USB_OTG_WHITELIST
 
-/*
- * This OTG Whitelist is the OTG "Targeted Peripheral List".  It should
- * mostly use of USB_DEVICE() or USB_DEVICE_VER() entries..
- *
- * YOU _SHOULD_ CHANGE THIS LIST TO MATCH YOUR PRODUCT AND ITS TESTING!
- */
-
-static struct usb_device_id whitelist_table [] __initdata = {
-
-/* hubs are optional in OTG, but very handy ... */
-{ USB_DEVICE_INFO(USB_CLASS_HUB, 0, 0), },
-{ USB_DEVICE_INFO(USB_CLASS_HUB, 0, 1), },
-
-#ifdef	CONFIG_USB_PRINTER		/* ignoring nonstatic linkage! */
-/* FIXME actually, printers are NOT supposed to use device classes;
- * they're supposed to use interface classes...
- */
-{ USB_DEVICE_INFO(7, 1, 1) },
-{ USB_DEVICE_INFO(7, 1, 2) },
-{ USB_DEVICE_INFO(7, 1, 3) },
-#endif
-
-#ifdef	CONFIG_USB_NET_CDCETHER
-/* Linux-USB CDC Ethernet gadget */
-{ USB_DEVICE(0x0525, 0xa4a1), },
-/* Linux-USB CDC Ethernet + RNDIS gadget */
-{ USB_DEVICE(0x0525, 0xa4a2), },
-#endif
-
-#if	defined(CONFIG_USB_TEST) || defined(CONFIG_USB_TEST_MODULE)
-/* gadget zero, for testing */
-{ USB_DEVICE(0x0525, 0xa4a0), },
-#endif
-
-{ }	/* Terminating entry */
-};
-
 struct otg_device {
 	struct list_head	list;
 	struct usb_device_id	id;
@@ -220,10 +184,13 @@ targeted:
 static int __init tpl_init(void)
 {
 	INIT_LIST_HEAD(&tpl_devices);
-	tpl_add_devices(whitelist_table);
+
 	if (xceiv)
 		xceiv->tpl_enabled = 1;
 
+	if (xceiv->otg_tpl != NULL)
+		tpl_add_devices(xceiv->otg_tpl);
+
 	return 0;
 }
 
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index fb37e2c..cf29bde 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1939,6 +1939,10 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	musb->set_clock = plat->set_clock;
 	musb->min_power = plat->min_power;
 
+#ifdef CONFIG_USB_OTG_WHITELIST
+	musb->xceiv.otg_tpl = plat->otg_tpl;
+#endif
+
 	/* Clock usage is chip-specific ... functional clock (DaVinci,
 	 * OMAP2430), or PHY ref (some TUSB6010 boards).  All this core
 	 * code does is make sure a clock handle is available; platform
diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
index d325a0d..76f21b7 100644
--- a/include/linux/usb/musb.h
+++ b/include/linux/usb/musb.h
@@ -7,6 +7,8 @@
  * key configuration differences between boards.
  */
 
+#include <linux/mod_devicetable.h>
+
 /* The USB role is defined by the connector used on the board, so long as
  * standards are being followed.  (Developer boards sometimes won't.)
  */
@@ -26,6 +28,9 @@ struct musb_hdrc_platform_data {
 	/* for clk_get() */
 	const char	*clock;
 
+	/* OTG Targeted Peripheral List */
+	struct usb_device_id	*otg_tpl;
+
 	/* (HOST or OTG) switch VBUS on/off */
 	int		(*set_vbus)(struct device *dev, int is_on);
 
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index e748030..79c36fc 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -1,5 +1,7 @@
 // include/linux/usb/otg.h
 
+#include <linux/mod_devicetable.h>
+
 /*
  * These APIs may be used between USB controllers.  USB device drivers
  * (for either host or peripheral roles) don't use these calls; they
@@ -57,6 +59,9 @@ struct otg_transceiver {
 	struct usb_bus		*host;
 	struct usb_gadget	*gadget;
 
+	/* OTG Target Peripheral List */
+	struct usb_device_id *otg_tpl;
+
 	/* to pass extra port status to the root hub */
 	u16			port_status;
 	u16			port_change;
-- 
1.5.4.rc3.24.gb53139

