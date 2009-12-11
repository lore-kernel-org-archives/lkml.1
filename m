Return-Path: <linux-kernel-owner+w=401wt.eu-S934768AbZLKXc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768AbZLKXc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934410AbZLKX30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:26 -0500
Received: from kroah.org ([198.145.64.141]:50440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbZLKX3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Eric Miao <eric.y.miao@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Mike Rapoport <mike@compulab.co.il>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/58] Serial: pxa: work around Errata #75
Date: Fri, 11 Dec 2009 15:28:05 -0800
Message-Id: <1260574122-10676-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Intel(R) PXA27x Processor Family Specification Update (Nov 2005)
says:

  E75. UART: Baud rate may not be programmed correctly on
       back-to-back writes.

  Problem:
  When programming the Divisor Latch registers, Low and High (DLL and
  DLH), with back-to-back writes, the second register write may not
  take effect. The result is an incorrect baud rate.

  Workaround:
  After programming the first Divisor Latch register, read and verify
  it before programming the second Divisor Latch register.

This was hit when changing the baud rate from 115200 to 9600 while
receiving characters at 9600 Bd.

And fixed indention of some comments nearby.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/pxa.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/pxa.c b/drivers/serial/pxa.c
index b8629d7..4a82104 100644
--- a/drivers/serial/pxa.c
+++ b/drivers/serial/pxa.c
@@ -438,6 +438,7 @@ serial_pxa_set_termios(struct uart_port *port, struct ktermios *termios,
 	unsigned char cval, fcr = 0;
 	unsigned long flags;
 	unsigned int baud, quot;
+	unsigned int dll;
 
 	switch (termios->c_cflag & CSIZE) {
 	case CS5:
@@ -534,10 +535,18 @@ serial_pxa_set_termios(struct uart_port *port, struct ktermios *termios,
 	else
 		up->mcr &= ~UART_MCR_AFE;
 
-	serial_out(up, UART_LCR, cval | UART_LCR_DLAB);/* set DLAB */
+	serial_out(up, UART_LCR, cval | UART_LCR_DLAB);	/* set DLAB */
 	serial_out(up, UART_DLL, quot & 0xff);		/* LS of divisor */
+
+	/*
+	 * work around Errata #75 according to Intel(R) PXA27x Processor Family
+	 * Specification Update (Nov 2005)
+	 */
+	dll = serial_in(up, UART_DLL);
+	WARN_ON(dll != (quot & 0xff));
+
 	serial_out(up, UART_DLM, quot >> 8);		/* MS of divisor */
-	serial_out(up, UART_LCR, cval);		/* reset DLAB */
+	serial_out(up, UART_LCR, cval);			/* reset DLAB */
 	up->lcr = cval;					/* Save LCR */
 	serial_pxa_set_mctrl(&up->port, up->port.mctrl);
 	serial_out(up, UART_FCR, fcr);
-- 
1.6.5.5

