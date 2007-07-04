Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbXGDAe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbXGDAe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 20:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXGDAd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 20:33:56 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49247 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbXGDAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 20:33:50 -0400
Date: Tue, 03 Jul 2007 17:35:46 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 4/4] usb: allocated usb releated dma buffer with kmalloc_node
In-reply-to: <20070703051129.GA18420@kroah.com>
To: Greg KH <greg@kroah.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707031735.47190.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
 <200707021536.37814.yinghai.lu@sun.com> <20070703051129.GA18420@kroah.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 4/4] usb: allocated usb releated dma buffer with kmalloc_node

For amd64 based two way system. USB always on node0. but dma buffer for urb
allocated via kmalloc always get ram on node1. So change to kmalloc_node to
get dma_buffer on corresponding node.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index dd34823..604a262 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -504,7 +504,8 @@ int usb_get_configuration(struct usb_device *dev)
 	if (!dev->rawdescriptors)
 		goto err2;
 
-	buffer = kmalloc(USB_DT_CONFIG_SIZE, GFP_KERNEL);
+	buffer = kmalloc_node(USB_DT_CONFIG_SIZE, GFP_KERNEL,
+			      dev_to_node(&dev->dev));
 	if (!buffer)
 		goto err2;
 	desc = (struct usb_config_descriptor *)buffer;
@@ -531,7 +532,8 @@ int usb_get_configuration(struct usb_device *dev)
 		    USB_DT_CONFIG_SIZE);
 
 		/* Now that we know the length, get the whole thing */
-		bigbuffer = kmalloc(length, GFP_KERNEL);
+		bigbuffer = kmalloc_node(length, GFP_KERNEL,
+					 dev_to_node(&dev->dev));
 		if (!bigbuffer) {
 			result = -ENOMEM;
 			goto err;
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 927a181..99dc0c3 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -718,7 +718,8 @@ static int proc_bulk(struct dev_state *ps, void __user *arg)
 	len1 = bulk.len;
 	if (len1 > MAX_USBFS_BUFFER_SIZE)
 		return -EINVAL;
-	if (!(tbuf = kmalloc(len1, GFP_KERNEL)))
+	tbuf = kmalloc_node(len1, GFP_KERNEL, dev_to_node(&dev->dev));
+	if (!tbuf)
 		return -ENOMEM;
 	tmo = bulk.timeout;
 	if (bulk.ep & 0x80) {
@@ -938,7 +939,9 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		/* min 8 byte setup packet, max 8 byte setup plus an arbitrary data stage */
 		if (uurb->buffer_length < 8 || uurb->buffer_length > (8 + MAX_USBFS_BUFFER_SIZE))
 			return -EINVAL;
-		if (!(dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_KERNEL)))
+		dr = kmalloc_node(sizeof(struct usb_ctrlrequest), GFP_KERNEL,
+				  dev_to_node(&ps->dev->dev));
+		if (!dr)
 			return -ENOMEM;
 		if (copy_from_user(dr, uurb->buffer, 8)) {
 			kfree(dr);
@@ -990,7 +993,9 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 				!= USB_ENDPOINT_XFER_ISOC)
 			return -EINVAL;
 		isofrmlen = sizeof(struct usbdevfs_iso_packet_desc) * uurb->number_of_packets;
-		if (!(isopkt = kmalloc(isofrmlen, GFP_KERNEL)))
+		isopkt = kmalloc_node(isofrmlen, GFP_KERNEL,
+				      dev_to_node(&ps->dev->dev));
+		if (!isopkt)
 			return -ENOMEM;
 		if (copy_from_user(isopkt, iso_frame_desc, isofrmlen)) {
 			kfree(isopkt);
@@ -1032,7 +1037,9 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		kfree(dr);
 		return -ENOMEM;
 	}
-	if (!(as->urb->transfer_buffer = kmalloc(uurb->buffer_length, GFP_KERNEL))) {
+	as->urb->transfer_buffer = kmalloc_node(uurb->buffer_length,
+				     GFP_KERNEL, dev_to_node(&ps->dev->dev));
+	if (!as->urb->transfer_buffer) {
 		kfree(isopkt);
 		kfree(dr);
 		free_async(as);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 24f10a1..ec49ce5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -449,7 +449,9 @@ void usb_hub_tt_clear_buffer (struct usb_device *udev, int pipe)
 	 * since each TT has "at least two" buffers that can need it (and
 	 * there can be many TTs per hub).  even if they're uncommon.
 	 */
-	if ((clear = kmalloc (sizeof *clear, GFP_ATOMIC)) == NULL) {
+	clear = kmalloc_node(sizeof *clear, GFP_ATOMIC,
+			     dev_to_node(&udev->dev));
+	if (clear == NULL) {
 		dev_err (&udev->dev, "can't save CLEAR_TT_BUFFER state\n");
 		/* FIXME recover somehow ... RESET_TT? */
 		return;
@@ -611,7 +613,8 @@ static int hub_configure(struct usb_hub *hub,
 		goto fail;
 	}
 
-	hub->status = kmalloc(sizeof(*hub->status), GFP_KERNEL);
+	hub->status = kmalloc_node(sizeof(*hub->status), GFP_KERNEL,
+				   dev_to_node(&hdev->dev));
 	if (!hub->status) {
 		message = "can't kmalloc hub status buffer";
 		ret = -ENOMEM;
@@ -619,7 +622,8 @@ static int hub_configure(struct usb_hub *hub,
 	}
 	mutex_init(&hub->status_mutex);
 
-	hub->descriptor = kmalloc(sizeof(*hub->descriptor), GFP_KERNEL);
+	hub->descriptor = kmalloc_node(sizeof(*hub->descriptor), GFP_KERNEL,
+				       dev_to_node(&hdev->dev));
 	if (!hub->descriptor) {
 		message = "can't kmalloc hub descriptor";
 		ret = -ENOMEM;
@@ -2213,7 +2217,8 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 			int r = 0;
 
 #define GET_DESCRIPTOR_BUFSIZE	64
-			buf = kmalloc(GET_DESCRIPTOR_BUFSIZE, GFP_NOIO);
+			buf = kmalloc_node(GET_DESCRIPTOR_BUFSIZE, GFP_NOIO,
+					   dev_to_node(&udev->dev));
 			if (!buf) {
 				retval = -ENOMEM;
 				continue;
@@ -2343,7 +2348,7 @@ check_highspeed (struct usb_hub *hub, struct usb_device *udev, int port1)
 	struct usb_qualifier_descriptor	*qual;
 	int				status;
 
-	qual = kmalloc (sizeof *qual, GFP_KERNEL);
+	qual = kmalloc_node(sizeof *qual, GFP_KERNEL, dev_to_node(&udev->dev));
 	if (qual == NULL)
 		return;
 
@@ -2894,7 +2899,7 @@ static int config_descriptors_changed(struct usb_device *udev)
 		if (len < le16_to_cpu(udev->config[index].desc.wTotalLength))
 			len = le16_to_cpu(udev->config[index].desc.wTotalLength);
 	}
-	buf = kmalloc (len, GFP_KERNEL);
+	buf = kmalloc_node(len, GFP_KERNEL, dev_to_node(&udev->dev));
 	if (buf == NULL) {
 		dev_err(&udev->dev, "no mem to re-read configs after reset\n");
 		/* assume the worst */
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index f9fed34..6687807 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -120,9 +120,11 @@ static int usb_internal_control_msg(struct usb_device *usb_dev,
 int usb_control_msg(struct usb_device *dev, unsigned int pipe, __u8 request, __u8 requesttype,
 			 __u16 value, __u16 index, void *data, __u16 size, int timeout)
 {
-	struct usb_ctrlrequest *dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+	struct usb_ctrlrequest *dr;
 	int ret;
-	
+
+	dr = kmalloc_node(sizeof(struct usb_ctrlrequest), GFP_NOIO,
+			  dev_to_node(&dev->dev));
 	if (!dr)
 		return -ENOMEM;
 
@@ -765,7 +767,7 @@ int usb_string(struct usb_device *dev, int index, char *buf, size_t size)
 	if (size <= 0 || !buf || !index)
 		return -EINVAL;
 	buf[0] = 0;
-	tbuf = kmalloc(256, GFP_KERNEL);
+	tbuf = kmalloc_node(256, GFP_KERNEL, dev_to_node(&dev->dev));
 	if (!tbuf)
 		return -ENOMEM;
 
@@ -828,13 +830,19 @@ char *usb_cache_string(struct usb_device *udev, int index)
 	char *smallbuf = NULL;
 	int len;
 
-	if (index > 0 && (buf = kmalloc(256, GFP_KERNEL)) != NULL) {
-		if ((len = usb_string(udev, index, buf, 256)) > 0) {
-			if ((smallbuf = kmalloc(++len, GFP_KERNEL)) == NULL)
-				return buf;
-			memcpy(smallbuf, buf, len);
+	if (index > 0) {
+		buf = kmalloc_node(256, GFP_KERNEL, dev_to_node(&udev->dev));
+		if (buf != NULL) {
+			len = usb_string(udev, index, buf, 256);
+			if (len > 0) {
+				smallbuf = kmalloc_node(++len, GFP_KERNEL,
+						 dev_to_node(&udev->dev));
+				if (smallbuf == NULL)
+					return buf;
+				memcpy(smallbuf, buf, len);
+			}
+			kfree(buf);
 		}
-		kfree(buf);
 	}
 	return smallbuf;
 }
@@ -864,7 +872,7 @@ int usb_get_device_descriptor(struct usb_device *dev, unsigned int size)
 
 	if (size > sizeof(*desc))
 		return -EINVAL;
-	desc = kmalloc(sizeof(*desc), GFP_NOIO);
+	desc = kmalloc_node(sizeof(*desc), GFP_NOIO, dev_to_node(&dev->dev));
 	if (!desc)
 		return -ENOMEM;
 
@@ -900,7 +908,8 @@ int usb_get_device_descriptor(struct usb_device *dev, unsigned int size)
 int usb_get_status(struct usb_device *dev, int type, int target, void *data)
 {
 	int ret;
-	u16 *status = kmalloc(sizeof(*status), GFP_KERNEL);
+	u16 *status = kmalloc_node(sizeof(*status), GFP_KERNEL,
+				   dev_to_node(&dev->dev));
 
 	if (!status)
 		return -ENOMEM;
@@ -1630,7 +1639,7 @@ int usb_driver_set_configuration(struct usb_device *udev, int config)
 {
 	struct set_config_request *req;
 
-	req = kmalloc(sizeof(*req), GFP_KERNEL);
+	req = kmalloc_node(sizeof(*req), GFP_KERNEL, dev_to_node(&udev->dev));
 	if (!req)
 		return -ENOMEM;
 	req->udev = udev;
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 8e898e3..52a37a8 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -470,7 +470,8 @@ static int associate_dev(struct us_data *us, struct usb_interface *intf)
 		return -ENOMEM;
 	}
 
-	us->sensebuf = kmalloc(US_SENSE_SIZE, GFP_KERNEL);
+	us->sensebuf = kmalloc_node(US_SENSE_SIZE, GFP_KERNEL,
+				dev_to_node(&us->pusb_dev->dev));
 	if (!us->sensebuf) {
 		US_DEBUGP("Sense buffer allocation failed\n");
 		return -ENOMEM;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index d91b9da..ffa84d0 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -759,7 +759,8 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 		return NULL;
 	}
 
-	if (!(rdesc = kmalloc(rsize, GFP_KERNEL))) {
+	rdesc = kmalloc_node(rsize, GFP_KERNEL, dev_to_node(&dev->dev));
+	if (!rdesc) {
 		dbg("couldn't allocate rdesc memory");
 		return NULL;
 	}
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 488d61b..e2a7165 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -476,7 +476,9 @@ static int hiddev_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 			if (get_user(idx, (int __user *)arg))
 				return -EFAULT;
 
-			if ((buf = kmalloc(HID_STRING_SIZE, GFP_KERNEL)) == NULL)
+			buf = kmalloc_node(HID_STRING_SIZE, GFP_KERNEL,
+					   dev_to_node(&dev->dev));
+			if (buf == NULL)
 				return -ENOMEM;
 
 			if ((len = usb_string(dev, idx, buf, HID_STRING_SIZE-1)) < 0) {
