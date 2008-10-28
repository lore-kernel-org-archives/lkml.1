Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYJ1AFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYJ1AFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJ1AFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:05:13 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5559 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYJ1AFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:05:10 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org, David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Subject: [PATCH 30/36] Don't clobber spinlocks in 8250.
Date: Mon, 27 Oct 2008 17:04:07 -0700
Message-Id: <1225152251-3367-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <490655B6.4030406@caviumnetworks.com>
References: <490655B6.4030406@caviumnetworks.com>
X-OriginalArrivalTime: 28 Oct 2008 00:04:16.0084 (UTC) FILETIME=[B770D140:01C93890]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In serial8250_isa_init_ports(), the port's lock is initialized.  We
should not overwrite it.  Only copy in the fields we need.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
---
 drivers/serial/8250.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 303272a..8e28750 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2752,12 +2752,23 @@ static struct uart_driver serial8250_reg = {
  */
 int __init early_serial_setup(struct uart_port *port)
 {
+	struct uart_port *p;
+
 	if (port->line >= ARRAY_SIZE(serial8250_ports))
 		return -ENODEV;
 
 	serial8250_isa_init_ports();
-	serial8250_ports[port->line].port	= *port;
-	serial8250_ports[port->line].port.ops	= &serial8250_pops;
+	p = &serial8250_ports[port->line].port;
+	p->iobase       = port->iobase;
+	p->membase      = port->membase;
+	p->irq          = port->irq;
+	p->uartclk      = port->uartclk;
+	p->fifosize     = port->fifosize;
+	p->regshift     = port->regshift;
+	p->iotype       = port->iotype;
+	p->flags        = port->flags;
+	p->mapbase      = port->mapbase;
+	p->private_data = port->private_data;
 	return 0;
 }
 
-- 
1.5.6.5

