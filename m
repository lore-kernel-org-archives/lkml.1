Return-Path: <linux-kernel-owner+w=401wt.eu-S1763703AbXEPImu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763703AbXEPImu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762572AbXEPIeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:34:31 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6630 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761417AbXEPIeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:34:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 17/19] SCSI: support for allocating large scatterlists
Date: Wed, 16 May 2007 10:32:31 +0200
Message-Id: <11793043541626-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11793043533744-git-send-email-jens.axboe@oracle.com>
References: <11793043533744-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is what enables large commands. If we need to allocate an
sgtable that doesn't fit in a single page, allocate several
SCSI_MAX_SG_SEGMENTS sized tables and chain them together.

SCSI defaults to large chained sg tables, if the arch supports it.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_lib.c  |  210 +++++++++++++++++++++++++++++++++++----------
 include/scsi/scsi.h      |    7 --
 include/scsi/scsi_cmnd.h |    1 +
 3 files changed, 164 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 26236b1..9aa1100 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -29,39 +29,26 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
+#include <linux/scatterlist.h>
 
 #define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
 #define SG_MEMPOOL_SIZE		2
 
 struct scsi_host_sg_pool {
 	size_t		size;
-	char		*name; 
+	char		*name;
 	struct kmem_cache	*slab;
 	mempool_t	*pool;
 };
 
-#if (SCSI_MAX_PHYS_SEGMENTS < 32)
-#error SCSI_MAX_PHYS_SEGMENTS is too small
-#endif
-
-#define SP(x) { x, "sgpool-" #x } 
+#define SP(x) { x, "sgpool-" #x }
 static struct scsi_host_sg_pool scsi_sg_pools[] = {
 	SP(8),
 	SP(16),
 	SP(32),
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
 	SP(64),
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
 	SP(128),
-#if (SCSI_MAX_PHYS_SEGMENTS > 128)
-	SP(256),
-#if (SCSI_MAX_PHYS_SEGMENTS > 256)
-#error SCSI_MAX_PHYS_SEGMENTS is too large
-#endif
-#endif
-#endif
-#endif
-}; 	
+};
 #undef SP
 
 static void scsi_run_queue(struct request_queue *q);
@@ -702,45 +689,126 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 	return NULL;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
-{
-	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl;
+/*
+ * The maximum number of SG segments that we will put inside a scatterlist
+ * (unless chaining is used). Should ideally fit inside a single page, to
+ * avoid a higher order allocation.
+ */
+#define SCSI_MAX_SG_SEGMENTS	128
 
-	BUG_ON(!cmd->use_sg);
+/*
+ * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
+ * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
+ */
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
 
-	switch (cmd->use_sg) {
+static inline unsigned int scsi_sgtable_index(unsigned short nents)
+{
+	unsigned int index;
+
+	switch (nents) {
 	case 1 ... 8:
-		cmd->sglist_len = 0;
+		index = 0;
 		break;
 	case 9 ... 16:
-		cmd->sglist_len = 1;
+		index = 1;
 		break;
 	case 17 ... 32:
-		cmd->sglist_len = 2;
+		index = 2;
 		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
 	case 33 ... 64:
-		cmd->sglist_len = 3;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
-	case 65 ... 128:
-		cmd->sglist_len = 4;
+		index = 3;
 		break;
-#if (SCSI_MAX_PHYS_SEGMENTS  > 128)
-	case 129 ... 256:
-		cmd->sglist_len = 5;
+	case 65 ... SCSI_MAX_SG_SEGMENTS:
+		index = 4;
 		break;
-#endif
-#endif
-#endif
 	default:
-		return NULL;
+		printk(KERN_ERR "scsi: bad segment count=%d\n", nents);
+		BUG();
 	}
 
-	sgp = scsi_sg_pools + cmd->sglist_len;
-	sgl = mempool_alloc(sgp->pool, gfp_mask);
-	return sgl;
+	return index;
+}
+
+struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+{
+	struct scsi_host_sg_pool *sgp;
+	struct scatterlist *sgl, *prev, *ret;
+	unsigned int index;
+	int this, left;
+
+	BUG_ON(!cmd->use_sg);
+
+	left = cmd->use_sg;
+	ret = prev = NULL;
+	do {
+		this = left;
+		if (this > SCSI_MAX_SG_SEGMENTS) {
+			this = SCSI_MAX_SG_SEGMENTS - 1;
+			index = SG_MEMPOOL_NR - 1;
+		} else
+			index = scsi_sgtable_index(this);
+
+		left -= this;
+
+		sgp = scsi_sg_pools + index;
+
+		sgl = mempool_alloc(sgp->pool, gfp_mask);
+		if (unlikely(!sgl))
+			goto enomem;
+
+		memset(sgl, 0, sizeof(*sgl) * sgp->size);
+
+		/*
+		 * first loop through, set initial index and return value
+		 */
+		if (!ret) {
+			cmd->sglist_len = index;
+			ret = sgl;
+		}
+
+		/*
+		 * chain previous sglist, if any. we know the previous
+		 * sglist must be the biggest one, or we would not have
+		 * ended up doing another loop.
+		 */
+		if (prev)
+			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
+
+		/*
+		 * don't allow subsequent mempool allocs to sleep, it would
+		 * violate the mempool principle.
+		 */
+		gfp_mask &= ~__GFP_WAIT;
+		gfp_mask |= __GFP_HIGH;
+		prev = sgl;
+	} while (left);
+
+	/*
+	 * ->use_sg may get modified after dma mapping has potentially
+	 * shrunk the number of segments, so keep a copy of it for free.
+	 */
+	cmd->__use_sg = cmd->use_sg;
+	return ret;
+enomem:
+	if (ret) {
+		/*
+		 * Free entries chained off ret. Since we were trying to
+		 * allocate another sglist, we know that all entries are of
+		 * the max size.
+		 */
+		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
+		prev = ret;
+		ret = &ret[SCSI_MAX_SG_SEGMENTS - 1];
+
+		while ((sgl = sg_chain_ptr(ret)) != NULL) {
+			ret = &sgl[SCSI_MAX_SG_SEGMENTS - 1];
+			mempool_free(sgl, sgp->pool);
+		}
+
+		mempool_free(prev, sgp->pool);
+	}
+	return NULL;
 }
 
 EXPORT_SYMBOL(scsi_alloc_sgtable);
@@ -752,6 +820,42 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 
 	BUG_ON(cmd->sglist_len >= SG_MEMPOOL_NR);
 
+	/*
+	 * if this is the biggest size sglist, check if we have
+	 * chained parts we need to free
+	 */
+	if (cmd->__use_sg > SCSI_MAX_SG_SEGMENTS) {
+		unsigned short this, left;
+		struct scatterlist *next;
+		unsigned int index;
+
+		left = cmd->__use_sg - (SCSI_MAX_SG_SEGMENTS - 1);
+		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
+		do {
+			sgl = next;
+			this = left;
+			if (this > SCSI_MAX_SG_SEGMENTS) {
+				this = SCSI_MAX_SG_SEGMENTS - 1;
+				index = SG_MEMPOOL_NR - 1;
+			} else
+				index = scsi_sgtable_index(this);
+
+			left -= this;
+
+			sgp = scsi_sg_pools + index;
+
+			if (left)
+				next = sg_chain_ptr(&sgl[sgp->size - 1]);
+
+			mempool_free(sgl, sgp->pool);
+		} while (left);
+
+		/*
+		 * Restore original, will be freed below
+		 */
+		sgl = cmd->request_buffer;
+	}
+
 	sgp = scsi_sg_pools + cmd->sglist_len;
 	mempool_free(sgl, sgp->pool);
 }
@@ -993,7 +1097,6 @@ EXPORT_SYMBOL(scsi_io_completion);
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
-	struct scatterlist *sgpnt;
 	int		   count;
 
 	/*
@@ -1006,14 +1109,13 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!sgpnt)) {
+	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
+	if (unlikely(!cmd->request_buffer)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
-	cmd->request_buffer = (char *) sgpnt;
 	if (blk_pc_request(req))
 		cmd->request_bufflen = req->data_len;
 	else
@@ -1577,8 +1679,22 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	if (!q)
 		return NULL;
 
+	/*
+	 * this limit is imposed by hardware restrictions
+	 */
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
+
+	/*
+	 * In the future, sg chaining support will be mandatory and this
+	 * ifdef can then go away. Right now we don't have all archs
+	 * converted, so better keep it safe.
+	 */
+#ifdef ARCH_HAS_SG_CHAIN
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
+#else
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
+#endif
+
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 9f8f80a..702fcfe 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -11,13 +11,6 @@
 #include <linux/types.h>
 
 /*
- *	The maximum sg list length SCSI can cope with
- *	(currently must be a power of 2 between 32 and 256)
- */
-#define SCSI_MAX_PHYS_SEGMENTS	MAX_PHYS_SEGMENTS
-
-
-/*
  *	SCSI command lengths
  */
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index d7db992..fc649af 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -72,6 +72,7 @@ struct scsi_cmnd {
 	/* These elements define the operation we ultimately want to perform */
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
 	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
+	unsigned short __use_sg;
 
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
-- 
1.5.2.rc1

