Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYEPJvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYEPJvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbYEPJut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:50:49 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43284 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753253AbYEPJuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:50:46 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jirislaby@gmail.com>,
       Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 03/10] HID: hid, make parsing event driven
Date: Fri, 16 May 2008 11:49:16 +0200
Message-Id: <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next step for complete hid bus, this patch includes:
- call parser either from probe or from hid-core if there is no probe.
- add ll_driver structure and centralize some stuff there (open, close...)
- split and merge usb_hid_configure and hid_probe into several functions
  to allow hooks/fixes between them

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-core.c        |   24 ++-
 drivers/hid/hid-input.c       |   16 ++-
 drivers/hid/hidraw.c          |    6 +-
 drivers/hid/usbhid/hid-core.c |  330 ++++++++++++++++++++++++-----------------
 include/linux/hid.h           |   94 +++++++++++-
 net/bluetooth/hidp/core.c     |  191 ++++++++++++++----------
 net/bluetooth/hidp/hidp.h     |    2 +
 7 files changed, 424 insertions(+), 239 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2bf7561..984d5d8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -648,6 +648,9 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 		hid_parser_reserved
 	};
 
+	if (device->driver->report_fixup)
+		device->driver->report_fixup(device, start, size);
+
 	device->rdesc = kmalloc(size, GFP_KERNEL);
 	if (device->rdesc == NULL)
 		return -ENOMEM;
@@ -1148,15 +1151,20 @@ static int hid_device_probe(struct device *dev)
 	int ret = 0;
 
 	if (!hdev->driver) {
-		if (hdrv->probe) {
-			ret = -ENODEV;
+		id = hid_match_id(hdev, hdrv->id_table);
+		if (id == NULL)
+			return -ENODEV;
 
-			id = hid_match_id(hdev, hdrv->id_table);
-			if (id)
-				ret = hdrv->probe(hdev, id);
+		hdev->driver = hdrv;
+		if (hdrv->probe) {
+			ret = hdrv->probe(hdev, id);
+		} else { /* default probe */
+			ret = hid_parse(hdev);
+			if (!ret)
+				ret = hid_hw_start(hdev);
 		}
-		if (!ret)
-			hdev->driver = hdrv;
+		if (ret)
+			hdev->driver = NULL;
 	}
 	return ret;
 }
@@ -1169,6 +1177,8 @@ static int hid_device_remove(struct device *dev)
 	if (hdrv) {
 		if (hdrv->remove)
 			hdrv->remove(hdev);
+		else /* default remove */
+			hid_hw_stop(hdev);
 		hdev->driver = NULL;
 	}
 
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 6f44ea0..6521ece 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -390,6 +390,11 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	if (ret)
 		goto mapped;
 
+	if (device->driver->input_mapping &&
+			device->driver->input_mapping(device, hidinput, usage,
+				&bit, &max))
+		goto mapped;
+
 	switch (usage->hid & HID_USAGE_PAGE) {
 
 		case HID_UP_UNDEFINED:
@@ -754,6 +759,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	}
 
 mapped:
+	if (device->driver->input_mapped)
+		device->driver->input_mapped(device, hidinput, usage,
+				&bit, &max);
+
 	if (device->quirks & HID_QUIRK_MIGHTYMOUSE) {
 		if (usage->hid == HID_GD_Z)
 			map_rel(REL_HWHEEL);
@@ -960,14 +969,14 @@ static int hidinput_open(struct input_dev *dev)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 
-	return hid->hid_open(hid);
+	return hid->ll_driver->open(hid);
 }
 
 static void hidinput_close(struct input_dev *dev)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 
-	hid->hid_close(hid);
+	hid->ll_driver->close(hid);
 }
 
 /*
@@ -1018,7 +1027,8 @@ int hidinput_connect(struct hid_device *hid)
 				}
 
 				input_set_drvdata(input_dev, hid);
-				input_dev->event = hid->hidinput_input_event;
+				input_dev->event =
+					hid->ll_driver->hidinput_input_event;
 				input_dev->open = hidinput_open;
 				input_dev->close = hidinput_close;
 				input_dev->setkeycode = hidinput_setkeycode;
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 1ca6f46..19081d0 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -178,7 +178,7 @@ static int hidraw_open(struct inode *inode, struct file *file)
 
 	dev = hidraw_table[minor];
 	if (!dev->open++)
-		dev->hid->hid_open(dev->hid);
+		dev->hid->ll_driver->open(dev->hid);
 
 out_unlock:
 	spin_unlock(&minors_lock);
@@ -203,7 +203,7 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	dev = hidraw_table[minor];
 	if (!dev->open--) {
 		if (list->hidraw->exist)
-			dev->hid->hid_close(dev->hid);
+			dev->hid->ll_driver->close(dev->hid);
 		else
 			kfree(list->hidraw);
 	}
@@ -359,7 +359,7 @@ void hidraw_disconnect(struct hid_device *hid)
 	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
 
 	if (hidraw->open) {
-		hid->hid_close(hid);
+		hid->ll_driver->close(hid);
 		wake_up_interruptible(&hidraw->wait);
 	} else {
 		kfree(hidraw);
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b649fdc..b23dcef 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -701,17 +701,84 @@ static void hid_fixup_sony_ps3_controller(struct usb_device *dev, int ifnum)
 	kfree(buf);
 }
 
-static struct hid_device *usb_hid_configure(struct usb_interface *intf)
+static int usbhid_start_finish(struct hid_device *hid)
 {
+	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
+	char path[64], *type;
+	unsigned int i;
+
+	usbhid_init_reports(hid);
+	hid_dump_device(hid);
+	if (hid->quirks & HID_QUIRK_RESET_LEDS)
+		usbhid_set_leds(hid);
+
+	if (!hidinput_connect(hid))
+		hid->claimed |= HID_CLAIMED_INPUT;
+	if (!hiddev_connect(hid))
+		hid->claimed |= HID_CLAIMED_HIDDEV;
+	if (!hidraw_connect(hid))
+		hid->claimed |= HID_CLAIMED_HIDRAW;
+
+	if (!hid->claimed) {
+		printk(KERN_ERR "HID device claimed by neither input, hiddev "
+				"nor hidraw\n");
+		return -ENODEV;
+	}
+
+	if ((hid->claimed & HID_CLAIMED_INPUT))
+		hid_ff_init(hid);
+
+	if (hid->quirks & HID_QUIRK_SONY_PS3_CONTROLLER)
+		hid_fixup_sony_ps3_controller(interface_to_usbdev(intf),
+			intf->cur_altsetting->desc.bInterfaceNumber);
+
+	printk(KERN_INFO);
+
+	if (hid->claimed & HID_CLAIMED_INPUT)
+		printk("input");
+	if ((hid->claimed & HID_CLAIMED_INPUT) &&
+			((hid->claimed & HID_CLAIMED_HIDDEV) ||
+				hid->claimed & HID_CLAIMED_HIDRAW))
+		printk(",");
+	if (hid->claimed & HID_CLAIMED_HIDDEV)
+		printk("hiddev%d", hid->minor);
+	if ((hid->claimed & HID_CLAIMED_INPUT) &&
+			(hid->claimed & HID_CLAIMED_HIDDEV) &&
+			(hid->claimed & HID_CLAIMED_HIDRAW))
+		printk(",");
+	if (hid->claimed & HID_CLAIMED_HIDRAW)
+		printk("hidraw%d", ((struct hidraw *)hid->hidraw)->minor);
+
+	type = "Device";
+	for (i = 0; i < hid->maxcollection; i++) {
+		if (hid->collection[i].type == HID_COLLECTION_APPLICATION &&
+		    (hid->collection[i].usage & HID_USAGE_PAGE) ==
+						HID_UP_GENDESK &&
+		    (hid->collection[i].usage & 0xffff) <
+						ARRAY_SIZE(hid_types)) {
+			type = hid_types[hid->collection[i].usage & 0xffff];
+			break;
+		}
+	}
+
+	usb_make_path(interface_to_usbdev(intf), path, 63);
+
+	printk(": USB HID v%x.%02x %s [%s] on %s\n",
+		hid->version >> 8, hid->version & 0xff, type, hid->name, path);
+
+	return 0;
+}
+
+static int usbhid_parse(struct hid_device *hid)
+{
+	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
 	struct usb_host_interface *interface = intf->cur_altsetting;
 	struct usb_device *dev = interface_to_usbdev (intf);
 	struct hid_descriptor *hdesc;
-	struct hid_device *hid;
 	u32 quirks = 0;
-	unsigned int insize = 0, rsize = 0;
+	unsigned int rsize = 0;
 	char *rdesc;
-	int n, len;
-	struct usbhid_device *usbhid;
+	int ret, n;
 
 	quirks = usbhid_lookup_quirk(le16_to_cpu(dev->descriptor.idVendor),
 			le16_to_cpu(dev->descriptor.idProduct));
@@ -725,40 +792,44 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 	}
 
 	if (quirks & HID_QUIRK_IGNORE)
-		return NULL;
+		return -ENODEV;
 
 	if ((quirks & HID_QUIRK_IGNORE_MOUSE) &&
 		(interface->desc.bInterfaceProtocol == USB_INTERFACE_PROTOCOL_MOUSE))
-			return NULL;
-
+			return -ENODEV;
 
 	if (usb_get_extra_descriptor(interface, HID_DT_HID, &hdesc) &&
 	    (!interface->desc.bNumEndpoints ||
 	     usb_get_extra_descriptor(&interface->endpoint[0], HID_DT_HID, &hdesc))) {
 		dbg_hid("class descriptor not present\n");
-		return NULL;
+		return -ENODEV;
 	}
 
+	hid->version = le16_to_cpu(hdesc->bcdHID);
+	hid->country = hdesc->bCountryCode;
+
 	for (n = 0; n < hdesc->bNumDescriptors; n++)
 		if (hdesc->desc[n].bDescriptorType == HID_DT_REPORT)
 			rsize = le16_to_cpu(hdesc->desc[n].wDescriptorLength);
 
 	if (!rsize || rsize > HID_MAX_DESCRIPTOR_SIZE) {
 		dbg_hid("weird size of report descriptor (%u)\n", rsize);
-		return NULL;
+		return -EINVAL;
 	}
 
 	if (!(rdesc = kmalloc(rsize, GFP_KERNEL))) {
 		dbg_hid("couldn't allocate rdesc memory\n");
-		return NULL;
+		return -ENOMEM;
 	}
 
 	hid_set_idle(dev, interface->desc.bInterfaceNumber, 0, 0);
 
-	if ((n = hid_get_class_descriptor(dev, interface->desc.bInterfaceNumber, HID_DT_REPORT, rdesc, rsize)) < 0) {
+	ret = hid_get_class_descriptor(dev, interface->desc.bInterfaceNumber,
+			HID_DT_REPORT, rdesc, rsize);
+	if (ret < 0) {
 		dbg_hid("reading report descriptor failed\n");
 		kfree(rdesc);
-		return NULL;
+		goto err;
 	}
 
 	usbhid_fixup_report_descriptor(le16_to_cpu(dev->descriptor.idVendor),
@@ -770,24 +841,36 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 		dbg_hid_line(" %02x", (unsigned char) rdesc[n]);
 	dbg_hid_line("\n");
 
-	hid = hid_allocate_device();
-	if (IS_ERR(hid)) {
-		kfree(rdesc);
-		return NULL;
-	}
-
-	if (hid_parse_report(hid, rdesc, n)) {
+	ret = hid_parse_report(hid, rdesc, rsize);
+	kfree(rdesc);
+	if (ret) {
 		dbg_hid("parsing report descriptor failed\n");
-		hid_destroy_device(hid);
-		kfree(rdesc);
-		return NULL;
+		goto err;
 	}
 
-	kfree(rdesc);
 	hid->quirks = quirks;
 
-	if (!(usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL)))
-		goto fail_no_usbhid;
+	return 0;
+err:
+	return ret;
+}
+
+static int usbhid_start(struct hid_device *hid)
+{
+	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
+	struct usb_host_interface *interface = intf->cur_altsetting;
+	struct usb_device *dev = interface_to_usbdev(intf);
+	struct usbhid_device *usbhid;
+	unsigned int n, insize = 0;
+	int ret;
+
+	WARN_ON(hid->driver_data);
+
+	usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL);
+	if (usbhid == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	hid->driver_data = usbhid;
 	usbhid->hid = hid;
@@ -805,27 +888,12 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 	if (insize > HID_MAX_BUFFER_SIZE)
 		insize = HID_MAX_BUFFER_SIZE;
 
-	if (hid_alloc_buffers(dev, hid))
+	if (hid_alloc_buffers(dev, hid)) {
+		ret = -ENOMEM;
 		goto fail;
-
-	hid->name[0] = 0;
-
-	if (dev->manufacturer)
-		strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
-
-	if (dev->product) {
-		if (dev->manufacturer)
-			strlcat(hid->name, " ", sizeof(hid->name));
-		strlcat(hid->name, dev->product, sizeof(hid->name));
 	}
 
-	if (!strlen(hid->name))
-		snprintf(hid->name, sizeof(hid->name), "HID %04x:%04x",
-			 le16_to_cpu(dev->descriptor.idVendor),
-			 le16_to_cpu(dev->descriptor.idProduct));
-
 	for (n = 0; n < interface->desc.bNumEndpoints; n++) {
-
 		struct usb_endpoint_descriptor *endpoint;
 		int pipe;
 		int interval;
@@ -837,7 +905,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 		interval = endpoint->bInterval;
 
 		/* Some vendors give fullspeed interval on highspeed devides */
-		if (quirks & HID_QUIRK_FULLSPEED_INTERVAL  &&
+		if (hid->quirks & HID_QUIRK_FULLSPEED_INTERVAL &&
 		    dev->speed == USB_SPEED_HIGH) {
 			interval = fls(endpoint->bInterval*8);
 			printk(KERN_INFO "%s: Fixing fullspeed to highspeed interval: %d -> %d\n",
@@ -848,6 +916,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 		if (hid->collection->usage == HID_GD_MOUSE && hid_mousepoll_interval > 0)
 			interval = hid_mousepoll_interval;
 
+		ret = -ENOMEM;
 		if (usb_endpoint_dir_in(endpoint)) {
 			if (usbhid->urbin)
 				continue;
@@ -873,6 +942,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 
 	if (!usbhid->urbin) {
 		err_hid("couldn't find an input interrupt endpoint");
+		ret = -ENODEV;
 		goto fail;
 	}
 
@@ -884,44 +954,26 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 	spin_lock_init(&usbhid->outlock);
 	spin_lock_init(&usbhid->ctrllock);
 
-	hid->version = le16_to_cpu(hdesc->bcdHID);
-	hid->country = hdesc->bCountryCode;
-	hid->dev.parent = &intf->dev;
 	usbhid->intf = intf;
 	usbhid->ifnum = interface->desc.bInterfaceNumber;
 
-	hid->bus = BUS_USB;
-	hid->vendor = le16_to_cpu(dev->descriptor.idVendor);
-	hid->product = le16_to_cpu(dev->descriptor.idProduct);
-
-	usb_make_path(dev, hid->phys, sizeof(hid->phys));
-	strlcat(hid->phys, "/input", sizeof(hid->phys));
-	len = strlen(hid->phys);
-	if (len < sizeof(hid->phys) - 1)
-		snprintf(hid->phys + len, sizeof(hid->phys) - len,
-			 "%d", intf->altsetting[0].desc.bInterfaceNumber);
-
-	if (usb_string(dev, dev->descriptor.iSerialNumber, hid->uniq, 64) <= 0)
-		hid->uniq[0] = 0;
-
 	usbhid->urbctrl = usb_alloc_urb(0, GFP_KERNEL);
-	if (!usbhid->urbctrl)
+	if (!usbhid->urbctrl) {
+		ret = -ENOMEM;
 		goto fail;
+	}
 
 	usb_fill_control_urb(usbhid->urbctrl, dev, 0, (void *) usbhid->cr,
 			     usbhid->ctrlbuf, 1, hid_ctrl, hid);
 	usbhid->urbctrl->setup_dma = usbhid->cr_dma;
 	usbhid->urbctrl->transfer_dma = usbhid->ctrlbuf_dma;
 	usbhid->urbctrl->transfer_flags |= (URB_NO_TRANSFER_DMA_MAP | URB_NO_SETUP_DMA_MAP);
-	hid->hidinput_input_event = usb_hidinput_input_event;
-	hid->hid_open = usbhid_open;
-	hid->hid_close = usbhid_close;
-#ifdef CONFIG_USB_HIDDEV
-	hid->hiddev_hid_event = hiddev_hid_event;
-	hid->hiddev_report_event = hiddev_report_event;
-#endif
-	hid->hid_output_raw_report = usbhid_output_raw_report;
-	return hid;
+
+	ret = usbhid_start_finish(hid);
+	if (ret)
+		goto fail;
+
+	return 0;
 
 fail:
 	usb_free_urb(usbhid->urbin);
@@ -929,24 +981,18 @@ fail:
 	usb_free_urb(usbhid->urbctrl);
 	hid_free_buffers(dev, hid);
 	kfree(usbhid);
-fail_no_usbhid:
-	hid_destroy_device(hid);
-
-	return NULL;
+err:
+	return ret;
 }
 
-static void hid_disconnect(struct usb_interface *intf)
+static void usbhid_stop(struct hid_device *hid)
 {
-	struct hid_device *hid = usb_get_intfdata (intf);
-	struct usbhid_device *usbhid;
+	struct usbhid_device *usbhid = hid->driver_data;
 
-	if (!hid)
+	if (WARN_ON(!usbhid))
 		return;
 
-	usbhid = hid->driver_data;
-
 	spin_lock_irq(&usbhid->inlock);	/* Sync with error handler */
-	usb_set_intfdata(intf, NULL);
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
 	spin_unlock_irq(&usbhid->inlock);
 	usb_kill_urb(usbhid->urbin);
@@ -963,93 +1009,99 @@ static void hid_disconnect(struct usb_interface *intf)
 	if (hid->claimed & HID_CLAIMED_HIDRAW)
 		hidraw_disconnect(hid);
 
+	hid->claimed = 0;
+
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbctrl);
 	usb_free_urb(usbhid->urbout);
 
 	hid_free_buffers(hid_to_usb_dev(hid), hid);
 	kfree(usbhid);
-	hid_destroy_device(hid);
+	hid->driver_data = NULL;
 }
 
+static struct hid_ll_driver usb_hid_driver = {
+	.parse = usbhid_parse,
+	.start = usbhid_start,
+	.stop = usbhid_stop,
+	.open = usbhid_open,
+	.close = usbhid_close,
+	.hidinput_input_event = usb_hidinput_input_event,
+};
+
 static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
+	struct usb_device *dev = interface_to_usbdev(intf);
 	struct hid_device *hid;
-	char path[64];
-	int i, ret;
-	char *c;
+	size_t len;
+	int ret;
 
 	dbg_hid("HID probe called for ifnum %d\n",
 			intf->altsetting->desc.bInterfaceNumber);
 
-	if (!(hid = usb_hid_configure(intf)))
-		return -ENODEV;
-
-	usbhid_init_reports(hid);
-	hid_dump_device(hid);
-	if (hid->quirks & HID_QUIRK_RESET_LEDS)
-		usbhid_set_leds(hid);
-
-	if (!hidinput_connect(hid))
-		hid->claimed |= HID_CLAIMED_INPUT;
-	if (!hiddev_connect(hid))
-		hid->claimed |= HID_CLAIMED_HIDDEV;
-	if (!hidraw_connect(hid))
-		hid->claimed |= HID_CLAIMED_HIDRAW;
+	hid = hid_allocate_device();
+	if (IS_ERR(hid))
+		return PTR_ERR(hid);
 
 	usb_set_intfdata(intf, hid);
+	hid->ll_driver = &usb_hid_driver;
+	hid->hid_output_raw_report = usbhid_output_raw_report;
+#ifdef CONFIG_USB_HIDDEV
+	hid->hiddev_hid_event = hiddev_hid_event;
+	hid->hiddev_report_event = hiddev_report_event;
+#endif
+	hid->dev.parent = &intf->dev;
+	hid->bus = BUS_USB;
+	hid->vendor = le16_to_cpu(dev->descriptor.idVendor);
+	hid->product = le16_to_cpu(dev->descriptor.idProduct);
+	hid->name[0] = 0;
 
-	if (!hid->claimed) {
-		printk ("HID device claimed by neither input, hiddev nor hidraw\n");
-		hid_disconnect(intf);
-		return -ENODEV;
-	}
-
-	if ((hid->claimed & HID_CLAIMED_INPUT))
-		hid_ff_init(hid);
-
-	if (hid->quirks & HID_QUIRK_SONY_PS3_CONTROLLER)
-		hid_fixup_sony_ps3_controller(interface_to_usbdev(intf),
-			intf->cur_altsetting->desc.bInterfaceNumber);
-
-	printk(KERN_INFO);
-
-	if (hid->claimed & HID_CLAIMED_INPUT)
-		printk("input");
-	if ((hid->claimed & HID_CLAIMED_INPUT) && ((hid->claimed & HID_CLAIMED_HIDDEV) ||
-				hid->claimed & HID_CLAIMED_HIDRAW))
-		printk(",");
-	if (hid->claimed & HID_CLAIMED_HIDDEV)
-		printk("hiddev%d", hid->minor);
-	if ((hid->claimed & HID_CLAIMED_INPUT) && (hid->claimed & HID_CLAIMED_HIDDEV) &&
-			(hid->claimed & HID_CLAIMED_HIDRAW))
-		printk(",");
-	if (hid->claimed & HID_CLAIMED_HIDRAW)
-		printk("hidraw%d", ((struct hidraw*)hid->hidraw)->minor);
+	if (dev->manufacturer)
+		strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
 
-	c = "Device";
-	for (i = 0; i < hid->maxcollection; i++) {
-		if (hid->collection[i].type == HID_COLLECTION_APPLICATION &&
-		    (hid->collection[i].usage & HID_USAGE_PAGE) == HID_UP_GENDESK &&
-		    (hid->collection[i].usage & 0xffff) < ARRAY_SIZE(hid_types)) {
-			c = hid_types[hid->collection[i].usage & 0xffff];
-			break;
-		}
+	if (dev->product) {
+		if (dev->manufacturer)
+			strlcat(hid->name, " ", sizeof(hid->name));
+		strlcat(hid->name, dev->product, sizeof(hid->name));
 	}
 
-	usb_make_path(interface_to_usbdev(intf), path, 63);
+	if (!strlen(hid->name))
+		snprintf(hid->name, sizeof(hid->name), "HID %04x:%04x",
+			 le16_to_cpu(dev->descriptor.idVendor),
+			 le16_to_cpu(dev->descriptor.idProduct));
 
-	printk(": USB HID v%x.%02x %s [%s] on %s\n",
-		hid->version >> 8, hid->version & 0xff, c, hid->name, path);
+	usb_make_path(dev, hid->phys, sizeof(hid->phys));
+	strlcat(hid->phys, "/input", sizeof(hid->phys));
+	len = strlen(hid->phys);
+	if (len < sizeof(hid->phys) - 1)
+		snprintf(hid->phys + len, sizeof(hid->phys) - len,
+			 "%d", intf->altsetting[0].desc.bInterfaceNumber);
+
+	if (usb_string(dev, dev->descriptor.iSerialNumber, hid->uniq, 64) <= 0)
+		hid->uniq[0] = 0;
 
 	ret = hid_add_device(hid);
 	if (ret) {
 		dev_err(&intf->dev, "can't add hid device: %d\n", ret);
-		hid_disconnect(intf);
+		goto err;
 	}
+
+	return 0;
+err:
+	hid_destroy_device(hid);
 	return ret;
 }
 
+static void hid_disconnect(struct usb_interface *intf)
+{
+	struct hid_device *hid = usb_get_intfdata(intf);
+
+	if (WARN_ON(!hid))
+		return;
+
+	hid_destroy_device(hid);
+}
+
 static int hid_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct hid_device *hid = usb_get_intfdata (intf);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 1c25de1..bda2368 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -421,6 +421,7 @@ struct hid_control_fifo {
 #define HID_CLAIMED_HIDRAW	4
 
 #define HID_STAT_ADDED		1
+#define HID_STAT_PARSED		2
 
 #define HID_CTRL_RUNNING	1
 #define HID_OUT_RUNNING		2
@@ -437,6 +438,7 @@ struct hid_input {
 };
 
 struct hid_driver;
+struct hid_ll_driver;
 
 struct hid_device {							/* device report descriptor */
 	__u8 *rdesc;
@@ -454,6 +456,7 @@ struct hid_device {							/* device report descriptor */
 
 	struct device dev;						/* device */
 	struct hid_driver *driver;
+	struct hid_ll_driver *ll_driver;
 
 	unsigned int status;						/* see STAT flags above */
 	unsigned claimed;						/* Claimed by hidinput, hiddev? */
@@ -473,11 +476,6 @@ struct hid_device {							/* device report descriptor */
 
 	__s32 delayed_value;						/* For A4 Tech mice hwheel quirk */
 
-	/* device-specific function pointers */
-	int (*hidinput_input_event) (struct input_dev *, unsigned int, unsigned int, int);
-	int (*hid_open) (struct hid_device *);
-	void (*hid_close) (struct hid_device *);
-
 	/* hiddev event handler */
 	void (*hiddev_hid_event) (struct hid_device *, struct hid_field *field,
 				  struct hid_usage *, __s32);
@@ -562,6 +560,9 @@ struct hid_usage_id {
  * @raw_event: if report in report_table, this hook is called (NULL means nop)
  * @usage_table: on which events to call event (NULL means all)
  * @event: if usage in usage_table, this hook is called (NULL means nop)
+ * @report_fixup: called before report descriptor parsing (NULL means nop)
+ * @input_mapping: invoked on input registering before mapping an usage
+ * @input_mapped: invoked on input registering after mapping an usage
  */
 struct hid_driver {
 	char *name;
@@ -576,10 +577,43 @@ struct hid_driver {
 	const struct hid_usage_id *usage_table;
 	int (*event)(struct hid_device *hdev, struct hid_field *field,
 			struct hid_usage *usage, __s32 value);
+
+	void (*report_fixup)(struct hid_device *hdev, __u8 *buf,
+			unsigned int size);
+
+	int (*input_mapping)(struct hid_device *hdev,
+			struct hid_input *hidinput, struct hid_usage *usage,
+			unsigned long **bit, int *max);
+	void (*input_mapped)(struct hid_device *hdev,
+			struct hid_input *hidinput, struct hid_usage *usage,
+			unsigned long **bit, int *max);
 /* private: */
 	struct device_driver driver;
 };
 
+/**
+ * hid_ll_driver - low level driver callbacks
+ * @start: called on probe to start the device
+ * @stop: called on remove
+ * @open: called by input layer on open
+ * @close: called by input layer on close
+ * @hidinput_input_event: event input event (e.g. ff or leds)
+ * @parse: this method is called only once to parse the device data,
+ *	   shouldn't allocate anything to not leak memory
+ */
+struct hid_ll_driver {
+	int (*start)(struct hid_device *hdev);
+	void (*stop)(struct hid_device *hdev);
+
+	int (*open)(struct hid_device *hdev);
+	void (*close)(struct hid_device *hdev);
+
+	int (*hidinput_input_event) (struct input_dev *idev, unsigned int type,
+			unsigned int code, int value);
+
+	int (*parse)(struct hid_device *hdev);
+};
+
 /* Applications from HID Usage Tables 4/8/99 Version 1.1 */
 /* We ignore a few input applications that are not widely used */
 #define IS_INPUT_APPLICATION(a) (((a >= 0x00010000) && (a <= 0x00010008)) || (a == 0x00010080) || (a == 0x000c0001))
@@ -616,6 +650,56 @@ void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
 
+/**
+ * hid_parse - parse HW reports
+ *
+ * @hdev: hid device
+ *
+ * Call this from probe after you set up the device (if needed). Your
+ * report_fixup will be called (if non-NULL) after reading raw report from
+ * device before passing it to hid layer for real parsing.
+ */
+static inline int __must_check hid_parse(struct hid_device *hdev)
+{
+	int ret;
+
+	if (hdev->status & HID_STAT_PARSED)
+		return 0;
+
+	ret = hdev->ll_driver->parse(hdev);
+	if (!ret)
+		hdev->status |= HID_STAT_PARSED;
+
+	return ret;
+}
+
+/**
+ * hid_hw_start - start underlaying HW
+ *
+ * @hdev: hid device
+ *
+ * Call this in probe function *after* hid_parse. This will setup HW buffers
+ * and start the device (if not deffered to device open). hid_hw_stop must be
+ * called if this was successfull.
+ */
+static inline int __must_check hid_hw_start(struct hid_device *hdev)
+{
+	return hdev->ll_driver->start(hdev);
+}
+
+/**
+ * hid_hw_stop - stop underlaying HW
+ *
+ * @hdev: hid device
+ *
+ * This is usually called from remove function or from probe when something
+ * failed and hid_hw_start was called already.
+ */
+static inline void hid_hw_stop(struct hid_device *hdev)
+{
+	hdev->ll_driver->stop(hdev);
+}
+
 void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt);
 
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 5ba536b..2644f1a 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -617,9 +617,15 @@ static struct device *hidp_get_device(struct hidp_session *session)
 static int hidp_setup_input(struct hidp_session *session,
 				struct hidp_connadd_req *req)
 {
-	struct input_dev *input = session->input;
+	struct input_dev *input;
 	int i;
 
+	input = input_allocate_device();
+	if (!input)
+		return -ENOMEM;
+
+	session->input = input;
+
 	input_set_drvdata(input, session);
 
 	input->name = "Bluetooth HID Boot Protocol Device";
@@ -692,55 +698,117 @@ static void hidp_setup_quirks(struct hid_device *hid)
 			hid->quirks = hidp_blacklist[n].quirks;
 }
 
+static int hidp_parse(struct hid_device *hid)
+{
+	struct hidp_session *session = hid->driver_data;
+	struct hidp_connadd_req *req = session->req;
+	unsigned char *buf;
+	int ret;
+
+	buf = kmalloc(req->rd_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, req->rd_data, req->rd_size)) {
+		kfree(buf);
+		return -EFAULT;
+	}
+
+	ret = hid_parse_report(session->hid, buf, req->rd_size);
+
+	kfree(buf);
+
+	if (ret)
+		return ret;
+
+	session->req = NULL;
+
+	hidp_setup_quirks(hid);
+	return 0;
+}
+
+static int hidp_start(struct hid_device *hid)
+{
+	struct hidp_session *session = hid->driver_data;
+	struct hid_report *report;
+
+	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].
+			report_list, list)
+		hidp_send_report(session, report);
+
+	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].
+			report_list, list)
+		hidp_send_report(session, report);
+
+	if (hidinput_connect(hid) == 0)
+		hid->claimed |= HID_CLAIMED_INPUT;
+
+	return 0;
+}
+
+static void hidp_stop(struct hid_device *hid)
+{
+	struct hidp_session *session = hid->driver_data;
+
+	skb_queue_purge(&session->ctrl_transmit);
+	skb_queue_purge(&session->intr_transmit);
+
+	if (hid->claimed & HID_CLAIMED_INPUT)
+		hidinput_disconnect(hid);
+	hid->claimed = 0;
+}
+
+static struct hid_ll_driver hidp_hid_driver = {
+	.parse = hidp_parse,
+	.start = hidp_start,
+	.stop = hidp_stop,
+	.open  = hidp_open,
+	.close = hidp_close,
+	.hidinput_input_event = hidp_hidinput_event,
+};
+
 static int hidp_setup_hid(struct hidp_session *session,
 				struct hidp_connadd_req *req)
 {
-	struct hid_device *hid = session->hid;
-	struct hid_report *report;
+	struct hid_device *hid;
 	bdaddr_t src, dst;
 	int ret;
 
-	baswap(&src, &bt_sk(session->ctrl_sock->sk)->src);
-	baswap(&dst, &bt_sk(session->ctrl_sock->sk)->dst);
+	hid = hid_allocate_device();
+	if (IS_ERR(hid)) {
+		ret = PTR_ERR(session->hid);
+		goto err;
+	}
 
+	session->hid = hid;
+	session->req = req;
 	hid->driver_data = session;
 
-	hid->country = req->country;
+	baswap(&src, &bt_sk(session->ctrl_sock->sk)->src);
+	baswap(&dst, &bt_sk(session->ctrl_sock->sk)->dst);
 
 	hid->bus     = BUS_BLUETOOTH;
 	hid->vendor  = req->vendor;
 	hid->product = req->product;
 	hid->version = req->version;
+	hid->country = req->country;
 
 	strncpy(hid->name, req->name, 128);
 	strncpy(hid->phys, batostr(&src), 64);
 	strncpy(hid->uniq, batostr(&dst), 64);
 
 	hid->dev.parent = hidp_get_device(session);
-
-	hid->hid_open  = hidp_open;
-	hid->hid_close = hidp_close;
-
-	hid->hidinput_input_event = hidp_hidinput_event;
-
-	hidp_setup_quirks(hid);
-
-	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].report_list, list)
-		hidp_send_report(session, report);
-
-	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
-		hidp_send_report(session, report);
-
-	if (hidinput_connect(hid) == 0)
-		hid->claimed |= HID_CLAIMED_INPUT;
+	hid->ll_driver = &hidp_hid_driver;
 
 	ret = hid_add_device(hid);
-	if (ret) {
-		if (hid->claimed & HID_CLAIMED_INPUT)
-			hidinput_disconnect(hid);
-		skb_queue_purge(&session->intr_transmit);
-	}
+	if (ret)
+		goto err_hid;
 
+	return 0;
+err_hid:
+	hid_destroy_device(hid);
+	session->hid = NULL;
+err:
 	return ret;
 }
 
@@ -761,46 +829,6 @@ int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock,
 
 	BT_DBG("rd_data %p rd_size %d", req->rd_data, req->rd_size);
 
-	if (req->rd_size > 0) {
-		unsigned char *buf = kmalloc(req->rd_size, GFP_KERNEL);
-
-		if (!buf) {
-			kfree(session);
-			return -ENOMEM;
-		}
-
-		if (copy_from_user(buf, req->rd_data, req->rd_size)) {
-			kfree(buf);
-			kfree(session);
-			return -EFAULT;
-		}
-
-		session->hid = hid_allocate_device();
-		if (IS_ERR(session->hid)) {
-			kfree(buf);
-			kfree(session);
-			return PTR_ERR(session->hid);
-		}
-
-		err = hid_parse_report(session->hid, buf, req->rd_size);
-
-		kfree(buf);
-
-		if (err) {
-			hid_destroy_device(session->hid);
-			kfree(session);
-			return -EINVAL;
-		}
-	}
-
-	if (!session->hid) {
-		session->input = input_allocate_device();
-		if (!session->input) {
-			kfree(session);
-			return -ENOMEM;
-		}
-	}
-
 	down_write(&hidp_session_sem);
 
 	s = __hidp_get_session(&bt_sk(ctrl_sock->sk)->dst);
@@ -828,16 +856,16 @@ int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock,
 	session->flags   = req->flags & (1 << HIDP_BLUETOOTH_VENDOR_ID);
 	session->idle_to = req->idle_to;
 
-	if (session->input) {
-		err = hidp_setup_input(session, req);
-		if (err < 0)
-			goto failed;
-	}
-
-	if (session->hid) {
+	if (req->rd_size > 0) {
 		err = hidp_setup_hid(session, req);
 		if (err)
-			goto failed;
+			goto err_skb;
+	}
+
+	if (!session->hid) {
+		err = hidp_setup_input(session, req);
+		if (err < 0)
+			goto err_skb;
 	}
 
 	__hidp_link_session(session);
@@ -865,16 +893,15 @@ unlink:
 
 	__hidp_unlink_session(session);
 
-	if (session->input) {
+	if (session->input)
 		input_unregister_device(session->input);
-		session->input = NULL; /* don't try to free it here */
-	}
-
-failed:
-	up_write(&hidp_session_sem);
-
 	if (session->hid)
 		hid_destroy_device(session->hid);
+err_skb:
+	skb_queue_purge(&session->ctrl_transmit);
+	skb_queue_purge(&session->intr_transmit);
+failed:
+	up_write(&hidp_session_sem);
 
 	input_free_device(session->input);
 	kfree(session);
diff --git a/net/bluetooth/hidp/hidp.h b/net/bluetooth/hidp/hidp.h
index 343fb05..e503c89 100644
--- a/net/bluetooth/hidp/hidp.h
+++ b/net/bluetooth/hidp/hidp.h
@@ -151,6 +151,8 @@ struct hidp_session {
 
 	struct sk_buff_head ctrl_transmit;
 	struct sk_buff_head intr_transmit;
+
+	struct hidp_connadd_req *req;
 };
 
 static inline void hidp_schedule(struct hidp_session *session)
-- 
1.5.4.5

