Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbXJAFxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbXJAFxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXJAFvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40757 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbXJAFv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:26 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 08/19] Unionfs: use page_offset() helper
Date: Mon,  1 Oct 2007 01:50:45 -0400
Message-Id: <11912178594178-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index cf9545e..8928e99 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -179,8 +179,7 @@ static int unionfs_do_readpage(struct file *file, struct page *page)
 	 * may be a little slower, but a lot safer, as the VFS does a lot of
 	 * the necessary magic for us.
 	 */
-	offset = lower_file->f_pos =
-		((loff_t) page->index << PAGE_CACHE_SHIFT);
+	offset = lower_file->f_pos = page_offset(page);
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
 	err = vfs_read(lower_file, page_data, PAGE_CACHE_SIZE,
@@ -290,7 +289,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 	BUG_ON(lower_file == NULL);
 
 	page_data = (char *)kmap(page);
-	lower_file->f_pos = ((loff_t) page->index << PAGE_CACHE_SHIFT) + from;
+	lower_file->f_pos = page_offset(page) + from;
 
 	/*
 	 * We use vfs_write instead of copying page data and the
@@ -312,7 +311,7 @@ static int unionfs_commit_write(struct file *file, struct page *page,
 
 	inode->i_blocks = lower_inode->i_blocks;
 	/* we may have to update i_size */
-	pos = ((loff_t) page->index << PAGE_CACHE_SHIFT) + to;
+	pos = page_offset(page) + to;
 	if (pos > i_size_read(inode))
 		i_size_write(inode, pos);
 	/* if vfs_write succeeded above, sync up our times */
-- 
1.5.2.2

