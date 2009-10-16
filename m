Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbZJPRS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbZJPRS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZJPRSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:24 -0400
Received: from kroah.org ([198.145.64.141]:48482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbZJPRSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:21 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:53 2009
Message-Id: <20091016171153.150585044@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [13/46] USB: serial: dont call release without attach
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=usb-serial-don-t-call-release-without-attach.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit a4720c650b68a5fe7faed2edeb0ad12645f7ae63 upstream.

This patch (as1295) fixes a recently-added bug in the USB serial core.
If certain kinds of errors occur during probing, the core may call a
serial driver's release method without previously calling the attach
method.  This causes some drivers (io_ti in particular) to perform an
invalid memory access.

The patch adds a new flag to keep track of whether or not attach has
been called.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Jean-Denis Girard <jd.girard@sysnux.pf>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    6 +++++-
 include/linux/usb/serial.h      |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -155,7 +155,8 @@ static void destroy_serial(struct kref *
 	if (serial->minor != SERIAL_TTY_NO_MINOR)
 		return_serial(serial);
 
-	serial->type->release(serial);
+	if (serial->attached)
+		serial->type->release(serial);
 
 	/* Now that nothing is using the ports, they can be freed */
 	for (i = 0; i < serial->num_port_pointers; ++i) {
@@ -1060,12 +1061,15 @@ int usb_serial_probe(struct usb_interfac
 		module_put(type->driver.owner);
 		if (retval < 0)
 			goto probe_error;
+		serial->attached = 1;
 		if (retval > 0) {
 			/* quietly accept this device, but don't bind to a
 			   serial port as it's about to disappear */
 			serial->num_ports = 0;
 			goto exit;
 		}
+	} else {
+		serial->attached = 1;
 	}
 
 	if (get_free_serial(serial, num_ports, &minor) == NULL) {
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -148,6 +148,7 @@ struct usb_serial {
 	struct usb_interface		*interface;
 	unsigned char			disconnected:1;
 	unsigned char			suspending:1;
+	unsigned char			attached:1;
 	unsigned char			minor;
 	unsigned char			num_ports;
 	unsigned char			num_port_pointers;


