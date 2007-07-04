Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbXGDW7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbXGDW7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbXGDW7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:59:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34036 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753091AbXGDW7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:59:37 -0400
Date: Thu, 5 Jul 2007 00:59:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Andi Kleen <ak@suse.de>,
       Indan Zupancic <indan@nul.nu>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de, rpurdie@rpsys.net
Subject: Re: blink driver power saving
Message-ID: <20070704225920.GA1687@elf.ucw.cz>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021439.27357.ak@suse.de> <20070702230827.GA9071@elf.ucw.cz> <200707030142.36252.dtor@insightbb.com> <20070704223200.GA2053@elf.ucw.cz> <alpine.LFD.0.98.0707041545490.9434@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0707041545490.9434@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Actually here's one that does not immediately oops when I plug USB
> > keyboard in.
> 
> Why do you use a delayed workqueue and then always use it without a delay? 
> That seems silly.

I copied code from Dmitry :-); guess I copied too much. Here's updated
version:

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 87d2046..716620c 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -95,6 +95,13 @@ config LEDS_COBALT
 	help
 	  This option enables support for the front LED on Cobalt Server
 
+config LEDS_INPUT
+	tristate "LED Support for input layer keyboards"
+	depends on LEDS_CLASS
+	help
+	  This option enables support for LEDs on keyboards handled by
+	  input layer.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index aa2c18e..ea58020 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -16,8 +16,10 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net4
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
+obj-$(CONFIG_LEDS_INPUT)		+= leds-input.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
+
diff --git a/drivers/leds/leds-input.c b/drivers/leds/leds-input.c
new file mode 100644
index 0000000..8caca35
--- /dev/null
+++ b/drivers/leds/leds-input.c
@@ -0,0 +1,153 @@
+/*
+ * LED <-> input subsystem glue
+ *
+ * Copyright 2007 Pavel Machek <pavel@suse.cz>
+ * Copyright 2007 Dmitry Torokhov
+ * Copyright 2005-2006 Openedhand Ltd.
+ *
+ * Author: Pavel Machek <pavel@suse.cz>
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
+	struct delayed_work work;
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
+	schedule_delayed_work(&blinker->work, 0);
+}
+
+static void blink_task_handler(struct work_struct *work)
+{
+	struct blinker *blinker = container_of(work, struct blinker, work.work);
+	printk("Setting led to %d\n", blinker->state);
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
+	INIT_DELAYED_WORK(&blinker->work, blink_task_handler);
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
+	cancel_rearming_delayed_work(&blinker->work);
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(blinker);
+}
+
+static const struct input_device_id blink_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_LEDBIT,
+		.evbit = { BIT(EV_LED) },
+		.ledbit = { [LONG(LED_CAPSL)] = BIT(LED_CAPSL) },
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
diff --git a/drivers/leds/leds-spitz.c b/drivers/leds/leds-spitz.c
index 126d09c..8d10274 100644
--- a/drivers/leds/leds-spitz.c
+++ b/drivers/leds/leds-spitz.c
@@ -1,5 +1,5 @@
 /*
- * LED Triggers Core
+ * SPITZ LED Driver
  *
  * Copyright 2005-2006 Openedhand Ltd.
  *


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
