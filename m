Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbXJLRWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbXJLRWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXJLRU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:20:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762837AbXJLRUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:20:55 -0400
Date: Fri, 12 Oct 2007 18:20:41 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [2.6.24 PATCH 17/25] dm crypt: add post processing queue
Message-ID: <20071012172041.GC24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Add post-processing queue (per crypt device) for read operations.

Current implementation uses only one queue for all operations
and this can lead to starvation caused by many requests waiting
for memory allocation. But the needed memory-releasing operation
is queued after these requests (in the same queue).

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-crypt.c |   67 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 51 insertions(+), 16 deletions(-)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 13:18:16.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 14:52:45.000000000 +0100
@@ -36,7 +36,6 @@ struct dm_crypt_io {
 	struct work_struct work;
 	atomic_t pending;
 	int error;
-	int post_process;
 };
 
 /*
@@ -80,7 +79,8 @@ struct crypt_config {
 	mempool_t *page_pool;
 	struct bio_set *bs;
 
-	struct workqueue_struct *queue;
+	struct workqueue_struct *io_queue;
+	struct workqueue_struct *crypt_queue;
 	/*
 	 * crypto related data
 	 */
@@ -497,19 +497,36 @@ static void dec_pending(struct dm_crypt_
 }
 
 /*
- * kcryptd:
+ * kcryptd/kcryptd_io:
  *
  * Needed because it would be very unwise to do decryption in an
  * interrupt context.
+ *
+ * kcryptd performs the actual encryption or decryption.
+ *
+ * kcryptd_io performs the IO submission.
+ *
+ * They must be separated as otherwise the final stages could be
+ * starved by new requests which can block in the first stages due
+ * to memory allocation.
  */
 static void kcryptd_do_work(struct work_struct *work);
+static void kcryptd_do_crypt(struct work_struct *work);
 
 static void kcryptd_queue_io(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->target->private;
 
 	INIT_WORK(&io->work, kcryptd_do_work);
-	queue_work(cc->queue, &io->work);
+	queue_work(cc->io_queue, &io->work);
+}
+
+static void kcryptd_queue_crypt(struct dm_crypt_io *io)
+{
+	struct crypt_config *cc = io->target->private;
+
+	INIT_WORK(&io->work, kcryptd_do_crypt);
+	queue_work(cc->crypt_queue, &io->work);
 }
 
 static void crypt_endio(struct bio *clone, int error)
@@ -532,8 +549,7 @@ static void crypt_endio(struct bio *clon
 	}
 
 	bio_put(clone);
-	io->post_process = 1;
-	kcryptd_queue_io(io);
+	kcryptd_queue_crypt(io);
 	return;
 
 out:
@@ -655,10 +671,16 @@ static void kcryptd_do_work(struct work_
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
 
-	if (io->post_process)
-		process_read_endio(io);
-	else if (bio_data_dir(io->base_bio) == READ)
+	if (bio_data_dir(io->base_bio) == READ)
 		process_read(io);
+}
+
+static void kcryptd_do_crypt(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+
+	if (bio_data_dir(io->base_bio) == READ)
+		process_read_endio(io);
 	else
 		process_write(io);
 }
@@ -891,16 +913,24 @@ static int crypt_ctr(struct dm_target *t
 	} else
 		cc->iv_mode = NULL;
 
-	cc->queue = create_singlethread_workqueue("kcryptd");
-	if (!cc->queue) {
+	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
+	if (!cc->io_queue) {
+		ti->error = "Couldn't create kcryptd io queue";
+		goto bad_io_queue;
+	}
+
+	cc->crypt_queue = create_singlethread_workqueue("kcryptd");
+	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
-		goto bad_queue;
+		goto bad_crypt_queue;
 	}
 
 	ti->private = cc;
 	return 0;
 
-bad_queue:
+bad_crypt_queue:
+	destroy_workqueue(cc->io_queue);
+bad_io_queue:
 	kfree(cc->iv_mode);
 bad_iv_mode:
 	dm_put_device(ti, cc->dev);
@@ -926,7 +956,8 @@ static void crypt_dtr(struct dm_target *
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
-	destroy_workqueue(cc->queue);
+	destroy_workqueue(cc->io_queue);
+	destroy_workqueue(cc->crypt_queue);
 
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
@@ -952,9 +983,13 @@ static int crypt_map(struct dm_target *t
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
-	io->error = io->post_process = 0;
+	io->error = 0;
 	atomic_set(&io->pending, 0);
-	kcryptd_queue_io(io);
+
+	if (bio_data_dir(io->base_bio) == READ)
+		kcryptd_queue_io(io);
+	else
+		kcryptd_queue_crypt(io);
 
 	return DM_MAPIO_SUBMITTED;
 }
