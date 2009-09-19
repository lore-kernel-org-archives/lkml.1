Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZISVks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZISVks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZISVkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:40:47 -0400
Received: from kroah.org ([198.145.64.141]:40445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbZISVkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:40:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 31/79] mxser: Split close ready for a standard tty_port_close method
Date: Sat, 19 Sep 2009 14:36:36 -0700
Message-Id: <1253396244-7885-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Prepare for the tty_port_close function by splitting out methods

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/mxser.c |   45 +++++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index dbf8d52..30544ca 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1073,34 +1073,17 @@ static void mxser_flush_buffer(struct tty_struct *tty)
 }
 
 
-/*
- * This routine is called when the serial port gets closed.  First, we
- * wait for the last remaining data to be sent.  Then, we unlink its
- * async structure from the interrupt chain if necessary, and we free
- * that IRQ if nothing is left in the chain.
- */
-static void mxser_close(struct tty_struct *tty, struct file *filp)
+static void mxser_close_port(struct tty_struct *tty, struct tty_port *port)
 {
-	struct mxser_port *info = tty->driver_data;
-	struct tty_port *port = &info->port;
-
+	struct mxser_port *info = container_of(port, struct mxser_port, port);
 	unsigned long timeout;
-
-	if (tty->index == MXSER_PORTS)
-		return;
-	if (!info)
-		return;
-
-	if (tty_port_close_start(port, tty, filp) == 0)
-		return;
-
 	/*
 	 * Save the termios structure, since this port may have
 	 * separate termios for callout and dialin.
 	 *
 	 * FIXME: Can this go ?
 	 */
-	if (info->port.flags & ASYNC_NORMAL_ACTIVE)
+	if (port->flags & ASYNC_NORMAL_ACTIVE)
 		info->normal_termios = *tty->termios;
 	/*
 	 * At this point we stop accepting input.  To do this, we
@@ -1112,7 +1095,7 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 	if (info->board->chip_flag)
 		info->IER &= ~MOXA_MUST_RECV_ISR;
 
-	if (info->port.flags & ASYNC_INITIALIZED) {
+	if (port->flags & ASYNC_INITIALIZED) {
 		outb(info->IER, info->ioaddr + UART_IER);
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
@@ -1127,8 +1110,26 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 		}
 	}
 	mxser_shutdown(tty);
-	mxser_flush_buffer(tty);
 
+}
+
+/*
+ * This routine is called when the serial port gets closed.  First, we
+ * wait for the last remaining data to be sent.  Then, we unlink its
+ * async structure from the interrupt chain if necessary, and we free
+ * that IRQ if nothing is left in the chain.
+ */
+static void mxser_close(struct tty_struct *tty, struct file *filp)
+{
+	struct mxser_port *info = tty->driver_data;
+	struct tty_port *port = &info->port;
+
+	if (tty->index == MXSER_PORTS)
+		return;
+	if (tty_port_close_start(port, tty, filp) == 0)
+		return;
+	mxser_close_port(tty, port);
+	mxser_flush_buffer(tty);
 	/* Right now the tty_port set is done outside of the close_end helper
 	   as we don't yet have everyone using refcounts */	
 	tty_port_close_end(port, tty);
-- 
1.6.4.2

