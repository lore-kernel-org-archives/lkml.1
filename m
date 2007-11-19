Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXKSOnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXKSOnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXKSOm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:42:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58046 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbXKSOm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:42:57 -0500
Date: Mon, 19 Nov 2007 14:41:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_isapnp: Polled devices
Message-ID: <20071119144105.6ce66cd0@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a card has no IRQ then pass no interrupt handler but allow polled
usage.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/ata/pata_isapnp.c linux-2.6.24-rc2-mm1/drivers/ata/pata_isapnp.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/ata/pata_isapnp.c	2007-11-16 17:54:39.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/ata/pata_isapnp.c	2007-11-16 18:14:29.000000000 +0000
@@ -75,13 +75,16 @@
 	struct ata_host *host;
 	struct ata_port *ap;
 	void __iomem *cmd_addr, *ctl_addr;
+	int irq = 0;
+	irq_handler_t handler = NULL;
 
 	if (pnp_port_valid(idev, 0) == 0)
 		return -ENODEV;
 
-	/* FIXME: Should selected polled PIO here not fail */
-	if (pnp_irq_valid(idev, 0) == 0)
-		return -ENODEV;
+	if (pnp_irq_valid(idev, 0)) {
+		irq = pnp_irq(idev, 0);
+		handler = ata_interrupt;
+	}
 
 	/* allocate host */
 	host = ata_host_alloc(&idev->dev, 1);
@@ -115,7 +118,7 @@
 		      (unsigned long long)pnp_port_start(idev, 1));
 
 	/* activate */
-	return ata_host_activate(host, pnp_irq(idev, 0), ata_interrupt, 0,
+	return ata_host_activate(host, irq, handler, 0,
 				 &isapnp_sht);
 }
 
