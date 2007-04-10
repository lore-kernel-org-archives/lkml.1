Return-Path: <linux-kernel-owner+w=401wt.eu-S1161130AbXDJXyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161130AbXDJXyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161128AbXDJXyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:54:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161130AbXDJXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:54:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:to:subject:message-id:date:from;
	b=KS9rWLoH46HIck4SntRlQ8j1qy37mKK++piRsXxjSxocefzH4xN+yRE4/LjqJcJi3
	FnXIt4qih25a7xYP7bzJQ==
To: akpm@linux-foundation.org, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-Id: <20070410235353.325A7346F64@localhost>
Date: Tue, 10 Apr 2007 16:53:53 -0700 (PDT)
From: kenchen@google.com (Ken Chen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resurrect an old patch that uses atomic operation to update ring buffer
index on AIO event queue.  This work allows futher application/libaio
optimization to run fast path io_getevents in user space.

I've also added one more change on top of old implementation that rounds
ring buffer size to power of 2 to allow fast head/tail calculation. With
the new scheme, there is no more modulo operation on them and we simply
increment either pointer index directly.  This scheme also automatically
handles integer wrap nicely without any additional special treatment.


Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/fs/aio.c b/fs/aio.c
index e4598d6..00ecd14 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -108,8 +108,8 @@ static int aio_setup_ring(struct kioctx 
 	unsigned long size;
 	int nr_pages;
 
-	/* Compensate for the ring buffer's head/tail overlap entry */
-	nr_events += 2;	/* 1 is required, 2 for good luck */
+	/* round nr_event to next power of 2 */
+	nr_events = roundup_pow_of_two(nr_events);
 
 	size = sizeof(struct aio_ring);
 	size += sizeof(struct io_event) * nr_events;
@@ -118,8 +118,6 @@ static int aio_setup_ring(struct kioctx 
 	if (nr_pages < 0)
 		return -EINVAL;
 
-	nr_events = (PAGE_SIZE * nr_pages - sizeof(struct aio_ring)) / sizeof(struct io_event);
-
 	info->nr = 0;
 	info->ring_pages = info->internal_pages;
 	if (nr_pages > AIO_RING_PAGES) {
@@ -177,8 +175,8 @@ #define AIO_EVENTS_PER_PAGE	(PAGE_SIZE /
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-#define aio_ring_event(info, nr, km) ({					\
-	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
+#define aio_ring_event(info, __nr, km) ({				\
+	unsigned pos = ((__nr) & ((info)->nr - 1)) + AIO_EVENTS_OFFSET;	\
 	struct io_event *__event;					\
 	__event = kmap_atomic(						\
 			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE], km); \
@@ -220,7 +218,6 @@ static struct kioctx *ioctx_alloc(unsign
 
 	atomic_set(&ctx->users, 1);
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -927,7 +924,7 @@ int fastcall aio_complete(struct kiocb *
 	struct aio_ring	*ring;
 	struct io_event	*event;
 	unsigned long	flags;
-	unsigned long	tail;
+	unsigned	tail;
 	int		ret;
 
 	/*
@@ -969,8 +966,6 @@ int fastcall aio_complete(struct kiocb *
 
 	tail = info->tail;
 	event = aio_ring_event(info, tail, KM_IRQ0);
-	if (++tail >= info->nr)
-		tail = 0;
 
 	event->obj = (u64)(unsigned long)iocb->ki_obj.user;
 	event->data = iocb->ki_user_data;
@@ -986,13 +981,14 @@ int fastcall aio_complete(struct kiocb *
 	 */
 	smp_wmb();	/* make event visible before updating tail */
 
+	tail++;
 	info->tail = tail;
 	ring->tail = tail;
 
 	put_aio_ring_event(event, KM_IRQ0);
 	kunmap_atomic(ring, KM_IRQ1);
 
-	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
+	pr_debug("added to ring %p at [%u]\n", iocb, tail);
 put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
@@ -1007,42 +1003,36 @@ put_rq:
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
  *	events fetched (0 or 1 ;-)
- *	FIXME: make this use cmpxchg.
  *	TODO: make the ringbuffer user mmap()able (requires FIXME).
  */
 static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 {
 	struct aio_ring_info *info = &ioctx->ring_info;
 	struct aio_ring *ring;
-	unsigned long head;
-	int ret = 0;
+	struct io_event *evp;
+	unsigned head;
+	int ret;
 
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
-		 (unsigned long)ring->head, (unsigned long)ring->tail,
-		 (unsigned long)ring->nr);
-
-	if (ring->head == ring->tail)
-		goto out;
-
-	spin_lock(&info->ring_lock);
+	dprintk("in aio_read_evt h%u t%u m%u\n",
+		 ring->head, ring->tail, ring->nr);
 
-	head = ring->head % info->nr;
-	if (head != ring->tail) {
-		struct io_event *evp = aio_ring_event(info, head, KM_USER1);
+	do {
+		head = ring->head;
+		if (head == ring->tail) {
+			ret = 0;
+			break;
+		}
+		evp = aio_ring_event(info, head, KM_USER1);
 		*ent = *evp;
-		head = (head + 1) % info->nr;
 		smp_mb(); /* finish reading the event before updatng the head */
-		ring->head = head;
 		ret = 1;
 		put_aio_ring_event(evp, KM_USER1);
-	}
-	spin_unlock(&info->ring_lock);
+	} while (head != cmpxchg(&ring->head, head, head + 1));
 
-out:
 	kunmap_atomic(ring, KM_USER0);
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
-		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	dprintk("leaving aio_read_evt: %d  h%u t%u\n", ret,
+		 ring->head, ring->tail);
 	return ret;
 }
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index a30ef13..42ca8d3 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -152,11 +152,10 @@ struct aio_ring {
 	unsigned	incompat_features;
 	unsigned	header_length;	/* size of aio_ring */
 
-
-	struct io_event		io_events[0];
+	struct io_event	io_events[0];
 }; /* 128 bytes + ring size */
 
-#define aio_ring_avail(info, ring)	(((ring)->head + (info)->nr - 1 - (ring)->tail) % (info)->nr)
+#define aio_ring_avail(info, ring) ((info)->nr + (ring)->head - (ring)->tail)
 
 #define AIO_RING_PAGES	8
 struct aio_ring_info {
@@ -164,7 +163,6 @@ struct aio_ring_info {
 	unsigned long		mmap_size;
 
 	struct page		**ring_pages;
-	spinlock_t		ring_lock;
 	long			nr_pages;
 
 	unsigned		nr, tail;

