Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZLWBvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZLWBvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZLWBvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:51:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48084 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZLWBvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:51:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [Regression, 2.6.33-rc1->current git] NULL pointer in usb_serial_probe() introduced by the recent kfifo changes
Date: Wed, 23 Dec 2009 02:51:31 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912230251.31568.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Something like the patch below is necessary to fix a new NULL pointer deref
in usb_serial_probe() that appeared after the recent kfifo changes (in short,
the kfifo changes modified the semantics of kfifo_alloc() that
usb_serial_probe() reiled on).

Thanks,
Rafael

---
 drivers/usb/serial/usb-serial.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/usb/serial/usb-serial.c
===================================================================
--- linux-2.6.orig/drivers/usb/serial/usb-serial.c
+++ linux-2.6/drivers/usb/serial/usb-serial.c
@@ -595,8 +595,10 @@ static void port_release(struct device *
 	usb_free_urb(port->write_urb);
 	usb_free_urb(port->interrupt_in_urb);
 	usb_free_urb(port->interrupt_out_urb);
-	if (!IS_ERR(port->write_fifo) && port->write_fifo)
+	if (port->write_fifo) {
 		kfifo_free(port->write_fifo);
+		kfree(port->write_fifo);
+	}
 	kfree(port->bulk_in_buffer);
 	kfree(port->bulk_out_buffer);
 	kfree(port->interrupt_in_buffer);
@@ -939,6 +941,12 @@ int usb_serial_probe(struct usb_interfac
 			dev_err(&interface->dev, "No free urbs available\n");
 			goto probe_error;
 		}
+		port->write_fifo = kzalloc(sizeof(struct kfifo), GFP_KERNEL);
+		if (!port->write_fifo) {
+			dev_err(&interface->dev,
+				"Couldn't allocate write_fifo\n");
+			goto probe_error;
+		}
 		if (kfifo_alloc(port->write_fifo, PAGE_SIZE, GFP_KERNEL))
 			goto probe_error;
 		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
