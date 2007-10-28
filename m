Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXJ1PwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXJ1PwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXJ1Pv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:51:58 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60004 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbXJ1Pv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:51:57 -0400
Date: Sun, 28 Oct 2007 16:52:12 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Nick Sillik <n.sillik@temple.edu>, David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, dmitry.torokhov@gmail.com
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: [RFC: 2.6 patch] remove the USB_STORAGE_ONETOUCH driver
Message-ID: <20071028155212.GC7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nearly two years ago, USB_STORAGE_ONETOUCH got a dependency on !PM.
Considering that this also implies that the driver is not available
e.g. when ACPI is enabled in the kernel that's not far from a dependency 
on BROKEN.

This patch therefore removes this driver.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/usb/storage/Kconfig        |   12 -
 drivers/usb/storage/Makefile       |    1 
 drivers/usb/storage/onetouch.c     |  237 -----------------------------
 drivers/usb/storage/onetouch.h     |    9 -
 drivers/usb/storage/unusual_devs.h |   17 --
 drivers/usb/storage/usb.c          |    3 
 6 files changed, 279 deletions(-)

876e6730e6fb60856da318ad652a912757359f44 
diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 7e53333..9b7df5f 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -121,18 +121,6 @@ config USB_STORAGE_ALAUDA
 	  These devices are based on the Alauda chip and support both
 	  XD and SmartMedia cards.
 
-config USB_STORAGE_ONETOUCH
-	bool "Support OneTouch Button on Maxtor Hard Drives (EXPERIMENTAL)"
-	depends on USB_STORAGE && INPUT_EVDEV && EXPERIMENTAL && !PM
-	help
-	  Say Y here to include additional code to support the Maxtor OneTouch
-	  USB hard drive's onetouch button.
-
-	  This code registers the button on the front of Maxtor OneTouch USB
-	  hard drive's as an input device. An action can be associated with
-	  this input in any keybinding software. (e.g. gnome's keyboard short-
-	  cuts)
-
 config USB_STORAGE_KARMA
 	bool "Support for Rio Karma music player"
 	depends on USB_STORAGE
diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index 023969b..a93ae7a 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -19,7 +19,6 @@ usb-storage-obj-$(CONFIG_USB_STORAGE_ISD200)	+= isd200.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_DATAFAB)	+= datafab.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_JUMPSHOT)	+= jumpshot.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_ALAUDA)	+= alauda.o
-usb-storage-obj-$(CONFIG_USB_STORAGE_ONETOUCH)	+= onetouch.o
 usb-storage-obj-$(CONFIG_USB_STORAGE_KARMA)	+= karma.o
 
 usb-storage-objs :=	scsiglue.o protocol.o transport.o usb.o \
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
deleted file mode 100644
index dfd42fe..0000000
--- a/drivers/usb/storage/onetouch.c
+++ /dev/null
@@ -1,237 +0,0 @@
-/*
- * Support for the Maxtor OneTouch USB hard drive's button
- *
- * Current development and maintenance by:
- *	Copyright (c) 2005 Nick Sillik <n.sillik@temple.edu>
- *
- * Initial work by:
- *	Copyright (c) 2003 Erik Thyren <erth7411@student.uu.se>
- *
- * Based on usbmouse.c (Vojtech Pavlik) and xpad.c (Marko Friedemann)
- *
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
- */
-
-#include <linux/kernel.h>
-#include <linux/input.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/usb/input.h>
-#include "usb.h"
-#include "onetouch.h"
-#include "debug.h"
-
-void onetouch_release_input(void *onetouch_);
-
-struct usb_onetouch {
-	char name[128];
-	char phys[64];
-	struct input_dev *dev;	/* input device interface */
-	struct usb_device *udev;	/* usb device */
-
-	struct urb *irq;	/* urb for interrupt in report */
-	unsigned char *data;	/* input data */
-	dma_addr_t data_dma;
-	unsigned int is_open:1;
-};
-
-static void usb_onetouch_irq(struct urb *urb)
-{
-	struct usb_onetouch *onetouch = urb->context;
-	signed char *data = onetouch->data;
-	struct input_dev *dev = onetouch->dev;
-	int status = urb->status;
-	int retval;
-
-	switch (status) {
-	case 0:			/* success */
-		break;
-	case -ECONNRESET:	/* unlink */
-	case -ENOENT:
-	case -ESHUTDOWN:
-		return;
-	/* -EPIPE:  should clear the halt */
-	default:		/* error */
-		goto resubmit;
-	}
-
-	input_report_key(dev, ONETOUCH_BUTTON, data[0] & 0x02);
-	input_sync(dev);
-
-resubmit:
-	retval = usb_submit_urb (urb, GFP_ATOMIC);
-	if (retval)
-		err ("can't resubmit intr, %s-%s/input0, retval %d",
-			onetouch->udev->bus->bus_name,
-			onetouch->udev->devpath, retval);
-}
-
-static int usb_onetouch_open(struct input_dev *dev)
-{
-	struct usb_onetouch *onetouch = input_get_drvdata(dev);
-
-	onetouch->is_open = 1;
-	onetouch->irq->dev = onetouch->udev;
-	if (usb_submit_urb(onetouch->irq, GFP_KERNEL)) {
-		err("usb_submit_urb failed");
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static void usb_onetouch_close(struct input_dev *dev)
-{
-	struct usb_onetouch *onetouch = input_get_drvdata(dev);
-
-	usb_kill_urb(onetouch->irq);
-	onetouch->is_open = 0;
-}
-
-#ifdef CONFIG_PM
-static void usb_onetouch_pm_hook(struct us_data *us, int action)
-{
-	struct usb_onetouch *onetouch = (struct usb_onetouch *) us->extra;
-
-	if (onetouch->is_open) {
-		switch (action) {
-		case US_SUSPEND:
-			usb_kill_urb(onetouch->irq);
-			break;
-		case US_RESUME:
-			if (usb_submit_urb(onetouch->irq, GFP_KERNEL) != 0)
-				err("usb_submit_urb failed");
-			break;
-		default:
-			break;
-		}
-	}
-}
-#endif /* CONFIG_PM */
-
-int onetouch_connect_input(struct us_data *ss)
-{
-	struct usb_device *udev = ss->pusb_dev;
-	struct usb_host_interface *interface;
-	struct usb_endpoint_descriptor *endpoint;
-	struct usb_onetouch *onetouch;
-	struct input_dev *input_dev;
-	int pipe, maxp;
-	int error = -ENOMEM;
-
-	interface = ss->pusb_intf->cur_altsetting;
-
-	if (interface->desc.bNumEndpoints != 3)
-		return -ENODEV;
-
-	endpoint = &interface->endpoint[2].desc;
-	if (!usb_endpoint_is_int_in(endpoint))
-		return -ENODEV;
-
-	pipe = usb_rcvintpipe(udev, endpoint->bEndpointAddress);
-	maxp = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
-
-	onetouch = kzalloc(sizeof(struct usb_onetouch), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!onetouch || !input_dev)
-		goto fail1;
-
-	onetouch->data = usb_buffer_alloc(udev, ONETOUCH_PKT_LEN,
-					  GFP_ATOMIC, &onetouch->data_dma);
-	if (!onetouch->data)
-		goto fail1;
-
-	onetouch->irq = usb_alloc_urb(0, GFP_KERNEL);
-	if (!onetouch->irq)
-		goto fail2;
-
-	onetouch->udev = udev;
-	onetouch->dev = input_dev;
-
-	if (udev->manufacturer)
-		strlcpy(onetouch->name, udev->manufacturer,
-			sizeof(onetouch->name));
-	if (udev->product) {
-		if (udev->manufacturer)
-			strlcat(onetouch->name, " ", sizeof(onetouch->name));
-		strlcat(onetouch->name, udev->product, sizeof(onetouch->name));
-	}
-
-	if (!strlen(onetouch->name))
-		snprintf(onetouch->name, sizeof(onetouch->name),
-			 "Maxtor Onetouch %04x:%04x",
-			 le16_to_cpu(udev->descriptor.idVendor),
-			 le16_to_cpu(udev->descriptor.idProduct));
-
-	usb_make_path(udev, onetouch->phys, sizeof(onetouch->phys));
-	strlcat(onetouch->phys, "/input0", sizeof(onetouch->phys));
-
-	input_dev->name = onetouch->name;
-	input_dev->phys = onetouch->phys;
-	usb_to_input_id(udev, &input_dev->id);
-	input_dev->dev.parent = &udev->dev;
-
-	set_bit(EV_KEY, input_dev->evbit);
-	set_bit(ONETOUCH_BUTTON, input_dev->keybit);
-	clear_bit(0, input_dev->keybit);
-
-	input_set_drvdata(input_dev, onetouch);
-
-	input_dev->open = usb_onetouch_open;
-	input_dev->close = usb_onetouch_close;
-
-	usb_fill_int_urb(onetouch->irq, udev, pipe, onetouch->data,
-			 (maxp > 8 ? 8 : maxp),
-			 usb_onetouch_irq, onetouch, endpoint->bInterval);
-	onetouch->irq->transfer_dma = onetouch->data_dma;
-	onetouch->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
-	ss->extra_destructor = onetouch_release_input;
-	ss->extra = onetouch;
-#ifdef CONFIG_PM
-	ss->suspend_resume_hook = usb_onetouch_pm_hook;
-#endif
-
-	error = input_register_device(onetouch->dev);
-	if (error)
-		goto fail3;
-
-	return 0;
-
- fail3:	usb_free_urb(onetouch->irq);
- fail2:	usb_buffer_free(udev, ONETOUCH_PKT_LEN,
-			onetouch->data, onetouch->data_dma);
- fail1:	kfree(onetouch);
-	input_free_device(input_dev);
-	return error;
-}
-
-void onetouch_release_input(void *onetouch_)
-{
-	struct usb_onetouch *onetouch = (struct usb_onetouch *) onetouch_;
-
-	if (onetouch) {
-		usb_kill_urb(onetouch->irq);
-		input_unregister_device(onetouch->dev);
-		usb_free_urb(onetouch->irq);
-		usb_buffer_free(onetouch->udev, ONETOUCH_PKT_LEN,
-				onetouch->data, onetouch->data_dma);
-	}
-}
diff --git a/drivers/usb/storage/onetouch.h b/drivers/usb/storage/onetouch.h
deleted file mode 100644
index 41c7aa8..0000000
--- a/drivers/usb/storage/onetouch.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _ONETOUCH_H_
-#define _ONETOUCH_H_
-
-#define ONETOUCH_PKT_LEN        0x02
-#define ONETOUCH_BUTTON         KEY_PROG1
-
-int onetouch_connect_input(struct us_data *ss);
-
-#endif
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 22ab238..2d18eae 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1282,23 +1282,6 @@ UNUSUAL_DEV( 0x0c0b, 0xa109, 0x0000, 0xffff,
 		US_FL_SINGLE_LUN ),
 #endif
 
-/* Submitted by: Nick Sillik <n.sillik@temple.edu>
- * Needed for OneTouch extension to usb-storage
- *
- */
-#ifdef CONFIG_USB_STORAGE_ONETOUCH
-	UNUSUAL_DEV(  0x0d49, 0x7000, 0x0000, 0x9999,
-			"Maxtor",
-			"OneTouch External Harddrive",
-			US_SC_DEVICE, US_PR_DEVICE, onetouch_connect_input,
-			0),
-	UNUSUAL_DEV(  0x0d49, 0x7010, 0x0000, 0x9999,
-			"Maxtor",
-			"OneTouch External Harddrive",
-			US_SC_DEVICE, US_PR_DEVICE, onetouch_connect_input,
-			0),
-#endif
-
 /*
  * Pete Zaitcev <zaitcev@yahoo.com>, bz#164688.
  * The device blatantly ignores LUN and returns 1 in GetMaxLUN.
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index ac6114e..2691fa4 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -92,9 +92,6 @@
 #ifdef CONFIG_USB_STORAGE_JUMPSHOT
 #include "jumpshot.h"
 #endif
-#ifdef CONFIG_USB_STORAGE_ONETOUCH
-#include "onetouch.h"
-#endif
 #ifdef CONFIG_USB_STORAGE_ALAUDA
 #include "alauda.h"
 #endif

