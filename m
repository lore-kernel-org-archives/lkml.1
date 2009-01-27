Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZA0L7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZA0L7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZA0L65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:58:57 -0500
Received: from brick.kernel.dk ([93.163.65.50]:25763 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZA0L6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:58:55 -0500
Date: Tue, 27 Jan 2009 12:57:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block/splice bits for 2.6.29
Message-ID: <20090127115709.GR30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Collection of fixes for 2.6.29, please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Alberto Bertogli (1):
      Fix small typo in bio.h's documentation

Bartlomiej Zolnierkiewicz (1):
      block: export SSD/non-rotational queue flag through sysfs

Boaz Harrosh (1):
      include/linux: Add bsg.h to the Kernel exported headers

Jens Axboe (5):
      block: get rid of the manual directory counting in blktrace
      block: seperate bio/request unplug and sync bits
      block: add bio_rw_flagged() for testing bio->bi_rw
      block: silently error an unsupported barrier bio
      block: add sysfs file for controlling io stats accounting

Martin K. Petersen (3):
      block: Don't verify integrity metadata on read error
      block: Remove obsolete BUG_ON
      block: Allow empty integrity profile

Nikanth Karthikesan (1):
      Mark mandatory elevator functions in the biodoc.txt

Theodore Ts'o (1):
      block: Fix documentation for blkdev_issue_flush()

Vegard Nossum (1):
      splice: fix deadlock with pipe_wait() and inode locking

 Documentation/block/biodoc.txt |    6 +-
 block/blk-barrier.c            |    2 +-
 block/blk-core.c               |  100 +++++++++++++++++++++++++---------------
 block/blk-integrity.c          |   25 ++++++----
 block/blk-sysfs.c              |   58 +++++++++++++++++++++++-
 block/blktrace.c               |   72 ++++++++--------------------
 fs/bio-integrity.c             |   26 ++++++----
 fs/fifo.c                      |    2 +-
 fs/pipe.c                      |   20 +++++---
 fs/splice.c                    |    8 ++--
 include/linux/Kbuild           |    1 +
 include/linux/bio.h            |   45 +++++++++++-------
 include/linux/blkdev.h         |    8 +++
 include/linux/pipe_fs_i.h      |    4 +-
 14 files changed, 230 insertions(+), 147 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 3c5434c..5e51217 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -953,14 +953,14 @@ elevator_allow_merge_fn		called whenever the block layer determines
 				results in some sort of conflict internally,
 				this hook allows it to do that.
 
-elevator_dispatch_fn		fills the dispatch queue with ready requests.
+elevator_dispatch_fn*		fills the dispatch queue with ready requests.
 				I/O schedulers are free to postpone requests by
 				not filling the dispatch queue unless @force
 				is non-zero.  Once dispatched, I/O schedulers
 				are not allowed to manipulate the requests -
 				they belong to generic dispatch queue.
 
-elevator_add_req_fn		called to add a new request into the scheduler
+elevator_add_req_fn*		called to add a new request into the scheduler
 
 elevator_queue_empty_fn		returns true if the merge queue is empty.
 				Drivers shouldn't use this, but rather check
@@ -990,7 +990,7 @@ elevator_activate_req_fn	Called when device driver first sees a request.
 elevator_deactivate_req_fn	Called when device driver decides to delay
 				a request by requeueing it.
 
-elevator_init_fn
+elevator_init_fn*
 elevator_exit_fn		Allocate and free any elevator specific storage
 				for a queue.
 
diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 8eba4e4..f7dae57 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -302,7 +302,7 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
  * Description:
  *    Issue a flush for the block device in question. Caller can supply
  *    room for storing the error offset in case of a flush error, if they
- *    wish to.  Caller must run wait_for_completion() on its own.
+ *    wish to.
  */
 int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 {
diff --git a/block/blk-core.c b/block/blk-core.c
index a824e49..ca69f3d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -64,11 +64,12 @@ static struct workqueue_struct *kblockd_workqueue;
 
 static void drive_stat_acct(struct request *rq, int new_io)
 {
+	struct gendisk *disk = rq->rq_disk;
 	struct hd_struct *part;
 	int rw = rq_data_dir(rq);
 	int cpu;
 
-	if (!blk_fs_request(rq) || !rq->rq_disk)
+	if (!blk_fs_request(rq) || !disk || !blk_queue_io_stat(disk->queue))
 		return;
 
 	cpu = part_stat_lock();
@@ -599,8 +600,7 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
-	q->queue_flags		= (1 << QUEUE_FLAG_CLUSTER |
-				   1 << QUEUE_FLAG_STACKABLE);
+	q->queue_flags		= QUEUE_FLAG_DEFAULT;
 	q->queue_lock		= lock;
 
 	blk_queue_segment_boundary(q, BLK_SEG_BOUNDARY_MASK);
@@ -1125,6 +1125,8 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 
 	if (bio_sync(bio))
 		req->cmd_flags |= REQ_RW_SYNC;
+	if (bio_unplug(bio))
+		req->cmd_flags |= REQ_UNPLUG;
 	if (bio_rw_meta(bio))
 		req->cmd_flags |= REQ_RW_META;
 
@@ -1141,6 +1143,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	int el_ret, nr_sectors;
 	const unsigned short prio = bio_prio(bio);
 	const int sync = bio_sync(bio);
+	const int unplug = bio_unplug(bio);
 	int rw_flags;
 
 	nr_sectors = bio_sectors(bio);
@@ -1244,7 +1247,7 @@ get_rq:
 		blk_plug_device(q);
 	add_request(q, req);
 out:
-	if (sync || blk_queue_nonrot(q))
+	if (unplug || blk_queue_nonrot(q))
 		__generic_unplug_device(q);
 	spin_unlock_irq(q->queue_lock);
 	return 0;
@@ -1448,6 +1451,11 @@ static inline void __generic_make_request(struct bio *bio)
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
+		if (bio_barrier(bio) && bio_has_data(bio) &&
+		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+			err = -EOPNOTSUPP;
+			goto end_io;
+		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
@@ -1655,6 +1663,55 @@ void blkdev_dequeue_request(struct request *req)
 }
 EXPORT_SYMBOL(blkdev_dequeue_request);
 
+static void blk_account_io_completion(struct request *req, unsigned int bytes)
+{
+	struct gendisk *disk = req->rq_disk;
+
+	if (!disk || !blk_queue_io_stat(disk->queue))
+		return;
+
+	if (blk_fs_request(req)) {
+		const int rw = rq_data_dir(req);
+		struct hd_struct *part;
+		int cpu;
+
+		cpu = part_stat_lock();
+		part = disk_map_sector_rcu(req->rq_disk, req->sector);
+		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
+		part_stat_unlock();
+	}
+}
+
+static void blk_account_io_done(struct request *req)
+{
+	struct gendisk *disk = req->rq_disk;
+
+	if (!disk || !blk_queue_io_stat(disk->queue))
+		return;
+
+	/*
+	 * Account IO completion.  bar_rq isn't accounted as a normal
+	 * IO on queueing nor completion.  Accounting the containing
+	 * request is enough.
+	 */
+	if (blk_fs_request(req) && req != &req->q->bar_rq) {
+		unsigned long duration = jiffies - req->start_time;
+		const int rw = rq_data_dir(req);
+		struct hd_struct *part;
+		int cpu;
+
+		cpu = part_stat_lock();
+		part = disk_map_sector_rcu(disk, req->sector);
+
+		part_stat_inc(cpu, part, ios[rw]);
+		part_stat_add(cpu, part, ticks[rw], duration);
+		part_round_stats(cpu, part);
+		part_dec_in_flight(part);
+
+		part_stat_unlock();
+	}
+}
+
 /**
  * __end_that_request_first - end I/O on a request
  * @req:      the request being processed
@@ -1690,16 +1747,7 @@ static int __end_that_request_first(struct request *req, int error,
 				(unsigned long long)req->sector);
 	}
 
-	if (blk_fs_request(req) && req->rq_disk) {
-		const int rw = rq_data_dir(req);
-		struct hd_struct *part;
-		int cpu;
-
-		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		part_stat_add(cpu, part, sectors[rw], nr_bytes >> 9);
-		part_stat_unlock();
-	}
+	blk_account_io_completion(req, nr_bytes);
 
 	total_bytes = bio_nbytes = 0;
 	while ((bio = req->bio) != NULL) {
@@ -1779,8 +1827,6 @@ static int __end_that_request_first(struct request *req, int error,
  */
 static void end_that_request_last(struct request *req, int error)
 {
-	struct gendisk *disk = req->rq_disk;
-
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
 
@@ -1792,27 +1838,7 @@ static void end_that_request_last(struct request *req, int error)
 
 	blk_delete_timer(req);
 
-	/*
-	 * Account IO completion.  bar_rq isn't accounted as a normal
-	 * IO on queueing nor completion.  Accounting the containing
-	 * request is enough.
-	 */
-	if (disk && blk_fs_request(req) && req != &req->q->bar_rq) {
-		unsigned long duration = jiffies - req->start_time;
-		const int rw = rq_data_dir(req);
-		struct hd_struct *part;
-		int cpu;
-
-		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(disk, req->sector);
-
-		part_stat_inc(cpu, part, ios[rw]);
-		part_stat_add(cpu, part, ticks[rw], duration);
-		part_round_stats(cpu, part);
-		part_dec_in_flight(part);
-
-		part_stat_unlock();
-	}
+	blk_account_io_done(req);
 
 	if (req->end_io)
 		req->end_io(req, error);
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 61a8e2f..91fa8e0 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -309,24 +309,24 @@ static struct kobj_type integrity_ktype = {
 /**
  * blk_integrity_register - Register a gendisk as being integrity-capable
  * @disk:	struct gendisk pointer to make integrity-aware
- * @template:	integrity profile
+ * @template:	optional integrity profile to register
  *
  * Description: When a device needs to advertise itself as being able
  * to send/receive integrity metadata it must use this function to
  * register the capability with the block layer.  The template is a
  * blk_integrity struct with values appropriate for the underlying
- * hardware.  See Documentation/block/data-integrity.txt.
+ * hardware.  If template is NULL the new profile is allocated but
+ * not filled out. See Documentation/block/data-integrity.txt.
  */
 int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 {
 	struct blk_integrity *bi;
 
 	BUG_ON(disk == NULL);
-	BUG_ON(template == NULL);
 
 	if (disk->integrity == NULL) {
 		bi = kmem_cache_alloc(integrity_cachep,
-						GFP_KERNEL | __GFP_ZERO);
+				      GFP_KERNEL | __GFP_ZERO);
 		if (!bi)
 			return -1;
 
@@ -346,13 +346,16 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		bi = disk->integrity;
 
 	/* Use the provided profile as template */
-	bi->name = template->name;
-	bi->generate_fn = template->generate_fn;
-	bi->verify_fn = template->verify_fn;
-	bi->tuple_size = template->tuple_size;
-	bi->set_tag_fn = template->set_tag_fn;
-	bi->get_tag_fn = template->get_tag_fn;
-	bi->tag_size = template->tag_size;
+	if (template != NULL) {
+		bi->name = template->name;
+		bi->generate_fn = template->generate_fn;
+		bi->verify_fn = template->verify_fn;
+		bi->tuple_size = template->tuple_size;
+		bi->set_tag_fn = template->set_tag_fn;
+		bi->get_tag_fn = template->get_tag_fn;
+		bi->tag_size = template->tag_size;
+	} else
+		bi->name = "unsupported";
 
 	return 0;
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index a29cb78..e29ddfc 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -130,6 +130,27 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_nonrot_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(!blk_queue_nonrot(q), page);
+}
+
+static ssize_t queue_nonrot_store(struct request_queue *q, const char *page,
+				  size_t count)
+{
+	unsigned long nm;
+	ssize_t ret = queue_var_store(&nm, page, count);
+
+	spin_lock_irq(q->queue_lock);
+	if (nm)
+		queue_flag_clear(QUEUE_FLAG_NONROT, q);
+	else
+		queue_flag_set(QUEUE_FLAG_NONROT, q);
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
+
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(blk_queue_nomerges(q), page);
@@ -146,8 +167,8 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 		queue_flag_set(QUEUE_FLAG_NOMERGES, q);
 	else
 		queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
-
 	spin_unlock_irq(q->queue_lock);
+
 	return ret;
 }
 
@@ -176,6 +197,27 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
+static ssize_t queue_iostats_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(blk_queue_io_stat(q), page);
+}
+
+static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
+				   size_t count)
+{
+	unsigned long stats;
+	ssize_t ret = queue_var_store(&stats, page, count);
+
+	spin_lock_irq(q->queue_lock);
+	if (stats)
+		queue_flag_set(QUEUE_FLAG_IO_STAT, q);
+	else
+		queue_flag_clear(QUEUE_FLAG_IO_STAT, q);
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
+
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -210,6 +252,12 @@ static struct queue_sysfs_entry queue_hw_sector_size_entry = {
 	.show = queue_hw_sector_size_show,
 };
 
+static struct queue_sysfs_entry queue_nonrot_entry = {
+	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_nonrot_show,
+	.store = queue_nonrot_store,
+};
+
 static struct queue_sysfs_entry queue_nomerges_entry = {
 	.attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_nomerges_show,
@@ -222,6 +270,12 @@ static struct queue_sysfs_entry queue_rq_affinity_entry = {
 	.store = queue_rq_affinity_store,
 };
 
+static struct queue_sysfs_entry queue_iostats_entry = {
+	.attr = {.name = "iostats", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_iostats_show,
+	.store = queue_iostats_store,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -229,8 +283,10 @@ static struct attribute *default_attrs[] = {
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
+	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
+	&queue_iostats_entry.attr,
 	NULL,
 };
 
diff --git a/block/blktrace.c b/block/blktrace.c
index b0a2cae..39cc3bf 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -187,59 +187,12 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 
 static struct dentry *blk_tree_root;
 static DEFINE_MUTEX(blk_tree_mutex);
-static unsigned int root_users;
-
-static inline void blk_remove_root(void)
-{
-	if (blk_tree_root) {
-		debugfs_remove(blk_tree_root);
-		blk_tree_root = NULL;
-	}
-}
-
-static void blk_remove_tree(struct dentry *dir)
-{
-	mutex_lock(&blk_tree_mutex);
-	debugfs_remove(dir);
-	if (--root_users == 0)
-		blk_remove_root();
-	mutex_unlock(&blk_tree_mutex);
-}
-
-static struct dentry *blk_create_tree(const char *blk_name)
-{
-	struct dentry *dir = NULL;
-	int created = 0;
-
-	mutex_lock(&blk_tree_mutex);
-
-	if (!blk_tree_root) {
-		blk_tree_root = debugfs_create_dir("block", NULL);
-		if (!blk_tree_root)
-			goto err;
-		created = 1;
-	}
-
-	dir = debugfs_create_dir(blk_name, blk_tree_root);
-	if (dir)
-		root_users++;
-	else {
-		/* Delete root only if we created it */
-		if (created)
-			blk_remove_root();
-	}
-
-err:
-	mutex_unlock(&blk_tree_mutex);
-	return dir;
-}
 
 static void blk_trace_cleanup(struct blk_trace *bt)
 {
-	relay_close(bt->rchan);
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
-	blk_remove_tree(bt->dir);
+	relay_close(bt->rchan);
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
@@ -346,7 +299,18 @@ static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
 
 static int blk_remove_buf_file_callback(struct dentry *dentry)
 {
+	struct dentry *parent = dentry->d_parent;
 	debugfs_remove(dentry);
+
+	/*
+	* this will fail for all but the last file, but that is ok. what we
+	* care about is the top level buts->name directory going away, when
+	* the last trace file is gone. Then we don't have to rmdir() that
+	* manually on trace stop, so it nicely solves the issue with
+	* force killing of running traces.
+	*/
+
+	debugfs_remove(parent);
 	return 0;
 }
 
@@ -404,7 +368,15 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		goto err;
 
 	ret = -ENOENT;
-	dir = blk_create_tree(buts->name);
+
+	if (!blk_tree_root) {
+		blk_tree_root = debugfs_create_dir("block", NULL);
+		if (!blk_tree_root)
+			return -ENOMEM;
+	}
+
+	dir = debugfs_create_dir(buts->name, blk_tree_root);
+
 	if (!dir)
 		goto err;
 
@@ -458,8 +430,6 @@ probe_err:
 	atomic_dec(&blk_probes_ref);
 	mutex_unlock(&blk_probe_mutex);
 err:
-	if (dir)
-		blk_remove_tree(dir);
 	if (bt) {
 		if (bt->msg_file)
 			debugfs_remove(bt->msg_file);
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 77ebc3c..549b014 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -140,7 +140,6 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 
 	iv = bip_vec_idx(bip, bip->bip_vcnt);
 	BUG_ON(iv == NULL);
-	BUG_ON(iv->bv_page != NULL);
 
 	iv->bv_page = page;
 	iv->bv_len = len;
@@ -465,7 +464,7 @@ static int bio_integrity_verify(struct bio *bio)
 
 		if (ret) {
 			kunmap_atomic(kaddr, KM_USER0);
-			break;
+			return ret;
 		}
 
 		sectors = bv->bv_len / bi->sector_size;
@@ -493,18 +492,13 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 	struct bio_integrity_payload *bip =
 		container_of(work, struct bio_integrity_payload, bip_work);
 	struct bio *bio = bip->bip_bio;
-	int error = bip->bip_error;
+	int error;
 
-	if (bio_integrity_verify(bio)) {
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-		error = -EIO;
-	}
+	error = bio_integrity_verify(bio);
 
 	/* Restore original bio completion handler */
 	bio->bi_end_io = bip->bip_end_io;
-
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+	bio_endio(bio, error);
 }
 
 /**
@@ -525,7 +519,17 @@ void bio_integrity_endio(struct bio *bio, int error)
 
 	BUG_ON(bip->bip_bio != bio);
 
-	bip->bip_error = error;
+	/* In case of an I/O error there is no point in verifying the
+	 * integrity metadata.  Restore original bio end_io handler
+	 * and run it.
+	 */
+	if (error) {
+		bio->bi_end_io = bip->bip_end_io;
+		bio_endio(bio, error);
+
+		return;
+	}
+
 	INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
 	queue_work(kintegrityd_wq, &bip->bip_work);
 }
diff --git a/fs/fifo.c b/fs/fifo.c
index f8f97b8..bd2bfc6 100644
--- a/fs/fifo.c
+++ b/fs/fifo.c
@@ -20,7 +20,7 @@ static void wait_for_partner(struct inode* inode, unsigned int *cnt)
 	int cur = *cnt;	
 
 	while (cur == *cnt) {
-		pipe_wait(inode->i_pipe);
+		pipe_wait(inode->i_pipe, NULL);
 		if (signal_pending(current))
 			break;
 	}
diff --git a/fs/pipe.c b/fs/pipe.c
index 3a48ba5..7d3807c 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -37,8 +37,14 @@
  * -- Manfred Spraul <manfred@colorfullife.com> 2002-05-09
  */
 
-/* Drop the inode semaphore and wait for a pipe event, atomically */
-void pipe_wait(struct pipe_inode_info *pipe)
+/*
+ * Drop the inode semaphore and wait for a pipe event, atomically.
+ *
+ * inode2 specifies another inode lock to drop. May be NULL if no such other
+ * inode exists. This is for use with splice, which sometimes need to lock
+ * both source and destination inodes.
+ */
+void pipe_wait(struct pipe_inode_info *pipe, struct inode *inode2)
 {
 	DEFINE_WAIT(wait);
 
@@ -47,12 +53,10 @@ void pipe_wait(struct pipe_inode_info *pipe)
 	 * is considered a noninteractive wait:
 	 */
 	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	inode_double_unlock(pipe->inode, inode2);
 	schedule();
 	finish_wait(&pipe->wait, &wait);
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
+	inode_double_lock(pipe->inode, inode2);
 }
 
 static int
@@ -377,7 +381,7 @@ redo:
 			wake_up_interruptible_sync(&pipe->wait);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 		}
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 	}
 	mutex_unlock(&inode->i_mutex);
 
@@ -550,7 +554,7 @@ redo2:
 			do_wakeup = 0;
 		}
 		pipe->waiting_writers++;
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 		pipe->waiting_writers--;
 	}
 out:
diff --git a/fs/splice.c b/fs/splice.c
index 4ed0ba4..e79e906 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -240,7 +240,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 		}
 
 		pipe->waiting_writers++;
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 		pipe->waiting_writers--;
 	}
 
@@ -690,7 +690,7 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
 			do_wakeup = 0;
 		}
 
-		pipe_wait(pipe);
+		pipe_wait(pipe, sd->u.file->f_mapping->host);
 	}
 
 	if (do_wakeup) {
@@ -1523,7 +1523,7 @@ static int link_ipipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 				break;
 			}
 		}
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 	}
 
 	mutex_unlock(&pipe->inode->i_mutex);
@@ -1563,7 +1563,7 @@ static int link_opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 			break;
 		}
 		pipe->waiting_writers++;
-		pipe_wait(pipe);
+		pipe_wait(pipe, NULL);
 		pipe->waiting_writers--;
 	}
 
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 12e9a29..2124c06 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -41,6 +41,7 @@ header-y += baycom.h
 header-y += bfs_fs.h
 header-y += blkpg.h
 header-y += bpqether.h
+header-y += bsg.h
 header-y += can.h
 header-y += cdk.h
 header-y += chio.h
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 18462c5..0942765 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -144,7 +144,7 @@ struct bio {
  * bit 1 -- rw-ahead when set
  * bit 2 -- barrier
  *	Insert a serialization point in the IO queue, forcing previously
- *	submitted IO to be completed before this oen is issued.
+ *	submitted IO to be completed before this one is issued.
  * bit 3 -- synchronous I/O hint: the block layer will unplug immediately
  *	Note that this does NOT indicate that the IO itself is sync, just
  *	that the block layer will not postpone issue of this IO by plugging.
@@ -163,12 +163,33 @@ struct bio {
 #define BIO_RW		0	/* Must match RW in req flags (blkdev.h) */
 #define BIO_RW_AHEAD	1	/* Must match FAILFAST in req flags */
 #define BIO_RW_BARRIER	2
-#define BIO_RW_SYNC	3
-#define BIO_RW_META	4
-#define BIO_RW_DISCARD	5
-#define BIO_RW_FAILFAST_DEV		6
-#define BIO_RW_FAILFAST_TRANSPORT	7
-#define BIO_RW_FAILFAST_DRIVER		8
+#define BIO_RW_SYNCIO	3
+#define BIO_RW_UNPLUG	4
+#define BIO_RW_META	5
+#define BIO_RW_DISCARD	6
+#define BIO_RW_FAILFAST_DEV		7
+#define BIO_RW_FAILFAST_TRANSPORT	8
+#define BIO_RW_FAILFAST_DRIVER		9
+
+#define BIO_RW_SYNC	(BIO_RW_SYNCIO | BIO_RW_UNPLUG)
+
+#define bio_rw_flagged(bio, flag)	((bio)->bi_rw & (1 << (flag)))
+
+/*
+ * Old defines, these should eventually be replaced by direct usage of
+ * bio_rw_flagged()
+ */
+#define bio_barrier(bio)	bio_rw_flagged(bio, BIO_RW_BARRIER)
+#define bio_sync(bio)		bio_rw_flagged(bio, BIO_RW_SYNCIO)
+#define bio_unplug(bio)		bio_rw_flagged(bio, BIO_RW_UNPLUG)
+#define bio_failfast_dev(bio)	bio_rw_flagged(bio, BIO_RW_FAILFAST_DEV)
+#define bio_failfast_transport(bio)	\
+		bio_rw_flagged(bio, BIO_RW_FAILFAST_TRANSPORT)
+#define bio_failfast_driver(bio) 	\
+		bio_rw_flagged(bio, BIO_RW_FAILFAST_DRIVER)
+#define bio_rw_ahead(bio)	bio_rw_flagged(bio, BIO_RW_AHEAD)
+#define bio_rw_meta(bio)	bio_rw_flagged(bio, BIO_RW_META)
+#define bio_discard(bio)	bio_rw_flagged(bio, BIO_RW_DISCARD)
 
 /*
  * upper 16 bits of bi_rw define the io priority of this bio
@@ -193,15 +214,6 @@ struct bio {
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
-#define bio_barrier(bio)	((bio)->bi_rw & (1 << BIO_RW_BARRIER))
-#define bio_sync(bio)		((bio)->bi_rw & (1 << BIO_RW_SYNC))
-#define bio_failfast_dev(bio)	((bio)->bi_rw &	(1 << BIO_RW_FAILFAST_DEV))
-#define bio_failfast_transport(bio)	\
-	((bio)->bi_rw & (1 << BIO_RW_FAILFAST_TRANSPORT))
-#define bio_failfast_driver(bio) ((bio)->bi_rw & (1 << BIO_RW_FAILFAST_DRIVER))
-#define bio_rw_ahead(bio)	((bio)->bi_rw & (1 << BIO_RW_AHEAD))
-#define bio_rw_meta(bio)	((bio)->bi_rw & (1 << BIO_RW_META))
-#define bio_discard(bio)	((bio)->bi_rw & (1 << BIO_RW_DISCARD))
 #define bio_empty_barrier(bio)	(bio_barrier(bio) && !bio_has_data(bio) && !bio_discard(bio))
 
 static inline unsigned int bio_cur_sectors(struct bio *bio)
@@ -312,7 +324,6 @@ struct bio_integrity_payload {
 	void			*bip_buf;	/* generated integrity data */
 	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
 
-	int			bip_error;	/* saved I/O error */
 	unsigned int		bip_size;
 
 	unsigned short		bip_pool;	/* pool the ivec came from */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 044467e..d08c4b8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -108,6 +108,7 @@ enum rq_flag_bits {
 	__REQ_RW_META,		/* metadata io request */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
+	__REQ_UNPLUG,		/* unplug queue on submission */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -134,6 +135,7 @@ enum rq_flag_bits {
 #define REQ_RW_META	(1 << __REQ_RW_META)
 #define REQ_COPY_USER	(1 << __REQ_COPY_USER)
 #define REQ_INTEGRITY	(1 << __REQ_INTEGRITY)
+#define REQ_UNPLUG	(1 << __REQ_UNPLUG)
 
 #define BLK_MAX_CDB	16
 
@@ -449,6 +451,11 @@ struct request_queue
 #define QUEUE_FLAG_STACKABLE   13	/* supports request stacking */
 #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
+#define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
+
+#define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
+				 (1 << QUEUE_FLAG_CLUSTER) |		\
+				  1 << QUEUE_FLAG_STACKABLE)
 
 static inline int queue_is_locked(struct request_queue *q)
 {
@@ -565,6 +572,7 @@ enum {
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
+#define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 8e41202..ba72941 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -134,8 +134,8 @@ struct pipe_buf_operations {
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
 
-/* Drop the inode semaphore and wait for a pipe event, atomically */
-void pipe_wait(struct pipe_inode_info *pipe);
+/* Drop the inode mutex(es) and wait for a pipe event, atomically */
+void pipe_wait(struct pipe_inode_info *pipe, struct inode *inode2);
 
 struct pipe_inode_info * alloc_pipe_info(struct inode * inode);
 void free_pipe_info(struct inode * inode);

-- 
Jens Axboe

