Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbXJUXFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbXJUXFC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:05:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXJUXEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:04:54 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:15823 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXJUXEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:04:53 -0400
Date: Sun, 21 Oct 2007 17:02:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Uartlite: speed up console output
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jacmet@sunsite.dk
Message-id: <20071021230255.7066.64565.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Change the wait_tx routine to call cpu_relax() instead of udelay() to
reduce console output latency and test for the TXFULL bit instead of
TXEMPTY.  That way the FIFO doesn't need to by 100% flushed before
writing the next character.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/serial/uartlite.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index dfef83f..a85f2d3 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -329,12 +329,14 @@ static struct uart_ops ulite_ops = {
 static void ulite_console_wait_tx(struct uart_port *port)
 {
 	int i;
+	u8 val;
 
-	/* wait up to 10ms for the character(s) to be sent */
-	for (i = 0; i < 10000; i++) {
-		if (readb(port->membase + ULITE_STATUS) & ULITE_STATUS_TXEMPTY)
+	/* Spin waiting for TX fifo to have space available */
+	for (i = 0; i < 100000; i++) {
+		val = readb(port->membase + ULITE_STATUS);
+		if ((val & ULITE_STATUS_TXFULL) == 0)
 			break;
-		udelay(1);
+		cpu_relax();
 	}
 }
 

