Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbXEMT5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbXEMT5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXEMT5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:57:37 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:33415 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbXEMT5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:57:36 -0400
Date: Sun, 13 May 2007 20:57:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Soeren Sonnenburg <kernel@nn7.de>, linux-input@atrey.karlin.mff.cuni.cz,
       nicolas@boichat.ch, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <20070513195724.GA28493@srcf.ucam.org>
References: <1178995886.4168.10.camel@localhost> <20070513172052.GA26712@srcf.ucam.org> <20070513114626.d943999a.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513114626.d943999a.zaitcev@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Make appletouch shut up when it has nothing to say
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I've tidied this up a little. I've separated the actual mode init 
code into a separate function in order to avoid code duplication, and no 
longer creating a new workqueue. The only other change is something that 
I /think/ is actually a bug in the driver to begin with, but I'd like 
some more feedback on that first - the first packet sent after the mode 
change has 0x20 in the final byte. This seems to be interpreted as a 
left mouse button press. As a result, moving the touchpad sends a false 
press after every reinitialisation, or (approximately) every time the 
pointer is moved. As far as I can tell this also happens with the 
existing code, but is probably not noticable there because it won't 
appear again after the first touch on the pad. Just skipping that case 
seems to work fine.

diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index e321526..f126de8 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -155,6 +155,8 @@ struct atp {
 	int			xy_acc[ATP_XSENSORS + ATP_YSENSORS];
 	int			overflowwarn;	/* overflow warning printed? */
 	int			datalen;	/* size of an USB urb transfer */
+	int                     idlecount;      /* number of empty packets */
+	struct work_struct      work;
 };
 
 #define dbg_dump(msg, tab) \
@@ -208,6 +210,51 @@ static inline int atp_is_geyser_3(struct atp *dev)
 		(productId == GEYSER4_JIS_PRODUCT_ID);
 }
 
+static int atp_geyser3_init(struct usb_device *udev)
+{
+	char data[8];
+	int size;
+
+	size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+			       ATP_GEYSER3_MODE_READ_REQUEST_ID,
+			       USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			       ATP_GEYSER3_MODE_REQUEST_VALUE,
+			       ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
+  
+	if (size != 8) {
+		err("Could not do mode read request from device"
+		    " (Geyser 3 mode)");
+		return -EIO;
+	}
+
+	/* Apply the mode switch */
+	data[0] = ATP_GEYSER3_MODE_VENDOR_VALUE;
+  
+	size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			       ATP_GEYSER3_MODE_WRITE_REQUEST_ID,
+			       USB_DIR_OUT | USB_TYPE_CLASS | 
+			       USB_RECIP_INTERFACE,
+			       ATP_GEYSER3_MODE_REQUEST_VALUE,
+			       ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
+	
+	if (size != 8) {
+		err("Could not do mode write request to device"
+		    " (Geyser 3 mode)");
+		return -EIO;
+	}
+	return 0;
+}
+
+/* Reinitialise the device if it's a geyser 3 */
+static void atp_reinit(struct work_struct *work)
+{
+	struct atp *dev = container_of(work, struct atp, work);
+	struct usb_device *udev = dev->udev;
+
+	dev->idlecount = 0;
+	atp_geyser3_init(udev);
+}
+
 static int atp_calculate_abs(int *xy_sensors, int nb_sensors, int fact,
 			     int *z, int *fingers)
 {
@@ -441,7 +488,6 @@ static void atp_complete(struct urb* urb)
 		dev->y_old = y;
 	}
 	else if (!x && !y) {
-
 		dev->x_old = dev->y_old = -1;
 		input_report_key(dev->input, BTN_TOUCH, 0);
 		input_report_abs(dev->input, ABS_PRESSURE, 0);
@@ -449,10 +495,21 @@ static void atp_complete(struct urb* urb)
 
 		/* reset the accumulator on release */
 		memset(dev->xy_acc, 0, sizeof(dev->xy_acc));
+
+		/* Geyser 3 will continue to send packets continually after
+		   the first touch unless reinitialised. Do so if it's been
+		   idle for a while in order to avoid waking the kernel up
+		   several hundred times a second */
+		if (atp_is_geyser_3(dev)) {
+			dev->idlecount++;
+			if (dev->idlecount == 10)
+				schedule_work (&dev->work);
+		}
 	}
 
-	input_report_key(dev->input, BTN_LEFT,
-			 !!dev->data[dev->datalen - 1]);
+	if (dev->data[dev->datalen-1] != 20) 
+		input_report_key(dev->input, BTN_LEFT,
+				 !!dev->data[dev->datalen - 1]);
 
 	input_sync(dev->input);
 
@@ -533,35 +590,9 @@ static int atp_probe(struct usb_interface *iface, const struct usb_device_id *id
 		 * packets (Report ID 2). This code changes device mode, so it
 		 * sends raw sensor reports (Report ID 5).
 		 */
-		char data[8];
-		int size;
-
-		size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			ATP_GEYSER3_MODE_READ_REQUEST_ID,
-			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			ATP_GEYSER3_MODE_REQUEST_VALUE,
-			ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
-
-		if (size != 8) {
-			err("Could not do mode read request from device"
-							" (Geyser 3 mode)");
+		if (atp_geyser3_init(udev))
 			goto err_free_devs;
-		}
 
-		/* Apply the mode switch */
-		data[0] = ATP_GEYSER3_MODE_VENDOR_VALUE;
-
-		size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
-			ATP_GEYSER3_MODE_WRITE_REQUEST_ID,
-			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			ATP_GEYSER3_MODE_REQUEST_VALUE,
-			ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
-
-		if (size != 8) {
-			err("Could not do mode write request to device"
-							" (Geyser 3 mode)");
-			goto err_free_devs;
-		}
 		printk("appletouch Geyser 3 inited.\n");
 	}
 
@@ -636,6 +667,8 @@ static int atp_probe(struct usb_interface *iface, const struct usb_device_id *id
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
+        INIT_WORK(&dev->work, atp_reinit);
+
 	return 0;
 
  err_free_buffer:

-- 
Matthew Garrett | mjg59@srcf.ucam.org
