Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYKRWZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYKRWZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYKRWYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:24:30 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12084 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbYKRWY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:24:28 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Subject: [PATCH 19/26] 8250: Don't clobber spinlocks.
Date: Tue, 18 Nov 2008 14:24:13 -0800
Message-Id: <1227047057-4911-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <49233FDE.3010404@caviumnetworks.com>
References: <49233FDE.3010404@caviumnetworks.com>
X-OriginalArrivalTime: 18 Nov 2008 22:24:20.0853 (UTC) FILETIME=[6717AA50:01C949CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In serial8250_isa_init_ports(), the port's lock is initialized.  We
should not overwrite it.  In early_serial_setup(), only copy in the
fields we need.  Since the early console code only uses a subset of
the fields, these are sufficient.

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

