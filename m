Return-Path: <linux-kernel-owner+w=401wt.eu-S1766014AbZDANtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766014AbZDANtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765501AbZDANo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:44738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764752AbZDANoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/17] bio: add sgl source support to bci and implement bio_memcpy_sgl_sgl()
Date: Wed,  1 Apr 2009 22:44:26 +0900
Message-Id: <1238593472-30360-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add new features to internal functions to prepare for future changes

Expand bci such that it supports sgl as source and implement
bio_memcpy_sgl_sgl() which can copy data between two sgls.  These will
be used to implement blk_rq_copy/map_kern_iov().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 1ca8b16..04bc5c2 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -758,8 +758,10 @@ err:
 struct bio_copy_info {
 	struct scatterlist	*copy_sgl;	/* one sg per page */
 	struct iovec		*src_iov;	/* source iovec from userland */
+	struct scatterlist	*src_sgl;	/* source sgl */
 	int			copy_nents;	/* #entries in copy_sgl */
 	int			src_count;	/* #entries in src_iov */
+	int			src_nents;	/* #entries in src_sgl */
 	size_t			len;		/* total length in bytes */
 	int			is_our_pages;	/* do we own copied pages? */
 };
@@ -776,6 +778,7 @@ static void bci_destroy(struct bio_copy_info *bci)
 		bio_sgl_free_pages(bci->copy_sgl, bci->copy_nents);
 	kfree(bci->copy_sgl);
 	kfree(bci->src_iov);
+	kfree(bci->src_sgl);
 	kfree(bci);
 }
 
@@ -783,6 +786,8 @@ static void bci_destroy(struct bio_copy_info *bci)
  *	bci_create - create a bci
  *	@src_iov: source iovec
  *	@src_count: number of entries in @src_iov
+ *	@src_sgl: source sgl
+ *	@src_nents: number of entries in @src_sgl
  *	@gfp: gfp for data structure allocations
  *	@page_gfp: gfp for page allocations
  *	@md: optional preallocated page pool
@@ -795,28 +800,47 @@ static void bci_destroy(struct bio_copy_info *bci)
  *	Pointer to the new bci on success, NULL on failure.
  */
 static struct bio_copy_info *bci_create(struct iovec *src_iov, int src_count,
-					gfp_t gfp, gfp_t page_gfp,
-					struct rq_map_data *md)
+				struct scatterlist *src_sgl, int src_nents,
+				gfp_t gfp, gfp_t page_gfp,
+				struct rq_map_data *md)
 {
 	struct bio_copy_info *bci;
+	struct scatterlist *sg;
+	int i;
+
+	BUG_ON(!src_iov == !src_sgl);
 
 	bci = kzalloc(sizeof(*bci), gfp);
 	if (!bci)
 		return NULL;
 
 	bci->src_count = src_count;
-	bci->len = iov_length(src_iov, src_count);
+	bci->src_nents = src_nents;
 	bci->is_our_pages = md == NULL;
 
+	if (src_iov)
+		bci->len = iov_length(src_iov, src_count);
+	else
+		for_each_sg(src_sgl, sg, src_nents, i)
+			bci->len += sg->length;
+
 	bci->copy_sgl = bio_alloc_sgl_with_pages(bci->len, gfp, page_gfp, md,
 						 &bci->copy_nents);
 	if (!bci->copy_sgl)
 		goto err;
 
-	bci->src_iov = kmalloc(sizeof(src_iov[0]) * src_count, gfp);
-	if (!bci->src_iov)
-		goto err;
-	memcpy(bci->src_iov, src_iov, sizeof(src_iov[0]) * src_count);
+	if (src_iov) {
+		bci->src_iov = kmalloc(sizeof(src_iov[0]) * src_count, gfp);
+		if (!bci->src_iov)
+			goto err;
+		memcpy(bci->src_iov, src_iov, sizeof(src_iov[0]) * src_count);
+	} else {
+		bci->src_sgl = kmalloc(sizeof(src_sgl[0]) * src_nents, gfp);
+		if (!bci->src_sgl)
+			goto err;
+		for_each_sg(src_sgl, sg, src_nents, i)
+			bci->src_sgl[i] = *sg;
+	}
 
 	return bci;
 
@@ -925,6 +949,48 @@ static void bio_init_from_sgl(struct bio *bio, struct request_queue *q,
 }
 
 /**
+ *	bio_memcpy_sgl_sgl - copy data betweel two sgls
+ *	@dsgl: destination sgl
+ *	@dnents: number of entries in @dsgl
+ *	@ssgl: source sgl
+ *	@snents: number of entries in @ssgl
+ *
+ *	Copy data from @ssgl to @dsgl.  The areas should be of the
+ *	same size.
+ */
+static void bio_memcpy_sgl_sgl(struct scatterlist *dsgl, int dnents,
+			       struct scatterlist *ssgl, int snents)
+{
+	struct sg_mapping_iter si, di;
+
+	/*
+	 * si will be nested inside di, use atomic mapping for it to
+	 * avoid (mostly theoretical) possibility of deadlock.
+	 */
+	sg_miter_start(&di, dsgl, dnents, 0);
+	sg_miter_start(&si, ssgl, snents, SG_MITER_ATOMIC);
+
+	while (sg_miter_next(&di)) {
+		void *daddr = di.addr;
+		size_t dlen = di.length;
+
+		while (dlen && sg_miter_next(&si)) {
+			size_t copy = min(dlen, si.length);
+
+			memcpy(daddr, si.addr, copy);
+
+			daddr += copy;
+			dlen -= copy;
+			si.consumed = copy;
+		}
+		WARN_ON_ONCE(dlen);	/* ssgl too short */
+		sg_miter_stop(&si);	/* advancing di might sleep, stop si */
+	}
+	WARN_ON_ONCE(sg_miter_next(&si)); /* dsgl too short */
+	sg_miter_stop(&di);
+}
+
+/**
  *	bio_create_from_sgl - create bio from sgl
  *	@q: request_queue new bio belongs to
  *	@sgl: sgl describing the data area
@@ -993,7 +1059,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct rq_map_data *md,
 	struct bio *bio;
 	int ret;
 
-	bci = bci_create(iov, count, gfp, q->bounce_gfp | gfp, md);
+	bci = bci_create(iov, count, NULL, 0, gfp, q->bounce_gfp | gfp, md);
 	if (!bci)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.6.0.2

