Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZFFAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZFFAoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 20:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZFFAoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 20:44:12 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:51191
	"EHLO QMTA13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbZFFAoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 20:44:11 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2009 20:44:11 EDT
Date: Sat, 6 Jun 2009 00:38:22 +0000 (UTC)
From: firstlink@comcast.net
To: gregkh@suse.de, judd@jpilot.org, jeff.frontz@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-ID: <1704904938.1159111244248702210.JavaMail.root@sz0061a.emeryville.ca.mail.comcast.net>
Subject: rspiusb driver cleanup - remove dbg macro
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.6.70.242]
X-Mailer: Zimbra 5.0.12_GA_2816.RHEL5_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.12_GA_2816.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, 
I think my last patch was broken because I forgot to turn plain text in my mailer. 
Here is the new patch. Let me know if it is in good enough shape to make it in the tree. 
I am preparing other patches in the same driver to address some of the other TODO points. 
At some point in this work I will looking for someone with a Princeton Instrument Camera for test. 

Best regards

Jean-Pierre Sainfeld


>From e596293d92c600ef17ebc3c6789368d9016bd537 Mon Sep 17 00:00:00 2001
From: Jean-Pierre Sainfeld <firstlink@comcast.net>
Date: Thu, 4 Jun 2009 17:06:14 -0700
Subject: [PATCH] remove local dbg macro


Signed-off-by: Jean-Pierre Sainfeld <firstlink@comcast.net>
---
 drivers/staging/rspiusb/rspiusb.c |  199 +++++++++++++++++++++++--------------
 1 files changed, 124 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/rspiusb/rspiusb.c b/drivers/staging/rspiusb/rspiusb.c
index 090bf41..25d0737 100644
--- a/drivers/staging/rspiusb/rspiusb.c
+++ b/drivers/staging/rspiusb/rspiusb.c
@@ -37,13 +37,6 @@ static int debug = 1;
 #else
 static int debug;
 #endif
-/* Use our own dbg macro */
-#undef dbg
-#define dbg(format, arg...) \
-	do { \
-		if (debug) \
-			printk(KERN_DEBUG __FILE__ ": " format "\n" , ##arg); \
-	} while (0)
 
 /* Version Information */
 #define DRIVER_VERSION "V1.0.1"
@@ -136,7 +129,6 @@ static int piusb_open(struct inode *inode, struct file *file)
 	int subminor;
 	int retval = 0;
 
-	dbg("Piusb_Open()");
 	subminor = iminor(inode);
 	interface = usb_find_interface(&piusb_driver, subminor);
 	if (!interface) {
@@ -151,7 +143,10 @@ static int piusb_open(struct inode *inode, struct file *file)
 		retval = -ENODEV;
 		goto exit_no_device;
 	}
-	dbg("Alternate Setting = %d", interface->num_altsetting);
+	dev_dbg(&pdx->udev->dev, "Piusb_Open()");
+	dev_dbg(&pdx->udev->dev,
+		"Alternate Setting = %d",
+		interface->num_altsetting);
 
 	pdx->bulk_in_size_returned = 0;
 	pdx->bulk_in_byte_trk = 0;
@@ -184,13 +179,13 @@ static int piusb_release(struct inode *inode, struct file *file)
 	struct device_extension *pdx;
 	int retval = 0;
 
-	dbg("Piusb_Release()");
 	pdx = (struct device_extension *)file->private_data;
 	if (pdx == NULL) {
-		dbg("%s - object is NULL", __func__);
 		retval = -ENODEV;
 		goto object_null;
 	}
+	dev_dbg(&pdx->udev->dev,
+		"Piusb_Release()");
 	/* decrement the count on our device */
 	kref_put(&pdx->kref, piusb_delete);
 
@@ -209,16 +204,17 @@ static int pixis_io(struct ioctl_struct *ctrl, struct device_extension *pdx,
 
 	uBuf = kmalloc(ctrl->numbytes, GFP_KERNEL);
 	if (!uBuf) {
-		dbg("Alloc for uBuf failed");
+		dev_dbg(&pdx->udev->dev, "Alloc for uBuf failed");
 		return 0;
 	}
 	numbytes = (int) ctrl->numbytes;
 	numToRead = (unsigned int) ctrl->numbytes;
-	dbg("numbytes to read = %d", numbytes);
-	dbg("endpoint # %d", ctrl->endpoint);
+	dev_dbg(&pdx->udev->dev, "numbytes to read = %d", numbytes);
+	dev_dbg(&pdx->udev->dev, "endpoint # %d", ctrl->endpoint);
 
 	if (copy_from_user(uBuf, ctrl->pData, numbytes))
-		dbg("copying ctrl->pData to dummyBuf failed");
+		dev_dbg(&pdx->udev->dev,
+		  "copying ctrl->pData to dummyBuf failed");
 
 	do {
 		i = usb_bulk_msg(pdx->udev, pdx->hEP[ctrl->endpoint],
@@ -227,26 +223,32 @@ static int pixis_io(struct ioctl_struct *ctrl, struct device_extension *pdx,
 				(numToRead > 64) ? 64 : numToRead,
 				&numbytes, HZ * 10);
 		if (i) {
-			dbg("CMD = %s, Address = 0x%02X",
-					((uBuf[3] == 0x02) ? "WRITE" : "READ"),
-					uBuf[1]);
-			dbg("Number of bytes Attempted to read = %d",
-					(int)ctrl->numbytes);
-			dbg("Blocking ReadI/O Failed with status %d", i);
+			dev_dbg(&pdx->udev->dev,
+				"CMD = %s, Address = 0x%02X",
+				((uBuf[3] == 0x02) ? "WRITE" : "READ"),
+				uBuf[1]);
+			dev_dbg(&pdx->udev->dev,
+				"Number of bytes Attempted to read = %d",
+				(int)ctrl->numbytes);
+			dev_dbg(&pdx->udev->dev,
+				"Blocking ReadI/O Failed with status %d",
+				i);
 			kfree(uBuf);
 			return -1;
 		}
-		dbg("Pixis EP0 Read %d bytes", numbytes);
+		dev_dbg(&pdx->udev->dev, "Pixis EP0 Read %d bytes", numbytes);
 		totalRead += numbytes;
 		numToRead -= numbytes;
 	} while (numToRead);
 
 	memcpy(ctrl->pData, uBuf, totalRead);
-	dbg("Total Bytes Read from PIXIS EP0 = %d", totalRead);
+	dev_dbg(&pdx->udev->dev,
+		"Total Bytes Read from PIXIS EP0 = %d",
+		totalRead);
 	ctrl->numbytes = totalRead;
 
 	if (copy_to_user(arg, ctrl, sizeof(struct ioctl_struct)))
-		dbg("copy_to_user failed in IORB");
+		dev_dbg(&pdx->udev->dev, "copy_to_user failed in IORB");
 
 	kfree(uBuf);
 	return ctrl->numbytes;
@@ -288,7 +290,7 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	pdx = (struct device_extension *)file->private_data;
 	/* verify that the device wasn't unplugged */
 	if (!pdx->present) {
-		dbg("No Device Present\n");
+		dev_dbg(&pdx->udev->dev, "No Device Present\n");
 		return -ENODEV;
 	}
 	/* fill in your device specific stuff here */
@@ -307,14 +309,19 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		if (copy_from_user
 		    (&ctrl, (void __user *)arg, sizeof(struct ioctl_struct)))
 			dev_err(&pdx->udev->dev, "copy_from_user failed\n");
-		dbg("%s %x\n", "Get Vendor Command = ", ctrl.cmd);
+
+		dev_dbg(&pdx->udev->dev,
+			"%s %x\n", "Get Vendor Command = ",
+			ctrl.cmd);
+
 		retval =
 		    usb_control_msg(pdx->udev, usb_rcvctrlpipe(pdx->udev, 0),
 				    ctrl.cmd, USB_DIR_IN, 0, 0, &devRB,
 				    ctrl.numbytes, HZ * 10);
 		if (ctrl.cmd == 0xF1) {
-			dbg("FW Version returned from HW = %ld.%ld",
-			    (devRB >> 8), (devRB & 0xFF));
+			dev_dbg(&pdx->udev->dev,
+				"FW Version returned from HW = %ld.%ld",
+				(devRB >> 8), (devRB & 0xFF));
 		}
 		if (retval >= 0)
 			retval = (int)devRB;
@@ -324,10 +331,19 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		if (copy_from_user
 		    (&ctrl, (void __user *)arg, sizeof(struct ioctl_struct)))
 			dev_err(&pdx->udev->dev, "copy_from_user failed\n");
-		/* dbg( "%s %x", "Set Vendor Command = ",ctrl.cmd ); */
+
+		/*
+		dev_dbg(&pdx->udev->dev,
+			"%s %x", "Set Vendor Command = ",
+			ctrl.cmd );
+		*/
 		controlData = ctrl.pData[0];
 		controlData |= (ctrl.pData[1] << 8);
-		/* dbg( "%s %d", "Vendor Data =",controlData ); */
+		/*
+		dev_dbg(&pdx->udev->dev,
+			"%s %d", "Vendor Data =",
+			controlData );
+		*/
 		retval = usb_control_msg(pdx->udev,
 				usb_sndctrlpipe(pdx->udev, 0),
 				ctrl.cmd,
@@ -345,7 +361,7 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			dev_err(&pdx->udev->dev,
 					"copy_from_user WRITE_DUMMY failed\n");
 		if (!access_ok(VERIFY_READ, ctrl.pData, ctrl.numbytes)) {
-			dbg("can't access pData");
+			dev_dbg(&pdx->udev->dev, "can't access pData");
 			return 0;
 		}
 		piusb_output(&ctrl, ctrl.pData /* uBuf */, ctrl.numbytes, pdx);
@@ -382,7 +398,7 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		return pdx->iama;
 
 	case PIUSB_SETFRAMESIZE:
-		dbg("PIUSB_SETFRAMESIZE");
+		dev_dbg(&pdx->udev->dev, "PIUSB_SETFRAMESIZE");
 		if (copy_from_user
 		    (&ctrl, (void __user *)arg, sizeof(struct ioctl_struct)))
 			dev_err(&pdx->udev->dev, "copy_from_user failed\n");
@@ -410,12 +426,12 @@ static int piusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		return 0;
 
 	default:
-		dbg("%s\n", "No IOCTL found");
+		dev_dbg(&pdx->udev->dev, "%s\n", "No IOCTL found");
 		break;
 
 	}
 	/* return that we did not understand this ioctl call */
-	dbg("Returning -ENOTTY");
+	dev_dbg(&pdx->udev->dev, "Returning -ENOTTY");
 	return -ENOTTY;
 }
 
@@ -473,15 +489,21 @@ static int UnMapUserBuffer(struct device_extension *pdx)
 	unsigned int epAddr;
 
 	for (k = 0; k < pdx->num_frames; k++) {
-		dbg("Killing Urbs for Frame %d", k);
+		dev_dbg(&pdx->udev->dev,
+			"Killing Urbs for Frame %d",
+			k);
 		for (i = 0; i < pdx->sgEntries[k]; i++) {
 			usb_kill_urb(pdx->PixelUrb[k][i]);
 			usb_free_urb(pdx->PixelUrb[k][i]);
 			pdx->pendedPixelUrbs[k][i] = 0;
 		}
-		dbg("Urb error count = %d", errCnt);
+		dev_dbg(&pdx->udev->dev,
+			"Urb error count = %d",
+			errCnt);
 		errCnt = 0;
-		dbg("Urbs free'd and Killed for Frame %d", k);
+		dev_dbg(&pdx->udev->dev,
+			"Urbs free'd and Killed for Frame %d",
+			k);
 	}
 
 	for (k = 0; k < pdx->num_frames; k++) {
@@ -527,13 +549,20 @@ static void piusb_readPIXEL_callback(struct urb *urb)
 	int status = urb->status;
 
 	if (status && !(status == -ENOENT || status == -ECONNRESET)) {
-		dbg("%s - nonzero read bulk status received: %d", __func__,
-		    status);
-		dbg("Error in read EP2 callback");
-		dbg("FrameIndex = %d", pdx->frameIdx);
-		dbg("Bytes received before problem occurred = %d",
-		    pdx->bulk_in_byte_trk);
-		dbg("Urb Idx = %d", pdx->urbIdx);
+		dev_dbg(&pdx->udev->dev,
+			"%s - nonzero read bulk status received: %d",
+			__func__, status);
+		dev_dbg(&pdx->udev->dev,
+			"Error in read EP2 callback");
+		dev_dbg(&pdx->udev->dev,
+			"FrameIndex = %d",
+			pdx->frameIdx);
+		dev_dbg(&pdx->udev->dev,
+			"Bytes received before problem occurred = %d",
+			pdx->bulk_in_byte_trk);
+		dev_dbg(&pdx->udev->dev,
+			"Urb Idx = %d",
+			pdx->urbIdx);
 		pdx->pendedPixelUrbs[pdx->frameIdx][pdx->urbIdx] = 0;
 	} else {
 		pdx->bulk_in_byte_trk += urb->actual_length;
@@ -541,8 +570,9 @@ static void piusb_readPIXEL_callback(struct urb *urb)
 		if (i) {
 			errCnt++;
 			if (i != lastErr) {
-				dbg("submit urb in callback failed "
-						"with error code %d", i);
+				dev_dbg(&pdx->udev->dev,
+					"submit urb in callback failed"
+					"with error code %d", i);
 				lastErr = i;
 			}
 		} else {
@@ -611,23 +641,24 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
 		/* PONG, odd frames: hEP[3] */
 		/* PING, even frames and zero hEP[2] */
 		epAddr = (frameInfo % 2) ? pdx->hEP[3] : pdx->hEP[2];
-		dbg("Pixis Frame #%d: EP=%d", frameInfo,
+		dev_dbg(&pdx->udev->dev, "Pixis Frame #%d: EP=%d", frameInfo,
 		    (epAddr == pdx->hEP[2]) ? 2 : 4);
 	} else { /* ST133 only has 1 endpoint for Pixel data transfer */
 		epAddr = pdx->hEP[0];
-		dbg("ST133 Frame #%d: EP=2", frameInfo);
+		dev_dbg(&pdx->udev->dev, "ST133 Frame #%d: EP=2", frameInfo);
 	}
 	count = numbytes;
-	dbg("UserAddress = 0x%08lX", uaddr);
-	dbg("numbytes = %d", (int)numbytes);
+	dev_dbg(&pdx->udev->dev, "UserAddress = 0x%08lX", uaddr);
+	dev_dbg(&pdx->udev->dev, "numbytes = %d", (int)numbytes);
 
 	/* number of pages to map the entire user space DMA buffer */
 	numPagesRequired =
 	    ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
-	dbg("Number of pages needed = %d", numPagesRequired);
+	dev_dbg(&pdx->udev->dev,
+		"Number of pages needed = %d", numPagesRequired);
 	maplist_p = vmalloc(numPagesRequired * sizeof(struct page));
 	if (!maplist_p) {
-		dbg("Can't Allocate Memory for maplist_p");
+		dev_dbg(&pdx->udev->dev, "Can't Allocate Memory for maplist_p");
 		return -ENOMEM;
 	}
 
@@ -637,13 +668,13 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
 			current->mm, (uaddr & PAGE_MASK), numPagesRequired,
 			WRITE, 0 /* Don't Force*/, maplist_p, NULL);
 	up_write(&current->mm->mmap_sem);
-	dbg("Number of pages mapped = %d",
+	dev_dbg(&pdx->udev->dev, "Number of pages mapped = %d",
 	    pdx->maplist_numPagesMapped[frameInfo]);
 
 	for (i = 0; i < pdx->maplist_numPagesMapped[frameInfo]; i++)
 		flush_dcache_page(maplist_p[i]);
 	if (!pdx->maplist_numPagesMapped[frameInfo]) {
-		dbg("get_user_pages() failed");
+		dev_dbg(&pdx->udev->dev, "get_user_pages() failed");
 		vfree(maplist_p);
 		return -ENOMEM;
 	}
@@ -656,7 +687,7 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
 		     sizeof(struct scatterlist)), GFP_ATOMIC);
 	if (!pdx->sgl[frameInfo]) {
 		vfree(maplist_p);
-		dbg("can't allocate mem for sgl");
+		dev_dbg(&pdx->udev->dev, "can't allocate mem for sgl");
 		return -ENOMEM;
 	}
 	pdx->sgl[frameInfo][0].page_link = maplist_p[0];
@@ -678,7 +709,9 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
 	pdx->sgEntries[frameInfo] =
 	    usb_buffer_map_sg(pdx->udev, epAddr, pdx->sgl[frameInfo],
 			      pdx->maplist_numPagesMapped[frameInfo]);
-	dbg("number of sgEntries = %d", pdx->sgEntries[frameInfo]);
+	dev_dbg(&pdx->udev->dev,
+		"number of sgEntries = %d",
+		pdx->sgEntries[frameInfo]);
 	pdx->userBufMapped = 1;
 	vfree(maplist_p);
 
@@ -687,7 +720,7 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
 	    kmalloc(pdx->sgEntries[frameInfo] * sizeof(struct urb *),
 		    GFP_KERNEL);
 	if (!pdx->PixelUrb[frameInfo]) {
-		dbg("Can't Allocate Memory for Urb");
+		dev_dbg(&pdx->udev->dev, "Can't Allocate Memory for Urb");
 		return -ENOMEM;
 	}
 	for (i = 0; i < pdx->sgEntries[frameInfo]; i++) {
@@ -711,11 +744,14 @@ static int MapUserBuffer(struct ioctl_struct *io, struct device_extension *pdx)
 	pdx->pendedPixelUrbs[frameInfo] =
 	    kmalloc((pdx->sgEntries[frameInfo] * sizeof(char)), GFP_KERNEL);
 	if (!pdx->pendedPixelUrbs[frameInfo])
-		dbg("Can't allocate Memory for pendedPixelUrbs");
+		dev_dbg(&pdx->udev->dev,
+			"Can't allocate Memory for pendedPixelUrbs");
 	for (i = 0; i < pdx->sgEntries[frameInfo]; i++) {
 		err = usb_submit_urb(pdx->PixelUrb[frameInfo][i], GFP_ATOMIC);
 		if (err) {
-			dbg("%s %d\n", "submit urb error =", err);
+			dev_dbg(&pdx->udev->dev,
+				"%s %d\n", "submit urb error =",
+				err);
 			pdx->pendedPixelUrbs[frameInfo][i] = 0;
 			return err;
 		}
@@ -774,28 +810,37 @@ static int piusb_probe(struct usb_interface *interface,
 
 	if (debug) {
 		if (pdx->udev->descriptor.idProduct == PIXIS_PID)
-			dbg("PIUSB:Pixis Camera Found");
+			dev_dbg(&pdx->udev->dev,
+				"PIUSB:Pixis Camera Found");
 		else
-			dbg("PIUSB:ST133 USB Controller Found");
+			dev_dbg(&pdx->udev->dev,
+				"PIUSB:ST133 USB Controller Found");
 		if (pdx->udev->speed == USB_SPEED_HIGH)
-			dbg("Highspeed(USB2.0) Device Attached");
+			dev_dbg(&pdx->udev->dev,
+				"Highspeed(USB2.0) Device Attached");
 		else
-			dbg("Lowspeed (USB1.1) Device Attached");
+			dev_dbg(&pdx->udev->dev,
+				"Lowspeed (USB1.1) Device Attached");
 
-		dbg("NumEndpoints in Configuration: %d",
-		    iface_desc->desc.bNumEndpoints);
+		dev_dbg(&pdx->udev->dev,
+			"NumEndpoints in Configuration: %d",
+			iface_desc->desc.bNumEndpoints);
 	}
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
 		if (debug) {
-			dbg("Endpoint[%d]->bDescriptorType = %d", i,
-			    endpoint->bDescriptorType);
-			dbg("Endpoint[%d]->bEndpointAddress = 0x%02X", i,
-			    endpoint->bEndpointAddress);
-			dbg("Endpoint[%d]->bbmAttributes = %d", i,
-			    endpoint->bmAttributes);
-			dbg("Endpoint[%d]->MaxPacketSize = %d\n", i,
-			    endpoint->wMaxPacketSize);
+			dev_dbg(&pdx->udev->dev,
+				"Endpoint[%d]->bDescriptorType = %d", i,
+				endpoint->bDescriptorType);
+			dev_dbg(&pdx->udev->dev,
+				"Endpoint[%d]->bEndpointAddress = 0x%02X", i,
+				endpoint->bEndpointAddress);
+			dev_dbg(&pdx->udev->dev,
+				"Endpoint[%d]->bbmAttributes = %d", i,
+				endpoint->bmAttributes);
+			dev_dbg(&pdx->udev->dev,
+				"Endpoint[%d]->MaxPacketSize = %d\n", i,
+				endpoint->wMaxPacketSize);
 		}
 		if (usb_endpoint_xfer_bulk(endpoint)) {
 			if (usb_endpoint_dir_in(endpoint))
@@ -820,7 +865,9 @@ static int piusb_probe(struct usb_interface *interface,
 	/* we can register the device now, as it is ready */
 	pdx->minor = interface->minor;
 	/* let the user know what node this device is now attached to */
-	dbg("PI USB2.0 device now attached to piusb-%d", pdx->minor);
+	dev_dbg(&pdx->udev->dev,
+		"PI USB2.0 device now attached to piusb-%d",
+		pdx->minor);
 	return 0;
 
 error:
@@ -858,7 +905,9 @@ static void piusb_disconnect(struct usb_interface *interface)
 	/* prevent device read, write and ioctl */
 	pdx->present = 0;
 	kref_put(&pdx->kref, piusb_delete);
-	dbg("PI USB2.0 device #%d now disconnected\n", minor);
+	dev_dbg(&pdx->udev->dev,
+		"PI USB2.0 device #%d now disconnected\n",
+		minor);
 }
 
 static struct usb_driver piusb_driver = {
-- 
1.6.0.4



