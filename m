Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYFZLHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYFZLHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 07:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYFZLGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 07:06:50 -0400
Received: from ns1.suse.de ([195.135.220.2]:40542 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbYFZLGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 07:06:49 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-aio@kvack.org
Subject: [PATCH] aio: use cmpxchg in aio_read_evt() instead of aio_ring_info->ring_lock
Date: Thu, 26 Jun 2008 09:32:53 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
       Jeff Moyer <jmoyer@redhat.com>, Zach Brown <zach.brown@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806260932.53563.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use cmpxchg in aio_read_evt() and remove the aio_ring_info->ring_lock

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/aio.c b/fs/aio.c
index 27b7181..09e216f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -256,7 +256,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	atomic_set(&ctx->users, 1);
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -988,14 +987,13 @@ put_rq:
 /* aio_read_evt
  *	Pull an event off of the ioctx's event ring.  Returns the number of 
  *	events fetched (0 or 1 ;-)
- *	FIXME: make this use cmpxchg.
- *	TODO: make the ringbuffer user mmap()able (requires FIXME).
+ *	TODO: make the ringbuffer user mmap()able.
  */
 static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 {
 	struct aio_ring_info *info = &ioctx->ring_info;
 	struct aio_ring *ring;
-	unsigned long head;
+	unsigned long head, old, prev;
 	int ret = 0;
 
 	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
@@ -1006,19 +1004,23 @@ static int aio_read_evt(struct kioctx *ioctx, struct 
io_event *ent)
 	if (ring->head == ring->tail)
 		goto out;
 
-	spin_lock(&info->ring_lock);
+	do {
+		struct io_event *evp;
+		ret = 0;
+		old = ring->head;
+		head = old % info->nr;
 
-	head = ring->head % info->nr;
-	if (head != ring->tail) {
-		struct io_event *evp = aio_ring_event(info, head, KM_USER1);
+		if (head == ring->tail)
+			goto out;
+
+		evp = aio_ring_event(info, head, KM_USER1);
 		*ent = *evp;
 		head = (head + 1) % info->nr;
-		smp_mb(); /* finish reading the event before updatng the head */
-		ring->head = head;
+		smp_mb(); /* finish reading the event before updating the head */
+		prev = cmpxchg(&ring->head, old, head);
 		ret = 1;
 		put_aio_ring_event(evp, KM_USER1);
-	}
-	spin_unlock(&info->ring_lock);
+	} while (prev != old);
 
 out:
 	kunmap_atomic(ring, KM_USER0);
diff --git a/include/linux/aio.h b/include/linux/aio.h
index b51ddd2..c204290 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -169,7 +169,6 @@ struct aio_ring_info {
 	unsigned long		mmap_size;
 
 	struct page		**ring_pages;
-	spinlock_t		ring_lock;
 	long			nr_pages;
 
 	unsigned		nr, tail;
