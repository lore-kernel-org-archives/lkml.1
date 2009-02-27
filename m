Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZB0Ioj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZB0Ioj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZB0Ioa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:44:30 -0500
Received: from sh.osrg.net ([192.16.179.4]:40989 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZB0Io3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:44:29 -0500
Date: Fri, 27 Feb 2009 17:35:43 +0900
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com, tj@kernel.org
Subject: [PATCH] libata: fix dma_unmap_sg misuse
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090227173520W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 27 Feb 2009 17:35:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repost of:

http://marc.info/?l=linux-ide&m=123484533504307&w=2

I sent this 10 days ago but seems that I can't find this in linux-next
yet. I guess that all the IOMMUs can handle this misuse for now so
it's not urgent.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] libata: fix dma_unmap_sg misuse

libata passes the returned value of dma_map_sg() to
dma_unmap_sg(),which is the misuse of dma_unmap_sg().

DMA-mapping.txt says:

To unmap a scatterlist, just call:

	pci_unmap_sg(pdev, sglist, nents, direction);

Again, make sure DMA activity has already finished.

PLEASE NOTE:  The 'nents' argument to the pci_unmap_sg call must be
              the _same_ one you passed into the pci_map_sg call,
	      it should _NOT_ be the 'count' value _returned_ from the
              pci_map_sg call.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |    4 ++--
 include/linux/libata.h    |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8167381..17a274a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4612,7 +4612,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
 
 	if (qc->n_elem)
-		dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
+		dma_unmap_sg(ap->dev, sg, qc->orig_n_elem, dir);
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
 	qc->sg = NULL;
@@ -4727,7 +4727,7 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 		return -1;
 
 	DPRINTK("%d sg elements mapped\n", n_elem);
-
+	qc->orig_n_elem = qc->n_elem;
 	qc->n_elem = n_elem;
 	qc->flags |= ATA_QCFLAG_DMAMAP;
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c953e17..337d1bd 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -530,6 +530,7 @@ struct ata_queued_cmd {
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
 	unsigned int		n_elem;
+	unsigned int		orig_n_elem;
 
 	int			dma_dir;
 
-- 
1.6.0.6

