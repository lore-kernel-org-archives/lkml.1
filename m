Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXJUXyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXJUXyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXJUXwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:52:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49205 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbXJUXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:50 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 7/9] Unionfs: remove for_writepages nfs workaround
Date: Sun, 21 Oct 2007 19:51:20 -0400
Message-Id: <11930106861987-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is no longer necessary since struct writeback_control no longer has a
fs_private field which lower file systems (esp. nfs) use.  Plus, unionfs now
defines its own ->writepages method.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |   39 ---------------------------------------
 1 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index b43557e..bed11c3 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -19,39 +19,6 @@
 
 #include "union.h"
 
-/*
- * Unionfs doesn't implement ->writepages, which is OK with the VFS and
- * keeps our code simpler and smaller.  Nevertheless, somehow, our own
- * ->writepage must be called so we can sync the upper pages with the lower
- * pages: otherwise data changed at the upper layer won't get written to the
- * lower layer.
- *
- * Some lower file systems (e.g., NFS) expect the VFS to call its writepages
- * only, which in turn will call generic_writepages and invoke each of the
- * lower file system's ->writepage.  NFS in particular uses the
- * wbc->fs_private field in its nfs_writepage, which is set in its
- * nfs_writepages.  So if we don't call the lower nfs_writepages first, then
- * NFS's nfs_writepage will dereference a NULL wbc->fs_private and cause an
- * OOPS.  If, however, we implement a unionfs_writepages and then we do call
- * the lower nfs_writepages, then we "lose control" over the pages we're
- * trying to write to the lower file system: we won't be writing our own
- * new/modified data from the upper pages to the lower pages, and any
- * mmap-based changes are lost.
- *
- * This is a fundamental cache-coherency problem in Linux.  The kernel isn't
- * able to support such stacking abstractions cleanly.  One possible clean
- * way would be that a lower file system's ->writepage method have some sort
- * of a callback to validate if any upper pages for the same file+offset
- * exist and have newer content in them.
- *
- * This whole NULL ptr dereference is triggered at the lower file system
- * (NFS) because the wbc->for_writepages is set to 1.  Therefore, to avoid
- * this NULL pointer dereference, we set this flag to 0 and restore it upon
- * exit.  This probably means that we're slightly less efficient in writing
- * pages out, doing them one at a time, but at least we avoid the oops until
- * such day as Linux can better support address_space_ops in a stackable
- * fashion.
- */
 static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int err = -EIO;
@@ -59,7 +26,6 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 	struct inode *lower_inode;
 	struct page *lower_page;
 	char *kaddr, *lower_kaddr;
-	int saved_for_writepages = wbc->for_writepages;
 
 	inode = page->mapping->host;
 	lower_inode = unionfs_lower_inode(inode);
@@ -101,14 +67,9 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 
 	BUG_ON(!lower_inode->i_mapping->a_ops->writepage);
 
-	/* workaround for some lower file systems: see big comment on top */
-	if (wbc->for_writepages && !wbc->fs_private)
-		wbc->for_writepages = 0;
-
 	/* call lower writepage (expects locked page) */
 	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
 	err = lower_inode->i_mapping->a_ops->writepage(lower_page, wbc);
-	wbc->for_writepages = saved_for_writepages; /* restore value */
 
 	/* b/c find_lock_page locked it and ->writepage unlocks on success */
 	if (err)
-- 
1.5.2.2

