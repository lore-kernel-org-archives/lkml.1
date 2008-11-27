Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYK0I34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYK0I34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 03:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYK0I3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 03:29:47 -0500
Received: from home.keithp.com ([63.227.221.253]:34390 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYK0I3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:29:46 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Keith Packard <keithp@keithp.com>
Subject: [PATCH] usb/serial: Add compat_ioctl pass-through
Date: Thu, 27 Nov 2008 00:29:35 -0800
Message-Id: <1227774576-5503-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB serial devices with extended IOCTLs cannot be used in a 64-bit kernel
from 32-bit user space as the compat_ioctl path is missing. This adds a
pass-through so that drivers may offer this functionality. This requires
that all drivers actually implement a compat_ioctl function if they want to
support this operation.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/usb/serial/usb-serial.c |   22 ++++++++++++++++++++++
 include/linux/usb/serial.h      |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 794b5ff..8fb4e13 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -381,6 +381,27 @@ static int serial_ioctl(struct tty_struct *tty, struct file *file,
 	return retval;
 }
 
+static long serial_compat_ioctl(struct tty_struct *tty, struct file *file,
+			       unsigned int cmd, unsigned long arg)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	long retval = -ENODEV;
+
+	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
+
+	WARN_ON(!port->port.count);
+
+	/* pass on to the driver specific version of this function
+	   if it is available */
+	if (port->serial->type->compat_ioctl) {
+		lock_kernel();
+		retval = port->serial->type->compat_ioctl(tty, file, cmd, arg);
+		unlock_kernel();
+	} else
+		retval = -ENOIOCTLCMD;
+	return retval;
+}
+
 static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1095,6 +1116,7 @@ static const struct tty_operations serial_ops = {
 	.write =		serial_write,
 	.write_room =		serial_write_room,
 	.ioctl =		serial_ioctl,
+	.compat_ioctl =		serial_compat_ioctl,
 	.set_termios =		serial_set_termios,
 	.throttle =		serial_throttle,
 	.unthrottle =		serial_unthrottle,
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 0b8617a..c15766a 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -228,6 +228,8 @@ struct usb_serial_driver {
 	int  (*write_room)(struct tty_struct *tty);
 	int  (*ioctl)(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg);
+	long  (*compat_ioctl)(struct tty_struct *tty, struct file *file,
+			      unsigned int cmd, unsigned long arg);
 	void (*set_termios)(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 	void (*break_ctl)(struct tty_struct *tty, int break_state);
-- 
1.5.6.5

