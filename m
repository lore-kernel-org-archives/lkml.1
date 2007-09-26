Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbXIZD3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbXIZD3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbXIZD3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:29:34 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35176 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbXIZD3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:29:32 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 19/25] Unionfs: add un/likely conditionals on mmap ops
Date: Tue, 25 Sep 2007 23:09:58 -0400
Message-Id: <11907762123763-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 37af979..1cea075 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -84,7 +84,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	 * resort to RAIF's page pointer flipping trick.)
 	 */
 	lower_page = find_lock_page(lower_inode->i_mapping, page->index);
-	if (!lower_page) {
+	if (unlikely(!lower_page)) {
 		err = AOP_WRITEPAGE_ACTIVATE;
 		set_page_dirty(page);
 		goto out;
@@ -102,7 +102,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	BUG_ON(!lower_inode->i_mapping->a_ops->writepage);
 
 	/* workaround for some lower file systems: see big comment on top */
-	if (wbc->for_writepages && !wbc->fs_private)
+	if (unlikely(wbc->for_writepages && !wbc->fs_private))
 		wbc->for_writepages = 0;
 
 	/* call lower writepage (expects locked page) */
@@ -111,12 +111,12 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	wbc->for_writepages = saved_for_writepages; /* restore value */
 
 	/* b/c find_lock_page locked it and ->writepage unlocks on success */
-	if (err)
+	if (unlikely(err))
 		unlock_page(lower_page);
 	/* b/c grab_cache_page increased refcnt */
 	page_cache_release(lower_page);
 
-	if (err < 0) {
+	if (unlikely(err < 0)) {
 		ClearPageUptodate(page);
 		goto out;
 	}
@@ -160,7 +160,7 @@ static int unionfs_do_readpage(struct file *file, struct page *page)
 	char *page_data = NULL;
 	loff_t offset;
 
-	if (!UNIONFS_F(file)) {
+	if (unlikely(!UNIONFS_F(file))) {
 		err = -ENOENT;
 		goto out;
 	}
@@ -189,7 +189,7 @@ static int unionfs_do_readpage(struct file *file, struct page *page)
 
 	kunmap(page);
 
-	if (err < 0)
+	if (unlikely(err < 0))
 		goto out;
 	err = 0;
 
@@ -199,7 +199,7 @@ static int unionfs_do_readpage(struct file *file, struct page *page)
 	flush_dcache_page(page);
 
 out:
-	if (err == 0)
+	if (likely(err == 0))
 		SetPageUptodate(page);
 	else
 		ClearPageUptodate(page);
@@ -212,13 +212,13 @@ static int unionfs_readpage(struct file *file, struct page *page)
 	int err;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, false)))
+	if (unlikely((err = unionfs_file_revalidate(file, false))))
 		goto out;
 	unionfs_check_file(file);
 
 	err = unionfs_do_readpage(file, page);
 
-	if (!err) {
+	if (likely(!err)) {
 		touch_atime(unionfs_lower_mnt(file->f_path.dentry),
 			    unionfs_lower_dentry(file->f_path.dentry));
 		unionfs_copy_attr_times(file->f_path.dentry->d_inode);
@@ -276,14 +276,14 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	BUG_ON(file == NULL);
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, true)))
+	if (unlikely((err = unionfs_file_revalidate(file, true))))
 		goto out;
 	unionfs_check_file(file);
 
 	inode = page->mapping->host;
 	lower_inode = unionfs_lower_inode(inode);
 
-	if (UNIONFS_F(file) != NULL)
+	if (likely(UNIONFS_F(file) != NULL))
 		lower_file = unionfs_lower_file(file);
 
 	/* FIXME: is this assertion right here? */
@@ -307,7 +307,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 
 	kunmap(page);
 
-	if (err < 0)
+	if (unlikely(err < 0))
 		goto out;
 
 	inode->i_blocks = lower_inode->i_blocks;
@@ -320,7 +320,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	mark_inode_dirty_sync(inode);
 
 out:
-	if (err < 0)
+	if (unlikely(err < 0))
 		ClearPageUptodate(page);
 
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
@@ -347,7 +347,7 @@ static void unionfs_sync_page(struct page *page)
 	 * do is ensure that pending I/O gets done.
 	 */
 	lower_page = find_lock_page(lower_inode->i_mapping, page->index);
-	if (!lower_page) {
+	if (unlikely(!lower_page)) {
 		printk(KERN_DEBUG "unionfs: find_lock_page failed\n");
 		goto out;
 	}
-- 
1.5.2.2

