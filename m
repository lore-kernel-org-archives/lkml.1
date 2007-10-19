Return-Path: <linux-kernel-owner+w=401wt.eu-S936628AbXJSUv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936628AbXJSUv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760932AbXJSUvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:51:16 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:49978 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759531AbXJSUvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:51:15 -0400
Date: Fri, 19 Oct 2007 21:51:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dz: Handle special conditions on reception correctly
Message-ID: <Pine.LNX.4.64N.0710192145130.13279@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Handle the read and ignore status masks correctly.  Handle the BREAK 
condition as expected: a framing error with a null character is a BREAK, 
any other framing error is a framing error indeed.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested with checkpatch.pl and at the run-time -- MIPS/Linux on a 
DECstation 5000/200.

 Please apply,

  Maciej

patch-mips-2.6.23-rc5-20070904-dz-receive-8
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.c linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.c	2007-05-02 04:56:10.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.c	2007-10-13 22:24:40.000000000 +0000
@@ -172,6 +172,7 @@ static void dz_enable_ms(struct uart_por
  */
 static inline void dz_receive_chars(struct dz_port *dport_in)
 {
+	struct uart_port *uport;
 	struct dz_port *dport;
 	struct tty_struct *tty = NULL;
 	struct uart_icount *icount;
@@ -182,57 +183,56 @@ static inline void dz_receive_chars(stru
 
 	while ((status = dz_in(dport_in, DZ_RBUF)) & DZ_DVAL) {
 		dport = &dz_ports[LINE(status)];
-		tty = dport->port.info->tty;	/* point to the proper dev */
+		uport = &dport->port;
+		tty = uport->info->tty;		/* point to the proper dev */
 
 		ch = UCHAR(status);		/* grab the char */
+		flag = TTY_NORMAL;
 
-		icount = &dport->port.icount;
+		icount = &uport->icount;
 		icount->rx++;
 
-		flag = TTY_NORMAL;
-		if (status & DZ_FERR) {		/* frame error */
+		if (unlikely(status & (DZ_OERR | DZ_FERR | DZ_PERR))) {
+
 			/*
-			 * There is no separate BREAK status bit, so
-			 * treat framing errors as BREAKs for Magic SysRq
-			 * and SAK; normally, otherwise.
+			 * There is no separate BREAK status bit, so treat
+			 * null characters with framing errors as BREAKs;
+			 * normally, otherwise.  For this move the Framing
+			 * Error bit to a simulated BREAK bit.
 			 */
-			if (uart_handle_break(&dport->port))
-				continue;
-			if (dport->port.flags & UPF_SAK)
+			if (!ch) {
+				status |= (status & DZ_FERR) >>
+					  (ffs(DZ_FERR) - ffs(DZ_BREAK));
+				status &= ~DZ_FERR;
+			}
+
+			/* Handle SysRq/SAK & keep track of the statistics. */
+			if (status & DZ_BREAK) {
+				icount->brk++;
+				if (uart_handle_break(uport))
+					continue;
+			} else if (status & DZ_FERR)
+				icount->frame++;
+			else if (status & DZ_PERR)
+				icount->parity++;
+			if (status & DZ_OERR)
+				icount->overrun++;
+
+			status &= uport->read_status_mask;
+			if (status & DZ_BREAK)
 				flag = TTY_BREAK;
-			else
+			else if (status & DZ_FERR)
 				flag = TTY_FRAME;
-		} else if (status & DZ_OERR)	/* overrun error */
-			flag = TTY_OVERRUN;
-		else if (status & DZ_PERR)	/* parity error */
-			flag = TTY_PARITY;
-
-		/* keep track of the statistics */
-		switch (flag) {
-		case TTY_FRAME:
-			icount->frame++;
-			break;
-		case TTY_PARITY:
-			icount->parity++;
-			break;
-		case TTY_OVERRUN:
-			icount->overrun++;
-			break;
-		case TTY_BREAK:
-			icount->brk++;
-			break;
-		default:
-			break;
+			else if (status & DZ_PERR)
+				flag = TTY_PARITY;
+
 		}
 
-		if (uart_handle_sysrq_char(&dport->port, ch))
+		if (uart_handle_sysrq_char(uport, ch))
 			continue;
 
-		if ((status & dport->port.ignore_status_mask) == 0) {
-			uart_insert_char(&dport->port,
-					 status, DZ_OERR, ch, flag);
-			lines_rx[LINE(status)] = 1;
-		}
+		uart_insert_char(uport, status, DZ_OERR, ch, flag);
+		lines_rx[LINE(status)] = 1;
 	}
 	for (i = 0; i < DZ_NB_PORT; i++)
 		if (lines_rx[i])
@@ -552,11 +552,17 @@ static void dz_set_termios(struct uart_p
 	dport->port.read_status_mask = DZ_OERR;
 	if (termios->c_iflag & INPCK)
 		dport->port.read_status_mask |= DZ_FERR | DZ_PERR;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		dport->port.read_status_mask |= DZ_BREAK;
 
 	/* characters to ignore */
 	uport->ignore_status_mask = 0;
+	if ((termios->c_iflag & (IGNPAR | IGNBRK)) == (IGNPAR | IGNBRK))
+		dport->port.ignore_status_mask |= DZ_OERR;
 	if (termios->c_iflag & IGNPAR)
 		dport->port.ignore_status_mask |= DZ_FERR | DZ_PERR;
+	if (termios->c_iflag & IGNBRK)
+		dport->port.ignore_status_mask |= DZ_BREAK;
 
 	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.h linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.h
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.h	2007-02-05 16:38:50.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.h	2007-09-08 12:20:40.000000000 +0000
@@ -33,6 +33,8 @@
 #define DZ_FERR        0x2000                 /* Frame error indicator */
 #define DZ_PERR        0x1000                 /* Parity error indicator */
 
+#define DZ_BREAK       0x0800                 /* BREAK event software flag */
+
 #define LINE(x) ((x & DZ_LINE_MASK) >> 8)     /* Get the line number
                                                  from the input buffer */
 #define UCHAR(x) ((unsigned char)(x & DZ_RBUF_MASK))
