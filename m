Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbXKMKNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbXKMKNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbXKMKLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:11:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50703 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXKMKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:10:59 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 4/9] Unionfs: writepage updates
Date: Tue, 13 Nov 2007 05:10:23 -0500
Message-Id: <11949486301913-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
References: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't set/reset the PageUptodate flag on our page.  Call flush_dcache_page
on the lower page after copy_highpage, and set it uptodate.  Call
set_page_dirty right before clear_page_dirty_for_io.

CC: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 4b00b98..468dc61 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -28,6 +28,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	struct address_space *lower_mapping; /* lower inode mapping */
 	gfp_t mask;
 
+	BUG_ON(!PageUptodate(page));
 	inode = page->mapping->host;
 	lower_inode = unionfs_lower_inode(inode);
 	lower_mapping = lower_inode->i_mapping;
@@ -53,6 +54,8 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 
 	/* copy page data from our upper page to the lower page */
 	copy_highpage(lower_page, page);
+	flush_dcache_page(lower_page);
+	SetPageUptodate(lower_page);
 
 	/*
 	 * Call lower writepage (expects locked page).  However, if we are
@@ -68,12 +71,11 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 		goto out_release;
 	}
 	BUG_ON(!lower_mapping->a_ops->writepage);
+	set_page_dirty(lower_page);
 	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
 	err = lower_mapping->a_ops->writepage(lower_page, wbc);
-	if (err < 0) {
-		ClearPageUptodate(page);
+	if (err < 0)
 		goto out_release;
-	}
 
 	/*
 	 * Lower file systems such as ramfs and tmpfs, may return
@@ -97,7 +99,7 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	}
 
 	/* all is well */
-	SetPageUptodate(page);
+
 	/* lower mtimes have changed: update ours */
 	unionfs_copy_attr_times(inode);
 
-- 
1.5.2.2

