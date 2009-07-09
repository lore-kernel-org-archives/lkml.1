Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbZGIMhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbZGIMhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760163AbZGIMhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:37:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38066 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758558AbZGIMhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:37:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/3] tty: Fix the PL2303 private methods for sysrq
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 13:36:58 +0100
Message-ID: <20090709123627.15654.3707.stgit@localhost.localdomain>
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

PL2303 has private data shovelling methods that also have no fast path. Fix
them to work the same way as the default handler.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/pl2303.c |   58 ++++++++++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 25 deletions(-)


diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 8835802..39cf3b4 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -971,18 +971,46 @@ exit:
 			__func__, retval);
 }
 
+static void pl2303_push_data(struct tty_struct *tty,
+		struct usb_serial_port *port, struct urb *urb,
+		u8 line_status)
+{
+	unsigned char *data = urb->transfer_buffer;
+	/* get tty_flag from status */
+	char tty_flag = TTY_NORMAL;
+	/* break takes precedence over parity, */
+	/* which takes precedence over framing errors */
+	if (line_status & UART_BREAK_ERROR)
+		tty_flag = TTY_BREAK;
+	else if (line_status & UART_PARITY_ERROR)
+		tty_flag = TTY_PARITY;
+	else if (line_status & UART_FRAME_ERROR)
+		tty_flag = TTY_FRAME;
+	dbg("%s - tty_flag = %d", __func__, tty_flag);
+	
+	tty_buffer_request_room(tty, urb->actual_length + 1);
+	/* overrun is special, not associated with a char */
+	if (line_status & UART_OVERRUN_ERROR)
+		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+	if (port->console && port->sysrq) {
+		int i;
+		for (i = 0; i < urb->actual_length; ++i)
+			if (!usb_serial_handle_sysrq_char(tty, port, data[i]))
+				tty_insert_flip_char(tty, data[i], tty_flag);
+	} else
+		tty_insert_flip_string(tty, data, urb->actual_length);
+	tty_flip_buffer_push(tty);
+}
+
 static void pl2303_read_bulk_callback(struct urb *urb)
 {
 	struct usb_serial_port *port =  urb->context;
 	struct pl2303_private *priv = usb_get_serial_port_data(port);
 	struct tty_struct *tty;
-	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
-	int i;
 	int result;
 	int status = urb->status;
 	u8 line_status;
-	char tty_flag;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -1010,10 +1038,7 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 	}
 
 	usb_serial_debug_data(debug, &port->dev, __func__,
-			      urb->actual_length, data);
-
-	/* get tty_flag from status */
-	tty_flag = TTY_NORMAL;
+			      urb->actual_length, urb->transfer_buffer);
 
 	spin_lock_irqsave(&priv->lock, flags);
 	line_status = priv->line_status;
@@ -1021,26 +1046,9 @@ static void pl2303_read_bulk_callback(struct urb *urb)
 	spin_unlock_irqrestore(&priv->lock, flags);
 	wake_up_interruptible(&priv->delta_msr_wait);
 
-	/* break takes precedence over parity, */
-	/* which takes precedence over framing errors */
-	if (line_status & UART_BREAK_ERROR)
-		tty_flag = TTY_BREAK;
-	else if (line_status & UART_PARITY_ERROR)
-		tty_flag = TTY_PARITY;
-	else if (line_status & UART_FRAME_ERROR)
-		tty_flag = TTY_FRAME;
-	dbg("%s - tty_flag = %d", __func__, tty_flag);
-
 	tty = tty_port_tty_get(&port->port);
 	if (tty && urb->actual_length) {
-		tty_buffer_request_room(tty, urb->actual_length + 1);
-		/* overrun is special, not associated with a char */
-		if (line_status & UART_OVERRUN_ERROR)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-		for (i = 0; i < urb->actual_length; ++i)
-			if (!usb_serial_handle_sysrq_char(tty, port, data[i]))
-				tty_insert_flip_char(tty, data[i], tty_flag);
-		tty_flip_buffer_push(tty);
+		pl2303_push_data(tty, port, urb, line_status);
 	}
 	tty_kref_put(tty);
 	/* Schedule the next read _if_ we are still open */

