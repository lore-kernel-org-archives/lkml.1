Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZGAMqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZGAMqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZGAMpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:45:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46497 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGAMpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:45:54 -0400
Date: Wed, 1 Jul 2009 14:45:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.31-rc
Message-ID: <20090701124556.GA23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these fixes for 2.6.31-rc. Highlights:

- Get rid of the disabled queue command filter sysfs code. It has been
  disabled since it was added due to problems. If someone wants to pick
  up the work again, the code is there in the git history. This shrinks
  the request_queue by ~100 bytes (or about ~8%).

- Get rid of __GFP_NOFAIL misuse in CFQ.

- Restore barrier support for stacked devices.

- A DIF integrity documentation and code addition.

Please pull from:

  git://git.kernel.dk/linux-2.6-block.git for-linus

Andre Noll (1):
      Trivial typo fixes in Documentation/block/data-integrity.txt.

Jens Axboe (3):
      cfq-iosched: move cfqq initialization out of cfq_find_alloc_queue()
      cfq-iosched: get rid of the need for __GFP_NOFAIL in cfq_find_alloc_queue()
      block: get rid of queue-private command filter

Martin K. Petersen (1):
      block: Create bip slabs with embedded integrity vectors

NeilBrown (1):
      blocK: Restore barrier support for md and probably other virtual devices.

Shan Wei (1):
      cfq-iosched: remove redundant check for NULL cfqq in cfq_set_request()

 Documentation/block/data-integrity.txt |    4 +-
 block/Makefile                         |    2 +-
 block/blk-core.c                       |   14 +-
 block/bsg.c                            |    2 +-
 block/cfq-iosched.c                    |  176 +++++++++++++-----------
 block/cmd-filter.c                     |  233 --------------------------------
 block/scsi_ioctl.c                     |   43 +++++-
 drivers/md/dm.c                        |    4 +-
 drivers/scsi/sg.c                      |    4 +-
 fs/bio-integrity.c                     |  170 +++++++++++++++++------
 fs/bio.c                               |   11 +-
 include/linux/bio.h                    |   22 +++-
 include/linux/blkdev.h                 |   15 +--
 13 files changed, 294 insertions(+), 406 deletions(-)
 delete mode 100644 block/cmd-filter.c


diff --git a/Documentation/block/data-integrity.txt b/Documentation/block/data-integrity.txt
index e8ca040..2d735b0 100644
--- a/Documentation/block/data-integrity.txt
+++ b/Documentation/block/data-integrity.txt
@@ -50,7 +50,7 @@ encouraged them to allow separation of the data and integrity metadata
 scatter-gather lists.
 
 The controller will interleave the buffers on write and split them on
-read.  This means that the Linux can DMA the data buffers to and from
+read.  This means that Linux can DMA the data buffers to and from
 host memory without changes to the page cache.
 
 Also, the 16-bit CRC checksum mandated by both the SCSI and SATA specs
@@ -66,7 +66,7 @@ software RAID5).
 
 The IP checksum is weaker than the CRC in terms of detecting bit
 errors.  However, the strength is really in the separation of the data
-buffers and the integrity metadata.  These two distinct buffers much
+buffers and the integrity metadata.  These two distinct buffers must
 match up for an I/O to complete.
 
 The separation of the data and integrity metadata buffers as well as
diff --git a/block/Makefile b/block/Makefile
index e9fa4dd..6c54ed0 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-barrier.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-softirq.o blk-timeout.o \
-			ioctl.o genhd.o scsi_ioctl.o cmd-filter.o
+			ioctl.o genhd.o scsi_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
diff --git a/block/blk-core.c b/block/blk-core.c
index b06cf5c..4b45435 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -595,8 +595,6 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 
 	q->sg_reserved_size = INT_MAX;
 
-	blk_set_cmd_filter_defaults(&q->cmd_filter);
-
 	/*
 	 * all done
 	 */
@@ -1172,6 +1170,11 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	const int unplug = bio_unplug(bio);
 	int rw_flags;
 
+	if (bio_barrier(bio) && bio_has_data(bio) &&
+	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1472,11 +1475,6 @@ static inline void __generic_make_request(struct bio *bio)
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
-		if (bio_barrier(bio) && bio_has_data(bio) &&
-		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
-			err = -EOPNOTSUPP;
-			goto end_io;
-		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
@@ -2365,7 +2363,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		__bio_clone(bio, bio_src);
 
 		if (bio_integrity(bio_src) &&
-		    bio_integrity_clone(bio, bio_src, gfp_mask))
+		    bio_integrity_clone(bio, bio_src, gfp_mask, bs))
 			goto free_and_out;
 
 		if (bio_ctr && bio_ctr(bio, bio_src, data))
diff --git a/block/bsg.c b/block/bsg.c
index e7d4752..5f184bb 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -186,7 +186,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 		return -EFAULT;
 
 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
-		if (blk_verify_command(&q->cmd_filter, rq->cmd, has_write_perm))
+		if (blk_verify_command(rq->cmd, has_write_perm))
 			return -EPERM;
 	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 833ec18..87276eb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -71,6 +71,51 @@ struct cfq_rb_root {
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, }
 
 /*
+ * Per process-grouping structure
+ */
+struct cfq_queue {
+	/* reference count */
+	atomic_t ref;
+	/* various state flags, see below */
+	unsigned int flags;
+	/* parent cfq_data */
+	struct cfq_data *cfqd;
+	/* service_tree member */
+	struct rb_node rb_node;
+	/* service_tree key */
+	unsigned long rb_key;
+	/* prio tree member */
+	struct rb_node p_node;
+	/* prio tree root we belong to, if any */
+	struct rb_root *p_root;
+	/* sorted list of pending requests */
+	struct rb_root sort_list;
+	/* if fifo isn't expired, next request to serve */
+	struct request *next_rq;
+	/* requests queued in sort_list */
+	int queued[2];
+	/* currently allocated requests */
+	int allocated[2];
+	/* fifo list of requests in sort_list */
+	struct list_head fifo;
+
+	unsigned long slice_end;
+	long slice_resid;
+	unsigned int slice_dispatch;
+
+	/* pending metadata requests */
+	int meta_pending;
+	/* number of requests that are on the dispatch list or inside driver */
+	int dispatched;
+
+	/* io prio of this group */
+	unsigned short ioprio, org_ioprio;
+	unsigned short ioprio_class, org_ioprio_class;
+
+	pid_t pid;
+};
+
+/*
  * Per block device queue structure
  */
 struct cfq_data {
@@ -135,51 +180,11 @@ struct cfq_data {
 	unsigned int cfq_slice_idle;
 
 	struct list_head cic_list;
-};
-
-/*
- * Per process-grouping structure
- */
-struct cfq_queue {
-	/* reference count */
-	atomic_t ref;
-	/* various state flags, see below */
-	unsigned int flags;
-	/* parent cfq_data */
-	struct cfq_data *cfqd;
-	/* service_tree member */
-	struct rb_node rb_node;
-	/* service_tree key */
-	unsigned long rb_key;
-	/* prio tree member */
-	struct rb_node p_node;
-	/* prio tree root we belong to, if any */
-	struct rb_root *p_root;
-	/* sorted list of pending requests */
-	struct rb_root sort_list;
-	/* if fifo isn't expired, next request to serve */
-	struct request *next_rq;
-	/* requests queued in sort_list */
-	int queued[2];
-	/* currently allocated requests */
-	int allocated[2];
-	/* fifo list of requests in sort_list */
-	struct list_head fifo;
 
-	unsigned long slice_end;
-	long slice_resid;
-	unsigned int slice_dispatch;
-
-	/* pending metadata requests */
-	int meta_pending;
-	/* number of requests that are on the dispatch list or inside driver */
-	int dispatched;
-
-	/* io prio of this group */
-	unsigned short ioprio, org_ioprio;
-	unsigned short ioprio_class, org_ioprio_class;
-
-	pid_t pid;
+	/*
+	 * Fallback dummy cfqq for extreme OOM conditions
+	 */
+	struct cfq_queue oom_cfqq;
 };
 
 enum cfqq_state_flags {
@@ -1641,6 +1646,26 @@ static void cfq_ioc_set_ioprio(struct io_context *ioc)
 	ioc->ioprio_changed = 0;
 }
 
+static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+			  pid_t pid, int is_sync)
+{
+	RB_CLEAR_NODE(&cfqq->rb_node);
+	RB_CLEAR_NODE(&cfqq->p_node);
+	INIT_LIST_HEAD(&cfqq->fifo);
+
+	atomic_set(&cfqq->ref, 0);
+	cfqq->cfqd = cfqd;
+
+	cfq_mark_cfqq_prio_changed(cfqq);
+
+	if (is_sync) {
+		if (!cfq_class_idle(cfqq))
+			cfq_mark_cfqq_idle_window(cfqq);
+		cfq_mark_cfqq_sync(cfqq);
+	}
+	cfqq->pid = pid;
+}
+
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, int is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
@@ -1653,56 +1678,40 @@ retry:
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
 
-	if (!cfqq) {
+	/*
+	 * Always try a new alloc if we fell back to the OOM cfqq
+	 * originally, since it should just be a temporary situation.
+	 */
+	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
+		cfqq = NULL;
 		if (new_cfqq) {
 			cfqq = new_cfqq;
 			new_cfqq = NULL;
 		} else if (gfp_mask & __GFP_WAIT) {
-			/*
-			 * Inform the allocator of the fact that we will
-			 * just repeat this allocation if it fails, to allow
-			 * the allocator to do whatever it needs to attempt to
-			 * free memory.
-			 */
 			spin_unlock_irq(cfqd->queue->queue_lock);
 			new_cfqq = kmem_cache_alloc_node(cfq_pool,
-					gfp_mask | __GFP_NOFAIL | __GFP_ZERO,
+					gfp_mask | __GFP_ZERO,
 					cfqd->queue->node);
 			spin_lock_irq(cfqd->queue->queue_lock);
-			goto retry;
+			if (new_cfqq)
+				goto retry;
 		} else {
 			cfqq = kmem_cache_alloc_node(cfq_pool,
 					gfp_mask | __GFP_ZERO,
 					cfqd->queue->node);
-			if (!cfqq)
-				goto out;
 		}
 
-		RB_CLEAR_NODE(&cfqq->rb_node);
-		RB_CLEAR_NODE(&cfqq->p_node);
-		INIT_LIST_HEAD(&cfqq->fifo);
-
-		atomic_set(&cfqq->ref, 0);
-		cfqq->cfqd = cfqd;
-
-		cfq_mark_cfqq_prio_changed(cfqq);
-
-		cfq_init_prio_data(cfqq, ioc);
-
-		if (is_sync) {
-			if (!cfq_class_idle(cfqq))
-				cfq_mark_cfqq_idle_window(cfqq);
-			cfq_mark_cfqq_sync(cfqq);
-		}
-		cfqq->pid = current->pid;
-		cfq_log_cfqq(cfqd, cfqq, "alloced");
+		if (cfqq) {
+			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
+			cfq_init_prio_data(cfqq, ioc);
+			cfq_log_cfqq(cfqd, cfqq, "alloced");
+		} else
+			cfqq = &cfqd->oom_cfqq;
 	}
 
 	if (new_cfqq)
 		kmem_cache_free(cfq_pool, new_cfqq);
 
-out:
-	WARN_ON((gfp_mask & __GFP_WAIT) && !cfqq);
 	return cfqq;
 }
 
@@ -1735,11 +1744,8 @@ cfq_get_queue(struct cfq_data *cfqd, int is_sync, struct io_context *ioc,
 		cfqq = *async_cfqq;
 	}
 
-	if (!cfqq) {
+	if (!cfqq)
 		cfqq = cfq_find_alloc_queue(cfqd, is_sync, ioc, gfp_mask);
-		if (!cfqq)
-			return NULL;
-	}
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -2307,10 +2313,6 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	cfqq = cic_to_cfqq(cic, is_sync);
 	if (!cfqq) {
 		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
-
-		if (!cfqq)
-			goto queue_fail;
-
 		cic_set_cfqq(cic, cfqq, is_sync);
 	}
 
@@ -2465,6 +2467,14 @@ static void *cfq_init_queue(struct request_queue *q)
 	for (i = 0; i < CFQ_PRIO_LISTS; i++)
 		cfqd->prio_trees[i] = RB_ROOT;
 
+	/*
+	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
+	 * Grab a permanent reference to it, so that the normal code flow
+	 * will not attempt to free it.
+	 */
+	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
+	atomic_inc(&cfqd->oom_cfqq.ref);
+
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
 	cfqd->queue = q;
diff --git a/block/cmd-filter.c b/block/cmd-filter.c
deleted file mode 100644
index 572bbc2..0000000
--- a/block/cmd-filter.c
+++ /dev/null
@@ -1,233 +0,0 @@
-/*
- * Copyright 2004 Peter M. Jones <pjones@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- *
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public Licens
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
- *
- */
-
-#include <linux/list.h>
-#include <linux/genhd.h>
-#include <linux/spinlock.h>
-#include <linux/capability.h>
-#include <linux/bitops.h>
-#include <linux/blkdev.h>
-
-#include <scsi/scsi.h>
-#include <linux/cdrom.h>
-
-int blk_verify_command(struct blk_cmd_filter *filter,
-		       unsigned char *cmd, fmode_t has_write_perm)
-{
-	/* root can do any command. */
-	if (capable(CAP_SYS_RAWIO))
-		return 0;
-
-	/* if there's no filter set, assume we're filtering everything out */
-	if (!filter)
-		return -EPERM;
-
-	/* Anybody who can open the device can do a read-safe command */
-	if (test_bit(cmd[0], filter->read_ok))
-		return 0;
-
-	/* Write-safe commands require a writable open */
-	if (test_bit(cmd[0], filter->write_ok) && has_write_perm)
-		return 0;
-
-	return -EPERM;
-}
-EXPORT_SYMBOL(blk_verify_command);
-
-#if 0
-/* and now, the sysfs stuff */
-static ssize_t rcf_cmds_show(struct blk_cmd_filter *filter, char *page,
-			     int rw)
-{
-	char *npage = page;
-	unsigned long *okbits;
-	int i;
-
-	if (rw == READ)
-		okbits = filter->read_ok;
-	else
-		okbits = filter->write_ok;
-
-	for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
-		if (test_bit(i, okbits)) {
-			npage += sprintf(npage, "0x%02x", i);
-			if (i < BLK_SCSI_MAX_CMDS - 1)
-				sprintf(npage++, " ");
-		}
-	}
-
-	if (npage != page)
-		npage += sprintf(npage, "\n");
-
-	return npage - page;
-}
-
-static ssize_t rcf_readcmds_show(struct blk_cmd_filter *filter, char *page)
-{
-	return rcf_cmds_show(filter, page, READ);
-}
-
-static ssize_t rcf_writecmds_show(struct blk_cmd_filter *filter,
-				 char *page)
-{
-	return rcf_cmds_show(filter, page, WRITE);
-}
-
-static ssize_t rcf_cmds_store(struct blk_cmd_filter *filter,
-			      const char *page, size_t count, int rw)
-{
-	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
-	int cmd, set;
-	char *p, *status;
-
-	if (rw == READ) {
-		memcpy(&okbits, filter->read_ok, sizeof(okbits));
-		target_okbits = filter->read_ok;
-	} else {
-		memcpy(&okbits, filter->write_ok, sizeof(okbits));
-		target_okbits = filter->write_ok;
-	}
-
-	while ((p = strsep((char **)&page, " ")) != NULL) {
-		set = 1;
-
-		if (p[0] == '+') {
-			p++;
-		} else if (p[0] == '-') {
-			set = 0;
-			p++;
-		}
-
-		cmd = simple_strtol(p, &status, 16);
-
-		/* either of these cases means invalid input, so do nothing. */
-		if ((status == p) || cmd >= BLK_SCSI_MAX_CMDS)
-			return -EINVAL;
-
-		if (set)
-			__set_bit(cmd, okbits);
-		else
-			__clear_bit(cmd, okbits);
-	}
-
-	memcpy(target_okbits, okbits, sizeof(okbits));
-	return count;
-}
-
-static ssize_t rcf_readcmds_store(struct blk_cmd_filter *filter,
-				  const char *page, size_t count)
-{
-	return rcf_cmds_store(filter, page, count, READ);
-}
-
-static ssize_t rcf_writecmds_store(struct blk_cmd_filter *filter,
-				   const char *page, size_t count)
-{
-	return rcf_cmds_store(filter, page, count, WRITE);
-}
-
-struct rcf_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(struct blk_cmd_filter *, char *);
-	ssize_t (*store)(struct blk_cmd_filter *, const char *, size_t);
-};
-
-static struct rcf_sysfs_entry rcf_readcmds_entry = {
-	.attr = { .name = "read_table", .mode = S_IRUGO | S_IWUSR },
-	.show = rcf_readcmds_show,
-	.store = rcf_readcmds_store,
-};
-
-static struct rcf_sysfs_entry rcf_writecmds_entry = {
-	.attr = {.name = "write_table", .mode = S_IRUGO | S_IWUSR },
-	.show = rcf_writecmds_show,
-	.store = rcf_writecmds_store,
-};
-
-static struct attribute *default_attrs[] = {
-	&rcf_readcmds_entry.attr,
-	&rcf_writecmds_entry.attr,
-	NULL,
-};
-
-#define to_rcf(atr) container_of((atr), struct rcf_sysfs_entry, attr)
-
-static ssize_t
-rcf_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
-{
-	struct rcf_sysfs_entry *entry = to_rcf(attr);
-	struct blk_cmd_filter *filter;
-
-	filter = container_of(kobj, struct blk_cmd_filter, kobj);
-	if (entry->show)
-		return entry->show(filter, page);
-
-	return 0;
-}
-
-static ssize_t
-rcf_attr_store(struct kobject *kobj, struct attribute *attr,
-			const char *page, size_t length)
-{
-	struct rcf_sysfs_entry *entry = to_rcf(attr);
-	struct blk_cmd_filter *filter;
-
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	if (!entry->store)
-		return -EINVAL;
-
-	filter = container_of(kobj, struct blk_cmd_filter, kobj);
-	return entry->store(filter, page, length);
-}
-
-static struct sysfs_ops rcf_sysfs_ops = {
-	.show = rcf_attr_show,
-	.store = rcf_attr_store,
-};
-
-static struct kobj_type rcf_ktype = {
-	.sysfs_ops = &rcf_sysfs_ops,
-	.default_attrs = default_attrs,
-};
-
-int blk_register_filter(struct gendisk *disk)
-{
-	int ret;
-	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
-
-	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype,
-				   &disk_to_dev(disk)->kobj,
-				   "%s", "cmd_filter");
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-EXPORT_SYMBOL(blk_register_filter);
-
-void blk_unregister_filter(struct gendisk *disk)
-{
-	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
-
-	kobject_put(&filter->kobj);
-}
-EXPORT_SYMBOL(blk_unregister_filter);
-#endif
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 5f8e798..f0e0ce0 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -32,6 +32,11 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 
+struct blk_cmd_filter {
+	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
+	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
+} blk_default_cmd_filter;
+
 /* Command group 3 is reserved and should never be used.  */
 const unsigned char scsi_command_size_tbl[8] =
 {
@@ -105,7 +110,7 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 	return put_user(1, p);
 }
 
-void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
+static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
 	/* Basic read-only commands */
 	__set_bit(TEST_UNIT_READY, filter->read_ok);
@@ -187,14 +192,37 @@ void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
 	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
 }
-EXPORT_SYMBOL_GPL(blk_set_cmd_filter_defaults);
+
+int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
+{
+	struct blk_cmd_filter *filter = &blk_default_cmd_filter;
+
+	/* root can do any command. */
+	if (capable(CAP_SYS_RAWIO))
+		return 0;
+
+	/* if there's no filter set, assume we're filtering everything out */
+	if (!filter)
+		return -EPERM;
+
+	/* Anybody who can open the device can do a read-safe command */
+	if (test_bit(cmd[0], filter->read_ok))
+		return 0;
+
+	/* Write-safe commands require a writable open */
+	if (test_bit(cmd[0], filter->write_ok) && has_write_perm)
+		return 0;
+
+	return -EPERM;
+}
+EXPORT_SYMBOL(blk_verify_command);
 
 static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 			     struct sg_io_hdr *hdr, fmode_t mode)
 {
 	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(&q->cmd_filter, rq->cmd, mode & FMODE_WRITE))
+	if (blk_verify_command(rq->cmd, mode & FMODE_WRITE))
 		return -EPERM;
 
 	/*
@@ -427,7 +455,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = blk_verify_command(&q->cmd_filter, rq->cmd, mode & FMODE_WRITE);
+	err = blk_verify_command(rq->cmd, mode & FMODE_WRITE);
 	if (err)
 		goto error;
 
@@ -645,5 +673,10 @@ int scsi_cmd_ioctl(struct request_queue *q, struct gendisk *bd_disk, fmode_t mod
 	blk_put_queue(q);
 	return err;
 }
-
 EXPORT_SYMBOL(scsi_cmd_ioctl);
+
+int __init blk_scsi_ioctl_init(void)
+{
+	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
+	return 0;
+}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3c6d4ee..9acd54a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1017,7 +1017,7 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
 	clone->bi_flags |= 1 << BIO_CLONED;
 
 	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, GFP_NOIO);
+		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
 		bio_integrity_trim(clone,
 				   bio_sector_offset(bio, idx, offset), len);
 	}
@@ -1045,7 +1045,7 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, GFP_NOIO);
+		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
 
 		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
 			bio_integrity_trim(clone,
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8201387..ef142fd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -210,13 +210,11 @@ static void sg_put_dev(Sg_device *sdp);
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
 	struct sg_fd *sfp = (struct sg_fd *)filp->private_data;
-	struct request_queue *q = sfp->parentdp->device->request_queue;
 
 	if (sfp->parentdp->device->type == TYPE_SCANNER)
 		return 0;
 
-	return blk_verify_command(&q->cmd_filter,
-				  cmd, filp->f_mode & FMODE_WRITE);
+	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
 }
 
 static int
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 31c46a2..49a34e7 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -1,7 +1,7 @@
 /*
  * bio-integrity.c - bio data integrity extensions
  *
- * Copyright (C) 2007, 2008 Oracle Corporation
+ * Copyright (C) 2007, 2008, 2009 Oracle Corporation
  * Written by: Martin K. Petersen <martin.petersen@oracle.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -25,63 +25,121 @@
 #include <linux/bio.h>
 #include <linux/workqueue.h>
 
-static struct kmem_cache *bio_integrity_slab __read_mostly;
-static mempool_t *bio_integrity_pool;
-static struct bio_set *integrity_bio_set;
+struct integrity_slab {
+	struct kmem_cache *slab;
+	unsigned short nr_vecs;
+	char name[8];
+};
+
+#define IS(x) { .nr_vecs = x, .name = "bip-"__stringify(x) }
+struct integrity_slab bip_slab[BIOVEC_NR_POOLS] __read_mostly = {
+	IS(1), IS(4), IS(16), IS(64), IS(128), IS(BIO_MAX_PAGES),
+};
+#undef IS
+
 static struct workqueue_struct *kintegrityd_wq;
 
+static inline unsigned int vecs_to_idx(unsigned int nr)
+{
+	switch (nr) {
+	case 1:
+		return 0;
+	case 2 ... 4:
+		return 1;
+	case 5 ... 16:
+		return 2;
+	case 17 ... 64:
+		return 3;
+	case 65 ... 128:
+		return 4;
+	case 129 ... BIO_MAX_PAGES:
+		return 5;
+	default:
+		BUG();
+	}
+}
+
+static inline int use_bip_pool(unsigned int idx)
+{
+	if (idx == BIOVEC_NR_POOLS)
+		return 1;
+
+	return 0;
+}
+
 /**
- * bio_integrity_alloc - Allocate integrity payload and attach it to bio
+ * bio_integrity_alloc_bioset - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
  * @gfp_mask:	Memory allocation mask
  * @nr_vecs:	Number of integrity metadata scatter-gather elements
+ * @bs:		bio_set to allocate from
  *
  * Description: This function prepares a bio for attaching integrity
  * metadata.  nr_vecs specifies the maximum number of pages containing
  * integrity metadata that can be attached.
  */
-struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
-						  gfp_t gfp_mask,
-						  unsigned int nr_vecs)
+struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
+							 gfp_t gfp_mask,
+							 unsigned int nr_vecs,
+							 struct bio_set *bs)
 {
 	struct bio_integrity_payload *bip;
-	struct bio_vec *iv;
-	unsigned long idx;
+	unsigned int idx = vecs_to_idx(nr_vecs);
 
 	BUG_ON(bio == NULL);
+	bip = NULL;
 
-	bip = mempool_alloc(bio_integrity_pool, gfp_mask);
-	if (unlikely(bip == NULL)) {
-		printk(KERN_ERR "%s: could not alloc bip\n", __func__);
-		return NULL;
-	}
+	/* Lower order allocations come straight from slab */
+	if (!use_bip_pool(idx))
+		bip = kmem_cache_alloc(bip_slab[idx].slab, gfp_mask);
 
-	memset(bip, 0, sizeof(*bip));
+	/* Use mempool if lower order alloc failed or max vecs were requested */
+	if (bip == NULL) {
+		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
 
-	iv = bvec_alloc_bs(gfp_mask, nr_vecs, &idx, integrity_bio_set);
-	if (unlikely(iv == NULL)) {
-		printk(KERN_ERR "%s: could not alloc bip_vec\n", __func__);
-		mempool_free(bip, bio_integrity_pool);
-		return NULL;
+		if (unlikely(bip == NULL)) {
+			printk(KERN_ERR "%s: could not alloc bip\n", __func__);
+			return NULL;
+		}
 	}
 
-	bip->bip_pool = idx;
-	bip->bip_vec = iv;
+	memset(bip, 0, sizeof(*bip));
+
+	bip->bip_slab = idx;
 	bip->bip_bio = bio;
 	bio->bi_integrity = bip;
 
 	return bip;
 }
+EXPORT_SYMBOL(bio_integrity_alloc_bioset);
+
+/**
+ * bio_integrity_alloc - Allocate integrity payload and attach it to bio
+ * @bio:	bio to attach integrity metadata to
+ * @gfp_mask:	Memory allocation mask
+ * @nr_vecs:	Number of integrity metadata scatter-gather elements
+ *
+ * Description: This function prepares a bio for attaching integrity
+ * metadata.  nr_vecs specifies the maximum number of pages containing
+ * integrity metadata that can be attached.
+ */
+struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
+						  gfp_t gfp_mask,
+						  unsigned int nr_vecs)
+{
+	return bio_integrity_alloc_bioset(bio, gfp_mask, nr_vecs, fs_bio_set);
+}
 EXPORT_SYMBOL(bio_integrity_alloc);
 
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
+ * @bs:		bio_set this bio was allocated from
  *
  * Description: Used to free the integrity portion of a bio. Usually
  * called from bio_free().
  */
-void bio_integrity_free(struct bio *bio)
+void bio_integrity_free(struct bio *bio, struct bio_set *bs)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 
@@ -92,8 +150,10 @@ void bio_integrity_free(struct bio *bio)
 	    && bip->bip_buf != NULL)
 		kfree(bip->bip_buf);
 
-	bvec_free_bs(integrity_bio_set, bip->bip_vec, bip->bip_pool);
-	mempool_free(bip, bio_integrity_pool);
+	if (use_bip_pool(bip->bip_slab))
+		mempool_free(bip, bs->bio_integrity_pool);
+	else
+		kmem_cache_free(bip_slab[bip->bip_slab].slab, bip);
 
 	bio->bi_integrity = NULL;
 }
@@ -114,7 +174,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_vec *iv;
 
-	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_pool)) {
+	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}
@@ -647,8 +707,8 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->iv1 = bip->bip_vec[0];
 	bp->iv2 = bip->bip_vec[0];
 
-	bp->bip1.bip_vec = &bp->iv1;
-	bp->bip2.bip_vec = &bp->iv2;
+	bp->bip1.bip_vec[0] = bp->iv1;
+	bp->bip2.bip_vec[0] = bp->iv2;
 
 	bp->iv1.bv_len = sectors * bi->tuple_size;
 	bp->iv2.bv_offset += sectors * bi->tuple_size;
@@ -667,17 +727,19 @@ EXPORT_SYMBOL(bio_integrity_split);
  * @bio:	New bio
  * @bio_src:	Original bio
  * @gfp_mask:	Memory allocation mask
+ * @bs:		bio_set to allocate bip from
  *
  * Description:	Called to allocate a bip when cloning a bio
  */
-int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp_mask)
+int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
+			gfp_t gfp_mask, struct bio_set *bs)
 {
 	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
 	struct bio_integrity_payload *bip;
 
 	BUG_ON(bip_src == NULL);
 
-	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_vcnt);
+	bip = bio_integrity_alloc_bioset(bio, gfp_mask, bip_src->bip_vcnt, bs);
 
 	if (bip == NULL)
 		return -EIO;
@@ -693,25 +755,43 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(bio_integrity_clone);
 
-static int __init bio_integrity_init(void)
+int bioset_integrity_create(struct bio_set *bs, int pool_size)
 {
-	kintegrityd_wq = create_workqueue("kintegrityd");
+	unsigned int max_slab = vecs_to_idx(BIO_MAX_PAGES);
+
+	bs->bio_integrity_pool =
+		mempool_create_slab_pool(pool_size, bip_slab[max_slab].slab);
 
+	if (!bs->bio_integrity_pool)
+		return -1;
+
+	return 0;
+}
+EXPORT_SYMBOL(bioset_integrity_create);
+
+void bioset_integrity_free(struct bio_set *bs)
+{
+	if (bs->bio_integrity_pool)
+		mempool_destroy(bs->bio_integrity_pool);
+}
+EXPORT_SYMBOL(bioset_integrity_free);
+
+void __init bio_integrity_init(void)
+{
+	unsigned int i;
+
+	kintegrityd_wq = create_workqueue("kintegrityd");
 	if (!kintegrityd_wq)
 		panic("Failed to create kintegrityd\n");
 
-	bio_integrity_slab = KMEM_CACHE(bio_integrity_payload,
-					SLAB_HWCACHE_ALIGN|SLAB_PANIC);
+	for (i = 0 ; i < BIOVEC_NR_POOLS ; i++) {
+		unsigned int size;
 
-	bio_integrity_pool = mempool_create_slab_pool(BIO_POOL_SIZE,
-						      bio_integrity_slab);
-	if (!bio_integrity_pool)
-		panic("bio_integrity: can't allocate bip pool\n");
+		size = sizeof(struct bio_integrity_payload)
+			+ bip_slab[i].nr_vecs * sizeof(struct bio_vec);
 
-	integrity_bio_set = bioset_create(BIO_POOL_SIZE, 0);
-	if (!integrity_bio_set)
-		panic("bio_integrity: can't allocate bio_set\n");
-
-	return 0;
+		bip_slab[i].slab =
+			kmem_cache_create(bip_slab[i].name, size, 0,
+					  SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+	}
 }
-subsys_initcall(bio_integrity_init);
diff --git a/fs/bio.c b/fs/bio.c
index 24c9140..1486b19 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -238,7 +238,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 	if (bio_integrity(bio))
-		bio_integrity_free(bio);
+		bio_integrity_free(bio, bs);
 
 	/*
 	 * If we have front padding, adjust the bio pointer before freeing
@@ -341,7 +341,7 @@ struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 static void bio_kmalloc_destructor(struct bio *bio)
 {
 	if (bio_integrity(bio))
-		bio_integrity_free(bio);
+		bio_integrity_free(bio, fs_bio_set);
 	kfree(bio);
 }
 
@@ -472,7 +472,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask);
+		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
 
 		if (ret < 0) {
 			bio_put(b);
@@ -1539,6 +1539,7 @@ void bioset_free(struct bio_set *bs)
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
+	bioset_integrity_free(bs);
 	biovec_free_pools(bs);
 	bio_put_slab(bs);
 
@@ -1579,6 +1580,9 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
+	if (bioset_integrity_create(bs, pool_size))
+		goto bad;
+
 	if (!biovec_create_pools(bs, pool_size))
 		return bs;
 
@@ -1616,6 +1620,7 @@ static int __init init_bio(void)
 	if (!bio_slabs)
 		panic("bio: can't allocate bios\n");
 
+	bio_integrity_init();
 	biovec_init_slabs();
 
 	fs_bio_set = bioset_create(BIO_POOL_SIZE, 0);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2a04eb5..2892b71 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -319,7 +319,6 @@ static inline int bio_has_allocated_vec(struct bio *bio)
  */
 struct bio_integrity_payload {
 	struct bio		*bip_bio;	/* parent bio */
-	struct bio_vec		*bip_vec;	/* integrity data vector */
 
 	sector_t		bip_sector;	/* virtual start sector */
 
@@ -328,11 +327,12 @@ struct bio_integrity_payload {
 
 	unsigned int		bip_size;
 
-	unsigned short		bip_pool;	/* pool the ivec came from */
+	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_idx;	/* current bip_vec index */
 
 	struct work_struct	bip_work;	/* I/O completion */
+	struct bio_vec		bip_vec[0];	/* embedded bvec array */
 };
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
@@ -430,6 +430,9 @@ struct bio_set {
 	unsigned int front_pad;
 
 	mempool_t *bio_pool;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	mempool_t *bio_integrity_pool;
+#endif
 	mempool_t *bvec_pool;
 };
 
@@ -634,8 +637,9 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
+extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
-extern void bio_integrity_free(struct bio *);
+extern void bio_integrity_free(struct bio *, struct bio_set *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern int bio_integrity_enabled(struct bio *bio);
 extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
@@ -645,21 +649,27 @@ extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
-extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
+extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
+extern int bioset_integrity_create(struct bio_set *, int);
+extern void bioset_integrity_free(struct bio_set *);
+extern void bio_integrity_init(void);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
 #define bio_integrity(a)		(0)
+#define bioset_integrity_create(a, b)	(0)
 #define bio_integrity_prep(a)		(0)
 #define bio_integrity_enabled(a)	(0)
-#define bio_integrity_clone(a, b, c)	(0)
-#define bio_integrity_free(a)		do { } while (0)
+#define bio_integrity_clone(a, b, c, d)	(0)
+#define bioset_integrity_free(a)	do { } while (0)
+#define bio_integrity_free(a, b)	do { } while (0)
 #define bio_integrity_endio(a, b)	do { } while (0)
 #define bio_integrity_advance(a, b)	do { } while (0)
 #define bio_integrity_trim(a, b, c)	do { } while (0)
 #define bio_integrity_split(a, b, c)	do { } while (0)
 #define bio_integrity_set_tag(a, b, c)	do { } while (0)
 #define bio_integrity_get_tag(a, b, c)	do { } while (0)
+#define bio_integrity_init(a)		do { } while (0)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8963d91..49ae079 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -301,12 +301,6 @@ struct blk_queue_tag {
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
-struct blk_cmd_filter {
-	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
-	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-	struct kobject kobj;
-};
-
 struct queue_limits {
 	unsigned long		bounce_pfn;
 	unsigned long		seg_boundary_mask;
@@ -445,7 +439,6 @@ struct request_queue
 #if defined(CONFIG_BLK_DEV_BSG)
 	struct bsg_class_device bsg_dev;
 #endif
-	struct blk_cmd_filter cmd_filter;
 };
 
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
@@ -998,13 +991,7 @@ static inline int sb_issue_discard(struct super_block *sb,
 	return blkdev_issue_discard(sb->s_bdev, block, nr_blocks, GFP_KERNEL);
 }
 
-/*
-* command filter functions
-*/
-extern int blk_verify_command(struct blk_cmd_filter *filter,
-			      unsigned char *cmd, fmode_t has_write_perm);
-extern void blk_unregister_filter(struct gendisk *disk);
-extern void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter);
+extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
 
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128

-- 
Jens Axboe

