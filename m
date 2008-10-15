Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYJOQvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYJOQvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYJOQve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:51:34 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:48525 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYJOQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:51:33 -0400
Message-ID: <48F61F86.5020108@caviumnetworks.com>
Date: Wed, 15 Oct 2008 09:51:18 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: [PATCH] 8250: Don't clobber spinlocks in 8250.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2008 16:51:19.0047 (UTC) FILETIME=[3EF68970:01C92EE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't clobber spinlocks in 8250.

In serial8250_isa_init_ports(), the port's lock is initialized.  We
should not overwrite it.  Only copy in the fields we need.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
---
 drivers/serial/8250.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index d3ca7d3..da65fea 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2699,12 +2699,24 @@ static struct uart_driver serial8250_reg = {
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
+	p->ops		= &serial8250_pops;
 	return 0;
 }
 
