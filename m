Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbXCYUb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbXCYUb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 16:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbXCYUb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 16:31:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35498 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXCYUb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 16:31:57 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 25 Mar 2007 16:28:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] INPUT: Delete unused source file drivers/input/power.c.
Message-ID: <Pine.LNX.4.64.0703251624330.31635@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Delete the never-compiled source file drivers/input/power.c, and
remove its entry from the corresponding Makefile, as there is no
Kconfig file that refers to the config option INPUT_POWER.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index da575de..b4cd106 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -13,7 +13,6 @@ obj-$(CONFIG_INPUT_MOUSEDEV)	+= mousedev.o
 obj-$(CONFIG_INPUT_JOYDEV)	+= joydev.o
 obj-$(CONFIG_INPUT_EVDEV)	+= evdev.o
 obj-$(CONFIG_INPUT_TSDEV)	+= tsdev.o
-obj-$(CONFIG_INPUT_POWER)	+= power.o
 obj-$(CONFIG_INPUT_EVBUG)	+= evbug.o

 obj-$(CONFIG_INPUT_KEYBOARD)	+= keyboard/
diff --git a/drivers/input/power.c b/drivers/input/power.c
deleted file mode 100644
index ee82464..0000000
--- a/drivers/input/power.c
+++ /dev/null
@@ -1,166 +0,0 @@
-/*
- * $Id: power.c,v 1.10 2001/09/25 09:17:15 vojtech Exp $
- *
- *  Copyright (c) 2001 "Crazy" James Simmons
- *
- *  Input driver Power Management.
- *
- *  Sponsored by Transvirtual Technology.
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * Should you need to contact me, the author, you can do so by
- * e-mail - mail your message to <jsimmons@transvirtual.com>.
- */
-
-#include <linux/module.h>
-#include <linux/input.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/tty.h>
-#include <linux/delay.h>
-#include <linux/pm.h>
-
-static struct input_handler power_handler;
-
-/*
- * Power management can't be done in a interrupt context. So we have to
- * use keventd.
- */
-static int suspend_button_pushed = 0;
-static void suspend_button_task_handler(void *data)
-{
-        udelay(200); /* debounce */
-        suspend_button_pushed = 0;
-}
-
-static DECLARE_WORK(suspend_button_task, suspend_button_task_handler, NULL);
-
-static void power_event(struct input_handle *handle, unsigned int type,
-		        unsigned int code, int down)
-{
-	struct input_dev *dev = handle->dev;
-
-	printk("Entering power_event\n");
-
-	if (type == EV_PWR) {
-		switch (code) {
-			case KEY_SUSPEND:
-				printk("Powering down entire device\n");
-
-				if (!suspend_button_pushed) {
-                			suspend_button_pushed = 1;
-                        		schedule_work(&suspend_button_task);
-                		}
-				break;
-			case KEY_POWER:
-				/* Hum power down the machine. */
-				break;
-			default:
-				return;
-		}
-	}
-
-	if (type == EV_KEY) {
-		switch (code) {
-			case KEY_SUSPEND:
-				printk("Powering down input device\n");
-				/* This is risky. See pm.h for details. */
-				if (dev->state != PM_RESUME)
-					dev->state = PM_RESUME;
-				else
-					dev->state = PM_SUSPEND;
-				pm_send(dev->pm_dev, dev->state, dev);
-				break;
-			case KEY_POWER:
-				/* Turn the input device off completely ? */
-				break;
-			default:
-				return;
-		}
-	}
-	return;
-}
-
-static struct input_handle *power_connect(struct input_handler *handler,
-					  struct input_dev *dev,
-					  const struct input_device_id *id)
-{
-	struct input_handle *handle;
-
-	if (!(handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL)))
-		return NULL;
-
-	handle->dev = dev;
-	handle->handler = handler;
-
-	input_open_device(handle);
-
-	printk(KERN_INFO "power.c: Adding power management to input layer\n");
-	return handle;
-}
-
-static void power_disconnect(struct input_handle *handle)
-{
-	input_close_device(handle);
-	kfree(handle);
-}
-
-static const struct input_device_id power_ids[] = {
-	{
-		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT(EV_KEY) },
-		.keybit = { [LONG(KEY_SUSPEND)] = BIT(KEY_SUSPEND) }
-	},
-	{
-		.flags = INPUT_DEVICE_ID_MATCH_EVBIT | INPUT_DEVICE_ID_MATCH_KEYBIT,
-		.evbit = { BIT(EV_KEY) },
-		.keybit = { [LONG(KEY_POWER)] = BIT(KEY_POWER) }
-	},
-	{
-		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
-		.evbit = { BIT(EV_PWR) },
-	},
-	{ }, 	/* Terminating entry */
-};
-
-MODULE_DEVICE_TABLE(input, power_ids);
-
-static struct input_handler power_handler = {
-	.event =	power_event,
-	.connect =	power_connect,
-	.disconnect =	power_disconnect,
-	.name =		"power",
-	.id_table =	power_ids,
-};
-
-static int __init power_init(void)
-{
-	return input_register_handler(&power_handler);
-}
-
-static void __exit power_exit(void)
-{
-	input_unregister_handler(&power_handler);
-}
-
-module_init(power_init);
-module_exit(power_exit);
-
-MODULE_AUTHOR("James Simmons <jsimmons@transvirtual.com>");
-MODULE_DESCRIPTION("Input Power Management driver");
-MODULE_LICENSE("GPL");
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
