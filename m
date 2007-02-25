Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbXBYQv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbXBYQv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 11:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbXBYQv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 11:51:27 -0500
Received: from aun.it.uu.se ([130.238.12.36]:39187 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbXBYQv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 11:51:26 -0500
Date: Sun, 25 Feb 2007 17:51:15 +0100 (MET)
Message-Id: <200702251651.l1PGpFmD004379@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 2.6.21-rc1] sata_promise: simplify port setup
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Each place in pdc_ata_init_one() that initialises a SATA
port first calls pdc_ata_setup_port(), and then manually
assigns the port's ->scr_addr. Simplify the code by extending
pdc_ata_setup_port() to also handle scr_addr initialisation;
for PATA ports we pass NULL as scr_addr.

The initialisation of the PATA-only 20619 redundantly set
up scr_addr for the ports. Remove this.

Tested on 20619, 20575, and 20775 chips.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

---

 drivers/ata/sata_promise.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff -rupN linux-2.6.21-rc1/drivers/ata/sata_promise.c linux-2.6.21-rc1.sata_promise-setup_port-cleanup/drivers/ata/sata_promise.c
--- linux-2.6.21-rc1/drivers/ata/sata_promise.c	2007-02-25 14:24:09.000000000 +0100
+++ linux-2.6.21-rc1.sata_promise-setup_port-cleanup/drivers/ata/sata_promise.c	2007-02-25 14:24:30.000000000 +0100
@@ -777,7 +777,8 @@ static int pdc_old_check_atapi_dma(struc
 	return pdc_check_atapi_dma(qc);
 }
 
-static void pdc_ata_setup_port(struct ata_ioports *port, void __iomem *base)
+static void pdc_ata_setup_port(struct ata_ioports *port, void __iomem *base,
+			       void __iomem *scr_addr)
 {
 	port->cmd_addr		= base;
 	port->data_addr		= base;
@@ -792,6 +793,7 @@ static void pdc_ata_setup_port(struct at
 	port->status_addr	= base + 0x1c;
 	port->altstatus_addr	=
 	port->ctl_addr		= base + 0x38;
+	port->scr_addr		= scr_addr;
 }
 
 
@@ -904,11 +906,8 @@ static int pdc_ata_init_one (struct pci_
 
 	base = probe_ent->iomap[PDC_MMIO_BAR];
 
-	pdc_ata_setup_port(&probe_ent->port[0], base + 0x200);
-	pdc_ata_setup_port(&probe_ent->port[1], base + 0x280);
-
-	probe_ent->port[0].scr_addr = base + 0x400;
-	probe_ent->port[1].scr_addr = base + 0x500;
+	pdc_ata_setup_port(&probe_ent->port[0], base + 0x200, base + 0x400);
+	pdc_ata_setup_port(&probe_ent->port[1], base + 0x280, base + 0x500);
 
 	/* notice 4-port boards */
 	switch (board_idx) {
@@ -917,12 +916,8 @@ static int pdc_ata_init_one (struct pci_
 		/* Fall through */
 	case board_20319:
        		probe_ent->n_ports = 4;
-
-		pdc_ata_setup_port(&probe_ent->port[2], base + 0x300);
-		pdc_ata_setup_port(&probe_ent->port[3], base + 0x380);
-
-		probe_ent->port[2].scr_addr = base + 0x600;
-		probe_ent->port[3].scr_addr = base + 0x700;
+		pdc_ata_setup_port(&probe_ent->port[2], base + 0x300, base + 0x600);
+		pdc_ata_setup_port(&probe_ent->port[3], base + 0x380, base + 0x700);
 		break;
 	case board_2057x:
 		hp->flags |= PDC_FLAG_GEN_II;
@@ -932,7 +927,7 @@ static int pdc_ata_init_one (struct pci_
 		tmp = readb(base + PDC_FLASH_CTL+1);
 		if (!(tmp & 0x80)) {
 			probe_ent->n_ports = 3;
-			pdc_ata_setup_port(&probe_ent->port[2], base + 0x300);
+			pdc_ata_setup_port(&probe_ent->port[2], base + 0x300, NULL);
 			hp->port_flags[2] = ATA_FLAG_SLAVE_POSS;
 			printk(KERN_INFO DRV_NAME " PATA port found\n");
 		} else
@@ -942,12 +937,8 @@ static int pdc_ata_init_one (struct pci_
 		break;
 	case board_20619:
 		probe_ent->n_ports = 4;
-
-		pdc_ata_setup_port(&probe_ent->port[2], base + 0x300);
-		pdc_ata_setup_port(&probe_ent->port[3], base + 0x380);
-
-		probe_ent->port[2].scr_addr = base + 0x600;
-		probe_ent->port[3].scr_addr = base + 0x700;
+		pdc_ata_setup_port(&probe_ent->port[2], base + 0x300, NULL);
+		pdc_ata_setup_port(&probe_ent->port[3], base + 0x380, NULL);
 		break;
 	default:
 		BUG();
