Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbXL1UsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbXL1UsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbXL1UoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37159 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbXL1Unw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:52 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Hugh Dickins <hugh@veritas.com>, Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 10/30] Unionfs: mmap fixes
Date: Fri, 28 Dec 2007 15:42:44 -0500
Message-Id: <1198874590842-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

Remove !mapping_cap_writeback_dirty shortcircuit from unionfs_writepages.

It was introduced to avoid the stray AOP_WRITEPAGE_ACTIVATE coming from
shmem_writepage; but that has since been fixed in shmem_writepage and in
write_cache_pages.  It stayed because it looked like a good optimization,
not to waste time calling down to tmpfs when that would serve no purpose.

But in fact this optimization causes hangs when running LTP with unionfs
over tmpfs.  The problem is that the test comes at the wrong level: unionfs
has already declared in its default_backing_dev_info that it's playing by
cap_writeback_dirty rules.  If it does nothing here in its writepages, its
dirty pages accumulate and choke the system.  What's needed is to carry on
down and let its pages be cleaned while in turn they dirty the lower level.

And this now has an additional benefit for tmpfs, that a sync or pdflush
pushes these pages down to shmem_writepage, letting it match the filepage
coming from unionfs with the swap which may have been allocated earlier,
so it can free the duplication sooner than waiting for further pressure.

Remove unnecessary locking/code from prepare_write.  Handle if no lower
inodes in writepage.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index 4d05352..aad2137 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -30,6 +30,11 @@ static int unionfs_writepage(struct page *page, struct writeback_control *wbc)
 
 	BUG_ON(!PageUptodate(page));
 	inode = page->mapping->host;
+	/* if no lower inode, nothing to do */
+	if (!inode || !UNIONFS_I(inode) || UNIONFS_I(inode)->lower_inodes) {
+		err = 0;
+		goto out;
+	}
 	lower_inode = unionfs_lower_inode(inode);
 	lower_mapping = lower_inode->i_mapping;
 
@@ -130,9 +135,6 @@ static int unionfs_writepages(struct address_space *mapping,
 	if (!lower_inode)
 		goto out;
 
-	if (!mapping_cap_writeback_dirty(lower_inode->i_mapping))
-		goto out;
-
 	err = generic_writepages(mapping, wbc);
 	if (!err)
 		unionfs_copy_attr_times(inode);
@@ -222,26 +224,13 @@ out:
 static int unionfs_prepare_write(struct file *file, struct page *page,
 				 unsigned from, unsigned to)
 {
-	int err;
-
-	unionfs_read_lock(file->f_path.dentry->d_sb);
 	/*
-	 * This is the only place where we unconditionally copy the lower
-	 * attribute times before calling unionfs_file_revalidate.  The
-	 * reason is that our ->write calls do_sync_write which in turn will
-	 * call our ->prepare_write and then ->commit_write.  Before our
-	 * ->write is called, the lower mtimes are in sync, but by the time
-	 * the VFS calls our ->commit_write, the lower mtimes have changed.
-	 * Therefore, the only reasonable time for us to sync up from the
-	 * changed lower mtimes, and avoid an invariant violation warning,
-	 * is here, in ->prepare_write.
+	 * Just copy lower inode attributes and return success.  Not much
+	 * else to do here.  No need to lock either (lockdep won't like it).
+	 * Let commit_write do all the hard work instead.
 	 */
 	unionfs_copy_attr_times(file->f_path.dentry->d_inode);
-	err = unionfs_file_revalidate(file, true);
-	unionfs_check_file(file);
-	unionfs_read_unlock(file->f_path.dentry->d_sb);
-
-	return err;
+	return 0;
 }
 
 static int unionfs_commit_write(struct file *file, struct page *page,
-- 
1.5.2.2

