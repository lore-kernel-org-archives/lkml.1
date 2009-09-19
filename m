Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbZISVsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbZISVsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZISVnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:43:17 -0400
Received: from kroah.org ([198.145.64.141]:40517 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbZISVnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:43:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 55/79] serial: kill USF_CLOSING_* definitions
Date: Sat, 19 Sep 2009 14:37:00 -0700
Message-Id: <1253396244-7885-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The serial layer for some reason uses different defines for the special
case close delays and then conditionally switches to/from the normal ones
in the ioctls.

Remove this rather pointless abstraction

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_core.c |    6 +++---
 include/linux/serial_core.h  |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 3c45a8d..69c4e20 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -652,7 +652,7 @@ static int uart_get_info(struct uart_state *state,
 	tmp.xmit_fifo_size  = uport->fifosize;
 	tmp.baud_base	    = uport->uartclk / 16;
 	tmp.close_delay	    = port->close_delay / 10;
-	tmp.closing_wait    = port->closing_wait == USF_CLOSING_WAIT_NONE ?
+	tmp.closing_wait    = port->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
 				port->closing_wait / 10;
 	tmp.custom_divisor  = uport->custom_divisor;
@@ -690,7 +690,7 @@ static int uart_set_info(struct uart_state *state,
 	new_serial.irq = irq_canonicalize(new_serial.irq);
 	close_delay = new_serial.close_delay * 10;
 	closing_wait = new_serial.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			USF_CLOSING_WAIT_NONE : new_serial.closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE : new_serial.closing_wait * 10;
 
 	/*
 	 * This semaphore protects port->count.  It is also
@@ -1307,7 +1307,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 */
 	tty->closing = 1;
 
-	if (port->closing_wait != USF_CLOSING_WAIT_NONE)
+	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
 		tty_wait_until_sent(tty, msecs_to_jiffies(port->closing_wait));
 
 	/*
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index bcafecd..d58e460 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -342,9 +342,6 @@ struct uart_port {
 struct uart_state {
 	struct tty_port		port;
 
-#define USF_CLOSING_WAIT_INF	(0)
-#define USF_CLOSING_WAIT_NONE	(~0U)
-
 	int			pm_state;
 	struct circ_buf		xmit;
 
-- 
1.6.4.2

