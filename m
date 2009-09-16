Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZIPRZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZIPRZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 13:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZIPRZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 13:25:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbZIPRZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 13:25:10 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org, jeffm@suse.com
Subject: [PATCH] reiserfs: Truncate blocks not used by a write (v2)
Date: Wed, 16 Sep 2009 19:25:12 +0200
Message-Id: <1253121912-20718-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can happen that write does not use all the blocks allocated in write_begin
either because of some filesystem error (like ENOSPC) or because page with
data to write has been removed from memory. We truncate these blocks so that
we don't have dangling blocks beyond i_size.

CC: reiserfs-devel@vger.kernel.org
CC: jeffm@suse.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/inode.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

  Next try, this time without vmtruncate() as Christoph asked.

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a14d6cd..a83280f 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2597,6 +2597,8 @@ static int reiserfs_write_begin(struct file *file,
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		/* Truncate allocated blocks */
+		reiserfs_truncate_file(inode, 0);
 	}
 	return ret;
 }
@@ -2689,8 +2691,7 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 	 ** transaction tracking stuff when the size changes.  So, we have
 	 ** to do the i_size updates here.
 	 */
-	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos + copied > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
 		reiserfs_write_lock(inode->i_sb);
 		/* If the file have grown beyond the border where it
@@ -2708,7 +2709,7 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 			goto journal_error;
 		}
 		reiserfs_update_inode_transaction(inode);
-		inode->i_size = pos;
+		inode->i_size = pos + copied;
 		/*
 		 * this will just nest into our transaction.  It's important
 		 * to use mark_inode_dirty so the inode gets pushed around on the
@@ -2735,6 +2736,10 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
       out:
 	unlock_page(page);
 	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		reiserfs_truncate_file(inode, 0);
+
 	return ret == 0 ? copied : ret;
 
       journal_error:
-- 
1.6.0.2

