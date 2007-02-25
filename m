Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbXBYH7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbXBYH7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 02:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933677AbXBYH7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 02:59:15 -0500
Received: from havoc.gtf.org ([69.61.125.42]:35004 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933675AbXBYH7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 02:59:14 -0500
Date: Sun, 25 Feb 2007 02:59:13 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sata_mv: clean up EDMA config register usage
Message-ID: <20070225075913.GA27150@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 346e14262ff04e5c85f069eb95f0bb7a64d7b062
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Feb 25 02:53:41 2007 -0500

    [libata] sata_mv: don't touch reserved bits in EDMA config register
    
    The code in mv_edma_cfg() reflected its 60xx origins, by doing things
    [slightly] incorrectly on the older 50xx and newer 6042/7042 chips.
    
    Clean up the EDMA configuration setup such that, each chip family
    carefully initializes its own EDMA setup.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/sata_mv.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

346e14262ff04e5c85f069eb95f0bb7a64d7b062
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index d689df5..137ff4e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -814,23 +814,27 @@ static void mv_edma_cfg(struct mv_host_priv *hpriv, void __iomem *port_mmio)
 	u32 cfg = readl(port_mmio + EDMA_CFG_OFS);
 
 	/* set up non-NCQ EDMA configuration */
-	cfg &= ~0x1f;		/* clear queue depth */
-	cfg &= ~EDMA_CFG_NCQ;	/* clear NCQ mode */
 	cfg &= ~(1 << 9);	/* disable equeue */
 
-	if (IS_GEN_I(hpriv))
+	if (IS_GEN_I(hpriv)) {
+		cfg &= ~0x1f;		/* clear queue depth */
 		cfg |= (1 << 8);	/* enab config burst size mask */
+	}
 
-	else if (IS_GEN_II(hpriv))
+	else if (IS_GEN_II(hpriv)) {
+		cfg &= ~0x1f;		/* clear queue depth */
 		cfg |= EDMA_CFG_RD_BRST_EXT | EDMA_CFG_WR_BUFF_LEN;
+		cfg &= ~(EDMA_CFG_NCQ | EDMA_CFG_NCQ_GO_ON_ERR); /* clear NCQ */
+	}
 
 	else if (IS_GEN_IIE(hpriv)) {
-		cfg |= (1 << 23);	/* dis RX PM port mask */
-		cfg &= ~(1 << 16);	/* dis FIS-based switching (for now) */
+		cfg |= (1 << 23);	/* do not mask PM field in rx'd FIS */
+		cfg |= (1 << 22);	/* enab 4-entry host queue cache */
 		cfg &= ~(1 << 19);	/* dis 128-entry queue (for now?) */
 		cfg |= (1 << 18);	/* enab early completion */
-		cfg |= (1 << 17);	/* enab host q cache */
-		cfg |= (1 << 22);	/* enab cutthrough */
+		cfg |= (1 << 17);	/* enab cut-through (dis stor&forwrd) */
+		cfg &= ~(1 << 16);	/* dis FIS-based switching (for now) */
+		cfg &= ~(EDMA_CFG_NCQ | EDMA_CFG_NCQ_GO_ON_ERR); /* clear NCQ */
 	}
 
 	writelfl(cfg, port_mmio + EDMA_CFG_OFS);
