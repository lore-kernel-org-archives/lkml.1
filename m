Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbXJCSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbXJCSwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXJCSwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:52:01 -0400
Received: from havoc.gtf.org ([69.61.125.42]:56477 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXJCSwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:52:00 -0400
Date: Wed, 3 Oct 2007 14:51:58 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071003185158.GA28932@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix ugly sata_mv bug, that exists due to lack of IOMMU knowledge about
device constraints (FUJITA Tomonori's current work should fix this issue
long term, hopefully).


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_ixp4xx_cf.c |    3 +++
 drivers/ata/pata_marvell.c   |    4 ++--
 drivers/ata/sata_mv.c        |   26 +++++++++++++++++++-------
 3 files changed, 24 insertions(+), 9 deletions(-)

Jiri Slaby (1):
      Ata: pata_marvell, use ioread* for iomap-ped memory

Olof Johansson (1):
      libata: fix for sata_mv >64KB DMA segments

Scott Thompson (1):
      drivers/ata/pata_ixp4xx_cf.c: ioremap return code check

diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 4ca7fd6..5dea358 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -189,6 +189,9 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
 
+	if (!data->cs0 || !data->cs1)
+		return -ENOMEM;
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq)
 		set_irq_type(irq, IRQT_RISING);
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index ae206f3..b45506f 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -44,10 +44,10 @@ static int marvell_pre_reset(struct ata_port *ap, unsigned long deadline)
 		return -ENOMEM;
 	printk("BAR5:");
 	for(i = 0; i <= 0x0F; i++)
-		printk("%02X:%02X ", i, readb(barp + i));
+		printk("%02X:%02X ", i, ioread8(barp + i));
 	printk("\n");
 
-	devices = readl(barp + 0x0C);
+	devices = ioread32(barp + 0x0C);
 	pci_iounmap(pdev, barp);
 
 	if ((pdev->device == 0x6145) && (ap->port_no == 0) &&
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 11bf6c7..1a82e22 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1139,15 +1139,27 @@ static unsigned int mv_fill_sg(struct ata_queued_cmd *qc)
 		dma_addr_t addr = sg_dma_address(sg);
 		u32 sg_len = sg_dma_len(sg);
 
-		mv_sg->addr = cpu_to_le32(addr & 0xffffffff);
-		mv_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
-		mv_sg->flags_size = cpu_to_le32(sg_len & 0xffff);
+		while (sg_len) {
+			u32 offset = addr & 0xffff;
+			u32 len = sg_len;
 
-		if (ata_sg_is_last(sg, qc))
-			mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
+			if ((offset + sg_len > 0x10000))
+				len = 0x10000 - offset;
+
+			mv_sg->addr = cpu_to_le32(addr & 0xffffffff);
+			mv_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
+			mv_sg->flags_size = cpu_to_le32(len);
+
+			sg_len -= len;
+			addr += len;
+
+			if (!sg_len && ata_sg_is_last(sg, qc))
+				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
+
+			mv_sg++;
+			n_sg++;
+		}
 
-		mv_sg++;
-		n_sg++;
 	}
 
 	return n_sg;
