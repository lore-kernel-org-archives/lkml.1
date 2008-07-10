Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYGJL3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYGJL3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYGJL25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:28:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbYGJL24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:28:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix SDIO break control to now return success or an error
To: drzeus-mmc@drzeus.cx, akpm@linux-foundation.org
Cc: dhowells@redhat.com, alan@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Jul 2008 12:28:48 +0100
Message-ID: <20080710112847.22339.88592.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix SDIO break control to now return success or an error.

This is a consequence of patch 9ea761bfef52c116fed4715d4043392c2503fe6a.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/mmc/card/sdio_uart.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index eeea84c..78ad487 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -885,12 +885,14 @@ static void sdio_uart_set_termios(struct tty_struct *tty, struct ktermios *old_t
 	sdio_uart_release_func(port);
 }
 
-static void sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
+static int sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
 {
 	struct sdio_uart_port *port = tty->driver_data;
+	int result;
 
-	if (sdio_uart_claim_func(port) != 0)
-		return;
+	result = sdio_uart_claim_func(port);
+	if (result != 0)
+		return result;
 
 	if (break_state == -1)
 		port->lcr |= UART_LCR_SBC;
@@ -899,6 +901,7 @@ static void sdio_uart_break_ctl(struct tty_struct *tty, int break_state)
 	sdio_out(port, UART_LCR, port->lcr);
 
 	sdio_uart_release_func(port);
+	return 0;
 }
 
 static int sdio_uart_tiocmget(struct tty_struct *tty, struct file *file)

