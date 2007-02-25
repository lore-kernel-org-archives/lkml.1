Return-Path: <linux-kernel-owner+w=401wt.eu-S1750953AbXBYJXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953AbXBYJXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 04:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXBYJXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 04:23:34 -0500
Received: from havoc.gtf.org ([69.61.125.42]:35149 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXBYJXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 04:23:33 -0500
Date: Sun, 25 Feb 2007 04:23:31 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sata_mv: fix 50xx irq mask
Message-ID: <20070225092331.GA15203@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 7aa3ffd983c12d224e33e5d4f89ad083392f9d8d
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Feb 25 04:19:45 2007 -0500

    [libata] sata_mv: Fix 50xx irq mask
    
    IRQ mask bits assumed a 60xx or newer generation chip, which is very
    wrong for the 50xx series.  Luckily both generations shared the per-port
    interrupt mask bits, leaving only the "misc chip features" bits to be
    completely mismatched.
    
    Fix 50xx by ensuring we only program bits that exist.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/sata_mv.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

7aa3ffd983c12d224e33e5d4f89ad083392f9d8d
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 30fd84e..208a9d8 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -137,14 +137,19 @@ enum {
 	PCI_ERR			= (1 << 18),
 	TRAN_LO_DONE		= (1 << 19),	/* 6xxx: IRQ coalescing */
 	TRAN_HI_DONE		= (1 << 20),	/* 6xxx: IRQ coalescing */
+	PORTS_0_3_COAL_DONE	= (1 << 8),
+	PORTS_4_7_COAL_DONE	= (1 << 17),
 	PORTS_0_7_COAL_DONE	= (1 << 21),	/* 6xxx: IRQ coalescing */
 	GPIO_INT		= (1 << 22),
 	SELF_INT		= (1 << 23),
 	TWSI_INT		= (1 << 24),
 	HC_MAIN_RSVD		= (0x7f << 25),	/* bits 31-25 */
+	HC_MAIN_RSVD_5		= (0x1fff << 19), /* bits 31-19 */
 	HC_MAIN_MASKED_IRQS	= (TRAN_LO_DONE | TRAN_HI_DONE |
 				   PORTS_0_7_COAL_DONE | GPIO_INT | TWSI_INT |
 				   HC_MAIN_RSVD),
+	HC_MAIN_MASKED_IRQS_5	= (PORTS_0_3_COAL_DONE | PORTS_4_7_COAL_DONE |
+				   HC_MAIN_RSVD_5),
 
 	/* SATAHC registers */
 	HC_CFG_OFS		= 0,
@@ -2239,7 +2244,11 @@ static int mv_init_host(struct pci_dev *pdev, struct ata_probe_ent *probe_ent,
 
 	/* and unmask interrupt generation for host regs */
 	writelfl(PCI_UNMASK_ALL_IRQS, mmio + PCI_IRQ_MASK_OFS);
-	writelfl(~HC_MAIN_MASKED_IRQS, mmio + HC_MAIN_IRQ_MASK_OFS);
+
+	if (IS_50XX(hpriv))
+		writelfl(~HC_MAIN_MASKED_IRQS_5, mmio + HC_MAIN_IRQ_MASK_OFS);
+	else
+		writelfl(~HC_MAIN_MASKED_IRQS, mmio + HC_MAIN_IRQ_MASK_OFS);
 
 	VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x "
 		"PCI int cause/mask=0x%08x/0x%08x\n",
