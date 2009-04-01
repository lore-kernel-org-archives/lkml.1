Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZDANse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZDANse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765028AbZDANo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:44733 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765441AbZDANoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/17] bio: implement bio_{map|copy}_kern_sgl()
Date: Wed,  1 Apr 2009 22:44:27 +0900
Message-Id: <1238593472-30360-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add multi segment support to kernel bio mapping

Implement bio_{map|copy}_kern_sgl() and implement
bio_{map|copy}_kern() in terms of them.  As all map/copy helpers
support sgl, it's quite simple.  The sgl versions will be used to
extend blk_rq_map_kern*() interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c            |  254 +++++++++++++++++++++++++++++++-------------------
 include/linux/bio.h |    5 +
 2 files changed, 162 insertions(+), 97 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 04bc5c2..9c921f9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -26,7 +26,6 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/blktrace_api.h>
-#include <linux/scatterlist.h>
 #include <linux/pfn.h>
 #include <trace/block.h>
 
@@ -899,13 +898,55 @@ static int bio_memcpy_sgl_uiov(struct scatterlist *sgl, int nents,
 		}
 		WARN_ON_ONCE(slen);		/* iov too short */
 	}
-	WARN_ON_ONCE(iov_iter_count(&ii));	/* bio too short */
+	WARN_ON_ONCE(iov_iter_count(&ii));	/* sgl too short */
 done:
 	sg_miter_stop(&si);
 	return ret;
 }
 
 /**
+ *	bio_memcpy_sgl_sgl - copy data betweel two sgls
+ *	@dsgl: destination sgl
+ *	@dnents: number of entries in @dsgl
+ *	@ssgl: source sgl
+ *	@snents: number of entries in @ssgl
+ *	@d_km_type; km_type to use for mapping @dsgl
+ *	@s_km_type; km_type to use for mapping @ssgl
+ *
+ *	Copy data from @ssgl to @dsgl.  The areas should be of the
+ *	same size.
+ */
+static void bio_memcpy_sgl_sgl(struct scatterlist *dsgl, int dnents,
+			       struct scatterlist *ssgl, int snents,
+			       enum km_type d_km_type, enum km_type s_km_type)
+{
+	struct sg_mapping_iter si, di;
+
+	sg_miter_start_atomic(&di, dsgl, dnents, d_km_type);
+	sg_miter_start_atomic(&si, ssgl, snents, s_km_type);
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
+		WARN_ON_ONCE(dlen);		/* ssgl too short */
+	}
+	WARN_ON_ONCE(sg_miter_next(&si));	/* dsgl too short */
+
+	sg_miter_stop(&di);
+	sg_miter_stop(&si);
+}
+
+/**
  *	bio_init_from_sgl - initialize bio from sgl
  *	@bio: bio to initialize
  *	@q: request_queue new bio belongs to
@@ -949,48 +990,6 @@ static void bio_init_from_sgl(struct bio *bio, struct request_queue *q,
 }
 
 /**
- *	bio_memcpy_sgl_sgl - copy data betweel two sgls
- *	@dsgl: destination sgl
- *	@dnents: number of entries in @dsgl
- *	@ssgl: source sgl
- *	@snents: number of entries in @ssgl
- *
- *	Copy data from @ssgl to @dsgl.  The areas should be of the
- *	same size.
- */
-static void bio_memcpy_sgl_sgl(struct scatterlist *dsgl, int dnents,
-			       struct scatterlist *ssgl, int snents)
-{
-	struct sg_mapping_iter si, di;
-
-	/*
-	 * si will be nested inside di, use atomic mapping for it to
-	 * avoid (mostly theoretical) possibility of deadlock.
-	 */
-	sg_miter_start(&di, dsgl, dnents, 0);
-	sg_miter_start(&si, ssgl, snents, SG_MITER_ATOMIC);
-
-	while (sg_miter_next(&di)) {
-		void *daddr = di.addr;
-		size_t dlen = di.length;
-
-		while (dlen && sg_miter_next(&si)) {
-			size_t copy = min(dlen, si.length);
-
-			memcpy(daddr, si.addr, copy);
-
-			daddr += copy;
-			dlen -= copy;
-			si.consumed = copy;
-		}
-		WARN_ON_ONCE(dlen);	/* ssgl too short */
-		sg_miter_stop(&si);	/* advancing di might sleep, stop si */
-	}
-	WARN_ON_ONCE(sg_miter_next(&si)); /* dsgl too short */
-	sg_miter_stop(&di);
-}
-
-/**
  *	bio_create_from_sgl - create bio from sgl
  *	@q: request_queue new bio belongs to
  *	@sgl: sgl describing the data area
@@ -1286,50 +1285,54 @@ static void bio_map_kern_endio(struct bio *bio, int err)
 }
 
 /**
- *	bio_map_kern	-	map kernel address into bio
+ *	bio_map_kern_sg - map kernel data into bio
  *	@q: the struct request_queue for the bio
- *	@data: pointer to buffer to map
- *	@len: length in bytes
+ *	@sgl: the sglist
+ *	@nents: number of elements in the sgl
+ *	@rw: READ or WRITE
  *	@gfp: allocation flags for bio allocation
  *
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
-			 gfp_t gfp)
+struct bio *bio_map_kern_sg(struct request_queue *q, struct scatterlist *sgl,
+			    int nents, int rw, gfp_t gfp)
 {
-	unsigned long kaddr = (unsigned long)data;
-	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = kaddr >> PAGE_SHIFT;
-	const int nr_pages = end - start;
-	int offset, i;
+	size_t tot_len = 0;
+	int nr_pages = 0;
+	struct scatterlist *sg;
 	struct bio *bio;
+	int i;
 
-	bio = bio_kmalloc(gfp, nr_pages);
-	if (!bio)
-		return ERR_PTR(-ENOMEM);
-
-	offset = offset_in_page(kaddr);
-	for (i = 0; i < nr_pages; i++) {
-		unsigned int bytes = PAGE_SIZE - offset;
-
-		if (len <= 0)
-			break;
-
-		if (bytes > len)
-			bytes = len;
+	for_each_sg(sgl, sg, nents, i) {
+		void *page_addr = page_address(sg_page(sg));
+		unsigned int len = sg->length;
 
-		if (bio_add_pc_page(q, bio, virt_to_page(data), bytes,
-				    offset) < bytes)
-			break;
+		nr_pages += PFN_UP(sg->offset + len);
+		tot_len += len;
 
-		data += bytes;
-		len -= bytes;
-		offset = 0;
+		/*
+		 * Each segment must be aligned on DMA boundary and
+		 * not on stack.  The last one may have unaligned
+		 * length as long as the total length is aligned to
+		 * DMA padding alignment.
+		 */
+		if (i == nents - 1)
+			len = 0;
+		if (((sg->offset | len) & queue_dma_alignment(q)) ||
+		    (page_addr && object_is_on_stack(page_addr + sg->offset)))
+			return ERR_PTR(-EINVAL);
 	}
+	/* and total length on DMA padding alignment */
+	if (!nr_pages || tot_len & q->dma_pad_mask)
+		return ERR_PTR(-EINVAL);
+
+	bio = bio_create_from_sgl(q, sgl, nents, nr_pages, rw, gfp);
+	if (IS_ERR(bio))
+		return bio;
 
 	/* doesn't support partial mappings */
-	if (unlikely(bio->bi_size != len)) {
+	if (bio->bi_size != tot_len) {
 		bio_put(bio);
 		return ERR_PTR(-EINVAL);
 	}
@@ -1338,54 +1341,111 @@ struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 	return bio;
 }
 
+/**
+ *	bio_map_kern	-	map kernel address into bio
+ *	@q: the struct request_queue for the bio
+ *	@data: pointer to buffer to map
+ *	@len: length in bytes
+ *	@gfp: allocation flags for bio allocation
+ *
+ *	Map the kernel address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+			 gfp_t gfp)
+{
+	struct scatterlist sg;
+
+	sg_init_one(&sg, data, len);
+
+	return bio_map_kern_sg(q, &sg, 1, READ, gfp);
+}
+
 static void bio_copy_kern_endio(struct bio *bio, int err)
 {
 	struct bio_copy_info *bci = bio->bi_private;
 
-	if (bio_data_dir(bio) == READ)
-		bio_memcpy_sgl_uiov(bci->copy_sgl, bci->copy_nents,
-				    bci->src_iov, bci->src_count, false);
+	if (bio_data_dir(bio) == READ) {
+		unsigned long flags;
 
+		local_irq_save(flags);	/* to protect KMs */
+		bio_memcpy_sgl_sgl(bci->src_sgl, bci->src_nents,
+				   bci->copy_sgl, bci->copy_nents,
+				   KM_BIO_DST_IRQ, KM_BIO_SRC_IRQ);
+		local_irq_restore(flags);
+	}
 	bci_destroy(bci);
 	bio_put(bio);
 }
 
 /**
- *	bio_copy_kern	-	copy kernel address into bio
+ *	bio_copy_kern_sg - copy kernel data into bio
  *	@q: the struct request_queue for the bio
- *	@data: pointer to buffer to copy
- *	@len: length in bytes
- *	@gfp: allocation flags for bio and page allocation
+ *	@sgl: the sglist
+ *	@nents: number of elements in the sgl
  *	@rw: READ or WRITE
+ *	@gfp: allocation flags for bio and page allocation
  *
  *	copy the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
-			  gfp_t gfp, int rw)
+struct bio *bio_copy_kern_sg(struct request_queue *q, struct scatterlist *sgl,
+			     int nents, int rw, gfp_t gfp)
 {
+	struct bio_copy_info *bci;
 	struct bio *bio;
-	struct bio_vec *bvec;
-	int i;
-
-	bio = bio_copy_user(q, NULL, (unsigned long)data, len, READ, gfp);
-	if (IS_ERR(bio))
-		return bio;
+	int ret;
 
-	if (rw == WRITE) {
-		void *p = data;
+	bci = bci_create(NULL, 0, sgl, nents, gfp, q->bounce_gfp | gfp, NULL);
+	if (!bci)
+		return ERR_PTR(-ENOMEM);
 
-		bio_for_each_segment(bvec, bio, i) {
-			char *addr = page_address(bvec->bv_page);
+	if (rw == WRITE)
+		bio_memcpy_sgl_sgl(bci->copy_sgl, bci->copy_nents, sgl, nents,
+				   KM_USER1, KM_USER0);
 
-			memcpy(addr, p, bvec->bv_len);
-			p += bvec->bv_len;
-		}
+	bio = bio_create_from_sgl(q, bci->copy_sgl, bci->copy_nents,
+				  bci->copy_nents, rw, gfp);
+	if (IS_ERR(bio)) {
+		ret = PTR_ERR(bio);
+		goto err_bci;
 	}
 
-	bio->bi_end_io = bio_copy_kern_endio;
+	/* doesn't support partial mappings */
+	ret= -EINVAL;
+	if (bio->bi_size != bci->len)
+		goto err_bio;
 
+	bio->bi_end_io = bio_copy_kern_endio;
+	bio->bi_private = bci;
 	return bio;
+
+err_bio:
+	bio_put(bio);
+err_bci:
+	bci_destroy(bci);
+	return ERR_PTR(ret);
+}
+
+/**
+ *	bio_copy_kern	-	copy kernel address into bio
+ *	@q: the struct request_queue for the bio
+ *	@data: pointer to buffer to copy
+ *	@len: length in bytes
+ *	@gfp: allocation flags for bio and page allocation
+ *	@rw: READ or WRITE
+ *
+ *	copy the kernel address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
+			  gfp_t gfp, int rw)
+{
+	struct scatterlist sg;
+
+	sg_init_one(&sg, data, len);
+
+	return bio_copy_kern_sg(q, &sg, 1, rw, gfp);
 }
 
 /*
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1c21e59..1c28c5c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -24,6 +24,7 @@
 #include <linux/mempool.h>
 #include <linux/ioprio.h>
 #include <linux/uio.h>
+#include <linux/scatterlist.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -400,8 +401,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct rq_map_data *md,
 int bio_uncopy_user(struct bio *bio);
 struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 			 gfp_t gfp);
+struct bio *bio_map_kern_sg(struct request_queue *q, struct scatterlist *sgl,
+			    int nents, int rw, gfp_t gfp);
 struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 			  gfp_t gfp, int rw);
+struct bio *bio_copy_kern_sg(struct request_queue *q, struct scatterlist *sgl,
+			     int nents, int rw, gfp_t gfp_mask);
 void bio_set_pages_dirty(struct bio *bio);
 void bio_check_pages_dirty(struct bio *bio);
 void zero_fill_bio(struct bio *bio);
-- 
1.6.0.2

