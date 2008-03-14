Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbYCNOFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbYCNOFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbYCNOFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:05:25 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:18900 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYCNOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:05:24 -0400
Message-ID: <47DA861D.6010904@hp.com>
Date: Fri, 14 Mar 2008 10:05:17 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Stacking bio support - patch 3/4 for 2.6.23.17 (stable)
References: <200803110352.41479.phillips@phunq.net> <47DA84B7.1000409@hp.com>
In-Reply-To: <47DA84B7.1000409@hp.com>
Content-Type: multipart/mixed;
 boundary="------------050901080704090006000406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050901080704090006000406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------050901080704090006000406
Content-Type: text/x-patch;
 name="0003-BIO-stack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-BIO-stack.patch"

>From 1cb4c136df6a84b45d4e6bccbef159455b28e949 Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Fri, 14 Mar 2008 08:27:55 -0400
Subject: [PATCH] BIO stack


---
 fs/bio.c            |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |   14 ++++++++--
 2 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 29cdd8b..d57f0f3 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -34,6 +34,63 @@ static struct kmem_cache *bio_slab __read_mostly;
 
 #define BIOVEC_NR_POOLS 6
 
+/* Bio push/pop (C) 2008, Daniel Phillips <phillips@phunq.net> */
+
+#define BIOSTACK_ALIGN (1 << 2)
+#define BIOCHUNK_SIZE (1 << 7)
+#define BIOCHUNK_MAGIC (0xddc0ffee)
+#define BIOCHUNK_OVERHEAD (sizeof(struct biochunk) + sizeof(struct bioframe))
+#define BIOCHUNK_PAYLOAD (BIOCHUNK_SIZE - BIOCHUNK_OVERHEAD)
+
+struct biochunk { u32 magic; void *oldstack; char frames[]; };
+
+static struct kmem_cache *biospace __read_mostly;
+
+static struct biochunk *alloc_biochunk(void)
+{
+	return kmem_cache_alloc(biospace, __GFP_NOFAIL);
+}
+
+static void free_biochunk(struct biochunk *chunk)
+{
+	kmem_cache_free(biospace, chunk);
+}
+
+void *bio_push(struct bio *bio, unsigned size, bio_end_io_t *endio)
+{
+	struct bioframe *frame = bio->bi_stack;
+	size += sizeof(struct bioframe);
+	size += -size & (BIOSTACK_ALIGN - 1);
+	if (unlikely(size > frame->stacksize)) {
+		struct biochunk *chunk = alloc_biochunk();
+		bio_end_io_t *old = frame->endio;
+		BUG_ON(size > BIOCHUNK_PAYLOAD);
+		*chunk = (struct biochunk){ .oldstack = bio->bi_stack, .magic = BIOCHUNK_MAGIC };
+		frame = bio->bi_stack = chunk->frames;
+		*frame = (struct bioframe){ .stacksize = BIOCHUNK_PAYLOAD, .endio = old };
+	}
+	bio->bi_stack += size;
+	*(struct bioframe *)bio->bi_stack = (struct bioframe){
+		.stacksize = frame->stacksize - size,
+		.framesize = size, .endio = endio };
+	return frame->space;
+}
+EXPORT_SYMBOL_GPL(bio_push);
+
+void *bio_pop(struct bio *bio)
+{
+	struct bioframe *frame = bio->bi_stack;
+	if (unlikely(!frame->framesize)) {
+		struct biochunk *chunk = bio->bi_stack - sizeof(struct biochunk);
+		BUG_ON(chunk->magic != BIOCHUNK_MAGIC);
+		frame = bio->bi_stack = chunk->oldstack;
+		free_biochunk(chunk);
+	}
+	frame = bio->bi_stack -= frame->framesize;
+	return frame->space;
+}
+EXPORT_SYMBOL_GPL(bio_pop);
+
 /*
  * a small number of entries is fine, not going to be performance critical.
  * basically we just need to survive
@@ -113,6 +170,9 @@ void bio_free(struct bio *bio, struct bio_set *bio_set)
 
 	BIO_BUG_ON(pool_idx >= BIOVEC_NR_POOLS);
 
+	if (!((struct bioframe *)bio->bi_stack)->framesize)
+		bio_pop(bio);
+
 	mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
 	mempool_free(bio, bio_set->bio_pool);
 }
@@ -179,6 +239,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 			bio->bi_max_vecs = bvec_slabs[idx].nr_vecs;
 		}
 		bio->bi_io_vec = bvl;
+		bio->bi_stack = &bio->space;
+		bio->space.framesize = sizeof(struct bioframe);
 	}
 out:
 	return bio;
@@ -1206,6 +1268,8 @@ static int __init init_bio(void)
 	if (!bio_split_pool)
 		panic("bio: can't create split pool\n");
 
+	biospace = kmem_cache_create("biospace", BIOCHUNK_SIZE, 0, SLAB_PANIC, NULL);
+
 	return 0;
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4c8d7a0..cca89d1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -68,6 +68,11 @@ typedef int (bio_end_io_t) (struct bio *, unsigned int, int);
 typedef void (bio_destructor_t) (struct bio *);
 
 /*
+ * Support endio handler stacking with per-handler private workspace
+ */
+struct bioframe { u16 framesize, stacksize; bio_end_io_t *endio; char space[]; };
+
+/*
  * main unit of I/O for the block layer and lower layers (ie drivers and
  * stacking drivers)
  */
@@ -114,6 +119,8 @@ struct bio {
 	void			*bi_private;
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
+	void			*bi_stack;	/* endio stacking */
+	struct bioframe		space;
 };
 
 /*
@@ -186,12 +193,12 @@ struct bio {
 
 static inline void bio_set_endio(struct bio *bio, bio_end_io_t *endio)
 {
-	bio->bi_endio = endio;
+	((struct bioframe *)bio->bi_stack)->endio = endio;
 }
 
 static inline bio_end_io_t *bio_get_endio(struct bio *bio)
 {
-	return bio->bi_endio;
+	return ((struct bioframe *)bio->bi_stack)->endio;
 }
 
 /*
@@ -295,7 +302,8 @@ extern struct bio *bio_alloc(gfp_t, int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
 extern void bio_free(struct bio *, struct bio_set *);
-
+extern void *bio_push(struct bio *bio, unsigned size, bio_end_io_t *endio);
+extern void *bio_pop(struct bio *bio);
 extern void bio_endio(struct bio *, unsigned int, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
-- 
1.5.2.5


--------------050901080704090006000406--
