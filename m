Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbXGBWfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbXGBWfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXGBWfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:35:33 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61365 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXGBWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:35:30 -0400
Date: Mon, 02 Jul 2007 15:36:37 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/4] usb: allocated usb releated dma buffer with kmalloc_node
In-reply-to: <200706291326.43563.yinghai.lu@sun.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707021536.37814.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/4] usb: allocated usb releated dma buffer with kmalloc_node

For amd64 based two way system. USB always on node0. but dma buffer for urb
allocated via kmalloc always get ram on node1. So change to kmalloc_node to
get dma_buffer on corresponding node

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index dd34823..0454f29 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -504,7 +504,7 @@ int usb_get_configuration(struct usb_device *dev)
 	if (!dev->rawdescriptors)
 		goto err2;
 
-	buffer = kmalloc(USB_DT_CONFIG_SIZE, GFP_KERNEL);
+	buffer = kmalloc_node(USB_DT_CONFIG_SIZE, GFP_KERNEL, dev_to_node(&dev->dev));
 	if (!buffer)
 		goto err2;
 	desc = (struct usb_config_descriptor *)buffer;
@@ -531,7 +531,7 @@ int usb_get_configuration(struct usb_device *dev)
 		    USB_DT_CONFIG_SIZE);
 
 		/* Now that we know the length, get the whole thing */
-		bigbuffer = kmalloc(length, GFP_KERNEL);
+		bigbuffer = kmalloc_node(length, GFP_KERNEL, dev_to_node(&dev->dev));
 		if (!bigbuffer) {
 			result = -ENOMEM;
 			goto err;
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 927a181..60cefbb 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -718,7 +718,7 @@ static int proc_bulk(struct dev_state *ps, void __user *arg)
 	len1 = bulk.len;
 	if (len1 > MAX_USBFS_BUFFER_SIZE)
 		return -EINVAL;
-	if (!(tbuf = kmalloc(len1, GFP_KERNEL)))
+	if (!(tbuf = kmalloc_node(len1, GFP_KERNEL, dev_to_node(&dev->dev))))
 		return -ENOMEM;
 	tmo = bulk.timeout;
 	if (bulk.ep & 0x80) {
@@ -938,7 +938,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		/* min 8 byte setup packet, max 8 byte setup plus an arbitrary data stage */
 		if (uurb->buffer_length < 8 || uurb->buffer_length > (8 + MAX_USBFS_BUFFER_SIZE))
 			return -EINVAL;
-		if (!(dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_KERNEL)))
+		if (!(dr = kmalloc_node(sizeof(struct usb_ctrlrequest), GFP_KERNEL, dev_to_node(&ps->dev->dev))))
 			return -ENOMEM;
 		if (copy_from_user(dr, uurb->buffer, 8)) {
 			kfree(dr);
@@ -990,7 +990,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 				!= USB_ENDPOINT_XFER_ISOC)
 			return -EINVAL;
 		isofrmlen = sizeof(struct usbdevfs_iso_packet_desc) * uurb->number_of_packets;
-		if (!(isopkt = kmalloc(isofrmlen, GFP_KERNEL)))
+		if (!(isopkt = kmalloc_node(isofrmlen, GFP_KERNEL, dev_to_node(&ps->dev->dev))))
 			return -ENOMEM;
 		if (copy_from_user(isopkt, iso_frame_desc, isofrmlen)) {
 			kfree(isopkt);
@@ -1032,7 +1032,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		kfree(dr);
 		return -ENOMEM;
 	}
-	if (!(as->urb->transfer_buffer = kmalloc(uurb->buffer_length, GFP_KERNEL))) {
+	if (!(as->urb->transfer_buffer = kmalloc_node(uurb->buffer_length, GFP_KERNEL, dev_to_node(&ps->dev->dev)))) {
 		kfree(isopkt);
 		kfree(dr);
 		free_async(as);
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 24f10a1..3e63161 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -449,7 +449,7 @@ void usb_hub_tt_clear_buffer (struct usb_device *udev, int pipe)
 	 * since each TT has "at least two" buffers that can need it (and
 	 * there can be many TTs per hub).  even if they're uncommon.
 	 */
-	if ((clear = kmalloc (sizeof *clear, GFP_ATOMIC)) == NULL) {
+	if ((clear = kmalloc_node(sizeof *clear, GFP_ATOMIC, dev_to_node(&udev->dev))) == NULL) {
 		dev_err (&udev->dev, "can't save CLEAR_TT_BUFFER state\n");
 		/* FIXME recover somehow ... RESET_TT? */
 		return;
@@ -611,7 +611,7 @@ static int hub_configure(struct usb_hub *hub,
 		goto fail;
 	}
 
-	hub->status = kmalloc(sizeof(*hub->status), GFP_KERNEL);
+	hub->status = kmalloc_node(sizeof(*hub->status), GFP_KERNEL, dev_to_node(&hdev->dev));
 	if (!hub->status) {
 		message = "can't kmalloc hub status buffer";
 		ret = -ENOMEM;
@@ -619,7 +619,7 @@ static int hub_configure(struct usb_hub *hub,
 	}
 	mutex_init(&hub->status_mutex);
 
-	hub->descriptor = kmalloc(sizeof(*hub->descriptor), GFP_KERNEL);
+	hub->descriptor = kmalloc_node(sizeof(*hub->descriptor), GFP_KERNEL, dev_to_node(&hdev->dev));
 	if (!hub->descriptor) {
 		message = "can't kmalloc hub descriptor";
 		ret = -ENOMEM;
@@ -2213,7 +2213,7 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 			int r = 0;
 
 #define GET_DESCRIPTOR_BUFSIZE	64
-			buf = kmalloc(GET_DESCRIPTOR_BUFSIZE, GFP_NOIO);
+			buf = kmalloc_node(GET_DESCRIPTOR_BUFSIZE, GFP_NOIO, dev_to_node(&udev->dev));
 			if (!buf) {
 				retval = -ENOMEM;
 				continue;
@@ -2343,7 +2343,7 @@ check_highspeed (struct usb_hub *hub, struct usb_device *udev, int port1)
 	struct usb_qualifier_descriptor	*qual;
 	int				status;
 
-	qual = kmalloc (sizeof *qual, GFP_KERNEL);
+	qual = kmalloc_node(sizeof *qual, GFP_KERNEL, dev_to_node(&udev->dev));
 	if (qual == NULL)
 		return;
 
@@ -2894,7 +2894,7 @@ static int config_descriptors_changed(struct usb_device *udev)
 		if (len < le16_to_cpu(udev->config[index].desc.wTotalLength))
 			len = le16_to_cpu(udev->config[index].desc.wTotalLength);
 	}
-	buf = kmalloc (len, GFP_KERNEL);
+	buf = kmalloc_node(len, GFP_KERNEL, dev_to_node(&udev->dev));
 	if (buf == NULL) {
 		dev_err(&udev->dev, "no mem to re-read configs after reset\n");
 		/* assume the worst */
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index f9fed34..1f299e0 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -120,7 +120,7 @@ static int usb_internal_control_msg(struct usb_device *usb_dev,
 int usb_control_msg(struct usb_device *dev, unsigned int pipe, __u8 request, __u8 requesttype,
 			 __u16 value, __u16 index, void *data, __u16 size, int timeout)
 {
-	struct usb_ctrlrequest *dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+	struct usb_ctrlrequest *dr = kmalloc_node(sizeof(struct usb_ctrlrequest), GFP_NOIO, dev_to_node(&dev->dev));
 	int ret;
 	
 	if (!dr)
@@ -765,7 +765,7 @@ int usb_string(struct usb_device *dev, int index, char *buf, size_t size)
 	if (size <= 0 || !buf || !index)
 		return -EINVAL;
 	buf[0] = 0;
-	tbuf = kmalloc(256, GFP_KERNEL);
+	tbuf = kmalloc_node(256, GFP_KERNEL, dev_to_node(&dev->dev));
 	if (!tbuf)
 		return -ENOMEM;
 
@@ -828,9 +828,9 @@ char *usb_cache_string(struct usb_device *udev, int index)
 	char *smallbuf = NULL;
 	int len;
 
-	if (index > 0 && (buf = kmalloc(256, GFP_KERNEL)) != NULL) {
+	if (index > 0 && (buf = kmalloc_node(256, GFP_KERNEL, dev_to_node(&udev->dev))) != NULL) {
 		if ((len = usb_string(udev, index, buf, 256)) > 0) {
-			if ((smallbuf = kmalloc(++len, GFP_KERNEL)) == NULL)
+			if ((smallbuf = kmalloc_node(++len, GFP_KERNEL, dev_to_node(&udev->dev))) == NULL)
 				return buf;
 			memcpy(smallbuf, buf, len);
 		}
@@ -864,7 +864,7 @@ int usb_get_device_descriptor(struct usb_device *dev, unsigned int size)
 
 	if (size > sizeof(*desc))
 		return -EINVAL;
-	desc = kmalloc(sizeof(*desc), GFP_NOIO);
+	desc = kmalloc_node(sizeof(*desc), GFP_NOIO, dev_to_node(&dev->dev));
 	if (!desc)
 		return -ENOMEM;
 
@@ -900,7 +900,7 @@ int usb_get_device_descriptor(struct usb_device *dev, unsigned int size)
 int usb_get_status(struct usb_device *dev, int type, int target, void *data)
 {
 	int ret;
-	u16 *status = kmalloc(sizeof(*status), GFP_KERNEL);
+	u16 *status = kmalloc_node(sizeof(*status), GFP_KERNEL, dev_to_node(&dev->dev));
 
 	if (!status)
 		return -ENOMEM;
@@ -1630,7 +1630,7 @@ int usb_driver_set_configuration(struct usb_device *udev, int config)
 {
 	struct set_config_request *req;
 
-	req = kmalloc(sizeof(*req), GFP_KERNEL);
+	req = kmalloc_node(sizeof(*req), GFP_KERNEL, dev_to_node(&udev->dev));
 	if (!req)
 		return -ENOMEM;
 	req->udev = udev;
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 8e898e3..007aaf9 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -470,7 +470,7 @@ static int associate_dev(struct us_data *us, struct usb_interface *intf)
 		return -ENOMEM;
 	}
 
-	us->sensebuf = kmalloc(US_SENSE_SIZE, GFP_KERNEL);
+	us->sensebuf = kmalloc_node(US_SENSE_SIZE, GFP_KERNEL, dev_to_node(&us->pusb_dev->dev));
 	if (!us->sensebuf) {
 		US_DEBUGP("Sense buffer allocation failed\n");
 		return -ENOMEM;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index d91b9da..3d25ae1 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -759,7 +759,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 		return NULL;
 	}
 
-	if (!(rdesc = kmalloc(rsize, GFP_KERNEL))) {
+	if (!(rdesc = kmalloc_node(rsize, GFP_KERNEL, dev_to_node(&dev->dev)))) {
 		dbg("couldn't allocate rdesc memory");
 		return NULL;
 	}
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 488d61b..74e67bb 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -476,7 +476,7 @@ static int hiddev_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 			if (get_user(idx, (int __user *)arg))
 				return -EFAULT;
 
-			if ((buf = kmalloc(HID_STRING_SIZE, GFP_KERNEL)) == NULL)
+			if ((buf = kmalloc_node(HID_STRING_SIZE, GFP_KERNEL, dev_to_node(&dev->dev))) == NULL)
 				return -ENOMEM;
 
 			if ((len = usb_string(dev, idx, buf, HID_STRING_SIZE-1)) < 0) {
