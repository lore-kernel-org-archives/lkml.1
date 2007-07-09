Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbXGIQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbXGIQhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbXGIQYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403AbXGIQY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:26 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Robert Peterson <rpeterso@redhat.com>,
       Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Journaled file write/unstuff bug
Date: Mon,  9 Jul 2007 17:02:47 +0100
Message-Id: <11839970711372-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970691406-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Peterson <rpeterso@redhat.com>

This patch is for bugzilla bug 283162, which uncovered a number of
bugs pertaining to writing to files that have the journaled bit on.
These bugs happen most often when writing to the meta_fs because
the files are always journaled.  So operations like gfs2_grow were
particularly vulnerable, although many of the problems could be
recreated with normal files after setting the journaled bit on.
The problems fixed are:

-GFS2 wasn't ever writing unstuffed journaled data blocks to their
 in-place location on disk. Now it does.

-If you unmounted too quickly after doing IO to a journaled file,
 GFS2 was crashing because you would discard a buffer whose bufdata
 was still on the active items list.  GFS2 now deals with this
 gracefully.

-GFS2 was losing track of the bufdata for journaled data blocks,
 and it wasn't getting freed, causing an error when you tried to
 unmount the module.  GFS2 now frees all the bufdata structures.

-There was a memory corruption occurring because GFS2 wrote
 twice as many log entries for journaled buffers.

-It was occasionally trying to write journal headers in buffers
 that weren't currently mapped.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 1fb846f..fbdc0dc 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -83,6 +83,11 @@ static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 
 			gfs2_assert(sdp, bd->bd_ail == ai);
 
+			if (!bh){
+				list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
+                                continue;
+                        }
+
 			if (!buffer_busy(bh)) {
 				if (!buffer_uptodate(bh)) {
 					gfs2_log_unlock(sdp);
@@ -125,6 +130,11 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai, int fl
 					 bd_ail_st_list) {
 		bh = bd->bd_bh;
 
+		if (!bh){
+			list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
+			continue;
+		}
+
 		gfs2_assert(sdp, bd->bd_ail == ai);
 
 		if (buffer_busy(bh)) {
@@ -227,7 +237,10 @@ static void gfs2_ail2_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 		list_del(&bd->bd_ail_st_list);
 		list_del(&bd->bd_ail_gl_list);
 		atomic_dec(&bd->bd_gl->gl_ail_count);
-		brelse(bd->bd_bh);
+		if (bd->bd_bh)
+			brelse(bd->bd_bh);
+		else
+			kmem_cache_free(gfs2_bufdata_cachep, bd);
 	}
 }
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 3e971f2..df6bcee 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -607,7 +607,8 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 				if (unlikely(magic != 0))
 					set_buffer_escaped(bh1);
 				gfs2_log_lock(sdp);
-				if (n++ > num)
+				n += 2;
+				if (n >= num)
 					break;
 			} else if (!bh1) {
 				total_dbuf--;
@@ -624,6 +625,7 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 		gfs2_log_unlock(sdp);
 		if (bh) {
+			set_buffer_mapped(bh);
 			set_buffer_dirty(bh);
 			ll_rw_block(WRITE, 1, &bh);
 			bh = NULL;
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index ac56595..9ab35a9 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -137,7 +137,9 @@ static int gfs2_writepage(struct page *page, struct writeback_control *wbc)
 		return 0; /* don't care */
 	}
 
-	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip)) {
+	if ((sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip)) &&
+	    PageChecked(page)) {
+		ClearPageChecked(page);
 		error = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
 		if (error)
 			goto out_ignore;
@@ -574,6 +576,23 @@ fail_nounlock:
 }
 
 /**
+ * gfs2_set_page_dirty - Page dirtying function
+ * @page: The page to dirty
+ *
+ * Returns: 1 if it dirtyed the page, or 0 otherwise
+ */
+ 
+static int gfs2_set_page_dirty(struct page *page)
+{
+	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
+	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
+
+	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
+		SetPageChecked(page);
+	return __set_page_dirty_buffers(page);
+}
+
+/**
  * gfs2_bmap - Block map function
  * @mapping: Address space info
  * @lblock: The block to map
@@ -609,6 +628,8 @@ static void discard_buffer(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	if (bd) {
 		bd->bd_bh = NULL;
 		bh->b_private = NULL;
+		if (!bd->bd_ail && list_empty(&bd->bd_le.le_list))
+			kmem_cache_free(gfs2_bufdata_cachep, bd);
 	}
 	gfs2_log_unlock(sdp);
 
@@ -629,6 +650,8 @@ static void gfs2_invalidatepage(struct page *page, unsigned long offset)
 	unsigned int curr_off = 0;
 
 	BUG_ON(!PageLocked(page));
+	if (offset == 0)
+		ClearPageChecked(page);
 	if (!page_has_buffers(page))
 		return;
 
@@ -841,6 +864,7 @@ const struct address_space_operations gfs2_file_aops = {
 	.sync_page = block_sync_page,
 	.prepare_write = gfs2_prepare_write,
 	.commit_write = gfs2_commit_write,
+	.set_page_dirty = gfs2_set_page_dirty,
 	.bmap = gfs2_bmap,
 	.invalidatepage = gfs2_invalidatepage,
 	.releasepage = gfs2_releasepage,
-- 
1.5.1.2

