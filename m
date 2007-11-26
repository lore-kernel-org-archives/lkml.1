Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbXKZQqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbXKZQqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbXKZQpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:30 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52779 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXKZQp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:27 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 13/16] Unionfs: support splice(2)
Date: Mon, 26 Nov 2007 11:44:10 -0500
Message-Id: <1196095458112-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove redundant variable from unionfs_readpage (saves a bit on stack
space).

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/file.c |    1 +
 fs/unionfs/mmap.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index cfbfb8e..b7d0d55 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -246,4 +246,5 @@ struct file_operations unionfs_main_fops = {
 	.fsync		= unionfs_fsync,
 	.fasync		= unionfs_fasync,
 	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
 };
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index fa358ef..623a913 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -147,7 +147,7 @@ static int unionfs_readpage(struct file *file, struct page *page)
 	struct inode *inode;
 	mm_segment_t old_fs;
 	char *page_data = NULL;
-	loff_t offset;
+	mode_t orig_mode;
 
 	unionfs_read_lock(file->f_path.dentry->d_sb);
 	err = unionfs_file_revalidate(file, false);
@@ -175,11 +175,17 @@ static int unionfs_readpage(struct file *file, struct page *page)
 	 * the necessary magic for us.
 	 */
 	lower_file->f_pos = page_offset(page);
-	offset = page_offset(page);
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
+	/*
+	 * generic_file_splice_write may call us on a file not opened for
+	 * reading, so temporarily allow reading.
+	 */
+	orig_mode = lower_file->f_mode;
+	lower_file->f_mode |= FMODE_READ;
 	err = vfs_read(lower_file, page_data, PAGE_CACHE_SIZE,
 		       &lower_file->f_pos);
+	lower_file->f_mode = orig_mode;
 	set_fs(old_fs);
 	if (err >= 0 && err < PAGE_CACHE_SIZE)
 		memset(page_data + err, 0, PAGE_CACHE_SIZE - err);
-- 
1.5.2.2

