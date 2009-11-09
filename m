Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbZKIRbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbZKIRbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbZKIRbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:31:19 -0500
Received: from khc.piap.pl ([195.187.100.11]:36241 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZKIRbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:31:17 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: SATA_SIL on IXP425 workaround
Date: Mon, 09 Nov 2009 18:31:21 +0100
Message-ID: <m33a4nfvva.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to add a workaround for IXP4xx CPUs to SATA SIL driver. The
problem is that IXP4xx CPUs (Intel's XScale (ARM) network-oriented
processors) are unable to perform 8 and 16-bit read from PCI MMIO, they
can only do a full 32-bit readl(); SIL chips respond to that with PCI
abort. The workaround is to use 8 and 16-bit regular IO reads (inb/inw)
instead (MMIO write is not a problem).

For SIL3x12 the workaround is simple (attached) and it works on my 3512.
I'm not sure about 3114 (the 4-port chip) - the PIO BARs have TF, CTL
and BWDMA registers which are common to channels 0 and 2, and (the other
set) to channels 1 and 3. Channel selection is done with bit 4 of
device/head TF register, this is similar (same?) as PATA master/slave.
Does that mean that I can simply treat channel 0 as PRI master, ch#2 as
PRI slave, ch#1 as SEC master and ch#3 as SEC slave, and the SFF code
will select the right device correctly? Does it need additional code?
I don't have anything based on 3114.

Note: the large PRD is not a problem here, the transfer can be started
by MMIO write. Only reads are an issue.

--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -757,7 +757,12 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
+#ifdef CONFIG_ARCH_IXP4XX
+	/* We need all 6 regions on IXP4xx */
+	rc = pcim_iomap_regions(pdev, 0x3F, DRV_NAME);
+#else
 	rc = pcim_iomap_regions(pdev, 1 << SIL_MMIO_BAR, DRV_NAME);
+#endif
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
@@ -777,10 +782,18 @@ static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		struct ata_port *ap = host->ports[i];
 		struct ata_ioports *ioaddr = &ap->ioaddr;
 
+#ifdef CONFIG_ARCH_IXP4XX
+		/* IXP4xx CPUs can't perform 8 and 16-bit MMIO reads,
+		   use normal IO from/to regions 0-5 instead */
+		ioaddr->cmd_addr = host->iomap[i * 2];
+		ioaddr->altstatus_addr = host->iomap[1 + i * 2] + 2;
+		ioaddr->bmdma_addr = host->iomap[4] + sil_port[i].bmdma;
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
