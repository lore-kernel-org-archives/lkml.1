Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZENOub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZENOub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZENOuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:50:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:53506 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZENOuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:50:19 -0400
Date: Thu, 14 May 2009 09:47:07 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, daveliu@freescale.com
Subject: [PATCH] sata_fsl: Fix the command description of FSL SATA controller
Message-ID: <Pine.LNX.4.64.0905140945540.8378@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Liu <daveliu@freescale.com>

The bit 11 of command description is reserved bit in Freescale
SATA controller and needs to be set to '1'.  This is needed to
make sure the last write from the controller to the buffer
descriptor is seen before an interrupt is raised.

Signed-off-by: Dave Liu <daveliu@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Jeff, please pick this up as a bug fix for 2.6.30

 drivers/ata/sata_fsl.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 5edd654..36b8629 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -205,6 +205,7 @@ struct cmdhdr_tbl_entry {
  * Description information bitdefs
  */
 enum {
+	CMD_DESC_RES = (1 << 11),
 	VENDOR_SPECIFIC_BIST = (1 << 10),
 	CMD_DESC_SNOOP_ENABLE = (1 << 9),
 	FPDMA_QUEUED_CMD = (1 << 8),
@@ -388,7 +389,7 @@ static void sata_fsl_qc_prep(struct ata_queued_cmd *qc)
 	void __iomem *hcr_base = host_priv->hcr_base;
 	unsigned int tag = sata_fsl_tag(qc->tag, hcr_base);
 	struct command_desc *cd;
-	u32 desc_info = CMD_DESC_SNOOP_ENABLE;
+	u32 desc_info = CMD_DESC_RES | CMD_DESC_SNOOP_ENABLE;
 	u32 num_prde = 0;
 	u32 ttl_dwords = 0;
 	dma_addr_t cd_paddr;
@@ -841,7 +842,7 @@ issue_srst:

 	/* device reset/SRST is a control register update FIS, uses tag0 */
 	sata_fsl_setup_cmd_hdr_entry(pp, 0,
-				     SRST_CMD | CMD_DESC_SNOOP_ENABLE, 0, 0, 5);
+		SRST_CMD | CMD_DESC_RES | CMD_DESC_SNOOP_ENABLE, 0, 0, 5);

 	tf.ctl |= ATA_SRST;	/* setup SRST bit in taskfile control reg */
 	ata_tf_to_fis(&tf, pmp, 0, cfis);
@@ -887,7 +888,8 @@ issue_srst:
 	 * using ATA signature D2H register FIS to the host controller.
 	 */

-	sata_fsl_setup_cmd_hdr_entry(pp, 0, CMD_DESC_SNOOP_ENABLE, 0, 0, 5);
+	sata_fsl_setup_cmd_hdr_entry(pp, 0, CMD_DESC_RES | CMD_DESC_SNOOP_ENABLE,
+				      0, 0, 5);

 	tf.ctl &= ~ATA_SRST;	/* 2nd H2D Ctl. register FIS */
 	ata_tf_to_fis(&tf, pmp, 0, cfis);
-- 
1.6.0.6

