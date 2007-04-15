Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXDOUzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXDOUzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXDOUzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:55:54 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:26742 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753931AbXDOUz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:55:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q4nhwftZ86rPNW8CMBL/dwktErQsXFniEZbwbzeFjPDkDMl6G4zuicL+N7kt5Hm90FU7GSw8OfMJeVdZ59l6skkWrFTStR7bMT2REXdWvw/qc5UxFBLyksGHbNq9DdgQatjSGgM3zytTOvOZtCV7xuqiBgaoEKnz4OqZDbk8dAU=  ;
X-YMail-OSG: TE29SPQVM1k.NNXepBs83bLdQUeyFIFeJdYIqEuq8_9mFxYYnbUll2XtMZlZHszwVZcMqHXhhvvtX5wm6LsZHuoV0qIIvQmFHvKlfEFdSL0v4EPq.fSASKkTy0NXBA--
From: David Brownell <david-b@pacbell.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
Date: Sun, 15 Apr 2007 13:03:27 -0700
User-Agent: KMail/1.7.1
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704102152.21287.david-b@pacbell.net> <1686019041.20070412165702@gmail.com>
In-Reply-To: <1686019041.20070412165702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151303.27867.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To merge, this would be split apart ... what's interesting here is
the way the new leds-gpio driver can be made to talk to leds that
sit across an I2C link.


==========	CUT HERE
This presumes various patches updating:

 - LED framework to support generic GPIOs (in MM and LED queue)

 - LED framework's generic GPIO support to understand that some GPIOs
   can't be directly accessed in timer callbacks (patch submitted)

 - I2C to support "new style" drivers (driver model conformance, in MM
   and i2c queues);

 - Kernel.org to match current OMAP trees (in the works, huge)

 - OMAP to use the "struct gpio_chip" infrastructure for its GPIOs (a
   previous patch in this series)

 - TPS65010 to be such a "new style" I2C driver (blocked waiting for OMAP
   and I2C patches to merge);

Given those prerequisites, this patch:

 * Exposes tps65010 GPIOs and LEDs through the GPIO framework (gaining an
   activity light for CF access)
 
 * Converts the OSK board to use that framework (not quite everywhere; at
   least the ads7846 driver and serial line wakeup still need updating)

 * Removes "old style" OSK led support, except with the Mistral board
   whose red-or-green LED isn't really supported by the new framework

Note that this is the first example of the "I2C GPIO expander" case,
where the GPIOs can't be accessed in non-sleeping contexts.

---
 arch/arm/mach-omap1/board-osk.c       |   66 +++++++++++++++++-------
 arch/arm/mach-omap1/leds-osk.c        |   92 ----------------------------------
 arch/arm/mach-omap1/leds.c            |   15 ++---
 drivers/i2c/chips/tps65010.c          |   59 +++++++++++++++++++++
 include/asm-arm/arch-omap/board-osk.h |   11 ++++
 include/asm-arm/arch-omap/tps65010.h  |   17 ++++++
 6 files changed, 141 insertions(+), 119 deletions(-)

--- osk2.orig/include/asm-arm/arch-omap/tps65010.h	2007-04-15 11:09:12.000000000 -0700
+++ osk2/include/asm-arm/arch-omap/tps65010.h	2007-04-15 11:09:15.000000000 -0700
@@ -152,5 +152,22 @@ extern int tps65010_config_vregs1(unsign
  */
 extern int tps65013_set_low_pwr(unsigned mode);
 
+
+/**
+ * struct tps65010_board - packages GPIO and LED lines
+ * @base: the GPIO number to assign to GPIO-1
+ * @outmask: bit (N-1) is set to allow GPIO-N to be used
+ *	as an (open drain) output
+ *
+ * Board data may be used to package the GPIO (and LED) lines
+ * for use in by the generic GPIO and LED frameworks.  The first
+ * four GPIOs starting at gpio_base are GPIO1..GPIO4; the next
+ * two are LED1..LED2.
+ */
+struct tps65010_board {
+	int			base;
+	unsigned		outmask;
+};
+
 #endif /*  __ASM_ARCH_TPS65010_H */
 
--- osk2.orig/drivers/i2c/chips/tps65010.c	2007-04-15 11:09:12.000000000 -0700
+++ osk2/drivers/i2c/chips/tps65010.c	2007-04-15 11:09:15.000000000 -0700
@@ -34,9 +34,9 @@
 #include <linux/mutex.h>
 
 #include <asm/irq.h>
+#include <asm/gpio.h>
 #include <asm/mach-types.h>
 
-#include <asm/arch/gpio.h>
 #include <asm/arch/mux.h>
 #include <asm/arch/tps65010.h>
 
@@ -91,7 +91,8 @@ struct tps65010 {
 	u8			chgstatus, regstatus, chgconf;
 	u8			nmask1, nmask2;
 
-	/* not currently tracking GPIO state */
+	u8			outmask;
+	struct gpio_chip	chip;
 };
 
 #define	POWER_POLL_DELAY	msecs_to_jiffies(5000)
@@ -454,6 +455,38 @@ static irqreturn_t tps65010_irq(int irq,
 
 /*-------------------------------------------------------------------------*/
 
+/* offsets 0..3 == GPIO1..GPIO4
+ * offsets 4..5 == LED1..LED2 (we set one of the non-BLINK modes)
+ */
+static void
+tps65010_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	if (offset < 4)
+		tps65010_set_gpio_out_value(offset + 1, value);
+	else
+		tps65010_set_led(offset - 3, value ? ON : OFF);
+}
+
+static int
+tps65010_output(struct gpio_chip *chip, unsigned offset, int value)
+{
+	/* GPIOs may be input-only */
+	if (offset < 4) {
+		struct tps65010		*tps;
+
+		tps = container_of(chip, struct tps65010, chip);
+		if (!(tps->outmask & (1 << offset)))
+			return -EINVAL;
+		tps65010_set_gpio_out_value(offset + 1, value);
+	} else
+		tps65010_set_led(offset - 3, value ? ON : OFF);
+
+	return 0;
+}
+
+
+/*-------------------------------------------------------------------------*/
+
 static struct tps65010 *the_tps;
 
 static int __exit tps65010_remove(struct i2c_client *client)
@@ -475,6 +508,7 @@ static int tps65010_probe(struct i2c_cli
 	struct tps65010		*tps;
 	int			status;
 	unsigned long		irqflags;
+	struct tps65010_board	*board = client->dev.platform_data;
 
 	if (the_tps) {
 		dev_dbg(&client->dev, "only one %s for now\n", DRIVER_NAME);
@@ -585,6 +619,27 @@ static int tps65010_probe(struct i2c_cli
 
 	tps->file = debugfs_create_file(DRIVER_NAME, S_IRUGO, NULL,
 				tps, DEBUG_FOPS);
+
+	/* optionally register GPIOs (and leds) */
+	if (board && board->base > 0) {
+		tps->outmask = board->outmask;
+
+		/* tps->chip.get = tps65010_gpio_get; */
+		tps->chip.set = tps65010_gpio_set;
+		/* tps->chip.direction_input = tps65010_input; */
+		tps->chip.direction_output = tps65010_output;
+		tps->chip.base = board->base;
+		tps->chip.name = client->name;
+		/* we don't handle GPIO input irqs (yet?) ... */
+		tps->chip.ngpio = 6;
+		tps->chip.can_sleep = 1;
+
+		status = gpio_chip_declare(&tps->chip);
+		if (status < 0)
+			dev_dbg(&client->dev, "can't declare GPIOs, err %d\n",
+					status);
+	}
+
 	return 0;
 fail1:
 	kfree(tps);
--- osk2.orig/include/asm-arm/arch-omap/board-osk.h	2007-04-15 11:09:12.000000000 -0700
+++ osk2/include/asm-arm/arch-omap/board-osk.h	2007-04-15 11:09:15.000000000 -0700
@@ -32,5 +32,16 @@
 /* At OMAP5912 OSK the Ethernet is directly connected to CS1 */
 #define OMAP_OSK_ETHR_START		0x04800300
 
+/* TPS65010 has four GPIOs.  nPG and LED2 can be treated like GPIOs with
+ * alternate pin configurations for hardware-controlled blinking.
+ */
+#define OSK_TPS_GPIO_BASE		(OMAP_MAX_GPIO_LINES + 16 /* MPUIO */)
+#	define OSK_TPS_GPIO_USB_PWR_EN	(OSK_TPS_GPIO_BASE + 0)
+#	define OSK_TPS_GPIO_LED_D3	(OSK_TPS_GPIO_BASE + 1)
+#	define OSK_TPS_GPIO_LAN_RESET	(OSK_TPS_GPIO_BASE + 2)
+#	define OSK_TPS_GPIO_DSP_PWR_EN	(OSK_TPS_GPIO_BASE + 3)
+#	define OSK_TPS_GPIO_LED_D9	(OSK_TPS_GPIO_BASE + 4)
+#	define OSK_TPS_GPIO_LED_D2	(OSK_TPS_GPIO_BASE + 5)
+
 #endif /*  __ASM_ARCH_OMAP_OSK_H */
 
--- osk2.orig/arch/arm/mach-omap1/board-osk.c	2007-04-15 11:09:12.000000000 -0700
+++ osk2/arch/arm/mach-omap1/board-osk.c	2007-04-15 11:09:15.000000000 -0700
@@ -33,6 +33,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
+#include <linux/leds.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
@@ -182,11 +183,17 @@ static struct platform_device *osk5912_d
 	&osk5912_mcbsp1_device,
 };
 
+static struct tps65010_board tps_board = {
+	.base		= OSK_TPS_GPIO_BASE,
+	.outmask	= 0x0f,
+};
+
 static struct i2c_board_info __initdata osk_i2c_board_info[] = {
 {
 	I2C_BOARD_INFO("tps65010", 0x48),
 	.type		= "tps65010",
 	.irq		= OMAP_GPIO_IRQ(OMAP_MPUIO(1)),
+	.platform_data	= &tps_board,
 },
 #ifdef	CONFIG_OMAP_OSK_MISTRAL
 {
@@ -202,7 +209,7 @@ static struct i2c_board_info __initdata 
 
 static void __init osk_init_smc91x(void)
 {
-	if ((omap_request_gpio(0)) < 0) {
+	if ((gpio_request(0, "smc_irq")) < 0) {
 		printk("Error requesting gpio 0 for smc91x irq\n");
 		return;
 	}
@@ -214,7 +221,7 @@ static void __init osk_init_smc91x(void)
 static void __init osk_init_cf(void)
 {
 	omap_cfg_reg(M7_1610_GPIO62);
-	if ((omap_request_gpio(62)) < 0) {
+	if ((gpio_request(62, "cf_irq")) < 0) {
 		printk("Error requesting gpio 62 for CF irq\n");
 		return;
 	}
@@ -338,7 +345,7 @@ static struct platform_device *mistral_d
 
 static int mistral_get_pendown_state(void)
 {
-	return !omap_get_gpio_datain(4);
+	return !gpio_get_value(4);
 }
 
 static const struct ads7846_platform_data mistral_ts_info = {
@@ -400,10 +407,9 @@ static void __init osk_mistral_init(void
 	omap_cfg_reg(W14_1610_CCP_DATAP);
 
 	/* CAM_PWDN */
-	if (omap_request_gpio(11) == 0) {
+	if (gpio_request(11, "cam_pwdn") == 0) {
 		omap_cfg_reg(N20_1610_GPIO11);
-		omap_set_gpio_direction(11, 0 /* out */);
-		omap_set_gpio_dataout(11, 0 /* off */);
+		gpio_direction_output(11, 0 /* off */);
 	} else
 		pr_debug("OSK+Mistral: CAM_PWDN is awol\n");
 
@@ -416,9 +422,9 @@ static void __init osk_mistral_init(void
 
 	/* the sideways button (SW1) is for use as a "wakeup" button */
 	omap_cfg_reg(N15_1610_MPUIO2);
-	if (omap_request_gpio(OMAP_MPUIO(2)) == 0) {
+	if (gpio_request(OMAP_MPUIO(2), "wakeup") == 0) {
 		int ret = 0;
-		omap_set_gpio_direction(OMAP_MPUIO(2), 1);
+		gpio_direction_input(OMAP_MPUIO(2));
 		set_irq_type(OMAP_GPIO_IRQ(OMAP_MPUIO(2)), IRQT_RISING);
 #ifdef	CONFIG_PM
 		/* share the IRQ in case someone wants to use the
@@ -429,7 +435,7 @@ static void __init osk_mistral_init(void
 				IRQF_SHARED, "mistral_wakeup",
 				&osk_mistral_wake_interrupt);
 		if (ret != 0) {
-			omap_free_gpio(OMAP_MPUIO(2));
+			gpio_free(OMAP_MPUIO(2));
 			printk(KERN_ERR "OSK+Mistral: no wakeup irq, %d?\n",
 				ret);
 		} else
@@ -442,10 +448,8 @@ static void __init osk_mistral_init(void
 	 * board, like the touchscreen, EEPROM, and wakeup (!) switch.
 	 */
 	omap_cfg_reg(PWL);
-	if (omap_request_gpio(2) == 0) {
-		omap_set_gpio_direction(2, 0 /* out */);
-		omap_set_gpio_dataout(2, 1 /* on */);
-	}
+	if (gpio_request(2, "lcd_pwdn") == 0)
+		gpio_direction_output(2, 1 /* on */);
 
 	platform_add_devices(mistral_devices, ARRAY_SIZE(mistral_devices));
 }
@@ -474,8 +478,8 @@ static void __init osk_init(void)
 
 	/* irq for tps65010 chip */
 	// omap_cfg_reg(U19_1610_MPUIO1);
-	omap_request_gpio(OMAP_MPUIO(1));
-	omap_set_gpio_direction(OMAP_MPUIO(1), 1);
+	if (gpio_request(OMAP_MPUIO(1), "tps65010"))
+		gpio_direction_input(OMAP_MPUIO(1));
 
 	i2c_register_board_info(1, osk_i2c_board_info,
 			ARRAY_SIZE(osk_i2c_board_info));
@@ -490,6 +494,26 @@ static void __init osk_map_io(void)
 }
 
 #ifdef CONFIG_TPS65010
+
+static struct gpio_led tps_leds[] = {
+	{ .gpio = OSK_TPS_GPIO_LED_D9, .name = "d9:green",
+			.default_trigger = "ide-disk", /* CF */ },
+	{ .gpio = OSK_TPS_GPIO_LED_D2, .name = "d2:green", },
+	{ .gpio = OSK_TPS_GPIO_LED_D3, .name = "d3:green", .active_low = 1,
+			.default_trigger = "heartbeat", },
+};
+
+static struct gpio_led_platform_data tps_led_data = {
+	.num_leds	= ARRAY_SIZE(tps_leds),
+	.leds		= tps_leds,
+};
+
+static struct platform_device tps_led_dev = {
+	.name			= "leds-gpio",
+	.id			= -1,
+	.dev.platform_data	= &tps_led_data,
+};
+
 static int __init osk_tps_init(void)
 {
 	if (!machine_is_omap_osk())
@@ -504,16 +528,20 @@ static int __init osk_tps_init(void)
 	/* Set GPIO 1 HIGH to disable VBUS power supply;
 	 * OHCI driver powers it up/down as needed.
 	 */
-	tps65010_set_gpio_out_value(GPIO1, HIGH);
+	if (gpio_request(OSK_TPS_GPIO_USB_PWR_EN, "vbus_dis") == 0)
+		gpio_direction_output(OSK_TPS_GPIO_USB_PWR_EN, 1);
 
 	/* Set GPIO 2 low to turn on LED D3 */
 	tps65010_set_gpio_out_value(GPIO2, HIGH);
 
 	/* Set GPIO 3 low to take ethernet out of reset */
-	tps65010_set_gpio_out_value(GPIO3, LOW);
+	if (gpio_request(OSK_TPS_GPIO_LAN_RESET, "lan_reset") == 0)
+		gpio_direction_output(OSK_TPS_GPIO_LAN_RESET, 0);
 
 	/* gpio4 for VDD_DSP */
-	// FIXME power DSP iff it's configured
+	/* FIXME power DSP iff it's configured */
+	if (gpio_request(OSK_TPS_GPIO_DSP_PWR_EN, "dsp_pwr_en") == 0)
+		gpio_direction_output(OSK_TPS_GPIO_DSP_PWR_EN, 1);
 
 	/* Enable LOW_PWR */
 	tps65010_set_low_pwr(ON);
@@ -522,7 +550,7 @@ static int __init osk_tps_init(void)
 	tps65010_config_vregs1(TPS_LDO2_ENABLE | TPS_VLDO2_3_0V
 			| TPS_LDO1_ENABLE);
 
-	return 0;
+	return platform_device_register(&tps_led_dev);
 }
 fs_initcall(osk_tps_init);
 #endif
--- osk2.orig/arch/arm/mach-omap1/leds-osk.c	2007-04-15 11:09:12.000000000 -0700
+++ osk2/arch/arm/mach-omap1/leds-osk.c	2007-04-15 11:09:15.000000000 -0700
@@ -1,7 +1,7 @@
 /*
  * linux/arch/arm/mach-omap1/leds-osk.c
  *
- * LED driver for OSK, and optionally Mistral QVGA, boards
+ * LED driver for OSK's optional Mistral QVGA board
  */
 #include <linux/init.h>
 #include <linux/workqueue.h>
@@ -11,7 +11,6 @@
 #include <asm/system.h>
 
 #include <asm/arch/gpio.h>
-#include <asm/arch/tps65010.h>
 
 #include "leds.h"
 
@@ -20,51 +19,11 @@
 #define LED_STATE_CLAIMED	(1 << 1)
 static u8 led_state;
 
-#define	GREEN_LED		(1 << 0)	/* TPS65010 LED1 */
-#define	AMBER_LED		(1 << 1)	/* TPS65010 LED2 */
-#define	RED_LED			(1 << 2)	/* TPS65010 GPIO2 */
 #define	TIMER_LED		(1 << 3)	/* Mistral board */
 #define	IDLE_LED		(1 << 4)	/* Mistral board */
 static u8 hw_led_state;
 
 
-/* TPS65010 leds are changed using i2c -- from a task context.
- * Using one of these for the "idle" LED would be impractical...
- */
-#define	TPS_LEDS	(GREEN_LED | RED_LED | AMBER_LED)
-
-static u8 tps_leds_change;
-
-static void tps_work(struct work_struct *unused)
-{
-	for (;;) {
-		u8	leds;
-
-		local_irq_disable();
-		leds = tps_leds_change;
-		tps_leds_change = 0;
-		local_irq_enable();
-
-		if (!leds)
-			break;
-
-		/* careful:  the set_led() value is on/off/blink */
-		if (leds & GREEN_LED)
-			tps65010_set_led(LED1, !!(hw_led_state & GREEN_LED));
-		if (leds & AMBER_LED)
-			tps65010_set_led(LED2, !!(hw_led_state & AMBER_LED));
-
-		/* the gpio led doesn't have that issue */
-		if (leds & RED_LED)
-			tps65010_set_gpio_out_value(GPIO2,
-					!(hw_led_state & RED_LED));
-	}
-}
-
-static DECLARE_WORK(work, tps_work);
-
-#ifdef	CONFIG_OMAP_OSK_MISTRAL
-
 /* For now, all system indicators require the Mistral board, since that
  * LED can be manipulated without a task context.  This LED is either red,
  * or green, but not both; it can't give the full "disco led" effect.
@@ -88,24 +47,19 @@ static void mistral_setled(void)
 	omap_set_gpio_dataout(GPIO_LED_RED, red);
 }
 
-#endif
-
 void osk_leds_event(led_event_t evt)
 {
 	unsigned long	flags;
-	u16		leds;
 
 	local_irq_save(flags);
 
 	if (!(led_state & LED_STATE_ENABLED) && evt != led_start)
 		goto done;
 
-	leds = hw_led_state;
 	switch (evt) {
 	case led_start:
 		led_state |= LED_STATE_ENABLED;
 		hw_led_state = 0;
-		leds = ~0;
 		break;
 
 	case led_halted:
@@ -118,7 +72,6 @@ void osk_leds_event(led_event_t evt)
 	case led_claim:
 		led_state |= LED_STATE_CLAIMED;
 		hw_led_state = 0;
-		leds = ~0;
 		break;
 
 	case led_release:
@@ -126,8 +79,6 @@ void osk_leds_event(led_event_t evt)
 		hw_led_state = 0;
 		break;
 
-#ifdef	CONFIG_OMAP_OSK_MISTRAL
-
 	case led_timer:
 		hw_led_state ^= TIMER_LED;
 		mistral_setled();
@@ -143,51 +94,10 @@ void osk_leds_event(led_event_t evt)
 		mistral_setled();
 		break;
 
-#endif	/* CONFIG_OMAP_OSK_MISTRAL */
-
-	/* "green" == tps LED1 (leftmost, normally power-good)
-	 * works only with DC adapter, not on battery power!
-	 */
-	case led_green_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= GREEN_LED;
-		break;
-	case led_green_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~GREEN_LED;
-		break;
-
-	/* "amber" == tps LED2 (middle) */
-	case led_amber_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= AMBER_LED;
-		break;
-	case led_amber_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~AMBER_LED;
-		break;
-
-	/* "red" == LED on tps gpio3 (rightmost) */
-	case led_red_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= RED_LED;
-		break;
-	case led_red_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~RED_LED;
-		break;
-
 	default:
 		break;
 	}
 
-	leds ^= hw_led_state;
-	leds &= TPS_LEDS;
-	if (leds && (led_state & LED_STATE_CLAIMED)) {
-		tps_leds_change |= leds;
-		schedule_work(&work);
-	}
-
 done:
 	local_irq_restore(flags);
 }
--- osk2.orig/arch/arm/mach-omap1/leds.c	2007-04-15 11:09:12.000000000 -0700
+++ osk2/arch/arm/mach-omap1/leds.c	2007-04-15 11:09:15.000000000 -0700
@@ -5,11 +5,12 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/list.h>
 
 #include <asm/leds.h>
+#include <asm/gpio.h>
 #include <asm/mach-types.h>
 
-#include <asm/arch/gpio.h>
 #include <asm/arch/mux.h>
 
 #include "leds.h"
@@ -25,17 +26,17 @@ omap_leds_init(void)
 			|| machine_is_omap_perseus2())
 		leds_event = h2p2_dbg_leds_event;
 
+#ifdef	CONFIG_OMAP_OSK_MISTRAL
 	else if (machine_is_omap_osk())
 		leds_event = osk_leds_event;
+#endif
 
 	else
 		return -1;
 
 	if (machine_is_omap_h2()
 			|| machine_is_omap_h3()
-#ifdef	CONFIG_OMAP_OSK_MISTRAL
 			|| machine_is_omap_osk()
-#endif
 			) {
 
 		/* LED1/LED2 pins can be used as GPIO (as done here), or by
@@ -47,14 +48,14 @@ omap_leds_init(void)
 		 * that's a different kind of LED (just one color at a time).
 		 */
 		omap_cfg_reg(P18_1610_GPIO3);
-		if (omap_request_gpio(3) == 0)
-			omap_set_gpio_direction(3, 0);
+		if (gpio_request(3, "timer_led") == 0)
+			gpio_direction_output(3, 0);
 		else
 			printk(KERN_WARNING "LED: can't get GPIO3/red?\n");
 
 		omap_cfg_reg(MPUIO4);
-		if (omap_request_gpio(OMAP_MPUIO(4)) == 0)
-			omap_set_gpio_direction(OMAP_MPUIO(4), 0);
+		if (gpio_request(OMAP_MPUIO(4), "idle_led") == 0)
+			gpio_direction_output(OMAP_MPUIO(4), 0);
 		else
 			printk(KERN_WARNING "LED: can't get MPUIO4/green?\n");
 	}
