Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbYL3U2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbYL3U2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 15:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYL3U2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 15:28:05 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:47204 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbYL3U2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 15:28:03 -0500
X-Trace: 125000874/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.224/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.224
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.2 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAFoTWklQLLDg/2dsb2JhbACBbMt7hkQ
X-IronPort-AV: E=Sophos;i="4.36,304,1228089600"; 
   d="scan'208";a="125000874"
Subject: Re: [PATCH] sh: maple: add support for the Maple mouse on the SEGA
 Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <200812300017.45336.dmitry.torokhov@gmail.com>
References: <1230578246.6496.25.camel@localhost.localdomain>
	 <1230589073.6496.30.camel@localhost.localdomain>
	 <200812291719.47754.vapier@gentoo.org>
	 <200812300017.45336.dmitry.torokhov@gmail.com>
Content-Type: text/plain
Date: Tue, 30 Dec 2008 20:27:05 +0000
Message-Id: <1230668825.6489.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Adding maple mouse with proper __devexit_p() handling

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 4e99342..71cc98a 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -286,4 +286,15 @@ config MOUSE_GPIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called gpio_mouse.
 
+config MOUSE_MAPLE
+	tristate "Maple mouse (for the Dreamcast)"
+	depends on MAPLE
+	help
+	  This driver supports the Maple mouse on the SEGA Dreamcast.
+
+	  Most Dreamcast users, who have a mouse, will say Y here.
+
+	  To compile this driver as a module choose M here: the module will be
+	  called maplemouse.
+
 endif
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 96f1dd8..0272f5d 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_MOUSE_SERIAL)	+= sermouse.o
 obj-$(CONFIG_MOUSE_HIL)		+= hil_ptr.o
 obj-$(CONFIG_MOUSE_VSXXXAA)	+= vsxxxaa.o
 obj-$(CONFIG_MOUSE_GPIO)	+= gpio_mouse.o
+obj-$(CONFIG_MOUSE_MAPLE)	+= maplemouse.o
 
 psmouse-objs := psmouse-base.o synaptics.o
 
diff --git a/drivers/input/mouse/maplemouse.c b/drivers/input/mouse/maplemouse.c
new file mode 100644
index 0000000..103e5a0
--- /dev/null
+++ b/drivers/input/mouse/maplemouse.c
@@ -0,0 +1,135 @@
+/*
+ *	SEGA Dreamcast mouse driver
+ *	Based on drivers/usb/usbmouse.c
+ *
+ *	Copyright Yaegashi Takeshi, 2001
+ *	Adrian McMenamin, 2008
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/maple.h>
+
+MODULE_AUTHOR("Adrian McMenamin <adrian@mcmen.demon.co.uk>");
+MODULE_DESCRIPTION("SEGA Dreamcast mouse driver");
+MODULE_LICENSE("GPL");
+
+struct dc_mouse {
+	struct input_dev *dev;
+	struct maple_device *mdev;
+};
+
+static void dc_mouse_callback(struct mapleq *mq)
+{
+	int buttons, relx, rely, relz;
+	struct maple_device *mapledev = mq->dev;
+	struct dc_mouse *mse = maple_get_drvdata(mapledev);
+	struct input_dev *dev = mse->dev;
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
+/* allow the mouse to be used */
+static int __devinit probe_maple_mouse(struct device *dev)
+{
+	struct maple_device *mdev;
+	struct maple_driver *mdrv;
+	int error;
+	struct input_dev *input_dev;
+	struct dc_mouse *mse;
+
+	mdev = to_maple_dev(dev);
+	mdrv = to_maple_driver(dev->driver);
+
+	mse = kzalloc(sizeof(struct dc_mouse), GFP_KERNEL);
+	if (!mse) {
+		error = -ENOMEM;
+		goto fail;
+	}
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		error = -ENOMEM;
+		goto fail_nomem;
+	}
+
+	mse->dev = input_dev;
+	mse->mdev = mdev;
+
+	input_set_drvdata(input_dev, mse);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
+	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
+		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_MIDDLE);
+	input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y) |
+		BIT_MASK(REL_WHEEL);
+	input_dev->name = mdev->product_name;
+	input_dev->id.bustype = BUS_HOST;
+	error =	input_register_device(input_dev);
+	if (error)
+		goto fail_register;
+
+	mdev->driver = mdrv;
+	maple_set_drvdata(mdev, mse);
+
+	maple_getcond_callback(mdev, dc_mouse_callback, HZ/50,
+		MAPLE_FUNC_MOUSE);
+
+	return error;
+
+fail_register:
+	input_free_device(input_dev);
+fail_nomem:
+	kfree(mse);
+fail:
+	return error;
+}
+
+static int __devexit remove_maple_mouse(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct dc_mouse *mse = maple_get_drvdata(mdev);
+
+	mdev->callback = NULL;
+	input_unregister_device(mse->dev);
+	maple_set_drvdata(mdev, NULL);
+	kfree(mse);
+	return 0;
+}
+
+static struct maple_driver dc_mouse_driver = {
+	.function =	MAPLE_FUNC_MOUSE,
+	.drv = {
+		.name = "Dreamcast_mouse",
+		.probe = probe_maple_mouse,
+		.remove = __devexit_p(remove_maple_mouse),
+	},
+};
+
+static int __init dc_mouse_init(void)
+{
+	return maple_driver_register(&dc_mouse_driver);
+}
+
+static void __exit dc_mouse_exit(void)
+{
+	maple_driver_unregister(&dc_mouse_driver);
+}
+
+module_init(dc_mouse_init);
+module_exit(dc_mouse_exit);

