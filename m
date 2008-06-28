Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYF1PEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYF1PEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYF1PD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:03:56 -0400
Received: from submit-tmp.sysedata.no ([195.159.29.133]:62720 "EHLO
	submit-tmp.sysedata.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYF1PDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:03:52 -0400
Message-ID: <486652D1.4010008@db.org>
Date: Sat, 28 Jun 2008 17:03:45 +0200
From: "Alfred E. Heggestad" <aeh@db.org>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
 #2
References: <200806271424.50425.oliver@neukum.org>
In-Reply-To: <200806271424.50425.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelisted: <oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch 25 Juni 2008 22:07:34 schrieb Alfred E. Heggestad:
> 
> Very well
> 
> - urb->status is about to go away and replaced by a parameter
> - reliably kill two URBs submitting each other cannot be done with
>   usb_kill_urb() alone
> - you close the device but leave the buzzer on
> - no support for suspend/resume
> - no support for pre/post_reset
> 
> Could you test this new additional patch? The original patch had some
> issues I corrected.
> 

Hi Oliver,

many many thanks for your patch and your suggested code improvements.
I have tested your patch and I have some comments:

* The first version of your patch was tested, and it applied cleanly
   and compiled with out any errors. The module was loaded OK, but when
   I inserted the CM109-device into the USB-port, the machine crashed.
   I fixed that issue by adding this to the usb_probe() function:

	init_waitqueue_head(&dev->wait);

* The second version of your patch was applied with some local mods.
   This is now working as expected.

* I have tested suspend/resume with 2.6.25.9 and TuxOnIce 3.0-rc7
   and it works fine (cm109 device was plugged in during suspend).
   During suspend I get this in syslog:

     drivers/input/misc/cm109.c: cm109: usb_suspend (event=1)
     drivers/input/misc/cm109.c: urb_irq_callback: urb status -2


* The flag "char disconnecting:1" is no longer used in your second
   patch, and has been removed from the struct.

* When the buzzer is triggered by SND_TONE/SND_BELL, I get these
   warnings in syslog:

     drivers/input/misc/cm109.c: urb_ctl_callback: usb_submit_urb failed -22
     drivers/input/misc/cm109.c: buzz: usb_submit_urb failed -22
     drivers/input/misc/cm109.c: urb_ctl_callback: usb_submit_urb failed -22
     drivers/input/misc/cm109.c: buzz: usb_submit_urb failed -22

   It seems that the ctl URB is shared between buzzer and keypress
   handling. I am thinking about adding a new URB just for the buzzer,
   but I am not sure if that really is necesary. Any suggestions?


OK, once again - many thanks for your input


/alfred


> 	Regards
> 		Oliver
> 
> ---
> 

new patch:



diff -uprN -X linux-2.6.25/Documentation/dontdiff linux-2.6.25-orig/drivers/input/misc/cm109.c linux-2.6.25/drivers/input/misc/cm109.c
--- linux-2.6.25-orig/drivers/input/misc/cm109.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.25/drivers/input/misc/cm109.c	2008-06-28 16:46:36.000000000 +0200
@@ -0,0 +1,829 @@
+/*
+ * Driver for the VoIP USB phones with CM109 chipsets.
+ *
+ * Copyright (C) 2007 - 2008 Alfred E. Heggestad <aeh@db.org>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ */
+
+/*
+ *   Tested devices:
+ *	- Komunikate KIP1000
+ *	- Genius G-talk
+ *	- Allied-Telesis Corega USBPH01
+ *	- ...
+ *
+ * This driver is based on the yealink.c driver
+ *
+ * Thanks to:
+ *   - Authors of yealink.c
+ *   - Thomas Reitmayr
+ *   - Oliver Neukum for good review comments and code
+ *   - Shaun Jackman <sjackman@gmail.com> for Genius G-talk keymap
+ *
+ * Todo:
+ *   - Fix bug with buzz and urb_ctl_callback:usb_submit_urb() -EINVAL
+ *   - Fix KEY_KPPOUND
+ *   - Read/write EEPROM
+ *   - Report input events volume up/down
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/rwsem.h>
+#include <linux/usb/input.h>
+
+#define CM109_DEBUG 0
+
+#define DRIVER_VERSION "20080628"
+#define DRIVER_AUTHOR  "Alfred E. Heggestad"
+#define DRIVER_DESC    "CM109 phone driver"
+
+static char *phone = "kip1000";
+module_param(phone, charp, S_IRUSR);
+MODULE_PARM_DESC(phone, "Phone name {kip1000, gtalk, usbph01}");
+
+
+enum {
+	/* HID Registers */
+	HID_IR0 = 0x00, /* Record/Playback-mute button, Volume up/down  */
+	HID_IR1 = 0x01, /* GPI, generic registers or EEPROM_DATA0       */
+	HID_IR2 = 0x02, /* Generic registers or EEPROM_DATA1            */
+	HID_IR3 = 0x03, /* Generic registers or EEPROM_CTRL             */
+	HID_OR0 = 0x00, /* Mapping control, buzzer, SPDIF (offset 0x04) */
+	HID_OR1 = 0x01, /* GPO - General Purpose Output                 */
+	HID_OR2 = 0x02, /* Set GPIO to input/output mode                */
+	HID_OR3 = 0x03, /* SPDIF status channel or EEPROM_CTRL          */
+
+	/* HID_IR0 */
+	RECORD_MUTE   = 1 << 3,
+	PLAYBACK_MUTE = 1 << 2,
+	VOLUME_DOWN   = 1 << 1,
+	VOLUME_UP     = 1 << 0,
+
+	/* HID_OR0 */
+	/* bits 7-6
+	   0: HID_OR1-2 are used for GPO; HID_OR0, 3 are used for buzzer
+	      and SPDIF
+	   1: HID_OR0-3 are used as generic HID registers
+	   2: Values written to HID_OR0-3 are also mapped to MCU_CTRL,
+	      EEPROM_DATA0-1, EEPROM_CTRL (see Note)
+	   3: Reserved
+	 */
+	HID_OR_GPO_BUZ_SPDIF   = 0 << 6,
+	HID_OR_GENERIC_HID_REG = 1 << 6,
+	HID_OR_MAP_MCU_EEPROM  = 2 << 6,
+
+	BUZZER_ON = 1 << 5,
+};
+
+/* CM109 protocol packet */
+struct cm109_ctl_packet {
+	u8 byte[4];
+} __attribute__ ((packed));
+
+enum {USB_PKT_LEN = sizeof(struct cm109_ctl_packet)};
+
+/* CM109 device structure */
+struct cm109_dev {
+	struct input_dev *idev;	 /* input device */
+	struct usb_device *udev; /* usb device */
+	struct usb_interface *intf;
+
+	/* irq input channel */
+	struct cm109_ctl_packet *irq_data;
+	dma_addr_t irq_dma;
+	struct urb *urb_irq;
+
+	/* control output channel */
+	struct cm109_ctl_packet *ctl_data;
+	dma_addr_t ctl_dma;
+	struct usb_ctrlrequest *ctl_req;
+	dma_addr_t ctl_req_dma;
+	struct urb *urb_ctl;
+
+	spinlock_t submit_lock;
+	wait_queue_head_t wait;
+
+	/* flags */
+	char shutting_down:1;
+	char buzz_state:1;
+	char open:1;
+	char resetting:1;
+
+	char phys[64];		/* physical device path */
+	int key_code;		/* last reported key */
+	int keybit;		/* 0=new scan  1,2,4,8=scan columns  */
+	u8 gpi;			/* Cached value of GPI (high nibble) */
+};
+
+static DEFINE_MUTEX(reset_mutex);
+static int buzz(struct cm109_dev *dev, int on);
+
+/******************************************************************************
+ * CM109 key interface
+ *****************************************************************************/
+
+/* TODO: remove this code when KEY_NUMERIC_POUND is defined in linux/input.h
+ *
+ * if KEY_NUMERIC_POUND is not defined, we define our own version which
+ * is a rather dirty hack.
+ */
+#ifndef KEY_NUMERIC_POUND
+#warning "using dirty hack for pound key"
+#define KEY_NUMERIC_POUND (KEY_LEFTSHIFT | KEY_3 << 8)
+#endif
+
+
+/* Map device buttons to internal key events.
+ *
+ * The "up" and "down" keys, are symbolised by arrows on the button.
+ * The "pickup" and "hangup" keys are symbolised by a green and red phone
+ * on the button.
+
+ Komunikate KIP1000 Keyboard Matrix
+
+     -> -- 1 -- 2 -- 3  --> GPI pin 4 (0x10)
+      |    |    |    |
+     <- -- 4 -- 5 -- 6  --> GPI pin 5 (0x20)
+      |    |    |    |
+     END - 7 -- 8 -- 9  --> GPI pin 6 (0x40)
+      |    |    |    |
+     OK -- * -- 0 -- #  --> GPI pin 7 (0x80)
+      |    |    |    |
+
+     /|\  /|\  /|\  /|\
+      |    |    |    |
+GPO
+pin:  3    2    1    0
+     0x8  0x4  0x2  0x1
+
+ */
+static int keymap_kip1000(int scancode)
+{
+	switch (scancode) {				/* phone key:   */
+	case 0x82: return KEY_0;			/*   0          */
+	case 0x14: return KEY_1;			/*   1          */
+	case 0x12: return KEY_2;			/*   2          */
+	case 0x11: return KEY_3;			/*   3          */
+	case 0x24: return KEY_4;			/*   4          */
+	case 0x22: return KEY_5;			/*   5          */
+	case 0x21: return KEY_6;			/*   6          */
+	case 0x44: return KEY_7;			/*   7          */
+	case 0x42: return KEY_8;			/*   8          */
+	case 0x41: return KEY_9;			/*   9          */
+	case 0x81: return KEY_NUMERIC_POUND;		/*   #          */
+	case 0x84: return KEY_KPASTERISK;		/*   *          */
+	case 0x88: return KEY_ENTER;			/*   pickup     */
+	case 0x48: return KEY_ESC;			/*   hangup     */
+	case 0x28: return KEY_LEFT;			/*   IN         */
+	case 0x18: return KEY_RIGHT;			/*   OUT        */
+	}
+	return -EINVAL;
+}
+
+/*
+  Contributed by Shaun Jackman <sjackman@gmail.com>
+
+  Genius G-Talk keyboard matrix
+     0 1 2 3
+  4: 0 4 8 Talk
+  5: 1 5 9 End
+  6: 2 6 # Up
+  7: 3 7 * Down
+*/
+static int keymap_gtalk(int scancode)
+{
+	switch (scancode) {
+	case 0x11: return KEY_0;
+	case 0x21: return KEY_1;
+	case 0x41: return KEY_2;
+	case 0x81: return KEY_3;
+	case 0x12: return KEY_4;
+	case 0x22: return KEY_5;
+	case 0x42: return KEY_6;
+	case 0x82: return KEY_7;
+	case 0x14: return KEY_8;
+	case 0x24: return KEY_9;
+	case 0x44: return KEY_NUMERIC_POUND; /* # */
+	case 0x84: return KEY_KPASTERISK;
+	case 0x18: return KEY_ENTER; /* Talk (green handset) */
+	case 0x28: return KEY_ESC; /* End (red handset) */
+	case 0x48: return KEY_UP; /* Menu up (rocker switch) */
+	case 0x88: return KEY_DOWN; /* Menu down (rocker switch) */
+	}
+	return -EINVAL;
+}
+
+/*
+ * Keymap for Allied-Telesis Corega USBPH01
+ * http://www.alliedtelesis-corega.com/2/1344/1437/1360/chprd.html
+ *
+ * Contributed by july@nat.bg
+ */
+static int keymap_usbph01(int scancode)
+{
+	switch (scancode) {
+	case 0x11: return KEY_0;			/*   0          */
+	case 0x21: return KEY_1;			/*   1          */
+	case 0x41: return KEY_2;			/*   2          */
+	case 0x81: return KEY_3;			/*   3          */
+	case 0x12: return KEY_4;			/*   4          */
+	case 0x22: return KEY_5;			/*   5          */
+	case 0x42: return KEY_6;			/*   6          */
+	case 0x82: return KEY_7;			/*   7          */
+	case 0x14: return KEY_8;			/*   8          */
+	case 0x24: return KEY_9;			/*   9          */
+	case 0x44: return KEY_NUMERIC_POUND;		/*   #          */
+	case 0x84: return KEY_KPASTERISK;		/*   *          */
+	case 0x18: return KEY_ENTER;			/*   pickup     */
+	case 0x28: return KEY_ESC;			/*   hangup     */
+	case 0x48: return KEY_LEFT;			/*   IN         */
+	case 0x88: return KEY_RIGHT;			/*   OUT        */
+	}
+	return -EINVAL;
+}
+
+static int (*keymap)(int) = keymap_kip1000;
+
+
+/* Completes a request by converting the data into events for the
+ * input subsystem.
+ *
+ * The key parameter can be cascaded: key2 << 8 | key1
+ */
+static void report_key(struct cm109_dev *dev, int key)
+{
+	struct input_dev *idev = dev->idev;
+
+	if (dev->key_code >= 0) {
+		/* old key up */
+		input_report_key(idev, dev->key_code & 0xff, 0);
+		if (dev->key_code >> 8)
+			input_report_key(idev, dev->key_code >> 8, 0);
+	}
+
+	dev->key_code = key;
+	if (key >= 0) {
+		/* new valid key */
+		input_report_key(idev, key & 0xff, 1);
+		if (key >> 8)
+			input_report_key(idev, key >> 8, 1);
+	}
+	input_sync(idev);
+}
+
+/******************************************************************************
+ * CM109 usb communication interface
+ *****************************************************************************/
+
+
+/*
+ * IRQ handler
+ */
+static void urb_irq_callback(struct urb *urb)
+{
+	struct cm109_dev *dev = urb->context;
+	const int status = urb->status;
+	int ret;
+
+#if CM109_DEBUG
+	info("### URB IRQ: [0x%02x 0x%02x 0x%02x 0x%02x] keybit=0x%02x",
+	     dev->irq_data->byte[0],
+	     dev->irq_data->byte[1],
+	     dev->irq_data->byte[2],
+	     dev->irq_data->byte[3],
+	     dev->keybit);
+#endif
+
+	if (status) {
+		if (-ESHUTDOWN == status)
+			return;
+		err("%s: urb status %d", __func__, status);
+	}
+
+	/* Scan key column */
+	if (0xf == dev->keybit) {
+
+		/* Any changes ? */
+		if ((dev->gpi & 0xf0) == (dev->irq_data->byte[HID_IR1] & 0xf0)) {
+			goto out;
+		}
+
+		dev->gpi = dev->irq_data->byte[HID_IR1] & 0xf0;
+
+		dev->keybit = 0x1;
+	} else {
+		report_key(dev, keymap(dev->irq_data->byte[HID_IR1]));
+
+		dev->keybit <<= 1;
+		if (dev->keybit > 0x8)
+			dev->keybit = 0xf;
+	}
+
+	dev->ctl_data->byte[HID_OR1] = dev->keybit;
+	dev->ctl_data->byte[HID_OR2] = dev->keybit;
+
+      out:
+	spin_lock(&dev->submit_lock);
+	if (!dev->shutting_down) {
+		ret = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
+		if (ret)
+			err("%s: usb_submit_urb failed %d", __func__, ret);
+	}
+	spin_unlock(&dev->submit_lock);
+}
+
+static void urb_ctl_callback(struct urb *urb)
+{
+	struct cm109_dev *dev = urb->context;
+	const int status = urb->status;
+	int ret = 0;
+
+#if CM109_DEBUG
+	info("### URB CTL: [0x%02x 0x%02x 0x%02x 0x%02x]",
+	     dev->ctl_data->byte[0],
+	     dev->ctl_data->byte[1],
+	     dev->ctl_data->byte[2],
+	     dev->ctl_data->byte[3]);
+#endif
+
+	if (status)
+		err("%s: urb status %d", __func__, status);
+
+	spin_lock(&dev->submit_lock);
+	/* ask for a response */
+	if (!dev->shutting_down)
+		ret = usb_submit_urb(dev->urb_irq, GFP_ATOMIC);
+	spin_unlock(&dev->submit_lock);
+
+	if (ret)
+		err("%s: usb_submit_urb failed %d", __func__, ret);
+	wake_up(&dev->wait);
+}
+
+/******************************************************************************
+ * input event interface
+ *****************************************************************************/
+
+static void stop_traffic(struct cm109_dev *dev)
+{
+	spin_lock_irq(&dev->submit_lock);
+	dev->shutting_down = 1;
+	spin_unlock_irq(&dev->submit_lock);
+
+	usb_kill_urb(dev->urb_ctl);
+	usb_kill_urb(dev->urb_irq);
+
+	spin_lock_irq(&dev->submit_lock);
+	dev->shutting_down = 0;
+	spin_unlock_irq(&dev->submit_lock);
+}
+
+static int input_open(struct input_dev *idev)
+{
+	struct cm109_dev *dev = input_get_drvdata(idev);
+	int ret;
+
+	dev->key_code = -1;	/* no keys pressed */
+	dev->keybit = 0xf;
+
+	/* issue INIT */
+	dev->ctl_data->byte[HID_OR0] = HID_OR_GPO_BUZ_SPDIF;
+	dev->ctl_data->byte[HID_OR1] = dev->keybit;
+	dev->ctl_data->byte[HID_OR2] = dev->keybit;
+	dev->ctl_data->byte[HID_OR3] = 0x00;
+
+	ret = usb_autopm_get_interface(dev->intf);
+	if (ret < 0) {
+		err("%s - cannot autoresume, result %d",
+		    __func__, ret);
+		return ret;
+	}
+
+	mutex_lock(&reset_mutex);
+	if ((ret = usb_submit_urb(dev->urb_ctl, GFP_KERNEL)) != 0) {
+		err("%s: usb_submit_urb failed with result %d",
+		    __func__, ret);
+		usb_autopm_put_interface(dev->intf);
+		mutex_unlock(&reset_mutex);
+		return ret;
+	}
+
+	dev->open = 1;
+	mutex_unlock(&reset_mutex);
+
+	return 0;
+}
+
+static void input_close(struct input_dev *idev)
+{
+	struct cm109_dev *dev = input_get_drvdata(idev);
+	int traffic = 0;
+	int r;
+
+	dev->open = 0;
+	stop_traffic(dev);
+
+	spin_lock_irq(&dev->submit_lock);
+	if (dev->buzz_state) {
+		r = buzz(dev, 0);
+		spin_unlock_irq(&dev->submit_lock);
+		if (!r) {
+			wait_event(dev->wait, !dev->buzz_state);
+			traffic = 1;
+		}
+	} else {
+		spin_unlock_irq(&dev->submit_lock);
+	}
+	if (traffic)
+		stop_traffic(dev);
+
+	usb_autopm_put_interface(dev->intf);
+}
+
+static int buzz(struct cm109_dev *dev, int on)
+{
+	int ret = 0;
+
+	if (dev == NULL) {
+		err("buzz: dev is NULL");
+		return -EINVAL;
+	}
+
+	dbg("Buzzer %s", on ? "on" : "off");
+	if (dev->resetting)
+		goto skip_io;
+	if (on)
+		dev->ctl_data->byte[HID_OR0] |= BUZZER_ON;
+	else
+		dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
+
+	ret = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
+	if (ret) {
+		err("%s: usb_submit_urb failed %d", __func__, ret);
+	} else {
+skip_io:
+		dev->buzz_state = on ? 1 : 0;
+	}
+	return ret;
+}
+
+static int input_ev(struct input_dev *idev, unsigned int type,
+		    unsigned int code, int value)
+{
+	struct cm109_dev *dev = input_get_drvdata(idev);
+
+#if CM109_DEBUG
+	info("input_ev: type=%u code=%u value=%d", type, code, value);
+#endif
+
+	if (type != EV_SND)
+		return -EINVAL;
+
+	switch (code) {
+	case SND_TONE:
+	case SND_BELL:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return buzz(dev, value);
+}
+
+
+/******************************************************************************
+ * Linux interface and usb initialisation
+ *****************************************************************************/
+
+struct driver_info {
+	char *name;
+};
+
+static const struct driver_info info_cm109 = {
+	.name = "CM109 USB driver",
+};
+
+enum {
+	VENDOR_ID        = 0x0d8c, /* C-Media Electronics */
+	PRODUCT_ID_CM109 = 0x000e, /* CM109 defines range 0x0008 - 0x000f */
+};
+
+/* table of devices that work with this driver */
+static const struct usb_device_id usb_table[] = {
+	{
+	 .match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+	 USB_DEVICE_ID_MATCH_INT_INFO,
+	 .idVendor = VENDOR_ID,
+	 .idProduct = PRODUCT_ID_CM109,
+	 .bInterfaceClass = USB_CLASS_HID,
+	 .bInterfaceSubClass = 0,
+	 .bInterfaceProtocol = 0,
+	 .driver_info = (kernel_ulong_t) & info_cm109},
+	/* you can add more devices here with product ID 0x0008 - 0x000f */
+	{}
+};
+
+static void usb_cleanup(struct cm109_dev *dev, int err)
+{
+	if (dev == NULL)
+		return;
+
+	stop_traffic(dev);
+
+	if (dev->idev) {
+		if (err)
+			input_free_device(dev->idev);
+		else
+			input_unregister_device(dev->idev);
+	}
+	if (dev->ctl_req)
+		usb_buffer_free(dev->udev, sizeof(*(dev->ctl_req)),
+				dev->ctl_req, dev->ctl_req_dma);
+	if (dev->ctl_data)
+		usb_buffer_free(dev->udev, USB_PKT_LEN,
+				dev->ctl_data, dev->ctl_dma);
+	if (dev->irq_data)
+		usb_buffer_free(dev->udev, USB_PKT_LEN,
+				dev->irq_data, dev->irq_dma);
+
+	usb_free_urb(dev->urb_irq);	/* parameter validation in core/urb */
+	usb_free_urb(dev->urb_ctl);	/* parameter validation in core/urb */
+	kfree(dev);
+}
+
+static void usb_disconnect(struct usb_interface *interface)
+{
+	struct cm109_dev *dev;
+
+	dev = usb_get_intfdata(interface);
+
+	usb_set_intfdata(interface, NULL);
+
+	usb_cleanup(dev, 0);
+}
+
+static int usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct driver_info *nfo = (struct driver_info *)id->driver_info;
+	struct usb_host_interface *interface;
+	struct usb_endpoint_descriptor *endpoint;
+	struct cm109_dev *dev;
+	struct input_dev *input_dev;
+	int ret, pipe, i;
+
+	interface = intf->cur_altsetting;
+	endpoint = &interface->endpoint[0].desc;
+
+	if (!usb_endpoint_is_int_in(endpoint))
+		return -ENODEV;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	spin_lock_init(&dev->submit_lock);
+	init_waitqueue_head(&dev->wait);
+
+	dev->udev = udev;
+	dev->intf = intf;
+
+	dev->idev = input_dev = input_allocate_device();
+	if (!input_dev)
+		goto err;
+
+	/* allocate usb buffers */
+	dev->irq_data = usb_buffer_alloc(udev, USB_PKT_LEN,
+					 GFP_KERNEL, &dev->irq_dma);
+	if (dev->irq_data == NULL)
+		goto err;
+
+	dev->ctl_data = usb_buffer_alloc(udev, USB_PKT_LEN,
+					 GFP_KERNEL, &dev->ctl_dma);
+	if (!dev->ctl_data)
+		goto err;
+
+	dev->ctl_req = usb_buffer_alloc(udev, sizeof(*(dev->ctl_req)),
+					GFP_KERNEL, &dev->ctl_req_dma);
+	if (dev->ctl_req == NULL)
+		goto err;
+
+	/* allocate urb structures */
+	dev->urb_irq = usb_alloc_urb(0, GFP_KERNEL);
+	if (dev->urb_irq == NULL)
+		goto err;
+
+	dev->urb_ctl = usb_alloc_urb(0, GFP_KERNEL);
+	if (dev->urb_ctl == NULL)
+		goto err;
+
+	/* get a handle to the interrupt data pipe */
+	pipe = usb_rcvintpipe(udev, endpoint->bEndpointAddress);
+	ret = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
+	if (ret != USB_PKT_LEN)
+		err("invalid payload size %d, expected %d", ret, USB_PKT_LEN);
+
+	/* initialise irq urb */
+	usb_fill_int_urb(dev->urb_irq, udev, pipe, dev->irq_data,
+			 USB_PKT_LEN,
+			 urb_irq_callback, dev, endpoint->bInterval);
+	dev->urb_irq->transfer_dma = dev->irq_dma;
+	dev->urb_irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	dev->urb_irq->dev = udev;
+
+	/* initialise ctl urb */
+	dev->ctl_req->bRequestType = USB_TYPE_CLASS | USB_RECIP_INTERFACE |
+	    USB_DIR_OUT;
+	dev->ctl_req->bRequest = USB_REQ_SET_CONFIGURATION;
+	dev->ctl_req->wValue = cpu_to_le16(0x200);
+	dev->ctl_req->wIndex = cpu_to_le16(interface->desc.bInterfaceNumber);
+	dev->ctl_req->wLength = cpu_to_le16(USB_PKT_LEN);
+
+	usb_fill_control_urb(dev->urb_ctl, udev, usb_sndctrlpipe(udev, 0),
+			     (void *)dev->ctl_req, dev->ctl_data, USB_PKT_LEN,
+			     urb_ctl_callback, dev);
+	dev->urb_ctl->setup_dma = dev->ctl_req_dma;
+	dev->urb_ctl->transfer_dma = dev->ctl_dma;
+	dev->urb_ctl->transfer_flags |= URB_NO_SETUP_DMA_MAP |
+	    URB_NO_TRANSFER_DMA_MAP;
+	dev->urb_ctl->dev = udev;
+
+	/* find out the physical bus location */
+	usb_make_path(udev, dev->phys, sizeof(dev->phys));
+	strlcat(dev->phys, "/input0", sizeof(dev->phys));
+
+	/* register settings for the input device */
+	input_dev->name = nfo->name;
+	input_dev->phys = dev->phys;
+	usb_to_input_id(udev, &input_dev->id);
+	input_dev->dev.parent = &intf->dev;
+
+	input_set_drvdata(input_dev, dev);
+	input_dev->open = input_open;
+	input_dev->close = input_close;
+	input_dev->event = input_ev;
+
+	/* register available key events */
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
+	for (i = 0; i < 256; i++) {
+		int k = keymap(i);
+		if (k >= 0) {
+			set_bit(k & 0xff, input_dev->keybit);
+			if (k >> 8)
+				set_bit(k >> 8, input_dev->keybit);
+		}
+	}
+
+	input_dev->evbit[0] |= BIT_MASK(EV_SND);
+	input_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
+
+	ret = input_register_device(dev->idev);
+	if (ret)
+		goto err;
+
+	usb_set_intfdata(intf, dev);
+
+	return 0;
+
+      err:
+	usb_cleanup(dev, 1);
+	return -ENOMEM;
+}
+
+static int restore_state(struct cm109_dev *dev)
+{
+	int rv;
+
+	spin_lock_irq(&dev->submit_lock);
+	/* if not open, just restore buzz, else submit urb */
+	dev->shutting_down = dev->open;
+	spin_unlock_irq(&dev->submit_lock);
+	rv = buzz(dev, dev->buzz_state);
+	spin_lock_irq(&dev->submit_lock);
+	dev->shutting_down = 0;
+	spin_unlock_irq(&dev->submit_lock);
+
+	return rv;
+}
+
+static int usb_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct cm109_dev *dev = usb_get_intfdata(intf);
+
+	info("cm109: usb_suspend (event=%d)", message.event);
+
+	stop_traffic(dev);
+	return 0;
+}
+
+static int usb_resume(struct usb_interface *intf)
+{
+	struct cm109_dev *dev = usb_get_intfdata(intf);
+	int rv;
+
+	info("cm109: usb_resume");
+
+	rv = restore_state(dev);
+
+	return rv;
+}
+
+static int usb_pre_reset(struct usb_interface *intf)
+{
+	struct cm109_dev *dev = usb_get_intfdata(intf);
+
+	mutex_lock(&reset_mutex);
+	spin_lock_irq(&dev->submit_lock);
+	dev->resetting = 1;
+	spin_unlock_irq(&dev->submit_lock);
+	stop_traffic(dev);
+
+	return 0;
+}
+
+static int usb_post_reset(struct usb_interface *intf)
+{
+	struct cm109_dev *dev = usb_get_intfdata(intf);
+	int rv;
+
+	spin_lock_irq(&dev->submit_lock);
+	dev->resetting = 0;
+	spin_unlock_irq(&dev->submit_lock);
+	rv = restore_state(dev);
+	mutex_unlock(&reset_mutex);
+	return rv;
+}
+
+static struct usb_driver cm109_driver = {
+	.name		= "cm109",
+	.probe		= usb_probe,
+	.disconnect	= usb_disconnect,
+	.suspend	= usb_suspend,
+	.resume		= usb_resume,
+	.reset_resume	= usb_resume,
+	.pre_reset	= usb_pre_reset,
+	.post_reset	= usb_post_reset,
+	.id_table	= usb_table,
+	.supports_autosuspend = 1,
+};
+
+static int __init select_keymap(void)
+{
+	/* Load the phone keymap */
+	if (0 == strcasecmp(phone, "kip1000")) {
+		keymap = keymap_kip1000;
+		info("Keymap for Komunikate KIP1000 phone loaded");
+	}
+	else if (0 == strcasecmp(phone, "gtalk")) {
+		keymap = keymap_gtalk;
+		info("Keymap for Genius G-talk phone loaded");
+	}
+	else if (0 == strcasecmp(phone, "usbph01")) {
+		keymap = keymap_usbph01;
+		info("Keymap for Allied-Telesis Corega USBPH01 phone loaded");
+	}
+	else {
+		err("Unsupported phone: %s", phone);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init cm109_dev_init(void)
+{
+	int err;
+
+	err = select_keymap();
+	if (err)
+		return err;
+
+	err = usb_register(&cm109_driver);
+	if (err)
+		return err;
+
+	info(DRIVER_DESC ": " DRIVER_VERSION " (C) " DRIVER_AUTHOR);
+
+	return 0;
+}
+
+static void __exit cm109_dev_exit(void)
+{
+	usb_deregister(&cm109_driver);
+}
+
+module_init(cm109_dev_init);
+module_exit(cm109_dev_exit);
+
+MODULE_DEVICE_TABLE(usb, usb_table);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff -uprN -X linux-2.6.25/Documentation/dontdiff linux-2.6.25-orig/drivers/input/misc/Kconfig linux-2.6.25/drivers/input/misc/Kconfig
--- linux-2.6.25-orig/drivers/input/misc/Kconfig	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/input/misc/Kconfig	2008-06-21 23:11:48.000000000 +0200
@@ -180,6 +180,18 @@ config INPUT_YEALINK
  	  To compile this driver as a module, choose M here: the module will be
  	  called yealink.

+config INPUT_CM109
+	tristate "C-Media CM109 USB I/O Controller"
+	depends on INPUT && EXPERIMENTAL
+	select USB
+	---help---
+	  Say Y here if you want to enable keyboard and buzzer functions of the
+	  C-Media CM109 usb phones. The audio part is enabled by the generic
+	  usb sound driver, so you might want to enable that as well.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called cm109.
+
  config INPUT_UINPUT
  	tristate "User level driver support"
  	help
diff -uprN -X linux-2.6.25/Documentation/dontdiff linux-2.6.25-orig/drivers/input/misc/Makefile linux-2.6.25/drivers/input/misc/Makefile
--- linux-2.6.25-orig/drivers/input/misc/Makefile	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25/drivers/input/misc/Makefile	2008-06-21 23:11:48.000000000 +0200
@@ -16,6 +16,7 @@ obj-$(CONFIG_INPUT_ATI_REMOTE2)		+= ati_
  obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
  obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
+obj-$(CONFIG_INPUT_CM109)		+= cm109.o
  obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
  obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
  obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
diff -uprN -X linux-2.6.25/Documentation/dontdiff linux-2.6.25-orig/drivers/input/misc/modules.order linux-2.6.25/drivers/input/misc/modules.order
--- linux-2.6.25-orig/drivers/input/misc/modules.order	2008-06-21 23:05:28.000000000 +0200
+++ linux-2.6.25/drivers/input/misc/modules.order	2008-06-28 15:56:50.000000000 +0200
@@ -1,2 +1,3 @@
  kernel/drivers/input/misc/yealink.ko
+kernel/drivers/input/misc/cm109.ko
  kernel/drivers/input/misc/uinput.ko
diff -uprN -X linux-2.6.25/Documentation/dontdiff linux-2.6.25-orig/drivers/input/modules.order linux-2.6.25/drivers/input/modules.order
--- linux-2.6.25-orig/drivers/input/modules.order	2008-06-21 23:05:28.000000000 +0200
+++ linux-2.6.25/drivers/input/modules.order	2008-06-28 15:56:58.000000000 +0200
@@ -1,3 +1,4 @@
  kernel/drivers/input/misc/yealink.ko
+kernel/drivers/input/misc/cm109.ko
  kernel/drivers/input/misc/uinput.ko
  kernel/drivers/input/input-polldev.ko
