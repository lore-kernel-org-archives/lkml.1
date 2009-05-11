Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbZEKU1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbZEKU1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbZEKUZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:25:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:52625 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305AbZEKUZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:25:18 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/4] usb_debug,usb_generic_serial: implement sysrq and serial break
Date: Mon, 11 May 2009 15:24:09 -0500
Message-Id: <1242073450-3794-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1242073450-3794-3-git-send-email-jason.wessel@windriver.com>
References: <1242073450-3794-1-git-send-email-jason.wessel@windriver.com>
 <1242073450-3794-2-git-send-email-jason.wessel@windriver.com>
 <1242073450-3794-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 May 2009 20:25:07.0762 (UTC) FILETIME=[93651920:01C9D276]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb_debug driver was modified to implement serial break handling
by using a "magic" data packet comprised of the sequence:

       0x00 0xff 0x01 0xfe   0x00 0xfe 0x01 0xff

When the tty layer requests a serial break the usb_debug driver sends
the magic packet.  On the receiving side the magic packet is thrown
away or a sysrq is activated depending on what kernel .config options
have been set.

The generic serial driver was modified as well as the usb serial
headers to generically implement sysrq processing in the same way the
non usb uart based drivers implement the sysrq handling.  This will
allow other usb serial devices to implement sysrq handling as desired.

The new usb serial functions are named similarly and implemented
similarly to the uart functions as follows:

usb_serial_handle_break <-> uart_handle_break
usb_serial_handle_sysrq_char <-> uart_handle_sysrq_char

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/Kconfig     |    7 +++++++
 drivers/usb/serial/generic.c   |   30 ++++++++++++++++++------------
 drivers/usb/serial/usb_debug.c |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/usb/serial.h     |   34 ++++++++++++++++++++++++++++++++--
 4 files changed, 96 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index c480ea4..3229321 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -42,6 +42,13 @@ config USB_SERIAL_CONSOLE
 
 	  If unsure, say N.
 
+config USB_SERIAL_SYSRQ
+       bool "Support inbound sysrq"
+       depends on USB_SERIAL_CONSOLE && MAGIC_SYSRQ
+       help
+         Say y here to enable support for sysrq if the usb serial
+         driver implements support for sysrq.
+
 config USB_EZUSB
 	bool "Functions for loading firmware on EZUSB chips"
 	help
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 6a1b45d..534d84d 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -352,7 +352,9 @@ int usb_serial_generic_write_room(struct tty_struct *tty)
 	spin_lock_irqsave(&port->lock, flags);
 	if (serial->type->max_in_flight_urbs) {
 		if (port->urbs_in_flight < serial->type->max_in_flight_urbs)
-			room = port->bulk_out_size;
+			room = port->bulk_out_size *
+				(serial->type->max_in_flight_urbs -
+				 port->urbs_in_flight);
 	} else if (serial->num_bulk_out && !(port->write_urb_busy)) {
 		room = port->bulk_out_size;
 	}
@@ -386,7 +388,8 @@ int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 }
 
 
-static void resubmit_read_urb(struct usb_serial_port *port, gfp_t mem_flags)
+void usb_serial_generic_resubmit_read_urb(struct usb_serial_port *port,
+			gfp_t mem_flags)
 {
 	struct urb *urb = port->read_urb;
 	struct usb_serial *serial = port->serial;
@@ -407,25 +410,28 @@ static void resubmit_read_urb(struct usb_serial_port *port, gfp_t mem_flags)
 			"%s - failed resubmitting read urb, error %d\n",
 							__func__, result);
 }
+EXPORT_SYMBOL_GPL(usb_serial_generic_resubmit_read_urb);
 
 /* Push data to tty layer and resubmit the bulk read URB */
 static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
 {
 	struct urb *urb = port->read_urb;
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
-	int room;
+	char *ch = (char *)urb->transfer_buffer;
+	int i;
+
+	if (!tty)
+		goto done;
 
 	/* Push data to tty */
-	if (tty && urb->actual_length) {
-		room = tty_buffer_request_room(tty, urb->actual_length);
-		if (room) {
-			tty_insert_flip_string(tty, urb->transfer_buffer, room);
-			tty_flip_buffer_push(tty);
-		}
+	for (i = 0; i < urb->actual_length; i++, ch++) {
+		if (!usb_serial_handle_sysrq_char(port, *ch))
+			tty_insert_flip_char(tty, *ch, TTY_NORMAL);
 	}
+	tty_flip_buffer_push(tty);
 	tty_kref_put(tty);
-
-	resubmit_read_urb(port, GFP_ATOMIC);
+done:
+	usb_serial_generic_resubmit_read_urb(port, GFP_ATOMIC);
 }
 
 void usb_serial_generic_read_bulk_callback(struct urb *urb)
@@ -516,7 +522,7 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 
 	if (was_throttled) {
 		/* Resume reading from device */
-		resubmit_read_urb(port, GFP_KERNEL);
+		usb_serial_generic_resubmit_read_urb(port, GFP_KERNEL);
 	}
 }
 
diff --git a/drivers/usb/serial/usb_debug.c b/drivers/usb/serial/usb_debug.c
index 157a6e2..f1878c2 100644
--- a/drivers/usb/serial/usb_debug.c
+++ b/drivers/usb/serial/usb_debug.c
@@ -17,6 +17,17 @@
 
 #define URB_DEBUG_MAX_IN_FLIGHT_URBS	4000
 #define USB_DEBUG_MAX_PACKET_SIZE	8
+#define USB_DEBUG_BRK_SIZE		8
+static char USB_DEBUG_BRK[USB_DEBUG_BRK_SIZE] = {
+	0x00,
+	0xff,
+	0x01,
+	0xfe,
+	0x00,
+	0xfe,
+	0x01,
+	0xff,
+};
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x0525, 0x127a) },
@@ -39,6 +50,32 @@ static int usb_debug_open(struct tty_struct *tty, struct usb_serial_port *port,
 	return usb_serial_generic_open(tty, port, filp);
 }
 
+/* This HW really does not support a serial break, so one will be
+ * emulated when ever the break state is set to true.
+ */
+static void usb_debug_break_ctl(struct tty_struct *tty, int break_state)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	if (!break_state)
+		return;
+	usb_serial_generic_write(tty, port, USB_DEBUG_BRK, USB_DEBUG_BRK_SIZE);
+}
+
+static void usb_debug_read_bulk_callback(struct urb *urb)
+{
+	struct usb_serial_port *port = urb->context;
+
+	if (urb->actual_length == USB_DEBUG_BRK_SIZE &&
+	    memcmp(urb->transfer_buffer, USB_DEBUG_BRK,
+		   USB_DEBUG_BRK_SIZE) == 0) {
+		usb_serial_handle_break(port);
+		usb_serial_generic_resubmit_read_urb(port, GFP_ATOMIC);
+		return;
+	}
+
+	usb_serial_generic_read_bulk_callback(urb);
+}
+
 static struct usb_serial_driver debug_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -48,6 +85,8 @@ static struct usb_serial_driver debug_device = {
 	.num_ports =		1,
 	.open =			usb_debug_open,
 	.max_in_flight_urbs = URB_DEBUG_MAX_IN_FLIGHT_URBS,
+	.break_ctl =			usb_debug_break_ctl,
+	.read_bulk_callback =		usb_debug_read_bulk_callback,
 };
 
 static int __init debug_init(void)
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 5cacba1..6ee63e8 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -15,6 +15,7 @@
 
 #include <linux/kref.h>
 #include <linux/mutex.h>
+#include <linux/sysrq.h>
 
 #define SERIAL_TTY_MAJOR	188	/* Nice legal number now */
 #define SERIAL_TTY_MINORS	254	/* loads of devices :) */
@@ -99,6 +100,9 @@ struct usb_serial_port {
 	char			throttled;
 	char			throttle_req;
 	char			console;
+#ifdef CONFIG_USB_SERIAL_SYSRQ
+	unsigned long		sysrq; /* sysrq timeout */
+#endif /* CONFIG_USB_SERIAL_SYSRQ */
 	struct device		dev;
 };
 #define to_usb_serial_port(d) container_of(d, struct usb_serial_port, dev)
@@ -299,6 +303,8 @@ extern void usb_serial_generic_unthrottle(struct tty_struct *tty);
 extern void usb_serial_generic_shutdown(struct usb_serial *serial);
 extern int usb_serial_generic_register(int debug);
 extern void usb_serial_generic_deregister(void);
+void usb_serial_generic_resubmit_read_urb(struct usb_serial_port *port,
+			gfp_t mem_flags);
 
 extern int usb_serial_bus_register(struct usb_serial_driver *device);
 extern void usb_serial_bus_deregister(struct usb_serial_driver *device);
@@ -332,7 +338,31 @@ static inline void usb_serial_debug_data(int debug,
 				## arg); \
 	} while (0)
 
-
-
+static inline int
+usb_serial_handle_sysrq_char(struct usb_serial_port *port, unsigned int ch)
+{
+#ifdef CONFIG_USB_SERIAL_SYSRQ
+	if (port->sysrq) {
+		if (ch && time_before(jiffies, port->sysrq)) {
+			handle_sysrq(ch, tty_port_tty_get(&port->port));
+			port->sysrq = 0;
+			return 1;
+		}
+		port->sysrq = 0;
+	}
+#endif /* CONFIG_USB_SERIAL_SYSRQ */
+	return 0;
+}
+static inline int usb_serial_handle_break(struct usb_serial_port *port)
+{
+#ifdef CONFIG_USB_SERIAL_SYSRQ
+	if (!port->sysrq) {
+		port->sysrq = jiffies + HZ*5;
+		return 1;
+	}
+	port->sysrq = 0;
+#endif /* CONFIG_USB_SERIAL_SYSRQ */
+	return 0;
+}
 #endif /* __LINUX_USB_SERIAL_H */
 
-- 
1.6.3.rc0.1.gf800

