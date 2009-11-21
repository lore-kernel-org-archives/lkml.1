Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZKUNlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZKUNlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbZKUNkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:40:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:24671 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbZKUNkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:40:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=lENdixCEyuUnSCRckaNfOlyCRNs+xJVKSunidUM1C7WNm4bzNUkDewL1neprKgoK94
         OVFgtL1mXzA0S5bXfP27jBtTtYwfOBplhNzCoMW7w8PS0NJqI44sygXa8ZGi3EoC3Gkh
         TY2Gb/gte8AVjg3X5PMKBLOZvcU6dtMlgCe/w=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 4/9] Serial: sc26xx - add accessor function for driver
	data.
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:40:07 +0100
Message-ID: <20091121134007.16090.92417.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract container_of and port -= line to a helper function
to avoid slightly opaque modification of port pointer.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/serial/sc26xx.c |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index ca74bf6..dc47d4f 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -95,6 +95,12 @@ struct uart_sc26xx_port {
 #define IMR_RXRDY   (1 << 1)
 #define IMR_TXRDY   (1 << 0)
 
+static struct uart_sc26xx_port *driver_info(struct uart_port *port)
+{
+	port -= port->line;
+	return container_of(port, struct uart_sc26xx_port, port[0]);
+}
+
 /* access port register */
 static inline u8 read_sc_port(struct uart_port *p, u8 reg)
 {
@@ -111,25 +117,17 @@ static inline void write_sc_port(struct uart_port *p, u8 reg, u8 val)
 
 static void sc26xx_enable_irq(struct uart_port *port, int mask)
 {
-	struct uart_sc26xx_port *up;
-	int line = port->line;
-
-	port -= line;
-	up = container_of(port, struct uart_sc26xx_port, port[0]);
+	struct uart_sc26xx_port *up = driver_info(port);
 
-	up->imr |= mask << (line * 4);
+	up->imr |= mask << (port->line * 4);
 	WRITE_SC(port, IMR, up->imr);
 }
 
 static void sc26xx_disable_irq(struct uart_port *port, int mask)
 {
-	struct uart_sc26xx_port *up;
-	int line = port->line;
-
-	port -= line;
-	up = container_of(port, struct uart_sc26xx_port, port[0]);
+	struct uart_sc26xx_port *up = driver_info(port);
 
-	up->imr &= ~(mask << (line * 4));
+	up->imr &= ~(mask << (port->line * 4));
 	WRITE_SC(port, IMR, up->imr);
 }
 
@@ -257,12 +255,9 @@ static unsigned int sc26xx_tx_empty(struct uart_port *port)
 /* port->lock held by caller.  */
 static void sc26xx_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_sc26xx_port *up;
+	struct uart_sc26xx_port *up = driver_info(port);
 	int line = port->line;
 
-	port -= line;
-	up = container_of(port, struct uart_sc26xx_port, port[0]);
-
 	if (up->dtr_mask[line]) {
 		if (mctrl & TIOCM_DTR)
 			WRITE_SC(port, OPR_SET, up->dtr_mask[line]);
@@ -280,13 +275,11 @@ static void sc26xx_set_mctrl(struct uart_port *port, unsigned int mctrl)
 /* port->lock is held by caller and interrupts are disabled.  */
 static unsigned int sc26xx_get_mctrl(struct uart_port *port)
 {
-	struct uart_sc26xx_port *up;
+	struct uart_sc26xx_port *up = driver_info(port);
 	int line = port->line;
 	unsigned int mctrl = TIOCM_DSR | TIOCM_CTS | TIOCM_CAR;
 	u8 ipr;
 
-	port -= line;
-	up = container_of(port, struct uart_sc26xx_port, port[0]);
 	ipr = READ_SC(port, IPR) ^ 0xff;
 
 	if (up->dsr_mask[line]) {

