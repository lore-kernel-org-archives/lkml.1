Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbYJPRpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbYJPRpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbYJPRod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:44:33 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:20082 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbYJPRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=YptztqdOz9gAYpD/klr3ti5iUpNEFk5MKy95HVyp0qJVA2I5fbK131xD4NbFbgjOyJ
         t+MUtexQaEUQnxnMp9b3WDPa/8v27Py4woush4PKnqpeSGvHkV3YWa63gJg+hdyZWmde
         RhgPEvX1kL9Ejk77rS1AmH4Lctd/icVemIvd0=
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/9] Blackfin Serial Driver: fix bug - SIR driver stop receiving randomly
Date: Fri, 17 Oct 2008 01:44:02 +0800
Message-Id: <1224179047-13073-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
References: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Bug description:
The IRDA receiver may can't receiving any more after processed some signals.

To duplicate this issue is put three IRDA devices together, one blackfin,
two none blackfin, they will detect each other. Let one none blackfin devices
irdaping the blackfin devices, when it stopped print out ping information,
it is the time that blackfin stoped receiving, the time is random.

The related register bit is OK, the other devices is sending data continuously.
But no interrupt come.

Fixing:
I tried Michael's suggestion that request the UARTx error interrupt, and reset
the IRDA when found FE error. This method helps much, but it can't completely
avoid stop.

Reset the IRDA before every time sending the data is more safe.

Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index aea3a53..3cc7b98 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -74,6 +74,8 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart);
 
 static void bfin_serial_mctrl_check(struct bfin_serial_port *uart);
 
+static void bfin_serial_reset_irda(struct uart_port *port);
+
 /*
  * interrupts are disabled on entry
  */
@@ -106,6 +108,14 @@ static void bfin_serial_stop_tx(struct uart_port *port)
 static void bfin_serial_start_tx(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+	struct tty_struct *tty = uart->port.info->port.tty;
+
+	/*
+	 * To avoid losting RX interrupt, we reset IR function
+	 * before sending data.
+	 */
+	if (tty->termios->c_line == N_IRDA)
+		bfin_serial_reset_irda(port);
 
 #ifdef CONFIG_SERIAL_BFIN_DMA
 	if (uart->tx_done)
@@ -891,6 +901,20 @@ static int bfin_kgdboc_port_startup(struct uart_port *port)
 }
 #endif
 
+static void bfin_serial_reset_irda(struct uart_port *port)
+{
+	int line = port->line;
+	unsigned short val;
+
+	val = UART_GET_GCTL(&bfin_serial_ports[line]);
+	val &= ~(IREN | RPOLC);
+	UART_PUT_GCTL(&bfin_serial_ports[line], val);
+	SSYNC();
+	val |= (IREN | RPOLC);
+	UART_PUT_GCTL(&bfin_serial_ports[line], val);
+	SSYNC();
+}
+
 static struct uart_ops bfin_serial_pops = {
 	.tx_empty	= bfin_serial_tx_empty,
 	.set_mctrl	= bfin_serial_set_mctrl,
-- 
1.5.6

