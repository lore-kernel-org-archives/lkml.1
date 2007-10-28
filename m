Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXJ1Vbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXJ1Vbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXJ1Vbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:31:34 -0400
Received: from mailgw2.3essentials.com ([66.179.153.59]:4194 "EHLO
	mailgw2.3essentials.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXJ1Vbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:31:33 -0400
Message-ID: <4724FF8F.30306@antonello.org>
Date: Sun, 28 Oct 2007 22:30:55 +0100
From: "lists@antonello.org" <lists@antonello.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Samuel Tardieu <sam@rfc1149.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight dimmer
References: <4724B48D.6090405@antonello.org> <87y7dndxm3.fsf@willow.rfc1149.net>
In-Reply-To: <87y7dndxm3.fsf@willow.rfc1149.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok,
  now checkpatch.pl only complains about a missing signed-off-by.
Is this ok for review?

jacopo


--- linux-2.6.23.1/include/linux/backlight.h	2007-10-12 18:43:44.000000000 +0200
+++ b/include/linux/backlight.h	2007-10-28 21:14:21.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
+#include <linux/timeout.h>
 
 /* Notes on locking:
  *
@@ -70,6 +71,12 @@ struct backlight_device {
 	/* The framebuffer notifier block */
 	struct notifier_block fb_notif;
 
+  /* dimmer stuff */
+	struct timeout *timeout;
+	struct input_handler *input_handler;
+	unsigned short dimmer_low_level;
+	unsigned short dimmer_high_level;
+
 	struct device dev;
 };
 
--- linux-2.6.23.1/drivers/video/backlight/Makefile	2007-10-12 18:43:44.000000000 +0200
+++ b/drivers/video/backlight/Makefile	2007-10-28 16:42:09.000000000 +0100
@@ -1,7 +1,7 @@
 # Backlight & LCD drivers
 
 obj-$(CONFIG_LCD_CLASS_DEVICE)     += lcd.o
-obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
+obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o timeout.o
 obj-$(CONFIG_BACKLIGHT_CORGI)	+= corgi_bl.o
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
--- linux-2.6.23.1/include/linux/timeout.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/linux/timeout.h	2007-10-28 21:14:27.000000000 +0100
@@ -0,0 +1,68 @@
+/*
+ *  timeout.h - simple timeout
+ *
+ *
+ *  Copyright (C) 2007 Jacopo Antonello <jack@antonello.org>
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
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#ifndef _TIMEOUT_H_
+#define _TIMEOUT_H_
+
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+enum timeout_state {
+	TIMEOUT_RUNNING,
+	TIMEOUT_TRIGGERED,
+	TIMEOUT_FINILIZED
+};
+
+struct timeout {
+	/* allow either start() or trigger() at a time */
+	struct mutex lock;
+	/* serialize updates to latest */
+	spinlock_t latest_lock;
+	struct delayed_work trigger_worker;
+	struct work_struct start_worker;
+	unsigned long latest;
+	enum timeout_state state;
+
+	unsigned long duration; /* client defined duration */
+	unsigned long data; /* client data */
+	void (*trigger)(unsigned long); /* client function */
+	void (*start)(unsigned long); /* client function */
+};
+
+extern void timeout_touch(struct timeout *timeout);
+
+extern void timeout_init(struct timeout *timeout);
+
+extern void timeout_kill(struct timeout *timeout);
+
+static inline int timeout_sec2jiffies(int secs)
+{
+	return secs * HZ;
+}
+
+static inline int timeout_jif2sec(unsigned long jif)
+{
+	return jif / HZ;
+}
+
+#endif
--- linux-2.6.23.1/drivers/video/backlight/timeout.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/video/backlight/timeout.c	2007-10-28 21:18:09.000000000 +0100
@@ -0,0 +1,135 @@
+/*
+ *  timeout.c - simple timeout
+ *
+ *
+ *  Copyright (C) 2007 Jacopo Antonello <jack@antonello.org>
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
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/timeout.h>
+
+
+/* atomic context helpers for timeout->latest */
+static inline unsigned long read_latest(struct timeout *timeout)
+{
+	unsigned long ret;
+	spin_lock(&timeout->latest_lock);
+	ret = timeout->latest;
+	spin_unlock(&timeout->latest_lock);
+	return ret;
+}
+
+static inline unsigned long elapsed(struct timeout *timeout)
+{
+	unsigned long elapsed;
+	spin_lock(&timeout->latest_lock);
+	elapsed = jiffies - timeout->latest;
+	spin_unlock(&timeout->latest_lock);
+	return elapsed;
+}
+
+static inline void touch_latest(struct timeout *timeout)
+{
+	spin_lock(&timeout->latest_lock);
+	timeout->latest = jiffies;
+	spin_unlock(&timeout->latest_lock);
+}
+
+/* non-atomic context */
+static void trigger_worker_function(struct work_struct *work)
+{
+	struct timeout *timeout = container_of(work, struct timeout,
+			trigger_worker.work);
+
+	mutex_lock(&timeout->lock);
+
+	/* flag to kill worker */
+	if (timeout->state != TIMEOUT_RUNNING)
+		goto exit;
+
+	if (elapsed(timeout) >= timeout->duration) {
+    pr_debug("tigger_worker_function() -> timeout->trigger()"
+				" (elapsed: %ld ms) \n",
+				(elapsed(timeout) * 1000 / (HZ)));
+		timeout->state = TIMEOUT_TRIGGERED;
+		timeout->trigger(timeout->data);
+	} else {
+		unsigned long new_delay = (read_latest(timeout) - jiffies) +
+			timeout->duration;
+		pr_debug("tigger_worker_function() -> schedule_delayed_work() "
+				"(new_delay: %ld jif %ld ms)\n",
+				new_delay, new_delay * 1000 / (HZ));
+		schedule_delayed_work(&timeout->trigger_worker, new_delay);
+	}
+
+exit:
+		mutex_unlock(&timeout->lock);
+}
+
+/* non-atomic context */
+static void start_worker_function(struct work_struct *work)
+{
+	struct timeout *timeout = container_of(work,
+			struct timeout, start_worker);
+
+	pr_debug("start_worker_function() -> timeout->start()\n");
+	timeout->start(timeout->data);
+	schedule_delayed_work(&timeout->trigger_worker, timeout->duration);
+}
+
+/* atomic context touch */
+void timeout_touch(struct timeout *timeout)
+{
+	touch_latest(timeout);
+
+	if (timeout->state == TIMEOUT_TRIGGERED &&
+			mutex_trylock(&timeout->lock)) {
+
+		if (timeout->state == TIMEOUT_TRIGGERED) {
+			timeout->state = TIMEOUT_RUNNING;
+			schedule_work(&timeout->start_worker);
+		}
+
+		mutex_unlock(&timeout->lock);
+	}
+}
+EXPORT_SYMBOL(timeout_touch);
+
+void timeout_init(struct timeout *timeout)
+{
+	mutex_init(&timeout->lock);
+	spin_lock_init(&timeout->latest_lock);
+	INIT_DELAYED_WORK(&timeout->trigger_worker, trigger_worker_function);
+	INIT_WORK(&timeout->start_worker, start_worker_function);
+	timeout->state = TIMEOUT_TRIGGERED;
+}
+EXPORT_SYMBOL(timeout_init);
+
+void timeout_kill(struct timeout *timeout)
+{
+	mutex_lock(&timeout->lock);
+	if (timeout->state == TIMEOUT_RUNNING)
+		cancel_delayed_work_sync(&timeout->trigger_worker);
+
+	flush_scheduled_work();
+	timeout->state = TIMEOUT_FINILIZED;
+	mutex_unlock(&timeout->lock);
+}
+EXPORT_SYMBOL(timeout_kill);
--- linux-2.6.23.1/drivers/video/backlight/backlight.c	2007-10-12 18:43:44.000000000 +0200
+++ b/drivers/video/backlight/backlight.c	2007-10-28 21:29:18.000000000 +0100
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/input.h>
 #include <linux/backlight.h>
 #include <linux/notifier.h>
 #include <linux/ctype.h>
@@ -172,13 +173,282 @@ static void bl_device_release(struct dev
 	kfree(bd);
 }
 
+/*
+ * ---------------------------------------------------
+ *           backlight dimmer
+ * --------------------------------------------------
+ */
+
+static const struct input_device_id idi_dimmer[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT(EV_KEY) },
+	}, /* key event */
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_RELBIT,
+		.relbit = { BIT(REL_X) | BIT(REL_Y) | BIT(REL_WHEEL) },
+	},	/* rel axes */
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_ABSBIT,
+		.absbit = { BIT(ABS_X) | BIT(ABS_Y) },
+	},	/* abs axes */
+	{ }
+};
+
+static void handler_event(struct input_handle *handle, unsigned int type,
+		unsigned int code, int value)
+{
+	struct backlight_device *dev =
+		(struct backlight_device *)handle->private;
+
+	switch (type) {
+	case EV_KEY:
+	case EV_REL:
+			timeout_touch(dev->timeout);
+	}
+}
+
+static void dimmer_start(unsigned long data)
+{
+	struct backlight_device *bd = (struct backlight_device *)data;
+
+	pr_debug("switch to high level\n");
+	bd->props.brightness = bd->dimmer_high_level;
+	backlight_update_status(bd);
+}
+
+static void dimmer_trigger(unsigned long data)
+{
+	struct backlight_device *bd = (struct backlight_device *)data;
+
+	pr_debug("switch to low level\n");
+	bd->props.brightness = bd->dimmer_low_level;
+	backlight_update_status(bd);
+}
+
+static int handler_connect(struct input_handler *handler, struct input_dev *dev,
+		const struct input_device_id *id)
+{
+	int error = 0;
+	struct input_handle *handle;
+
+
+	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->handler = handler;
+	handle->dev = dev;
+	handle->name = "backlight";
+	handle->private = handler->private;
+
+	error = input_register_handle(handle);
+	if (error)
+		goto err_free_handle;
+
+	error = input_open_device(handle);
+	if (error)
+		goto err_unregister_handle;
+
+	return 0;
+
+err_unregister_handle:
+		input_unregister_handle(handle);
+err_free_handle:
+		kfree(handle);
+	return error;
+}
+
+static void handler_disconnect(struct input_handle *handle)
+{
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(handle);
+}
+
+static int enable_dimmer(struct backlight_device *dev)
+{
+	pr_debug("enable_dimmer()\n");
+	dev->input_handler = kzalloc(sizeof(struct input_handler), GFP_KERNEL);
+	if (!dev->input_handler)
+		return -ENOMEM;
+
+	if (!dev->dimmer_low_level)
+		dev->dimmer_low_level = dev->props.max_brightness/2;
+	if (!dev->dimmer_high_level)
+		dev->dimmer_high_level = dev->props.max_brightness;
+
+	dev->input_handler->event = handler_event;
+	dev->input_handler->connect = handler_connect;
+	dev->input_handler->disconnect = handler_disconnect;
+	dev->input_handler->name = "backlight";
+	dev->input_handler->id_table = idi_dimmer;
+	dev->input_handler->private = dev;
+
+	dev->timeout = kzalloc(sizeof(struct timeout), GFP_KERNEL);
+	if (!dev->timeout)
+		goto free_handler;
+
+	timeout_init(dev->timeout);
+	dev->timeout->duration = timeout_sec2jiffies(5);
+	dev->timeout->data = (unsigned long)dev;
+	dev->timeout->trigger = dimmer_trigger;
+	dev->timeout->start = dimmer_start;
+
+	if (!input_register_handler(dev->input_handler))
+		return 0; /* success */
+	/* else go on & cleanup */
+
+free_handler:
+		kfree(dev->input_handler);
+		dev->input_handler = NULL;
+		return -ENOMEM;
+}
+
+static void disable_dimmer(struct backlight_device *dev)
+{
+	if (!dev->input_handler)
+		return;
+
+	input_unregister_handler(dev->input_handler);
+	timeout_kill(dev->timeout);
+	kfree(dev->input_handler);
+	kfree(dev->timeout);
+	dev->input_handler = NULL;
+	dev->timeout = NULL;
+	pr_debug("disable_dimmer()\n");
+}
+
+/* show */
+static ssize_t show_dimmer_control(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			(bd->input_handler != NULL));
+}
+
+static ssize_t show_dimmer_timeout(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	if (bd->timeout)
+		return snprintf(buf, PAGE_SIZE, "%d\n",
+				timeout_jif2sec(bd->timeout->duration));
+	else
+		return 0;
+}
+
+static ssize_t show_dimmer_low_level(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			bd->dimmer_low_level);
+}
+
+static ssize_t show_dimmer_high_level(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			bd->dimmer_high_level);
+}
+
+/* store */
+static ssize_t store_dimmer_control(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	char *endp;
+	int control = simple_strtoul(buf, &endp, 0);
+
+	mutex_lock(&bd->ops_lock);
+	if (control == 1 && !bd->input_handler)
+		enable_dimmer(bd);
+	else if (control == 0 && bd->input_handler)
+		disable_dimmer(bd);
+	mutex_unlock(&bd->ops_lock);
+
+	return count;
+}
+
+static ssize_t store_dimmer_timeout(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	char *endp;
+	int timeout = simple_strtoul(buf, &endp, 0);
+
+	if (timeout <= 0 || timeout >= 60*30)
+		return -ENXIO;
+
+	mutex_lock(&bd->ops_lock);
+	if (!bd->timeout) {
+		mutex_unlock(&bd->ops_lock);
+		return -ENXIO;
+	}
+	bd->timeout->duration = timeout_sec2jiffies(timeout);
+	mutex_unlock(&bd->ops_lock);
+
+	return count;
+}
+
+static ssize_t store_dimmer_low_level(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	char *endp;
+	int low = simple_strtoul(buf, &endp, 0);
+
+	if (low < 0 || low > bd->props.max_brightness)
+		return -ENXIO;
+
+	mutex_lock(&bd->ops_lock);
+	bd->dimmer_low_level = low;
+	mutex_unlock(&bd->ops_lock);
+
+	return count;
+}
+
+static ssize_t store_dimmer_high_level(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	char *endp;
+	int high = simple_strtoul(buf, &endp, 0);
+
+	if (high < 0 || high > bd->props.max_brightness)
+		return -ENXIO;
+
+	mutex_lock(&bd->ops_lock);
+	bd->dimmer_high_level = high;
+	mutex_unlock(&bd->ops_lock);
+
+	return count;
+}
+
 static struct device_attribute bl_device_attributes[] = {
 	__ATTR(bl_power, 0644, backlight_show_power, backlight_store_power),
 	__ATTR(brightness, 0644, backlight_show_brightness,
-		     backlight_store_brightness),
+				 backlight_store_brightness),
 	__ATTR(actual_brightness, 0444, backlight_show_actual_brightness,
-		     NULL),
+				 NULL),
 	__ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
+	__ATTR(dimmer_control, 0666, show_dimmer_control, store_dimmer_control),
+	__ATTR(dimmer_timeout, 0666, show_dimmer_timeout, store_dimmer_timeout),
+	__ATTR(dimmer_low_level, 0666, show_dimmer_low_level,
+			store_dimmer_low_level),
+	__ATTR(dimmer_high_level, 0666, show_dimmer_high_level,
+			store_dimmer_high_level),
 	__ATTR_NULL,
 };
 
@@ -259,6 +529,7 @@ void backlight_device_unregister(struct 
 #endif
 	mutex_lock(&bd->ops_lock);
 	bd->ops = NULL;
+	disable_dimmer(bd);
 	mutex_unlock(&bd->ops_lock);
 
 	backlight_unregister_fb(bd);

