Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZLHORO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZLHORO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZLHORK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:17:10 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47006 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbZLHORD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ieQTJanYGX48uuyocrSToB6ME7Q2BL5TAHp3wiAP9ByMc+eUAAiySCCCmz4KIGx3JC
         8k1vH/pmYFTBsuyMR3/oPyP3baW8XWncgHpLK+J8EtkL5QV17Hje9qAQTZ2iNTrtuGK4
         hHWC8wkhUQNaOt7a4v4utgQpma+M0ekdLz6gI=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v9 8/8] Loongson: YeeLoong: add input/hotkey driver
Date: Tue,  8 Dec 2009 22:15:56 +0800
Message-Id: <e6d590fa37e6003dd482918fdef02c1fc127d6c8.1260281599.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <6af33d6c42ba4de9eea27316c64f81b96e01c948.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260254344.git.wuzhangjin@gmail.com>
 <39d232e3f8359e9c11bad7536f0162444401ec94.1260281599.git.wuzhangjin@gmail.com>
 <7676d8397e593dbec0d40e24429b7ccbcecfa588.1260281599.git.wuzhangjin@gmail.com>
 <4d821efaecc3dee0b9124119507a694e81572437.1260281599.git.wuzhangjin@gmail.com>
 <5c426a5091bee3e4483fc0b93f26359e2840428b.1260281599.git.wuzhangjin@gmail.com>
 <5e9acb4cd757075f617daa45cbd6f5fad94678ac.1260281599.git.wuzhangjin@gmail.com>
 <234c5ecd475b05e3eb17ead3ae107cfe3426e0e0.1260281599.git.wuzhangjin@gmail.com>
 <6af33d6c42ba4de9eea27316c64f81b96e01c948.1260281599.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260281599.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch adds Hotkey Driver, which will do related actions for The
hotkey event(/sys/class/input) and report the corresponding input keys
to the user-space applications.

[NOTE:

This patch is based on the sparse keymap library in:

git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input next

of Dmitry Torokhov. that sparse keymap support is also queued for
2.6.33. Before the above branch is pulled by linus, this patch is not
appliable.]

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/include/asm/mach-loongson/loongson.h |    6 +
 arch/mips/loongson/common/cmdline.c            |    8 +
 drivers/platform/mips/Kconfig                  |    2 +
 drivers/platform/mips/yeeloong_laptop.c        |  412 ++++++++++++++++++++++++
 4 files changed, 428 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/mach-loongson/loongson.h b/arch/mips/include/asm/mach-loongson/loongson.h
index ee8bc83..13e208e 100644
--- a/arch/mips/include/asm/mach-loongson/loongson.h
+++ b/arch/mips/include/asm/mach-loongson/loongson.h
@@ -43,6 +43,12 @@ static inline void prom_init_uart_base(void)
 #endif
 }
 
+/*
+ * Copy kernel command line from arcs_cmdline
+ */
+#include <asm/setup.h>
+extern char loongson_cmdline[COMMAND_LINE_SIZE];
+
 /* irq operation functions */
 extern void bonito_irqdispatch(void);
 extern void __init bonito_irq_init(void);
diff --git a/arch/mips/loongson/common/cmdline.c b/arch/mips/loongson/common/cmdline.c
index 7ad47f2..617faee 100644
--- a/arch/mips/loongson/common/cmdline.c
+++ b/arch/mips/loongson/common/cmdline.c
@@ -17,6 +17,7 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  */
+#include <linux/module.h>
 #include <asm/bootinfo.h>
 
 #include <loongson.h>
@@ -25,6 +26,10 @@ int prom_argc;
 /* pmon passes arguments in 32bit pointers */
 int *_prom_argv;
 
+/* the kernel command line copied from arcs_cmdline */
+char loongson_cmdline[COMMAND_LINE_SIZE];
+EXPORT_SYMBOL(loongson_cmdline);
+
 void __init prom_init_cmdline(void)
 {
 	int i;
@@ -51,4 +56,7 @@ void __init prom_init_cmdline(void)
 		strcat(arcs_cmdline, " root=/dev/hda1");
 
 	prom_init_machtype();
+
+	/* copy arcs_cmdline into loongson_cmdline */
+	strncpy(loongson_cmdline, arcs_cmdline, COMMAND_LINE_SIZE);
 }
diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index e2dbe28..8262dff 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -22,6 +22,8 @@ config LEMOTE_YEELOONG2F
 	select APM_EMULATION
 	select HWMON
 	select VIDEO_OUTPUT_CONTROL
+	select INPUT_SPARSEKMAP
+	depends on INPUT
 	help
 	  YeeLoong netbook is a mini laptop made by Lemote, which is basically
 	  compatible to FuLoong2F mini PC, but it has an extra Embedded
diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
index baf3e81..ce3a7e8 100644
--- a/drivers/platform/mips/yeeloong_laptop.c
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -17,7 +17,14 @@
 #include <linux/hwmon.h>	/* for hwmon subdriver */
 #include <linux/hwmon-sysfs.h>
 #include <linux/video_output.h>	/* for video output subdriver */
+#include <linux/input.h>	/* for hotkey subdriver */
+#include <linux/input/sparse-keymap.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
 
+#include <cs5536/cs5536.h>
+
+#include <loongson.h>		/* for loongson_cmdline */
 #include <ec_kb3310b.h>
 
 /* backlight subdriver */
@@ -512,6 +519,403 @@ static void yeeloong_vo_exit(void)
 	}
 }
 
+/* hotkey subdriver */
+
+static struct input_dev *yeeloong_hotkey_dev;
+
+static const struct key_entry yeeloong_keymap[] = {
+	{KE_SW, EVENT_LID, { SW_LID } },
+	{KE_KEY, EVENT_CAMERA, { KEY_CAMERA } }, /* Fn + ESC */
+	{KE_KEY, EVENT_SLEEP, { KEY_SLEEP } }, /* Fn + F1 */
+	{KE_KEY, EVENT_DISPLAY_TOGGLE, { KEY_SWITCHVIDEOMODE } }, /* Fn + F3 */
+	{KE_KEY, EVENT_AUDIO_MUTE, { KEY_MUTE } }, /* Fn + F4 */
+	{KE_KEY, EVENT_WLAN, { KEY_WLAN } }, /* Fn + F5 */
+	{KE_KEY, EVENT_DISPLAY_BRIGHTNESS, { KEY_BRIGHTNESSUP } }, /* Fn + up */
+	{KE_KEY, EVENT_DISPLAY_BRIGHTNESS, { KEY_BRIGHTNESSDOWN } }, /* Fn + down */
+	{KE_KEY, EVENT_AUDIO_VOLUME, { KEY_VOLUMEUP } }, /* Fn + right */
+	{KE_KEY, EVENT_AUDIO_VOLUME, { KEY_VOLUMEDOWN } }, /* Fn + left */
+	{KE_END, 0}
+};
+
+static struct key_entry *get_event_key_entry(int event, int status)
+{
+	struct key_entry *ke;
+	static int old_brightness_status = -1;
+	static int old_volume_status = -1;
+
+	ke = sparse_keymap_entry_from_scancode(yeeloong_hotkey_dev, event);
+	if (!ke)
+		return NULL;
+
+	switch (event) {
+	case EVENT_DISPLAY_BRIGHTNESS:
+		/* current status > old one, means up */
+		if ((status < old_brightness_status) || (0 == status))
+			ke++;
+		old_brightness_status = status;
+		break;
+	case EVENT_AUDIO_VOLUME:
+		if ((status < old_volume_status) || (0 == status))
+			ke++;
+		old_volume_status = status;
+		break;
+	default:
+		break;
+	}
+
+	return ke;
+}
+
+static int report_lid_switch(int status)
+{
+	input_report_switch(yeeloong_hotkey_dev, SW_LID, !status);
+	input_sync(yeeloong_hotkey_dev);
+
+	return status;
+}
+
+static int crt_detect_handler(int status)
+{
+	if (status) {
+		yeeloong_crt_vo_set(BIT_CRT_DETECT_PLUG);
+		yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_OFF);
+	} else {
+		yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_ON);
+		yeeloong_crt_vo_set(BIT_CRT_DETECT_UNPLUG);
+	}
+	return status;
+}
+
+#define EC_VER_LEN 64
+
+static int black_screen_handler(int status)
+{
+	char *p, ec_ver[EC_VER_LEN];
+
+	p = strstr(loongson_cmdline, "EC_VER=");
+	if (!p)
+		memset(ec_ver, 0, EC_VER_LEN);
+	else {
+		strncpy(ec_ver, p, EC_VER_LEN);
+		p = strstr(ec_ver, " ");
+		if (p)
+			*p = '\0';
+	}
+
+	/* Seems EC(>=PQ1D26) does this job for us, we can not do it again,
+	 * otherwise, the brightness will not resume to the normal level! */
+	if (strncasecmp(ec_ver, "EC_VER=PQ1D26", 64) < 0)
+		yeeloong_lcd_vo_set(status);
+
+	return status;
+}
+
+static int display_toggle_handler(int status)
+{
+	static int video_output_status;
+
+	/* Only enable switch video output button
+	 * when CRT is connected */
+	if (ec_read(REG_CRT_DETECT) == BIT_CRT_DETECT_UNPLUG)
+		return 0;
+	/* 0. no CRT connected: LCD on, CRT off
+	 * 1. BOTH on
+	 * 2. LCD off, CRT on
+	 * 3. BOTH off
+	 * 4. LCD on, CRT off
+	 */
+	video_output_status++;
+	if (video_output_status > 4)
+		video_output_status = 1;
+
+	switch (video_output_status) {
+	case 1:
+		yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_ON);
+		yeeloong_crt_vo_set(BIT_CRT_DETECT_PLUG);
+		break;
+	case 2:
+		yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_OFF);
+		yeeloong_crt_vo_set(BIT_CRT_DETECT_PLUG);
+		break;
+	case 3:
+		yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_OFF);
+		yeeloong_crt_vo_set(BIT_CRT_DETECT_UNPLUG);
+		break;
+	case 4:
+		yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_ON);
+		yeeloong_crt_vo_set(BIT_CRT_DETECT_UNPLUG);
+		break;
+	default:
+		/* Ensure LCD is on */
+		yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_ON);
+		break;
+	}
+	return video_output_status;
+}
+
+static int camera_handler(int status)
+{
+	int value;
+
+	value = ec_read(REG_CAMERA_CONTROL);
+	ec_write(REG_CAMERA_CONTROL, value | (1 << 1));
+
+	return status;
+}
+
+static int usb2_handler(int status)
+{
+	pr_emerg("USB2 Over Current occurred\n");
+
+	return status;
+}
+
+static int usb0_handler(int status)
+{
+	pr_emerg("USB0 Over Current occurred\n");
+
+	return status;
+}
+
+/* yeeloong_wifi_handler may be implemented in the wifi driver */
+sci_handler yeeloong_wifi_handler;
+EXPORT_SYMBOL(yeeloong_wifi_handler);
+
+
+static void do_event_action(int event)
+{
+	sci_handler handler;
+	int reg, status;
+	struct key_entry *ke;
+
+	reg = 0;
+	handler = NULL;
+
+	switch (event) {
+	case EVENT_LID:
+		reg = REG_LID_DETECT;
+		break;
+	case EVENT_DISPLAY_TOGGLE:
+		handler = display_toggle_handler;
+		break;
+	case EVENT_CRT_DETECT:
+		reg = REG_CRT_DETECT;
+		handler = crt_detect_handler;
+		break;
+	case EVENT_CAMERA:
+		reg = REG_CAMERA_STATUS;
+		handler = camera_handler;
+		break;
+	case EVENT_USB_OC2:
+		reg = REG_USB2_FLAG;
+		handler = usb2_handler;
+		break;
+	case EVENT_USB_OC0:
+		reg = REG_USB0_FLAG;
+		handler = usb0_handler;
+		break;
+	case EVENT_BLACK_SCREEN:
+		reg = REG_DISPLAY_LCD;
+		handler = black_screen_handler;
+		break;
+	case EVENT_AUDIO_MUTE:
+		reg = REG_AUDIO_MUTE;
+		break;
+	case EVENT_DISPLAY_BRIGHTNESS:
+		reg = REG_DISPLAY_BRIGHTNESS;
+		break;
+	case EVENT_AUDIO_VOLUME:
+		reg = REG_AUDIO_VOLUME;
+		break;
+	case EVENT_WLAN:
+		/* We use 2 to indicate it as a switch */
+		status = 2;
+		handler = yeeloong_wifi_handler;
+		break;
+	default:
+		break;
+	}
+
+	if (reg != 0)
+		status = ec_read(reg);
+
+	if (handler != NULL)
+		status = handler(status);
+
+	pr_info("%s: event: %d status: %d\n", __func__, event, status);
+
+	/* Report current key to user-space */
+	ke = get_event_key_entry(event, status);
+	if (ke) {
+		if (ke->keycode == SW_LID)
+			report_lid_switch(status);
+		else
+			sparse_keymap_report_entry(yeeloong_hotkey_dev, ke, 1,
+					true);
+	}
+}
+
+/*
+ * SCI(system control interrupt) main interrupt routine
+ *
+ * We will do the query and get event number together so the interrupt routine
+ * should be longer than 120us now at least 3ms elpase for it.
+ */
+static irqreturn_t sci_irq_handler(int irq, void *dev_id)
+{
+	int ret, event;
+
+	if (SCI_IRQ_NUM != irq)
+		return IRQ_NONE;
+
+	/* Query the event number */
+	ret = ec_query_event_num();
+	if (ret < 0)
+		return IRQ_NONE;
+
+	event = ec_get_event_num();
+	if (event < EVENT_START || event > EVENT_END)
+		return IRQ_NONE;
+
+	/* Execute corresponding actions */
+	do_event_action(event);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Config and init some msr and gpio register properly.
+ */
+static int sci_irq_init(void)
+{
+	u32 hi, lo;
+	u32 gpio_base;
+	unsigned long flags;
+	int ret;
+
+	/* Get gpio base */
+	_rdmsr(DIVIL_MSR_REG(DIVIL_LBAR_GPIO), &hi, &lo);
+	gpio_base = lo & 0xff00;
+
+	/* Filter the former kb3310 interrupt for security */
+	ret = ec_query_event_num();
+	if (ret)
+		return ret;
+
+	/* For filtering next number interrupt */
+	udelay(10000);
+
+	/* Set gpio native registers and msrs for GPIO27 SCI EVENT PIN
+	 * gpio :
+	 *      input, pull-up, no-invert, event-count and value 0,
+	 *      no-filter, no edge mode
+	 *      gpio27 map to Virtual gpio0
+	 * msr :
+	 *      no primary and lpc
+	 *      Unrestricted Z input to IG10 from Virtual gpio 0.
+	 */
+	local_irq_save(flags);
+	_rdmsr(0x80000024, &hi, &lo);
+	lo &= ~(1 << 10);
+	_wrmsr(0x80000024, hi, lo);
+	_rdmsr(0x80000025, &hi, &lo);
+	lo &= ~(1 << 10);
+	_wrmsr(0x80000025, hi, lo);
+	_rdmsr(0x80000023, &hi, &lo);
+	lo |= (0x0a << 0);
+	_wrmsr(0x80000023, hi, lo);
+	local_irq_restore(flags);
+
+	/* Set gpio27 as sci interrupt
+	 *
+	 * input, pull-up, no-fliter, no-negedge, invert
+	 * the sci event is just about 120us
+	 */
+	asm(".set noreorder\n");
+	/*  input enable */
+	outl(0x00000800, (gpio_base | 0xA0));
+	/*  revert the input */
+	outl(0x00000800, (gpio_base | 0xA4));
+	/*  event-int enable */
+	outl(0x00000800, (gpio_base | 0xB8));
+	asm(".set reorder\n");
+
+	return 0;
+}
+
+static struct irqaction sci_irqaction = {
+	.handler = sci_irq_handler,
+	.name = "sci",
+	.flags = IRQF_SHARED,
+};
+
+static int yeeloong_hotkey_init(void)
+{
+	int ret;
+
+	ret = sci_irq_init();
+	if (ret)
+		return -EFAULT;
+
+	ret = setup_irq(SCI_IRQ_NUM, &sci_irqaction);
+	if (ret)
+		return -EFAULT;
+
+	yeeloong_hotkey_dev = input_allocate_device();
+
+	if (!yeeloong_hotkey_dev) {
+		remove_irq(SCI_IRQ_NUM, &sci_irqaction);
+		return -ENOMEM;
+	}
+
+	yeeloong_hotkey_dev->name = "HotKeys";
+	yeeloong_hotkey_dev->phys = "button/input0";
+	yeeloong_hotkey_dev->id.bustype = BUS_HOST;
+	yeeloong_hotkey_dev->dev.parent = NULL;
+
+	ret = sparse_keymap_setup(yeeloong_hotkey_dev, yeeloong_keymap, NULL);
+	if (ret) {
+		pr_err("Fail to setup input device keymap\n");
+		input_free_device(yeeloong_hotkey_dev);
+		return ret;
+	}
+
+	ret = input_register_device(yeeloong_hotkey_dev);
+	if (ret) {
+		sparse_keymap_free(yeeloong_hotkey_dev);
+		input_free_device(yeeloong_hotkey_dev);
+		return ret;
+	}
+
+	/* Update the current status of LID */
+	report_lid_switch(BIT_LID_DETECT_ON);
+
+#ifdef CONFIG_LOONGSON_SUSPEND
+	/* Install the real yeeloong_report_lid_status for pm.c */
+	yeeloong_report_lid_status = report_lid_switch;
+#endif
+
+	return 0;
+}
+
+static void yeeloong_hotkey_exit(void)
+{
+	/* Free irq */
+	remove_irq(SCI_IRQ_NUM, &sci_irqaction);
+
+#ifdef CONFIG_LOONGSON_SUSPEND
+	/* Uninstall yeeloong_report_lid_status for pm.c */
+	if (yeeloong_report_lid_status == report_lid_switch)
+		yeeloong_report_lid_status = NULL;
+#endif
+
+	if (yeeloong_hotkey_dev) {
+		sparse_keymap_free(yeeloong_hotkey_dev);
+		input_unregister_device(yeeloong_hotkey_dev);
+		yeeloong_hotkey_dev = NULL;
+	}
+}
+
 #ifdef CONFIG_PM
 static void usb_ports_set(int status)
 {
@@ -601,11 +1005,19 @@ static int __init yeeloong_init(void)
 		return ret;
 	}
 
+	ret = yeeloong_hotkey_init();
+	if (ret) {
+		pr_err("Fail to register yeeloong hotkey driver.\n");
+		yeeloong_hotkey_exit();
+		return ret;
+	}
+
 	return 0;
 }
 
 static void __exit yeeloong_exit(void)
 {
+	yeeloong_hotkey_exit();
 	yeeloong_vo_exit();
 	yeeloong_hwmon_exit();
 	yeeloong_battery_exit();
-- 
1.6.2.1

