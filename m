Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZJYOBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZJYOBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 10:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZJYOBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 10:01:50 -0400
Received: from mail-vw0-f184.google.com ([209.85.212.184]:33938 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZJYOBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 10:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Bpw/PPbstII0BsF3Zj/bUQJzwcAURyewhFK0UNKR5GatcGiqJ8VAyZZxq29m5eOq+7
         CcNQO8sLdPlwv2V2WWBib13wwq/G1HAAjJlvvOROxRfLi4LkYCBmNl7aebIJAm7balU/
         VcxJ9Jd+3mgTcLk5uJr+1JTVJYI6kUGqNUtqc=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 25 Oct 2009 12:01:34 -0200
Message-ID: <b8bf37780910250701r58d25082y12ea482f6c1b2ea4@mail.gmail.com>
Subject: [PATCH] serial, 8250: calculate irqflags bitmask before loop
To: alan@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
       ddaney@caviumnetworks.com, tpaoletti@caviumnetworks.com, gregkh@suse.de,
       linux-serial@vger.kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3619427f21e450763b7cc1b12f7c21b2300e49e8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sat, 24 Oct 2009 11:57:18 -0200
Subject: [PATCH] serial, 8250: calculate irqflags bitmask before loop
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b1ae774..b22dcc3 100644
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

@@ -2940,10 +2942,13 @@ static int __devinit serial8250_probe(struct
platform_device *dev)
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
@@ -2960,8 +2965,7 @@ static int __devinit serial8250_probe(struct
platform_device *dev)
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
1.6.5.1.75.g02d56
