Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZDANsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZDANsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764638AbZDANo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:44727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765430AbZDANox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:53 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/17] bio: reimplement bio_copy_user_iov()
Date: Wed,  1 Apr 2009 22:44:23 +0900
Message-Id: <1238593472-30360-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: more modular implementation

Break down bio_copy_user_iov() into the following steps.

1. bci and page allocation
2. copying data if WRITE
3. create bio accordingly

bci is now responsible for managing any copy related resources.  Given
source iov, bci_create() allocates bci and fills it with enough pages
to cover the source iov.  The allocated pages are described with a
sgl.

Note that new allocator always rounds up rq_map_data->offset to page
boundary to simplify implementation and guarantee enough DMA padding
area at the end.  As the only user, scsi sg, always passes in zero
offset, this doesn't cause any actual behavior difference.  Also,
nth_page() is used to walk to the next page rather than directly
adding to struct page *.

Copying back and forth is done using bio_memcpy_sgl_uiov() which is
implemented using sg mapping iterator and iov iterator.

The last step is done using bio_create_from_sgl().

This patch by itself adds one more level of indirection via sgl and
more code but components factored out here will be used for future
code refactoring.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c |  465 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 293 insertions(+), 172 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 1cd97e3..f13aef0 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -26,6 +26,7 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/blktrace_api.h>
+#include <linux/scatterlist.h>
 #include <linux/pfn.h>
 #include <trace/block.h>
 
@@ -653,102 +654,303 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
 }
 
-struct bio_copy_info {
-	struct bio_vec		*iovecs;
-	struct iovec		*src_iov;
-	int			src_count;
-	int			is_our_pages;
-};
+/**
+ *	bio_sgl_free_pages - free pages from sgl
+ *	@sgl: target sgl
+ *	@nents: nents for @sgl
+ *
+ *	Free all pages pointed to by @sgl.  Note that this function
+ *	assumes that each sg entry is pointing to single page.
+ */
+static void bio_sgl_free_pages(struct scatterlist *sgl, int nents)
+{
+	struct scatterlist *sg;
+	int i;
 
-static void bci_set(struct bio_copy_info *bci, struct bio *bio,
-		    struct iovec *iov, int count, int is_our_pages)
+	for_each_sg(sgl, sg, nents, i)
+		__free_page(sg_page(sg));
+}
+
+/**
+ *	bio_alloc_sgl_with_pages - allocate sgl and populate with pages
+ *	@len: target length
+ *	@gfp: gfp for data structure allocations
+ *	@page_gfp: gfp for page allocations
+ *	@md: optional preallocated page pool
+ *	@nentsp: out parameter for nents of the result sgl
+ *
+ *	Alloate sgl to cover @len bytes and populate it with pages.
+ *	The area the last sg points to is guaranteed to have enough
+ *	room to page align @len.  This is used by blk_rq_map_sg() to
+ *	honor q->dma_pad_mask.  Each entry in the resulting sgl always
+ *	points to upto a single page.
+ *
+ *	RETURNS:
+ *	Allocated sgl on success, NULL on failure.
+ */
+static struct scatterlist *bio_alloc_sgl_with_pages(size_t len,
+						    gfp_t gfp, gfp_t page_gfp,
+						    struct rq_map_data *md,
+						    int *nentsp)
 {
-	memcpy(bci->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
-	memcpy(bci->src_iov, iov, sizeof(struct iovec) * count);
-	bci->src_count = count;
-	bci->is_our_pages = is_our_pages;
-	bio->bi_private = bci;
+	int nr_pages = PFN_UP(len);
+	int nents = 0;
+	struct scatterlist *sgl;
+	unsigned int md_pages;
+	unsigned int md_pgidx;
+
+	sgl = kmalloc(sizeof(sgl[0]) * nr_pages, gfp);
+	if (!sgl)
+		return ERR_PTR(-ENOMEM);
+	sg_init_table(sgl, nr_pages);
+
+	if (md) {
+		/*
+		 * The area might need to be extended upto the next
+		 * PAGE_SIZE alignment for DMA padding.  Always start
+		 * page aligned.
+		 */
+		md_pgidx = PFN_UP(md->offset);
+		md_pages = 1 << md->page_order;
+	}
+	while (len) {
+		unsigned int bytes = min(PAGE_SIZE, len);
+		struct page *page = NULL;
+
+		if (md) {
+			if (md_pgidx < md->nr_entries * md_pages) {
+				page = md->pages[md_pgidx / md_pages];
+				page = nth_page(page, md_pgidx % md_pages);
+				md_pgidx++;
+			}
+		} else
+			page = alloc_page(page_gfp);
+
+		if (!page)
+			goto err;
+
+		sg_set_page(&sgl[nents++], page, bytes, 0);
+
+		len -= bytes;
+	}
+	BUG_ON(nents != nr_pages);
+
+	*nentsp = nents;
+	return sgl;
+
+err:
+	if (!md)
+		bio_sgl_free_pages(sgl, nents);
+	kfree(sgl);
+	return NULL;
 }
 
-static void bci_free(struct bio_copy_info *bci)
+/*
+ * bio_copy_info
+ *
+ * A bci carries information about copy-mapped bio so that data can be
+ * copied back to the original bio for READ and resources can be
+ * released after completion.
+ *
+ * bci_create() allocates all resources necessary for copying and
+ * bci_destroy() does the opposite.
+ */
+struct bio_copy_info {
+	struct scatterlist	*copy_sgl;	/* one sg per page */
+	struct iovec		*src_iov;	/* source iovec from userland */
+	int			copy_nents;	/* #entries in copy_sgl */
+	int			src_count;	/* #entries in src_iov */
+	size_t			len;		/* total length in bytes */
+	int			is_our_pages;	/* do we own copied pages? */
+};
+
+/**
+ *	bci_destroy - destroy a bci
+ *	@bci: bci to destroy
+ *
+ *	Release all resources @bci is holding and free it.
+ */
+static void bci_destroy(struct bio_copy_info *bci)
 {
-	kfree(bci->iovecs);
+	if (bci->is_our_pages && bci->copy_sgl)
+		bio_sgl_free_pages(bci->copy_sgl, bci->copy_nents);
+	kfree(bci->copy_sgl);
 	kfree(bci->src_iov);
 	kfree(bci);
 }
 
-static struct bio_copy_info *bci_alloc(int nr_segs, int count, gfp_t gfp)
+/**
+ *	bci_create - create a bci
+ *	@src_iov: source iovec
+ *	@src_count: number of entries in @src_iov
+ *	@gfp: gfp for data structure allocations
+ *	@page_gfp: gfp for page allocations
+ *	@md: optional preallocated page pool
+ *
+ *	Create a bci.  A bci is allocated and populated with pages so
+ *	that the src area can be copied.  The src pair is copied for
+ *	later reference.
+ *
+ *	RETURNS:
+ *	Pointer to the new bci on success, NULL on failure.
+ */
+static struct bio_copy_info *bci_create(struct iovec *src_iov, int src_count,
+					gfp_t gfp, gfp_t page_gfp,
+					struct rq_map_data *md)
 {
-	struct bio_copy_info *bci = kmalloc(sizeof(*bci), gfp);
+	struct bio_copy_info *bci;
 
+	bci = kzalloc(sizeof(*bci), gfp);
 	if (!bci)
 		return NULL;
 
-	bci->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, gfp);
-	if (!bci->iovecs) {
-		kfree(bci);
-		return NULL;
-	}
+	bci->src_count = src_count;
+	bci->len = iov_length(src_iov, src_count);
+	bci->is_our_pages = md == NULL;
 
-	bci->src_iov = kmalloc(sizeof(struct iovec) * count, gfp);
-	if (bci->src_count)
-		return bci;
+	bci->copy_sgl = bio_alloc_sgl_with_pages(bci->len, gfp, page_gfp, md,
+						 &bci->copy_nents);
+	if (!bci->copy_sgl)
+		goto err;
 
-	kfree(bci->iovecs);
-	kfree(bci);
+	bci->src_iov = kmalloc(sizeof(src_iov[0]) * src_count, gfp);
+	if (!bci->src_iov)
+		goto err;
+	memcpy(bci->src_iov, src_iov, sizeof(src_iov[0]) * src_count);
+
+	return bci;
+
+err:
+	bci_destroy(bci);
 	return NULL;
 }
 
-static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
-			  struct iovec *iov, int count, int uncopy,
-			  int do_free_page)
+/**
+ *	bio_memcpy_sgl_uiov - copy data between sgl and user iov
+ *	@sgl: sgl to copy to/from
+ *	@nents: number of entries in @sgl
+ *	@iov: user iov to copy from/to
+ *	@count: number of entries in @iov
+ *	@to_sgl: copy direction, true for @iov->@sgl, false for @sgl->@iov
+ *
+ *	Copy data between kernel area described by @sgl/@nents and
+ *	user area described by @iov/@count.  Copy direction is
+ *	determined by @to_sgl.  The areas must be of the same size.
+ *
+ *	RETURNS:
+ *	0 on success, -EFAULT on user area access error.
+ */
+static int bio_memcpy_sgl_uiov(struct scatterlist *sgl, int nents,
+			       struct iovec *iov, int count, bool to_sgl)
 {
-	int ret = 0, i;
-	struct bio_vec *bvec;
-	int iov_idx = 0;
-	unsigned int iov_off = 0;
-	int read = bio_data_dir(bio) == READ;
+	struct sg_mapping_iter si;
+	struct iov_iter ii;
+	int ret = 0;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
-		char *bv_addr = page_address(bvec->bv_page);
-		unsigned int bv_len = iovecs[i].bv_len;
-
-		while (bv_len && iov_idx < count) {
-			unsigned int bytes;
-			char *iov_addr;
-
-			bytes = min_t(unsigned int,
-				      iov[iov_idx].iov_len - iov_off, bv_len);
-			iov_addr = iov[iov_idx].iov_base + iov_off;
-
-			if (!ret) {
-				if (!read && !uncopy)
-					ret = copy_from_user(bv_addr, iov_addr,
-							     bytes);
-				if (read && uncopy)
-					ret = copy_to_user(iov_addr, bv_addr,
-							   bytes);
-
-				if (ret)
-					ret = -EFAULT;
-			}
+	sg_miter_start(&si, sgl, nents);
+	iov_iter_init(&ii, iov, count, iov_length(iov, count), 0);
+
+	while (sg_miter_next(&si)) {
+		void *saddr = si.addr;
+		size_t slen = si.length;
+
+		while (slen && iov_iter_count(&ii)) {
+			void __user *iaddr = ii.iov->iov_base + ii.iov_offset;
+			size_t copy = min(slen, iov_iter_single_seg_count(&ii));
+			size_t left;
 
-			bv_len -= bytes;
-			bv_addr += bytes;
-			iov_addr += bytes;
-			iov_off += bytes;
+			if (to_sgl)
+				left = copy_from_user(saddr, iaddr, copy);
+			else
+				left = copy_to_user(iaddr, saddr, copy);
 
-			if (iov[iov_idx].iov_len == iov_off) {
-				iov_idx++;
-				iov_off = 0;
+			if (unlikely(left)) {
+				ret = -EFAULT;
+				goto done;
 			}
+
+			saddr += copy;
+			slen -= copy;
+			iov_iter_advance(&ii, copy);
 		}
+		WARN_ON_ONCE(slen);		/* iov too short */
+	}
+	WARN_ON_ONCE(iov_iter_count(&ii));	/* bio too short */
+done:
+	sg_miter_stop(&si);
+	return ret;
+}
+
+/**
+ *	bio_init_from_sgl - initialize bio from sgl
+ *	@bio: bio to initialize
+ *	@q: request_queue new bio belongs to
+ *	@sgl: sgl describing the data area
+ *	@nents: number of entries in @sgl
+ *	@nr_pages: number of pages in @sgl
+ *	@rw: the data direction of new bio
+ *
+ *	Populate @bio with the data area described by @sgl.  Note that
+ *	the resulting bio might not contain the whole @sgl area.  This
+ *	can be checked by testing bio->bi_size against total area
+ *	length.
+ */
+static void bio_init_from_sgl(struct bio *bio, struct request_queue *q,
+			      struct scatterlist *sgl, int nents,
+			      int nr_pages, int rw)
+{
+	struct scatterlist *sg;
+	int i;
+
+	if (rw == WRITE)
+		bio->bi_rw |= 1 << BIO_RW;
+
+	for_each_sg(sgl, sg, nents, i) {
+		struct page *page = sg_page(sg);
+		size_t offset = sg->offset;
+		size_t len = sg->length;
 
-		if (do_free_page)
-			__free_page(bvec->bv_page);
+		while (len) {
+			size_t bytes = min_t(size_t, len, PAGE_SIZE - offset);
+
+			if (unlikely(bio_add_pc_page(q, bio, page,
+						     bytes, offset) < bytes))
+				break;
+
+			offset = 0;
+			len -= bytes;
+			page = nth_page(page, 1);
+		}
 	}
+}
 
-	return ret;
+/**
+ *	bio_create_from_sgl - create bio from sgl
+ *	@q: request_queue new bio belongs to
+ *	@sgl: sgl describing the data area
+ *	@nents: number of entries in @sgl
+ *	@nr_pages: number of pages in @sgl
+ *	@rw: the data direction of new bio
+ *	@gfp: gfp for data structure allocations
+ *
+ *	Allocate a bio and populate it with using bio_init_from_sgl().
+ *
+ *	RETURNS:
+ *	Pointer to the new bio on success, ERR_PTR(-errno) on error.
+ */
+static struct bio *bio_create_from_sgl(struct request_queue *q,
+				       struct scatterlist *sgl, int nents,
+				       int nr_pages, int rw, int gfp)
+{
+	struct bio *bio;
+
+	bio = bio_kmalloc(gfp, nr_pages);
+	if (!bio)
+		return ERR_PTR(-ENOMEM);
+
+	bio_init_from_sgl(bio, q, sgl, nents, nr_pages, rw);
+
+	return bio;
 }
 
 /**
@@ -763,10 +965,10 @@ int bio_uncopy_user(struct bio *bio)
 	struct bio_copy_info *bci = bio->bi_private;
 	int ret = 0;
 
-	if (!bio_flagged(bio, BIO_NULL_MAPPED))
-		ret = __bio_copy_iov(bio, bci->iovecs, bci->src_iov,
-				     bci->src_count, 1, bci->is_our_pages);
-	bci_free(bci);
+	if (!bio_flagged(bio, BIO_NULL_MAPPED) && bio_data_dir(bio) == READ)
+		ret = bio_memcpy_sgl_uiov(bci->copy_sgl, bci->copy_nents,
+					  bci->src_iov, bci->src_count, false);
+	bci_destroy(bci);
 	bio_put(bio);
 	return ret;
 }
@@ -788,102 +990,32 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct rq_map_data *md,
 			      struct iovec *iov, int count, int rw, gfp_t gfp)
 {
 	struct bio_copy_info *bci;
-	struct bio_vec *bvec;
-	struct page *page;
 	struct bio *bio;
-	int i, ret;
-	int nr_pages = 0;
-	unsigned int len = 0;
-	unsigned int offset = md ? md->offset & ~PAGE_MASK : 0;
+	int ret;
 
-	for (i = 0; i < count; i++) {
-		unsigned long uaddr;
-		unsigned long end;
-		unsigned long start;
-
-		uaddr = (unsigned long)iov[i].iov_base;
-		end = (uaddr + iov[i].iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		start = uaddr >> PAGE_SHIFT;
-
-		nr_pages += end - start;
-		len += iov[i].iov_len;
-	}
-
-	bci = bci_alloc(nr_pages, count, gfp);
+	bci = bci_create(iov, count, gfp, q->bounce_gfp | gfp, md);
 	if (!bci)
 		return ERR_PTR(-ENOMEM);
 
-	ret = -ENOMEM;
-	bio = bio_kmalloc(gfp, nr_pages);
-	if (!bio)
-		goto out_bci;
-
-	if (rw == WRITE)
-		bio->bi_rw |= 1 << BIO_RW;
-
-	ret = 0;
-
-	if (md) {
-		nr_pages = 1 << md->page_order;
-		i = md->offset / PAGE_SIZE;
-	}
-	while (len) {
-		unsigned int bytes = PAGE_SIZE;
-
-		bytes -= offset;
-
-		if (bytes > len)
-			bytes = len;
-
-		if (md) {
-			if (i == md->nr_entries * nr_pages) {
-				ret = -ENOMEM;
-				break;
-			}
-
-			page = md->pages[i / nr_pages];
-			page += (i % nr_pages);
-
-			i++;
-		} else {
-			page = alloc_page(q->bounce_gfp | gfp);
-			if (!page) {
-				ret = -ENOMEM;
-				break;
-			}
-		}
-
-		if (bio_add_pc_page(q, bio, page, bytes, offset) < bytes)
-			break;
-
-		len -= bytes;
-		offset = 0;
+	if (rw == WRITE && (!md || !md->null_mapped)) {
+		ret = bio_memcpy_sgl_uiov(bci->copy_sgl, bci->copy_nents,
+					  iov, count, true);
+		if (ret)
+			goto err_bci;
 	}
 
-	if (ret)
-		goto cleanup;
-
-	/*
-	 * success
-	 */
-	if (unlikely(md && md->null_mapped))
-		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
-	else if (rw == WRITE) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, count, 0, 0);
-		if (ret)
-			goto cleanup;
+	bio = bio_create_from_sgl(q, bci->copy_sgl, bci->copy_nents,
+				  bci->copy_nents, rw, gfp);
+	if (IS_ERR(bio)) {
+		ret = PTR_ERR(bio);
+		goto err_bci;
 	}
 
-	bci_set(bci, bio, iov, count, md ? 0 : 1);
+	bio->bi_private = bci;
 	return bio;
-cleanup:
-	if (!md)
-		bio_for_each_segment(bvec, bio, i)
-			__free_page(bvec->bv_page);
 
-	bio_put(bio);
-out_bci:
-	bci_free(bci);
+err_bci:
+	bci_destroy(bci);
 	return ERR_PTR(ret);
 }
 
@@ -1186,24 +1318,13 @@ struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 
 static void bio_copy_kern_endio(struct bio *bio, int err)
 {
-	struct bio_vec *bvec;
-	const int read = bio_data_dir(bio) == READ;
 	struct bio_copy_info *bci = bio->bi_private;
-	int i;
-	char *p = bci->src_iov[0].iov_base;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
-		char *addr = page_address(bvec->bv_page);
-		int len = bci->iovecs[i].bv_len;
-
-		if (read && !err)
-			memcpy(p, addr, len);
-
-		__free_page(bvec->bv_page);
-		p += len;
-	}
+	if (bio_data_dir(bio) == READ)
+		bio_memcpy_sgl_uiov(bci->copy_sgl, bci->copy_nents,
+				    bci->src_iov, bci->src_count, false);
 
-	bci_free(bci);
+	bci_destroy(bci);
 	bio_put(bio);
 }
 
-- 
1.6.0.2

