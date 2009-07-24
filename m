Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZGXQLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZGXQLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZGXQLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:11:22 -0400
Received: from SXT-SM-1.UCIS.Dal.Ca ([129.173.5.72]:55912 "EHLO
	sxt-sm-1.ucis.dal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZGXQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:11:21 -0400
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 12:11:21 EDT
Message-ID: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
Date: Fri, 24 Jul 2009 12:48:03 -0300
From: Trevor Pace <tr212206@DAL.CA>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Removed useless retval variables in usb-serial.c
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.0.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed useless return value variables.

Signed-off By: Trevor Pace <trevor.pace@dal.ca>

================================================================================

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index bd7581b..faec1d1 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -362,10 +362,9 @@ static int serial_write(struct tty_struct *tty, const
unsigned char *buf,
 								int count)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	int retval = -ENODEV;

 	if (port->serial->dev->state == USB_STATE_NOTATTACHED)
-		goto exit;
+		return -ENODEV;

 	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);

@@ -374,10 +373,7 @@ static int serial_write(struct tty_struct *tty, const
unsigned char *buf,
 	WARN_ON(!port->port.count);

 	/* pass on to the driver specific version of this function */
-	retval = port->serial->type->write(tty, port, buf, count);
-
-exit:
-	return retval;
+	return port->serial->type->write(tty, port, buf, count);
 }

 static int serial_write_room(struct tty_struct *tty)
@@ -429,7 +425,6 @@ static int serial_ioctl(struct tty_struct *tty, struct file
*file,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	int retval = -ENODEV;

 	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);

@@ -437,11 +432,9 @@ static int serial_ioctl(struct tty_struct *tty, struct file
*file,

 	/* pass on to the driver specific version of this function
 	   if it is available */
-	if (port->serial->type->ioctl) {
-		retval = port->serial->type->ioctl(tty, file, cmd, arg);
-	} else
-		retval = -ENOIOCTLCMD;
-	return retval;
+	if (port->serial->type->ioctl)
+		return port->serial->type->ioctl(tty, file, cmd, arg);
+        return -ENOIOCTLCMD;
 }

 static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
@@ -1174,7 +1167,7 @@ int usb_serial_suspend(struct usb_interface *intf,
pm_message_t message)
 {
 	struct usb_serial *serial = usb_get_intfdata(intf);
 	struct usb_serial_port *port;
-	int i, r = 0;
+	int i;

 	serial->suspending = 1;

@@ -1185,24 +1178,21 @@ int usb_serial_suspend(struct usb_interface *intf,
pm_message_t message)
 	}

 	if (serial->type->suspend)
-		r = serial->type->suspend(serial, message);
+		return serial->type->suspend(serial, message);

-	return r;
+	return 0;
 }
 EXPORT_SYMBOL(usb_serial_suspend);

 int usb_serial_resume(struct usb_interface *intf)
 {
 	struct usb_serial *serial = usb_get_intfdata(intf);
-	int rv;

 	serial->suspending = 0;
-	if (serial->type->resume)
-		rv = serial->type->resume(serial);
-	else
-		rv = usb_serial_generic_resume(serial);

-	return rv;
+	return (serial->type->resume)
+		? serial->type->resume(serial)
+		: usb_serial_generic_resume(serial);
 }
 EXPORT_SYMBOL(usb_serial_resume);

