Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbXJDJZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbXJDJZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759519AbXJDJR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759532AbXJDJRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:55 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 22/51] [GFS2] Clean up invalidatepage/releasepage
Date: Thu,  4 Oct 2007 09:49:15 +0100
Message-Id: <11914878304004-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878283252-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch fixes some bugs relating to journaled data files by cleaning
up the gfs2_invalidatepage() and gfs2_releasepage() functions. We now
never block during gfs2_releasepage(), instead we always either release
or refuse to release depending on the status of the buffers.

This fixes Red Hat bugzillas #248969 and #252392.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 777ca46..88342e0 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -156,9 +156,11 @@ static void inode_go_sync(struct gfs2_glock *gl)
 		ip = NULL;
 
 	if (test_bit(GLF_DIRTY, &gl->gl_flags)) {
-		if (ip)
+		if (ip && !gfs2_is_jdata(ip))
 			filemap_fdatawrite(ip->i_inode.i_mapping);
 		gfs2_log_flush(gl->gl_sbd, gl);
+		if (ip && gfs2_is_jdata(ip))
+			filemap_fdatawrite(ip->i_inode.i_mapping);
 		gfs2_meta_sync(gl);
 		if (ip) {
 			struct address_space *mapping = ip->i_inode.i_mapping;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 00ab6c0..d0e6b42 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -229,8 +229,10 @@ static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 		list_del(&bd->bd_ail_st_list);
 		list_del(&bd->bd_ail_gl_list);
 		atomic_dec(&bd->bd_gl->gl_ail_count);
-		bh_ip = GFS2_I(bd->bd_bh->b_page->mapping->host);
-		gfs2_meta_cache_flush(bh_ip);
+		if (bd->bd_bh->b_page->mapping) {
+			bh_ip = GFS2_I(bd->bd_bh->b_page->mapping->host);
+			gfs2_meta_cache_flush(bh_ip);
+		}
 		brelse(bd->bd_bh);
 	}
 }
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 42a5f58..8407d1d 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -616,58 +616,13 @@ static sector_t gfs2_bmap(struct address_space *mapping, sector_t lblock)
 	return dblock;
 }
 
-static void discard_buffer(struct gfs2_sbd *sdp, struct buffer_head *bh)
-{
-	struct gfs2_bufdata *bd;
-
-	gfs2_log_lock(sdp);
-	bd = bh->b_private;
-	if (bd) {
-		bd->bd_bh = NULL;
-		bh->b_private = NULL;
-		if (!bd->bd_ail && list_empty(&bd->bd_le.le_list))
-			kmem_cache_free(gfs2_bufdata_cachep, bd);
-	}
-	gfs2_log_unlock(sdp);
-
-	lock_buffer(bh);
-	clear_buffer_dirty(bh);
-	bh->b_bdev = NULL;
-	clear_buffer_mapped(bh);
-	clear_buffer_req(bh);
-	clear_buffer_new(bh);
-	clear_buffer_delay(bh);
-	unlock_buffer(bh);
-}
-
 static void gfs2_invalidatepage(struct page *page, unsigned long offset)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
-	struct buffer_head *head, *bh, *next;
-	unsigned int curr_off = 0;
-
 	BUG_ON(!PageLocked(page));
 	if (offset == 0)
 		ClearPageChecked(page);
-	if (!page_has_buffers(page))
-		return;
 
-	bh = head = page_buffers(page);
-	do {
-		unsigned int next_off = curr_off + bh->b_size;
-		next = bh->b_this_page;
-
-		if (offset <= curr_off)
-			discard_buffer(sdp, bh);
-
-		curr_off = next_off;
-		bh = next;
-	} while (bh != head);
-
-	if (!offset)
-		try_to_release_page(page, 0);
-
-	return;
+	block_invalidatepage(page, offset);
 }
 
 /**
@@ -736,59 +691,6 @@ out:
 }
 
 /**
- * stuck_releasepage - We're stuck in gfs2_releasepage().  Print stuff out.
- * @bh: the buffer we're stuck on
- *
- */
-
-static void stuck_releasepage(struct buffer_head *bh)
-{
-	struct inode *inode = bh->b_page->mapping->host;
-	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
-	struct gfs2_bufdata *bd = bh->b_private;
-	struct gfs2_glock *gl;
-static unsigned limit = 0;
-
-	if (limit > 3)
-		return;
-	limit++;
-
-	fs_warn(sdp, "stuck in gfs2_releasepage() %p\n", inode);
-	fs_warn(sdp, "blkno = %llu, bh->b_count = %d\n",
-		(unsigned long long)bh->b_blocknr, atomic_read(&bh->b_count));
-	fs_warn(sdp, "pinned = %u\n", buffer_pinned(bh));
-	fs_warn(sdp, "bh->b_private = %s\n", (bd) ? "!NULL" : "NULL");
-
-	if (!bd)
-		return;
-
-	gl = bd->bd_gl;
-
-	fs_warn(sdp, "gl = (%u, %llu)\n",
-		gl->gl_name.ln_type, (unsigned long long)gl->gl_name.ln_number);
-
-	fs_warn(sdp, "bd_list_tr = %s, bd_le.le_list = %s\n",
-		(list_empty(&bd->bd_list_tr)) ? "no" : "yes",
-		(list_empty(&bd->bd_le.le_list)) ? "no" : "yes");
-
-	if (gl->gl_ops == &gfs2_inode_glops) {
-		struct gfs2_inode *ip = gl->gl_object;
-		unsigned int x;
-
-		if (!ip)
-			return;
-
-		fs_warn(sdp, "ip = %llu %llu\n",
-			(unsigned long long)ip->i_no_formal_ino,
-			(unsigned long long)ip->i_no_addr);
-
-		for (x = 0; x < GFS2_MAX_META_HEIGHT; x++)
-			fs_warn(sdp, "ip->i_cache[%u] = %s\n",
-				x, (ip->i_cache[x]) ? "!NULL" : "NULL");
-	}
-}
-
-/**
  * gfs2_releasepage - free the metadata associated with a page
  * @page: the page that's being released
  * @gfp_mask: passed from Linux VFS, ignored by us
@@ -805,38 +707,31 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 	struct gfs2_sbd *sdp = aspace->i_sb->s_fs_info;
 	struct buffer_head *bh, *head;
 	struct gfs2_bufdata *bd;
-	unsigned long t = jiffies + gfs2_tune_get(sdp, gt_stall_secs) * HZ;
 
 	if (!page_has_buffers(page))
 		goto out;
 
+	gfs2_log_lock(sdp);
 	head = bh = page_buffers(page);
 	do {
-		while (atomic_read(&bh->b_count)) {
-			if (!atomic_read(&aspace->i_writecount))
-				return 0;
-
-			if (!(gfp_mask & __GFP_WAIT))
-				return 0;
-
-			if (time_after_eq(jiffies, t)) {
-				stuck_releasepage(bh);
-				/* should we withdraw here? */
-				return 0;
-			}
-
-			yield();
-		}
-
+		if (atomic_read(&bh->b_count))
+			goto cannot_release;
+		bd = bh->b_private;
+		if (bd && bd->bd_ail)
+			goto cannot_release;
 		gfs2_assert_warn(sdp, !buffer_pinned(bh));
 		gfs2_assert_warn(sdp, !buffer_dirty(bh));
+		bh = bh->b_this_page;
+	} while(bh != head);
+	gfs2_log_unlock(sdp);
 
+	head = bh = page_buffers(page);
+	do {
 		gfs2_log_lock(sdp);
 		bd = bh->b_private;
 		if (bd) {
 			gfs2_assert_warn(sdp, bd->bd_bh == bh);
 			gfs2_assert_warn(sdp, list_empty(&bd->bd_list_tr));
-			gfs2_assert_warn(sdp, !bd->bd_ail);
 			bd->bd_bh = NULL;
 			if (!list_empty(&bd->bd_le.le_list))
 				bd = NULL;
@@ -851,6 +746,9 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 
 out:
 	return try_to_free_buffers(page);
+cannot_release:
+	gfs2_log_unlock(sdp);
+	return 0;
 }
 
 const struct address_space_operations gfs2_file_aops = {
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c1c6672..9e0e9be 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -35,6 +35,7 @@
 #include "super.h"
 #include "sys.h"
 #include "util.h"
+#include "log.h"
 
 #define DO 0
 #define UNDO 1
@@ -887,6 +888,7 @@ error:
 static void gfs2_kill_sb(struct super_block *sb)
 {
 	gfs2_delete_debugfs_file(sb->s_fs_info);
+	gfs2_meta_syncfs(sb->s_fs_info);
 	kill_block_super(sb);
 }
 
-- 
1.5.1.2

