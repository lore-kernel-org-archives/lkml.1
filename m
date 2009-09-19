Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZISVoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZISVoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZISVoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:44:20 -0400
Received: from kroah.org ([198.145.64.141]:40561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950AbZISVoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:44:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 68/79] uartlite: support shared interrupt lines
Date: Sat, 19 Sep 2009 14:37:13 -0700
Message-Id: <1253396244-7885-68-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Korsgaard <jacmet@sunsite.dk>

Adapt isr to work with shared interrupt lines.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/uartlite.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index 5d3a573..377f271 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -154,17 +154,22 @@ static int ulite_transmit(struct uart_port *port, int stat)
 static irqreturn_t ulite_isr(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	int busy;
+	int busy, n = 0;
 
 	do {
 		int stat = readb(port->membase + ULITE_STATUS);
 		busy  = ulite_receive(port, stat);
 		busy |= ulite_transmit(port, stat);
+		n++;
 	} while (busy);
 
-	tty_flip_buffer_push(port->state->port.tty);
-
-	return IRQ_HANDLED;
+	/* work done? */
+	if (n > 1) {
+		tty_flip_buffer_push(port->state->port.tty);
+		return IRQ_HANDLED;
+	} else {
+		return IRQ_NONE;
+	}
 }
 
 static unsigned int ulite_tx_empty(struct uart_port *port)
@@ -221,7 +226,7 @@ static int ulite_startup(struct uart_port *port)
 	int ret;
 
 	ret = request_irq(port->irq, ulite_isr,
-			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "uartlite", port);
+			  IRQF_SHARED | IRQF_SAMPLE_RANDOM, "uartlite", port);
 	if (ret)
 		return ret;
 
-- 
1.6.4.2

