Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0CIG3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:29:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:33645 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0CIG3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:29:34 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 4/6] usb-serial: optimize sysrq function calls
Date: Tue,  9 Mar 2010 00:29:09 -0600
Message-Id: <1268116151-1448-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1268116151-1448-4-git-send-email-jason.wessel@windriver.com>
References: <1268116151-1448-1-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-2-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-3-git-send-email-jason.wessel@windriver.com>
 <1268116151-1448-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Mar 2010 06:29:26.0335 (UTC) FILETIME=[DD8704F0:01CABF51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to have external function calls for the sysrq
functions.  The compiler can inline the sysrq calls such that they are
entirely a NOP if CONFIG_MAGIC_SYSRQ is not set.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/usb/serial/generic.c |   26 --------------------------
 include/linux/usb/serial.h   |   34 +++++++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 4dea9d7..0cdfccb 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -553,32 +553,6 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 	}
 }
 
-int usb_serial_handle_sysrq_char(struct tty_struct *tty,
-			struct usb_serial_port *port, unsigned int ch)
-{
-	if (port->sysrq && port->port.console) {
-		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, tty);
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
 int usb_serial_generic_resume(struct usb_serial *serial)
 {
 	struct usb_serial_port *port;
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index b7682fe..60f8422 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -318,11 +318,6 @@ extern int usb_serial_generic_register(int debug);
 extern void usb_serial_generic_deregister(void);
 extern void usb_serial_generic_resubmit_read_urb(struct usb_serial_port *port,
 						 gfp_t mem_flags);
-extern int usb_serial_handle_sysrq_char(struct tty_struct *tty,
-					struct usb_serial_port *port,
-					unsigned int ch);
-extern int usb_serial_handle_break(struct usb_serial_port *port);
-
 
 extern int usb_serial_bus_register(struct usb_serial_driver *device);
 extern void usb_serial_bus_deregister(struct usb_serial_driver *device);
@@ -331,6 +326,35 @@ extern struct usb_serial_driver usb_serial_generic_device;
 extern struct bus_type usb_serial_bus_type;
 extern struct tty_driver *usb_serial_tty_driver;
 
+static inline int usb_serial_handle_sysrq_char(struct tty_struct *tty,
+					struct usb_serial_port *port,
+					unsigned int ch)
+{
+#ifdef CONFIG_MAGIC_SYSRQ
+	if (port->sysrq && port->port.console) {
+		if (ch && time_before(jiffies, port->sysrq)) {
+			handle_sysrq(ch, tty);
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

