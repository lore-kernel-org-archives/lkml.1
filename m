Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbZKTUq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbZKTUq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZKTUqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:46:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55103 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbZKTUqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:46:21 -0500
Date: Fri, 20 Nov 2009 21:46:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
Message-ID: <20091120204612.GA31728@elf.ucw.cz>
References: <20091116225429.GB4764@const.famille.thibault.fr>
 <20091116230523.GC24961@x200>
 <20091116231520.GD4764@const.famille.thibault.fr>
 <20091117115503.GB1657@x200>
 <20091117132358.GJ12736@const.bordeaux.inria.fr>
 <20091119131854.GA1628@x200.localdomain>
 <20091119132828.GA31025@const.bordeaux.inria.fr>
 <20091119133737.GE31025@const.bordeaux.inria.fr>
 <4B055F24.8030307@zytor.com>
 <20091120190730.GB1434@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120190730.GB1434@ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > So we agree, and so the right solution is to either completely rework
> > > the interface (ugh), or just add LED routing (which can be very useful,
> > > actually, I for instance don't care at all about the num lock state, but
> > > I _do_ care about the lock that lets me shift between different keyboard
> > > layouts).
> > > 
> > 
> > Adding LED routing and using keyboard levels is so clearly The Right Thing.
> > 
> > We already allow the LEDs to be programmed; we should probably just
> > have, for each LED, the ability to program it off/on/flashing/connected
> > to modifier #X.
> > 
> > The current KDSETLED/KDGETLED interface is of course too limited for
> > this -- we need an interface with at least a byte per LED.
> 
> Actually, we already have very nice /sys/class/led interface, and we
> should just use it for keyboard leds, too. Actually I have a patch,
> somewhere...

Like this... But it should probably be slightly more complex -- like
making numlock/capslock/scrollock leds into trigers, and then
move input LED lowlevels into drivers/led...

Signed-off-by: Pavel Machek <pavel@ucw.cz> (but...)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e4f599f..c80fee8 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -96,6 +96,13 @@ config LEDS_COBALT_RAQ
 	help
 	  This option enables support for the Cobalt Raq series LEDs.
 
+config LEDS_INPUT
+	tristate "LED Support for input layer keyboards"
+	depends on LEDS_CLASS
+	help
+	  This option enables support for LEDs on keyboards handled by
+	  input layer.
+
 config LEDS_SUNFIRE
 	tristate "LED support for SunFire servers."
 	depends on LEDS_CLASS && SPARC64
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 46d7270..71bde81 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_ALIX2)		+= leds-alix2.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
+obj-$(CONFIG_LEDS_INPUT)		+= leds-input.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
diff --git a/drivers/leds/leds-input.c b/drivers/leds/leds-input.c
new file mode 100644
index 0000000..8ffb4fc
--- /dev/null
+++ b/drivers/leds/leds-input.c
@@ -0,0 +1,151 @@
+/*
+ * LED <-> input subsystem glue
+ *
+ * Copyright 2007 Pavel Machek <pavel@ucw.cz>
+ * Copyright 2007 Dmitry Torokhov
+ * Copyright 2005-2006 Openedhand Ltd.
+ *
+ * Author: Pavel Machek <pavel@ucw.cz>
+ * Based on code by: Richard Purdie <rpurdie@openedhand.com>
+ * 		     
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/init.h>
+
+struct blinker {
+	struct work_struct work;
+	struct input_handle handle;
+	int state;
+
+	struct led_classdev dev;
+};
+
+struct blinker *blinker;
+
+static void inputled_set(struct led_classdev *led_cdev, enum led_brightness value)
+{
+	struct blinker *blinker = container_of(led_cdev, struct blinker, dev);
+	blinker->state = value;
+	schedule_work(&blinker->work);
+}
+
+static void blink_task_handler(struct work_struct *work)
+{
+	struct blinker *blinker = container_of(work, struct blinker, work);
+	input_inject_event(&blinker->handle, EV_LED, LED_CAPSL, !!blinker->state);
+}
+
+static void blink_event(struct input_handle *handle, unsigned int type,
+		        unsigned int code, int down)
+{
+	/*
+	 * This is a very rare handler that does not process any input
+	 * events; just injects them.
+	 */
+}
+
+static int blink_connect(struct input_handler *handler, struct input_dev *dev,
+			  const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	struct led_classdev *led_dev;
+	static int counter;
+	int error;
+
+	blinker = kzalloc(sizeof(struct blinker), GFP_KERNEL);
+	if (!blinker) {
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&blinker->work, blink_task_handler);
+
+	led_dev = &blinker->dev;
+	led_dev->name = kmalloc(10, GFP_KERNEL);
+	sprintf(led_dev->name, "input%d", counter++);
+	led_dev->brightness_set = inputled_set;
+
+	handle = &blinker->handle;
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "blink";
+	handle->private = blinker;
+
+	error = input_register_handle(handle);
+	if (error)
+		goto err_free_handle;
+
+	error = input_open_device(handle);
+	if (error)
+		goto err_unregister_handle;
+
+	error = led_classdev_register(NULL, led_dev);
+	if (error < 0)
+		goto err_input_close_device;
+
+	return 0;
+
+ err_input_close_device:
+	input_close_device(handle);
+ err_unregister_handle:
+	input_unregister_handle(handle);
+ err_free_handle:
+	kfree(handle);
+	return error;
+}
+
+static void blink_disconnect(struct input_handle *handle)
+{
+	struct blinker *blinker = handle->private;
+
+	led_classdev_unregister(&blinker->dev);
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(blinker);
+}
+
+static const struct input_device_id blink_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_LEDBIT,
+		.evbit = { BIT(EV_LED) },
+		.ledbit = { [LED_CAPSL] = BIT(LED_CAPSL) },
+	},
+	{ }
+};
+
+static struct input_handler blink_handler = {
+	.event		= blink_event,
+	.connect	= blink_connect,
+	.disconnect	= blink_disconnect,
+	.name		= "blink",
+	.id_table	= blink_ids,
+};
+
+static int __init blink_handler_init(void)
+{
+	return input_register_handler(&blink_handler);
+}
+
+static void __exit blink_handler_exit(void)
+{
+	input_unregister_handler(&blink_handler);
+	flush_scheduled_work();
+}
+
+module_init(blink_handler_init);
+module_exit(blink_handler_exit);
+
+


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
