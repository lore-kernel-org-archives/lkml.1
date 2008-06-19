Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYFSW2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYFSW2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYFSW2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:28:24 -0400
Received: from n2a.bullet.mail.ac4.yahoo.com ([76.13.13.65]:40300 "HELO
	n2a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752464AbYFSW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:28:22 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 18:28:22 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 673095.54386.bm@omp106.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=lFJOtuALKX1FiLnx0B58Kuf3Hts9WG0UpnKEJ+8/MUBlp5Q9p1uei6Oj4cxQz5nLgP0qx1a4zPnCOP+nEr3SxSSpSm5tGAlZ3ZFxh/nlsabTCgI+nhXihgtMgA9U59mVNPv5lXS2meLKF51ZSSHW2soh87/JXh7jn4qHbLyoTsc=;
X-Mailer: YahooMailRC/975.45 YahooMailWebService/0.7.199
Date: Thu, 19 Jun 2008 15:22:17 -0700 (PDT)
From: Aleksey Gorelov <dared1st@yahoo.com>
Subject: [PATCH] USB: debug port converter does not accept more than 8 byte packets
To: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <911755.27146.qm@web83307.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  USB debug port only supports 8 byte rx/tx packets. Although spec implies that "if a packet larger than eight bytes is received from the remote computer, the device must break the larger packet into eight-byte packets before sending the data to the Debug Port", the real PLX NET20DC device does not handle it right - data is corrupted on debug port end if serial interface sends >8 byte urbs. Patch below fixes the issue by limiting tx urb to 8 byte.

Signed off by: Aleks Gorelov <dared1st@yahoo.com>

--- a/drivers/usb/serial/usb_debug.c    2008-06-19 14:52:19.000000000 -0700
+++ b/drivers/usb/serial/usb_debug.c    2008-06-19 14:48:32.000000000 -0700
@@ -15,6 +15,8 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
+#define USB_DEBUG_MAX_PACKET_SIZE    8
+
 static struct usb_device_id id_table [] = {
     { USB_DEVICE(0x0525, 0x127a) },
     { },
@@ -29,6 +31,12 @@
     .no_dynamic_id =     1,
 };
 
+int usb_debug_open (struct usb_serial_port *port, struct file *filp)
+{
+    port->bulk_out_size = USB_DEBUG_MAX_PACKET_SIZE;
+    return usb_serial_generic_open(port, filp);
+}
+
 static struct usb_serial_driver debug_device = {
     .driver = {
         .owner =    THIS_MODULE,
@@ -39,6 +47,7 @@
     .num_bulk_in =        NUM_DONT_CARE,
     .num_bulk_out =        NUM_DONT_CARE,
     .num_ports =        1,
+    .open =            usb_debug_open,
 };
 
 static int __init debug_init(void)

