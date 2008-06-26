Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYFZKbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYFZKbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 06:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYFZKbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 06:31:08 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:45381 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYFZKbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 06:31:05 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Alfred E. Heggestad" <aeh@db.org>
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
Date: Thu, 26 Jun 2008 12:31:32 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <47AB5012.20509@db.org> <20080624045919.GA18612@anvil.corenet.prv> <4862A586.4050406@db.org>
In-Reply-To: <4862A586.4050406@db.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261231.33190.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 25 Juni 2008 22:07:34 schrieb Alfred E. Heggestad:

Very well

- urb->status is about to go away and replaced by a parameter
- reliably kill two URBs submitting each other cannot be done with
  usb_kill_urb() alone
- you close the device but leave the buzzer on
- input_ev() races with disconnect
- no support for suspend/resume
- no support for pre/post_reset

Could you test this additional patch?

	Regards
		Oliver

--- linux-2.6.26-sierra/drivers/input/misc/cm109.alt.c	2008-06-26 08:15:16.000000000 +0200
+++ linux-2.6.26-sierra/drivers/input/misc/cm109.c	2008-06-26 12:02:54.000000000 +0200
@@ -93,6 +93,7 @@ enum {USB_PKT_LEN = sizeof(struct cm109_
 struct cm109_dev {
 	struct input_dev *idev;	 /* input device */
 	struct usb_device *udev; /* usb device */
+	struct usb_interface *intf;
 
 	/* irq input channel */
 	struct cm109_ctl_packet *irq_data;
@@ -107,7 +108,12 @@ struct cm109_dev {
 	struct urb *urb_ctl;
 
 	spinlock_t submit_lock;
-	int disconnecting;
+	char disconnecting:1;
+	char shutting_down:1;
+	char buzz_state:1;
+	char open:1;
+	char resetting:1;
+	wait_queue_head_t wait;
 
 	char phys[64];		/* physical device path */
 	int key_code;		/* last reported key */
@@ -115,6 +121,9 @@ struct cm109_dev {
 	u8 gpi;			/* Cached value of GPI (high nibble) */
 };
 
+static DEFINE_MUTEX(close_disc_mutex);
+static int buzz(struct cm109_dev *dev, int on);
+
 /******************************************************************************
  * CM109 key interface
  *****************************************************************************/
@@ -279,7 +288,7 @@ static void report_key(struct cm109_dev
 static void urb_irq_callback(struct urb *urb)
 {
 	struct cm109_dev *dev = urb->context;
-	int ret;
+	int ret, status = urb->status;
 
 #if CM109_DEBUG
 	info("### URB IRQ: [0x%02x 0x%02x 0x%02x 0x%02x] keybit=0x%02x",
@@ -290,10 +299,10 @@ static void urb_irq_callback(struct urb
 	     dev->keybit);
 #endif
 
-	if (urb->status) {
-		if (-ESHUTDOWN == urb->status)
+	if (status) {
+		if (-ESHUTDOWN == status)
 			return;
-		err("%s - urb status %d", __FUNCTION__, urb->status);
+		err("%s - urb status %d", __func__, status);
 	}
 
 	/* Scan key column */
@@ -319,15 +328,19 @@ static void urb_irq_callback(struct urb
 	dev->ctl_data->byte[HID_OR2] = dev->keybit;
 
       out:
-	ret = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
-	if (ret)
-		err("%s - usb_submit_urb failed %d", __FUNCTION__, ret);
+	spin_lock(&dev->submit_lock);
+	if (!dev->shutting_down) {
+		ret = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
+		if (ret)
+			err("%s - usb_submit_urb failed %d", __func__, ret);
+	}
+	spin_unlock(&dev->submit_lock);
 }
 
 static void urb_ctl_callback(struct urb *urb)
 {
 	struct cm109_dev *dev = urb->context;
-	int ret = 0;
+	int ret = 0, status = urb->status;
 
 #if CM109_DEBUG
 	info("### URB CTL: [0x%02x 0x%02x 0x%02x 0x%02x]",
@@ -337,24 +350,37 @@ static void urb_ctl_callback(struct urb
 	     dev->ctl_data->byte[3]);
 #endif
 
-	if (urb->status)
-		err("%s - urb status %d", __FUNCTION__, urb->status);
+	if (status)
+		err("%s - urb status %d", __func__, status);
 
 	spin_lock(&dev->submit_lock);
 	/* ask for a response */
-	if (!dev->disconnecting)
+	if (!dev->shutting_down)
 		ret = usb_submit_urb(dev->urb_irq, GFP_ATOMIC);
 	spin_unlock(&dev->submit_lock);
 
 	if (ret)
 		err("%s - usb_submit_urb failed %d", __FUNCTION__, ret);
+	wake_up(&dev->wait);
 }
 
 /******************************************************************************
  * input event interface
  *****************************************************************************/
 
-static DEFINE_SPINLOCK(cm109_buzz_lock);
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
 
 static int input_open(struct input_dev *idev)
 {
@@ -370,41 +396,81 @@ static int input_open(struct input_dev *
 	dev->ctl_data->byte[HID_OR2] = dev->keybit;
 	dev->ctl_data->byte[HID_OR3] = 0x00;
 
+	ret = usb_autopm_get_interface(dev->intf);
+	if (ret < 0) {
+		err("%s - cannot autoresume, result %d",
+		    __func__, ret);
+		return ret;
+	}
+
+	mutex_lock(&close_disc_mutex);
 	if ((ret = usb_submit_urb(dev->urb_ctl, GFP_KERNEL)) != 0) {
 		err("%s - usb_submit_urb failed with result %d",
-		    __FUNCTION__, ret);
+		    __func__, ret);
+		usb_autopm_put_interface(dev->intf);
+		mutex_unlock(&close_disc_mutex);
 		return ret;
 	}
 
+	dev->open = 1;
+	mutex_unlock(&close_disc_mutex);
+
 	return 0;
 }
 
 static void input_close(struct input_dev *idev)
 {
 	struct cm109_dev *dev = input_get_drvdata(idev);
+	int traffic = 0;
+	int r;
 
-	usb_kill_urb(dev->urb_ctl);
-	usb_kill_urb(dev->urb_irq);
+	stop_traffic(dev);
+	dev->open = 0;
+	spin_lock_irq(&dev->submit_lock);
+	if (!dev->disconnecting && dev->buzz_state) {
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
+	mutex_lock(&close_disc_mutex);
+	if (!dev->disconnecting)
+		usb_autopm_put_interface(dev->intf);
+	mutex_unlock(&close_disc_mutex);
 }
 
-static void buzz(struct cm109_dev *dev, int on)
+static int buzz(struct cm109_dev *dev, int on)
 {
-	int ret;
+	int ret = 0;
 
 	if (dev == NULL) {
 		err("buzz: dev is NULL");
-		return;
+		return -EINVAL;
 	}
 
 	dbg("Buzzer %s", on ? "on" : "off");
+	if (dev->resetting)
+		goto skip_io;
 	if (on)
 		dev->ctl_data->byte[HID_OR0] |= BUZZER_ON;
 	else
 		dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
 
 	ret = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
-	if (ret)
-		err("%s - usb_submit_urb failed %d", __FUNCTION__, ret);
+	if (ret) {
+		err("%s - usb_submit_urb failed %d", __func__, ret);
+	} else {
+skip_io:
+		dev->buzz_state = on ? 1 : 0;
+	}
+	return ret;
 }
 
 static int input_ev(struct input_dev *idev, unsigned int type,
@@ -412,6 +478,7 @@ static int input_ev(struct input_dev *id
 {
 	struct cm109_dev *dev = input_get_drvdata(idev);
 	unsigned long flags;
+	int rv = 0;
 
 #if CM109_DEBUG
 	info("input_ev: type=%u code=%u value=%d", type, code, value);
@@ -428,11 +495,12 @@ static int input_ev(struct input_dev *id
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&cm109_buzz_lock, flags);
-	buzz(dev, value);
-	spin_unlock_irqrestore(&cm109_buzz_lock, flags);
+	spin_lock_irqsave(&dev->submit_lock, flags);
+	if (!dev->disconnecting)
+		rv = buzz(dev, value);
+	spin_unlock_irqrestore(&dev->submit_lock, flags);
 
-	return 0;
+	return rv;
 }
 
 
@@ -468,13 +536,12 @@ static const struct usb_device_id usb_ta
 	{}
 };
 
-static int usb_cleanup(struct cm109_dev *dev, int err)
+static void usb_cleanup(struct cm109_dev *dev, int err)
 {
 	if (dev == NULL)
-		return err;
+		return;
 
-	usb_kill_urb(dev->urb_irq);	/* parameter validation in core/urb */
-	usb_kill_urb(dev->urb_ctl);	/* parameter validation in core/urb */
+	stop_traffic(dev);
 
 	if (dev->idev) {
 		if (err)
@@ -495,8 +562,6 @@ static int usb_cleanup(struct cm109_dev
 	usb_free_urb(dev->urb_irq);	/* parameter validation in core/urb */
 	usb_free_urb(dev->urb_ctl);	/* parameter validation in core/urb */
 	kfree(dev);
-
-	return err;
 }
 
 static void usb_disconnect(struct usb_interface *interface)
@@ -506,9 +571,12 @@ static void usb_disconnect(struct usb_in
 	dev = usb_get_intfdata(interface);
 
 	/* Wait for URB idle */
+	
+	mutex_lock(&close_disc_mutex);
 	spin_lock_irq(&dev->submit_lock);
 	dev->disconnecting = 1;
 	spin_unlock_irq(&dev->submit_lock);
+	mutex_unlock(&close_disc_mutex);
 
 	usb_set_intfdata(interface, NULL);
 
@@ -536,9 +604,9 @@ static int usb_probe(struct usb_interfac
 		return -ENOMEM;
 
 	spin_lock_init(&dev->submit_lock);
-	dev->disconnecting = 0;
 
 	dev->udev = udev;
+	dev->intf = intf;
 
 	dev->idev = input_dev = input_allocate_device();
 	if (!input_dev)
@@ -638,14 +706,81 @@ static int usb_probe(struct usb_interfac
 	return 0;
 
       err:
-	return usb_cleanup(dev, -ENOMEM);
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
+static int usb_resume(struct usb_interface *intf)
+{
+	struct cm109_dev *dev = usb_get_intfdata(intf);
+	int rv;
+
+	rv = restore_state(dev);
+
+	return rv;
+}
+
+static int usb_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct cm109_dev *dev = usb_get_intfdata(intf);
+
+	stop_traffic(dev);
+	return 0;
+}
+
+static int usb_pre_reset(struct usb_interface *intf)
+{
+	struct cm109_dev *dev = usb_get_intfdata(intf);
+
+	mutex_lock(&close_disc_mutex);
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
+	mutex_unlock(&close_disc_mutex);
+	return rv;
 }
 
 static struct usb_driver cm109_driver = {
-	.name       = "cm109",
-	.probe      = usb_probe,
-	.disconnect = usb_disconnect,
-	.id_table   = usb_table,
+	.name		= "cm109",
+	.probe		= usb_probe,
+	.disconnect	= usb_disconnect,
+	.resume		= usb_resume,
+	.reset_resume	= usb_resume,
+	.suspend	= usb_suspend,
+	.pre_reset	= usb_pre_reset,
+	.post_reset	= usb_post_reset,
+	.id_table	= usb_table,
+	.supports_autosuspend = 1,
 };
 
 static int __init select_keymap(void)
@@ -685,7 +820,7 @@ static int __init cm109_dev_init(void)
 
 	info(DRIVER_DESC ": " DRIVER_VERSION " (C) " DRIVER_AUTHOR);
 
-	return err;
+	return 0;
 }
 
 static void __exit cm109_dev_exit(void)
