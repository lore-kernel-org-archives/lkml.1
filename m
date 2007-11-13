Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbXKMKMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbXKMKMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXKMKLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:11:00 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50693 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbXKMKKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:10:53 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 8/9] Unionfs: fold do_readpage into unionfs_readpage
Date: Tue, 13 Nov 2007 05:10:27 -0500
Message-Id: <11949486313260-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
References: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code and reduce stack pressure a bit.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |   44 ++++++++++++++------------------------------
 1 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 34fd8aa..ef8822f 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -136,22 +136,22 @@ out:
 	return err;
 }
 
-/*
- * readpage is called from generic_page_read and the fault handler.
- * If your file system uses generic_page_read for the read op, it
- * must implement readpage.
- *
- * Readpage expects a locked page, and must unlock it.
- */
-static int unionfs_do_readpage(struct file *file, struct page *page)
+/* Readpage expects a locked page, and must unlock it */
+static int unionfs_readpage(struct file *file, struct page *page)
 {
-	int err = -EIO;
+	int err;
 	struct file *lower_file;
 	struct inode *inode;
 	mm_segment_t old_fs;
 	char *page_data = NULL;
 	loff_t offset;
 
+	unionfs_read_lock(file->f_path.dentry->d_sb);
+	err = unionfs_file_revalidate(file, false);
+	if (unlikely(err))
+		goto out;
+	unionfs_check_file(file);
+
 	if (!UNIONFS_F(file)) {
 		err = -ENOENT;
 		goto out;
@@ -191,33 +191,17 @@ static int unionfs_do_readpage(struct file *file, struct page *page)
 
 	flush_dcache_page(page);
 
-out:
-	if (err == 0)
-		SetPageUptodate(page);
-	else
-		ClearPageUptodate(page);
-
-	return err;
-}
-
-static int unionfs_readpage(struct file *file, struct page *page)
-{
-	int err;
-
-	unionfs_read_lock(file->f_path.dentry->d_sb);
-	err = unionfs_file_revalidate(file, false);
-	if (unlikely(err))
-		goto out;
-	unionfs_check_file(file);
-
-	err = unionfs_do_readpage(file, page);
-
 	/*
 	 * we have to unlock our page, b/c we _might_ have gotten a locked
 	 * page.  but we no longer have to wakeup on our page here, b/c
 	 * UnlockPage does it
 	 */
 out:
+	if (err == 0)
+		SetPageUptodate(page);
+	else
+		ClearPageUptodate(page);
+
 	unlock_page(page);
 	unionfs_check_file(file);
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
-- 
1.5.2.2

