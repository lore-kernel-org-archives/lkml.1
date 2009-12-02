Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZLBTR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZLBTR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZLBTRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:17:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbZLBTRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:17:22 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/3] reiserfs: Truncate blocks not used by write (v3)
Date: Wed,  2 Dec 2009 20:16:49 +0100
Message-Id: <1259781409-31318-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1259781409-31318-1-git-send-email-jack@suse.cz>
References: <1259781409-31318-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can happen that write does not use all the blocks allocated in
write_begin either because of some filesystem error (like ENOSPC) or
because page with data to write has been removed from memory.  We truncate
these blocks so that we don't have dangling blocks beyond i_size.

CC: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/inode.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

Andrew, this replaces the patch with the same name in your tree.

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a14d6cd..d240c15 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2531,6 +2531,12 @@ static int reiserfs_writepage(struct page *page, struct writeback_control *wbc)
 	return reiserfs_write_full_page(page, wbc);
 }
 
+static void reiserfs_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	reiserfs_truncate_file(inode, 0);
+}
+
 static int reiserfs_write_begin(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
@@ -2597,6 +2603,8 @@ static int reiserfs_write_begin(struct file *file,
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		/* Truncate allocated blocks */
+		reiserfs_truncate_failed_write(inode);
 	}
 	return ret;
 }
@@ -2689,8 +2697,7 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 	 ** transaction tracking stuff when the size changes.  So, we have
 	 ** to do the i_size updates here.
 	 */
-	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos + copied > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
 		reiserfs_write_lock(inode->i_sb);
 		/* If the file have grown beyond the border where it
@@ -2708,7 +2715,7 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 			goto journal_error;
 		}
 		reiserfs_update_inode_transaction(inode);
-		inode->i_size = pos;
+		inode->i_size = pos + copied;
 		/*
 		 * this will just nest into our transaction.  It's important
 		 * to use mark_inode_dirty so the inode gets pushed around on the
@@ -2735,6 +2742,10 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
       out:
 	unlock_page(page);
 	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		reiserfs_truncate_failed_write(inode);
+
 	return ret == 0 ? copied : ret;
 
       journal_error:
-- 
1.6.4.2

