Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbXJaItb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbXJaItb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbXJaItW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:49:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58615 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbXJaItV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:49:21 -0400
Date: Wed, 31 Oct 2007 04:49:20 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] "killing" sg_last(), and discussion
Message-ID: <20071031084920.GA25202@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I looked into killing sg_last(), but really, this is the best its gonna
get (moving sg_last to libata-core.c).

You could maybe kill one use with caching, but in the other sg_last()
callsites there isn't another s/g loop we can stick a "last_sg = sg;"
into.

libata is stuck because we undertake the highly unusual operation of
fiddling with the final S/G element, to enforce 32-bit alignment.

Of course we could eliminate all that nasty fiddling/padding
completely, including sg_last(), if other areas of the kernel would
guarantee ahead of time that buffer lengths are always a multiple
of 4........

	Jeff





[the obvious patch follows, moving sg_last()...]

 drivers/ata/libata-core.c   |   24 ++++++++++++++++++++++++
 drivers/ata/sata_nv.c       |    1 -
 drivers/ata/sata_promise.c  |    1 -
 drivers/ata/sata_qstor.c    |    1 -
 include/linux/scatterlist.h |   34 ----------------------------------
 5 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 63035d7..4f0acc5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4480,6 +4480,30 @@ static unsigned int ata_dev_init_params(struct ata_device *dev,
 }
 
 /**
+ * sg_last - return the last scatterlist entry in a list
+ * @sgl:	First entry in the scatterlist
+ * @nents:	Number of entries in the scatterlist
+ *
+ * Description:
+ *   Should only be used casually, it (currently) scan the entire list
+ *   to get the last entry.
+ *
+ *   Note that the @sgl@ pointer passed in need not be the first one,
+ *   the important bit is that @nents@ denotes the number of entries that
+ *   exist from @sgl@.
+ *
+ **/
+static inline struct scatterlist *sg_last(struct scatterlist *sgl,
+					  unsigned int nents)
+{
+	struct scatterlist *sg, *ret = NULL;
+	unsigned int i;
+
+	for_each_sg(sgl, sg, nents, i)
+		ret = sg;
+}
+
+/**
  *	ata_sg_clean - Unmap DMA memory associated with command
  *	@qc: Command containing DMA memory to be released
  *
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 35b2df2..6546913 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1985,7 +1985,6 @@ static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
 	struct nv_swncq_port_priv *pp = ap->private_data;
 	struct ata_prd *prd;
 
-	WARN_ON(qc->__sg == NULL);
 	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
 
 	prd = pp->prd + ATA_MAX_PRD * qc->tag;
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 825e717..1fba9d4 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -547,7 +547,6 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
 		return;
 
-	WARN_ON(qc->__sg == NULL);
 	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
 
 	idx = 0;
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 6d43ba7..664e3f7 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -276,7 +276,6 @@ static unsigned int qs_fill_sg(struct ata_queued_cmd *qc)
 	unsigned int nelem;
 	u8 *prd = pp->pkt + QS_CPB_BYTES;
 
-	WARN_ON(qc->__sg == NULL);
 	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
 
 	nelem = 0;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 32326c2..ab94464 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -130,40 +130,6 @@ static inline struct scatterlist *sg_next(struct scatterlist *sg)
 	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
 
 /**
- * sg_last - return the last scatterlist entry in a list
- * @sgl:	First entry in the scatterlist
- * @nents:	Number of entries in the scatterlist
- *
- * Description:
- *   Should only be used casually, it (currently) scan the entire list
- *   to get the last entry.
- *
- *   Note that the @sgl@ pointer passed in need not be the first one,
- *   the important bit is that @nents@ denotes the number of entries that
- *   exist from @sgl@.
- *
- **/
-static inline struct scatterlist *sg_last(struct scatterlist *sgl,
-					  unsigned int nents)
-{
-#ifndef ARCH_HAS_SG_CHAIN
-	struct scatterlist *ret = &sgl[nents - 1];
-#else
-	struct scatterlist *sg, *ret = NULL;
-	unsigned int i;
-
-	for_each_sg(sgl, sg, nents, i)
-		ret = sg;
-
-#endif
-#ifdef CONFIG_DEBUG_SG
-	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
-	BUG_ON(!sg_is_last(ret));
-#endif
-	return ret;
-}
-
-/**
  * sg_chain - Chain two sglists together
  * @prv:	First scatterlist
  * @prv_nents:	Number of entries in prv
