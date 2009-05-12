Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbZELWct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbZELWct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZELWcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:32:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:57581 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZELWcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:32:35 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, oliver@neukum.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/2] usb hcd: poll hcd device to force writes
Date: Tue, 12 May 2009 17:32:19 -0500
Message-Id: <1242167540-23585-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.9.g6345d
In-Reply-To: <1242167540-23585-1-git-send-email-jason.wessel@windriver.com>
References: <1242167540-23585-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 May 2009 22:32:24.0518 (UTC) FILETIME=[85AB5660:01C9D351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem that this patch tries to solve is that data is lost
because there are too many outstanding transmit urb's while trying to
execute printk's to a console.  The same is true if you try something
like "echo t > /proc/sysrq-trigger".

This patch takes the route of forcibly polling the hcd device to drain
the urb queue in order to initiate the bulk write call backs.  This
only happens if the device is a usb serial console device that sets
the max_in_flight_urbs in the serial device structure.

A maximum 3 ms penalty will get incurred to allow the hcd controller
to complete a write urb, else the console data is thrown away.

The max_in_flight_urbs was reduced in the usb_debug driver because it
is highly desired to push things out to the console in a timely
fashion and there is no need to have a queue that large for the
interrupt driven mode of operation when used through the tty
interface.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/core/hcd.c         |   15 +++++++++++++
 drivers/usb/core/hcd.h         |    1 +
 drivers/usb/serial/console.c   |   44 ++++++++++++++++++++++++++-------------
 drivers/usb/serial/ftdi_sio.c  |    7 +++--
 drivers/usb/serial/usb_debug.c |    2 +-
 5 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 42b93da..ca15008 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1760,6 +1760,7 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 	local_irq_restore(flags);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(usb_hcd_irq);
 
 /*-------------------------------------------------------------------------*/
 
@@ -2045,6 +2046,20 @@ usb_hcd_platform_shutdown(struct platform_device* dev)
 }
 EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
+void
+usb_hcd_poll_urb_irq(struct urb *urb)
+{
+	struct usb_hcd *hcd;
+
+	if (!urb)
+		return;
+
+	hcd = bus_to_hcd(urb->dev->bus);
+	if (hcd)
+		usb_hcd_irq(0, hcd);
+}
+EXPORT_SYMBOL_GPL(usb_hcd_poll_urb_irq);
+
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index e7d4479..30e0373 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -251,6 +251,7 @@ extern void usb_put_hcd(struct usb_hcd *hcd);
 extern int usb_add_hcd(struct usb_hcd *hcd,
 		unsigned int irqnum, unsigned long irqflags);
 extern void usb_remove_hcd(struct usb_hcd *hcd);
+extern void usb_hcd_poll_urb_irq(struct urb *urb);
 
 struct platform_device;
 extern void usb_hcd_platform_shutdown(struct platform_device *dev);
diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 19e2404..ca05e9d 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -18,6 +18,7 @@
 #include <linux/console.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include "../core/hcd.h"
 
 static int debug;
 
@@ -185,13 +186,38 @@ reset_open_count:
 goto out;
 }
 
+static void usb_do_console_write(struct usb_serial *serial,
+				 struct usb_serial_port *port,
+				 const char *buf, unsigned count)
+{
+	int retval;
+	int loops = 3;
+try_again:
+	/* pass on to the driver specific version of this function if
+	   it is available */
+	if (serial->type->write)
+		retval = serial->type->write(NULL, port, buf, count);
+	else
+		retval = usb_serial_generic_write(NULL, port, buf, count);
+	if (serial->type->max_in_flight_urbs && loops-- &&
+	    retval >= 0 && retval < count) {
+		/* poll the hcd device because the queue is full and
+		 * try this for a total of 3 ms and give up. */
+		count -= retval;
+		buf += retval;
+		mdelay(1);
+		usb_hcd_poll_urb_irq(port->read_urb);
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
@@ -218,23 +244,11 @@ static void usb_console_write(struct console *co,
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
index a93b76a..a552751 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -51,6 +51,9 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman <greg@kroah.com>, Bill Ryder <bryder@sgi.com>, Kuba Ober <kuba@mareimbrium.org>"
 #define DRIVER_DESC "USB FTDI Serial Converters Driver"
 
+/* number of outstanding urbs to prevent userspace DoS from happening */
+#define URB_UPPER_LIMIT	42
+
 static int debug;
 static __u16 vendor = FTDI_VID;
 static __u16 product;
@@ -771,6 +774,7 @@ static struct usb_serial_driver ftdi_sio_device = {
 	.set_termios =		ftdi_set_termios,
 	.break_ctl =		ftdi_break_ctl,
 	.shutdown =		ftdi_shutdown,
+	.max_in_flight_urbs =	URB_UPPER_LIMIT,
 };
 
 
@@ -781,9 +785,6 @@ static struct usb_serial_driver ftdi_sio_device = {
 #define HIGH 1
 #define LOW 0
 
-/* number of outstanding urbs to prevent userspace DoS from happening */
-#define URB_UPPER_LIMIT	42
-
 /*
  * ***************************************************************************
  * Utility functions
diff --git a/drivers/usb/serial/usb_debug.c b/drivers/usb/serial/usb_debug.c
index 6148009..d33df1c 100644
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
1.6.3.9.g6345d

