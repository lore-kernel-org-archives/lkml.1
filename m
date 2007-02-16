Return-Path: <linux-kernel-owner+w=401wt.eu-S966193AbXBPIP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966193AbXBPIP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966195AbXBPIP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:15:29 -0500
Received: from mo30.po.2iij.net ([210.128.50.53]:2625 "EHLO mo30.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966193AbXBPIP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:15:27 -0500
Message-Id: <200702160815.l1G8FEIr078415@mbox33.po.2iij.net>
Date: Fri, 16 Feb 2007 17:15:14 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: yoichi_yuasa@tripeaks.co.jp, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Cobalt button interface driver support
In-Reply-To: <200702152309.44563.dtor@insightbb.com>
References: <20070216123608.733f04a3.yoichi_yuasa@tripeaks.co.jp>
	<200702152309.44563.dtor@insightbb.com>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your comments.

On Thu, 15 Feb 2007 23:09:43 -0500
Dmitry Torokhov <dtor@insightbb.com> wrote:

> On Thursday 15 February 2007 22:36, Yoichi Yuasa wrote:
> > Hi,
> > 
> > This patch adds support for the back panel buttons on Cobalt server.
> > It's tested on the Cobalt Qube2.
> > 
> 
> Hi,
> 
> Thank you for your patch. Couple of comments:
> 
> > +
> > +		button++;
> > +	}
> > +
> > +	mod_timer(&buttons_timer, jiffies + HZ / BUTTONS_POLL_FREQUENCY);
> 
> May I suggest using msecs_to_jiffies() to avoid direct computations on HZ?

OK, I updated it.

> > +
> > +	bdev->input = input;
> > +	bdev->reg = ioremap(res->start, res->end - res->start + 1);
> > +	dev_set_drvdata(&pdev->dev, bdev);
> > +
> > +	setup_timer(&buttons_timer, handle_buttons, (unsigned long)bdev);
> > +	mod_timer(&buttons_timer, jiffies + HZ / BUTTONS_POLL_FREQUENCY);
> 
> Please implement cobalt_buttons_open() and cobalt_buttons_close() methods
> and start/stop timer from there - there is no point in polling hardware
> if noone is listening to the events.

I updated it too.

> > +static int __devexit cobalt_buttons_remove(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct buttons_dev *bdev = dev_get_drvdata(dev);
> > +
> > +	del_timer(&buttons_timer);
> 
> del_timer_sync? Is there any possibility it may run SMP?

Cobalt server doesn't support SMP. but there is no problem.
I updated it.

> > +static void __exit cobalt_buttons_exit(void)
> > +{
> > +	platform_driver_unregister(&cobalt_buttons_driver);
> 
> You are not allowed to unregister statically allocated devices -
> if there are references left and your module goes away then
> these references become invalid and kernel goes boom.
> 
> Please convert to platform_device_alloc/platform_device_add.

I updated it.

> Is there a point of moving platform device creation code into
> platform-specific code? Is there a possibility of this driver
> being used elsewhere?

No it isn't. 

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
+++ mips/drivers/input/misc/cobalt_btns.c	2007-02-16 16:09:48.857365000 +0900
@@ -0,0 +1,233 @@
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
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
+
+#include <asm/param.h>
+
+#define BUTTONS_POLL_INTERVAL	30	/* msec */
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
+static struct resource cobalt_buttons_resource __initdata = {
+	.start	= 0x1d000000,
+	.end	= 0x1d000003,
+	.flags	= IORESOURCE_MEM,
+};
+
+static struct platform_device *cobalt_buttons_device;
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
+	mod_timer(&buttons_timer, jiffies + msecs_to_jiffies(BUTTONS_POLL_INTERVAL));
+}
+
+static int cobalt_buttons_open(struct inode *inode, struct file *file)
+{
+	buttons_timer.expires = jiffies + msecs_to_jiffies(BUTTONS_POLL_INTERVAL);
+	add_timer(&buttons_timer);
+
+	return nonseekable_open(inode, file);
+
+}
+
+static int cobalt_buttons_release(struct inode *inode, struct file *file)
+{
+	return del_timer_sync(&buttons_timer);
+}
+
+static const struct file_operations cobalt_buttons_fops = {
+	.owner		= THIS_MODULE,
+	.open		= cobalt_buttons_open,
+	.release	= cobalt_buttons_release,
+	.llseek		= no_llseek,
+};
+
+static struct miscdevice cobalt_buttons_miscdevice = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "Cobalt buttons",
+	.fops	= &cobalt_buttons_fops,
+};
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
+
+	retval = misc_register(&cobalt_buttons_miscdevice);
+	if (retval < 0) {
+		del_timer_sync(&buttons_timer);
+		iounmap(bdev->reg);
+		input_unregister_device(input);
+		kfree(bdev);
+	}
+
+	return retval;
+}
+
+static int __devexit cobalt_buttons_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct buttons_dev *bdev = dev_get_drvdata(dev);
+
+	misc_deregister(&cobalt_buttons_miscdevice);
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
+	cobalt_buttons_device = platform_device_register_simple("Cobalt buttons", -1,
+	                                                        &cobalt_buttons_resource, 1);
+	if (IS_ERR(cobalt_buttons_device)) {
+		retval = PTR_ERR(cobalt_buttons_device);
+		return retval;
+	}
+
+	retval = platform_driver_register(&cobalt_buttons_driver);
+	if (retval < 0)
+		platform_device_unregister(cobalt_buttons_device);
+
+	return retval;
+}
+
+static void __exit cobalt_buttons_exit(void)
+{
+	platform_driver_unregister(&cobalt_buttons_driver);
+	platform_device_unregister(cobalt_buttons_device);
+}
+
+module_init(cobalt_buttons_init);
+module_exit(cobalt_buttons_exit);

