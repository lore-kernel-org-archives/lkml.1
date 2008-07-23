Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYGWLiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYGWLiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYGWLiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:38:05 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48877 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbYGWLiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:38:01 -0400
Message-ID: <48871811.2060808@euromail.se>
Date: Wed, 23 Jul 2008 13:37:53 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net,
       Oliver Neukum <oliver@neukum.org>, stern@rowland.harvard.edu
Subject: Re: [PATCH] linux-input: bcm5974-0.57: mode-switch to atp_open,	cleanup
 bug fixed
References: <1216466049.6238.0.camel@alnilam> <20080720051016.GA7853@anvil.corenet.prv> <1216688142.4768.26.camel@alnilam> <20080722093606.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080722093606.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.11
X-ACL-Warn: Too high rate of unknown addresses received from you
X-Scan-Result: No virus found in message 1KLcfO-0001Rj-7d.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KLcfO-0001Rj-7d b91c94542beccd556f55304830d96441
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

here are the tentative changes, addressing your comments.
The diff is against version 0.57.

Thanks,
Henrik
--

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 1e1cf04..55c1f60 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
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
@@ -133,26 +134,27 @@ struct atp_params {
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
@@ -171,11 +173,11 @@ struct atp {
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
@@ -184,9 +186,9 @@ static const struct atp_config atp_config_table[] = {
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
@@ -198,15 +200,14 @@ static const struct atp_config atp_config_table[] = {
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
@@ -216,33 +217,55 @@ static inline int raw2int(__le16 x)
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
@@ -255,6 +278,7 @@ static int report_tp_state(struct atp *dev, int size)
 		input_report_key(dev->input, BTN_TOOL_FINGER, false);
 		input_report_key(dev->input, BTN_TOOL_DOUBLETAP, false);
 		input_report_key(dev->input, BTN_TOOL_TRIPLETAP, false);
+		input_sync(dev->input);
 		return 0;
 	}

@@ -274,17 +298,18 @@ static int report_tp_state(struct atp *dev, int size)
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
-#define ATP_WELLSPRING_MODE_VENDOR_VALUE	0x01
+#define BCM5974_WELLSPRING_MODE_READ_REQUEST_ID		1
+#define BCM5974_WELLSPRING_MODE_WRITE_REQUEST_ID	9
+#define BCM5974_WELLSPRING_MODE_REQUEST_VALUE		0x300
+#define BCM5974_WELLSPRING_MODE_REQUEST_INDEX		0
+#define BCM5974_WELLSPRING_MODE_VENDOR_VALUE		0x01

-static int atp_wellspring_mode(struct atp *dev)
+static int bcm5974_wellspring_mode(struct bcm5974 *dev)
 {
 	char *data = kmalloc(8, GFP_KERNEL);
 	int error = 0, size;
@@ -297,10 +322,10 @@ static int atp_wellspring_mode(struct atp *dev)

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
@@ -309,14 +334,14 @@ static int atp_wellspring_mode(struct atp *dev)
 	}

 	/* apply the mode switch */
-	data[0] = ATP_WELLSPRING_MODE_VENDOR_VALUE;
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
@@ -336,7 +361,7 @@ error:

 static void irq_button(struct urb *urb)
 {
-	struct atp *dev = urb->context;
+	struct bcm5974 *dev = urb->context;
 	int error;

 	switch (urb->status) {
@@ -353,13 +378,9 @@ static void irq_button(struct urb *urb)
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
@@ -369,7 +390,7 @@ exit:

 static void irq_trackpad(struct urb *urb)
 {
-	struct atp *dev = urb->context;
+	struct bcm5974 *dev = urb->context;
 	int error;

 	switch (urb->status) {
@@ -390,13 +411,9 @@ static void irq_trackpad(struct urb *urb)
 	if (dev->tp_urb->actual_length == 2)
 		goto exit;

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
@@ -417,99 +434,149 @@ exit:
  * device, resulting in trackpad malfunction under certain
  * circumstances. To get around this problem, there is at least one
  * example that utilizes the USB_QUIRK_RESET_RESUME quirk in order to
- * recieve a reset_resume request rather than the normal resume. Since
- * the implementation of reset_resume is equal to mode switch plus
- * open, it seems easier to always do the switch while opening the
- * device.
+ * recieve a reset_resume request rather than the normal resume.
+ * Since the implementation of reset_resume is equal to mode switch
+ * plus start_traffic, it seems easier to always do the switch when
+ * starting traffic on the device.
  */
-static int atp_open(struct input_dev *input)
+static int start_traffic(struct bcm5974 *dev)
 {
-	struct atp *dev = input_get_drvdata(input);
-
-	if (!dev->open) {
-		if (atp_wellspring_mode(dev)) {
-			dprintk(1, "bcm5974: mode switch failed\n");
-			goto error;
-		}
-		if (usb_submit_urb(dev->bt_urb, GFP_KERNEL))
-			goto error;
-		if (usb_submit_urb(dev->tp_urb, GFP_KERNEL))
-			goto err_kill_bt;
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
 err_kill_bt:
 	usb_kill_urb(dev->bt_urb);
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

-	dev->open = 0;
-	dev->suspended = 0;
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
+
+	mutex_lock(&dev->mutex);
+	if (dev->manually_suspended)
+		error = -EACCES;
+	else if (!dev->opened)
+		error = start_traffic(dev);
+	dev->opened = !error;
+	mutex_unlock(&dev->mutex);
+
+	return error;
 }

-static int atp_probe(struct usb_interface *iface,
+static void bcm5974_close(struct input_dev *input)
+{
+	struct bcm5974 *dev = input_get_drvdata(input);
+
+	mutex_lock(&dev->mutex);
+	if (!dev->manually_suspended)
+		pause_traffic(dev);
+	dev->opened = 0;
+	mutex_unlock(&dev->mutex);
+}
+
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
@@ -521,6 +588,7 @@ static int atp_probe(struct usb_interface *iface,
 		dev->tp_data, dev->cfg.tp_datalen,
 		irq_trackpad, dev, 1);

+	/* create bcm5974 device */
 	usb_make_path(udev, dev->phys, sizeof(dev->phys));
 	strlcat(dev->phys, "/input0", sizeof(dev->phys));

@@ -531,24 +599,10 @@ static int atp_probe(struct usb_interface *iface,

 	input_set_drvdata(input_dev, dev);

-	input_dev->open = atp_open;
-	input_dev->close = atp_close;
+	input_dev->open = bcm5974_open;
+	input_dev->close = bcm5974_close;

-	set_bit(EV_ABS, input_dev->evbit);
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-		0, cfg->p.dim, cfg->p.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_TOOL_WIDTH,
-		0, cfg->w.dim, cfg->w.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_X,
-		0, cfg->x.dim, cfg->x.fuzz, 0);
-	input_set_abs_params(input_dev, ABS_Y,
-		0, cfg->y.dim, cfg->y.fuzz, 0);
-
-	set_bit(EV_KEY, input_dev->evbit);
-	set_bit(BTN_TOOL_FINGER, input_dev->keybit);
-	set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
-	set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
-	set_bit(BTN_LEFT, input_dev->keybit);
+	setup_events_to_report(input_dev, cfg);

 	error = input_register_device(dev->input);
 	if (error)
@@ -571,77 +625,49 @@ err_free_bt_urb:
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
-static struct usb_driver atp_driver = {
+static struct usb_driver bcm5974_driver = {
 	.name = "bcm5974",
-	.probe = atp_probe,
-	.disconnect = atp_disconnect,
-	.suspend = atp_suspend,
-	.resume = atp_resume,
-	.reset_resume = atp_resume,
-	.id_table = atp_table,
+	.probe = bcm5974_probe,
+	.disconnect = bcm5974_disconnect,
+	.suspend = bcm5974_suspend,
+	.resume = bcm5974_resume,
+	.reset_resume = bcm5974_resume,
+	.id_table = bcm5974_table,
 };

-static int __init atp_init(void)
+static int __init bcm5974_init(void)
 {
-	return usb_register(&atp_driver);
+	return usb_register(&bcm5974_driver);
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

