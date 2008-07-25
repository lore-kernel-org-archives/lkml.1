Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYGYAks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYGYAks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYGYAkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:40:41 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:38407 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbYGYAkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:40:39 -0400
Message-ID: <48892103.3020307@euromail.se>
Date: Fri, 25 Jul 2008 02:40:35 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] bcm5974-0.58: name changes, open/close and suspend/resume
 CORRECTED
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.11
X-Scan-Result: No virus found in message 1KMBMJ-0002PZ-5r.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KMBMJ-0002PZ-5r fe663cd7b387234ecb4d15768c0777f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please disregard the prior mail with the same name - there was a slip-up.
Sorry for spamming (still learning how to work with patches!)

Changelog since 0.55:

bcm5974 (0.58) unstable; urgency=low

  * Name changes; use usbhid definitions, rename atp to bcm5974
  * Input syncing moved to report functions, event type setup broken out
  * Traffic functions added for open/close and suspend/resume logic
  * Open/close and suspend/resume transition logic corrected
  * Open/close serialized with respect to suspend/resume

  -- Henrik Rydberg <rydberg@euromail.se>  Wed, 23 Jul 2008 02:20:10 +0200

bcm5974 (0.57) unstable; urgency=low

  * Keep reset_resume around
  * Submitted to kernel.org

  -- Henrik Rydberg <rydberg@euromail.se>  Sat, 19 Jul 2008 01:42:52 +0200

bcm5974 (0.56) unstable; urgency=low

  * Leave device initialization to hid; use mode-switch only
  * Mode switch moved to atp_open and simplified
  * Corrected cleanup action in atp_open
  * Simplified control package detection
  * Removed reset_resume, pre_reset, post_reset; not needed

  -- Henrik Rydberg <rydberg@euromail.se>  Fri, 18 Jul 2008 02:42:52 +0200

This version, without the dynamic-quirk patch, was also sent to kernel.org.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 updates/input/mouse/bcm5974.c |  495 ++++++++++++++++++++---------------------
 1 files changed, 241 insertions(+), 254 deletions(-)

diff --git a/updates/input/mouse/bcm5974.c b/updates/input/mouse/bcm5974.c
index c43fc0c..5edc784 100644
--- a/updates/input/mouse/bcm5974.c
+++ b/updates/input/mouse/bcm5974.c
@@ -39,42 +39,43 @@
 #include <linux/module.h>
 #include <linux/usb/input.h>
 #include <linux/hid.h>
+#include <linux/mutex.h>

-#define APPLE_VENDOR_ID		0x05AC
+#define USB_VENDOR_ID_APPLE		0x05ac

 /* MacbookAir, aka wellspring */
-#define ATP_WELLSPRING_ANSI	0x0223
-#define ATP_WELLSPRING_ISO	0x0224
-#define ATP_WELLSPRING_JIS	0x0225
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ANSI	0x0223
+#define USB_DEVICE_ID_APPLE_WELLSPRING_ISO	0x0224
+#define USB_DEVICE_ID_APPLE_WELLSPRING_JIS	0x0225
 /* MacbookProPenryn, aka wellspring2 */
-#define ATP_WELLSPRING2_ANSI	0x0230
-#define ATP_WELLSPRING2_ISO	0x0231
-#define ATP_WELLSPRING2_JIS	0x0232
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI	0x0230
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO	0x0231
+#define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232

-#define ATP_DEVICE(prod) {					\
+#define BCM5974_DEVICE(prod) {					\
 	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
 			USB_DEVICE_ID_MATCH_INT_CLASS |		\
 			USB_DEVICE_ID_MATCH_INT_PROTOCOL),	\
-	.idVendor = APPLE_VENDOR_ID,				\
+	.idVendor = USB_VENDOR_ID_APPLE,			\
 	.idProduct = (prod),					\
 	.bInterfaceClass = USB_INTERFACE_CLASS_HID,		\
 	.bInterfaceProtocol = USB_INTERFACE_PROTOCOL_MOUSE	\
 }

 /* table of devices that work with this driver */
-static const struct usb_device_id atp_table [] = {
+static const struct usb_device_id bcm5974_table [] = {
 	/* MacbookAir1.1 */
-	ATP_DEVICE(ATP_WELLSPRING_ANSI),
-	ATP_DEVICE(ATP_WELLSPRING_ISO),
-	ATP_DEVICE(ATP_WELLSPRING_JIS),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING_JIS),
 	/* MacbookProPenryn */
-	ATP_DEVICE(ATP_WELLSPRING2_ANSI),
-	ATP_DEVICE(ATP_WELLSPRING2_ISO),
-	ATP_DEVICE(ATP_WELLSPRING2_JIS),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_ISO),
+	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING2_JIS),
 	/* Terminating entry */
 	{}
 };
-MODULE_DEVICE_TABLE(usb, atp_table);
+MODULE_DEVICE_TABLE(usb, bcm5974_table);

 MODULE_AUTHOR("Henrik Rydberg");
 MODULE_DESCRIPTION("Apple USB BCM5974 multitouch driver");
@@ -125,7 +126,7 @@ struct tp_data {
 };

 /* device-specific parameters */
-struct atp_params {
+struct bcm5974_param {
 	int dim;		/* logical dimension */
 	int fuzz;		/* logical noise value */
 	int devmin;		/* device minimum reading */
@@ -133,31 +134,31 @@ struct atp_params {
 };

 /* device-specific configuration */
-struct atp_config {
+struct bcm5974_config {
 	int ansi, iso, jis;	/* the product id of this device */
 	int bt_ep;		/* the endpoint of the button interface */
 	int bt_datalen;		/* data length of the button interface */
 	int tp_ep;		/* the endpoint of the trackpad interface */
 	int tp_datalen;		/* data length of the trackpad interface */
-	struct atp_params p;	/* finger pressure limits */
-	struct atp_params w;	/* finger width limits */
-	struct atp_params x;	/* horizontal limits */
-	struct atp_params y;	/* vertical limits */
+	struct bcm5974_param p;	/* finger pressure limits */
+	struct bcm5974_param w;	/* finger width limits */
+	struct bcm5974_param x;	/* horizontal limits */
+	struct bcm5974_param y;	/* vertical limits */
 };

 /* logical device structure */
-struct atp {
+struct bcm5974 {
 	char phys[64];
 	struct usb_device *udev;	/* usb device */
 	struct input_dev *input;	/* input dev */
-	struct atp_config cfg;		/* device configuration */
-	int open;			/* >0: open, else closed */
-	int suspended;			/* >0: suspended, else open */
+	struct bcm5974_config cfg;	/* device configuration */
+	struct mutex mutex;		/* serialize access to open/suspend */
+	int opened;			/* >0: opened, else closed */
+	int manually_suspended;		/* >0: manually suspended */
 	struct urb *bt_urb;		/* button usb request block */
 	struct bt_data *bt_data;	/* button transferred data */
 	struct urb *tp_urb;		/* trackpad usb request block */
 	struct tp_data *tp_data;	/* trackpad transferred data */
-	unsigned tp_valid;		/* trackpad sensors valid */
 };

 /* logical dimensions */
@@ -172,11 +173,11 @@ struct atp {
 #define SN_COORD	250		/* coordinate signal-to-noise ratio */

 /* device constants */
-static const struct atp_config atp_config_table[] = {
+static const struct bcm5974_config bcm5974_config_table[] = {
 	{
-		ATP_WELLSPRING_ANSI,
-		ATP_WELLSPRING_ISO,
-		ATP_WELLSPRING_JIS,
+		USB_DEVICE_ID_APPLE_WELLSPRING_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING_JIS,
 		0x84, sizeof(struct bt_data),
 		0x81, sizeof(struct tp_data),
 		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 256 },
@@ -185,9 +186,9 @@ static const struct atp_config atp_config_table[] = {
 		{ DIM_Y, DIM_Y / SN_COORD, -172, 5820 }
 	},
 	{
-		ATP_WELLSPRING2_ANSI,
-		ATP_WELLSPRING2_ISO,
-		ATP_WELLSPRING2_JIS,
+		USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI,
+		USB_DEVICE_ID_APPLE_WELLSPRING2_ISO,
+		USB_DEVICE_ID_APPLE_WELLSPRING2_JIS,
 		0x84, sizeof(struct bt_data),
 		0x81, sizeof(struct tp_data),
 		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 256 },
@@ -199,15 +200,14 @@ static const struct atp_config atp_config_table[] = {
 };

 /* return the device-specific configuration by device */
-static const struct atp_config *atp_product_config(struct usb_device *udev)
+static const struct bcm5974_config *bcm5974_get_config(struct usb_device *udev)
 {
 	u16 id = le16_to_cpu(udev->descriptor.idProduct);
-	const struct atp_config *config;
-	for (config = atp_config_table; config->ansi; ++config)
-		if (config->ansi == id || config->iso == id ||
-				config->jis == id)
-			return config;
-	return atp_config_table;
+	const struct bcm5974_config *cfg;
+	for (cfg = bcm5974_config_table; cfg->ansi; ++cfg)
+		if (cfg->ansi == id || cfg->iso == id || cfg->jis == id)
+			return cfg;
+	return bcm5974_config_table;
 }

 /* convert 16-bit little endian to signed integer */
@@ -217,33 +217,55 @@ static inline int raw2int(__le16 x)
 }

 /* scale device data to logical dimensions (asserts devmin < devmax) */
-static inline int int2scale(const struct atp_params *p, int x)
+static inline int int2scale(const struct bcm5974_param *p, int x)
 {
 	return x * p->dim / (p->devmax - p->devmin);
 }

 /* all logical value ranges are [0,dim). */
-static inline int int2bound(const struct atp_params *p, int x)
+static inline int int2bound(const struct bcm5974_param *p, int x)
 {
 	int s = int2scale(p, x);
 	return s < 0 ? 0 : s >= p->dim ? p->dim - 1 : s;
 }

+/* setup which logical events to report */
+static void setup_events_to_report(struct input_dev *input_dev,
+	const struct bcm5974_config *cfg)
+{
+	set_bit(EV_ABS, input_dev->evbit);
+	input_set_abs_params(input_dev, ABS_PRESSURE,
+		0, cfg->p.dim, cfg->p.fuzz, 0);
+	input_set_abs_params(input_dev, ABS_TOOL_WIDTH,
+		0, cfg->w.dim, cfg->w.fuzz, 0);
+	input_set_abs_params(input_dev, ABS_X,
+		0, cfg->x.dim, cfg->x.fuzz, 0);
+	input_set_abs_params(input_dev, ABS_Y,
+		0, cfg->y.dim, cfg->y.fuzz, 0);
+
+	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+	set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
+	set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
+	set_bit(BTN_LEFT, input_dev->keybit);
+}
+
 /* report button data as logical button state */
-static int report_bt_state(struct atp *dev, int size)
+static int report_bt_state(struct bcm5974 *dev, int size)
 {
 	if (size != sizeof(struct bt_data))
 		return -EIO;

 	input_report_key(dev->input, BTN_LEFT, dev->bt_data->button);
+	input_sync(dev->input);

 	return 0;
 }

 /* report trackpad data as logical trackpad state */
-static int report_tp_state(struct atp *dev, int size)
+static int report_tp_state(struct bcm5974 *dev, int size)
 {
-	const struct atp_config *c = &dev->cfg;
+	const struct bcm5974_config *c = &dev->cfg;
 	const struct tp_finger *f = dev->tp_data->finger;
 	const int fingers = (size - 26) / 28;
 	int p, w, x, y, n;
@@ -256,6 +278,7 @@ static int report_tp_state(struct atp *dev, int size)
 		input_report_key(dev->input, BTN_TOOL_FINGER, false);
 		input_report_key(dev->input, BTN_TOOL_DOUBLETAP, false);
 		input_report_key(dev->input, BTN_TOOL_TRIPLETAP, false);
+		input_sync(dev->input);
 		return 0;
 	}

@@ -275,18 +298,18 @@ static int report_tp_state(struct atp *dev, int size)
 	input_report_key(dev->input, BTN_TOOL_FINGER, n == 1);
 	input_report_key(dev->input, BTN_TOOL_DOUBLETAP, n == 2);
 	input_report_key(dev->input, BTN_TOOL_TRIPLETAP, n > 2);
+	input_sync(dev->input);
 	return 0;
 }

 /* Wellspring initialization constants */
-#define ATP_WELLSPRING_MODE_READ_REQUEST_ID	1
-#define ATP_WELLSPRING_MODE_WRITE_REQUEST_ID	9
-#define ATP_WELLSPRING_MODE_REQUEST_VALUE	0x300
-#define ATP_WELLSPRING_MODE_REQUEST_INDEX	0
-#define ATP_WELLSPRING_MODE_VENDOR_VALUE_1	0x01
-#define ATP_WELLSPRING_MODE_VENDOR_VALUE_2	0x05
-
-static int atp_wellspring_init(struct atp *dev)
+#define BCM5974_WELLSPRING_MODE_READ_REQUEST_ID		1
+#define BCM5974_WELLSPRING_MODE_WRITE_REQUEST_ID	9
+#define BCM5974_WELLSPRING_MODE_REQUEST_VALUE		0x300
+#define BCM5974_WELLSPRING_MODE_REQUEST_INDEX		0
+#define BCM5974_WELLSPRING_MODE_VENDOR_VALUE		0x01
+
+static int bcm5974_wellspring_mode(struct bcm5974 *dev)
 {
 	char *data = kmalloc(8, GFP_KERNEL);
 	int error = 0, size;
@@ -297,30 +320,12 @@ static int atp_wellspring_init(struct atp *dev)
 		goto error;
 	}

-	/* reset button endpoint */
-	if (usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
-			USB_REQ_CLEAR_FEATURE, USB_RECIP_ENDPOINT,
-			0, dev->cfg.bt_ep, NULL, 0, 5000)) {
-		err("bcm5974: could not reset button endpoint");
-		error = -EIO;
-		goto error;
-	}
-
-	/* reset trackpad endpoint */
-	if (usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
-			USB_REQ_CLEAR_FEATURE, USB_RECIP_ENDPOINT,
-			0, dev->cfg.tp_ep, NULL, 0, 5000)) {
-		err("bcm5974: could not reset trackpad endpoint");
-		error = -EIO;
-		goto error;
-	}
-
 	/* read configuration */
 	size = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
-		ATP_WELLSPRING_MODE_READ_REQUEST_ID,
+		BCM5974_WELLSPRING_MODE_READ_REQUEST_ID,
 		USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		ATP_WELLSPRING_MODE_REQUEST_VALUE,
-		ATP_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
+		BCM5974_WELLSPRING_MODE_REQUEST_VALUE,
+		BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);

 	if (size != 8) {
 		err("bcm5974: could not read from device");
@@ -329,15 +334,14 @@ static int atp_wellspring_init(struct atp *dev)
 	}

 	/* apply the mode switch */
-	data[0] = ATP_WELLSPRING_MODE_VENDOR_VALUE_1;
-	data[1] = ATP_WELLSPRING_MODE_VENDOR_VALUE_2;
+	data[0] = BCM5974_WELLSPRING_MODE_VENDOR_VALUE;

 	/* write configuration */
 	size = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
-		ATP_WELLSPRING_MODE_WRITE_REQUEST_ID,
+		BCM5974_WELLSPRING_MODE_WRITE_REQUEST_ID,
 		USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		ATP_WELLSPRING_MODE_REQUEST_VALUE,
-		ATP_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
+		BCM5974_WELLSPRING_MODE_REQUEST_VALUE,
+		BCM5974_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);

 	if (size != 8) {
 		err("bcm5974: could not write to device");
@@ -345,9 +349,7 @@ static int atp_wellspring_init(struct atp *dev)
 		goto error;
 	}

-	dev->tp_valid = 0;
-
-	printk(KERN_INFO "bcm5974: Wellspring mode initialized.\n");
+	dprintk(2, "bcm5974: switched to wellspring mode.\n");

 	kfree(data);
 	return 0;
@@ -359,7 +361,7 @@ error:

 static void irq_button(struct urb *urb)
 {
-	struct atp *dev = urb->context;
+	struct bcm5974 *dev = urb->context;
 	int error;

 	switch (urb->status) {
@@ -376,13 +378,9 @@ static void irq_button(struct urb *urb)
 		goto exit;
 	}

-	if (report_bt_state(dev, dev->bt_urb->actual_length)) {
+	if (report_bt_state(dev, dev->bt_urb->actual_length))
 		dprintk(1, "bcm5974: bad button package, length: %d\n",
 			dev->bt_urb->actual_length);
-		goto exit;
-	}
-
-	input_sync(dev->input);

 exit:
 	error = usb_submit_urb(dev->bt_urb, GFP_ATOMIC);
@@ -392,7 +390,7 @@ exit:

 static void irq_trackpad(struct urb *urb)
 {
-	struct atp *dev = urb->context;
+	struct bcm5974 *dev = urb->context;
 	int error;

 	switch (urb->status) {
@@ -409,19 +407,13 @@ static void irq_trackpad(struct urb *urb)
 		goto exit;
 	}

-	/* first sample data ignored */
-	if (!dev->tp_valid) {
-		dev->tp_valid = 1;
+	/* control response ignored */
+	if (dev->tp_urb->actual_length == 2)
 		goto exit;
-	}

-	if (report_tp_state(dev, dev->tp_urb->actual_length)) {
+	if (report_tp_state(dev, dev->tp_urb->actual_length))
 		dprintk(1, "bcm5974: bad trackpad package, length: %d\n",
 			dev->tp_urb->actual_length);
-		goto exit;
-	}
-
-	input_sync(dev->input);

 exit:
 	error = usb_submit_urb(dev->tp_urb, GFP_ATOMIC);
@@ -429,96 +421,162 @@ exit:
 		err("bcm5974: trackpad urb failed: %d", error);
 }

-static int atp_open(struct input_dev *input)
+/*
+ * The Wellspring trackpad, like many recent Apple trackpads, share
+ * the usb device with the keyboard. Since keyboards are usually
+ * handled by the HID system, the device ends up being handled by two
+ * modules. Setting up the device therefore becomes slightly
+ * complicated. To enable multitouch features, a mode switch is
+ * required, which is usually applied via the control interface of the
+ * device.  It can be argued where this switch should take place. In
+ * some drivers, like appletouch, the switch is made during
+ * probe. However, the hid module may also alter the state of the
+ * device, resulting in trackpad malfunction under certain
+ * circumstances. To get around this problem, there is at least one
+ * example that utilizes the USB_QUIRK_RESET_RESUME quirk in order to
+ * recieve a reset_resume request rather than the normal resume.
+ * Since the implementation of reset_resume is equal to mode switch
+ * plus start_traffic, it seems easier to always do the switch when
+ * starting traffic on the device.
+ */
+static int start_traffic(struct bcm5974 *dev)
 {
-	struct atp *dev = input_get_drvdata(input);
-
-	if (!dev->open) {
-		if (usb_submit_urb(dev->bt_urb, GFP_KERNEL))
-			goto error;
-		if (usb_submit_urb(dev->tp_urb, GFP_KERNEL))
-			goto err_free_bt_urb;
+	if (bcm5974_wellspring_mode(dev)) {
+		dprintk(1, "bcm5974: mode switch failed\n");
+		goto error;
 	}
+	if (usb_submit_urb(dev->bt_urb, GFP_KERNEL))
+		goto error;
+	if (usb_submit_urb(dev->tp_urb, GFP_KERNEL))
+		goto err_kill_bt;

-	dev->open = 1;
-	dev->suspended = 0;
 	return 0;
-
-err_free_bt_urb:
-	usb_free_urb(dev->bt_urb);
+err_kill_bt:
+	usb_kill_urb(dev->bt_urb);
 error:
 	return -EIO;
 }

-static void atp_close(struct input_dev *input)
+static void pause_traffic(struct bcm5974 *dev)
 {
-	struct atp *dev = input_get_drvdata(input);
-
 	usb_kill_urb(dev->tp_urb);
 	usb_kill_urb(dev->bt_urb);
+}
+
+/*
+ * The code below implements open/close and manual suspend/resume.
+ * All functions may be called in random order.
+ *
+ * Opening a suspended device fails with EACCES - permission denied.
+ *
+ * Failing a resume leaves the device resumed but closed.
+ */
+static int bcm5974_open(struct input_dev *input)
+{
+	struct bcm5974 *dev = input_get_drvdata(input);
+	int error = 0;

-	dev->open = 0;
-	dev->suspended = 0;
+	mutex_lock(&dev->mutex);
+	if (dev->manually_suspended)
+		error = -EACCES;
+	else if (!dev->opened)
+		error = start_traffic(dev);
+	dev->opened = !error;
+	mutex_unlock(&dev->mutex);
+
+	return error;
+}
+
+static void bcm5974_close(struct input_dev *input)
+{
+	struct bcm5974 *dev = input_get_drvdata(input);
+
+	mutex_lock(&dev->mutex);
+	if (!dev->manually_suspended)
+		pause_traffic(dev);
+	dev->opened = 0;
+	mutex_unlock(&dev->mutex);
 }

-static int atp_probe(struct usb_interface *iface,
+static int bcm5974_suspend(struct usb_interface *iface, pm_message_t message)
+{
+	struct bcm5974 *dev = usb_get_intfdata(iface);
+
+	if (dev) {
+		mutex_lock(&dev->mutex);
+		if (dev->opened && !dev->manually_suspended)
+			pause_traffic(dev);
+		dev->manually_suspended++;
+		mutex_unlock(&dev->mutex);
+	}
+
+	return 0;
+}
+
+static int bcm5974_resume(struct usb_interface *iface)
+{
+	struct bcm5974 *dev = usb_get_intfdata(iface);
+	int error = 0;
+
+	if (dev) {
+		mutex_lock(&dev->mutex);
+		if (dev->manually_suspended)
+			dev->manually_suspended--;
+		if (dev->opened && !dev->manually_suspended)
+			error = start_traffic(dev);
+		if (error)
+			dev->opened = 0;
+		mutex_unlock(&dev->mutex);
+	}
+
+	return error;
+}
+
+static int bcm5974_probe(struct usb_interface *iface,
 		     const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(iface);
-	const struct atp_config *cfg;
-	struct atp *dev;
+	const struct bcm5974_config *cfg;
+	struct bcm5974 *dev;
 	struct input_dev *input_dev;
-	int error = 0;
+	int error = -ENOMEM;

 	/* find the product index */
-	cfg = atp_product_config(udev);
+	cfg = bcm5974_get_config(udev);

 	/* allocate memory for our device state and initialize it */
-	dev = kzalloc(sizeof(struct atp), GFP_KERNEL);
+	dev = kzalloc(sizeof(struct bcm5974), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!dev || !input_dev) {
 		err("bcm5974: out of memory");
-		error = -ENOMEM;
 		goto err_free_devs;
 	}

 	dev->udev = udev;
 	dev->input = input_dev;
 	dev->cfg = *cfg;
+	mutex_init(&dev->mutex);

-	/* switch to raw sensor mode */
-	if (atp_wellspring_init(dev)) {
-		error = -EIO;
-		goto err_free_devs;
-	}
-
+	/* setup urbs */
 	dev->bt_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!dev->bt_urb) {
-		error = -ENOMEM;
+	if (!dev->bt_urb)
 		goto err_free_devs;
-	}

 	dev->tp_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!dev->tp_urb) {
-		error = -ENOMEM;
+	if (!dev->tp_urb)
 		goto err_free_bt_urb;
-	}

 	dev->bt_data = usb_buffer_alloc(dev->udev,
 		dev->cfg.bt_datalen, GFP_KERNEL,
 		&dev->bt_urb->transfer_dma);
-	if (!dev->bt_data) {
-		error = -ENOMEM;
+	if (!dev->bt_data)
 		goto err_free_urb;
-	}

 	dev->tp_data = usb_buffer_alloc(dev->udev,
 		dev->cfg.tp_datalen, GFP_KERNEL,
 		&dev->tp_urb->transfer_dma);
-	if (!dev->tp_data) {
-		error = -ENOMEM;
+	if (!dev->tp_data)
 		goto err_free_bt_buffer;
-	}

 	usb_fill_int_urb(dev->bt_urb, udev,
 		usb_rcvintpipe(udev, cfg->bt_ep),
@@ -530,6 +588,7 @@ static int atp_probe(struct usb_interface *iface,
 		dev->tp_data, dev->cfg.tp_datalen,
 		irq_trackpad, dev, 1);

+	/* create bcm5974 device */
 	usb_make_path(udev, dev->phys, sizeof(dev->phys));
 	strlcat(dev->phys, "/input0", sizeof(dev->phys));

@@ -540,24 +599,10 @@ static int atp_probe(struct usb_interface *iface,

 	input_set_drvdata(input_dev, dev);

-	input_dev->open = atp_open;
-	input_dev->close = atp_close;
-
-	set_bit(EV_ABS, input_dev->evbit);
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-		0, cfg->p.dim, cfg->p.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_TOOL_WIDTH,
-		0, cfg->w.dim, cfg->w.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_X,
-		0, cfg->x.dim, cfg->x.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_Y,
-		0, cfg->y.dim, cfg->y.fuzz, 0);
+	input_dev->open = bcm5974_open;
+	input_dev->close = bcm5974_close;

-	set_bit(EV_KEY, input_dev->evbit);
-	set_bit(BTN_TOOL_FINGER, input_dev->keybit);
-	set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
-	set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
-	set_bit(BTN_LEFT, input_dev->keybit);
+	setup_events_to_report(input_dev, cfg);

 	error = input_register_device(dev->input);
 	if (error)
@@ -580,97 +625,39 @@ err_free_bt_urb:
 	usb_free_urb(dev->bt_urb);
 err_free_devs:
 	usb_set_intfdata(iface, NULL);
-	kfree(dev);
 	input_free_device(input_dev);
+	kfree(dev);
 	return error;
 }

-static void atp_disconnect(struct usb_interface *iface)
+static void bcm5974_disconnect(struct usb_interface *iface)
 {
-	struct atp *dev = usb_get_intfdata(iface);
+	struct bcm5974 *dev = usb_get_intfdata(iface);

 	usb_set_intfdata(iface, NULL);

-	if (dev) {
-		input_unregister_device(dev->input);
-		usb_buffer_free(dev->udev, dev->cfg.tp_datalen,
-			dev->tp_data, dev->tp_urb->transfer_dma);
-		usb_buffer_free(dev->udev, dev->cfg.bt_datalen,
-			dev->bt_data, dev->bt_urb->transfer_dma);
-		usb_free_urb(dev->tp_urb);
-		usb_free_urb(dev->bt_urb);
-		kfree(dev);
-	}
+	input_unregister_device(dev->input);
+	usb_buffer_free(dev->udev, dev->cfg.tp_datalen,
+		dev->tp_data, dev->tp_urb->transfer_dma);
+	usb_buffer_free(dev->udev, dev->cfg.bt_datalen,
+		dev->bt_data, dev->bt_urb->transfer_dma);
+	usb_free_urb(dev->tp_urb);
+	usb_free_urb(dev->bt_urb);
+	kfree(dev);

 	printk(KERN_INFO "bcm5974: disconnected\n");
 }

-static int atp_suspend(struct usb_interface *iface, pm_message_t message)
-{
-	struct atp *dev = usb_get_intfdata(iface);
-
-	if (dev) {
-		if (!dev->suspended)
-			atp_close(dev->input);
-		dev->suspended++;
-	}
-
-	return 0;
-}
-
-static int atp_resume(struct usb_interface *iface)
-{
-	struct atp *dev = usb_get_intfdata(iface);
-	int error = 0;
-
-	if (dev && dev->suspended) {
-		if (!--dev->suspended)
-			error = atp_open(dev->input);
-	}
-
-	return error;
-}
-
-static int atp_reset_resume(struct usb_interface *iface)
-{
-	struct atp *dev = usb_get_intfdata(iface);
-
-	if (dev && atp_wellspring_init(dev))
-		printk(KERN_INFO "bcm5974: warning: reset failed\n");
-
-	return atp_resume(iface);
-}
-
-static int atp_pre_reset(struct usb_interface *iface)
-{
-	return atp_suspend(iface, PMSG_ON);
-}
-
-static int atp_post_reset(struct usb_interface *iface)
-{
-	return atp_reset_resume(iface);
-}
-
-static struct usb_driver atp_driver = {
+static struct usb_driver bcm5974_driver = {
 	.name = "bcm5974",
-	.probe = atp_probe,
-	.disconnect = atp_disconnect,
-	.suspend = atp_suspend,
-	.resume = atp_resume,
-	.reset_resume = atp_reset_resume,
-	.pre_reset = atp_pre_reset,
-	.post_reset = atp_post_reset,
-	.id_table = atp_table,
+	.probe = bcm5974_probe,
+	.disconnect = bcm5974_disconnect,
+	.suspend = bcm5974_suspend,
+	.resume = bcm5974_resume,
+	.reset_resume = bcm5974_resume,
+	.id_table = bcm5974_table,
 };

-#define USB_VENDOR_ID_APPLE		0x05ac
-#define USB_DEVICE_ID_APPLE_WELLSPRING_ANSI   0x0223
-#define USB_DEVICE_ID_APPLE_WELLSPRING_ISO    0x0224
-#define USB_DEVICE_ID_APPLE_WELLSPRING_JIS    0x0225
-#define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI   0x0230
-#define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO    0x0231
-#define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS    0x0232
-
 static const struct hid_blacklist {
 	__u16 idVendor;
 	__u16 idProduct;
@@ -682,43 +669,43 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE},
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD | HID_QUIRK_IGNORE_MOUSE },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING2_JIS, HID_QUIRK_APPLE_HAS_FN  | HID_QUIRK_IGNORE_MOUSE },
-	{0,0,0}
+	{}
 };

-static int __init atp_update_quirks(void)
+static int __init bcm5974_update_quirks(void)
 {
-	struct hid_blacklist *bp;
-	int result=0;
-	for (bp=hid_blacklist; bp->quirks; bp++)
-	{
-		result = usbhid_modify_dquirk(bp->idVendor,bp->idProduct,bp->quirks);
-		if (result < 0)
-		{
-			dbg_hid("Could not modify quirk for %04x:%04x\n",bp->idVendor,bp->idProduct);
+	const struct hid_blacklist *bp;
+	int result = 0;
+	for (bp = hid_blacklist; bp->quirks; bp++) {
+		result = usbhid_modify_dquirk(bp->idVendor, bp->idProduct,
+			bp->quirks);
+		if (result < 0) {
+			dbg_hid("Could not modify quirk for %04x:%04x\n",
+				bp->idVendor, bp->idProduct);
 			break;
 		}
 	}
 	return result;
 }

-static int __init atp_init(void)
+static int __init bcm5974_init(void)
 {
 	int result;

 	/*
 	 * Update the kernel quirk table for this device.
 	 */
-	result = atp_update_quirks();
+	result = bcm5974_update_quirks();
 	if (result >= 0)
-		return usb_register(&atp_driver);
-	return(result);
+		return usb_register(&bcm5974_driver);
+	return result;
 }

-static void __exit atp_exit(void)
+static void __exit bcm5974_exit(void)
 {
-	usb_deregister(&atp_driver);
+	usb_deregister(&bcm5974_driver);
 }

-module_init(atp_init);
-module_exit(atp_exit);
+module_init(bcm5974_init);
+module_exit(bcm5974_exit);

-- 
1.5.4.3

