Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbXJRJcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbXJRJcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXJRJcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:32:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49817 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbXJRJcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:32:31 -0400
Message-ID: <4717281B.6070301@garzik.org>
Date: Thu, 18 Oct 2007 05:32:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk>
In-Reply-To: <20071018091706.GO5063@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------020104030304060807010003"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020104030304060807010003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> The sata_mv construct looks a bit odd. Does this work? That last

The sata_mv construct worked just fine before sg chaining :)


> end_mv_sg test should always be true, just being paranoid...
> 
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index 4df8311..5397eea 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -1138,8 +1138,9 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
>  {
>  	struct mv_port_priv *pp = qc->ap->private_data;
>  	struct scatterlist *sg;
> -	struct mv_sg *mv_sg;
> +	struct mv_sg *mv_sg, *end_mv_sg;
>  
> +	end_mv_sg = NULL;
>  	mv_sg = pp->sg_tbl;
>  	ata_for_each_sg(sg, qc) {
>  		dma_addr_t addr = sg_dma_address(sg);
> @@ -1158,14 +1159,12 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
>  
>  			sg_len -= len;
>  			addr += len;
> -
> -			if (!sg_len && ata_sg_is_last(sg, qc))
> -				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
> -
> +			end_mv_sg = mv_sg;
>  			mv_sg++;
>  		}
> -
>  	}
> +	if (end_mv_sg)
> +		end_mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
>  }
>  

I'm testing a similar patch based on ata_fill_sg()'s method, which 
basically does something similar to what you've done here (see 
attached).  I had noticed that ata_fill_sg() did not call ata_sg_is_last().

If this fixes the problem, I think the best solution would be to delete 
ata_sg_is_last().  In the few users that exist, we should be able to 
eliminate the test programmatically as you and ata_fill_sg() have done 
-- thereby eliminating a branch per loop in a hotpath.

Off to test the attached...  if that doesn't work I'll try your version, 
though there shouldn't be much difference.

	Jeff



--------------020104030304060807010003
Content-Type: text/plain;
 name="patch.sata_mv-fill-sg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.sata_mv-fill-sg"

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 4df8311..42b5a9e 100644
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
@@ -1138,34 +1126,35 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct mv_port_priv *pp = qc->ap->private_data;
 	struct scatterlist *sg;
-	struct mv_sg *mv_sg;
+	struct mv_sg *mv_sg = pp->sg_tbl;
+	unsigned int idx = 0;
 
-	mv_sg = pp->sg_tbl;
 	ata_for_each_sg(sg, qc) {
-		dma_addr_t addr = sg_dma_address(sg);
-		u32 sg_len = sg_dma_len(sg);
+		u64 addr;
+		u32 offset, sg_len, len;
+
+		addr = sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
 
 		while (sg_len) {
-			u32 offset = addr & 0xffff;
-			u32 len = sg_len;
+			offset = addr & 0xffff;
+			len = sg_len;
 
 			if ((offset + sg_len > 0x10000))
 				len = 0x10000 - offset;
 
-			mv_sg->addr = cpu_to_le32(addr & 0xffffffff);
-			mv_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
-			mv_sg->flags_size = cpu_to_le32(len & 0xffff);
+			mv_sg[idx].addr = cpu_to_le32(addr & 0xffffffff);
+			mv_sg[idx].addr_hi = cpu_to_le32(addr >> 32);
+			mv_sg[idx].flags_size = cpu_to_le32(len & 0xffff);
 
+			idx++;
 			sg_len -= len;
 			addr += len;
-
-			if (!sg_len && ata_sg_is_last(sg, qc))
-				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
-
-			mv_sg++;
 		}
-
 	}
+
+	if (idx)
+		mv_sg[idx - 1].flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
 }
 
 static inline void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)

--------------020104030304060807010003--
