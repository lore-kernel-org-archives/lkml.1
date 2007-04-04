Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbXDDSgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbXDDSgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXDDSgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:36:07 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36759 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbXDDSIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:08:12 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Date: Wed,  4 Apr 2007 14:05:04 -0400
Message-Id: <11757100281957-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1175710026446-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

This adds generic support for the "debug board" LEDs used by most of
TI's OMAP reference boards, and board-specific support for the H4.

It's derived from the not-as-generic stuff used by OMAP1 H2/H3/P2.
Those should be able to switch easily to this version, and clean up
some of the omap1-specific code.

In addition to H4 support, one key improvement is supporting not just
the "old" ARM debug LED API (with timer and idle LEDs, plus four that
can be handy for kernel debugging), but it also supports the "new"
generic LED API (most useful for usermode stuff IMO).  Either or both
APIs can be enabled.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig     |    1 +
 arch/arm/mach-omap2/board-h4.c  |   14 ++
 arch/arm/plat-omap/Kconfig      |    5 +
 arch/arm/plat-omap/Makefile     |    2 +-
 arch/arm/plat-omap/debug-leds.c |  319 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 340 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index aab97cc..2a1aca7 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -20,6 +20,7 @@ config MACH_OMAP_GENERIC
 config MACH_OMAP_H4
 	bool "OMAP 2420 H4 board"
 	depends on ARCH_OMAP2 && ARCH_OMAP24XX
+	select OMAP_DEBUG_LEDS if LEDS || LEDS_OMAP_DEBUG
 
 config MACH_OMAP_APOLLON
 	bool "OMAP 2420 Apollon board"
diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index 1e7ed6d..452193f 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -266,12 +266,26 @@ static struct platform_device h4_lcd_device = {
 	.id		= -1,
 };
 
+static struct resource h4_led_resources[] = {
+	[0] = {
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device h4_led_device = {
+	.name		= "omap_dbg_led",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(h4_led_resources),
+	.resource	= h4_led_resources,
+};
+
 static struct platform_device *h4_devices[] __initdata = {
 	&h4_smc91x_device,
 	&h4_flash_device,
 	&h4_irda_device,
 	&h4_kp_device,
 	&h4_lcd_device,
+	&h4_led_device,
 };
 
 static inline void __init h4_init_smc91x(void)
diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index f2dc363..ce8bc33 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -19,6 +19,11 @@ endchoice
 
 comment "OMAP Feature Selections"
 
+config OMAP_DEBUG_LEDS
+	bool
+	help
+	  For debug card leds on TI reference boards.
+
 config OMAP_RESET_CLOCKS
 	bool "Reset unused clocks during boot"
 	depends on ARCH_OMAP
diff --git a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
index 2896b45..4ce277d 100644
--- a/arch/arm/plat-omap/Makefile
+++ b/arch/arm/plat-omap/Makefile
@@ -16,4 +16,4 @@ obj-$(CONFIG_ARCH_OMAP16XX) += ocpi.o
 
 obj-$(CONFIG_CPU_FREQ) += cpu-omap.o
 obj-$(CONFIG_OMAP_DM_TIMER) += dmtimer.o
-
+obj-$(CONFIG_OMAP_DEBUG_LEDS) += debug-leds.o
diff --git a/arch/arm/plat-omap/debug-leds.c b/arch/arm/plat-omap/debug-leds.c
new file mode 100644
index 0000000..511d6a5
--- /dev/null
+++ b/arch/arm/plat-omap/debug-leds.c
@@ -0,0 +1,319 @@
+/*
+ * linux/arch/arm/plat-omap/debug-leds.c
+ *
+ * Copyright 2003 by Texas Instruments Incorporated
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+
+#include <asm/io.h>
+#include <asm/hardware.h>
+#include <asm/leds.h>
+#include <asm/system.h>
+#include <asm/mach-types.h>
+
+#include <asm/arch/fpga.h>
+#include <asm/arch/gpio.h>
+
+
+/* Many OMAP development platforms reuse the same "debug board"; these
+ * platforms include H2, H3, H4, and Perseus2.  There are 16 LEDs on the
+ * debug board (all green), accessed through FPGA registers.
+ *
+ * The "surfer" expansion board and H2 sample board also have two-color
+ * green+red LEDs (in parallel), used here for timer and idle indicators
+ * in preference to the ones on the debug board, for a "Disco LED" effect.
+ *
+ * This driver exports either the original ARM LED API, the new generic
+ * one, or both.
+ */
+
+static spinlock_t			lock;
+static struct h2p2_dbg_fpga __iomem	*fpga;
+static u16				led_state, hw_led_state;
+
+
+#ifdef	CONFIG_LEDS
+#define old_led_api()	1
+#else
+#define old_led_api()	0
+#endif
+
+#ifdef	CONFIG_LEDS_OMAP_DEBUG
+#define new_led_api()	1
+#else
+#define new_led_api()	0
+#endif
+
+
+/*-------------------------------------------------------------------------*/
+
+/* original ARM debug LED API:
+ *  - timer and idle leds (some boards use non-FPGA leds here);
+ *  - up to 4 generic leds, easily accessed in-kernel (any context)
+ */
+
+#define GPIO_LED_RED		3
+#define GPIO_LED_GREEN		OMAP_MPUIO(4)
+
+#define LED_STATE_ENABLED	0x01
+#define LED_STATE_CLAIMED	0x02
+#define LED_TIMER_ON		0x04
+
+#define GPIO_IDLE		GPIO_LED_GREEN
+#define GPIO_TIMER		GPIO_LED_RED
+
+static void h2p2_dbg_leds_event(led_event_t evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lock, flags);
+
+	if (!(led_state & LED_STATE_ENABLED) && evt != led_start)
+		goto done;
+
+	switch (evt) {
+	case led_start:
+		if (fpga)
+			led_state |= LED_STATE_ENABLED;
+		break;
+
+	case led_stop:
+	case led_halted:
+		/* all leds off during suspend or shutdown */
+
+		if (!(machine_is_omap_perseus2() || machine_is_omap_h4())) {
+			omap_set_gpio_dataout(GPIO_TIMER, 0);
+			omap_set_gpio_dataout(GPIO_IDLE, 0);
+		}
+
+		__raw_writew(~0, &fpga->leds);
+		led_state &= ~LED_STATE_ENABLED;
+		goto done;
+
+	case led_claim:
+		led_state |= LED_STATE_CLAIMED;
+		hw_led_state = 0;
+		break;
+
+	case led_release:
+		led_state &= ~LED_STATE_CLAIMED;
+		break;
+
+#ifdef CONFIG_LEDS_TIMER
+	case led_timer:
+		led_state ^= LED_TIMER_ON;
+
+		if (machine_is_omap_perseus2() || machine_is_omap_h4())
+			hw_led_state ^= H2P2_DBG_FPGA_P2_LED_TIMER;
+		else {
+			omap_set_gpio_dataout(GPIO_TIMER,
+					led_state & LED_TIMER_ON);
+			goto done;
+		}
+
+		break;
+#endif
+
+#ifdef CONFIG_LEDS_CPU
+	/* LED lit iff busy */
+	case led_idle_start:
+		if (machine_is_omap_perseus2() || machine_is_omap_h4())
+			hw_led_state &= ~H2P2_DBG_FPGA_P2_LED_IDLE;
+		else {
+			omap_set_gpio_dataout(GPIO_IDLE, 1);
+			goto done;
+		}
+
+		break;
+
+	case led_idle_end:
+		if (machine_is_omap_perseus2() || machine_is_omap_h4())
+			hw_led_state |= H2P2_DBG_FPGA_P2_LED_IDLE;
+		else {
+			omap_set_gpio_dataout(GPIO_IDLE, 0);
+			goto done;
+		}
+
+		break;
+#endif
+
+	case led_green_on:
+		hw_led_state |= H2P2_DBG_FPGA_LED_GREEN;
+		break;
+	case led_green_off:
+		hw_led_state &= ~H2P2_DBG_FPGA_LED_GREEN;
+		break;
+
+	case led_amber_on:
+		hw_led_state |= H2P2_DBG_FPGA_LED_AMBER;
+		break;
+	case led_amber_off:
+		hw_led_state &= ~H2P2_DBG_FPGA_LED_AMBER;
+		break;
+
+	case led_red_on:
+		hw_led_state |= H2P2_DBG_FPGA_LED_RED;
+		break;
+	case led_red_off:
+		hw_led_state &= ~H2P2_DBG_FPGA_LED_RED;
+		break;
+
+	case led_blue_on:
+		hw_led_state |= H2P2_DBG_FPGA_LED_BLUE;
+		break;
+	case led_blue_off:
+		hw_led_state &= ~H2P2_DBG_FPGA_LED_BLUE;
+		break;
+
+	default:
+		break;
+	}
+
+
+	/*
+	 *  Actually burn the LEDs
+	 */
+	if (led_state & LED_STATE_ENABLED)
+		__raw_writew(~hw_led_state, &fpga->leds);
+
+done:
+	spin_unlock_irqrestore(&lock, flags);
+}
+
+/*-------------------------------------------------------------------------*/
+
+/* "new" LED API
+ *  - with syfs access and generic triggering
+ *  - not readily accessible to in-kernel drivers
+ */
+
+struct dbg_led {
+	struct led_classdev	cdev;
+	u16			mask;
+};
+
+static struct dbg_led dbg_leds[] = {
+	/* REVISIT at least H2 uses different timer & cpu leds... */
+#ifndef CONFIG_LEDS_TIMER
+	{ .mask = 1 << 0,  .cdev.name =  "d4:green", },		/* timer */
+#endif
+#ifndef CONFIG_LEDS_CPU
+	{ .mask = 1 << 1,  .cdev.name =  "d5:green", },		/* !idle */
+#endif
+	{ .mask = 1 << 2,  .cdev.name =  "d6:green", },
+	{ .mask = 1 << 3,  .cdev.name =  "d7:green", },
+
+	{ .mask = 1 << 4,  .cdev.name =  "d8:green", },
+	{ .mask = 1 << 5,  .cdev.name =  "d9:green", },
+	{ .mask = 1 << 6,  .cdev.name = "d10:green", },
+	{ .mask = 1 << 7,  .cdev.name = "d11:green", },
+
+	{ .mask = 1 << 8,  .cdev.name = "d12:green", },
+	{ .mask = 1 << 9,  .cdev.name = "d13:green", },
+	{ .mask = 1 << 10, .cdev.name = "d14:green", },
+	{ .mask = 1 << 11, .cdev.name = "d15:green", },
+
+#ifndef	CONFIG_LEDS
+	{ .mask = 1 << 12, .cdev.name = "d16:green", },
+	{ .mask = 1 << 13, .cdev.name = "d17:green", },
+	{ .mask = 1 << 14, .cdev.name = "d18:green", },
+	{ .mask = 1 << 15, .cdev.name = "d19:green", },
+#endif
+};
+
+static void
+fpga_led_set(struct led_classdev *cdev, enum led_brightness value)
+{
+	struct dbg_led	*led = container_of(cdev, struct dbg_led, cdev);
+	unsigned long	flags;
+
+	spin_lock_irqsave(&lock, flags);
+	if (value == LED_OFF)
+		hw_led_state &= ~led->mask;
+	else
+		hw_led_state |= led->mask;
+	__raw_writew(~hw_led_state, &fpga->leds);
+	spin_unlock_irqrestore(&lock, flags);
+}
+
+static void __init newled_init(struct device *dev)
+{
+	unsigned	i;
+	struct dbg_led	*led;
+	int		status;
+
+	for (i = 0, led = dbg_leds; i < ARRAY_SIZE(dbg_leds); i++, led++) {
+		led->cdev.brightness_set = fpga_led_set;
+		status = led_classdev_register(dev, &led->cdev);
+		if (status < 0)
+			break;
+	}
+	return;
+}
+
+
+/*-------------------------------------------------------------------------*/
+
+static int /* __init */ fpga_probe(struct platform_device *pdev)
+{
+	struct resource	*iomem;
+
+	spin_lock_init(&lock);
+
+	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem)
+		return -ENODEV;
+
+	fpga = ioremap(iomem->start, H2P2_DBG_FPGA_SIZE);
+	__raw_writew(~0, &fpga->leds);
+
+	if (old_led_api()) {
+		leds_event = h2p2_dbg_leds_event;
+		leds_event(led_start);
+	}
+
+	if (new_led_api()) {
+		newled_init(&pdev->dev);
+	}
+
+	return 0;
+}
+
+static int fpga_suspend_late(struct platform_device *pdev, pm_message_t mesg)
+{
+	__raw_writew(~0, &fpga->leds);
+	return 0;
+}
+
+static int fpga_resume_early(struct platform_device *pdev)
+{
+	__raw_writew(~hw_led_state, &fpga->leds);
+	return 0;
+}
+
+
+static struct platform_driver led_driver = {
+	.driver.name	= "omap_dbg_led",
+	.probe		= fpga_probe,
+	.suspend_late	= fpga_suspend_late,
+	.resume_early	= fpga_resume_early,
+};
+
+static int __init fpga_init(void)
+{
+	if (machine_is_omap_h4()
+			|| machine_is_omap_h3()
+			|| machine_is_omap_h2()
+			|| machine_is_omap_perseus2()
+			)
+		return platform_driver_register(&led_driver);
+	return 0;
+}
+fs_initcall(fpga_init);
-- 
1.4.4.2

