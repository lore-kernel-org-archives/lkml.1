Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZCRNcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZCRNcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbZCRN22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:28:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757847AbZCRN20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:28:26 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/18] GFS2: Clean up of glops.c
Date: Wed, 18 Mar 2009 12:23:53 +0000
Message-Id: <1237379033-28095-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-18-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-10-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-11-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-12-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-13-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-14-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-15-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-16-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-17-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-18-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This cleans up a number of bits of code mostly based in glops.c.
A couple of simple functions have been merged into the callers
to make it more obvious what is going on, the mysterious raising
of i_writecount around the truncate_inode_pages() call has been
removed. The meta_go_* operations have been renamed rgrp_go_*
since that is the only lock type that they are used with.

The unused argument of gfs2_read_sb has been removed. Also
a bug has been fixed where a check for the rindex inode was
in the wrong callback. More comments are added, and the
debugging code is improved too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index f34bc70..bf23a62 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -76,29 +76,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 }
 
 /**
- * gfs2_pte_inval - Sync and invalidate all PTEs associated with a glock
- * @gl: the glock
- *
- */
-
-static void gfs2_pte_inval(struct gfs2_glock *gl)
-{
-	struct gfs2_inode *ip;
-	struct inode *inode;
-
-	ip = gl->gl_object;
-	inode = &ip->i_inode;
-	if (!ip || !S_ISREG(inode->i_mode))
-		return;
-
-	unmap_shared_mapping_range(inode->i_mapping, 0, 0);
-	if (test_bit(GIF_SW_PAGED, &ip->i_flags))
-		set_bit(GLF_DIRTY, &gl->gl_flags);
-
-}
-
-/**
- * meta_go_sync - sync out the metadata for this glock
+ * rgrp_go_sync - sync out the metadata for this glock
  * @gl: the glock
  *
  * Called when demoting or unlocking an EX glock.  We must flush
@@ -106,36 +84,42 @@ static void gfs2_pte_inval(struct gfs2_glock *gl)
  * not return to caller to demote/unlock the glock until I/O is complete.
  */
 
-static void meta_go_sync(struct gfs2_glock *gl)
+static void rgrp_go_sync(struct gfs2_glock *gl)
 {
-	if (gl->gl_state != LM_ST_EXCLUSIVE)
+	struct address_space *metamapping = gl->gl_aspace->i_mapping;
+	int error;
+
+	if (!test_and_clear_bit(GLF_DIRTY, &gl->gl_flags))
 		return;
+	BUG_ON(gl->gl_state != LM_ST_EXCLUSIVE);
 
-	if (test_and_clear_bit(GLF_DIRTY, &gl->gl_flags)) {
-		gfs2_log_flush(gl->gl_sbd, gl);
-		gfs2_meta_sync(gl);
-		gfs2_ail_empty_gl(gl);
-	}
+	gfs2_log_flush(gl->gl_sbd, gl);
+	filemap_fdatawrite(metamapping);
+	error = filemap_fdatawait(metamapping);
+        mapping_set_error(metamapping, error);
+	gfs2_ail_empty_gl(gl);
 }
 
 /**
- * meta_go_inval - invalidate the metadata for this glock
+ * rgrp_go_inval - invalidate the metadata for this glock
  * @gl: the glock
  * @flags:
  *
+ * We never used LM_ST_DEFERRED with resource groups, so that we
+ * should always see the metadata flag set here.
+ *
  */
 
-static void meta_go_inval(struct gfs2_glock *gl, int flags)
+static void rgrp_go_inval(struct gfs2_glock *gl, int flags)
 {
-	if (!(flags & DIO_METADATA))
-		return;
+	struct address_space *mapping = gl->gl_aspace->i_mapping;
 
-	gfs2_meta_inval(gl);
-	if (gl->gl_object == GFS2_I(gl->gl_sbd->sd_rindex))
-		gl->gl_sbd->sd_rindex_uptodate = 0;
-	else if (gl->gl_ops == &gfs2_rgrp_glops && gl->gl_object) {
-		struct gfs2_rgrpd *rgd = (struct gfs2_rgrpd *)gl->gl_object;
+	BUG_ON(!(flags & DIO_METADATA));
+	gfs2_assert_withdraw(gl->gl_sbd, !atomic_read(&gl->gl_ail_count));
+	truncate_inode_pages(mapping, 0);
 
+	if (gl->gl_object) {
+		struct gfs2_rgrpd *rgd = (struct gfs2_rgrpd *)gl->gl_object;
 		rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
 	}
 }
@@ -152,48 +136,54 @@ static void inode_go_sync(struct gfs2_glock *gl)
 	struct address_space *metamapping = gl->gl_aspace->i_mapping;
 	int error;
 
-	if (gl->gl_state != LM_ST_UNLOCKED)
-		gfs2_pte_inval(gl);
-	if (gl->gl_state != LM_ST_EXCLUSIVE)
-		return;
-
 	if (ip && !S_ISREG(ip->i_inode.i_mode))
 		ip = NULL;
+	if (ip && test_and_clear_bit(GIF_SW_PAGED, &ip->i_flags))
+		unmap_shared_mapping_range(ip->i_inode.i_mapping, 0, 0);
+	if (!test_and_clear_bit(GLF_DIRTY, &gl->gl_flags))
+		return;
 
-	if (test_bit(GLF_DIRTY, &gl->gl_flags)) {
-		gfs2_log_flush(gl->gl_sbd, gl);
-		filemap_fdatawrite(metamapping);
-		if (ip) {
-			struct address_space *mapping = ip->i_inode.i_mapping;
-			filemap_fdatawrite(mapping);
-			error = filemap_fdatawait(mapping);
-			mapping_set_error(mapping, error);
-		}
-		error = filemap_fdatawait(metamapping);
-		mapping_set_error(metamapping, error);
-		clear_bit(GLF_DIRTY, &gl->gl_flags);
-		gfs2_ail_empty_gl(gl);
+	BUG_ON(gl->gl_state != LM_ST_EXCLUSIVE);
+
+	gfs2_log_flush(gl->gl_sbd, gl);
+	filemap_fdatawrite(metamapping);
+	if (ip) {
+		struct address_space *mapping = ip->i_inode.i_mapping;
+		filemap_fdatawrite(mapping);
+		error = filemap_fdatawait(mapping);
+		mapping_set_error(mapping, error);
 	}
+	error = filemap_fdatawait(metamapping);
+	mapping_set_error(metamapping, error);
+	gfs2_ail_empty_gl(gl);
 }
 
 /**
  * inode_go_inval - prepare a inode glock to be released
  * @gl: the glock
  * @flags:
+ * 
+ * Normally we invlidate everything, but if we are moving into
+ * LM_ST_DEFERRED from LM_ST_SHARED or LM_ST_EXCLUSIVE then we
+ * can keep hold of the metadata, since it won't have changed.
  *
  */
 
 static void inode_go_inval(struct gfs2_glock *gl, int flags)
 {
 	struct gfs2_inode *ip = gl->gl_object;
-	int meta = (flags & DIO_METADATA);
 
-	if (meta) {
-		gfs2_meta_inval(gl);
+	gfs2_assert_withdraw(gl->gl_sbd, !atomic_read(&gl->gl_ail_count));
+
+	if (flags & DIO_METADATA) {
+		struct address_space *mapping = gl->gl_aspace->i_mapping;
+		truncate_inode_pages(mapping, 0);
 		if (ip)
 			set_bit(GIF_INVALID, &ip->i_flags);
 	}
 
+	if (ip == GFS2_I(gl->gl_sbd->sd_rindex))
+		gl->gl_sbd->sd_rindex_uptodate = 0;
 	if (ip && S_ISREG(ip->i_inode.i_mode))
 		truncate_inode_pages(ip->i_inode.i_mapping, 0);
 }
@@ -395,7 +385,6 @@ static int trans_go_demote_ok(const struct gfs2_glock *gl)
 }
 
 const struct gfs2_glock_operations gfs2_meta_glops = {
-	.go_xmote_th = meta_go_sync,
 	.go_type = LM_TYPE_META,
 };
 
@@ -410,8 +399,8 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
-	.go_xmote_th = meta_go_sync,
-	.go_inval = meta_go_inval,
+	.go_xmote_th = rgrp_go_sync,
+	.go_inval = rgrp_go_inval,
 	.go_demote_ok = rgrp_go_demote_ok,
 	.go_lock = rgrp_go_lock,
 	.go_unlock = rgrp_go_unlock,
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 870d65a..8d6f132 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -89,27 +89,6 @@ void gfs2_aspace_put(struct inode *aspace)
 }
 
 /**
- * gfs2_meta_inval - Invalidate all buffers associated with a glock
- * @gl: the glock
- *
- */
-
-void gfs2_meta_inval(struct gfs2_glock *gl)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	struct inode *aspace = gl->gl_aspace;
-	struct address_space *mapping = gl->gl_aspace->i_mapping;
-
-	gfs2_assert_withdraw(sdp, !atomic_read(&gl->gl_ail_count));
-
-	atomic_inc(&aspace->i_writecount);
-	truncate_inode_pages(mapping, 0);
-	atomic_dec(&aspace->i_writecount);
-
-	gfs2_assert_withdraw(sdp, !mapping->nrpages);
-}
-
-/**
  * gfs2_meta_sync - Sync all buffers associated with a glock
  * @gl: The glock
  *
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index b1a5f36..de270c2 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -40,7 +40,6 @@ static inline void gfs2_buffer_copy_tail(struct buffer_head *to_bh,
 struct inode *gfs2_aspace_get(struct gfs2_sbd *sdp);
 void gfs2_aspace_put(struct inode *aspace);
 
-void gfs2_meta_inval(struct gfs2_glock *gl);
 void gfs2_meta_sync(struct gfs2_glock *gl);
 
 struct buffer_head *gfs2_meta_new(struct gfs2_glock *gl, u64 blkno);
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 99d726f..48ec3d5 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -355,7 +355,6 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	if (ret)
 		goto out;
 
-	set_bit(GIF_SW_PAGED, &ip->i_flags);
 	ret = gfs2_write_alloc_required(ip, pos, PAGE_CACHE_SIZE, &alloc_required);
 	if (ret || !alloc_required)
 		goto out_unlock;
@@ -396,6 +395,8 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 			goto out_unlock_page;
 	}
 	ret = gfs2_allocate_page_backing(page);
+	if (!ret)
+		set_bit(GIF_SW_PAGED, &ip->i_flags);
 
 out_unlock_page:
 	unlock_page(page);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 804ca72..51883b3 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -296,15 +296,15 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector)
 	__free_page(page);
 	return 0;
 }
+
 /**
  * gfs2_read_sb - Read super block
  * @sdp: The GFS2 superblock
- * @gl: the glock for the superblock (assumed to be held)
  * @silent: Don't print message if mount fails
  *
  */
 
-static int gfs2_read_sb(struct gfs2_sbd *sdp, struct gfs2_glock *gl, int silent)
+static int gfs2_read_sb(struct gfs2_sbd *sdp, int silent)
 {
 	u32 hash_blocks, ind_blocks, leaf_blocks;
 	u32 tmp_blocks;
@@ -524,7 +524,7 @@ static int init_sb(struct gfs2_sbd *sdp, int silent)
 		return ret;
 	}
 
-	ret = gfs2_read_sb(sdp, sb_gh.gh_gl, silent);
+	ret = gfs2_read_sb(sdp, silent);
 	if (ret) {
 		fs_err(sdp, "can't read superblock: %d\n", ret);
 		goto out;
-- 
1.6.0.3

