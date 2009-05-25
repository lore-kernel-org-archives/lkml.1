Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZEYHfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZEYHfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZEYHdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:33:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38667 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZEYHbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:14 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 05/13] aio: mostly crap
Date: Mon, 25 May 2009 09:30:52 +0200
Message-Id: <1243236668-3398-10-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First attempts at getting rid of some locking in aio

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/aio.c            |  151 +++++++++++++++++++++++++++++++++------------------
 include/linux/aio.h |   11 ++--
 2 files changed, 103 insertions(+), 59 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 76da125..98c82f2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -79,9 +79,8 @@ static int __init aio_setup(void)
 	return 0;
 }
 
-static void aio_free_ring(struct kioctx *ctx)
+static void __aio_free_ring(struct kioctx *ctx, struct aio_ring_info *info)
 {
-	struct aio_ring_info *info = &ctx->ring_info;
 	long i;
 
 	for (i=0; i<info->nr_pages; i++)
@@ -99,16 +98,28 @@ static void aio_free_ring(struct kioctx *ctx)
 	info->nr = 0;
 }
 
-static int aio_setup_ring(struct kioctx *ctx)
+static void aio_free_ring(struct kioctx *ctx)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i) {
+		struct aio_ring_info *info = per_cpu_ptr(ctx->ring_info, i);
+
+		 __aio_free_ring(ctx, info);
+	}
+	free_percpu(ctx->ring_info);
+	ctx->ring_info = NULL;
+}
+
+static int __aio_setup_ring(struct kioctx *ctx, struct aio_ring_info *info)
 {
 	struct aio_ring *ring;
-	struct aio_ring_info *info = &ctx->ring_info;
 	unsigned nr_events = ctx->max_reqs;
 	unsigned long size;
 	int nr_pages;
 
-	/* Compensate for the ring buffer's head/tail overlap entry */
-	nr_events += 2;	/* 1 is required, 2 for good luck */
+	/* round nr_event to next power of 2 */
+	nr_events = roundup_pow_of_two(nr_events);
 
 	size = sizeof(struct aio_ring);
 	size += sizeof(struct io_event) * nr_events;
@@ -117,8 +128,6 @@ static int aio_setup_ring(struct kioctx *ctx)
 	if (nr_pages < 0)
 		return -EINVAL;
 
-	nr_events = (PAGE_SIZE * nr_pages - sizeof(struct aio_ring)) / sizeof(struct io_event);
-
 	info->nr = 0;
 	info->ring_pages = info->internal_pages;
 	if (nr_pages > AIO_RING_PAGES) {
@@ -158,7 +167,8 @@ static int aio_setup_ring(struct kioctx *ctx)
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
 	ring->nr = nr_events;	/* user copy */
 	ring->id = ctx->user_id;
-	ring->head = ring->tail = 0;
+	atomic_set(&ring->head, 0);
+	ring->tail = 0;
 	ring->magic = AIO_RING_MAGIC;
 	ring->compat_features = AIO_RING_COMPAT_FEATURES;
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
@@ -168,6 +178,27 @@ static int aio_setup_ring(struct kioctx *ctx)
 	return 0;
 }
 
+static int aio_setup_ring(struct kioctx *ctx)
+{
+	unsigned int i;
+	int ret;
+
+	ctx->ring_info = alloc_percpu(struct aio_ring_info);
+	if (!ctx->ring_info)
+		return -ENOMEM;
+
+	ret = 0;
+	for_each_possible_cpu(i) {
+		struct aio_ring_info *info = per_cpu_ptr(ctx->ring_info, i);
+		int err;
+
+		err = __aio_setup_ring(ctx, info);
+		if (err && !ret)
+			ret = err;
+	}
+
+	return ret;
+}
 
 /* aio_ring_event: returns a pointer to the event at the given index from
  * kmap_atomic(, km).  Release the pointer with put_aio_ring_event();
@@ -176,8 +207,8 @@ static int aio_setup_ring(struct kioctx *ctx)
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-#define aio_ring_event(info, nr, km) ({					\
-	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
+#define aio_ring_event(info, __nr, km) ({				\
+	unsigned pos = ((__nr) & ((info)->nr - 1)) + AIO_EVENTS_OFFSET;	\
 	struct io_event *__event;					\
 	__event = kmap_atomic(						\
 			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE], km); \
@@ -262,7 +293,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	atomic_set(&ctx->users, 1);
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -426,6 +456,7 @@ void exit_aio(struct mm_struct *mm)
 static struct kiocb *__aio_get_req(struct kioctx *ctx)
 {
 	struct kiocb *req = NULL;
+	struct aio_ring_info *info;
 	struct aio_ring *ring;
 	int okay = 0;
 
@@ -448,15 +479,18 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
 	/* Check if the completion queue has enough free space to
 	 * accept an event from this io.
 	 */
-	spin_lock_irq(&ctx->ctx_lock);
-	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
-	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
+	local_irq_disable();
+	info = per_cpu_ptr(ctx->ring_info, smp_processor_id());
+	ring = kmap_atomic(info->ring_pages[0], KM_IRQ0);
+	if (ctx->reqs_active < aio_ring_avail(info, ring)) {
+		spin_lock(&ctx->ctx_lock);
 		list_add(&req->ki_list, &ctx->active_reqs);
 		ctx->reqs_active++;
+		spin_unlock(&ctx->ctx_lock);
 		okay = 1;
 	}
-	kunmap_atomic(ring, KM_USER0);
-	spin_unlock_irq(&ctx->ctx_lock);
+	kunmap_atomic(ring, KM_IRQ0);
+	local_irq_enable();
 
 	if (!okay) {
 		kmem_cache_free(kiocb_cachep, req);
@@ -578,9 +612,11 @@ int aio_put_req(struct kiocb *req)
 {
 	struct kioctx *ctx = req->ki_ctx;
 	int ret;
+
 	spin_lock_irq(&ctx->ctx_lock);
 	ret = __aio_put_req(ctx, req);
 	spin_unlock_irq(&ctx->ctx_lock);
+
 	return ret;
 }
 
@@ -954,7 +990,7 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	struct aio_ring	*ring;
 	struct io_event	*event;
 	unsigned long	flags;
-	unsigned long	tail;
+	unsigned	tail;
 	int		ret;
 
 	/*
@@ -972,15 +1008,14 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 		return 1;
 	}
 
-	info = &ctx->ring_info;
-
 	/* add a completion event to the ring buffer.
 	 * must be done holding ctx->ctx_lock to prevent
 	 * other code from messing with the tail
 	 * pointer since we might be called from irq
 	 * context.
 	 */
-	spin_lock_irqsave(&ctx->ctx_lock, flags);
+	local_irq_save(flags);
+	info = per_cpu_ptr(ctx->ring_info, smp_processor_id());
 
 	if (iocb->ki_run_list.prev && !list_empty(&iocb->ki_run_list))
 		list_del_init(&iocb->ki_run_list);
@@ -996,8 +1031,6 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 
 	tail = info->tail;
 	event = aio_ring_event(info, tail, KM_IRQ0);
-	if (++tail >= info->nr)
-		tail = 0;
 
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
 	event->data = iocb->ki_user_data;
@@ -1013,13 +1046,14 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
+	tail++;
 	info->tail = tail;
 	ring->tail = tail;
 
 	put_aio_ring_event(event, KM_IRQ0);
 	kunmap_atomic(ring, KM_IRQ1);
 
-	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 
 	/*
 	 * Check if the user asked us to deliver the result through an
@@ -1031,7 +1065,9 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
+	spin_lock(&ctx->ctx_lock);
 	ret = __aio_put_req(ctx, iocb);
+	spin_unlock(&ctx->ctx_lock);
 
 	/*
 	 * We have to order our ring_info tail store above and test
@@ -1044,49 +1080,58 @@ put_rq:
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
-	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
+	local_irq_restore(flags);
+	return ret;
+}
+
+static int __aio_read_evt(struct aio_ring_info *info, struct aio_ring *ring,
+			  struct io_event *ent)
+{
+	struct io_event *evp;
+	unsigned head;
+	int ret = 0;
+
+	do {
+		head = atomic_read(&ring->head);
+		if (head == ring->tail)
+			break;
+		evp = aio_ring_event(info, head, KM_USER1);
+		*ent = *evp;
+		smp_mb(); /* finish reading the event before updatng the head */
+		++ret;
+		put_aio_ring_event(evp, KM_USER1);
+	} while (head != atomic_cmpxchg(&ring->head, head, head + 1));
+
 	return ret;
 }
 
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
  *	events fetched (0 or 1 ;-)
- *	FIXME: make this use cmpxchg.
- *	TODO: make the ringbuffer user mmap()able (requires FIXME).
+ *	TODO: make the ringbuffer user mmap()able
  */
 static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 {
-	struct aio_ring_info *info = &ioctx->ring_info;
-	struct aio_ring *ring;
-	unsigned long head;
-	int ret = 0;
+	int i, ret = 0;
 
-	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
-		 (unsigned long)ring->head, (unsigned long)ring->tail,
-		 (unsigned long)ring->nr);
+	for_each_possible_cpu(i) {
+		struct aio_ring_info *info;
+		struct aio_ring *ring;
 
-	if (ring->head == ring->tail)
-		goto out;
+		info = per_cpu_ptr(ioctx->ring_info, i);
+		ring = kmap_atomic(info->ring_pages[0], KM_USER0);
+		dprintk("in aio_read_evt h%u t%u m%u\n",
+			 atomic_read(&ring->head), ring->tail, ring->nr);
 
-	spin_lock(&info->ring_lock);
-
-	head = ring->head % info->nr;
-	if (head != ring->tail) {
-		struct io_event *evp = aio_ring_event(info, head, KM_USER1);
-		*ent = *evp;
-		head = (head + 1) % info->nr;
-		smp_mb(); /* finish reading the event before updatng the head */
-		ring->head = head;
-		ret = 1;
-		put_aio_ring_event(evp, KM_USER1);
+		ret = __aio_read_evt(info, ring, ent);
+		kunmap_atomic(ring, KM_USER0);
+		if (ret)
+			break;
 	}
-	spin_unlock(&info->ring_lock);
 
-out:
-	kunmap_atomic(ring, KM_USER0);
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
-		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	dprintk("leaving aio_read_evt: %d  h%u t%u\n", ret,
+		 atomic_read(&ring->head), ring->tail);
+
 	return ret;
 }
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index b16a957..9a7acb4 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -149,7 +149,7 @@ struct kiocb {
 struct aio_ring {
 	unsigned	id;	/* kernel internal index number */
 	unsigned	nr;	/* number of io_events */
-	unsigned	head;
+	atomic_t	head;
 	unsigned	tail;
 
 	unsigned	magic;
@@ -157,11 +157,11 @@ struct aio_ring {
 	unsigned	incompat_features;
 	unsigned	header_length;	/* size of aio_ring */
 
-
-	struct io_event		io_events[0];
+	struct io_event	io_events[0];
 }; /* 128 bytes + ring size */
 
-#define aio_ring_avail(info, ring)	(((ring)->head + (info)->nr - 1 - (ring)->tail) % (info)->nr)
+#define aio_ring_avail(info, ring)					\
+	((info)->nr + (unsigned) atomic_read(&(ring)->head) - (ring)->tail)
 
 #define AIO_RING_PAGES	8
 struct aio_ring_info {
@@ -169,7 +169,6 @@ struct aio_ring_info {
 	unsigned long		mmap_size;
 
 	struct page		**ring_pages;
-	spinlock_t		ring_lock;
 	long			nr_pages;
 
 	unsigned		nr, tail;
@@ -197,7 +196,7 @@ struct kioctx {
 	/* sys_io_setup currently limits this to an unsigned int */
 	unsigned		max_reqs;
 
-	struct aio_ring_info	ring_info;
+	struct aio_ring_info	*ring_info;
 
 	struct delayed_work	wq;
 
-- 
1.6.3.rc0.1.gf800

