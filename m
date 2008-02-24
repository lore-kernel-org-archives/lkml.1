Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYBXNx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYBXNx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 08:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYBXNxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 08:53:49 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:28639 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbYBXNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 08:53:47 -0500
X-Trace: 667503824/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FANcFwUdRAVlC/2dsb2JhbACBVahDgXo
Subject: [PATCH 3/3] input: support maple mouse on Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203860954.6474.9.camel@localhost.localdomain>
References: <1203860828.6474.6.camel@localhost.localdomain>
	 <1203860954.6474.9.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 13:51:26 +0000
Message-Id: <1203861086.6474.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

input: add support for maple mouse on Dreamcast

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/input/mouse/maplemouse.c b/drivers/input/mouse/maplemouse.c
new file mode 100644
index 0000000..08cfb6f
--- /dev/null
+++ b/drivers/input/mouse/maplemouse.c
@@ -0,0 +1,148 @@
+/*
+ *	SEGA Dreamcast mouse driver
+ *	Based on drivers/usb/usbmouse.c
+ *
+ *	Copyright Yaegashi Takeshi, 2001
+ *	Porting to 2.6 and other fixes
+ *	copyright, Adrian McMenamin, 2008
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/maple.h>
+#include <asm/mach/maple.h>
+
+MODULE_AUTHOR("YAEGASHI Takeshi <t@keshi.org>");
+MODULE_DESCRIPTION("SEGA Dreamcast mouse driver");
+MODULE_LICENSE("GPL");
+
+static void dc_mouse_callback(struct mapleq *mq)
+{
+	int buttons, relx, rely, relz;
+	struct maple_device *mapledev = mq->dev;
+	struct input_dev *dev = mapledev->private_data;
+	unsigned char *res = mq->recvbuf;
+
+	buttons = ~res[8];
+	relx = *(unsigned short *)(res + 12) - 512;
+	rely = *(unsigned short *)(res + 14) - 512;
+	relz = *(unsigned short *)(res + 16) - 512;
+
+	input_report_key(dev, BTN_LEFT,   buttons & 4);
+	input_report_key(dev, BTN_MIDDLE, buttons & 9);
+	input_report_key(dev, BTN_RIGHT,  buttons & 2);
+	input_report_rel(dev, REL_X,      relx);
+	input_report_rel(dev, REL_Y,      rely);
+	input_report_rel(dev, REL_WHEEL,  relz);
+	input_sync(dev);
+}
+
+static int dc_mouse_connect(struct maple_device *mdev)
+{
+	struct input_dev *input_dev;
+	int error;
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		error = ENOMEM;
+		goto fail_nomem;
+	}
+	mdev->private_data = input_dev;
+
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
+
+	input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y) | BIT_MASK(REL_WHEEL);
+
+	input_dev->name = mdev->product_name;
+	input_dev->id.bustype = BUS_HOST;
+
+	error =	input_register_device(input_dev);
+	if (error)
+		goto fail_regdev;
+
+	maple_getcond_callback(mdev, dc_mouse_callback, HZ/50, MAPLE_FUNC_MOUSE);
+
+	return error;
+
+fail_regdev:
+	input_free_device(input_dev);
+fail_nomem:
+	return error;
+}
+
+static void dc_mouse_disconnect(struct maple_device *dev)
+{
+	struct input_dev *input_dev = dev->private_data;
+
+	input_unregister_device(input_dev);
+	kfree(input_dev);
+}
+
+/* allow the mouse to be used */
+static int probe_maple_mouse(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+	int error;
+
+	error = dc_mouse_connect(mdev);
+	if (error)
+		return error;
+
+	mdev->driver = mdrv;
+
+	return 0;
+}
+
+
+static int remove_maple_mouse(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+
+	dc_mouse_disconnect(mdev);
+	return 0;
+}
+
+static struct maple_driver dc_mouse_driver = {
+	.function =	MAPLE_FUNC_MOUSE,
+	.connect =	dc_mouse_connect,
+	.disconnect =	dc_mouse_disconnect,
+	.drv = {
+		.name = "Dreamcast_mouse",
+		.probe = probe_maple_mouse,
+		.remove = remove_maple_mouse,
+	},
+};
+
+static int unplug_maple_mouse(struct device *dev, void *ignored)
+{
+	/* Please DO NOT really unplug your mouse */
+	struct maple_device *mdev;
+
+	mdev = to_maple_dev(dev);
+	if ((mdev->function & MAPLE_FUNC_MOUSE)
+		&& (mdev->driver == &dc_mouse_driver))
+		remove_maple_mouse(dev);
+
+	return 0;
+}
+
+static int __init dc_mouse_init(void)
+{
+	maple_driver_register(&dc_mouse_driver.drv);
+	return 0;
+}
+
+static void __exit dc_mouse_exit(void)
+{
+	bus_for_each_dev(&maple_bus_type, NULL, NULL, unplug_maple_mouse);
+	driver_unregister(&dc_mouse_driver.drv);
+}
+
+module_init(dc_mouse_init);
+module_exit(dc_mouse_exit);

