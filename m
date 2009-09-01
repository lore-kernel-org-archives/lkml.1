Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZIAPzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZIAPzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZIAPzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:55:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:44740 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbZIAPzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:55:53 -0400
Date: Tue, 1 Sep 2009 17:55:54 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: reiserfs-devel@vger.kernel.org, jeffm@suse.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] reiserfs: Truncate blocks not used by a write
Message-ID: <20090901155554.GD8242@duck.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can happen that write does not use all the blocks allocated in write_begin
either because of some filesystem error (like ENOSPC) or because page with
data to write has been removed from memory. We truncate these blocks so that
we don't have dangling blocks beyond i_size. 

Signed-off-by: Jan Kara <jack@suse.cz>
---

Andrew, would you merge the patch please? Thanks.

diff -rupX /home/jack/.kerndiffexclude linux-2.6.27-SLE11_BRANCH/fs/reiserfs/inode.c linux-2.6.27-SLE11_BRANCH-1-reiserfs_corruption//fs/reiserfs/inode.c
--- linux-2.6.27-SLE11_BRANCH/fs/reiserfs/inode.c	2009-06-02 17:14:29.000000000 +0200
+++ linux-2.6.27-SLE11_BRANCH-1-reiserfs_corruption//fs/reiserfs/inode.c	2009-06-24 14:39:44.000000000 +0200
@@ -2606,6 +2610,8 @@ static int reiserfs_write_begin(struct f
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
+		/* Truncate allocated blocks */
+		vmtruncate(inode, inode->i_size);
 	}
 	return ret;
 }
@@ -2698,8 +2705,7 @@ static int reiserfs_write_end(struct fil
 	 ** transaction tracking stuff when the size changes.  So, we have
 	 ** to do the i_size updates here.
 	 */
-	pos += copied;
-	if (pos > inode->i_size) {
+	if (pos + copied > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
 		reiserfs_write_lock(inode->i_sb);
 		/* If the file have grown beyond the border where it
@@ -2717,7 +2723,7 @@ static int reiserfs_write_end(struct fil
 			goto journal_error;
 		}
 		reiserfs_update_inode_transaction(inode);
-		inode->i_size = pos;
+		inode->i_size = pos + copied;
 		/*
 		 * this will just nest into our transaction.  It's important
 		 * to use mark_inode_dirty so the inode gets pushed around on the
@@ -2744,6 +2750,10 @@ static int reiserfs_write_end(struct fil
       out:
 	unlock_page(page);
 	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
+
 	return ret == 0 ? copied : ret;
 
       journal_error:
