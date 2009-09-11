Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZIKHfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZIKHfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZIKHfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:35:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44854 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbZIKHeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:34:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/7] writeback: add name to backing_dev_info
Date: Fri, 11 Sep 2009 09:34:09 +0200
Message-Id: <1252654450-25721-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com>
References: <1252654450-25721-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables us to track who does what and print info. Its main use
is catching dirty inodes on the default_backing_dev_info, so we can
fix that up.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c            |    1 +
 drivers/block/aoe/aoeblk.c  |    1 +
 drivers/char/mem.c          |    1 +
 fs/btrfs/disk-io.c          |    1 +
 fs/char_dev.c               |    1 +
 fs/configfs/inode.c         |    1 +
 fs/fuse/inode.c             |    1 +
 fs/hugetlbfs/inode.c        |    1 +
 fs/nfs/client.c             |    1 +
 fs/ocfs2/dlm/dlmfs.c        |    1 +
 fs/ramfs/inode.c            |    1 +
 fs/sysfs/inode.c            |    1 +
 fs/ubifs/super.c            |    1 +
 include/linux/backing-dev.h |    2 ++
 kernel/cgroup.c             |    1 +
 mm/backing-dev.c            |    1 +
 mm/swap_state.c             |    1 +
 17 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e3299a7..e695634 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -501,6 +501,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
+	q->backing_dev_info.name = "block";
 
 	err = bdi_init(&q->backing_dev_info);
 	if (err) {
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 1e15889..95d3449 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -268,6 +268,7 @@ aoeblk_gdalloc(void *vp)
 	if (!d->blkq)
 		goto err_mempool;
 	blk_queue_make_request(d->blkq, aoeblk_make_request);
+	d->blkq->backing_dev_info.name = "aoe";
 	if (bdi_init(&d->blkq->backing_dev_info))
 		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index afa8813..645237b 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -822,6 +822,7 @@ static const struct file_operations zero_fops = {
  * - permits private mappings, "copies" are taken of the source of zeros
  */
 static struct backing_dev_info zero_bdi = {
+	.name		= "char/mem",
 	.capabilities	= BDI_CAP_MAP_COPY,
 };
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e83be2e..15831d5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1352,6 +1352,7 @@ static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 {
 	int err;
 
+	bdi->name = "btrfs";
 	bdi->capabilities = BDI_CAP_MAP_COPY;
 	err = bdi_init(bdi);
 	if (err)
diff --git a/fs/char_dev.c b/fs/char_dev.c
index a173551..7c27a8e 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -31,6 +31,7 @@
  * - no readahead or I/O queue unplugging required
  */
 struct backing_dev_info directly_mappable_cdev_bdi = {
+	.name = "char",
 	.capabilities	= (
 #ifdef CONFIG_MMU
 		/* permit private copies of the data to be taken */
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 4921e74..a2f7460 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -51,6 +51,7 @@ static const struct address_space_operations configfs_aops = {
 };
 
 static struct backing_dev_info configfs_backing_dev_info = {
+	.name		= "configfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f91ccc4..4567db6 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -801,6 +801,7 @@ static int fuse_bdi_init(struct fuse_conn *fc, struct super_block *sb)
 {
 	int err;
 
+	fc->bdi.name = "fuse";
 	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	fc->bdi.unplug_io_fn = default_unplug_io_fn;
 	/* fuse does it's own writeback accounting */
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cb88dac..a93b885 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -44,6 +44,7 @@ static const struct inode_operations hugetlbfs_dir_inode_operations;
 static const struct inode_operations hugetlbfs_inode_operations;
 
 static struct backing_dev_info hugetlbfs_backing_dev_info = {
+	.name		= "hugetlbfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 8d25ccb..c6be84a 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -879,6 +879,7 @@ static void nfs_server_set_fsinfo(struct nfs_server *server, struct nfs_fsinfo *
 		server->rsize = NFS_MAX_FILE_IO_SIZE;
 	server->rpages = (server->rsize + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
+	server->backing_dev_info.name = "nfs";
 	server->backing_dev_info.ra_pages = server->rpages * NFS_MAX_READAHEAD;
 
 	if (server->wsize > max_rpc_payload)
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 1c9efb4..02bf178 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -325,6 +325,7 @@ clear_fields:
 }
 
 static struct backing_dev_info dlmfs_backing_dev_info = {
+	.name		= "ocfs2-dlmfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 0ff7566..a7f0110 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -46,6 +46,7 @@ static const struct super_operations ramfs_ops;
 static const struct inode_operations ramfs_dir_inode_operations;
 
 static struct backing_dev_info ramfs_backing_dev_info = {
+	.name		= "ramfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK |
 			  BDI_CAP_MAP_DIRECT | BDI_CAP_MAP_COPY |
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 555f0ff..e57f98e 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -29,6 +29,7 @@ static const struct address_space_operations sysfs_aops = {
 };
 
 static struct backing_dev_info sysfs_backing_dev_info = {
+	.name		= "sysfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 8d6050a..51763aa 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1965,6 +1965,7 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	 *
 	 * Read-ahead will be disabled because @c->bdi.ra_pages is 0.
 	 */
+	c->bdi.name = "ubifs",
 	c->bdi.capabilities = BDI_CAP_MAP_COPY;
 	c->bdi.unplug_io_fn = default_unplug_io_fn;
 	err  = bdi_init(&c->bdi);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index d045f5f..2f218b7 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -66,6 +66,8 @@ struct backing_dev_info {
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
 	void *unplug_io_data;
 
+	char *name;
+
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
 	struct prop_local_percpu completions;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b6eadfe..c7ece8f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -600,6 +600,7 @@ static struct inode_operations cgroup_dir_inode_operations;
 static struct file_operations proc_cgroupstats_operations;
 
 static struct backing_dev_info cgroup_backing_dev_info = {
+	.name		= "cgroup",
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 22c45e9..5cb32c5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -17,6 +17,7 @@ void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 EXPORT_SYMBOL(default_unplug_io_fn);
 
 struct backing_dev_info default_backing_dev_info = {
+	.name		= "default",
 	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 42cd38e..5ae6b8b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -34,6 +34,7 @@ static const struct address_space_operations swap_aops = {
 };
 
 static struct backing_dev_info swap_backing_dev_info = {
+	.name		= "swap",
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
 	.unplug_io_fn	= swap_unplug_io_fn,
 };
-- 
1.6.4.1.207.g68ea

