Return-Path: <linux-kernel-owner+w=401wt.eu-S1762979AbXJRKnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762979AbXJRKnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbXJRKnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:43:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49156 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbXJRKnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:43:13 -0400
Message-ID: <471738A6.2020201@garzik.org>
Date: Thu, 18 Oct 2007 06:42:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tejun Heo <htejun@gmail.com>, Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org> <20071018100959.GQ5063@kernel.dk>
In-Reply-To: <20071018100959.GQ5063@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------020707030107060602070709"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020707030107060602070709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Thu, Oct 18 2007, Jeff Garzik wrote:
>> Jens Axboe wrote:
>>> That should work as well. WRT ata_sg_is_last(), if we go ahead with my
>>> recent sg chaining updates, we can keep the test as it would be a single
>>> conditional and not require any looping.
>>> Let me know when you have tested this!
>> The patch I attached to the last email got both sata_mv test boxes working 
>> reliably (so far).
>>
>> I worked up a patch that kills ata_sg_is_last() (plus the max_phys_segments 
>> sata_mv fix), see attached.  I'm thinking this is what I like to see in 
>> upstream.
> 
> Great!
> 
>> Of course, this doesn't explain why ata_sg_is_last() was broken, but since 
>> it's working _and_ slightly more efficient, I don't really care :)
> 
> Tomo and I agreed to kill sg_last() a few days ago anyways, so this is
> perfectly fine with me.

Yep, the [attached] patch that kills ata_sg_is_last() is working here on 
both machines that were previously croaking.

It would be nice to get pdc_adma, sata_sil24 and ipr it-works test done, 
but IMO the patch is pretty straightforward and should be OK.

	Jeff



--------------020707030107060602070709
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 8d1b03d..199f7e1 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -318,7 +318,7 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	struct ata_port *ap = qc->ap;
 	struct adma_port_priv *pp = ap->private_data;
-	u8  *buf = pp->pkt;
+	u8  *buf = pp->pkt, *last_buf = NULL;
 	int i = (2 + buf[3]) * 8;
 	u8 pFLAGS = pORD | ((qc->tf.flags & ATA_TFLAG_WRITE) ? pDIRO : 0);
 
@@ -334,8 +334,7 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 		*(__le32 *)(buf + i) = cpu_to_le32(len);
 		i += 4;
 
-		if (ata_sg_is_last(sg, qc))
-			pFLAGS |= pEND;
+		last_buf = &buf[i];
 		buf[i++] = pFLAGS;
 		buf[i++] = qc->dev->dma_mode & 0xf;
 		buf[i++] = 0;	/* pPKLW */
@@ -348,6 +347,10 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 		VPRINTK("PRD[%u] = (0x%lX, 0x%X)\n", i/4,
 					(unsigned long)addr, len);
 	}
+
+	if (likely(last_buf))
+		*last_buf |= pEND;
+
 	return i;
 }
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 4df8311..7f1b13e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -421,7 +421,6 @@ static void mv_error_handler(struct ata_port *ap);
 static void mv_post_int_cmd(struct ata_queued_cmd *qc);
 static void mv_eh_freeze(struct ata_port *ap);
 static void mv_eh_thaw(struct ata_port *ap);
-static int mv_slave_config(struct scsi_device *sdev);
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -459,7 +458,7 @@ static struct scsi_host_template mv5_sht = {
 	.use_clustering		= 1,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= MV_DMA_BOUNDARY,
-	.slave_configure	= mv_slave_config,
+	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 };
@@ -477,7 +476,7 @@ static struct scsi_host_template mv6_sht = {
 	.use_clustering		= 1,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= MV_DMA_BOUNDARY,
-	.slave_configure	= mv_slave_config,
+	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 };
@@ -756,17 +755,6 @@ static void mv_irq_clear(struct ata_port *ap)
 {
 }
 
-static int mv_slave_config(struct scsi_device *sdev)
-{
-	int rc = ata_scsi_slave_config(sdev);
-	if (rc)
-		return rc;
-
-	blk_queue_max_phys_segments(sdev->request_queue, MV_MAX_SG_CT / 2);
-
-	return 0;	/* scsi layer doesn't check return value, sigh */
-}
-
 static void mv_set_edma_ptrs(void __iomem *port_mmio,
 			     struct mv_host_priv *hpriv,
 			     struct mv_port_priv *pp)
@@ -1138,7 +1126,7 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct mv_port_priv *pp = qc->ap->private_data;
 	struct scatterlist *sg;
-	struct mv_sg *mv_sg;
+	struct mv_sg *mv_sg, *last_sg = NULL;
 
 	mv_sg = pp->sg_tbl;
 	ata_for_each_sg(sg, qc) {
@@ -1159,13 +1147,13 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 			sg_len -= len;
 			addr += len;
 
-			if (!sg_len && ata_sg_is_last(sg, qc))
-				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
-
+			last_sg = mv_sg;
 			mv_sg++;
 		}
-
 	}
+
+	if (likely(last_sg))
+		last_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
 }
 
 static inline void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index b061927..26ebffc 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -796,16 +796,19 @@ static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
 				 struct sil24_sge *sge)
 {
 	struct scatterlist *sg;
+	struct sil24_sge *last_sge = NULL;
 
 	ata_for_each_sg(sg, qc) {
 		sge->addr = cpu_to_le64(sg_dma_address(sg));
 		sge->cnt = cpu_to_le32(sg_dma_len(sg));
-		if (ata_sg_is_last(sg, qc))
-			sge->flags = cpu_to_le32(SGE_TRM);
-		else
-			sge->flags = 0;
+		sge->flags = 0;
+
+		last_sge = sge;
 		sge++;
 	}
+
+	if (likely(last_sge))
+		last_sge->flags = cpu_to_le32(SGE_TRM);
 }
 
 static int sil24_qc_defer(struct ata_queued_cmd *qc)
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b41dfb5..c316a0b 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5134,6 +5134,7 @@ static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
 	u32 ioadl_flags = 0;
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
+	struct ipr_ioadl_desc *last_ioadl = NULL;
 	int len = qc->nbytes + qc->pad_len;
 	struct scatterlist *sg;
 
@@ -5156,11 +5157,13 @@ static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
 	ata_for_each_sg(sg, qc) {
 		ioadl->flags_and_data_len = cpu_to_be32(ioadl_flags | sg_dma_len(sg));
 		ioadl->address = cpu_to_be32(sg_dma_address(sg));
-		if (ata_sg_is_last(sg, qc))
-			ioadl->flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
-		else
-			ioadl++;
+
+		last_ioadl = ioadl;
+		ioadl++;
 	}
+
+	if (likely(last_ioadl))
+		last_ioadl->flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
 }
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 377e6d4..bc3b6fc 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1037,18 +1037,6 @@ extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 /*
  * qc helpers
  */
-static inline int
-ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
-{
-	if (sg == &qc->pad_sgent)
-		return 1;
-	if (qc->pad_len)
-		return 0;
-	if (qc->n_iter == qc->n_elem)
-		return 1;
-	return 0;
-}
-
 static inline struct scatterlist *
 ata_qc_first_sg(struct ata_queued_cmd *qc)
 {

--------------020707030107060602070709--
