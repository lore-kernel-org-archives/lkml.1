Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXITNN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXITNN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXITNNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:13:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53806 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbXITNNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:13:19 -0400
Date: Thu, 20 Sep 2007 14:13:15 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: 2.6.23-rc6-mm1: Build failure on ppc64 drivers/ata/pata_scc.c
Message-ID: <20070920131315.GE24105@skynet.ie>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PPC64 building allmodconfig fails to compile drivers/ata/pata_scc.c . It
doesn't show up on other arches because this driver is specific to the
architecture.

drivers/ata/pata_scc.c: In function `scc_bmdma_status':
drivers/ata/pata_scc.c:734: error: structure has no member named `active_tag'
drivers/ata/pata_scc.c: In function `scc_pata_prereset':
drivers/ata/pata_scc.c:866: warning: passing arg 1 of `ata_std_prereset' from incompatible pointer type
drivers/ata/pata_scc.c: In function `scc_error_handler':
drivers/ata/pata_scc.c:908: warning: passing arg 2 of `ata_bmdma_drive_eh' from incompatible pointer type
drivers/ata/pata_scc.c:908: warning: passing arg 3 of `ata_bmdma_drive_eh' from incompatible pointer type
drivers/ata/pata_scc.c:908: warning: passing arg 5 of `ata_bmdma_drive_eh' from incompatible pointer type
make[2]: *** [drivers/ata/pata_scc.o] Error 1
make[1]: *** [drivers/ata] Error 2
make: *** [drivers] Error 2

The problem seems to be in git-libata-all.patch but based on similar
changes in this patch, the following patch should be the fix. 

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 drivers/ata/pata_scc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc6-mm1-025_fix_ppc64_kgdb/drivers/ata/pata_scc.c linux-2.6.23-rc6-mm1-030_fix_ppc64_sata/drivers/ata/pata_scc.c
--- linux-2.6.23-rc6-mm1-025_fix_ppc64_kgdb/drivers/ata/pata_scc.c	2007-09-18 11:29:26.000000000 +0100
+++ linux-2.6.23-rc6-mm1-030_fix_ppc64_sata/drivers/ata/pata_scc.c	2007-09-20 11:51:01.000000000 +0100
@@ -731,7 +731,7 @@ static u8 scc_bmdma_status (struct ata_p
 	void __iomem *mmio = ap->ioaddr.bmdma_addr;
 	u8 host_stat = in_be32(mmio + SCC_DMA_STATUS);
 	u32 int_status = in_be32(mmio + SCC_DMA_INTST);
-	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
+	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
 	static int retry = 0;
 
 	/* return if IOS_SS is cleared */
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
