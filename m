Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbYAUKFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbYAUKFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759412AbYAUKCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252AbYAUKCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:04 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/58] [GFS2] Split gfs2_writepage into three cases
Date: Mon, 21 Jan 2008 09:21:26 +0000
Message-Id: <1200907356883-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073542596-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
Message-Id: <ec596658f8ed9596efa3d0b406a3d5c47da7ff58.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch splits gfs2_writepage into separate functions for each of
the three cases: writeback, ordered and journalled. As a result
it becomes a lot easier to see what each one is doing. The common
code is moved into gfs2_writepage_common.

This fixes a performance bug where we were doing more work than
strictly required in the ordered write case.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 6c27cea..e901f8f 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -556,17 +556,20 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 
 	lock_buffer(bd->bd_bh);
 	gfs2_log_lock(sdp);
-	if (!list_empty(&bd->bd_list_tr))
-		goto out;
-	tr->tr_touched = 1;
-	if (gfs2_is_jdata(ip)) {
-		tr->tr_num_buf++;
-		list_add(&bd->bd_list_tr, &tr->tr_list_buf);
+	if (tr) {
+		if (!list_empty(&bd->bd_list_tr))
+			goto out;
+		tr->tr_touched = 1;
+		if (gfs2_is_jdata(ip)) {
+			tr->tr_num_buf++;
+			list_add(&bd->bd_list_tr, &tr->tr_list_buf);
+		}
 	}
 	if (!list_empty(&le->le_list))
 		goto out;
 
-	__glock_lo_add(sdp, &bd->bd_gl->gl_le);
+	if (tr)
+		__glock_lo_add(sdp, &bd->bd_gl->gl_le);
 	if (gfs2_is_jdata(ip)) {
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 207014f..4bf73ed 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -103,16 +103,15 @@ static int gfs2_get_block_direct(struct inode *inode, sector_t lblock,
 }
 
 /**
- * gfs2_writepage - Write complete page
- * @page: Page to write
- *
- * Returns: errno
+ * gfs2_writepage_common - Common bits of writepage
+ * @page: The page to be written
+ * @wbc: The writeback control
  *
- * Some of this is copied from block_write_full_page() although we still
- * call it to do most of the work.
+ * Returns: 1 if writepage is ok, otherwise an error code or zero if no error.
  */
 
-static int gfs2_writepage(struct page *page, struct writeback_control *wbc)
+static int gfs2_writepage_common(struct page *page,
+				 struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -120,23 +119,94 @@ static int gfs2_writepage(struct page *page, struct writeback_control *wbc)
 	loff_t i_size = i_size_read(inode);
 	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	int error;
-	int done_trans = 0;
+	int ret = -EIO;
 
-	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(ip->i_gl))) {
-		unlock_page(page);
-		return -EIO;
-	}
+	if (gfs2_assert_withdraw(sdp, gfs2_glock_is_held_excl(ip->i_gl)))
+		goto out;
+	ret = 0;
 	if (current->journal_info)
-		goto out_ignore;
-
+		goto redirty;
 	/* Is the page fully outside i_size? (truncate in progress) */
-        offset = i_size & (PAGE_CACHE_SIZE-1);
+	offset = i_size & (PAGE_CACHE_SIZE-1);
 	if (page->index > end_index || (page->index == end_index && !offset)) {
 		page->mapping->a_ops->invalidatepage(page, 0);
-		unlock_page(page);
-		return 0; /* don't care */
+		goto out;
 	}
+	return 1;
+redirty:
+	redirty_page_for_writepage(wbc, page);
+out:
+	unlock_page(page);
+	return 0;
+}
+
+/**
+ * gfs2_writeback_writepage - Write page for writeback mappings
+ * @page: The page
+ * @wbc: The writeback control
+ *
+ */
+
+static int gfs2_writeback_writepage(struct page *page,
+				    struct writeback_control *wbc)
+{
+	int ret;
+
+	ret = gfs2_writepage_common(page, wbc);
+	if (ret <= 0)
+		return ret;
+
+	ret = mpage_writepage(page, gfs2_get_block_noalloc, wbc);
+	if (ret == -EAGAIN)
+		ret = block_write_full_page(page, gfs2_get_block_noalloc, wbc);
+	return ret;
+}
+
+/**
+ * gfs2_ordered_writepage - Write page for ordered data files
+ * @page: The page to write
+ * @wbc: The writeback control
+ *
+ */
+
+static int gfs2_ordered_writepage(struct page *page,
+				  struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	int ret;
+
+	ret = gfs2_writepage_common(page, wbc);
+	if (ret <= 0)
+		return ret;
+
+	if (!page_has_buffers(page)) {
+		create_empty_buffers(page, inode->i_sb->s_blocksize,
+				     (1 << BH_Dirty)|(1 << BH_Uptodate));
+	}
+	gfs2_page_add_databufs(ip, page, 0, inode->i_sb->s_blocksize-1);
+	return block_write_full_page(page, gfs2_get_block_noalloc, wbc);
+}
+
+/**
+ * gfs2_jdata_writepage - Write complete page
+ * @page: Page to write
+ *
+ * Returns: errno
+ *
+ */
+
+static int gfs2_jdata_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	int error;
+	int done_trans = 0;
+
+	error = gfs2_writepage_common(page, wbc);
+	if (error <= 0)
+		return error;
 
 	if (PageChecked(page)) {
 		error = gfs2_trans_begin(sdp, RES_DINODE + 1, 0);
@@ -838,7 +908,7 @@ cannot_release:
 }
 
 static const struct address_space_operations gfs2_writeback_aops = {
-	.writepage = gfs2_writepage,
+	.writepage = gfs2_writeback_writepage,
 	.writepages = gfs2_writeback_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
@@ -852,7 +922,7 @@ static const struct address_space_operations gfs2_writeback_aops = {
 };
 
 static const struct address_space_operations gfs2_ordered_aops = {
-	.writepage = gfs2_writepage,
+	.writepage = gfs2_ordered_writepage,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
 	.sync_page = block_sync_page,
@@ -866,7 +936,7 @@ static const struct address_space_operations gfs2_ordered_aops = {
 };
 
 static const struct address_space_operations gfs2_jdata_aops = {
-	.writepage = gfs2_writepage,
+	.writepage = gfs2_jdata_writepage,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
 	.sync_page = block_sync_page,
-- 
1.5.1.2

