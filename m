Return-Path: <linux-kernel-owner+w=401wt.eu-S1764495AbYD2Nmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764495AbYD2Nmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYD2Nmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:42:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49603 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755864AbYD2Nml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:42:41 -0400
Date: Tue, 29 Apr 2008 14:34:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8250: Switch 8250 drivers to use _nocache ioremaps
Message-ID: <20080429143419.7d12812b@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/serial/8250.c linux-2.6.25-mm1/drivers/serial/8250.c
--- linux.vanilla-2.6.25-mm1/drivers/serial/8250.c	2008-04-28 11:36:50.000000000 +0100
+++ linux-2.6.25-mm1/drivers/serial/8250.c	2008-04-28 10:11:41.000000000 +0100
@@ -2271,7 +2271,8 @@
 		}
 
 		if (up->port.flags & UPF_IOREMAP) {
-			up->port.membase = ioremap(up->port.mapbase, size);
+			up->port.membase = ioremap_nocache(up->port.mapbase,
+									size);
 			if (!up->port.membase) {
 				release_mem_region(up->port.mapbase, size);
 				ret = -ENOMEM;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/serial/8250_early.c linux-2.6.25-mm1/drivers/serial/8250_early.c
--- linux.vanilla-2.6.25-mm1/drivers/serial/8250_early.c	2008-04-28 11:36:50.000000000 +0100
+++ linux-2.6.25-mm1/drivers/serial/8250_early.c	2008-04-28 10:11:55.000000000 +0100
@@ -153,7 +153,7 @@
 			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
 		port->membase += port->mapbase & ~PAGE_MASK;
 #else
-		port->membase = ioremap(port->mapbase, 64);
+		port->membase = ioremap_nocache(port->mapbase, 64);
 		if (!port->membase) {
 			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
 				__func__,
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/serial/8250_pci.c linux-2.6.25-mm1/drivers/serial/8250_pci.c
--- linux.vanilla-2.6.25-mm1/drivers/serial/8250_pci.c	2008-04-28 11:36:50.000000000 +0100
+++ linux-2.6.25-mm1/drivers/serial/8250_pci.c	2008-04-28 10:11:16.000000000 +0100
@@ -86,7 +86,7 @@
 		len =  pci_resource_len(dev, bar);
 
 		if (!priv->remapped_bar[bar])
-			priv->remapped_bar[bar] = ioremap(base, len);
+			priv->remapped_bar[bar] = ioremap_nocache(base, len);
 		if (!priv->remapped_bar[bar])
 			return -ENOMEM;
 
@@ -270,7 +270,7 @@
 	/*
 	 * enable/disable interrupts
 	 */
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p == NULL)
 		return -ENOMEM;
 	writel(irq_config, p + 0x4c);
@@ -294,7 +294,7 @@
 	/*
 	 * disable interrupts
 	 */
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p != NULL) {
 		writel(0, p + 0x4c);
 
@@ -341,7 +341,8 @@
 {
 	u8 __iomem *p;
 
-	p = ioremap(pci_resource_start(dev, 0), pci_resource_len(dev, 0));
+	p = ioremap_nocache(pci_resource_start(dev, 0),
+						pci_resource_len(dev, 0));
 
 	if (p == NULL)
 		return -ENOMEM;
@@ -365,7 +366,8 @@
 {
 	u8 __iomem *p;
 
-	p = ioremap(pci_resource_start(dev, 0), pci_resource_len(dev, 0));
+	p = ioremap_nocache(pci_resource_start(dev, 0),
+					pci_resource_len(dev, 0));
 	/* FIXME: What if resource_len < OCT_REG_CR_OFF */
 	if (p != NULL)
 		writeb(0, p + OCT_REG_CR_OFF);
@@ -419,7 +421,7 @@
 		break;
 	}
 
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p == NULL)
 		return -ENOMEM;
 
