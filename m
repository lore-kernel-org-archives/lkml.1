Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZEZJgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZEZJgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbZEZJe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:34:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54801 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbZEZJdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:33:53 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 11/12] writeback: add name to backing_dev_info
Date: Tue, 26 May 2009 11:33:49 +0200
Message-Id: <1243330430-9964-12-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
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
index c89883b..d3f18b5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -517,6 +517,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
+	q->backing_dev_info.name = "block";
 	err = bdi_init(&q->backing_dev_info);
 	if (err) {
 		kmem_cache_free(blk_requestq_cachep, q);
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 2307a27..0efb8fc 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -265,6 +265,7 @@ aoeblk_gdalloc(void *vp)
 	}
 
 	blk_queue_make_request(&d->blkq, aoeblk_make_request);
+	d->blkq.backing_dev_info.name = "aoe";
 	if (bdi_init(&d->blkq.backing_dev_info))
 		goto err_mempool;
 	spin_lock_irqsave(&d->lock, flags);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8f05c38..3b38093 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -820,6 +820,7 @@ static const struct file_operations zero_fops = {
  * - permits private mappings, "copies" are taken of the source of zeros
  */
 static struct backing_dev_info zero_bdi = {
+	.name		= "char/mem",
 	.capabilities	= BDI_CAP_MAP_COPY,
 };
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2dc19c9..eff2a82 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1353,6 +1353,7 @@ static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 {
 	int err;
 
+	bdi->name = "btrfs";
 	bdi->capabilities = BDI_CAP_MAP_COPY;
 	err = bdi_init(bdi);
 	if (err)
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 38f7122..350ef9c 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -32,6 +32,7 @@
  * - no readahead or I/O queue unplugging required
  */
 struct backing_dev_info directly_mappable_cdev_bdi = {
+	.name = "char",
 	.capabilities	= (
 #ifdef CONFIG_MMU
 		/* permit private copies of the data to be taken */
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 5d349d3..9a266cd 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -46,6 +46,7 @@ static const struct address_space_operations configfs_aops = {
 };
 
 static struct backing_dev_info configfs_backing_dev_info = {
+	.name		= "configfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 91f7c85..e5e8b03 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -484,6 +484,7 @@ int fuse_conn_init(struct fuse_conn *fc, struct super_block *sb)
 	INIT_LIST_HEAD(&fc->bg_queue);
 	INIT_LIST_HEAD(&fc->entry);
 	atomic_set(&fc->num_waiting, 0);
+	fc->bdi.name = "fuse";
 	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	fc->bdi.unplug_io_fn = default_unplug_io_fn;
 	/* fuse does it's own writeback accounting */
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c1462d4..db1e537 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -43,6 +43,7 @@ static const struct inode_operations hugetlbfs_dir_inode_operations;
 static const struct inode_operations hugetlbfs_inode_operations;
 
 static struct backing_dev_info hugetlbfs_backing_dev_info = {
+	.name		= "hugetlbfs",
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 75c9cd2..3a26d06 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -836,6 +836,7 @@ static void nfs_server_set_fsinfo(struct nfs_server *server, struct nfs_fsinfo *
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
index 3a6b193..5a24199 100644
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
index e9f7a75..2349e2c 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1923,6 +1923,7 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	 *
 	 * Read-ahead will be disabled because @c->bdi.ra_pages is 0.
 	 */
+	c->bdi.name = "ubifs",
 	c->bdi.capabilities = BDI_CAP_MAP_COPY;
 	c->bdi.unplug_io_fn = default_unplug_io_fn;
 	err  = bdi_init(&c->bdi);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 9523df3..f8b9325 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -70,6 +70,8 @@ struct backing_dev_info {
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
 	void *unplug_io_data;
 
+	char *name;
+
 	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 
 	struct prop_local_percpu completions;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a7267bf..0863c5f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -598,6 +598,7 @@ static struct inode_operations cgroup_dir_inode_operations;
 static struct file_operations proc_cgroupstats_operations;
 
 static struct backing_dev_info cgroup_backing_dev_info = {
+	.name		= "cgroup",
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index e7b0283..fb7e00a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -17,6 +17,7 @@ void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 EXPORT_SYMBOL(default_unplug_io_fn);
 
 struct backing_dev_info default_backing_dev_info = {
+	.name		= "default",
 	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_FLUSH_FORKER,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3ecea98..323da00 100644
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
1.6.3.rc0.1.gf800

