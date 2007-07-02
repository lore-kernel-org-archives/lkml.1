Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXGBWfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXGBWfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXGBWfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:35:31 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61366 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbXGBWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:35:30 -0400
Date: Mon, 02 Jul 2007 15:37:13 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node
In-reply-to: <200706291326.43563.yinghai.lu@sun.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707021537.13840.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 4/4] net: add usb_alloc_urb_node to use use kmalloc_node

For amd64 based two way system. USB always on node0. but urb allocated via
kmalloc always get ram on node1. So change to kmalloc_node to get urb on
corresponding node

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 24f10a1..ae21c69 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -818,7 +818,7 @@ static int hub_configure(struct usb_hub *hub,
 	if (maxp > sizeof(*hub->buffer))
 		maxp = sizeof(*hub->buffer);
 
-	hub->urb = usb_alloc_urb(0, GFP_KERNEL);
+	hub->urb = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&hdev->dev));
 	if (!hub->urb) {
 		message = "couldn't allocate interrupt urb";
 		ret = -ENOMEM;
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index f9fed34..c432b0e 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -77,7 +77,7 @@ static int usb_internal_control_msg(struct usb_device *usb_dev,
 	int retv;
 	int length;
 
-	urb = usb_alloc_urb(0, GFP_NOIO);
+	urb = usb_alloc_urb_node(0, GFP_NOIO, dev_to_node(&usb_dev->dev));
 	if (!urb)
 		return -ENOMEM;
   
@@ -215,7 +215,7 @@ int usb_bulk_msg(struct usb_device *usb_dev, unsigned int pipe,
 	if (!ep || len < 0)
 		return -EINVAL;
 
-	urb = usb_alloc_urb(0, GFP_KERNEL);
+	urb = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&usb_dev->dev));
 	if (!urb)
 		return -ENOMEM;
 
@@ -391,7 +391,7 @@ int usb_sg_init (
 	for (i = 0; i < io->entries; i++) {
 		unsigned		len;
 
-		io->urbs [i] = usb_alloc_urb (0, mem_flags);
+		io->urbs [i] = usb_alloc_urb_node(0, mem_flags, dev_to_node(&dev->dev));
 		if (!io->urbs [i]) {
 			io->entries = i;
 			goto nomem;
diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 94ea972..8e11ef1 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -53,13 +53,13 @@ void usb_init_urb(struct urb *urb)
  *
  * The driver must call usb_free_urb() when it is finished with the urb.
  */
-struct urb *usb_alloc_urb(int iso_packets, gfp_t mem_flags)
+struct urb *usb_alloc_urb_node(int iso_packets, gfp_t mem_flags, int node)
 {
 	struct urb *urb;
 
-	urb = kmalloc(sizeof(struct urb) +
+	urb = kmalloc_node(sizeof(struct urb) +
 		iso_packets * sizeof(struct usb_iso_packet_descriptor),
-		mem_flags);
+		mem_flags, node);
 	if (!urb) {
 		err("alloc_urb: kmalloc failed");
 		return NULL;
@@ -67,6 +67,10 @@ struct urb *usb_alloc_urb(int iso_packets, gfp_t mem_flags)
 	usb_init_urb(urb);
 	return urb;
 }
+struct urb *usb_alloc_urb(int iso_packets, gfp_t mem_flags)
+{
+	return usb_alloc_urb_node(iso_packets, mem_flags, -1);
+}
 
 /**
  * usb_free_urb - frees the memory used by a urb when all users of it are finished
@@ -479,6 +483,7 @@ void usb_kill_urb(struct urb *urb)
 }
 
 EXPORT_SYMBOL(usb_init_urb);
+EXPORT_SYMBOL(usb_alloc_urb_node);
 EXPORT_SYMBOL(usb_alloc_urb);
 EXPORT_SYMBOL(usb_free_urb);
 EXPORT_SYMBOL(usb_get_urb);
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
index d353693..938395d 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -157,7 +157,7 @@ int onetouch_connect_input(struct us_data *ss)
 	if (!onetouch->data)
 		goto fail1;
 
-	onetouch->irq = usb_alloc_urb(0, GFP_KERNEL);
+	onetouch->irq = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&udev->dev));
 	if (!onetouch->irq)
 		goto fail2;
 
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 8e898e3..36cc5ef 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -781,7 +781,7 @@ static int usb_stor_acquire_resources(struct us_data *us)
 	int p;
 	struct task_struct *th;
 
-	us->current_urb = usb_alloc_urb(0, GFP_KERNEL);
+	us->current_urb = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&us->pusb_dev->dev));
 	if (!us->current_urb) {
 		US_DEBUGP("URB allocation failed\n");
 		return -ENOMEM;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index d91b9da..f1f460b 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -840,7 +840,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 		if (usb_endpoint_dir_in(endpoint)) {
 			if (usbhid->urbin)
 				continue;
-			if (!(usbhid->urbin = usb_alloc_urb(0, GFP_KERNEL)))
+			if (!(usbhid->urbin = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&dev->dev))))
 				goto fail;
 			pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);
 			usb_fill_int_urb(usbhid->urbin, dev, pipe, usbhid->inbuf, insize,
@@ -850,7 +850,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 		} else {
 			if (usbhid->urbout)
 				continue;
-			if (!(usbhid->urbout = usb_alloc_urb(0, GFP_KERNEL)))
+			if (!(usbhid->urbout = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&dev->dev))))
 				goto fail;
 			pipe = usb_sndintpipe(dev, endpoint->bEndpointAddress);
 			usb_fill_int_urb(usbhid->urbout, dev, pipe, usbhid->outbuf, 0,
@@ -910,7 +910,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
 	if (usb_string(dev, dev->descriptor.iSerialNumber, hid->uniq, 64) <= 0)
 		hid->uniq[0] = 0;
 
-	usbhid->urbctrl = usb_alloc_urb(0, GFP_KERNEL);
+	usbhid->urbctrl = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&dev->dev));
 	if (!usbhid->urbctrl)
 		goto fail;
 
diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index 1309787..aafc530 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -192,9 +192,9 @@ static void usb_kbd_close(struct input_dev *dev)
 
 static int usb_kbd_alloc_mem(struct usb_device *dev, struct usb_kbd *kbd)
 {
-	if (!(kbd->irq = usb_alloc_urb(0, GFP_KERNEL)))
+	if (!(kbd->irq = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&dev->dev))))
 		return -1;
-	if (!(kbd->led = usb_alloc_urb(0, GFP_KERNEL)))
+	if (!(kbd->led = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&dev->dev))))
 		return -1;
 	if (!(kbd->new = usb_buffer_alloc(dev, 8, GFP_ATOMIC, &kbd->new_dma)))
 		return -1;
diff --git a/drivers/hid/usbhid/usbmouse.c b/drivers/hid/usbhid/usbmouse.c
index 5345c73..d12a3dd 100644
--- a/drivers/hid/usbhid/usbmouse.c
+++ b/drivers/hid/usbhid/usbmouse.c
@@ -143,7 +143,7 @@ static int usb_mouse_probe(struct usb_interface *intf, const struct usb_device_i
 	if (!mouse->data)
 		goto fail1;
 
-	mouse->irq = usb_alloc_urb(0, GFP_KERNEL);
+	mouse->irq = usb_alloc_urb_node(0, GFP_KERNEL, dev_to_node(&dev->dev));
 	if (!mouse->irq)
 		goto fail2;
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 94bd38a..a0b63ef 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1263,6 +1263,7 @@ static inline void usb_fill_int_urb (struct urb *urb,
 }
 
 extern void usb_init_urb(struct urb *urb);
+extern struct urb *usb_alloc_urb_node(int iso_packets, gfp_t mem_flags, int node);
 extern struct urb *usb_alloc_urb(int iso_packets, gfp_t mem_flags);
 extern void usb_free_urb(struct urb *urb);
 #define usb_put_urb usb_free_urb
