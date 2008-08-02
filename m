Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYHBS3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYHBS3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 14:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYHBS3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 14:29:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:40406 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYHBS3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 14:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=c/bgj4XFt+zOd6ah2BZY1vFfQGHuQhaF/iQRdgLmRnb2XFX2eyQXOeV7w4vdMdbWay
         bzoeUzr/g06Ri3M3OK7TQzp3QCWRy6T+wahx0sKq5XzwTvXA8ZxajJObR5d/cQ4voRaU
         l7vpybOmXFRh45wOQMkuAHpCPDZ5E0p4CXHUA=
From: Oliver Pinter <oliver.pntr@gmail.com>
To: Aristeu Rozanski <arozansk@redhat.com>, stable@kernel.org
Subject: [RFC, 2.6.26.2-rc1] 8250: fix break handling for Intel 82571 (fixed)
Date: Sat, 2 Aug 2008 20:41:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808022041.14542.oliver.pntr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7500b1f602aad75901774a67a687ee985d85893f Mon Sep 17 00:00:00 2001
From: Aristeu Rozanski <arozansk@redhat.com>
Date: Wed, 23 Jul 2008 21:29:45 -0700
Subject: [PATCH] 8250: fix break handling for Intel 82571

[ Upstream commit 7500b1f602aad75901774a67a687ee985d85893f ]

Intel 82571 has a "Serial Over LAN" feature that doesn't properly
implements the receiving of break characters.  When a break is received,
it doesn't set UART_LSR_DR and unless another character is received, the
break won't be received by the application.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 27f34a9..a97f1ae 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1293,7 +1293,18 @@ receive_chars(struct uart_8250_port *up, unsigned int *status)
 	char flag;
 
 	do {
-		ch = serial_inp(up, UART_RX);
+		if (likely(lsr & UART_LSR_DR))
+			ch = serial_inp(up, UART_RX);
+		else
+			/*
+			 * Intel 82571 has a Serial Over Lan device that will
+			 * set UART_LSR_BI without setting UART_LSR_DR when
+			 * it receives a break. To avoid reading from the
+			 * receive buffer without UART_LSR_DR bit set, we
+			 * just force the read character to be 0
+			 */
+			ch = 0;
+
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
 
@@ -1342,7 +1353,7 @@ receive_chars(struct uart_8250_port *up, unsigned int *status)
 
 ignore_char:
 		lsr = serial_inp(up, UART_LSR);
-	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
+	} while ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
 	tty_flip_buffer_push(tty);
 	spin_lock(&up->port.lock);
@@ -1425,7 +1436,7 @@ serial8250_handle_port(struct uart_8250_port *up)
 
 	DEBUG_INTR("status = %x...", status);
 
-	if (status & UART_LSR_DR)
+	if (status & (UART_LSR_DR | UART_LSR_BI))
 		receive_chars(up, &status);
 	check_modem_status(up);
 	if (status & UART_LSR_THRE)
