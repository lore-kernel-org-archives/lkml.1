Return-Path: <linux-kernel-owner+w=401wt.eu-S1765621AbZDANq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765621AbZDANq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765394AbZDANot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:44691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764757AbZDANor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:47 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/17] bio: bio.h cleanup
Date: Wed,  1 Apr 2009 22:44:19 +0900
Message-Id: <1238593472-30360-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

bio is about to go through major update.  Take the chance and cleanup
bio.h such that

* forward declaration of structs are in one place.

* collect bio_copy/map*() prototypes in one place.

* function prototypes don't have unncessary extern in front of them
  and have their parameters named.  (dropping extern makes it much
  easier to have named parameters)

* dummy integrity APIs are inline functions instead of macros so that
  type check still occurs and unused variable warnings aren't
  triggered.

* fix return values of dummy bio_integrity_set/get_tag(),
  bio_integrity_prep() and bio_integrity_clone().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/bio.h |  178 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 108 insertions(+), 70 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8647dd9..4bf7442 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -354,56 +354,64 @@ struct bio_pair {
 	atomic_t			cnt;
 	int				error;
 };
-extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
-extern void bio_pair_release(struct bio_pair *dbio);
 
-extern struct bio_set *bioset_create(unsigned int, unsigned int);
-extern void bioset_free(struct bio_set *);
-
-extern struct bio *bio_alloc(gfp_t, int);
-extern struct bio *bio_kmalloc(gfp_t, int);
-extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
-extern void bio_put(struct bio *);
-extern void bio_free(struct bio *, struct bio_set *);
-
-extern void bio_endio(struct bio *, int);
 struct request_queue;
-extern int bio_phys_segments(struct request_queue *, struct bio *);
-
-extern void __bio_clone(struct bio *, struct bio *);
-extern struct bio *bio_clone(struct bio *, gfp_t);
-
-extern void bio_init(struct bio *);
-
-extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
-extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
-			   unsigned int, unsigned int);
-extern int bio_get_nr_vecs(struct block_device *);
-extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
-extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
-				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
 struct rq_map_data;
-extern struct bio *bio_map_user_iov(struct request_queue *,
-				    struct block_device *,
-				    struct sg_iovec *, int, int, gfp_t);
-extern void bio_unmap_user(struct bio *);
-extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
-				gfp_t);
-extern struct bio *bio_copy_kern(struct request_queue *, void *, unsigned int,
-				 gfp_t, int);
-extern void bio_set_pages_dirty(struct bio *bio);
-extern void bio_check_pages_dirty(struct bio *bio);
-extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
-				 unsigned long, unsigned int, int, gfp_t);
-extern struct bio *bio_copy_user_iov(struct request_queue *,
-				     struct rq_map_data *, struct sg_iovec *,
-				     int, int, gfp_t);
-extern int bio_uncopy_user(struct bio *);
+
+struct bio_pair *bio_split(struct bio *bi, int first_sectors);
+void bio_pair_release(struct bio_pair *dbio);
+
+struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad);
+void bioset_free(struct bio_set *bs);
+
+struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs);
+struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs);
+struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs);
+void bio_put(struct bio *bio);
+void bio_free(struct bio *bio, struct bio_set *bs);
+
+void bio_endio(struct bio *bio, int error);
+int bio_phys_segments(struct request_queue *q, struct bio *bio);
+
+void __bio_clone(struct bio *bio, struct bio *bio_src);
+struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask);
+
+void bio_init(struct bio *bio);
+
+int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
+		 unsigned int offset);
+int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
+		    unsigned int len, unsigned int offset);
+int bio_get_nr_vecs(struct block_device *bdev);
+sector_t bio_sector_offset(struct bio *bio, unsigned short index,
+			   unsigned int offset);
+struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
+			 unsigned long uaddr, unsigned int len,
+			 int write_to_vm, gfp_t gfp_mask);
+struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
+			     struct sg_iovec *iov, int iov_count,
+			     int write_to_vm, gfp_t gfp_mask);
+void bio_unmap_user(struct bio *bio);
+struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
+			  unsigned long uaddr, unsigned int len,
+			  int write_to_vm, gfp_t gfp_mask);
+struct bio *bio_copy_user_iov(struct request_queue *q,
+			      struct rq_map_data *map_data,
+			      struct sg_iovec *iov, int iov_count,
+			      int write_to_vm, gfp_t gfp_mask);
+int bio_uncopy_user(struct bio *bio);
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+			 gfp_t gfp_mask);
+struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
+			  gfp_t gfp_mask, int reading);
+void bio_set_pages_dirty(struct bio *bio);
+void bio_check_pages_dirty(struct bio *bio);
 void zero_fill_bio(struct bio *bio);
-extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set *);
-extern void bvec_free_bs(struct bio_set *, struct bio_vec *, unsigned int);
-extern unsigned int bvec_nr_vecs(unsigned short idx);
+struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
+			      struct bio_set *bs);
+void bvec_free_bs(struct bio_set *bs, struct bio_vec *bv, unsigned int idx);
+unsigned int bvec_nr_vecs(unsigned short idx);
 
 /*
  * Allow queuer to specify a completion CPU for this bio
@@ -516,34 +524,64 @@ static inline int bio_has_data(struct bio *bio)
 #define bip_for_each_vec(bvl, bip, i)					\
 	__bip_for_each_vec(bvl, bip, i, (bip)->bip_idx)
 
-#define bio_integrity(bio) (bio->bi_integrity != NULL)
-
-extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
-extern void bio_integrity_free(struct bio *);
-extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
-extern int bio_integrity_enabled(struct bio *bio);
-extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
-extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
-extern int bio_integrity_prep(struct bio *);
-extern void bio_integrity_endio(struct bio *, int);
-extern void bio_integrity_advance(struct bio *, unsigned int);
-extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
-extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
-extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
+static inline bool bio_integrity(struct bio *bio)
+{
+	return bio->bi_integrity != NULL;
+}
+
+struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
+					gfp_t gfp_mask, unsigned int nr_vecs);
+void bio_integrity_free(struct bio *bio);
+int bio_integrity_add_page(struct bio *bio, struct page *page,
+			   unsigned int len, unsigned int offset);
+int bio_integrity_enabled(struct bio *bio);
+int bio_integrity_set_tag(struct bio *bio, void *tag_buf, unsigned int len);
+int bio_integrity_get_tag(struct bio *bio, void *tag_buf, unsigned int len);
+int bio_integrity_prep(struct bio *bio);
+void bio_integrity_endio(struct bio *bio, int error);
+void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
+void bio_integrity_trim(struct bio *bio, unsigned int offset,
+			unsigned int sectors);
+void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors);
+int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp_mask);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
-#define bio_integrity(a)		(0)
-#define bio_integrity_prep(a)		(0)
-#define bio_integrity_enabled(a)	(0)
-#define bio_integrity_clone(a, b, c)	(0)
-#define bio_integrity_free(a)		do { } while (0)
-#define bio_integrity_endio(a, b)	do { } while (0)
-#define bio_integrity_advance(a, b)	do { } while (0)
-#define bio_integrity_trim(a, b, c)	do { } while (0)
-#define bio_integrity_split(a, b, c)	do { } while (0)
-#define bio_integrity_set_tag(a, b, c)	do { } while (0)
-#define bio_integrity_get_tag(a, b, c)	do { } while (0)
+static inline bool bio_integrity(struct bio *bio)
+{ return false; }
+static inline struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
+					gfp_t gfp_mask, unsigned int nr_vecs)
+{ return NULL; }
+static inline void bio_integrity_free(struct bio *bio)
+{ }
+static inline int bio_integrity_add_page(struct bio *bio, struct page *page,
+					 unsigned int len, unsigned int offset)
+{ return 0; }
+static inline int bio_integrity_enabled(struct bio *bio)
+{ return 0; }
+static inline int bio_integrity_set_tag(struct bio *bio, void *tag_buf,
+					unsigned int len)
+{ return -1; }
+static inline int bio_integrity_get_tag(struct bio *bio, void *tag_buf,
+					unsigned int len)
+{ return -1; }
+static inline int bio_integrity_prep(struct bio *bio)
+{ return -EIO; }
+static inline void bio_integrity_endio(struct bio *bio, int error)
+{ }
+static inline void bio_integrity_advance(struct bio *bio,
+					 unsigned int bytes_done)
+{ }
+static inline void bio_integrity_trim(struct bio *bio, unsigned int offset,
+				      unsigned int sectors)
+{ }
+static inline void bio_integrity_split(struct bio *bio, struct bio_pair *bp,
+				       int sectors)
+{ }
+
+static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
+				      gfp_t gfp_mask)
+{ return -EIO; }
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
-- 
1.6.0.2

