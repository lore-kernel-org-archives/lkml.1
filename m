Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbZKFWhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbZKFWhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbZKFWWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:55 -0500
Received: from kroah.org ([198.145.64.141]:56832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbZKFWWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:52 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:44 2009
Message-Id: <20091106221543.922283323@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Elina Pasheva <epasheva@sierrawireless.com>
Subject: [39/99] USB: serial: sierra driver send_setup() autopm fix
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-sierra-driver-send_setup-autopm-fix.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Elina Pasheva <epasheva@sierrawireless.com>

commit 3c77d5137d3f4ff41721e9b4f4812db56a6065c0 upstream.

This patch presents a fix for the autosuspend feature implementation in
sierra usb serial driver for function sierra_send_setup().  Because it
is possible to call sierra_send_setup() before sierra_open() or after
sierra_close() we added a get/put interface activity to assure that the
usb control can happen even when the device is autosuspended.

Signed-off-by: Elina Pasheva <epasheva@sierrawireless.com>
Tested-by: Matthew Safar <msafar@sierrawireless.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -287,6 +287,8 @@ static int sierra_send_setup(struct usb_
 	struct sierra_port_private *portdata;
 	__u16 interface = 0;
 	int val = 0;
+	int do_send = 0;
+	int retval;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
@@ -305,10 +307,7 @@ static int sierra_send_setup(struct usb_
 		 */
 		if (port->interrupt_in_urb) {
 			/* send control message */
-			return usb_control_msg(serial->dev,
-				usb_rcvctrlpipe(serial->dev, 0),
-				0x22, 0x21, val, interface,
-				NULL, 0, USB_CTRL_SET_TIMEOUT);
+			do_send = 1;
 		}
 	}
 
@@ -320,12 +319,18 @@ static int sierra_send_setup(struct usb_
 			interface = 1;
 		else if (port->bulk_out_endpointAddress == 5)
 			interface = 2;
-		return usb_control_msg(serial->dev,
-			usb_rcvctrlpipe(serial->dev, 0),
-			0x22, 0x21, val, interface,
-			NULL, 0, USB_CTRL_SET_TIMEOUT);
+
+		do_send = 1;
 	}
-	return 0;
+	if (!do_send)
+		return 0;
+
+	usb_autopm_get_interface(serial->interface);
+	retval = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+		0x22, 0x21, val, interface, NULL, 0, USB_CTRL_SET_TIMEOUT);
+	usb_autopm_put_interface(serial->interface);
+
+	return retval;
 }
 
 static void sierra_set_termios(struct tty_struct *tty,


