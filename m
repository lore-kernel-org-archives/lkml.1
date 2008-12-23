Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYLWJAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYLWJAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 04:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYLWI75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 03:59:57 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:24278 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYLWI7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 03:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Taaq2+RQSeD+Nd5cPijgEA7P6/4FYqoobXO/tQ0bSRW9RiiUcCJ98YaZXDw1/7qCuL
         +IgO7El5q+Otxxcn6guZg7aBJICMLk9l63AdMioTA8n9exWKpHqMmjodWLpCXYpAth/M
         UoNhHd4LC3CxHz4Yh1flrr+AcGrI/CZUAawtA=
Date: Tue, 23 Dec 2008 03:59:47 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       lethal@linux-sh.org
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a
	joystick
Message-ID: <20081223085946.GA14302@anvil.corenet.prv>
References: <1229728542.1441.6.camel@localhost.localdomain> <20081222150636.8dc20d61.akpm@linux-foundation.org> <1229994455.22856.61.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229994455.22856.61.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 05:07:35PM -0800, Harvey Harrison wrote:
> On Mon, 2008-12-22 at 15:06 -0800, Andrew Morton wrote:
> > On Fri, 19 Dec 2008 23:15:42 +0000
> > Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> > 
> > > Not sure what happened with earlier submissions, so here is an up-to-date
> > > patch for the Dreamcast Maple controlled.
> > > 
> > > 
> > > Add support for the SEGA Dreamcast Maple controller as a joystick
> > > 
> > > ...
> > >
> > > +static void dc_pad_callback(struct mapleq *mq)
> > > +{
> > > +	unsigned short buttons;
> > > +	struct maple_device *mapledev = mq->dev;
> > > +	struct dc_pad *pad = maple_get_drvdata(mapledev);
> > > +	struct input_dev *dev = pad->dev;
> > > +	unsigned char *res = mq->recvbuf;
> > > +
> > > +	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
> > 
> > hm, could that be simplified?
> 
> And as a bonus fix the obvious sparse warning:
> 
> 	buttons = ~le16_to_cpup((__le16 *)(res + 8));
> 

Below is what I woudl like to apply unless you see more issues with the
patch. Andrew, if you could test it on your hardware to make sure it
still works that woudl be great.

Thanks!

-- 
Dmitry

Input: add support for Maple controller as a joystick

From: Adrian McMenamin <adrian@newgolddream.dyndns.info>

Add support for the SEGA Dreamcast Maple controller as a joystick

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/Kconfig        |   12 ++
 drivers/input/joystick/Makefile       |    1 
 drivers/input/joystick/maplecontrol.c |  193 +++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/joystick/maplecontrol.c

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 268dd3f..b114195 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -306,4 +306,16 @@ config JOYSTICK_WALKERA0701
 	  To compile this driver as a module, choose M here: the
 	  module will be called walkera0701.
 
+config JOYSTICK_MAPLE
+	tristate "Dreamcast control pad"
+	depends on MAPLE
+	help
+	  Say Y here if you have a SEGA Dreamcast and want to use your
+	  controller as a joystick.
+
+	  Most Dreamcast users will say Y.
+
+	  To compile this as a module choose M here: the module will be called
+	  maplecontrol.
+
 endif
diff --git a/drivers/input/joystick/Makefile b/drivers/input/joystick/Makefile
index 7230362..f397ec0 100644
--- a/drivers/input/joystick/Makefile
+++ b/drivers/input/joystick/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_JOYSTICK_AMIGA)		+= amijoy.o
 obj-$(CONFIG_JOYSTICK_ANALOG)		+= analog.o
 obj-$(CONFIG_JOYSTICK_COBRA)		+= cobra.o
 obj-$(CONFIG_JOYSTICK_DB9)		+= db9.o
+obj-$(CONFIG_JOYSTICK_MAPLE)		+= maplecontrol.o
 obj-$(CONFIG_JOYSTICK_GAMECON)		+= gamecon.o
 obj-$(CONFIG_JOYSTICK_GF2K)		+= gf2k.o
 obj-$(CONFIG_JOYSTICK_GRIP)		+= grip.o
diff --git a/drivers/input/joystick/maplecontrol.c b/drivers/input/joystick/maplecontrol.c
new file mode 100644
index 0000000..c2e8160
--- /dev/null
+++ b/drivers/input/joystick/maplecontrol.c
@@ -0,0 +1,193 @@
+/*
+ *	SEGA Dreamcast controller driver
+ *	Based on drivers/usb/iforce.c
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
+MODULE_DESCRIPTION("SEGA Dreamcast controller driver");
+MODULE_LICENSE("GPL");
+
+struct dc_pad {
+	struct input_dev *dev;
+	struct maple_device *mdev;
+};
+
+static void dc_pad_callback(struct mapleq *mq)
+{
+	unsigned short buttons;
+	struct maple_device *mapledev = mq->dev;
+	struct dc_pad *pad = maple_get_drvdata(mapledev);
+	struct input_dev *dev = pad->dev;
+	unsigned char *res = mq->recvbuf;
+
+	buttons = ~le16_to_cpup((__le16 *)(res + 8));
+
+	input_report_abs(dev, ABS_HAT0Y,
+		(buttons & 0x0010 ? -1 : 0) + (buttons & 0x0020 ? 1 : 0));
+	input_report_abs(dev, ABS_HAT0X,
+		(buttons & 0x0040 ? -1 : 0) + (buttons & 0x0080 ? 1 : 0));
+	input_report_abs(dev, ABS_HAT1Y,
+		(buttons & 0x1000 ? -1 : 0) + (buttons & 0x2000 ? 1 : 0));
+	input_report_abs(dev, ABS_HAT1X,
+		(buttons & 0x4000 ? -1 : 0) + (buttons & 0x8000 ? 1 : 0));
+
+	input_report_key(dev, BTN_C,      buttons & 0x0001);
+	input_report_key(dev, BTN_B,      buttons & 0x0002);
+	input_report_key(dev, BTN_A,      buttons & 0x0004);
+	input_report_key(dev, BTN_START,  buttons & 0x0008);
+	input_report_key(dev, BTN_Z,      buttons & 0x0100);
+	input_report_key(dev, BTN_Y,      buttons & 0x0200);
+	input_report_key(dev, BTN_X,      buttons & 0x0400);
+	input_report_key(dev, BTN_SELECT, buttons & 0x0800);
+
+	input_report_abs(dev, ABS_GAS,    res[10]);
+	input_report_abs(dev, ABS_BRAKE,  res[11]);
+	input_report_abs(dev, ABS_X,      res[12]);
+	input_report_abs(dev, ABS_Y,      res[13]);
+	input_report_abs(dev, ABS_RX,     res[14]);
+	input_report_abs(dev, ABS_RY,     res[15]);
+}
+
+static int dc_pad_open(struct input_dev *dev)
+{
+	struct dc_pad *pad = dev->dev.platform_data;
+
+	maple_getcond_callback(pad->mdev, dc_pad_callback, HZ/20,
+		MAPLE_FUNC_CONTROLLER);
+
+	return 0;
+}
+
+static void dc_pad_close(struct input_dev *dev)
+{
+	struct dc_pad *pad = dev->dev.platform_data;
+
+	maple_getcond_callback(pad->mdev, dc_pad_callback, 0,
+		MAPLE_FUNC_CONTROLLER);
+}
+
+/* allow the controller to be used */
+static int probe_maple_controller(struct device *dev)
+{
+	static const short btn_bit[32] = {
+		BTN_C, BTN_B, BTN_A, BTN_START, -1, -1, -1, -1,
+		BTN_Z, BTN_Y, BTN_X, BTN_SELECT, -1, -1, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+	};
+
+	static const short abs_bit[32] = {
+		-1, -1, -1, -1, ABS_HAT0Y, ABS_HAT0Y, ABS_HAT0X, ABS_HAT0X,
+		-1, -1, -1, -1, ABS_HAT1Y, ABS_HAT1Y, ABS_HAT1X, ABS_HAT1X,
+		ABS_GAS, ABS_BRAKE, ABS_X, ABS_Y, ABS_RX, ABS_RY, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+	};
+
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+	int i, error;
+	struct dc_pad *pad;
+	struct input_dev *idev;
+	unsigned long data = be32_to_cpu(mdev->devinfo.function_data[0]);
+
+	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
+	idev = input_allocate_device();
+	if (!pad || !idev) {
+		error = -ENOMEM;
+		goto fail;
+	}
+
+	pad->dev = idev;
+	pad->mdev = mdev;
+
+	idev->open = dc_pad_open;
+	idev->close = dc_pad_close;
+
+	for (i = 0; i < 32; i++) {
+		if (data & (1 << i)) {
+			if (btn_bit[i] >= 0)
+				__set_bit(btn_bit[i], idev->keybit);
+			else if (abs_bit[i] >= 0)
+				__set_bit(abs_bit[i], idev->absbit);
+		}
+	}
+
+	if (idev->keybit[BIT_WORD(BTN_JOYSTICK)])
+		idev->evbit[0] |= BIT_MASK(EV_KEY);
+
+	if (idev->absbit[0])
+		idev->evbit[0] |= BIT_MASK(EV_ABS);
+
+	for (i = ABS_X; i <= ABS_BRAKE; i++)
+		input_set_abs_params(idev, i, 0, 255, 0, 0);
+
+	for (i = ABS_HAT0X; i <= ABS_HAT3Y; i++)
+		input_set_abs_params(idev, i, 1, -1, 0, 0);
+
+	idev->dev.platform_data = pad;
+	idev->dev.parent = &mdev->dev;
+	idev->name = mdev->product_name;
+	idev->id.bustype = BUS_HOST;
+	input_set_drvdata(idev, pad);
+
+	error = input_register_device(idev);
+	if (error)
+		goto fail;
+
+	mdev->driver = mdrv;
+	maple_set_drvdata(mdev, pad);
+
+	return 0;
+
+fail:
+	input_free_device(idev);
+	kfree(pad);
+	maple_set_drvdata(mdev, NULL);
+	return error;
+}
+
+static int remove_maple_controller(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct dc_pad *pad = maple_get_drvdata(mdev);
+
+	mdev->callback = NULL;
+	input_unregister_device(pad->dev);
+	maple_set_drvdata(mdev, NULL);
+	kfree(pad);
+
+	return 0;
+}
+
+static struct maple_driver dc_pad_driver = {
+	.function =	MAPLE_FUNC_CONTROLLER,
+	.drv = {
+		.name	= "Dreamcast_controller",
+		.probe	= probe_maple_controller,
+		.remove	= remove_maple_controller,
+	},
+};
+
+static int __init dc_pad_init(void)
+{
+	return maple_driver_register(&dc_pad_driver);
+}
+
+static void __exit dc_pad_exit(void)
+{
+	maple_driver_unregister(&dc_pad_driver);
+}
+
+module_init(dc_pad_init);
+module_exit(dc_pad_exit);
