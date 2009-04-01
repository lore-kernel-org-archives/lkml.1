Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbZDANrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbZDANrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765383AbZDANoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:44726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765100AbZDANow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:52 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>, Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [PATCH 02/17] scatterlist: improve atomic mapping handling in mapping iterator
Date: Wed,  1 Apr 2009 22:44:17 +0900
Message-Id: <1238593472-30360-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: better atomic mapping handling

sg-miter supported atomic mapping using single flag - SG_MITER_ATOMIC.
It implicly used KM_BIO_SRC_IRQ and required irq to be disabled for
each iteration to protect the kernel mapping.  This was too limiting
and didn't allow multiple iterators to be used concurrently (e.g. for
sgl -> sgl copying).

This patch adds a new interface sg_miter_start_atomic() which takes
km_type argument and drops @flags from sg_miter_start() so that
km_type can be specified by the caller for atomic iterators.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
---
 drivers/mmc/host/sdhci.c    |    4 +-
 include/linux/scatterlist.h |   11 +++++++--
 lib/scatterlist.c           |   49 ++++++++++++++++++++++++++++++++----------
 3 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index accb592..559aca7 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -704,8 +704,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	}
 
 	if (!(host->flags & SDHCI_REQ_USE_DMA)) {
-		sg_miter_start(&host->sg_miter,
-			data->sg, data->sg_len, SG_MITER_ATOMIC);
+		sg_miter_start_atomic(&host->sg_miter,
+				      data->sg, data->sg_len, KM_BIO_SRC_IRQ);
 		host->blocks = data->blocks;
 	}
 
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index e599698..2249caa 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <asm/io.h>
+#include <asm/kmap_types.h>
 
 struct sg_table {
 	struct scatterlist *sgl;	/* the list */
@@ -254,11 +255,15 @@ struct sg_mapping_iter {
 	struct scatterlist	*__sg;		/* current entry */
 	unsigned int		__nents;	/* nr of remaining entries */
 	unsigned int		__offset;	/* offset within sg */
-	unsigned int		__flags;
+	unsigned int		__flags;	/* internal flags */
+	enum km_type		__km_type;	/* atomic kmap type to use */
 };
 
-void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
-		    unsigned int nents, unsigned int flags);
+void sg_miter_start(struct sg_mapping_iter *miter,
+		    struct scatterlist *sgl, unsigned int nents);
+void sg_miter_start_atomic(struct sg_mapping_iter *miter,
+			   struct scatterlist *sgl, unsigned int nents,
+			   enum km_type km_type);
 bool sg_miter_next(struct sg_mapping_iter *miter);
 void sg_miter_stop(struct sg_mapping_iter *miter);
 
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a295e40..4158a7c 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -306,19 +306,41 @@ EXPORT_SYMBOL(sg_alloc_table);
  * Context:
  *   Don't care.
  */
-void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
-		    unsigned int nents, unsigned int flags)
+void sg_miter_start(struct sg_mapping_iter *miter,
+		    struct scatterlist *sgl, unsigned int nents)
 {
 	memset(miter, 0, sizeof(struct sg_mapping_iter));
 
 	miter->__sg = sgl;
 	miter->__nents = nents;
 	miter->__offset = 0;
-	miter->__flags = flags;
 }
 EXPORT_SYMBOL(sg_miter_start);
 
 /**
+ * sg_miter_start_atomic - start atomic mapping iteration over a sg list
+ * @miter: sg mapping iter to be started
+ * @sgl: sg list to iterate over
+ * @nents: number of sg entries
+ * @idx: kmap type to use for atomic mapping
+ *
+ * Description:
+ *   Starts atomic mapping iterator @miter.
+ *
+ * Context:
+ *   Don't care.
+ */
+void sg_miter_start_atomic(struct sg_mapping_iter *miter,
+			   struct scatterlist *sgl, unsigned int nents,
+			   enum km_type km_type)
+{
+	sg_miter_start(miter, sgl, nents);
+	miter->__flags |= SG_MITER_ATOMIC;
+	miter->__km_type = km_type;
+}
+EXPORT_SYMBOL(sg_miter_start_atomic);
+
+/**
  * sg_miter_next - proceed mapping iterator to the next mapping
  * @miter: sg mapping iter to proceed
  *
@@ -329,8 +351,11 @@ EXPORT_SYMBOL(sg_miter_start);
  *   current mapping.
  *
  * Context:
- *   IRQ disabled if SG_MITER_ATOMIC.  IRQ must stay disabled till
- *   @miter@ is stopped.  May sleep if !SG_MITER_ATOMIC.
+ *   Atomic for atomic miters.  Atomic state must be maintained till
+ *   @miter@ is stopped.  Note that the selected KM type limits which
+ *   atomic (preempt, softirq or hardirq) contexts are allowed.  The
+ *   rules are identical to those of kmap_atomic().  May sleep for
+ *   non-atomic miters.
  *
  * Returns:
  *   true if @miter contains the next mapping.  false if end of sg
@@ -365,7 +390,7 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 	miter->consumed = miter->length;
 
 	if (miter->__flags & SG_MITER_ATOMIC)
-		miter->addr = kmap_atomic(miter->page, KM_BIO_SRC_IRQ) + off;
+		miter->addr = kmap_atomic(miter->page, miter->__km_type) + off;
 	else
 		miter->addr = kmap(miter->page) + off;
 
@@ -384,7 +409,7 @@ EXPORT_SYMBOL(sg_miter_next);
  *   resources (kmap) need to be released during iteration.
  *
  * Context:
- *   IRQ disabled if the SG_MITER_ATOMIC is set.  Don't care otherwise.
+ *   Atomic if the SG_MITER_ATOMIC is set.  Don't care otherwise.
  */
 void sg_miter_stop(struct sg_mapping_iter *miter)
 {
@@ -394,10 +419,9 @@ void sg_miter_stop(struct sg_mapping_iter *miter)
 	if (miter->addr) {
 		miter->__offset += miter->consumed;
 
-		if (miter->__flags & SG_MITER_ATOMIC) {
-			WARN_ON(!irqs_disabled());
-			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
-		} else
+		if (miter->__flags & SG_MITER_ATOMIC)
+			kunmap_atomic(miter->addr, miter->__km_type);
+		else
 			kunmap(miter->page);
 
 		miter->page = NULL;
@@ -427,8 +451,9 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 	struct sg_mapping_iter miter;
 	unsigned long flags;
 
-	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC);
+	sg_miter_start_atomic(&miter, sgl, nents, KM_BIO_SRC_IRQ);
 
+	/* dunno the context we're being called from, plug IRQ */
 	local_irq_save(flags);
 
 	while (sg_miter_next(&miter) && offset < buflen) {
-- 
1.6.0.2

