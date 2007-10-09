Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbXJIRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbXJIRwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXJIRwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:52:00 -0400
Received: from havoc.gtf.org ([69.61.125.42]:41401 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbXJIRv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:51:59 -0400
Date: Tue, 9 Oct 2007 13:51:57 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sata_mv: correct S/G table limits
Message-ID: <20071009175157.GA27633@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The recent mv_fill_sg() rewrite, to fix a data corruption problem
related to IOMMU virtual merging, forgot to account for the
potentially-increased size of the scatter/gather table after its run.

Additionally, the DMA boundary is reduced from 0xffffffff to 0xffff
to more closely match the needs of mv_fill_sg().

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/sata_mv.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 1a82e22..cb7dec9 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -313,7 +313,10 @@ enum {
 #define IS_GEN_IIE(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_IIE)
 
 enum {
-	MV_DMA_BOUNDARY		= 0xffffffffU,
+	/* DMA boundary 0xffff is required by the s/g splitting
+	 * we need on /length/ in mv_fill-sg().
+	 */
+	MV_DMA_BOUNDARY		= 0xffffU,
 
 	/* mask of register bits containing lower 32 bits
 	 * of EDMA request queue DMA address
@@ -448,7 +451,7 @@ static struct scsi_host_template mv5_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= MV_MAX_SG_CT,
+	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= 1,
@@ -466,7 +469,7 @@ static struct scsi_host_template mv6_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= MV_MAX_SG_CT,
+	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= 1,
