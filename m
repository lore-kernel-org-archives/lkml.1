Return-Path: <linux-kernel-owner+w=401wt.eu-S1767054AbXDTKet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767054AbXDTKet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767055AbXDTKet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:34:49 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:38558 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767052AbXDTKeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:34:46 -0400
Message-id: <20225157853131727049@wsc.cz>
Subject: [PATCH 1/3] Char: mxser_new, fix recursive locking
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Date: Fri, 20 Apr 2007 12:34:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, I think it would be good to have these 3 in 2.6.21.

--
mxser_new, fix recursive locking

Acquire a port lock only if not in_interrupt in some places, because ISR
holds the lock yet (and ldisc calls some of driver's routines which tries to
acquire it again due to tty->low_latency).

Thanks to Jan "Yenya" Kasprzak.

Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a3c71212efb38a67d344f35137136808e64537c6
tree c1ec123ca7007190dfae8c06fafec4702d88e00c
parent 0156510dee9d326af2ec52cf8b1a388ce9a839e9
author Jiri Slaby <jirislaby@gmail.com> Mon, 16 Apr 2007 13:24:46 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 16 Apr 2007 13:24:46 +0200

 drivers/char/mxser_new.c |   46 ++++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 6362e78..626f491 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -85,6 +85,16 @@
 #define MXSER_HIGHBAUD	1
 #define MXSER_HAS2	2
 
+/* if we are in interrupt, lock is held by ISR, don't acquire it again! */
+#define mx_lock(info, flags) do {				\
+	if (!in_interrupt())					\
+		spin_lock_irqsave(&(info)->slock, flags);	\
+} while (0)
+#define mx_unlock(info, flags) do {				\
+	if (!in_interrupt())					\
+		spin_unlock_irqrestore(&(info)->slock, flags);	\
+} while (0)
+
 /* This is only for PCI */
 static const struct {
 	int type;
@@ -869,7 +879,7 @@ static void mxser_shutdown(struct mxser_port *info)
 	if (!(info->flags & ASYNC_INITIALIZED))
 		return;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 
 	/*
 	 * clear delta_msr_wait queue to avoid mem leaks: we may free the irq
@@ -912,7 +922,7 @@ static void mxser_shutdown(struct mxser_port *info)
 	if (info->board->chip_flag)
 		SET_MOXA_MUST_NO_SOFTWARE_FLOW_CONTROL(info->ioaddr);
 
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 /*
@@ -1076,11 +1086,11 @@ static int mxser_write(struct tty_struct *tty, const unsigned char *buf, int cou
 			break;
 
 		memcpy(info->xmit_buf + info->xmit_head, buf, c);
-		spin_lock_irqsave(&info->slock, flags);
+		mx_lock(info, flags);
 		info->xmit_head = (info->xmit_head + c) &
 				  (SERIAL_XMIT_SIZE - 1);
 		info->xmit_cnt += c;
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 
 		buf += c;
 		count -= c;
@@ -1091,12 +1101,12 @@ static int mxser_write(struct tty_struct *tty, const unsigned char *buf, int cou
 		if (!tty->hw_stopped ||
 				(info->type == PORT_16550A) ||
 				(info->board->chip_flag)) {
-			spin_lock_irqsave(&info->slock, flags);
+			mx_lock(info, flags);
 			outb(info->IER & ~UART_IER_THRI, info->ioaddr +
 					UART_IER);
 			info->IER |= UART_IER_THRI;
 			outb(info->IER, info->ioaddr + UART_IER);
-			spin_unlock_irqrestore(&info->slock, flags);
+			mx_unlock(info, flags);
 		}
 	}
 	return total;
@@ -1113,20 +1123,20 @@ static void mxser_put_char(struct tty_struct *tty, unsigned char ch)
 	if (info->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
 		return;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	info->xmit_buf[info->xmit_head++] = ch;
 	info->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	info->xmit_cnt++;
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 	if (!tty->stopped) {
 		if (!tty->hw_stopped ||
 				(info->type == PORT_16550A) ||
 				info->board->chip_flag) {
-			spin_lock_irqsave(&info->slock, flags);
+			mx_lock(info, flags);
 			outb(info->IER & ~UART_IER_THRI, info->ioaddr + UART_IER);
 			info->IER |= UART_IER_THRI;
 			outb(info->IER, info->ioaddr + UART_IER);
-			spin_unlock_irqrestore(&info->slock, flags);
+			mx_unlock(info, flags);
 		}
 	}
 }
@@ -1146,13 +1156,13 @@ static void mxser_flush_chars(struct tty_struct *tty)
 			))
 		return;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 
 	outb(info->IER & ~UART_IER_THRI, info->ioaddr + UART_IER);
 	info->IER |= UART_IER_THRI;
 	outb(info->IER, info->ioaddr + UART_IER);
 
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 static int mxser_write_room(struct tty_struct *tty)
@@ -1179,7 +1189,7 @@ static void mxser_flush_buffer(struct tty_struct *tty)
 	unsigned long flags;
 
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 
 	fcr = inb(info->ioaddr + UART_FCR);
@@ -1187,7 +1197,7 @@ static void mxser_flush_buffer(struct tty_struct *tty)
 		info->ioaddr + UART_FCR);
 	outb(fcr, info->ioaddr + UART_FCR);
 
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 
 	tty_wakeup(tty);
 }
@@ -1983,12 +1993,12 @@ static void mxser_stop(struct tty_struct *tty)
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	if (info->IER & UART_IER_THRI) {
 		info->IER &= ~UART_IER_THRI;
 		outb(info->IER, info->ioaddr + UART_IER);
 	}
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 static void mxser_start(struct tty_struct *tty)
@@ -1996,13 +2006,13 @@ static void mxser_start(struct tty_struct *tty)
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	if (info->xmit_cnt && info->xmit_buf) {
 		outb(info->IER & ~UART_IER_THRI, info->ioaddr + UART_IER);
 		info->IER |= UART_IER_THRI;
 		outb(info->IER, info->ioaddr + UART_IER);
 	}
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
