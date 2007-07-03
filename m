Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbXGCOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbXGCOwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXGCOwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:52:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42188 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753836AbXGCOwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:52:05 -0400
Date: Tue, 3 Jul 2007 15:58:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libata-sff: Kiss ATA_PRIMARY_* goodbye
Message-ID: <20070703155815.16391674@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've been setting the PCI resources correctly in the PCI layer for some
time so remove this special casing. 

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-sff.c linux-2.6.22-rc6-mm1/drivers/ata/libata-sff.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-sff.c	2007-07-02 20:48:49.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/libata-sff.c	2007-07-03 13:15:48.000000000 +0100
@@ -774,16 +774,13 @@
 				struct ata_legacy_devres *legacy_dr)
 {
 	struct ata_host *host = ap->host;
+	struct device *gdev = host->dev;
+	struct pci_dev *pdev = to_pci_dev(gdev);
 	int port_no = ap->port_no;
 	unsigned long cmd_port, ctl_port;
 
-	if (port_no == 0) {
-		cmd_port = ATA_PRIMARY_CMD;
-		ctl_port = ATA_PRIMARY_CTL;
-	} else {
-		cmd_port = ATA_SECONDARY_CMD;
-		ctl_port = ATA_SECONDARY_CTL;
-	}
+	cmd_port = pci_resource_start(pdev, port_no * 2);
+	ctl_port = pci_resource_start(pdev, port_no * 2 + 1);
 
 	/* request cmd_port */
 	if (request_region(cmd_port, 8, "libata"))
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/include/asm-generic/libata-portmap.h linux-2.6.22-rc6-mm1/include/asm-generic/libata-portmap.h
--- linux.vanilla-2.6.22-rc6-mm1/include/asm-generic/libata-portmap.h	2007-07-02 20:47:33.000000000 +0100
+++ linux-2.6.22-rc6-mm1/include/asm-generic/libata-portmap.h	2007-07-03 13:16:13.000000000 +0100
@@ -1,12 +1,7 @@
 #ifndef __ASM_GENERIC_LIBATA_PORTMAP_H
 #define __ASM_GENERIC_LIBATA_PORTMAP_H
 
-#define ATA_PRIMARY_CMD		0x1F0
-#define ATA_PRIMARY_CTL		0x3F6
 #define ATA_PRIMARY_IRQ(dev)	14
-
-#define ATA_SECONDARY_CMD	0x170
-#define ATA_SECONDARY_CTL	0x376
 #define ATA_SECONDARY_IRQ(dev)	15
 
 #endif
