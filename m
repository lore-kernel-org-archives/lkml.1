Return-Path: <linux-kernel-owner+w=401wt.eu-S1762182AbYESPIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182AbYESPIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbYESPEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:04:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39747 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761448AbYESPEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:04:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 17/20] riscom8: remove bogus checks
To: linux-kernel@vger.kernel.org, akpm@osdl.org, greg@kroah.com
Date: Mon, 19 May 2008 15:51:45 +0100
Message-ID: <20080519145144.19326.27668.stgit@core>
In-Reply-To: <20080519144557.19326.74313.stgit@core>
References: <20080519144557.19326.74313.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Chris Malley posted a patch removing a NULL check in the riscom8 driver.
Further analysis shows that even more of the tests are irrelevant so we
can delete lots of stuff
---

 drivers/char/riscom8.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)


diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index b0ba241..3ca8957 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -638,9 +638,6 @@ static void rc_change_speed(struct riscom_board *bp, struct riscom_port *port)
 	unsigned char cor1 = 0, cor3 = 0;
 	unsigned char mcor1 = 0, mcor2 = 0;
 
-	if (tty == NULL || tty->termios == NULL)
-		return;
-
 	port->IER  = 0;
 	port->COR2 = 0;
 	port->MSVR = MSVR_RTS;
@@ -794,8 +791,7 @@ static int rc_setup_port(struct riscom_board *bp, struct riscom_port *port)
 
 	spin_lock_irqsave(&riscom_lock, flags);
 
-	if (port->port.tty)
-		clear_bit(TTY_IO_ERROR, &port->port.tty->flags);
+	clear_bit(TTY_IO_ERROR, &port->port.tty->flags);
 	if (port->port.count == 1)
 		bp->count++;
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
@@ -807,10 +803,9 @@ static int rc_setup_port(struct riscom_board *bp, struct riscom_port *port)
 }
 
 /* Must be called with interrupts disabled */
-static void rc_shutdown_port(struct riscom_board *bp, struct riscom_port *port)
+static void rc_shutdown_port(struct tty_struct *tty,
+			struct riscom_board *bp, struct riscom_port *port)
 {
-	struct tty_struct *tty;
-
 	if (!(port->port.flags & ASYNC_INITIALIZED))
 		return;
 
@@ -830,10 +825,7 @@ static void rc_shutdown_port(struct riscom_board *bp, struct riscom_port *port)
 	}
 #endif
 	tty_port_free_xmit_buf(&port->port);
-
-	tty = port->port.tty;
-
-	if (tty == NULL || C_HUPCL(tty)) {
+	if (C_HUPCL(tty)) {
 		/* Drop DTR */
 		bp->DTR |= (1u << port_No(port));
 		rc_out(bp, RC_DTR, bp->DTR);
@@ -848,8 +840,7 @@ static void rc_shutdown_port(struct riscom_board *bp, struct riscom_port *port)
 	port->IER = 0;
 	rc_out(bp, CD180_IER, port->IER);
 
-	if (tty)
-		set_bit(TTY_IO_ERROR, &tty->flags);
+	set_bit(TTY_IO_ERROR, &tty->flags);
 	port->port.flags &= ~ASYNC_INITIALIZED;
 
 	if (--bp->count < 0)  {
@@ -1067,7 +1058,7 @@ static void rc_close(struct tty_struct *tty, struct file *filp)
 				break;
 		}
 	}
-	rc_shutdown_port(bp, port);
+	rc_shutdown_port(tty, bp, port);
 	rc_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
@@ -1098,9 +1089,6 @@ static int rc_write(struct tty_struct *tty,
 
 	bp = port_Board(port);
 
-	if (!tty || !port->port.xmit_buf)
-		return 0;
-
 	while (1) {
 		spin_lock_irqsave(&riscom_lock, flags);
 
@@ -1141,9 +1129,6 @@ static int rc_put_char(struct tty_struct *tty, unsigned char ch)
 	if (rc_paranoia_check(port, tty->name, "rc_put_char"))
 		return 0;
 
-	if (!tty || !port->port.xmit_buf)
-		return 0;
-
 	spin_lock_irqsave(&riscom_lock, flags);
 
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
@@ -1167,8 +1152,7 @@ static void rc_flush_chars(struct tty_struct *tty)
 	if (rc_paranoia_check(port, tty->name, "rc_flush_chars"))
 		return;
 
-	if (port->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped ||
-	    !port->port.xmit_buf)
+	if (port->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped)
 		return;
 
 	spin_lock_irqsave(&riscom_lock, flags);
@@ -1488,7 +1472,7 @@ static void rc_hangup(struct tty_struct *tty)
 
 	bp = port_Board(port);
 
-	rc_shutdown_port(bp, port);
+	rc_shutdown_port(tty, bp, port);
 	port->port.count = 0;
 	port->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	port->port.tty = NULL;

