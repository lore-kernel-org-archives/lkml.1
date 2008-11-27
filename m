Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYK0IaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYK0IaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 03:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYK0I3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 03:29:49 -0500
Received: from home.keithp.com ([63.227.221.253]:34396 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYK0I3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:29:48 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Keith Packard <keithp@keithp.com>
Subject: [PATCH] usb/serial/cp2101: Add support for cp2103 GPIO pins
Date: Thu, 27 Nov 2008 00:29:36 -0800
Message-Id: <1227774576-5503-2-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227774576-5503-1-git-send-email-keithp@keithp.com>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cp2103 is programmed the same as the cp2101/cp2102 except for the
addition of a set of four GPIO pins which can be directly controlled by the
host. Access to this is done through a custom ioctl.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/usb/serial/cp2101.c |   97 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/cp2101.h |   39 +++++++++++++++++
 2 files changed, 135 insertions(+), 1 deletions(-)
 create mode 100644 drivers/usb/serial/cp2101.h

diff --git a/drivers/usb/serial/cp2101.c b/drivers/usb/serial/cp2101.c
index 8008d0b..d0b96aa 100644
--- a/drivers/usb/serial/cp2101.c
+++ b/drivers/usb/serial/cp2101.c
@@ -28,11 +28,13 @@
 #include <linux/uaccess.h>
 #include <linux/usb/serial.h>
 
+#include "cp2101.h"
+
 /*
  * Version Information
  */
 #define DRIVER_VERSION "v0.07"
-#define DRIVER_DESC "Silicon Labs CP2101/CP2102 RS232 serial adaptor driver"
+#define DRIVER_DESC "Silicon Labs CP2101/CP2102/CP2103 RS232 serial adaptor driver"
 
 /*
  * Function Prototypes
@@ -42,6 +44,10 @@ static int cp2101_open(struct tty_struct *, struct usb_serial_port *,
 static void cp2101_cleanup(struct usb_serial_port *);
 static void cp2101_close(struct tty_struct *, struct usb_serial_port *,
 							struct file*);
+static int cp2101_ioctl(struct tty_struct *, struct file *,
+			unsigned int cmd, unsigned long arg);
+static long cp2101_compat_ioctl32(struct tty_struct *, struct file *,
+				 unsigned int cmd, unsigned long arg);
 static void cp2101_get_termios(struct tty_struct *);
 static void cp2101_set_termios(struct tty_struct *, struct usb_serial_port *,
 							struct ktermios*);
@@ -52,6 +58,8 @@ static void cp2101_break_ctl(struct tty_struct *, int);
 static int cp2101_startup(struct usb_serial *);
 static void cp2101_shutdown(struct usb_serial *);
 
+static int cp210x_gpioget(struct usb_serial_port *port, u8* gpio);
+static int cp210x_gpioset(struct usb_serial_port *port, uint16_t arg);
 
 static int debug;
 
@@ -120,6 +128,8 @@ static struct usb_serial_driver cp2101_device = {
 	.open			= cp2101_open,
 	.close			= cp2101_close,
 	.break_ctl		= cp2101_break_ctl,
+	.ioctl			= cp2101_ioctl,
+	.compat_ioctl		= cp2101_compat_ioctl32,
 	.set_termios		= cp2101_set_termios,
 	.tiocmget 		= cp2101_tiocmget,
 	.tiocmset		= cp2101_tiocmset,
@@ -364,6 +374,45 @@ static void cp2101_close(struct tty_struct *tty, struct usb_serial_port *port,
 	mutex_unlock(&port->serial->disc_mutex);
 }
 
+static int cp2101_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	int ret;
+	u8 gpio_get;
+	u16 gpio_set;
+
+	switch(cmd) {
+	case CP2101_IOCTL_GPIOGET:
+		ret = cp210x_gpioget(port, &gpio_get);
+		if (ret < 0)
+			return ret;
+		if (copy_to_user((void __user*)arg,
+				 &gpio_get,
+				 sizeof(__u8)))
+			return -EFAULT;
+		return 0;
+
+	case CP2101_IOCTL_GPIOSET:
+		if (copy_from_user(&gpio_set,
+				   (void __user *)arg,
+				   sizeof(__u16)))
+			return -EFAULT;
+		ret = cp210x_gpioset(port, gpio_set);
+		if (ret < 0)
+			return ret;
+		return 0;
+
+	}
+	return -ENOIOCTLCMD;
+}
+
+static long cp2101_compat_ioctl32(struct tty_struct *tty, struct file *file,
+				  unsigned int cmd, unsigned long arg)
+{
+	return (long) cp2101_ioctl(tty, file, cmd, arg);
+}
+
 /*
  * cp2101_get_termios
  * Reads the baud rate, data bits, parity, stop bits and flow control mode
@@ -719,6 +768,52 @@ static void cp2101_break_ctl (struct tty_struct *tty, int break_state)
 	cp2101_set_config(port, CP2101_BREAK, &state, 2);
 }
 
+/*
+ * cp2101_ctlmsg
+ * A generic usb control message interface.
+ * Returns the actual size of the data read or written within the message, 0
+ * if no data were read or written, or a negative value to indicate an error.
+ */
+static int cp2101_ctlmsg(struct usb_serial_port* port, u8 request,
+		u8 requestype, u16 value, u16 index, void* data, u16 size)
+{
+	struct usb_device *dev = port->serial->dev;
+	u8 *tbuf;
+	int ret;
+
+	if (!(tbuf = kmalloc(size, GFP_KERNEL))) {
+		return -ENOMEM;
+	}
+
+	if (requestype & 0x80) {
+		ret = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), request,
+				requestype, value, index, tbuf, size, 300);
+
+		if (ret > 0 && size)
+			memcpy(data, tbuf, size);
+	} else {
+		if (size)
+			memcpy(tbuf, data, size);
+
+		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0), request,
+				requestype, value, index, tbuf, size, 300);
+	}
+	kfree(tbuf);
+	return ret;
+}
+
+/* Get current GPIO status */
+static int cp210x_gpioget(struct usb_serial_port *port, u8* gpio)
+{
+	return cp2101_ctlmsg(port, 0xff, 0xc0, 0x00c2, 0, gpio, 1);
+}
+
+/* Set all gpio simultaneously */
+static int cp210x_gpioset(struct usb_serial_port *port, uint16_t arg)
+{
+	return cp2101_ctlmsg(port, 0xff, 0x40, 0x37e1, arg, 0, 0);
+}
+
 static int cp2101_startup(struct usb_serial *serial)
 {
 	/* CP2101 buffers behave strangely unless device is reset */
diff --git a/drivers/usb/serial/cp2101.h b/drivers/usb/serial/cp2101.h
new file mode 100644
index 0000000..713c332
--- /dev/null
+++ b/drivers/usb/serial/cp2101.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright © 2008 Keith Packard <keithp@keithp.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#ifndef _CP2101_H_
+#define _CP2101_H_
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/* Write GPIO register */
+#define CP2101_REQTYPE_HOST_TO_DEVICE	0x40
+
+/* Read GPIO register */
+#define CP2101_REQTYPE_DEVICE_TO_HOST	0xc0
+
+#define CP2101_IOCTL_GPIOGET	_IOR('C', 1, unsigned char)
+#define CP2101_IOCTL_GPIOSET	_IOW('C', 2, unsigned short)
+
+#define CP2101_GPIO_MASK(bit)			(1 << (bit))
+#define CP2101_GPIO_VALUE(bit)			(0x100 << (bit))
+
+#define CP2101_GPIO_SET(bit,value)	((1 << (bit)) | ((value & 1) << ((bit) + 8)))
+
+#endif /* _CP2101_H_ */
-- 
1.5.6.5

