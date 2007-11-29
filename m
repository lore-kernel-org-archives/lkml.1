Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbXK2ANn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbXK2ANn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761726AbXK2AN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:13:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761479AbXK2AN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:13:27 -0500
Date: Wed, 28 Nov 2007 16:13:05 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: linux-usb@vger.kernel.org
Cc: zaitcev@redhat.com, <preining@logic.at>, <kristoffer.ericson@gmail.com>,
       <drussell@redhat.com>, <johann.wilhelm@student.tugraz.at>,
       linux-kernel@vger.kernel.org
Subject: Add the infamous Huawei E220 to option.c
Message-Id: <20071128161305.b01167b3.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All:

It looks like the Huawei E220 saga is not over yet. A collegue of mine,
David Russll, reported that the modem does not work reliably on Fedora 8,
which does have the initializer in usb-storage.

The problem stems from the fact that both option and usb-storage can bind
to the modem when in storage mode: the former binds because of the storage
class, the latter binds because of VID/PID match. The modprobe loads both,
it's random which wins. If usb-storage wins, everything is fine. If option
wins, it binds to modem still in storage mode and does not work.

I propose we add the same initializer that usb-storage has to the option.
This way no matter which driver wins the modem gets initialized. The
patch is tested on David's modem, but I would like someone give it more
testing.

I dunno, do we want some kind of code sharing between storage and option?
They both could use the normal usb_control_msg, I think.

Also, from archives it looks like Johann may need PID 0x1004 added.

Since we're on topic, David's modem has exactly same IDs as Norbert's,
but works fine with the length of 1. Although it's possible that the
firmware is different without different firmware reported in USB desc-
riptors. Does anyone know a magic AT command? ATI or something?
Norbert, please try my patch, maybe it'll work this time.

And finally, pleas stop using that script from the polish website and
above all quit using the generic serial subdriver. The option must
work now with the patch. Please let me know if it fails.

Thanks in advance,
-- Pete

diff -urp -X dontdiff linux-2.6.23.1-42.fc8/drivers/usb/serial/option.c linux-2.6.23.1-42.fc8.e220.1/drivers/usb/serial/option.c
--- linux-2.6.23.1-42.fc8/drivers/usb/serial/option.c	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23.1-42.fc8.e220.1/drivers/usb/serial/option.c	2007-11-27 21:36:11.000000000 -0800
@@ -448,7 +448,7 @@ static void option_indat_callback(struct
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err)
 				printk(KERN_ERR "%s: resubmit read urb failed. "
-					"(%d)", __FUNCTION__, err);
+					"(%d)\n", __FUNCTION__, err);
 		}
 	}
 	return;
@@ -728,6 +728,35 @@ static int option_send_setup(struct usb_
 	return 0;
 }
 
+static void option_start_huawei(struct usb_serial *serial)
+{
+	struct usb_device *dev = serial->dev;
+	char *buf;
+	int rc;
+
+	if (!(le16_to_cpu(dev->descriptor.idVendor) == HUAWEI_VENDOR_ID &&
+	    le16_to_cpu(dev->descriptor.idProduct) == HUAWEI_PRODUCT_E220))
+		return;
+
+	if ((buf = kmalloc(1, GFP_KERNEL)) == 0)
+		goto err_buf;
+
+	buf[0] = 0x1;
+	rc = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+		USB_REQ_SET_FEATURE, USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+		0x01, 0x0, buf, 1, 1000);
+	if (rc) {
+		printk(KERN_ERR "%s: HUAWEI E220 setup failed (%d)\n",
+		    __FUNCTION__, rc);
+	}
+
+	kfree(buf);
+	return;
+
+err_buf:
+	;
+}
+
 static int option_startup(struct usb_serial *serial)
 {
 	int i, err;
@@ -736,6 +765,8 @@ static int option_startup(struct usb_ser
 
 	dbg("%s", __FUNCTION__);
 
+	option_start_huawei(serial);
+
 	/* Now setup per port private data */
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
