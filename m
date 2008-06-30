Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYF3KZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYF3KZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYF3KZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:25:08 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:63800 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbYF3KZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:25:06 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel@avr32linux.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/2] serial: Add flush_buffer() operation to uart_ops
Date: Mon, 30 Jun 2008 12:24:20 +0200
Message-Id: <1214821461-11772-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 30 Jun 2008 10:24:12.0880 (UTC) FILETIME=[70E37500:01C8DA9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serial drivers using DMA (like the atmel_serial driver) tend to get very
confused when the xmit buffer is flushed and nobody told them.  They
also tend to spew a lot of garbage since the DMA engine keeps running
after the buffer is flushed and possibly refilled with unrelated data.

This patch adds a new flush_buffer operation to the uart_ops struct,
along with a call to it from uart_flush_buffer() right after the xmit
buffer has been cleared. The driver can implement this in order to
syncronize its internal DMA state with the xmit buffer when the buffer
is flushed.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 Documentation/serial/driver  |   11 +++++++++++
 drivers/serial/serial_core.c |    2 ++
 include/linux/serial_core.h  |    1 +
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/serial/driver b/Documentation/serial/driver
index 88ad615..77ba0af 100644
--- a/Documentation/serial/driver
+++ b/Documentation/serial/driver
@@ -186,6 +186,17 @@ hardware.
 	Locking: port_sem taken.
 	Interrupts: caller dependent.
 
+  flush_buffer(port)
+	Flush any write buffers, reset any DMA state and stop any
+	ongoing DMA transfers.
+
+	This will be called whenever the port->info->xmit circular
+	buffer is cleared.
+
+	Locking: port->lock taken.
+	Interrupts: locally disabled.
+	This call must not sleep
+
   set_termios(port,termios,oldtermios)
 	Change the port parameters, including word length, parity, stop
 	bits.  Update read_status_mask and ignore_status_mask to indicate
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index c9b64e7..799f739 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -573,6 +573,8 @@ static void uart_flush_buffer(struct tty_struct *tty)
 
 	spin_lock_irqsave(&port->lock, flags);
 	uart_circ_clear(&state->info->xmit);
+	if (port->ops->flush_buffer)
+		port->ops->flush_buffer(port);
 	spin_unlock_irqrestore(&port->lock, flags);
 	tty_wakeup(tty);
 }
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index d8f31de..1d2faa6 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -190,6 +190,7 @@ struct uart_ops {
 	void		(*break_ctl)(struct uart_port *, int ctl);
 	int		(*startup)(struct uart_port *);
 	void		(*shutdown)(struct uart_port *);
+	void		(*flush_buffer)(struct uart_port *);
 	void		(*set_termios)(struct uart_port *, struct ktermios *new,
 				       struct ktermios *old);
 	void		(*set_ldisc)(struct uart_port *);
-- 
1.5.5.4

