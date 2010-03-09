Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab0CIG3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:29:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:33648 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab0CIG3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:29:34 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 5/6] usb-hcd,usb-console: poll hcd device to force usb console writes
Date: Tue,  9 Mar 2010 00:29:10 -0600
Message-Id: <1268116151-1448-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1268116151-1448-5-git-send-email-jason.wessel@windriver.com>
References: <1268116151-1448-1-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-2-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-3-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-4-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Mar 2010 06:29:28.0071 (UTC) FILETIME=[DE8FE970:01CABF51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to solve the problem that data is lost because there
are too many outstanding transmit urb's while trying to execute
printk's to a console.  The same is true if you try something like
"echo t > /proc/sysrq-trigger".

This patch takes the route of forcibly polling the hcd device to drain
the urb queue in order to initiate the bulk write call backs.  This
only happens if the device is a usb serial console device that sets
the max_in_flight_urbs to a non zero value in the serial device
structure.

A few millisecond penalty will get incurred to allow the hcd controller
to complete a write urb, else the console data is thrown away.

The max_in_flight_urbs was reduced in the usb_debug driver because it
is highly desired to push things out to the console in a timely
fashion and there is no need to have a queue that large for the
interrupt driven mode of operation when used through the tty
interface.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/core/hcd.c         |   11 ++++++++++
 drivers/usb/core/hcd.h         |    1 +
 drivers/usb/serial/console.c   |   43 ++++++++++++++++++++++++++--------------
 drivers/usb/serial/ftdi_sio.c  |    7 +++--
 drivers/usb/serial/pl2303.c    |    6 +++-
 drivers/usb/serial/usb_debug.c |    2 +-
 6 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 2f8cedd..3484446 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1973,6 +1973,7 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 	local_irq_restore(flags);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(usb_hcd_irq);
 
 /*-------------------------------------------------------------------------*/
 
@@ -2271,6 +2272,16 @@ usb_hcd_platform_shutdown(struct platform_device* dev)
 }
 EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
+void
+usb_hcd_poll_irq(struct usb_device *udev)
+{
+	struct usb_hcd *hcd;
+
+	hcd = bus_to_hcd(udev->bus);
+	usb_hcd_irq(0, hcd);
+}
+EXPORT_SYMBOL_GPL(usb_hcd_poll_irq);
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index a3cdb09..703f407 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -318,6 +318,7 @@ extern void usb_put_hcd(struct usb_hcd *hcd);
 extern int usb_add_hcd(struct usb_hcd *hcd,
 		unsigned int irqnum, unsigned long irqflags);
 extern void usb_remove_hcd(struct usb_hcd *hcd);
+extern void usb_hcd_poll_irq(struct usb_device *udev);
 
 struct platform_device;
 extern void usb_hcd_platform_shutdown(struct platform_device *dev);
diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 1ee6b2a..3786d75 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -19,6 +19,7 @@
 #include <linux/serial.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include "../core/hcd.h"
 
 static int debug;
 
@@ -197,13 +198,37 @@ static int usb_console_setup(struct console *co, char *options)
 	return retval;
 }
 
+static void usb_do_console_write(struct usb_serial *serial,
+				 struct usb_serial_port *port,
+				 const char *buf, unsigned count)
+{
+	int retval;
+	int loops = 100;
+try_again:
+	/* pass on to the driver specific version of this function if
+	   it is available */
+	if (serial->type->write)
+		retval = serial->type->write(NULL, port, buf, count);
+	else
+		retval = usb_serial_generic_write(NULL, port, buf, count);
+	if (retval < count && retval >= 0 &&
+	    serial->type->max_in_flight_urbs != 0 && loops--) {
+		/* poll the hcd device because the queue is full */
+		count -= retval;
+		buf += retval;
+		udelay(100);
+		usb_hcd_poll_irq(serial->dev);
+		goto try_again;
+	}
+	dbg("%s - return value : %d", __func__, retval);
+}
+
 static void usb_console_write(struct console *co,
 					const char *buf, unsigned count)
 {
 	static struct usbcons_info *info = &usbcons_info;
 	struct usb_serial_port *port = info->port;
 	struct usb_serial *serial;
-	int retval = -ENODEV;
 
 	if (!port || port->serial->dev->state == USB_STATE_NOTATTACHED)
 		return;
@@ -230,23 +255,11 @@ static void usb_console_write(struct console *co,
 				break;
 			}
 		}
-		/* pass on to the driver specific version of this function if
-		   it is available */
-		if (serial->type->write)
-			retval = serial->type->write(NULL, port, buf, i);
-		else
-			retval = usb_serial_generic_write(NULL, port, buf, i);
-		dbg("%s - return value : %d", __func__, retval);
+		usb_do_console_write(serial, port, buf, i);
 		if (lf) {
 			/* append CR after LF */
 			unsigned char cr = 13;
-			if (serial->type->write)
-				retval = serial->type->write(NULL,
-								port, &cr, 1);
-			else
-				retval = usb_serial_generic_write(NULL,
-								port, &cr, 1);
-			dbg("%s - return value : %d", __func__, retval);
+			usb_do_console_write(serial, port, &cr, 1);
 		}
 		buf += i;
 		count -= i;
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 95ec748..c7f559c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -53,6 +53,9 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman <greg@kroah.com>, Bill Ryder <bryder@sgi.com>, Kuba Ober <kuba@mareimbrium.org>, Andreas Mohr"
 #define DRIVER_DESC "USB FTDI Serial Converters Driver"
 
+/* number of outstanding urbs to prevent userspace DoS from happening */
+#define URB_UPPER_LIMIT	42
+
 static int debug;
 static __u16 vendor = FTDI_VID;
 static __u16 product;
@@ -838,6 +841,7 @@ static struct usb_serial_driver ftdi_sio_device = {
 	.ioctl =		ftdi_ioctl,
 	.set_termios =		ftdi_set_termios,
 	.break_ctl =		ftdi_break_ctl,
+	.max_in_flight_urbs =	URB_UPPER_LIMIT,
 };
 
 
@@ -848,9 +852,6 @@ static struct usb_serial_driver ftdi_sio_device = {
 #define HIGH 1
 #define LOW 0
 
-/* number of outstanding urbs to prevent userspace DoS from happening */
-#define URB_UPPER_LIMIT	42
-
 /*
  * ***************************************************************************
  * Utility functions
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1891cfb..2615fe1 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -453,8 +453,9 @@ static void pl2303_send(struct usb_serial_port *port)
 	port->write_urb->transfer_buffer_length = count;
 	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
 	if (result) {
-		dev_err(&port->dev, "%s - failed submitting write urb,"
-			" error %d\n", __func__, result);
+		if (!(port->port.console))
+			dev_err(&port->dev, "%s - failed submitting write urb,"
+				" error %d\n", __func__, result);
 		priv->write_urb_in_use = 0;
 		/* TODO: reschedule pl2303_send */
 	}
@@ -1185,6 +1186,7 @@ static struct usb_serial_driver pl2303_device = {
 	.chars_in_buffer =	pl2303_chars_in_buffer,
 	.attach =		pl2303_startup,
 	.release =		pl2303_release,
+	.max_in_flight_urbs =	-1,
 };
 
 static int __init pl2303_init(void)
diff --git a/drivers/usb/serial/usb_debug.c b/drivers/usb/serial/usb_debug.c
index 252cc2d..4a04552 100644
--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -15,7 +15,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-#define URB_DEBUG_MAX_IN_FLIGHT_URBS	4000
+#define URB_DEBUG_MAX_IN_FLIGHT_URBS	42
 #define USB_DEBUG_MAX_PACKET_SIZE	8
 #define USB_DEBUG_BRK_SIZE		8
 static char USB_DEBUG_BRK[USB_DEBUG_BRK_SIZE] = {
-- 
1.6.3.1.9.g95405b

