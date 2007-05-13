Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbXEMRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbXEMRoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXEMRoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:44:08 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:41335 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbXEMRoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:44:07 -0400
Date: Sun, 13 May 2007 18:20:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz, nicolas@boichat.ch
Message-ID: <20070513172052.GA26712@srcf.ucam.org>
References: <1178995886.4168.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178995886.4168.10.camel@localhost>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH] Make appletouch shut up when it has nothing to say
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The appletouch devices found in the Intel Macs (and possibly some later 
PPC ones?) send a constant stream of packets after the first touch. This 
results in the kernel waking up around once every couple of milliseconds 
to process them, making it almost impossible to spend any significant 
period of time in C3 state on a dynamic HZ kernel. Sending the mode 
initialisation code makes the device shut up until it's touched again. 
This patch does so after receiving 10 packets with no interesting 
content.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index e321526..7931a76 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -155,8 +155,12 @@ struct atp {
 	int			xy_acc[ATP_XSENSORS + ATP_YSENSORS];
 	int			overflowwarn;	/* overflow warning printed? */
 	int			datalen;	/* size of an USB urb transfer */
+	int                     idlecount;      /* number of empty packets */
+	struct work_struct      work;
 };
 
+static struct workqueue_struct *appletouch_wq;
+
 #define dbg_dump(msg, tab) \
 	if (debug > 1) {						\
 		int i;							\
@@ -208,6 +212,46 @@ static inline int atp_is_geyser_3(struct atp *dev)
 		(productId == GEYSER4_JIS_PRODUCT_ID);
 }
 
+/* Reinitialise the device if it's a geyser 3 */
+static void atp_reinit(struct work_struct *work)
+{
+	struct atp *dev = container_of(work, struct atp, work);
+	struct usb_device *udev = dev->udev;
+	char data[8];
+	int size;
+
+	if (!atp_is_geyser_3(dev))
+		return;
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
+		return;
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
+		return;
+	}
+}
+
 static int atp_calculate_abs(int *xy_sensors, int nb_sensors, int fact,
 			     int *z, int *fingers)
 {
@@ -419,6 +463,7 @@ static void atp_complete(struct urb* urb)
 			      ATP_YFACT, &y_z, &y_f);
 
 	if (x && y) {
+		dev->idlecount = 0;
 		if (dev->x_old != -1) {
 			x = (dev->x_old * 3 + x) >> 2;
 			y = (dev->y_old * 3 + y) >> 2;
@@ -441,7 +486,7 @@ static void atp_complete(struct urb* urb)
 		dev->y_old = y;
 	}
 	else if (!x && !y) {
-
+		dev->idlecount++;
 		dev->x_old = dev->y_old = -1;
 		input_report_key(dev->input, BTN_TOUCH, 0);
 		input_report_abs(dev->input, ABS_PRESSURE, 0);
@@ -449,6 +494,13 @@ static void atp_complete(struct urb* urb)
 
 		/* reset the accumulator on release */
 		memset(dev->xy_acc, 0, sizeof(dev->xy_acc));
+
+		/* Geyser 3 will continue to send packets continually after
+		   the first touch unless reinitialised. Do so if it's been
+		   idle for a while in order to avoid waking the kernel up
+		   several hundred times a second */
+		if (dev->idlecount >= 10)
+			queue_work (appletouch_wq, &dev->work);
 	}
 
 	input_report_key(dev->input, BTN_LEFT,
@@ -636,6 +688,8 @@ static int atp_probe(struct usb_interface *iface, const struct usb_device_id *id
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
+        INIT_WORK(&dev->work, atp_reinit);
+
 	return 0;
 
  err_free_buffer:
@@ -694,12 +748,18 @@ static struct usb_driver atp_driver = {
 
 static int __init atp_init(void)
 {
+	appletouch_wq = create_singlethread_workqueue("kappletouch");
+	if (!appletouch_wq) {
+		printk(KERN_ERR "appletouch: failed to create workqueue\n");
+		return -ENOMEM;
+	}
 	return usb_register(&atp_driver);
 }
 
 static void __exit atp_exit(void)
 {
 	usb_deregister(&atp_driver);
+	destroy_workqueue(appletouch_wq);
 }
 
 module_init(atp_init);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
