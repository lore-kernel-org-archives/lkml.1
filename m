Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYAXMn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYAXMn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYAXMmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:42:12 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57043 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753282AbYAXMmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:42:02 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>, Marc Pignat <marc.pignat@hevs.ch>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH -mm v4 3/9] atmel_serial: Use cpu_relax() when busy-waiting
Date: Thu, 24 Jan 2008 13:41:45 +0100
Message-Id: <1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace two instances of barrier() with cpu_relax() since that's the
right thing to do when busy-waiting. This does not actually change
anything since cpu_relax() is defined as barrier() on both ARM and
AVR32.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
---
 drivers/serial/atmel_serial.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index ee5d844..4b5c6ff 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -616,7 +616,7 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, -1);
 	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
-		barrier();
+		cpu_relax();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
@@ -795,7 +795,7 @@ void __init atmel_register_uart_fns(struct atmel_port_fns *fns)
 static void atmel_console_putchar(struct uart_port *port, int ch)
 {
 	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
-		barrier();
+		cpu_relax();
 	UART_PUT_CHAR(port, ch);
 }
 
-- 
1.5.3.8

