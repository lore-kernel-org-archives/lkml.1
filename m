Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbZL2IAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbZL2IAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 03:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZL2IAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 03:00:23 -0500
Received: from vps2.mechanicalrealm.com ([66.216.20.21]:34400 "EHLO
	zinan.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZL2IAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 03:00:22 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 03:00:22 EST
From: "Luke-Jr" <luke@dashjr.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP2: add USB platform data and initialization for Nokia N800 and N810
Date: Tue, 29 Dec 2009 01:52:04 -0600
User-Agent: KMail/1.12.3 (Linux/2.6.32-gentoo; KDE/4.3.3; x86_64; ; )
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Kalle Valo <kalle.valo@iki.fi>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912290152.16357.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform data and initialization for USB on Nokia N800 and N810 devices
via the TUSB6010 chipset.

Tested on Nokia N810 in Linux-OMAP tree. Mainline is not bootable yet.

Signed-off-by: Luke Dashjr <luke_linuxkern@dashjr.org>
---
 arch/arm/mach-omap2/Kconfig          |    5 +
 arch/arm/mach-omap2/Makefile         |    1 +
 arch/arm/mach-omap2/board-n8x0-usb.c |  173 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-n8x0.c     |    8 ++
 4 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-n8x0-usb.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 10eafa7..e3c913c 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -117,6 +117,11 @@ config MACH_NOKIA_N8X0
 	select MACH_NOKIA_N810
 	select MACH_NOKIA_N810_WIMAX
 
+config MACH_NOKIA_N8X0_USB
+	bool
+	depends on MACH_NOKIA_N8X0 && MACH_OMAP2_TUSB6010
+	default y
+
 config MACH_NOKIA_RX51
 	bool "Nokia RX-51 board"
 	depends on ARCH_OMAP3 && ARCH_OMAP34XX
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index b32678b..e890b2b 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o \
 obj-$(CONFIG_MACH_OMAP_3430SDP)		+= board-3430sdp.o \
 					   mmc-twl4030.o
 obj-$(CONFIG_MACH_NOKIA_N8X0)		+= board-n8x0.o
+obj-$(CONFIG_MACH_NOKIA_N8X0_USB)	+= board-n8x0-usb.o
 obj-$(CONFIG_MACH_NOKIA_RX51)		+= board-rx51.o \
 					   board-rx51-sdram.o \
 					   board-rx51-peripherals.o \
diff --git a/arch/arm/mach-omap2/board-n8x0-usb.c b/arch/arm/mach-omap2/board-n8x0-usb.c
new file mode 100644
index 0000000..2254ebd
--- /dev/null
+++ b/arch/arm/mach-omap2/board-n8x0-usb.c
@@ -0,0 +1,173 @@
+/*
+ * linux/arch/arm/mach-omap2/board-n8x0-usb.c
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Author: Juha Yrjola
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/usb/musb.h>
+
+#include <plat/gpmc.h>
+
+#define TUSB_ASYNC_CS		1
+#define TUSB_SYNC_CS		4
+#define GPIO_TUSB_INT		58
+#define GPIO_TUSB_ENABLE	0
+
+static int tusb_set_power(int state);
+static int tusb_set_clock(struct clk *osc_ck, int state);
+
+#if	defined(CONFIG_USB_MUSB_OTG)
+#	define BOARD_MODE	MUSB_OTG
+#elif	defined(CONFIG_USB_MUSB_PERIPHERAL)
+#	define BOARD_MODE	MUSB_PERIPHERAL
+#else	/* defined(CONFIG_USB_MUSB_HOST) */
+#	define BOARD_MODE	MUSB_HOST
+#endif
+
+static struct musb_hdrc_eps_bits musb_eps[] = {
+	{	"ep1_tx", 5,	},
+	{	"ep1_rx", 5,	},
+	{	"ep2_tx", 5,	},
+	{	"ep2_rx", 5,	},
+	{	"ep3_tx", 3,	},
+	{	"ep3_rx", 3,	},
+	{	"ep4_tx", 3,	},
+	{	"ep4_rx", 3,	},
+	{	"ep5_tx", 2,	},
+	{	"ep5_rx", 2,	},
+	{	"ep6_tx", 2,	},
+	{	"ep6_rx", 2,	},
+	{	"ep7_tx", 2,	},
+	{	"ep7_rx", 2,	},
+	{	"ep8_tx", 2,	},
+	{	"ep8_rx", 2,	},
+	{	"ep9_tx", 2,	},
+	{	"ep9_rx", 2,	},
+	{	"ep10_tx", 2,	},
+	{	"ep10_rx", 2,	},
+	{	"ep11_tx", 2,	},
+	{	"ep11_rx", 2,	},
+	{	"ep12_tx", 2,	},
+	{	"ep12_rx", 2,	},
+	{	"ep13_tx", 2,	},
+	{	"ep13_rx", 2,	},
+	{	"ep14_tx", 2,	},
+	{	"ep14_rx", 2,	},
+	{	"ep15_tx", 2,	},
+	{	"ep15_rx", 2,	},
+};
+
+static struct musb_hdrc_config musb_config = {
+	.multipoint	= 1,
+	.dyn_fifo	= 1,
+	.soft_con	= 1,
+	.dma		= 1,
+	.num_eps	= 16,
+	.dma_channels	= 7,
+	.ram_bits	= 12,
+	.eps_bits	= musb_eps,
+};
+
+static struct musb_hdrc_platform_data tusb_data = {
+	.mode		= BOARD_MODE,
+	.set_power	= tusb_set_power,
+	.set_clock	= tusb_set_clock,
+	.min_power	= 25,	/* x2 = 50 mA drawn from VBUS as peripheral */
+	.power		= 100,	/* Max 100 mA VBUS for host mode */
+	.clock		= "osc_ck",
+	.config		= &musb_config,
+};
+
+/*
+ * Enable or disable power to TUSB6010. When enabling, turn on 3.3 V and
+ * 1.5 V voltage regulators of PM companion chip. Companion chip will then
+ * provide then PGOOD signal to TUSB6010 which will release it from reset.
+ */
+static int tusb_set_power(int state)
+{
+	int i, retval = 0;
+
+	if (state) {
+		gpio_set_value(GPIO_TUSB_ENABLE, 1);
+		msleep(1);
+
+		/* Wait until TUSB6010 pulls INT pin down */
+		i = 100;
+		while (i && gpio_get_value(GPIO_TUSB_INT)) {
+			msleep(1);
+			i--;
+		}
+
+		if (!i) {
+			printk(KERN_ERR "tusb: powerup failed\n");
+			retval = -ENODEV;
+		}
+	} else {
+		gpio_set_value(GPIO_TUSB_ENABLE, 0);
+		msleep(10);
+	}
+
+	return retval;
+}
+
+static int		osc_ck_on;
+
+static int tusb_set_clock(struct clk *osc_ck, int state)
+{
+	if (state) {
+		if (osc_ck_on > 0)
+			return -ENODEV;
+
+		clk_enable(osc_ck);
+		osc_ck_on = 1;
+	} else {
+		if (osc_ck_on == 0)
+			return -ENODEV;
+
+		clk_disable(osc_ck);
+		osc_ck_on = 0;
+	}
+
+	return 0;
+}
+
+void __init n8x0_usb_init(void)
+{
+	int ret = 0;
+	static char	announce[] __initdata = KERN_INFO "TUSB 6010\n";
+
+	/* PM companion chip power control pin */
+	ret = gpio_request(GPIO_TUSB_ENABLE, "TUSB6010 enable");
+	if (ret != 0) {
+		printk(KERN_ERR "Could not get TUSB power GPIO%i\n",
+		       GPIO_TUSB_ENABLE);
+		return;
+	}
+	gpio_direction_output(GPIO_TUSB_ENABLE, 0);
+
+	tusb_set_power(0);
+
+	ret = tusb6010_setup_interface(&tusb_data, TUSB6010_REFCLK_19, 2,
+					TUSB_ASYNC_CS, TUSB_SYNC_CS,
+					GPIO_TUSB_INT, 0x3f);
+	if (ret != 0)
+		goto err;
+
+	printk(announce);
+
+	return;
+
+err:
+	gpio_free(GPIO_TUSB_ENABLE);
+}
diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 764ab1e..c9395e1 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -109,8 +109,16 @@ static void __init n8x0_init_irq(void)
 	omap_gpio_init();
 }
 
+#ifdef CONFIG_MACH_NOKIA_N8X0_LCD
+extern void n8x0_usb_init(void);
+#else
+static inline void n8x0_usb_init (void) {}
+#endif
+
 static void __init n8x0_init_machine(void)
 {
+	n8x0_usb_init();
+
 	/* FIXME: add n810 spi devices */
 	spi_register_board_info(n800_spi_board_info,
 				ARRAY_SIZE(n800_spi_board_info));
-- 
1.6.4.4

