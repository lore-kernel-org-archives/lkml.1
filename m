Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZFRCVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZFRCVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbZFRCU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:20:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:55097 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbZFRCU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:20:28 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/3] usb-serial: optimize sysrq function calls
Date: Wed, 17 Jun 2009 21:20:09 -0500
Message-Id: <1245291609-14871-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1245291609-14871-3-git-send-email-jason.wessel@windriver.com>
References: <1245291609-14871-1-git-send-email-jason.wessel@windriver.com>
 <1245291609-14871-2-git-send-email-jason.wessel@windriver.com>
 <1245291609-14871-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Jun 2009 02:20:16.0687 (UTC) FILETIME=[51C9C3F0:01C9EFBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have external function calls for the sysrq
functions.  The compiler can inline the sysrq calls such that they are
entirely a NOP if CONFIG_MAGIC_SYSRQ is not set.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/generic.c |   25 -------------------------
 include/linux/usb/serial.h   |   32 ++++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 82b8883..45515c0 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -535,31 +535,6 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 	}
 }
 
-int usb_serial_handle_sysrq_char(struct usb_serial_port *port, unsigned int ch)
-{
-	if (port->sysrq && port->console) {
-		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, tty_port_tty_get(&port->port));
-			port->sysrq = 0;
-			return 1;
-		}
-		port->sysrq = 0;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(usb_serial_handle_sysrq_char);
-
-int usb_serial_handle_break(struct usb_serial_port *port)
-{
-	if (!port->sysrq) {
-		port->sysrq = jiffies + HZ*5;
-		return 1;
-	}
-	port->sysrq = 0;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(usb_serial_handle_break);
-
 void usb_serial_generic_disconnect(struct usb_serial *serial)
 {
 	int i;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 44801d2..4601e0d 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -317,10 +317,6 @@ extern int usb_serial_generic_register(int debug);
 extern void usb_serial_generic_deregister(void);
 extern void usb_serial_generic_resubmit_read_urb(struct usb_serial_port *port,
 						 gfp_t mem_flags);
-extern int usb_serial_handle_sysrq_char(struct usb_serial_port *port,
-					unsigned int ch);
-extern int usb_serial_handle_break(struct usb_serial_port *port);
-
 
 extern int usb_serial_bus_register(struct usb_serial_driver *device);
 extern void usb_serial_bus_deregister(struct usb_serial_driver *device);
@@ -329,6 +325,34 @@ extern struct usb_serial_driver usb_serial_generic_device;
 extern struct bus_type usb_serial_bus_type;
 extern struct tty_driver *usb_serial_tty_driver;
 
+static inline int usb_serial_handle_sysrq_char(struct usb_serial_port *port,
+					       unsigned int ch)
+{
+#ifdef CONFIG_MAGIC_SYSRQ
+	if (port->sysrq && port->console) {
+		if (ch && time_before(jiffies, port->sysrq)) {
+			handle_sysrq(ch, tty_port_tty_get(&port->port));
+			port->sysrq = 0;
+			return 1;
+		}
+		port->sysrq = 0;
+	}
+#endif /* CONFIG_MAGIC_SYSRQ */
+	return 0;
+}
+
+static inline int usb_serial_handle_break(struct usb_serial_port *port)
+{
+#ifdef CONFIG_MAGIC_SYSRQ
+	if (!port->sysrq) {
+		port->sysrq = jiffies + HZ*5;
+		return 1;
+	}
+	port->sysrq = 0;
+#endif /* CONFIG_MAGIC_SYSRQ */
+	return 0;
+}
+
 static inline void usb_serial_debug_data(int debug,
 					 struct device *dev,
 					 const char *function, int size,
-- 
1.6.3.1.9.g95405b

