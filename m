Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZKBQ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZKBQ74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbZKBQ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:59:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40015 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756192AbZKBQ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:59:40 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/6] sdio_uart: Use kfifo instead of the messy circ stuff
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, nico@cam.org
Date: Mon, 02 Nov 2009 16:46:15 +0000
Message-ID: <20091102164610.11877.51014.stgit@localhost.localdomain>
In-Reply-To: <20091102164039.11877.88825.stgit@localhost.localdomain>
References: <20091102164039.11877.88825.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably all the tty code should switch to this, especially when the new
lockless kfifo is merged.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mmc/card/sdio_uart.c |   86 +++++++++++++-----------------------------
 1 files changed, 27 insertions(+), 59 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index e611bc6..c4fc27d 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -32,7 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
 #include <linux/serial_reg.h>
-#include <linux/circ_buf.h>
+#include <linux/kfifo.h>
 #include <linux/gfp.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
@@ -46,18 +46,9 @@
 #define UART_NR		8	/* Number of UARTs this driver can handle */
 
 
-#define UART_XMIT_SIZE	PAGE_SIZE
+#define FIFO_SIZE	PAGE_SIZE
 #define WAKEUP_CHARS	256
 
-#define circ_empty(circ)	((circ)->head == (circ)->tail)
-#define circ_clear(circ)	((circ)->head = (circ)->tail = 0)
-
-#define circ_chars_pending(circ) \
-		(CIRC_CNT((circ)->head, (circ)->tail, UART_XMIT_SIZE))
-
-#define circ_chars_free(circ) \
-		(CIRC_SPACE((circ)->head, (circ)->tail, UART_XMIT_SIZE))
-
 
 struct uart_icount {
 	__u32	cts;
@@ -82,7 +73,7 @@ struct sdio_uart_port {
 	struct mutex		func_lock;
 	struct task_struct	*in_sdio_uart_irq;
 	unsigned int		regs_offset;
-	struct circ_buf		xmit;
+	struct kfifo		*xmit_fifo;
 	spinlock_t		write_lock;
 	struct uart_icount	icount;
 	unsigned int		uartclk;
@@ -104,6 +95,9 @@ static int sdio_uart_add_port(struct sdio_uart_port *port)
 	kref_init(&port->kref);
 	mutex_init(&port->func_lock);
 	spin_lock_init(&port->write_lock);
+	port->xmit_fifo = kfifo_alloc(FIFO_SIZE, GFP_KERNEL, &port->write_lock);
+	if (port->xmit_fifo == NULL)
+		return -ENOMEM;
 
 	spin_lock(&sdio_uart_table_lock);
 	for (index = 0; index < UART_NR; index++) {
@@ -453,9 +447,11 @@ static void sdio_uart_receive_chars(struct sdio_uart_port *port,
 
 static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 {
-	struct circ_buf *xmit = &port->xmit;
+	struct kfifo *xmit = port->xmit_fifo;
 	int count;
 	struct tty_struct *tty;
+	u8 iobuf[16];
+	int len;
 
 	if (port->x_char) {
 		sdio_out(port, UART_TX, port->x_char);
@@ -466,24 +462,21 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 
 	tty = tty_port_tty_get(&port->port);
 
-	if (tty == NULL || circ_empty(xmit) || tty->stopped || tty->hw_stopped) {
+	if (tty == NULL || !kfifo_len(xmit) || tty->stopped || tty->hw_stopped) {
 		sdio_uart_stop_tx(port);
 		return;
 	}
 
-	count = 16;
-	do {
-		sdio_out(port, UART_TX, xmit->buf[xmit->tail]);
-		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+	len = kfifo_get(xmit, iobuf, 16);
+	for (count = 0; count < len; count++) {
+		sdio_out(port, UART_TX, iobuf[count]);
 		port->icount.tx++;
-		if (circ_empty(xmit))
-			break;
-	} while (--count > 0);
+	}
 
-	if (circ_chars_pending(xmit) < WAKEUP_CHARS)
+	if (len < WAKEUP_CHARS)
 		tty_wakeup(tty);
 
-	if (circ_empty(xmit))
+	if (len == 0)
 		sdio_uart_stop_tx(port);
 	tty_kref_put(tty);
 }
@@ -606,22 +599,17 @@ static int sdio_uart_activate(struct tty_port *tport, struct tty_struct *tty)
 	 */
 	set_bit(TTY_IO_ERROR, &tty->flags);
 
-	/* Initialise and allocate the transmit buffer. */
-	page = __get_free_page(GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
-	port->xmit.buf = (unsigned char *)page;
-	circ_clear(&port->xmit);
+	kfifo_reset(port->xmit_fifo);
 
 	ret = sdio_uart_claim_func(port);
 	if (ret)
-		goto err1;
+		return ret;
 	ret = sdio_enable_func(port->func);
 	if (ret)
-		goto err2;
+		goto err1;
 	ret = sdio_claim_irq(port->func, sdio_uart_irq);
 	if (ret)
-		goto err3;
+		goto err2;
 
 	/*
 	 * Clear the FIFO buffers and disable them.
@@ -665,12 +653,10 @@ static int sdio_uart_activate(struct tty_port *tport, struct tty_struct *tty)
 	sdio_uart_release_func(port);
 	return 0;
 
-err3:
-	sdio_disable_func(port->func);
 err2:
-	sdio_uart_release_func(port);
+	sdio_disable_func(port->func);
 err1:
-	free_page((unsigned long)port->xmit.buf);
+	sdio_uart_release_func(port);
 	return ret;
 }
 
@@ -693,7 +679,7 @@ static void sdio_uart_shutdown(struct tty_port *tport)
 
 	ret = sdio_uart_claim_func(port);
 	if (ret)
-		goto skip;
+		return ret;
 
 	sdio_uart_stop_rx(port);
 
@@ -715,10 +701,6 @@ static void sdio_uart_shutdown(struct tty_port *tport)
 	sdio_disable_func(port->func);
 
 	sdio_uart_release_func(port);
-
-skip:
-	/* Free the transmit buffer page. */
-	free_page((unsigned long)port->xmit.buf);
 }
 
 /**
@@ -789,26 +771,12 @@ static int sdio_uart_write(struct tty_struct * tty, const unsigned char *buf,
 			   int count)
 {
 	struct sdio_uart_port *port = tty->driver_data;
-	struct circ_buf *circ = &port->xmit;
-	int c, ret = 0;
+	int ret;
 
 	if (!port->func)
 		return -ENODEV;
 
-	spin_lock(&port->write_lock);
-	while (1) {
-		c = CIRC_SPACE_TO_END(circ->head, circ->tail, UART_XMIT_SIZE);
-		if (count < c)
-			c = count;
-		if (c <= 0)
-			break;
-		memcpy(circ->buf + circ->head, buf, c);
-		circ->head = (circ->head + c) & (UART_XMIT_SIZE - 1);
-		buf += c;
-		count -= c;
-		ret += c;
-	}
-	spin_unlock(&port->write_lock);
+	ret = kfifo_put(port->xmit_fifo, buf, count);
 
 	if ( !(port->ier & UART_IER_THRI)) {
 		int err = sdio_uart_claim_func(port);
@@ -826,13 +794,13 @@ static int sdio_uart_write(struct tty_struct * tty, const unsigned char *buf,
 static int sdio_uart_write_room(struct tty_struct *tty)
 {
 	struct sdio_uart_port *port = tty->driver_data;
-	return port ? circ_chars_free(&port->xmit) : 0;
+	return FIFO_SIZE - kfifo_len(port->xmit_fifo);
 }
 
 static int sdio_uart_chars_in_buffer(struct tty_struct *tty)
 {
 	struct sdio_uart_port *port = tty->driver_data;
-	return port ? circ_chars_pending(&port->xmit) : 0;
+	return kfifo_len(port->xmit_fifo);
 }
 
 static void sdio_uart_send_xchar(struct tty_struct *tty, char ch)

