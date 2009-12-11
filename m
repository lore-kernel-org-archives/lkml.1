Return-Path: <linux-kernel-owner+w=401wt.eu-S934390AbZLKX3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390AbZLKX3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934301AbZLKX3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:16 -0500
Received: from kroah.org ([198.145.64.141]:50472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936AbZLKX3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/58] serial, 8250: calculate irqflags bitmask before loop
Date: Fri, 11 Dec 2009 15:28:04 -0800
Message-Id: <1260574122-10676-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Goddard Rosa <andre.goddard@gmail.com>

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 737b4c9..b75e63e 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2646,7 +2646,7 @@ static void __init serial8250_isa_init_ports(void)
 {
 	struct uart_8250_port *up;
 	static int first = 1;
-	int i;
+	int i, irqflag = 0;
 
 	if (!first)
 		return;
@@ -2670,6 +2670,9 @@ static void __init serial8250_isa_init_ports(void)
 		up->port.ops = &serial8250_pops;
 	}
 
+	if (share_irqs)
+		irqflag = IRQF_SHARED;
+
 	for (i = 0, up = serial8250_ports;
 	     i < ARRAY_SIZE(old_serial_port) && i < nr_uarts;
 	     i++, up++) {
@@ -2683,8 +2686,7 @@ static void __init serial8250_isa_init_ports(void)
 		up->port.iotype   = old_serial_port[i].io_type;
 		up->port.regshift = old_serial_port[i].iomem_reg_shift;
 		set_io_from_upio(&up->port);
-		if (share_irqs)
-			up->port.irqflags |= IRQF_SHARED;
+		up->port.irqflags |= irqflag;
 	}
 }
 
@@ -2940,10 +2942,13 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 {
 	struct plat_serial8250_port *p = dev->dev.platform_data;
 	struct uart_port port;
-	int ret, i;
+	int ret, i, irqflag = 0;
 
 	memset(&port, 0, sizeof(struct uart_port));
 
+	if (share_irqs)
+		irqflag = IRQF_SHARED;
+
 	for (i = 0; p && p->flags != 0; p++, i++) {
 		port.iobase		= p->iobase;
 		port.membase		= p->membase;
@@ -2960,8 +2965,7 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.serial_in		= p->serial_in;
 		port.serial_out		= p->serial_out;
 		port.dev		= &dev->dev;
-		if (share_irqs)
-			port.irqflags |= IRQF_SHARED;
+		port.irqflags		|= irqflag;
 		ret = serial8250_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
-- 
1.6.5.5

