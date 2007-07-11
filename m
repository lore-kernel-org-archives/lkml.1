Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXGKADA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXGKADA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbXGKABV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:01:21 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38446 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763310AbXGKABB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:01:01 -0400
Date: Tue, 10 Jul 2007 17:03:35 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] serial: do not add port that is not initialized
To: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andi Kleen <ak@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707101703.36173.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] serial: do not add port that is not initialized

if the port is not initialized with correct iobase, and membase, we don't
need to add that port.
for x86, when pnpacpi is enabled, we will not get extra ttyS1/ttyS2/ttyS3 in
/sys/devices/platform/serial8250/tty

Sign-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c84dab0..6399014 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2425,9 +2425,12 @@ serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 	for (i = 0; i < nr_uarts; i++) {
 		struct uart_8250_port *up = &serial8250_ports[i];
 
+		if (!up->port.iobase && !up->port.membase)
+			continue;
 		up->port.dev = dev;
 		uart_add_one_port(drv, &up->port);
 	}
+
 }
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE

