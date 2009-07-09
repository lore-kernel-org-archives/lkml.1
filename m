Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbZGIMgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbZGIMgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbZGIMgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:36:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38062 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757708AbZGIMgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:36:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/3] tty: Fix USB kref leak
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 13:36:22 +0100
Message-ID: <20090709123602.15654.51161.stgit@localhost.localdomain>
In-Reply-To: <20090709123301.15654.4698.stgit@localhost.localdomain>
References: <20090709123301.15654.4698.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The sysrq code acquired a kref leak. Fix it by passing the tty separately
from the caller (thus effectively using the callers kref which all the
callers hold anyway)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/ftdi_sio.c |    2 +-
 drivers/usb/serial/generic.c  |    7 ++++---
 drivers/usb/serial/pl2303.c   |    2 +-
 include/linux/usb/serial.h    |    3 ++-
 4 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3dc3768..5f08702 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2121,7 +2121,7 @@ static void ftdi_process_read(struct work_struct *work)
 				/* Note that the error flag is duplicated for
 				   every character received since we don't know
 				   which character it applied to */
-				if (!usb_serial_handle_sysrq_char(port,
+				if (!usb_serial_handle_sysrq_char(tty, port,
 						data[packet_offset + i]))
 					tty_insert_flip_char(tty,
 						data[packet_offset + i],
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index e9aa7a4..21dd6e7 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -432,7 +432,7 @@ static void flush_and_resubmit_read_urb(struct usb_serial_port *port)
 	else {	
 		/* Push data to tty */
 		for (i = 0; i < urb->actual_length; i++, ch++) {
-			if (!usb_serial_handle_sysrq_char(port, *ch))
+			if (!usb_serial_handle_sysrq_char(tty, port, *ch))
 				tty_insert_flip_char(tty, *ch, TTY_NORMAL);
 		}
 	}
@@ -534,11 +534,12 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 	}
 }
 
-int usb_serial_handle_sysrq_char(struct usb_serial_port *port, unsigned int ch)
+int usb_serial_handle_sysrq_char(struct tty_struct *tty,
+			struct usb_serial_port *port, unsigned int ch)
 {
 	if (port->sysrq && port->console) {
 		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, tty_port_tty_get(&port->port));
+			handle_sysrq(ch, tty);
 			port->sysrq = 0;
 			return 1;
 		}
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index ec6c132..8835802 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -1038,7 +1038,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 		if (line_status & UART_OVERRUN_ERROR)
 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 		for (i = 0; i < urb->actual_length; ++i)
-			if (!usb_serial_handle_sysrq_char(port, data[i]))
+			if (!usb_serial_handle_sysrq_char(tty, port, data[i]))
 				tty_insert_flip_char(tty, data[i], tty_flag);
 		tty_flip_buffer_push(tty);
 	}
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 44801d2..0ec50ba 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -317,7 +317,8 @@ extern int usb_serial_generic_register(int debug);
 extern void usb_serial_generic_deregister(void);
 extern void usb_serial_generic_resubmit_read_urb(struct usb_serial_port *port,
 						 gfp_t mem_flags);
-extern int usb_serial_handle_sysrq_char(struct usb_serial_port *port,
+extern int usb_serial_handle_sysrq_char(struct tty_struct *tty,
+					struct usb_serial_port *port,
 					unsigned int ch);
 extern int usb_serial_handle_break(struct usb_serial_port *port);
 

