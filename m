Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbZKKAEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbZKKAEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZKKAEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:04:12 -0500
Received: from khc.piap.pl ([195.187.100.11]:52458 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758724AbZKKAEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:04:11 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: SATA_SIL: Add a work-around for IXP4xx CPU.
Date: Wed, 11 Nov 2009 01:04:14 +0100
Message-ID: <m3fx8m0vwh.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IXP4xx CPUs can't read from 8 and 16-bit PCI MMIO registers, we have to read
from normal IO regions instead.

Tested on SIL3512, and specifically not tested on 4-port SIL3114.

Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -757,7 +757,22 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
+#ifdef CONFIG_ARCH_IXP4XX
+	/* IXP4xx CPUs can't perform 8 and 16-bit MMIO reads,
+	   use normal IO from/to regions 0-5 instead.
+	   region 0: channel 0 (and 2) task file regs
+	   region 1: channel 0 (and 2) auxiliary status
+	   region 2: channel 1 (and 3) task file regs
+	   region 3: channel 1 (and 3) auxiliary status
+	   region 4: bus master DMA command and status for all channels
+	   region 5: the normal MMIO
+
+	   Channels 2 and 3 are present only on SIL3114, device selection
+	   is done with ATA_DEV1 bit in ATA_REG_DEVICE. FIXME - untested */
+	rc = pcim_iomap_regions(pdev, 0x3F, DRV_NAME);
+#else
 	rc = pcim_iomap_regions(pdev, 1 << SIL_MMIO_BAR, DRV_NAME);
+#endif
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
@@ -777,10 +792,16 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		struct ata_port *ap = host->ports[i];
 		struct ata_ioports *ioaddr = &ap->ioaddr;
 
+#ifdef CONFIG_ARCH_IXP4XX
+		ioaddr->cmd_addr = host->iomap[(i % 2) * 2];
+		ioaddr->altstatus_addr = host->iomap[1 + (i % 2) * 2] + 2;
+		ioaddr->bmdma_addr = host->iomap[4] + sil_port[i % 2].bmdma;
+#else
 		ioaddr->cmd_addr = mmio_base + sil_port[i].tf;
-		ioaddr->altstatus_addr =
-		ioaddr->ctl_addr = mmio_base + sil_port[i].ctl;
+		ioaddr->altstatus_addr = mmio_base + sil_port[i].ctl;
 		ioaddr->bmdma_addr = mmio_base + sil_port[i].bmdma;
+#endif
+		ioaddr->ctl_addr = mmio_base + sil_port[i].ctl;
 		ioaddr->scr_addr = mmio_base + sil_port[i].scr;
 		ata_sff_std_ports(ioaddr);
 

-- 
Krzysztof Halasa
