Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbYDUNcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbYDUNcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760022AbYDUNTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8449 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760211AbYDUNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=wrFBluv02OSEQ5I+SXVLV7nwoEkOQPMTh9reoNg8lnFPMM9x6vKJFWOCd7KRSrVe5Oq+fKhNxkd9DZ0aopyKDAHCiyt5ldsF9XMTUs42+heP5rOZw2hdGsqHaXj9K0e/fu6kGoxmnCUREMXWD6hbVbl2buKo5Sv/QwZpGs8NrgU=
Message-Id: <e722409445fbe718f09f6d5e03d0ae84cf0954d0.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Tue, 15 Apr 2008 01:31:57 -0400
Subject: [PATCH 26/37] Input: wacom - implement suspend and autosuspend
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Oliver Neukum <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements suspend and autosuspend support for wacom devices.
It works by using the usb last busy functionality triggered in the
completion callback.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/tablet/wacom.h     |    3 +
 drivers/input/tablet/wacom_sys.c |   76 +++++++++++++++++++++++++++++++++-----
 2 files changed, 69 insertions(+), 10 deletions(-)

diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index acf9830..706619d 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -101,8 +101,11 @@ struct wacom {
 	dma_addr_t data_dma;
 	struct input_dev *dev;
 	struct usb_device *usbdev;
+	struct usb_interface *intf;
 	struct urb *irq;
 	struct wacom_wac * wacom_wac;
+	struct mutex lock;
+	int open:1;
 	char phys[32];
 };
 
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 41caaef..71cc0c1 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -70,6 +70,7 @@ static void wacom_sys_irq(struct urb *urb)
 		input_sync(get_input_dev(&wcombo));
 
  exit:
+	usb_mark_last_busy(wacom->usbdev);
 	retval = usb_submit_urb (urb, GFP_ATOMIC);
 	if (retval)
 		err ("%s - usb_submit_urb failed with result %d",
@@ -124,10 +125,25 @@ static int wacom_open(struct input_dev *dev)
 {
 	struct wacom *wacom = input_get_drvdata(dev);
 
+	mutex_lock(&wacom->lock);
+
 	wacom->irq->dev = wacom->usbdev;
-	if (usb_submit_urb(wacom->irq, GFP_KERNEL))
+
+	if (usb_autopm_get_interface(wacom->intf) < 0) {
+		mutex_unlock(&wacom->lock);
 		return -EIO;
+	}
+
+	if (usb_submit_urb(wacom->irq, GFP_KERNEL)) {
+		usb_autopm_put_interface(wacom->intf);
+		mutex_unlock(&wacom->lock);
+		return -EIO;
+	}
+
+	wacom->open = 1;
+	wacom->intf->needs_remote_wakeup = 1;
 
+	mutex_unlock(&wacom->lock);
 	return 0;
 }
 
@@ -135,7 +151,11 @@ static void wacom_close(struct input_dev *dev)
 {
 	struct wacom *wacom = input_get_drvdata(dev);
 
+	mutex_lock(&wacom->lock);
 	usb_kill_urb(wacom->irq);
+	wacom->open = 0;
+	wacom->intf->needs_remote_wakeup = 0;
+	mutex_unlock(&wacom->lock);
 }
 
 void input_dev_mo(struct input_dev *input_dev, struct wacom_wac *wacom_wac)
@@ -243,6 +263,8 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	wacom->usbdev = dev;
 	wacom->dev = input_dev;
+	wacom->intf = intf;
+	mutex_init(&wacom->lock);
 	usb_make_path(dev, wacom->phys, sizeof(wacom->phys));
 	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
 
@@ -304,23 +326,57 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 static void wacom_disconnect(struct usb_interface *intf)
 {
-	struct wacom *wacom = usb_get_intfdata (intf);
+	struct wacom *wacom = usb_get_intfdata(intf);
 
 	usb_set_intfdata(intf, NULL);
-	if (wacom) {
-		usb_kill_urb(wacom->irq);
-		input_unregister_device(wacom->dev);
-		usb_free_urb(wacom->irq);
-		usb_buffer_free(interface_to_usbdev(intf), 10, wacom->wacom_wac->data, wacom->data_dma);
-		kfree(wacom->wacom_wac);
-		kfree(wacom);
-	}
+
+	usb_kill_urb(wacom->irq);
+	input_unregister_device(wacom->dev);
+	usb_free_urb(wacom->irq);
+	usb_buffer_free(interface_to_usbdev(intf), 10, wacom->wacom_wac->data, wacom->data_dma);
+	kfree(wacom->wacom_wac);
+	kfree(wacom);
+}
+
+static int wacom_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct wacom *wacom = usb_get_intfdata(intf);
+
+	mutex_lock(&wacom->lock);
+	usb_kill_urb(wacom->irq);
+	mutex_unlock(&wacom->lock);
+
+	return 0;
+}
+
+static int wacom_resume(struct usb_interface *intf)
+{
+	struct wacom *wacom = usb_get_intfdata(intf);
+	int rv;
+
+	mutex_lock(&wacom->lock);
+	if (wacom->open)
+		rv = usb_submit_urb(wacom->irq, GFP_NOIO);
+	else
+		rv = 0;
+	mutex_unlock(&wacom->lock);
+
+	return rv;
+}
+
+static int wacom_reset_resume(struct usb_interface *intf)
+{
+	return wacom_resume(intf);
 }
 
 static struct usb_driver wacom_driver = {
 	.name =		"wacom",
 	.probe =	wacom_probe,
 	.disconnect =	wacom_disconnect,
+	.suspend =	wacom_suspend,
+	.resume =	wacom_resume,
+	.reset_resume =	wacom_reset_resume,
+	.supports_autosuspend = 1,
 };
 
 static int __init wacom_init(void)
-- 
1.5.5.rc2.6.gf58d


