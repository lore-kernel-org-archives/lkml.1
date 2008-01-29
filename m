Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbYA2Xp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbYA2Xp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbYA2Xoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:44:38 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:56932 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbYA2Xog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:44:36 -0500
Message-ID: <479FBA62.3000106@web.de>
Date: Wed, 30 Jan 2008 00:44:34 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/5] KGDB-8250: handle shared IRQ properly
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18w9O2eVzySE616lZbcCthV8qi/g6OzI23D2mx2
	DLWjdO5UAywzvUzIkgKHl6lPfBfqTfqNJqXUngHUUsxrTdrq6W
	bQ3V92yKw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, KGDB's 8250 driver always reports IRQs as handled, though it
registers the line with IRQF_SHARED. This patch fixes the behavior by
returning the appropriate values from the interrupt handler.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 drivers/serial/8250_kgdb.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: b/drivers/serial/8250_kgdb.c
===================================================================
--- a/drivers/serial/8250_kgdb.c
+++ b/drivers/serial/8250_kgdb.c
@@ -152,14 +152,15 @@ static int kgdb_get_debug_char(void)
 static irqreturn_t
 kgdb8250_interrupt(int irq, void *dev_id)
 {
-	if (kgdb_ioread(UART_IIR) & UART_IIR_RDI) {
-		/* Throw away the data if another I/O routine is active. */
-		if (kgdb_io_ops.read_char != kgdb_get_debug_char &&
-				(kgdb_ioread(UART_LSR) & UART_LSR_DR))
-			kgdb_ioread(UART_RX);
-		else
-			breakpoint();
-	}
+	if (!(kgdb_ioread(UART_IIR) & UART_IIR_RDI))
+		return IRQ_NONE;
+
+	/* Throw away the data if another I/O routine is active. */
+	if (kgdb_io_ops.read_char != kgdb_get_debug_char &&
+	    (kgdb_ioread(UART_LSR) & UART_LSR_DR))
+		kgdb_ioread(UART_RX);
+	else
+		breakpoint();
 
 	return IRQ_HANDLED;
 }
