Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbXJ3VWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbXJ3VWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJ3VWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:22:16 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58981 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXJ3VWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:22:15 -0400
Date: Tue, 30 Oct 2007 22:22:13 +0100
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20071030212213.GA13410@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com> <20071030204720.GI8479@gamma.logic.tuwien.ac.at> <47279EF7.3040406@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <47279EF7.3040406@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Di, 30 Okt 2007, Chuck Ebbert wrote:
> Did you see commit d853d872c14b9adc4adad29e56cd378b291f86e0 ?

No, where can I see that one?

I tried the attached patch which I found on the usb list, but it didn't
work, the cdrom was still always found, and it was
connected/disconnected permanently. Currently I was at:

...
Oct 30 22:20:32 mithrandir kernel: usb 2-2: new full speed USB device using uhci_hcd and address 13
Oct 30 22:20:32 mithrandir kernel: usb 2-2: configuration #1 chosen from 1 choice
Oct 30 22:20:32 mithrandir kernel: usb-storage: probe of 2-2:1.0 failed with error -5
Oct 30 22:20:32 mithrandir kernel: option 2-2:1.0: GSM modem (1-port) converter detected
Oct 30 22:20:32 mithrandir kernel: usb 2-2: GSM modem (1-port) converter now attached to ttyUSB0
Oct 30 22:20:32 mithrandir kernel: usb-storage: probe of 2-2:1.1 failed with error -5
Oct 30 22:20:32 mithrandir kernel: option 2-2:1.1: GSM modem (1-port) converter detected
Oct 30 22:20:32 mithrandir kernel: usb 2-2: GSM modem (1-port) converter now attached to ttyUSB1
Oct 30 22:20:32 mithrandir kernel: scsi35 : SCSI emulation for USB Mass Storage devices

Note the SCSI35 !!!

So is there any other patch I can try?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
BARSTIBLEY
A humorous device such as a china horse or small naked porcelain
infant which jocular hosts use of piss water into your Scotch with.
			--- Douglas Adams, The Meaning of Liff

--RnlQjJ0d97Da+TV1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="activate_huawei_dev-2.6.23.patch"

--- ./drivers/usb/storage/initializers.c.orig	2007-04-26 09:20:58.000000000 +0200
+++ ./drivers/usb/storage/initializers.c	2007-10-30 22:03:29.000000000 +0100
@@ -90,3 +90,14 @@
 
 	return (res ? -1 : 0);
 }
+
+/* This places the HUAWEI E220 devices in multi-port mode */
+int usb_stor_switch_ports_init(struct us_data *us)
+{
+	us->iobuf[0] = 0x1;
+	(void)usb_control_msg(us->pusb_dev, usb_sndctrlpipe(us->pusb_dev, 0),
+		USB_REQ_SET_FEATURE, USB_TYPE_STANDARD | USB_RECIP_DEVICE, 
+		0x01, 0x0, us->iobuf, 0x1, 1000);
+	return 0;
+}
+
--- ./drivers/usb/storage/initializers.h.orig	2006-12-09 15:26:06.000000000 +0100
+++ ./drivers/usb/storage/initializers.h	2007-10-30 22:03:29.000000000 +0100
@@ -47,3 +47,6 @@
 /* This function is required to activate all four slots on the UCR-61S2B
  * flash reader */
 int usb_stor_ucr61s2b_init(struct us_data *us);
+
+/* This places the HUAWEI E220 devices in multi-port mode */
+int usb_stor_switch_ports_init(struct us_data *us);
--- ./drivers/usb/storage/unusual_devs.h.orig	2007-10-30 19:40:17.000000000 +0100
+++ ./drivers/usb/storage/unusual_devs.h	2007-10-30 22:05:51.000000000 +0100
@@ -1463,6 +1463,16 @@
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
 
+/* This tells the usb driver to place the HUAWEI E220 devices into multi-port mode
+ * Reported by fangxiaozhi <fangxiaozhi60675@huawei.com>
+ * and by linlei <linlei83@huawei.com>
+ */
+UNUSUAL_DEV( 0x12d1, 0x1003, 0x0000, 0x0000,
+                "HUAWEI",
+		"HUAWEI MOBILE Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_switch_ports_init,
+		0),
+
 /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
 UNUSUAL_DEV(  0x132b, 0x000b, 0x0001, 0x0001,
 		"Minolta",

--RnlQjJ0d97Da+TV1--
