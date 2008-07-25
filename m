Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbYGYPnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYGYPnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYGYPm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:42:57 -0400
Received: from hs-out-0708.google.com ([64.233.178.242]:52894 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYGYPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HTUedaoNy9yenL1rmN2M5nHzkaxX05c+zTKmcB/1OQ+2etd+4LlKylfvLYNvNCJxqb
         zF1UCqfm9L3ET1B0zSNaetF/tbXzi8TUA1d4RhFaN8aLFlRhfHDMnGcfEhTblDew4FJr
         3ROHgsgC696FH/KexdYXu9gKVyhZJOz7/Y4x8=
Date: Fri, 25 Jul 2008 11:42:50 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net
Subject: Re: [PATCH] bcm5974-0.58: name changes, open/close and
	suspend/resume serialized
Message-ID: <20080725154250.GA1861@anvil.corenet.prv>
References: <4888311E.9010005@euromail.se>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <4888311E.9010005@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Henrik,

On Thu, Jul 24, 2008 at 09:37:02AM +0200, Henrik Rydberg wrote:
> 
> This is version bcm5974-0.58. Changes since 0.57 are in short:
> 
>   * Name changes; use usbhid definitions, rename atp to bcm5974
>   * Input syncing moved to report functions, event type setup broken out
>   * Traffic functions added for open/close and suspend/resume logic
>   * Open/close and suspend/resume transition logic corrected
>   * Open/close serialized with respect to suspend/resume
> 

Thank you for the changes.  You don't have to track whether device is
manually suspended or not - usb_submit_urb will fail and that is it.

Attached are 2 patches. First cleans suspend state tracking as it is not
really needed and does some formatting and other minor changes and 2nd
implements runtime pm for the device. Could you please try them and if
everything still works I will apply the driver.

Thanks!

-- 
Dmitry

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bcm5974-cleanups.patch"

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>


---

 drivers/input/mouse/Kconfig   |   12 +-
 drivers/input/mouse/bcm5974.c |  228 ++++++++++++++++++++---------------------
 2 files changed, 118 insertions(+), 122 deletions(-)

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 2eab073..f996546 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -133,23 +133,23 @@ config MOUSE_APPLETOUCH
 config MOUSE_BCM5974
 	tristate "Apple USB BCM5974 Multitouch trackpad support"
 	depends on USB_ARCH_HAS_HCD
-	depends on USB
+	select USB
 	help
 	  Say Y here if you have an Apple USB BCM5974 Multitouch
 	  trackpad.
-	
+
 	  The BCM5974 is the multitouch trackpad found in the Macbook
 	  Air (JAN2008) and Macbook Pro Penryn (FEB2008) laptops.
-	
+
 	  It is also found in the IPhone (2007) and Ipod Touch (2008).
-	
+
 	  This driver provides multitouch functionality together with
 	  the synaptics X11 driver.
-	
+
 	  The interface is currently identical to the appletouch interface,
 	  for further information, see
 	  <file:Documentation/input/appletouch.txt>.
-	
+
 	  To compile this driver as a module, choose M here: the
 	  module will be called bcm5974.
 
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 55c1f60..6f85278 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -152,9 +152,8 @@ struct bcm5974 {
 	struct usb_device *udev;	/* usb device */
 	struct input_dev *input;	/* input dev */
 	struct bcm5974_config cfg;	/* device configuration */
-	struct mutex mutex;		/* serialize access to open/suspend */
-	int opened;			/* >0: opened, else closed */
-	int manually_suspended;		/* >0: manually suspended */
+	struct mutex pm_mutex;		/* serialize access to open/suspend */
+	int opened;			/* 1: opened, 0: closed */
 	struct urb *bt_urb;		/* button usb request block */
 	struct bt_data *bt_data;	/* button transferred data */
 	struct urb *tp_urb;		/* trackpad usb request block */
@@ -204,9 +203,11 @@ static const struct bcm5974_config *bcm5974_get_config(struct usb_device *udev)
 {
 	u16 id = le16_to_cpu(udev->descriptor.idProduct);
 	const struct bcm5974_config *cfg;
+
 	for (cfg = bcm5974_config_table; cfg->ansi; ++cfg)
 		if (cfg->ansi == id || cfg->iso == id || cfg->jis == id)
 			return cfg;
+
 	return bcm5974_config_table;
 }
 
@@ -226,28 +227,30 @@ static inline int int2scale(const struct bcm5974_param *p, int x)
 static inline int int2bound(const struct bcm5974_param *p, int x)
 {
 	int s = int2scale(p, x);
-	return s < 0 ? 0 : s >= p->dim ? p->dim - 1 : s;
+
+	return clamp_val(s, 0, p->dim - 1);
 }
 
 /* setup which logical events to report */
 static void setup_events_to_report(struct input_dev *input_dev,
-	const struct bcm5974_config *cfg)
+				   const struct bcm5974_config *cfg)
 {
-	set_bit(EV_ABS, input_dev->evbit);
+	__set_bit(EV_ABS, input_dev->evbit);
+
 	input_set_abs_params(input_dev, ABS_PRESSURE,
-		0, cfg->p.dim, cfg->p.fuzz, 0);
+				0, cfg->p.dim, cfg->p.fuzz, 0);
 	input_set_abs_params(input_dev, ABS_TOOL_WIDTH,
-		0, cfg->w.dim, cfg->w.fuzz, 0);
+				0, cfg->w.dim, cfg->w.fuzz, 0);
 	input_set_abs_params(input_dev, ABS_X,
-		0, cfg->x.dim, cfg->x.fuzz, 0);
+				0, cfg->x.dim, cfg->x.fuzz, 0);
 	input_set_abs_params(input_dev, ABS_Y,
-		0, cfg->y.dim, cfg->y.fuzz, 0);
+				0, cfg->y.dim, cfg->y.fuzz, 0);
 
-	set_bit(EV_KEY, input_dev->evbit);
-	set_bit(BTN_TOOL_FINGER, input_dev->keybit);
-	set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
-	set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
-	set_bit(BTN_LEFT, input_dev->keybit);
+	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
+	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
+	__set_bit(BTN_LEFT, input_dev->keybit);
 }
 
 /* report button data as logical button state */
@@ -267,38 +270,37 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 {
 	const struct bcm5974_config *c = &dev->cfg;
 	const struct tp_finger *f = dev->tp_data->finger;
+	struct input_dev *input = dev->input;
 	const int fingers = (size - 26) / 28;
-	int p, w, x, y, n;
+	int p = 0, w, x, y, n = 0;
 
 	if (size < 26 || (size - 26) % 28 != 0)
 		return -EIO;
 
-	if (!fingers) {
-		input_report_abs(dev->input, ABS_PRESSURE, 0);
-		input_report_key(dev->input, BTN_TOOL_FINGER, false);
-		input_report_key(dev->input, BTN_TOOL_DOUBLETAP, false);
-		input_report_key(dev->input, BTN_TOOL_TRIPLETAP, false);
-		input_sync(dev->input);
-		return 0;
+	if (fingers) {
+		p = raw2int(f->force_major);
+		w = raw2int(f->size_major);
+		x = raw2int(f->abs_x);
+		y = raw2int(f->abs_y);
+		n = p > 0 ? fingers : 0;
+
+		dprintk(9,
+			"bcm5974: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
+			p, w, x, y, n);
+
+		input_report_abs(input, ABS_TOOL_WIDTH, int2bound(&c->w, w));
+		input_report_abs(input, ABS_X, int2bound(&c->x, x - c->x.devmin));
+		input_report_abs(input, ABS_Y, int2bound(&c->y, c->y.devmax - y));
 	}
 
-	p = raw2int(f->force_major);
-	w = raw2int(f->size_major);
-	x = raw2int(f->abs_x);
-	y = raw2int(f->abs_y);
-	n = p > 0 ? fingers : 0;
-
-	dprintk(9, "bcm5974: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
-		p, w, x, y, n);
-
-	input_report_abs(dev->input, ABS_PRESSURE, int2bound(&c->p, p));
-	input_report_abs(dev->input, ABS_TOOL_WIDTH, int2bound(&c->w, w));
-	input_report_abs(dev->input, ABS_X, int2bound(&c->x, x - c->x.devmin));
-	input_report_abs(dev->input, ABS_Y, int2bound(&c->y, c->y.devmax - y));
-	input_report_key(dev->input, BTN_TOOL_FINGER, n == 1);
-	input_report_key(dev->input, BTN_TOOL_DOUBLETAP, n == 2);
-	input_report_key(dev->input, BTN_TOOL_TRIPLETAP, n > 2);
-	input_sync(dev->input);
+	input_report_abs(input, ABS_PRESSURE, int2bound(&c->p, p));
+
+	input_report_key(input, BTN_TOOL_FINGER, n == 1);
+	input_report_key(input, BTN_TOOL_DOUBLETAP, n == 2);
+	input_report_key(input, BTN_TOOL_TRIPLETAP, n > 2);
+
+	input_sync(input);
+
 	return 0;
 }
 
@@ -312,25 +314,25 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 static int bcm5974_wellspring_mode(struct bcm5974 *dev)
 {
 	char *data = kmalloc(8, GFP_KERNEL);
-	int error = 0, size;
+	int retval = 0, size;
 
 	if (!data) {
 		err("bcm5974: out of memory");
-		error = -ENOMEM;
-		goto error;
+		retval = -ENOMEM;
+		goto out;
 	}
 
 	/* read configuration */
 	size = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
-		BCM5974_WELLSPRING_MODE_READ_REQUEST_ID,
-		USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		BCM5974_WELLSPRING_MODE_REQUEST_VALUE,
-		BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
+			BCM5974_WELLSPRING_MODE_READ_REQUEST_ID,
+			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			BCM5974_WELLSPRING_MODE_REQUEST_VALUE,
+			BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
 		err("bcm5974: could not read from device");
-		error = -EIO;
-		goto error;
+		retval = -EIO;
+		goto out;
 	}
 
 	/* apply the mode switch */
@@ -338,28 +340,25 @@ static int bcm5974_wellspring_mode(struct bcm5974 *dev)
 
 	/* write configuration */
 	size = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
-		BCM5974_WELLSPRING_MODE_WRITE_REQUEST_ID,
-		USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		BCM5974_WELLSPRING_MODE_REQUEST_VALUE,
-		BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
+			BCM5974_WELLSPRING_MODE_WRITE_REQUEST_ID,
+			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			BCM5974_WELLSPRING_MODE_REQUEST_VALUE,
+			BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
 		err("bcm5974: could not write to device");
-		error = -EIO;
-		goto error;
+		retval = -EIO;
+		goto out;
 	}
 
 	dprintk(2, "bcm5974: switched to wellspring mode.\n");
 
+ out:
 	kfree(data);
-	return 0;
-
-error:
-	kfree(data);
-	return error;
+	return retval;
 }
 
-static void irq_button(struct urb *urb)
+static void bcm5974_irq_button(struct urb *urb)
 {
 	struct bcm5974 *dev = urb->context;
 	int error;
@@ -388,7 +387,7 @@ exit:
 		err("bcm5974: button urb failed: %d", error);
 }
 
-static void irq_trackpad(struct urb *urb)
+static void bcm5974_irq_trackpad(struct urb *urb)
 {
 	struct bcm5974 *dev = urb->context;
 	int error;
@@ -439,25 +438,28 @@ exit:
  * plus start_traffic, it seems easier to always do the switch when
  * starting traffic on the device.
  */
-static int start_traffic(struct bcm5974 *dev)
+static int bcm5974_start_traffic(struct bcm5974 *dev)
 {
 	if (bcm5974_wellspring_mode(dev)) {
 		dprintk(1, "bcm5974: mode switch failed\n");
 		goto error;
 	}
+
 	if (usb_submit_urb(dev->bt_urb, GFP_KERNEL))
 		goto error;
+
 	if (usb_submit_urb(dev->tp_urb, GFP_KERNEL))
 		goto err_kill_bt;
 
 	return 0;
+
 err_kill_bt:
 	usb_kill_urb(dev->bt_urb);
 error:
 	return -EIO;
 }
 
-static void pause_traffic(struct bcm5974 *dev)
+static void bcm5974_pause_traffic(struct bcm5974 *dev)
 {
 	usb_kill_urb(dev->tp_urb);
 	usb_kill_urb(dev->bt_urb);
@@ -474,15 +476,15 @@ static void pause_traffic(struct bcm5974 *dev)
 static int bcm5974_open(struct input_dev *input)
 {
 	struct bcm5974 *dev = input_get_drvdata(input);
-	int error = 0;
+	int error;
 
-	mutex_lock(&dev->mutex);
-	if (dev->manually_suspended)
-		error = -EACCES;
-	else if (!dev->opened)
-		error = start_traffic(dev);
-	dev->opened = !error;
-	mutex_unlock(&dev->mutex);
+	mutex_lock(&dev->pm_mutex);
+
+	error = bcm5974_start_traffic(dev);
+	if (!error)
+		dev->opened = 1;
+
+	mutex_unlock(&dev->pm_mutex);
 
 	return error;
 }
@@ -491,24 +493,24 @@ static void bcm5974_close(struct input_dev *input)
 {
 	struct bcm5974 *dev = input_get_drvdata(input);
 
-	mutex_lock(&dev->mutex);
-	if (!dev->manually_suspended)
-		pause_traffic(dev);
+	mutex_lock(&dev->pm_mutex);
+
+	bcm5974_pause_traffic(dev);
 	dev->opened = 0;
-	mutex_unlock(&dev->mutex);
+
+	mutex_unlock(&dev->pm_mutex);
 }
 
 static int bcm5974_suspend(struct usb_interface *iface, pm_message_t message)
 {
 	struct bcm5974 *dev = usb_get_intfdata(iface);
 
-	if (dev) {
-		mutex_lock(&dev->mutex);
-		if (dev->opened && !dev->manually_suspended)
-			pause_traffic(dev);
-		dev->manually_suspended++;
-		mutex_unlock(&dev->mutex);
-	}
+	mutex_lock(&dev->pm_mutex);
+
+	if (dev->opened)
+		bcm5974_pause_traffic(dev);
+
+	mutex_unlock(&dev->pm_mutex);
 
 	return 0;
 }
@@ -518,22 +520,18 @@ static int bcm5974_resume(struct usb_interface *iface)
 	struct bcm5974 *dev = usb_get_intfdata(iface);
 	int error = 0;
 
-	if (dev) {
-		mutex_lock(&dev->mutex);
-		if (dev->manually_suspended)
-			dev->manually_suspended--;
-		if (dev->opened && !dev->manually_suspended)
-			error = start_traffic(dev);
-		if (error)
-			dev->opened = 0;
-		mutex_unlock(&dev->mutex);
-	}
+	mutex_lock(&dev->pm_mutex);
+
+	if (dev->opened)
+		error = bcm5974_start_traffic(dev);
+
+	mutex_unlock(&dev->pm_mutex);
 
 	return error;
 }
 
 static int bcm5974_probe(struct usb_interface *iface,
-		     const struct usb_device_id *id)
+			 const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(iface);
 	const struct bcm5974_config *cfg;
@@ -555,7 +553,7 @@ static int bcm5974_probe(struct usb_interface *iface,
 	dev->udev = udev;
 	dev->input = input_dev;
 	dev->cfg = *cfg;
-	mutex_init(&dev->mutex);
+	mutex_init(&dev->pm_mutex);
 
 	/* setup urbs */
 	dev->bt_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -567,26 +565,26 @@ static int bcm5974_probe(struct usb_interface *iface,
 		goto err_free_bt_urb;
 
 	dev->bt_data = usb_buffer_alloc(dev->udev,
-		dev->cfg.bt_datalen, GFP_KERNEL,
-		&dev->bt_urb->transfer_dma);
+					dev->cfg.bt_datalen, GFP_KERNEL,
+					&dev->bt_urb->transfer_dma);
 	if (!dev->bt_data)
 		goto err_free_urb;
 
 	dev->tp_data = usb_buffer_alloc(dev->udev,
-		dev->cfg.tp_datalen, GFP_KERNEL,
-		&dev->tp_urb->transfer_dma);
+					dev->cfg.tp_datalen, GFP_KERNEL,
+					&dev->tp_urb->transfer_dma);
 	if (!dev->tp_data)
 		goto err_free_bt_buffer;
 
 	usb_fill_int_urb(dev->bt_urb, udev,
-		usb_rcvintpipe(udev, cfg->bt_ep),
-		dev->bt_data, dev->cfg.bt_datalen,
-		irq_button, dev, 1);
+			 usb_rcvintpipe(udev, cfg->bt_ep),
+			 dev->bt_data, dev->cfg.bt_datalen,
+			 bcm5974_irq_button, dev, 1);
 
 	usb_fill_int_urb(dev->tp_urb, udev,
-		usb_rcvintpipe(udev, cfg->tp_ep),
-		dev->tp_data, dev->cfg.tp_datalen,
-		irq_trackpad, dev, 1);
+			 usb_rcvintpipe(udev, cfg->tp_ep),
+			 dev->tp_data, dev->cfg.tp_datalen,
+			 bcm5974_irq_trackpad, dev, 1);
 
 	/* create bcm5974 device */
 	usb_make_path(udev, dev->phys, sizeof(dev->phys));
@@ -638,24 +636,22 @@ static void bcm5974_disconnect(struct usb_interface *iface)
 
 	input_unregister_device(dev->input);
 	usb_buffer_free(dev->udev, dev->cfg.tp_datalen,
-		dev->tp_data, dev->tp_urb->transfer_dma);
+			dev->tp_data, dev->tp_urb->transfer_dma);
 	usb_buffer_free(dev->udev, dev->cfg.bt_datalen,
-		dev->bt_data, dev->bt_urb->transfer_dma);
+			dev->bt_data, dev->bt_urb->transfer_dma);
 	usb_free_urb(dev->tp_urb);
 	usb_free_urb(dev->bt_urb);
 	kfree(dev);
-
-	printk(KERN_INFO "bcm5974: disconnected\n");
 }
 
 static struct usb_driver bcm5974_driver = {
-	.name = "bcm5974",
-	.probe = bcm5974_probe,
-	.disconnect = bcm5974_disconnect,
-	.suspend = bcm5974_suspend,
-	.resume = bcm5974_resume,
-	.reset_resume = bcm5974_resume,
-	.id_table = bcm5974_table,
+	.name			= "bcm5974",
+	.probe			= bcm5974_probe,
+	.disconnect		= bcm5974_disconnect,
+	.suspend		= bcm5974_suspend,
+	.resume			= bcm5974_resume,
+	.reset_resume		= bcm5974_resume,
+	.id_table		= bcm5974_table,
 };
 
 static int __init bcm5974_init(void)

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bcm5974-autopm.patch"

Input: bcm5974 - implement autosuspend support

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/bcm5974.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 6f85278..2ec921b 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -150,6 +150,7 @@ struct bcm5974_config {
 struct bcm5974 {
 	char phys[64];
 	struct usb_device *udev;	/* usb device */
+	struct usb_interface *intf;	/* our interface */
 	struct input_dev *input;	/* input dev */
 	struct bcm5974_config cfg;	/* device configuration */
 	struct mutex pm_mutex;		/* serialize access to open/suspend */
@@ -478,6 +479,10 @@ static int bcm5974_open(struct input_dev *input)
 	struct bcm5974 *dev = input_get_drvdata(input);
 	int error;
 
+	error = usb_autopm_get_interface(dev->intf);
+	if (error)
+		return error;
+
 	mutex_lock(&dev->pm_mutex);
 
 	error = bcm5974_start_traffic(dev);
@@ -486,6 +491,9 @@ static int bcm5974_open(struct input_dev *input)
 
 	mutex_unlock(&dev->pm_mutex);
 
+	if (error)
+		usb_autopm_put_interface(dev->intf);
+
 	return error;
 }
 
@@ -499,6 +507,8 @@ static void bcm5974_close(struct input_dev *input)
 	dev->opened = 0;
 
 	mutex_unlock(&dev->pm_mutex);
+
+	usb_autopm_put_interface(dev->intf);
 }
 
 static int bcm5974_suspend(struct usb_interface *iface, pm_message_t message)
@@ -551,6 +561,7 @@ static int bcm5974_probe(struct usb_interface *iface,
 	}
 
 	dev->udev = udev;
+	dev->intf = iface;
 	dev->input = input_dev;
 	dev->cfg = *cfg;
 	mutex_init(&dev->pm_mutex);
@@ -652,6 +663,7 @@ static struct usb_driver bcm5974_driver = {
 	.resume			= bcm5974_resume,
 	.reset_resume		= bcm5974_resume,
 	.id_table		= bcm5974_table,
+	.supports_autosuspend	= 1,
 };
 
 static int __init bcm5974_init(void)

--0OAP2g/MAC+5xKAE--
