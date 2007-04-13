Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXDMRDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXDMRDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 13:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXDMRDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 13:03:32 -0400
Received: from degraaf1.colo.troy.waveform.net ([204.11.33.9]:58010 "HELO
	mahatma.gandhilinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754102AbXDMRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 13:03:31 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2007 13:03:31 EDT
From: "Jeremy C. Andrus" <jeremy@jeremya.com>
Organization: http://www.jeremya.com/
To: linux-kernel@vger.kernel.org
Subject: [PATCH] usb bulk transfer: 1024 byte packets
Date: Fri, 13 Apr 2007 12:56:47 -0400
User-Agent: KMail/1.9.5
X-Rokken: Dokken
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PZ7HGgE3aR1NQ7h"
Message-Id: <200704131256.47570.jeremy@jeremya.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_PZ7HGgE3aR1NQ7h
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I recently ran into a couple of USB devices which insisted on using 1024 
byte packets in bulk transfer mode (despite the hard limit of 512 
established in the spec). I really wanted to use these devices, so I 
created a kernel patch which allows the use of 1024 byte URBs, but does 
not interfere with normal (512 byte) operation. I did this through a 
bit in the transfer_flags bitfield. 

I found this patch useful and un-obtrusive, so I figured that I would 
post it here to see if anyone else thinks it interesting enough to 
patch in. 

I am not subscribed to the list, and would appreciate a personal CC on 
reply :-).

	-Jeremy

-- 
-----------------------
Jeremy C. Andrus
http://www.jeremya.com/
-----------------------

--Boundary-00=_PZ7HGgE3aR1NQ7h
Content-Type: text/x-diff;
  charset="utf-8";
  name="linux-2.6.20.6-usb_1024byte_packets.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.20.6-usb_1024byte_packets.patch"

diff -Naur linux-2.6.20.6/Documentation/usb/bulk_tx_hacks.txt linux-2.6.20.6_jca/Documentation/usb/bulk_tx_hacks.txt
--- linux-2.6.20.6/Documentation/usb/bulk_tx_hacks.txt	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.20.6_jca/Documentation/usb/bulk_tx_hacks.txt	2007-04-13 09:59:19.000000000 -0400
@@ -0,0 +1,28 @@
+bulk_tx_hacks.txt
+Copyright (C) 2007 Jeremy C. Andrus <jeremy@jeremya.com>
+Started:   2007-April-13
+
+
+How to use a 1024-byte bulk transfer packet
+
+There are some devices/companies which have decided to use
+a bulk transfer packet size which is larger than the maximum
+specified in the USB spec. Because I was interested in using
+such a device, I found it necessary to devise a way to allow
+this functionality in the linux kernel. 
+
+It is reasonably simple to create a 1024-byte bulk transfer
+URB. Simply OR the 'URB_1024_BYTE_PKT' value into the URB's
+transfer_flags field before submitting it to the system:
+
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+
+	usb_fill_bulk_urb( urb, ... );
+
+	/* this allows the URB's buffer to be 1024 bytes */
+	urb->transfer_flags |= URB_1024_BYTE_PKT;
+	
+	retval = usb_submit_urb( urb, GFP_KERNEL );
+	
+	usb_free_urb( urb );
+
diff -Naur linux-2.6.20.6/drivers/usb/host/Kconfig linux-2.6.20.6_jca/drivers/usb/host/Kconfig
--- linux-2.6.20.6/drivers/usb/host/Kconfig	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6_jca/drivers/usb/host/Kconfig	2007-04-13 10:00:36.000000000 -0400
@@ -67,6 +67,20 @@
 
 	  If unsure, say N.
 
+config USB_EHCI_1024BYTE_BULK_PKTS
+	bool "Allow 1024-byte packets in Bulk Transfer mode"
+	depends on USB_EHCI_HCD && EXPERIMENTAL
+	---help---
+	  The USB specification allows a maximum bulk transfer packet size
+	  of 512 bytes. There are a few devices which have decided to break
+	  this specification and use 1024 byte packets. This option allows
+	  the use of the larger packet size with a very specific flag set 
+	  in the URB.
+	  
+	  See the Documentation/usb/bulk_tx_hacks.txt file for details.
+	  
+	  If unsure, say N.
+
 config USB_ISP116X_HCD
 	tristate "ISP116X HCD support"
 	depends on USB
diff -Naur linux-2.6.20.6/drivers/usb/host/ehci-q.c linux-2.6.20.6_jca/drivers/usb/host/ehci-q.c
--- linux-2.6.20.6/drivers/usb/host/ehci-q.c	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6_jca/drivers/usb/host/ehci-q.c	2007-04-13 09:47:09.000000000 -0400
@@ -751,7 +751,12 @@
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else if (type == PIPE_BULK) {
 			info1 |= (EHCI_TUNE_RL_HS << 28);
-			info1 |= 512 << 16;	/* usb2 fixed maxpacket */
+#ifdef USB_EHCI_1024BYTE_BULK_PKTS
+			if ( urb->transfer_flags & URB_1024_BYTE_PKT )
+				info1 |= 1024 << 16; /* HACK for Micron Dev Kits requiring 1024 byte packets... */
+			else
+#endif
+				info1 |= 512 << 16; /* usb2 fixed maxpacket */
 			info2 |= (EHCI_TUNE_MULT_HS << 30);
 		} else {		/* PIPE_INTERRUPT */
 			info1 |= max_packet (maxp) << 16;
diff -Naur linux-2.6.20.6/include/linux/usb.h linux-2.6.20.6_jca/include/linux/usb.h
--- linux-2.6.20.6/include/linux/usb.h	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6_jca/include/linux/usb.h	2007-04-13 09:47:09.000000000 -0400
@@ -904,6 +904,9 @@
 #define URB_ZERO_PACKET		0x0040	/* Finish bulk OUT with short packet */
 #define URB_NO_INTERRUPT	0x0080	/* HINT: no non-error interrupt
 					 * needed */
+#ifdef USB_EHCI_1024BYTE_BULK_PKTS
+#define URB_1024_BYTE_PKT	0x8000 /* Use a max packet length of 1024 bytes instead of 512 */
+#endif
 
 struct usb_iso_packet_descriptor {
 	unsigned int offset;

--Boundary-00=_PZ7HGgE3aR1NQ7h--
