Return-Path: <linux-kernel-owner+w=401wt.eu-S932946AbXJREbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbXJREbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbXJREbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:31:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53292 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbXJREbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:31:40 -0400
Message-ID: <4716E19F.1090201@garzik.org>
Date: Thu, 18 Oct 2007 00:31:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org> <4716D6B1.8010309@rtr.ca> <alpine.LFD.0.999.0710172100420.26902@woody.linux-foundation.org> <4716DB9A.2060809@rtr.ca> <4716DE82.2050006@rtr.ca>
In-Reply-To: <4716DE82.2050006@rtr.ca>
Content-Type: multipart/mixed;
 boundary="------------000003090700070708010602"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000003090700070708010602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mark Lord wrote:
> Okay, mine is dying with EIP at blk_rq_map_sg+0xcb/0x160.
> 
> Screen photo is at http://rtr.ca/recent/2.6.23-git12-crash.jpg,
> but the top was cut off (isn't there a new config option or patch
> to do double-columns or scrollback or something ???.

Is this a sata_mv box?  If so, could you try this patch?

	Jeff




--------------000003090700070708010602
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 4df8311..d8cf8b1 100644
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

--------------000003090700070708010602--
