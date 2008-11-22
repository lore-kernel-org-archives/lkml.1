Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbYKVJ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbYKVJ45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYKVJ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:56:48 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:53655 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYKVJ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:56:47 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: stern@rowland.harvard.edu, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] USBHID: remove setup mutex
Date: Sat, 22 Nov 2008 10:56:39 +0100
Message-Id: <1227347799-24137-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <Pine.LNX.4.44L0.0811121650090.2186-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0811121650090.2186-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It causes recursive locking warning and is unneeded after
introduction of STARTED flag.

* Resume vs. stop is effectively solved by DISCONNECT flag.
* No problem in suspend vs. start -- urb is submitted even after open
which is possible after connect which is called after start.
* Resume vs. start solved by STARTED flag.
* Suspend vs. stop -- no problem in killing urb and timer twice.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/hid/usbhid/hid-core.c |   18 ++----------------
 drivers/hid/usbhid/usbhid.h   |    1 -
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index f86a5c4..f0a0f72 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -796,7 +796,6 @@ static int usbhid_start(struct hid_device *hid)
 	if (insize > HID_MAX_BUFFER_SIZE)
 		insize = HID_MAX_BUFFER_SIZE;
 
-	mutex_lock(&usbhid->setup);
 	if (hid_alloc_buffers(dev, hid)) {
 		ret = -ENOMEM;
 		goto fail;
@@ -876,7 +875,6 @@ static int usbhid_start(struct hid_device *hid)
 	hid_dump_device(hid);
 
 	set_bit(HID_STARTED, &usbhid->iofl);
-	mutex_unlock(&usbhid->setup);
 
 	/* Some keyboards don't work until their LEDs have been set.
 	 * Since BIOSes do set the LEDs, it must be safe for any device
@@ -897,7 +895,6 @@ fail:
 	usbhid->urbout = NULL;
 	usbhid->urbctrl = NULL;
 	hid_free_buffers(dev, hid);
-	mutex_unlock(&usbhid->setup);
 	return ret;
 }
 
@@ -908,7 +905,6 @@ static void usbhid_stop(struct hid_device *hid)
 	if (WARN_ON(!usbhid))
 		return;
 
-	mutex_lock(&usbhid->setup);
 	clear_bit(HID_STARTED, &usbhid->iofl);
 	spin_lock_irq(&usbhid->inlock);	/* Sync with error handler */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
@@ -937,7 +933,6 @@ static void usbhid_stop(struct hid_device *hid)
 	usbhid->urbout = NULL;
 
 	hid_free_buffers(hid_to_usb_dev(hid), hid);
-	mutex_unlock(&usbhid->setup);
 }
 
 static struct hid_ll_driver usb_hid_driver = {
@@ -1025,7 +1020,6 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	hid->driver_data = usbhid;
 	usbhid->hid = hid;
-	mutex_init(&usbhid->setup); /* needed on suspend/resume */
 
 	ret = hid_add_device(hid);
 	if (ret) {
@@ -1060,18 +1054,14 @@ static int hid_suspend(struct usb_interface *intf, pm_message_t message)
 	struct hid_device *hid = usb_get_intfdata (intf);
 	struct usbhid_device *usbhid = hid->driver_data;
 
-	mutex_lock(&usbhid->setup);
-	if (!test_bit(HID_STARTED, &usbhid->iofl)) {
-		mutex_unlock(&usbhid->setup);
+	if (!test_bit(HID_STARTED, &usbhid->iofl))
 		return 0;
-	}
 
 	spin_lock_irq(&usbhid->inlock);	/* Sync with error handler */
 	set_bit(HID_SUSPENDED, &usbhid->iofl);
 	spin_unlock_irq(&usbhid->inlock);
 	del_timer_sync(&usbhid->io_retry);
 	usb_kill_urb(usbhid->urbin);
-	mutex_unlock(&usbhid->setup);
 	dev_dbg(&intf->dev, "suspend\n");
 	return 0;
 }
@@ -1082,16 +1072,12 @@ static int hid_resume(struct usb_interface *intf)
 	struct usbhid_device *usbhid = hid->driver_data;
 	int status;
 
-	mutex_lock(&usbhid->setup);
-	if (!test_bit(HID_STARTED, &usbhid->iofl)) {
-		mutex_unlock(&usbhid->setup);
+	if (!test_bit(HID_STARTED, &usbhid->iofl))
 		return 0;
-	}
 
 	clear_bit(HID_SUSPENDED, &usbhid->iofl);
 	usbhid->retry_delay = 0;
 	status = hid_start_in(hid);
-	mutex_unlock(&usbhid->setup);
 	dev_dbg(&intf->dev, "resume status %d\n", status);
 	return status;
 }
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index 1ad7782..9eb3056 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -84,7 +84,6 @@ struct usbhid_device {
 	dma_addr_t outbuf_dma;                                          /* Output buffer dma */
 	spinlock_t outlock;                                             /* Output fifo spinlock */
 
-	struct mutex setup;
 	unsigned long iofl;                                             /* I/O flags (CTRL_RUNNING, OUT_RUNNING) */
 	struct timer_list io_retry;                                     /* Retry timer */
 	unsigned long stop_retry;                                       /* Time to give up, in jiffies */
-- 
1.6.0.4

