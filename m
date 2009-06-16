Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbZFPPEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbZFPPEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZFPPE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:04:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44051 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759306AbZFPPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:04:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 8/9] atmel_serial: fix hang in set_termios when crtscts is
	enabled
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:02:03 +0100
Message-ID: <20090616160157.10041.81193.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
References: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

After enabling hardware flow control, any subsequent termios call may hang
waiting for the transmitter to drain.  This appears to be caused by a
busy-loop in set_termios() waiting for the transmitter to become empty,
which may take a very long time (or hang indefinitely) if the device at
the other end is blocking us.

A quick look through the tty and serial_core code indicates that any
necessary flushing (which is optional) has already been done at this
point, so there's no need for the driver to flush the transmitter on its
own.

Fix it by removing the busy-loop altogether.

Tested-by: Eirik Aanonsen <eaa@wprmedical.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/atmel_serial.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index b3497d7..338b15c 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1104,11 +1104,13 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* save/disable interrupts and drain transmitter */
+	/*
+	 * save/disable interrupts. The tty layer will ensure that the
+	 * transmitter is empty if requested by the caller, so there's
+	 * no need to wait for it here.
+	 */
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, -1);
-	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
-		cpu_relax();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);

