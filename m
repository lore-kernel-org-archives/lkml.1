Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbYABBD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbYABBD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 20:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbYABBDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 20:03:17 -0500
Received: from tim.rpsys.net ([194.106.48.114]:54347 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbYABBDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 20:03:16 -0500
Subject: [RFC PATCH] Add input event to APM event bridge for embedded
	devices
From: Richard Purdie <rpurdie@rpsys.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Wed, 02 Jan 2008 01:03:09 +0000
Message-Id: <1199235789.4653.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a very simple input power event to APM user suspend
event bridge. Its currently only works for the systems using the
emulated APM driver but could easily be extended to work with anything
with a true APM BIOS too.

This covers a standard embedded system need which is to suspend when the
user presses a suspend button. It leaves options open to system
integrators to ignore (or unload) this code and implement their own more
complex event handling system.

Its hidden behind the EMBEDDED Kconfig option since its only likely to
be of use to embedded style systems. It can be built as a module so the
"hardcoded" policy can easily be removed from the kernel at runtime if
desired too.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

---

 drivers/input/Kconfig     |   12 ++++
 drivers/input/Makefile    |    1 
 drivers/input/apm-power.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 138 insertions(+)

Index: kernel-hacking/drivers/input/Kconfig
===================================================================
--- kernel-hacking.orig/drivers/input/Kconfig	2008-01-01 23:50:13.000000000 +0000
+++ kernel-hacking/drivers/input/Kconfig	2008-01-02 00:45:33.000000000 +0000
@@ -137,6 +137,18 @@ config INPUT_EVBUG
 	  To compile this driver as a module, choose M here: the
 	  module will be called evbug.
 
+config INPUT_APMPOWER
+	tristate "Input Power Event -> APM Bridge" if EMBEDDED
+	depends on INPUT && APM_EMULATION
+	---help---
+	  Say Y here if you want suspend key events to trigger a user
+	  requested suspend through APM. This is useful on embedded
+	  systems where such behviour is desired without userspace
+	  interaction. If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called apm-power.
+
 comment "Input Device Drivers"
 
 source "drivers/input/keyboard/Kconfig"
Index: kernel-hacking/drivers/input/Makefile
===================================================================
--- kernel-hacking.orig/drivers/input/Makefile	2008-01-01 23:50:13.000000000 +0000
+++ kernel-hacking/drivers/input/Makefile	2008-01-02 00:39:03.000000000 +0000
@@ -22,3 +22,4 @@ obj-$(CONFIG_INPUT_TABLET)	+= tablet/
 obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
 
+obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
Index: kernel-hacking/drivers/input/apm-power.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ kernel-hacking/drivers/input/apm-power.c	2008-01-02 00:43:42.000000000 +0000
@@ -0,0 +1,125 @@
+/*
+ *  Input Power Event -> APM Bridge
+ *
+ *  Copyright (c) 2007 Richard Purdie
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/tty.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/apm-emulation.h>
+
+static void system_power_event(unsigned int keycode)
+{
+	switch (keycode) {
+		case KEY_SUSPEND:
+			apm_queue_event(APM_USER_SUSPEND);
+
+			printk(KERN_INFO "apm-power: Requesting system suspend...\n");
+			break;
+		default:
+			break;
+	}
+}
+
+static void apmpower_event(struct input_handle *handle, unsigned int type,
+		        unsigned int code, int value)
+{
+	/* only react on key down events */
+	if (value != 1)
+		return;
+
+	switch (type) {
+		case EV_PWR:
+			system_power_event(code);
+			break;
+
+		default:
+			break;
+	}
+}
+
+static int apmpower_connect(struct input_handler *handler,
+					  struct input_dev *dev,
+					  const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int err;
+
+	if (!(handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL)))
+		return -ENOMEM;
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "apm-power";
+
+	handler->private = handle;
+	err = input_register_handle(handle);
+	if (err < 0) {
+		printk(KERN_ERR "apm-power.c: Failed to register input power handler\n");
+		kfree(handle);
+		return err;
+	}
+
+	err = input_open_device(handle);
+	if (err < 0) {
+		printk(KERN_ERR "apm-power.c: Failed to open input power device\n");
+		input_unregister_handle(handle);
+		kfree(handle);
+		return err;
+	}
+
+	return 0;
+}
+
+static void apmpower_disconnect(struct input_handle *handler)
+{
+	struct input_handle *handle = handler->private;
+
+	input_close_device(handle);
+	kfree(handle);
+}
+
+static const struct input_device_id apmpower_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_PWR) },
+	},
+	{ },
+};
+
+MODULE_DEVICE_TABLE(input, apmpower_ids);
+
+static struct input_handler apmpower_handler = {
+	.event =	apmpower_event,
+	.connect =	apmpower_connect,
+	.disconnect =	apmpower_disconnect,
+	.name =		"apm-power",
+	.id_table =	apmpower_ids,
+};
+
+static int __init apmpower_init(void)
+{
+	return input_register_handler(&apmpower_handler);
+}
+
+static void __exit apmpower_exit(void)
+{
+	input_unregister_handler(&apmpower_handler);
+}
+
+module_init(apmpower_init);
+module_exit(apmpower_exit);
+
+MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
+MODULE_DESCRIPTION("Input Power Event -> APM Bridge");
+MODULE_LICENSE("GPL");

