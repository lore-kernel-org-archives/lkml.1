Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYK1W2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYK1W2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 17:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYK1W2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 17:28:11 -0500
Received: from home.keithp.com ([63.227.221.253]:54587 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbYK1W2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 17:28:10 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Keith Packard <keithp@keithp.com>
Subject: [PATCH] usb/serial: Add compat_ioctl pass-through
Date: Fri, 28 Nov 2008 14:28:02 -0800
Message-Id: <1227911282-8857-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <200811281642.52637.arnd@arndb.de>
References: <200811281642.52637.arnd@arndb.de>
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
 drivers/usb/serial/usb-serial.c |   20 ++++++++++++++++++++
 include/linux/usb/serial.h      |    4 ++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 794b5ff..c83a9f0 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -381,6 +381,25 @@ static int serial_ioctl(struct tty_struct *tty, struct file *file,
 	return retval;
 }
 
+static int serial_compat_ioctl(struct tty_struct *tty, struct file *file,
+			       unsigned int cmd, unsigned long arg)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	int retval = -ENODEV;
+
+	dbg("%s - port %d, cmd 0x%.4x", __func__, port->number, cmd);
+
+	WARN_ON(!port->port.count);
+
+	/* pass on to the driver specific version of this function
+	   if it is available */
+	if (port->serial->type->compat_ioctl) {
+		retval = port->serial->type->compat_ioctl(tty, file, cmd, arg);
+	} else
+		retval = -ENOIOCTLCMD;
+	return retval;
+}
+
 static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -1095,6 +1114,7 @@ static const struct tty_operations serial_ops = {
 	.write =		serial_write,
 	.write_room =		serial_write_room,
 	.ioctl =		serial_ioctl,
+	.compat_ioctl =		serial_compat_ioctl,
 	.set_termios =		serial_set_termios,
 	.throttle =		serial_throttle,
 	.unthrottle =		serial_unthrottle,
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 0b8617a..02c4080 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -226,8 +226,12 @@ struct usb_serial_driver {
 			const unsigned char *buf, int count);
 	/* Called only by the tty layer */
 	int  (*write_room)(struct tty_struct *tty);
+	/* Called with bkl held */
 	int  (*ioctl)(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg);
+	/* Called without bkl held */
+	int  (*compat_ioctl)(struct tty_struct *tty, struct file *file,
+			     unsigned int cmd, unsigned long arg);
 	void (*set_termios)(struct tty_struct *tty,
 			struct usb_serial_port *port, struct ktermios *old);
 	void (*break_ctl)(struct tty_struct *tty, int break_state);
-- 
1.5.6.5

