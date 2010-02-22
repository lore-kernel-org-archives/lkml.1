Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0BVNfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:35:13 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:44979 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0BVNfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:35:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Kt8nBKUsqruMjhdo3vKgcUhj1NpSlcT605c+D1XqHVpb1yKQz2pWT3WeAMAGixobf5
         ALvooooynWPde9KHOwplxuM45hjWnx/A+bwtweauLkZyl0ySV9T5XNPn/byY9Ea08Xsz
         vrbN3RynuNvV4ttthq0mgrkF3US5YHTgvI6I0=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] pktcdvd: use BIO list management functions
Date: Mon, 22 Feb 2010 22:29:23 +0900
Message-Id: <1266845364-3242-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the bio list management stuff is generic, convert pktcdvd to
use bio lists instead of its own private bio list implementation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc:  Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
---
 drivers/block/pktcdvd.c |   89 +++++++++++------------------------------------
 include/linux/pktcdvd.h |   10 ++---
 2 files changed, 25 insertions(+), 74 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 68b5957..7cd2973 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -569,6 +569,7 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 	}
 
 	spin_lock_init(&pkt->lock);
+	bio_list_init(&pkt->orig_bios);
 
 	for (i = 0; i < frames; i++) {
 		struct bio *bio = pkt_bio_alloc(1);
@@ -721,43 +722,6 @@ static void pkt_rbtree_insert(struct pktcdvd_device *pd, struct pkt_rb_node *nod
 }
 
 /*
- * Add a bio to a single linked list defined by its head and tail pointers.
- */
-static void pkt_add_list_last(struct bio *bio, struct bio **list_head, struct bio **list_tail)
-{
-	bio->bi_next = NULL;
-	if (*list_tail) {
-		BUG_ON((*list_head) == NULL);
-		(*list_tail)->bi_next = bio;
-		(*list_tail) = bio;
-	} else {
-		BUG_ON((*list_head) != NULL);
-		(*list_head) = bio;
-		(*list_tail) = bio;
-	}
-}
-
-/*
- * Remove and return the first bio from a single linked list defined by its
- * head and tail pointers.
- */
-static inline struct bio *pkt_get_list_first(struct bio **list_head, struct bio **list_tail)
-{
-	struct bio *bio;
-
-	if (*list_head == NULL)
-		return NULL;
-
-	bio = *list_head;
-	*list_head = bio->bi_next;
-	if (*list_head == NULL)
-		*list_tail = NULL;
-
-	bio->bi_next = NULL;
-	return bio;
-}
-
-/*
  * Send a packet_command to the underlying block device and
  * wait for completion.
  */
@@ -876,13 +840,10 @@ static noinline_for_stack int pkt_set_speed(struct pktcdvd_device *pd,
 static void pkt_queue_bio(struct pktcdvd_device *pd, struct bio *bio)
 {
 	spin_lock(&pd->iosched.lock);
-	if (bio_data_dir(bio) == READ) {
-		pkt_add_list_last(bio, &pd->iosched.read_queue,
-				  &pd->iosched.read_queue_tail);
-	} else {
-		pkt_add_list_last(bio, &pd->iosched.write_queue,
-				  &pd->iosched.write_queue_tail);
-	}
+	if (bio_data_dir(bio) == READ)
+		bio_list_add(&pd->iosched.read_queue, bio);
+	else
+		bio_list_add(&pd->iosched.write_queue, bio);
 	spin_unlock(&pd->iosched.lock);
 
 	atomic_set(&pd->iosched.attention, 1);
@@ -917,8 +878,8 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 		int reads_queued, writes_queued;
 
 		spin_lock(&pd->iosched.lock);
-		reads_queued = (pd->iosched.read_queue != NULL);
-		writes_queued = (pd->iosched.write_queue != NULL);
+		reads_queued = !bio_list_empty(&pd->iosched.read_queue);
+		writes_queued = !bio_list_empty(&pd->iosched.write_queue);
 		spin_unlock(&pd->iosched.lock);
 
 		if (!reads_queued && !writes_queued)
@@ -927,7 +888,7 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 		if (pd->iosched.writing) {
 			int need_write_seek = 1;
 			spin_lock(&pd->iosched.lock);
-			bio = pd->iosched.write_queue;
+			bio = bio_list_peek(&pd->iosched.write_queue);
 			spin_unlock(&pd->iosched.lock);
 			if (bio && (bio->bi_sector == pd->iosched.last_write))
 				need_write_seek = 0;
@@ -950,13 +911,10 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 		}
 
 		spin_lock(&pd->iosched.lock);
-		if (pd->iosched.writing) {
-			bio = pkt_get_list_first(&pd->iosched.write_queue,
-						 &pd->iosched.write_queue_tail);
-		} else {
-			bio = pkt_get_list_first(&pd->iosched.read_queue,
-						 &pd->iosched.read_queue_tail);
-		}
+		if (pd->iosched.writing)
+			bio = bio_list_pop(&pd->iosched.write_queue);
+		else
+			bio = bio_list_pop(&pd->iosched.read_queue);
 		spin_unlock(&pd->iosched.lock);
 
 		if (!bio)
@@ -1114,7 +1072,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	int f;
 	char written[PACKET_MAX_SIZE];
 
-	BUG_ON(!pkt->orig_bios);
+	BUG_ON(bio_list_empty(&pkt->orig_bios));
 
 	atomic_set(&pkt->io_wait, 0);
 	atomic_set(&pkt->io_errors, 0);
@@ -1124,7 +1082,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	 */
 	memset(written, 0, sizeof(written));
 	spin_lock(&pkt->lock);
-	for (bio = pkt->orig_bios; bio; bio = bio->bi_next) {
+	bio_list_for_each(bio, &pkt->orig_bios) {
 		int first_frame = (bio->bi_sector - pkt->sector) / (CD_FRAMESIZE >> 9);
 		int num_frames = bio->bi_size / CD_FRAMESIZE;
 		pd->stats.secs_w += num_frames * (CD_FRAMESIZE >> 9);
@@ -1363,7 +1321,7 @@ try_next_bio:
 			break;
 		pkt_rbtree_erase(pd, node);
 		spin_lock(&pkt->lock);
-		pkt_add_list_last(bio, &pkt->orig_bios, &pkt->orig_bios_tail);
+		bio_list_add(&pkt->orig_bios, bio);
 		pkt->write_size += bio->bi_size / CD_FRAMESIZE;
 		spin_unlock(&pkt->lock);
 	}
@@ -1409,7 +1367,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	 */
 	frames_write = 0;
 	spin_lock(&pkt->lock);
-	for (bio = pkt->orig_bios; bio; bio = bio->bi_next) {
+	bio_list_for_each(bio, &pkt->orig_bios) {
 		int segment = bio->bi_idx;
 		int src_offs = 0;
 		int first_frame = (bio->bi_sector - pkt->sector) / (CD_FRAMESIZE >> 9);
@@ -1472,20 +1430,14 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 static void pkt_finish_packet(struct packet_data *pkt, int uptodate)
 {
-	struct bio *bio, *next;
+	struct bio *bio;
 
 	if (!uptodate)
 		pkt->cache_valid = 0;
 
 	/* Finish all bios corresponding to this packet */
-	bio = pkt->orig_bios;
-	while (bio) {
-		next = bio->bi_next;
-		bio->bi_next = NULL;
+	while ((bio = bio_list_pop(&pkt->orig_bios)))
 		bio_endio(bio, uptodate ? 0 : -EIO);
-		bio = next;
-	}
-	pkt->orig_bios = pkt->orig_bios_tail = NULL;
 }
 
 static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data *pkt)
@@ -2567,8 +2519,7 @@ static int pkt_make_request(struct request_queue *q, struct bio *bio)
 			spin_lock(&pkt->lock);
 			if ((pkt->state == PACKET_WAITING_STATE) ||
 			    (pkt->state == PACKET_READ_WAIT_STATE)) {
-				pkt_add_list_last(bio, &pkt->orig_bios,
-						  &pkt->orig_bios_tail);
+				bio_list_add(&pkt->orig_bios, bio);
 				pkt->write_size += bio->bi_size / CD_FRAMESIZE;
 				if ((pkt->write_size >= pkt->frames) &&
 				    (pkt->state == PACKET_WAITING_STATE)) {
@@ -2898,6 +2849,8 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 
 	spin_lock_init(&pd->lock);
 	spin_lock_init(&pd->iosched.lock);
+	bio_list_init(&pd->iosched.read_queue);
+	bio_list_init(&pd->iosched.write_queue);
 	sprintf(pd->name, DRIVER_NAME"%d", idx);
 	init_waitqueue_head(&pd->wqueue);
 	pd->bio_queue = RB_ROOT;
diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 76e5053..721301b 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -163,10 +163,8 @@ struct packet_iosched
 	atomic_t		attention;	/* Set to non-zero when queue processing is needed */
 	int			writing;	/* Non-zero when writing, zero when reading */
 	spinlock_t		lock;		/* Protecting read/write queue manipulations */
-	struct bio		*read_queue;
-	struct bio		*read_queue_tail;
-	struct bio		*write_queue;
-	struct bio		*write_queue_tail;
+	struct bio_list		read_queue;
+	struct bio_list		write_queue;
 	sector_t		last_write;	/* The sector where the last write ended */
 	int			successive_reads;
 };
@@ -206,8 +204,8 @@ struct packet_data
 	spinlock_t		lock;		/* Lock protecting state transitions and */
 						/* orig_bios list */
 
-	struct bio		*orig_bios;	/* Original bios passed to pkt_make_request */
-	struct bio		*orig_bios_tail;/* that will be handled by this packet */
+	struct bio_list		orig_bios;	/* Original bios passed to pkt_make_request */
+						/* that will be handled by this packet */
 	int			write_size;	/* Total size of all bios in the orig_bios */
 						/* list, measured in number of frames */
 
-- 
1.6.0.6

