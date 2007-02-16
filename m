Return-Path: <linux-kernel-owner+w=401wt.eu-S1423132AbXBPEL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423132AbXBPEL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423135AbXBPEL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:11:27 -0500
Received: from mfo32.po.2iij.net ([210.128.50.15]:9209 "EHLO mfo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423132AbXBPEL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:11:26 -0500
X-Greylist: delayed 2104 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 23:11:25 EST
Date: Fri, 16 Feb 2007 12:36:08 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: dmitry.torokhov@gmail.com
Cc: yoichi_yuasa@tripeaks.co.jp, linux-input@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add Cobalt button interface driver support
Message-Id: <20070216123608.733f04a3.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds support for the back panel buttons on Cobalt server.
It's tested on the Cobalt Qube2.

Yoichi

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/input/misc/Kconfig mips/drivers/input/misc/Kconfig
--- mips-orig/drivers/input/misc/Kconfig	2007-02-14 15:35:30.566862000 +0900
+++ mips/drivers/input/misc/Kconfig	2007-02-15 17:20:28.721985250 +0900
@@ -89,4 +89,10 @@ config HP_SDC_RTC
 	  Say Y here if you want to support the built-in real time clock
 	  of the HP SDC controller.
 
+config INPUT_COBALT_BTNS
+	tristate "Cobalt button interface"       
+	depends on MIPS_COBALT
+	help
+	  Say Y here if you want to support MIPS Cobalt button interface.
+
 endif
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/input/misc/Makefile mips/drivers/input/misc/Makefile
--- mips-orig/drivers/input/misc/Makefile	2007-02-14 15:35:30.566862000 +0900
+++ mips/drivers/input/misc/Makefile	2007-02-15 11:55:30.856042500 +0900
@@ -12,3 +12,4 @@ obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wist
 obj-$(CONFIG_INPUT_ATLAS_BTNS)		+= atlas_btns.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
+obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/input/misc/cobalt_btns.c mips/drivers/input/misc/cobalt_btns.c
--- mips-orig/drivers/input/misc/cobalt_btns.c	1970-01-01 09:00:00.000000000 +0900
+++ mips/drivers/input/misc/cobalt_btns.c	2007-02-15 17:17:31.550912750 +0900
@@ -0,0 +1,199 @@
+/*
+ *  Cobalt button interface driver.
+ *
+ *  Copyright (C) 2007  Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
+
+#include <asm/param.h>
+
+#define BUTTONS_POLL_FREQUENCY	30
+#define BUTTONS_COUNT_THRESHOLD	3
+#define BUTTONS_STATUS_MASK	0xfe000000
+
+struct buttons_dev {
+	struct input_dev *input;
+	void __iomem *reg;
+};
+
+struct buttons_map {
+	uint32_t	mask;
+	int		keycode;
+	int		count;
+};
+
+static struct buttons_map buttons_map[] = {
+	{ 0x02000000, KEY_RESTART, },
+	{ 0x04000000, KEY_LEFT, },
+	{ 0x08000000, KEY_UP, },
+	{ 0x10000000, KEY_DOWN, },
+	{ 0x20000000, KEY_RIGHT, },
+	{ 0x40000000, KEY_ENTER, },
+	{ 0x80000000, KEY_SELECT, },
+};
+
+static struct resource cobalt_buttons_resource = {
+	.start	= 0x1d000000,
+	.end	= 0x1d000003,
+	.flags	= IORESOURCE_MEM,
+};
+
+static struct platform_device cobalt_buttons_device = {
+	.name		= "Cobalt buttons",
+	.num_resources	= 1,
+	.resource	= &cobalt_buttons_resource,
+};
+
+static struct timer_list buttons_timer;
+
+static void handle_buttons(unsigned long data)
+{
+	struct buttons_map *button = buttons_map;
+	struct buttons_dev *bdev;
+	uint32_t status;
+	int i;
+
+	bdev = (struct buttons_dev *)data;
+	status = readl(bdev->reg);
+	status = ~status & BUTTONS_STATUS_MASK;
+
+	for (i = 0; i < ARRAY_SIZE(buttons_map); i++) {
+		if (status & button->mask) {
+			button->count++;
+		} else {
+			if (button->count >= BUTTONS_COUNT_THRESHOLD) {
+				input_report_key(bdev->input, button->keycode, 0);
+				input_sync(bdev->input);
+			}
+			button->count = 0;
+		}
+
+		if (button->count == BUTTONS_COUNT_THRESHOLD) {
+			input_report_key(bdev->input, button->keycode, 1);
+			input_sync(bdev->input);
+		}
+
+		button++;
+	}
+
+	mod_timer(&buttons_timer, jiffies + HZ / BUTTONS_POLL_FREQUENCY);
+}
+
+static int __init cobalt_buttons_probe(struct platform_device *pdev)
+{
+	struct buttons_dev *bdev;
+	struct input_dev *input;
+	struct resource *res;
+	int retval, i;
+
+	bdev = kzalloc(sizeof(struct buttons_dev), GFP_KERNEL);
+	if (!bdev)
+		return -ENOMEM;
+
+	input = input_allocate_device();
+	if (!input) {
+		kfree(bdev);
+		return -ENOMEM;
+	}
+
+	input->name = "Cobalt buttons";
+	input->phys = "cobalt/input0";
+	input->id.bustype = BUS_HOST;
+	input->cdev.dev = &pdev->dev;
+
+	input->evbit[0] = BIT(EV_KEY);
+	for (i = 0; i < ARRAY_SIZE(buttons_map); i++) {
+		set_bit(buttons_map[i].keycode, input->keybit);
+		buttons_map[i].count = 0;
+	}
+
+	retval = input_register_device(input);
+	if (retval < 0) {
+		input_free_device(input);
+		kfree(bdev);
+		return retval;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		input_unregister_device(input);
+		kfree(bdev);
+		return -EBUSY;
+	}
+
+	bdev->input = input;
+	bdev->reg = ioremap(res->start, res->end - res->start + 1);
+	dev_set_drvdata(&pdev->dev, bdev);
+
+	setup_timer(&buttons_timer, handle_buttons, (unsigned long)bdev);
+	mod_timer(&buttons_timer, jiffies + HZ / BUTTONS_POLL_FREQUENCY);
+
+	return retval;
+}
+
+static int __devexit cobalt_buttons_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct buttons_dev *bdev = dev_get_drvdata(dev);
+
+	del_timer(&buttons_timer);
+	input_unregister_device(bdev->input);
+	iounmap(bdev->reg);
+	kfree(bdev);
+	dev_set_drvdata(dev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver cobalt_buttons_driver = {
+	.probe	= cobalt_buttons_probe,
+	.remove	= __devexit_p(cobalt_buttons_remove),
+	.driver	= {
+		.name	= "Cobalt buttons",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init cobalt_buttons_init(void)
+{
+	int retval;
+
+	retval = platform_device_register(&cobalt_buttons_device);
+	if (retval < 0)
+		return retval;
+
+	retval = platform_driver_register(&cobalt_buttons_driver);
+	if (retval < 0)
+		platform_device_unregister(&cobalt_buttons_device);
+
+	return retval;
+}
+
+static void __exit cobalt_buttons_exit(void)
+{
+	platform_driver_unregister(&cobalt_buttons_driver);
+	platform_device_unregister(&cobalt_buttons_device);
+}
+
+module_init(cobalt_buttons_init);
+module_exit(cobalt_buttons_exit);
