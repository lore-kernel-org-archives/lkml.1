Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYJ0LQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYJ0LQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYJ0LQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:16:33 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43390 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYJ0LQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:16:31 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andreas Schwab <schwab@suse.de>
Subject: [PATCH 1/2] HID: don't oops on suspend of non-bound devices
Date: Mon, 27 Oct 2008 12:16:15 +0100
Message-Id: <1225106176-5496-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usbhid structure is allocated on start invoked only from probe
of some driver. When there is no driver, the structure is null
and causes null-dereference oopses.

Fix it by allocating the structure on probe and disconnect of
the device itself. Also make sure we won't race between start
and resume or stop and suspend respectively.

References: http://bugzilla.kernel.org/show_bug.cgi?id=11827

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Andreas Schwab <schwab@suse.de>
---
 drivers/hid/usbhid/hid-core.c |   58 +++++++++++++++++++++++++++++------------
 drivers/hid/usbhid/usbhid.h   |    2 +
 include/linux/hid.h           |    1 +
 3 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index d203e98..a761e08 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <asm/unaligned.h>
@@ -774,21 +775,10 @@ static int usbhid_start(struct hid_device *hid)
 	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
 	struct usb_host_interface *interface = intf->cur_altsetting;
 	struct usb_device *dev = interface_to_usbdev(intf);
-	struct usbhid_device *usbhid;
+	struct usbhid_device *usbhid = hid->driver_data;
 	unsigned int n, insize = 0;
 	int ret;
 
-	WARN_ON(hid->driver_data);
-
-	usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL);
-	if (usbhid == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	hid->driver_data = usbhid;
-	usbhid->hid = hid;
-
 	usbhid->bufsize = HID_MIN_BUFFER_SIZE;
 	hid_find_max_report(hid, HID_INPUT_REPORT, &usbhid->bufsize);
 	hid_find_max_report(hid, HID_OUTPUT_REPORT, &usbhid->bufsize);
@@ -802,6 +792,7 @@ static int usbhid_start(struct hid_device *hid)
 	if (insize > HID_MAX_BUFFER_SIZE)
 		insize = HID_MAX_BUFFER_SIZE;
 
+	mutex_lock(&usbhid->setup);
 	if (hid_alloc_buffers(dev, hid)) {
 		ret = -ENOMEM;
 		goto fail;
@@ -886,6 +877,9 @@ static int usbhid_start(struct hid_device *hid)
 	usbhid_init_reports(hid);
 	hid_dump_device(hid);
 
+	set_bit(HID_STARTED, &usbhid->iofl);
+	mutex_unlock(&usbhid->setup);
+
 	return 0;
 
 fail:
@@ -893,8 +887,7 @@ fail:
 	usb_free_urb(usbhid->urbout);
 	usb_free_urb(usbhid->urbctrl);
 	hid_free_buffers(dev, hid);
-	kfree(usbhid);
-err:
+	mutex_unlock(&usbhid->setup);
 	return ret;
 }
 
@@ -905,6 +898,8 @@ static void usbhid_stop(struct hid_device *hid)
 	if (WARN_ON(!usbhid))
 		return;
 
+	mutex_lock(&usbhid->setup);
+	clear_bit(HID_STARTED, &usbhid->iofl);
 	spin_lock_irq(&usbhid->inlock);	/* Sync with error handler */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
 	spin_unlock_irq(&usbhid->inlock);
@@ -929,8 +924,7 @@ static void usbhid_stop(struct hid_device *hid)
 	usb_free_urb(usbhid->urbout);
 
 	hid_free_buffers(hid_to_usb_dev(hid), hid);
-	kfree(usbhid);
-	hid->driver_data = NULL;
+	mutex_unlock(&usbhid->setup);
 }
 
 static struct hid_ll_driver usb_hid_driver = {
@@ -945,6 +939,7 @@ static struct hid_ll_driver usb_hid_driver = {
 static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
+	struct usbhid_device *usbhid;
 	struct hid_device *hid;
 	size_t len;
 	int ret;
@@ -998,14 +993,26 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if (usb_string(dev, dev->descriptor.iSerialNumber, hid->uniq, 64) <= 0)
 		hid->uniq[0] = 0;
 
+	usbhid = kzalloc(sizeof(*usbhid), GFP_KERNEL);
+	if (usbhid == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	hid->driver_data = usbhid;
+	usbhid->hid = hid;
+	mutex_init(&usbhid->setup); /* needed on suspend/resume */
+
 	ret = hid_add_device(hid);
 	if (ret) {
 		if (ret != -ENODEV)
 			dev_err(&intf->dev, "can't add hid device: %d\n", ret);
-		goto err;
+		goto err_free;
 	}
 
 	return 0;
+err_free:
+	kfree(usbhid);
 err:
 	hid_destroy_device(hid);
 	return ret;
@@ -1014,11 +1021,14 @@ err:
 static void hid_disconnect(struct usb_interface *intf)
 {
 	struct hid_device *hid = usb_get_intfdata(intf);
+	struct usbhid_device *usbhid;
 
 	if (WARN_ON(!hid))
 		return;
 
+	usbhid = hid->driver_data;
 	hid_destroy_device(hid);
+	kfree(usbhid);
 }
 
 static int hid_suspend(struct usb_interface *intf, pm_message_t message)
@@ -1026,11 +1036,18 @@ static int hid_suspend(struct usb_interface *intf, pm_message_t message)
 	struct hid_device *hid = usb_get_intfdata (intf);
 	struct usbhid_device *usbhid = hid->driver_data;
 
+	mutex_lock(&usbhid->setup);
+	if (!test_bit(HID_STARTED, &usbhid->iofl)) {
+		mutex_unlock(&usbhid->setup);
+		return 0;
+	}
+
 	spin_lock_irq(&usbhid->inlock);	/* Sync with error handler */
 	set_bit(HID_SUSPENDED, &usbhid->iofl);
 	spin_unlock_irq(&usbhid->inlock);
 	del_timer(&usbhid->io_retry);
 	usb_kill_urb(usbhid->urbin);
+	mutex_unlock(&usbhid->setup);
 	dev_dbg(&intf->dev, "suspend\n");
 	return 0;
 }
@@ -1041,9 +1058,16 @@ static int hid_resume(struct usb_interface *intf)
 	struct usbhid_device *usbhid = hid->driver_data;
 	int status;
 
+	mutex_lock(&usbhid->setup);
+	if (!test_bit(HID_STARTED, &usbhid->iofl)) {
+		mutex_unlock(&usbhid->setup);
+		return 0;
+	}
+
 	clear_bit(HID_SUSPENDED, &usbhid->iofl);
 	usbhid->retry_delay = 0;
 	status = hid_start_in(hid);
+	mutex_unlock(&usbhid->setup);
 	dev_dbg(&intf->dev, "resume status %d\n", status);
 	return status;
 }
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index abedb13..55973ff 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -27,6 +27,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
@@ -73,6 +74,7 @@ struct usbhid_device {
 	dma_addr_t outbuf_dma;                                          /* Output buffer dma */
 	spinlock_t outlock;                                             /* Output fifo spinlock */
 
+	struct mutex setup;
 	unsigned long iofl;                                             /* I/O flags (CTRL_RUNNING, OUT_RUNNING) */
 	struct timer_list io_retry;                                     /* Retry timer */
 	unsigned long stop_retry;                                       /* Time to give up, in jiffies */
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 5355ca4..e5780f8 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -410,6 +410,7 @@ struct hid_output_fifo {
 #define HID_SUSPENDED		5
 #define HID_CLEAR_HALT		6
 #define HID_DISCONNECTED	7
+#define HID_STARTED		8
 
 struct hid_input {
 	struct list_head list;
-- 
1.6.0.2

