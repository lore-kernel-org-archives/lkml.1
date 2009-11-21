Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZKUNkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZKUNkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZKUNkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:40:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41031 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbZKUNkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=hvYqrnHLY+RD6hxH4i0VkKNaJweEKZjkajq68R9W/t8Gjb2ZQawqk2K46Z5WIqTer9
         6ONcdYwV0qnLDOVpy8751zJXfDmzWJSpZ7VqCsCd2pPfdVUsgDMoUv6zcYOn5Sw2wYmD
         yp3ab8N6m8utllHJn9gjhvWgyEod0IYuHizIc=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 5/9] Serial: sc26xx - refactor register access
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:40:11 +0100
Message-ID: <20091121134011.16090.14636.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add line number based register accessor functions.
Add command function which implements the inter command
delay required by datasheet.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/serial/sc26xx.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index dc47d4f..1b47443 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -102,19 +102,45 @@ static struct uart_sc26xx_port *driver_info(struct uart_port *port)
 }
 
 /* access port register */
+static inline u8 read_sc_line(struct uart_port *p, int line, u8 reg)
+{
+	return readb(p->membase + line * 0x20 + reg);
+}
+
 static inline u8 read_sc_port(struct uart_port *p, u8 reg)
 {
-	return readb(p->membase + p->line * 0x20 + reg);
+	return read_sc_line(p, p->line, reg);
+}
+
+static inline void write_sc_line(struct uart_port *p, int line, u8 reg, u8 val)
+{
+	writeb(val, p->membase + line * 0x20 + reg);
 }
 
 static inline void write_sc_port(struct uart_port *p, u8 reg, u8 val)
 {
-	writeb(val, p->membase + p->line * 0x20 + reg);
+	write_sc_line(p, p->line, reg, val);
 }
 
 #define READ_SC_PORT(p, r)     read_sc_port(p, RD_PORT_##r)
 #define WRITE_SC_PORT(p, r, v) write_sc_port(p, WR_PORT_##r, v)
 
+static void write_cmd_line(struct uart_port *port, int line, u8 cmd)
+{
+	int i;
+
+	write_sc_line(port, line, WR_PORT_CR, cmd);
+
+	/* According to data sheet require 3 NOPs before next command */
+	for (i = 0; i < 3; i++)
+		write_sc_line(port, line, WR_PORT_CR, 0);
+}
+
+static inline void write_cmd_port(struct uart_port *port, u8 cmd)
+{
+	write_cmd_line(port, port->line, cmd);
+}
+
 static void sc26xx_enable_irq(struct uart_port *port, int mask)
 {
 	struct uart_sc26xx_port *up = driver_info(port);
@@ -337,9 +363,9 @@ static void sc26xx_enable_ms(struct uart_port *port)
 static void sc26xx_break_ctl(struct uart_port *port, int break_state)
 {
 	if (break_state == -1)
-		WRITE_SC_PORT(port, CR, CR_STRT_BRK);
+		write_cmd_port(port, CR_STRT_BRK);
 	else
-		WRITE_SC_PORT(port, CR, CR_STOP_BRK);
+		write_cmd_port(port, CR_STOP_BRK);
 }
 
 /* port->lock is not held.  */
@@ -349,8 +375,8 @@ static int sc26xx_startup(struct uart_port *port)
 	WRITE_SC(port, OPCR, 0);
 
 	/* reset tx and rx */
-	WRITE_SC_PORT(port, CR, CR_RES_RX);
-	WRITE_SC_PORT(port, CR, CR_RES_TX);
+	write_cmd_port(port, CR_RES_RX);
+	write_cmd_port(port, CR_RES_TX);
 
 	/* start rx/tx */
 	WRITE_SC_PORT(port, CR, CR_ENA_TX | CR_ENA_RX);
@@ -464,7 +490,7 @@ static void sc26xx_set_termios(struct uart_port *port, struct ktermios *termios,
 		break;
 	}
 
-	WRITE_SC_PORT(port, CR, CR_RES_MR);
+	write_cmd_port(port, CR_RES_MR);
 	WRITE_SC_PORT(port, MRx, mr1);
 	WRITE_SC_PORT(port, MRx, mr2);
 
@@ -472,8 +498,8 @@ static void sc26xx_set_termios(struct uart_port *port, struct ktermios *termios,
 	WRITE_SC_PORT(port, CSR, csr);
 
 	/* reset tx and rx */
-	WRITE_SC_PORT(port, CR, CR_RES_RX);
-	WRITE_SC_PORT(port, CR, CR_RES_TX);
+	write_cmd_port(port, CR_RES_RX);
+	write_cmd_port(port, CR_RES_TX);
 
 	WRITE_SC_PORT(port, CR, CR_ENA_TX | CR_ENA_RX);
 	while ((READ_SC_PORT(port, SR) & ((1 << 3) | (1 << 2))) != 0xc)

