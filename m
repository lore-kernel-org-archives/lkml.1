Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935915Ab0COJJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:09:20 -0400
Received: from www.tglx.de ([62.245.132.106]:56894 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759885Ab0COJJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:09:19 -0400
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] serial: fix possible imx deadlock
From: John Ogness <john.ogness@linutronix.de>
Date: Mon, 15 Mar 2010 10:08:58 +0100
Message-ID: <80k4tehryt.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a possible deadlock situation with the port and timer
locks. The calling paths for the deadlock situation are:

1. imx_set_termios() -> LOCK(port.lock)
      -> del_timer_sync() -> LOCK(timer.base.lock)

2. run_timer_softirq() -> LOCK(timer.base.lock)
      -> imx_timeout() -> LOCK(port.lock)

This patch is against 2.6.34-rc1.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/serial/imx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
diff -Naurp a/drivers/serial/imx.c b/drivers/serial/imx.c
--- a/drivers/serial/imx.c	2010-03-08 19:45:44.000000000 +0100
+++ b/drivers/serial/imx.c	2010-03-15 09:52:39.855261060 +0100
@@ -836,6 +836,12 @@ imx_set_termios(struct uart_port *port, 
 	baud = uart_get_baud_rate(port, termios, old, 50, port->uartclk / 16);
 	quot = uart_get_divisor(port, baud);
 
+	/*
+	 * Stop our timer. This is done with the port unlocked
+	 * to avoid possible deadlock against the timer function.
+	 */
+	del_timer_sync(&sport->timer);
+
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	sport->port.read_status_mask = 0;
@@ -860,8 +866,6 @@ imx_set_termios(struct uart_port *port, 
 			sport->port.ignore_status_mask |= URXD_OVRRUN;
 	}
 
-	del_timer_sync(&sport->timer);
-
 	/*
 	 * Update the per-port timeout.
 	 */
