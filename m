Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbYHTUCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbYHTUCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYHTUBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:01:55 -0400
Received: from vs251036.vserver.de ([62.75.251.36]:60980 "EHLO
	vs251036.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbYHTUBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:01:54 -0400
Message-ID: <48AC7829.8040709@claudio.ch>
Date: Wed, 20 Aug 2008 22:01:45 +0200
From: Claudio Nieder <private@claudio.ch>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrey Panin <pazke@pazke.donpac.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Backlight driver for Tabletkiosk Sahara TouchIT-213	Tablet
 PC
References: <488E0D2A.1000005@claudio.ch> <1217270428.6059.39.camel@dax.rpnet.com> <488E25F4.4020405@claudio.ch> <20080811134940.b3bcde83.akpm@linux-foundation.org> <48A1CA9A.4000007@claudio.ch> <48AB5099.7070904@claudio.ch> 
In-Reply-To: <48AB5099.7070904@claudio.ch> 
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> These two empty initializers are not needed.

Fixed.

> Now let's add module alias to ensure driver autoloading.
> IMHO the line below should do the trick:
> 
> MODULE_ALIAS("dmi:*:svnSDV:pniTouchT201:*");

I usually built the kernel with my driver included. For once I tried to build as
module first without that line added and then with. And by magic the module is
loaded right at boot time. Thank you for your help.

Once again the patch in which all your suggestions are included. Furthermore I
noticed that I had "default y" in Kconfig. Handy for me, but a tad selfish I
think and so corrected that by setting it to "n".

Here the fixed patch:

Signed-off-by: Claudio Nieder <private@claudio.ch>

Backlight driver for Tabletkiosk Sahara TouchIT-213 Tablet PC
---
 drivers/video/backlight/Kconfig     |    7 +
 drivers/video/backlight/Makefile    |    1 +
 drivers/video/backlight/kb3886_bl.c |  213 +++++++++++++++++++++++++++++++++++
 3 files changed, 221 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 452b770..7dd0ecd 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -164,3 +164,10 @@ config BACKLIGHT_MBP_NVIDIA
          If you have an Apple Macbook Pro with Nvidia graphics hardware say Y
 	 to enable a driver for its backlight

+config BACKLIGHT_SAHARA
+	tristate "Tabletkiosk Sahara Touch-iT Backlight Driver"
+	depends on BACKLIGHT_CLASS_DEVICE && X86
+	default n
+	help
+	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
+	  backlight driver.
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index b405aac..f4a1183 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -16,4 +16,5 @@ obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
+obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o

diff --git a/drivers/video/backlight/kb3886_bl.c
b/drivers/video/backlight/kb3886_bl.c
new file mode 100644
index 0000000..feb750a
--- /dev/null
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -0,0 +1,213 @@
+/*
+ *  Backlight Driver for the KB3886 Backlight
+ *
+ *  Copyright (c) 2007-2008 Claudio Nieder
+ *
+ *  Based on corgi_bl.c by Richard Purdie and kb3886 driver by Robert Woerle
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/delay.h>
+#include <linux/dmi.h>
+
+/*
+ * The following is what corgi has in arch/arm/mach-pxa/corgi.c and
+ * corgi_lcd.c. On kernelnebwies it was suggested I put the platform_device
+ * code in my driver.
+ */
+
+#define KB3886_PARENT 0x64
+#define KB3886_IO 0x60
+#define KB3886_ADC_DAC_PWM 0xC4
+#define KB3886_PWM0_WRITE 0x81
+#define KB3886_PWM0_READ 0x41
+
+static DEFINE_MUTEX(bl_mutex);
+
+static void kb3886_bl_set_intensity(int intensity)
+{
+	mutex_lock(&bl_mutex);
+	intensity = intensity&0xff;
+	outb(KB3886_ADC_DAC_PWM, KB3886_PARENT);
+	msleep(10);
+	outb(KB3886_PWM0_WRITE, KB3886_IO);
+	msleep(10);
+	outb(intensity, KB3886_IO);
+	mutex_unlock(&bl_mutex);
+}
+
+struct kb3886bl_machinfo {
+	int max_intensity;
+	int default_intensity;
+	int limit_mask;
+	void (*set_bl_intensity)(int intensity);
+};
+
+static struct kb3886bl_machinfo kb3886_bl_machinfo = {
+	.max_intensity = 0xff,
+	.default_intensity = 0xa0,
+	.limit_mask = 0x7f,
+	.set_bl_intensity = kb3886_bl_set_intensity,
+};
+
+static struct platform_device kb3886bl_device = {
+	.name		= "kb3886-bl",
+	.dev		= {
+		.platform_data	= &kb3886_bl_machinfo,
+	},
+	.id		= -1,
+};
+
+static struct platform_device *devices[] __initdata = {
+	&kb3886bl_device,
+};
+
+/*
+ * Back to driver
+ */
+
+static int kb3886bl_intensity;
+static struct backlight_device *kb3886_backlight_device;
+static struct kb3886bl_machinfo *bl_machinfo;
+
+static unsigned long kb3886bl_flags;
+#define KB3886BL_SUSPENDED     0x01
+#define KB3886BL_BATTLOW       0x02
+
+static struct dmi_system_id __initdata kb3886bl_device_table[] = {
+	{
+		.ident = "Sahara Touch-iT",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SDV"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iTouch T201"),
+		},
+	},
+	{ }
+};
+
+static int kb3886bl_send_intensity(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	if (bd->props.power != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (kb3886bl_flags & KB3886BL_SUSPENDED)
+		intensity = 0;
+	if (kb3886bl_flags & KB3886BL_BATTLOW)
+		intensity &= bl_machinfo->limit_mask;
+
+	bl_machinfo->set_bl_intensity(intensity);
+
+	kb3886bl_intensity = intensity;
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int kb3886bl_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	kb3886bl_flags |= KB3886BL_SUSPENDED;
+	backlight_update_status(bd);
+	return 0;
+}
+
+static int kb3886bl_resume(struct platform_device *pdev)
+{
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	kb3886bl_flags &= ~KB3886BL_SUSPENDED;
+	backlight_update_status(bd);
+	return 0;
+}
+#else
+#define kb3886bl_suspend	NULL
+#define kb3886bl_resume		NULL
+#endif
+
+static int kb3886bl_get_intensity(struct backlight_device *bd)
+{
+	return kb3886bl_intensity;
+}
+
+static struct backlight_ops kb3886bl_ops = {
+	.get_brightness = kb3886bl_get_intensity,
+	.update_status  = kb3886bl_send_intensity,
+};
+
+static int kb3886bl_probe(struct platform_device *pdev)
+{
+	struct kb3886bl_machinfo *machinfo = pdev->dev.platform_data;
+
+	bl_machinfo = machinfo;
+	if (!machinfo->limit_mask)
+		machinfo->limit_mask = -1;
+
+	kb3886_backlight_device = backlight_device_register("kb3886-bl",
+		&pdev->dev, NULL, &kb3886bl_ops);
+	if (IS_ERR (kb3886_backlight_device))
+		return PTR_ERR(kb3886_backlight_device);
+
+	platform_set_drvdata(pdev, kb3886_backlight_device);
+
+	kb3886_backlight_device->props.max_brightness = machinfo->max_intensity;
+	kb3886_backlight_device->props.power = FB_BLANK_UNBLANK;
+	kb3886_backlight_device->props.brightness = machinfo->default_intensity;
+	backlight_update_status(kb3886_backlight_device);
+
+	return 0;
+}
+
+static int kb3886bl_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	backlight_device_unregister(bd);
+
+	return 0;
+}
+
+static struct platform_driver kb3886bl_driver = {
+	.probe		= kb3886bl_probe,
+	.remove		= kb3886bl_remove,
+	.suspend	= kb3886bl_suspend,
+	.resume		= kb3886bl_resume,
+	.driver		= {
+		.name	= "kb3886-bl",
+	},
+};
+
+static int __init kb3886_init(void)
+{
+	if (!dmi_check_system(kb3886bl_device_table))
+		return -ENODEV;
+
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+	return platform_driver_register(&kb3886bl_driver);
+}
+
+static void __exit kb3886_exit(void)
+{
+	platform_driver_unregister(&kb3886bl_driver);
+}
+
+module_init(kb3886_init);
+module_exit(kb3886_exit);
+
+MODULE_AUTHOR("Claudio Nieder <private@claudio.ch>");
+MODULE_DESCRIPTION("Tabletkiosk Sahara Touch-iT Backlight Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("dmi:*:svnSDV:pniTouchT201:*");
-- 
1.4.4.4

claudio
-- 
Claudio Nieder, Talweg 6, CH-8610 Uster, Tel +4179 357 6743, www.claudio.ch
