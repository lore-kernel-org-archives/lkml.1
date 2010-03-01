Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab0CAPTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:19:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab0CAPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:17:54 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/5] GFS2: Metadata address space clean up
Date: Mon,  1 Mar 2010 15:08:22 +0000
Message-Id: <1267456106-3084-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1267456106-3084-1-git-send-email-swhiteho@redhat.com>
References: <1267456106-3084-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the start of GFS2, an "extra" inode has been used to store
the metadata belonging to each inode. The only reason for using
this inode was to have an extra address space, the other fields
were unused. This means that the memory usage was rather inefficient.

The reason for keeping each inode's metadata in a separate address
space is that when glocks are requested on remote nodes, we need to
be able to efficiently locate the data and metadata which relating
to that glock (inode) in order to sync or sync and invalidate it
(depending on the remotely requested lock mode).

This patch adds a new type of glock, which has in addition to
its normal fields, has an address space. This applies to all
inode and rgrp glocks (but to no other glock types which remain
as before). As a result, we no longer need to have the second
inode.

This results in three major improvements:
 1. A saving of approx 25% of memory used in caching inodes
 2. A removal of the circular dependency between inodes and glocks
 3. No confusion between "normal" and "metadata" inodes in super.c

Although the first of these is the more immediately apparent, the
second is just as important as it now enables a number of clean
ups at umount time. Those will be the subject of future patches.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/aops.c     |    4 ++--
 fs/gfs2/glock.c    |   40 +++++++++++++++++++++-------------------
 fs/gfs2/glock.h    |    7 +++++++
 fs/gfs2/glops.c    |   16 +++++++++-------
 fs/gfs2/incore.h   |    4 ++--
 fs/gfs2/inode.c    |    6 ++----
 fs/gfs2/lock_dlm.c |    5 ++++-
 fs/gfs2/main.c     |   28 ++++++++++++++++++++++++++++
 fs/gfs2/meta_io.c  |   46 ++++++----------------------------------------
 fs/gfs2/meta_io.h  |   12 ++++++++++--
 fs/gfs2/super.c    |   26 ++++++++------------------
 fs/gfs2/util.c     |    1 +
 fs/gfs2/util.h     |    1 +
 13 files changed, 101 insertions(+), 95 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 7b8da94..0c1d0b8 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1061,8 +1061,8 @@ out:
 
 int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 {
-	struct inode *aspace = page->mapping->host;
-	struct gfs2_sbd *sdp = aspace->i_sb->s_fs_info;
+	struct address_space *mapping = page->mapping;
+	struct gfs2_sbd *sdp = gfs2_mapping2sbd(mapping);
 	struct buffer_head *bh, *head;
 	struct gfs2_bufdata *bd;
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f426633..dfb10a4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -154,12 +154,14 @@ static unsigned int gl_hash(const struct gfs2_sbd *sdp,
 static void glock_free(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-	struct inode *aspace = gl->gl_aspace;
+	struct address_space *mapping = gfs2_glock2aspace(gl);
+	struct kmem_cache *cachep = gfs2_glock_cachep;
 
-	if (aspace)
-		gfs2_aspace_put(aspace);
+	GLOCK_BUG_ON(gl, mapping && mapping->nrpages);
 	trace_gfs2_glock_put(gl);
-	sdp->sd_lockstruct.ls_ops->lm_put_lock(gfs2_glock_cachep, gl);
+	if (mapping)
+		cachep = gfs2_glock_aspace_cachep;
+	sdp->sd_lockstruct.ls_ops->lm_put_lock(cachep, gl);
 }
 
 /**
@@ -750,10 +752,11 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		   const struct gfs2_glock_operations *glops, int create,
 		   struct gfs2_glock **glp)
 {
+	struct super_block *s = sdp->sd_vfs;
 	struct lm_lockname name = { .ln_number = number, .ln_type = glops->go_type };
 	struct gfs2_glock *gl, *tmp;
 	unsigned int hash = gl_hash(sdp, &name);
-	int error;
+	struct address_space *mapping;
 
 	read_lock(gl_lock_addr(hash));
 	gl = search_bucket(hash, sdp, &name);
@@ -765,7 +768,10 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	if (!create)
 		return -ENOENT;
 
-	gl = kmem_cache_alloc(gfs2_glock_cachep, GFP_KERNEL);
+	if (glops->go_flags & GLOF_ASPACE)
+		gl = kmem_cache_alloc(gfs2_glock_aspace_cachep, GFP_KERNEL);
+	else
+		gl = kmem_cache_alloc(gfs2_glock_cachep, GFP_KERNEL);
 	if (!gl)
 		return -ENOMEM;
 
@@ -784,18 +790,18 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
 	gl->gl_sbd = sdp;
-	gl->gl_aspace = NULL;
 	INIT_DELAYED_WORK(&gl->gl_work, glock_work_func);
 	INIT_WORK(&gl->gl_delete, delete_work_func);
 
-	/* If this glock protects actual on-disk data or metadata blocks,
-	   create a VFS inode to manage the pages/buffers holding them. */
-	if (glops == &gfs2_inode_glops || glops == &gfs2_rgrp_glops) {
-		gl->gl_aspace = gfs2_aspace_get(sdp);
-		if (!gl->gl_aspace) {
-			error = -ENOMEM;
-			goto fail;
-		}
+	mapping = gfs2_glock2aspace(gl);
+	if (mapping) {
+                mapping->a_ops = &gfs2_meta_aops;
+		mapping->host = s->s_bdev->bd_inode;
+		mapping->flags = 0;
+		mapping_set_gfp_mask(mapping, GFP_NOFS);
+		mapping->assoc_mapping = NULL;
+		mapping->backing_dev_info = s->s_bdi;
+		mapping->writeback_index = 0;
 	}
 
 	write_lock(gl_lock_addr(hash));
@@ -812,10 +818,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	*glp = gl;
 
 	return 0;
-
-fail:
-	kmem_cache_free(gfs2_glock_cachep, gl);
-	return error;
 }
 
 /**
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index c0262fa..2bda191 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -180,6 +180,13 @@ static inline int gfs2_glock_is_held_shrd(struct gfs2_glock *gl)
 	return gl->gl_state == LM_ST_SHARED;
 }
 
+static inline struct address_space *gfs2_glock2aspace(struct gfs2_glock *gl)
+{
+	if (gl->gl_ops->go_flags & GLOF_ASPACE)
+		return (struct address_space *)(gl + 1);
+	return NULL;
+}
+
 int gfs2_glock_get(struct gfs2_sbd *sdp,
 		   u64 number, const struct gfs2_glock_operations *glops,
 		   int create, struct gfs2_glock **glp);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 78554ac..38e3749 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -87,7 +87,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 
 static void rgrp_go_sync(struct gfs2_glock *gl)
 {
-	struct address_space *metamapping = gl->gl_aspace->i_mapping;
+	struct address_space *metamapping = gfs2_glock2aspace(gl);
 	int error;
 
 	if (!test_and_clear_bit(GLF_DIRTY, &gl->gl_flags))
@@ -113,7 +113,7 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
 
 static void rgrp_go_inval(struct gfs2_glock *gl, int flags)
 {
-	struct address_space *mapping = gl->gl_aspace->i_mapping;
+	struct address_space *mapping = gfs2_glock2aspace(gl);
 
 	BUG_ON(!(flags & DIO_METADATA));
 	gfs2_assert_withdraw(gl->gl_sbd, !atomic_read(&gl->gl_ail_count));
@@ -134,7 +134,7 @@ static void rgrp_go_inval(struct gfs2_glock *gl, int flags)
 static void inode_go_sync(struct gfs2_glock *gl)
 {
 	struct gfs2_inode *ip = gl->gl_object;
-	struct address_space *metamapping = gl->gl_aspace->i_mapping;
+	struct address_space *metamapping = gfs2_glock2aspace(gl);
 	int error;
 
 	if (ip && !S_ISREG(ip->i_inode.i_mode))
@@ -183,7 +183,7 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
 	gfs2_assert_withdraw(gl->gl_sbd, !atomic_read(&gl->gl_ail_count));
 
 	if (flags & DIO_METADATA) {
-		struct address_space *mapping = gl->gl_aspace->i_mapping;
+		struct address_space *mapping = gfs2_glock2aspace(gl);
 		truncate_inode_pages(mapping, 0);
 		if (ip) {
 			set_bit(GIF_INVALID, &ip->i_flags);
@@ -282,7 +282,8 @@ static int inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 
 static int rgrp_go_demote_ok(const struct gfs2_glock *gl)
 {
-	return !gl->gl_aspace->i_mapping->nrpages;
+	const struct address_space *mapping = (const struct address_space *)(gl + 1);
+	return !mapping->nrpages;
 }
 
 /**
@@ -387,8 +388,7 @@ static void iopen_go_callback(struct gfs2_glock *gl)
 	struct gfs2_inode *ip = (struct gfs2_inode *)gl->gl_object;
 
 	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
-	    gl->gl_state == LM_ST_SHARED &&
-	    ip && test_bit(GIF_USER, &ip->i_flags)) {
+	    gl->gl_state == LM_ST_SHARED && ip) {
 		gfs2_glock_hold(gl);
 		if (queue_work(gfs2_delete_workqueue, &gl->gl_delete) == 0)
 			gfs2_glock_put_nolock(gl);
@@ -407,6 +407,7 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 	.go_dump = inode_go_dump,
 	.go_type = LM_TYPE_INODE,
 	.go_min_hold_time = HZ / 5,
+	.go_flags = GLOF_ASPACE,
 };
 
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
@@ -418,6 +419,7 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_dump = gfs2_rgrp_dump,
 	.go_type = LM_TYPE_RGRP,
 	.go_min_hold_time = HZ / 5,
+	.go_flags = GLOF_ASPACE,
 };
 
 const struct gfs2_glock_operations gfs2_trans_glops = {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index bc0ad15..1de7e1b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -162,6 +162,8 @@ struct gfs2_glock_operations {
 	void (*go_callback) (struct gfs2_glock *gl);
 	const int go_type;
 	const unsigned long go_min_hold_time;
+	const unsigned long go_flags;
+#define GLOF_ASPACE 1
 };
 
 enum {
@@ -225,7 +227,6 @@ struct gfs2_glock {
 
 	struct gfs2_sbd *gl_sbd;
 
-	struct inode *gl_aspace;
 	struct list_head gl_ail_list;
 	atomic_t gl_ail_count;
 	struct delayed_work gl_work;
@@ -258,7 +259,6 @@ enum {
 	GIF_INVALID		= 0,
 	GIF_QD_LOCKED		= 1,
 	GIF_SW_PAGED		= 3,
-	GIF_USER                = 4, /* user inode, not metadata addr space */
 };
 
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 6e220f4..b1bf269 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -45,7 +45,7 @@ static int iget_test(struct inode *inode, void *opaque)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	u64 *no_addr = opaque;
 
-	if (ip->i_no_addr == *no_addr && test_bit(GIF_USER, &ip->i_flags))
+	if (ip->i_no_addr == *no_addr)
 		return 1;
 
 	return 0;
@@ -58,7 +58,6 @@ static int iget_set(struct inode *inode, void *opaque)
 
 	inode->i_ino = (unsigned long)*no_addr;
 	ip->i_no_addr = *no_addr;
-	set_bit(GIF_USER, &ip->i_flags);
 	return 0;
 }
 
@@ -84,7 +83,7 @@ static int iget_skip_test(struct inode *inode, void *opaque)
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_skip_data *data = opaque;
 
-	if (ip->i_no_addr == data->no_addr && test_bit(GIF_USER, &ip->i_flags)){
+	if (ip->i_no_addr == data->no_addr) {
 		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE)){
 			data->skipped = 1;
 			return 0;
@@ -103,7 +102,6 @@ static int iget_skip_set(struct inode *inode, void *opaque)
 		return 1;
 	inode->i_ino = (unsigned long)(data->no_addr);
 	ip->i_no_addr = data->no_addr;
-	set_bit(GIF_USER, &ip->i_flags);
 	return 0;
 }
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 0e5e0e7..569b462 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -30,7 +30,10 @@ static void gdlm_ast(void *arg)
 
 	switch (gl->gl_lksb.sb_status) {
 	case -DLM_EUNLOCK: /* Unlocked, so glock can be freed */
-		kmem_cache_free(gfs2_glock_cachep, gl);
+		if (gl->gl_ops->go_flags & GLOF_ASPACE)
+			kmem_cache_free(gfs2_glock_aspace_cachep, gl);
+		else
+			kmem_cache_free(gfs2_glock_cachep, gl);
 		if (atomic_dec_and_test(&sdp->sd_glock_disposal))
 			wake_up(&sdp->sd_glock_wait);
 		return;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 5b31f77..a88fadc 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -52,6 +52,22 @@ static void gfs2_init_glock_once(void *foo)
 	atomic_set(&gl->gl_ail_count, 0);
 }
 
+static void gfs2_init_gl_aspace_once(void *foo)
+{
+	struct gfs2_glock *gl = foo;
+	struct address_space *mapping = (struct address_space *)(gl + 1);
+
+	gfs2_init_glock_once(gl);
+	memset(mapping, 0, sizeof(*mapping));
+	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
+	spin_lock_init(&mapping->tree_lock);
+	spin_lock_init(&mapping->i_mmap_lock);
+	INIT_LIST_HEAD(&mapping->private_list);
+	spin_lock_init(&mapping->private_lock);
+	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
+	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
+}
+
 /**
  * init_gfs2_fs - Register GFS2 as a filesystem
  *
@@ -78,6 +94,14 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_glock_cachep)
 		goto fail;
 
+	gfs2_glock_aspace_cachep = kmem_cache_create("gfs2_glock (aspace)",
+					sizeof(struct gfs2_glock) +
+					sizeof(struct address_space),
+					0, 0, gfs2_init_gl_aspace_once);
+
+	if (!gfs2_glock_aspace_cachep)
+		goto fail;
+
 	gfs2_inode_cachep = kmem_cache_create("gfs2_inode",
 					      sizeof(struct gfs2_inode),
 					      0,  SLAB_RECLAIM_ACCOUNT|
@@ -144,6 +168,9 @@ fail:
 	if (gfs2_inode_cachep)
 		kmem_cache_destroy(gfs2_inode_cachep);
 
+	if (gfs2_glock_aspace_cachep)
+		kmem_cache_destroy(gfs2_glock_aspace_cachep);
+
 	if (gfs2_glock_cachep)
 		kmem_cache_destroy(gfs2_glock_cachep);
 
@@ -169,6 +196,7 @@ static void __exit exit_gfs2_fs(void)
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
 	kmem_cache_destroy(gfs2_bufdata_cachep);
 	kmem_cache_destroy(gfs2_inode_cachep);
+	kmem_cache_destroy(gfs2_glock_aspace_cachep);
 	kmem_cache_destroy(gfs2_glock_cachep);
 
 	gfs2_sys_uninit();
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 6f68a5f..0bb12c8 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -93,49 +93,13 @@ static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wb
 	return err;
 }
 
-static const struct address_space_operations aspace_aops = {
+const struct address_space_operations gfs2_meta_aops = {
 	.writepage = gfs2_aspace_writepage,
 	.releasepage = gfs2_releasepage,
 	.sync_page = block_sync_page,
 };
 
 /**
- * gfs2_aspace_get - Create and initialize a struct inode structure
- * @sdp: the filesystem the aspace is in
- *
- * Right now a struct inode is just a struct inode.  Maybe Linux
- * will supply a more lightweight address space construct (that works)
- * in the future.
- *
- * Make sure pages/buffers in this aspace aren't in high memory.
- *
- * Returns: the aspace
- */
-
-struct inode *gfs2_aspace_get(struct gfs2_sbd *sdp)
-{
-	struct inode *aspace;
-	struct gfs2_inode *ip;
-
-	aspace = new_inode(sdp->sd_vfs);
-	if (aspace) {
-		mapping_set_gfp_mask(aspace->i_mapping, GFP_NOFS);
-		aspace->i_mapping->a_ops = &aspace_aops;
-		aspace->i_size = MAX_LFS_FILESIZE;
-		ip = GFS2_I(aspace);
-		clear_bit(GIF_USER, &ip->i_flags);
-		insert_inode_hash(aspace);
-	}
-	return aspace;
-}
-
-void gfs2_aspace_put(struct inode *aspace)
-{
-	remove_inode_hash(aspace);
-	iput(aspace);
-}
-
-/**
  * gfs2_meta_sync - Sync all buffers associated with a glock
  * @gl: The glock
  *
@@ -143,7 +107,7 @@ void gfs2_aspace_put(struct inode *aspace)
 
 void gfs2_meta_sync(struct gfs2_glock *gl)
 {
-	struct address_space *mapping = gl->gl_aspace->i_mapping;
+	struct address_space *mapping = gfs2_glock2aspace(gl);
 	int error;
 
 	filemap_fdatawrite(mapping);
@@ -164,7 +128,7 @@ void gfs2_meta_sync(struct gfs2_glock *gl)
 
 struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno, int create)
 {
-	struct address_space *mapping = gl->gl_aspace->i_mapping;
+	struct address_space *mapping = gfs2_glock2aspace(gl);
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct page *page;
 	struct buffer_head *bh;
@@ -344,8 +308,10 @@ void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 
 void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int meta)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(bh->b_page->mapping->host);
+	struct address_space *mapping = bh->b_page->mapping;
+	struct gfs2_sbd *sdp = gfs2_mapping2sbd(mapping);
 	struct gfs2_bufdata *bd = bh->b_private;
+
 	if (test_clear_buffer_pinned(bh)) {
 		list_del_init(&bd->bd_le.le_list);
 		if (meta) {
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index de270c2..6a1d9ba 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -37,8 +37,16 @@ static inline void gfs2_buffer_copy_tail(struct buffer_head *to_bh,
 	       0, from_head - to_head);
 }
 
-struct inode *gfs2_aspace_get(struct gfs2_sbd *sdp);
-void gfs2_aspace_put(struct inode *aspace);
+extern const struct address_space_operations gfs2_meta_aops;
+
+static inline struct gfs2_sbd *gfs2_mapping2sbd(struct address_space *mapping)
+{
+	struct inode *inode = mapping->host;
+	if (mapping->a_ops == &gfs2_meta_aops)
+		return (((struct gfs2_glock *)mapping) - 1)->gl_sbd;
+	else
+		return inode->i_sb->s_fs_info;
+}
 
 void gfs2_meta_sync(struct gfs2_glock *gl);
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b9dd3da..ad7bc2d 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -722,8 +722,7 @@ static int gfs2_write_inode(struct inode *inode, int sync)
 	int ret = 0;
 
 	/* Check this is a "normal" inode, etc */
-	if (!test_bit(GIF_USER, &ip->i_flags) ||
-	    (current->flags & PF_MEMALLOC))
+	if (current->flags & PF_MEMALLOC)
 		return 0;
 	ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	if (ret)
@@ -1194,7 +1193,7 @@ static void gfs2_drop_inode(struct inode *inode)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 
-	if (test_bit(GIF_USER, &ip->i_flags) && inode->i_nlink) {
+	if (inode->i_nlink) {
 		struct gfs2_glock *gl = ip->i_iopen_gh.gh_gl;
 		if (gl && test_bit(GLF_DEMOTE, &gl->gl_flags))
 			clear_nlink(inode);
@@ -1212,18 +1211,12 @@ static void gfs2_clear_inode(struct inode *inode)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 
-	/* This tells us its a "real" inode and not one which only
-	 * serves to contain an address space (see rgrp.c, meta_io.c)
-	 * which therefore doesn't have its own glocks.
-	 */
-	if (test_bit(GIF_USER, &ip->i_flags)) {
-		ip->i_gl->gl_object = NULL;
-		gfs2_glock_put(ip->i_gl);
-		ip->i_gl = NULL;
-		if (ip->i_iopen_gh.gh_gl) {
-			ip->i_iopen_gh.gh_gl->gl_object = NULL;
-			gfs2_glock_dq_uninit(&ip->i_iopen_gh);
-		}
+	ip->i_gl->gl_object = NULL;
+	gfs2_glock_put(ip->i_gl);
+	ip->i_gl = NULL;
+	if (ip->i_iopen_gh.gh_gl) {
+		ip->i_iopen_gh.gh_gl->gl_object = NULL;
+		gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 	}
 }
 
@@ -1358,9 +1351,6 @@ static void gfs2_delete_inode(struct inode *inode)
 	struct gfs2_holder gh;
 	int error;
 
-	if (!test_bit(GIF_USER, &ip->i_flags))
-		goto out;
-
 	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	if (unlikely(error)) {
 		gfs2_glock_dq_uninit(&ip->i_iopen_gh);
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index f6a7efa..226f2bf 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -21,6 +21,7 @@
 #include "util.h"
 
 struct kmem_cache *gfs2_glock_cachep __read_mostly;
+struct kmem_cache *gfs2_glock_aspace_cachep __read_mostly;
 struct kmem_cache *gfs2_inode_cachep __read_mostly;
 struct kmem_cache *gfs2_bufdata_cachep __read_mostly;
 struct kmem_cache *gfs2_rgrpd_cachep __read_mostly;
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 33e96b0..b432e04 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -145,6 +145,7 @@ gfs2_io_error_bh_i((sdp), (bh), __func__, __FILE__, __LINE__);
 
 
 extern struct kmem_cache *gfs2_glock_cachep;
+extern struct kmem_cache *gfs2_glock_aspace_cachep;
 extern struct kmem_cache *gfs2_inode_cachep;
 extern struct kmem_cache *gfs2_bufdata_cachep;
 extern struct kmem_cache *gfs2_rgrpd_cachep;
-- 
1.6.2.5

