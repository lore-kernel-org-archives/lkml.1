Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbZEHShv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbZEHShv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZEHSfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:35:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:18303 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761437AbZEHSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cbPUNATkkfTGWP7G0H/byE5FWjt13MBf7sSkuk5HUrWyuHLpi4EtsrOOgP4rBu3Exx
         I1IwoaqUJd2rkq3+7s9nrt8j5uBtApVIslFP1xP0N9Qp/TEKLg3Q5y7n+vdctH5RPTMm
         q5zUdkdO6OzYdokMagtUPq3B/NStq9pCosYe0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 6/7] kill-the-bkl/reiserfs: factorize the locking in reiserfs_write_end()
Date: Fri,  8 May 2009 20:35:23 +0200
Message-Id: <1241807725-6263-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
References: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_write_end() is a hot path in reiserfs.
We have two wasteful write lock lock/release inside that can be gathered
without changing the code logic.

This patch factorizes them out in a single protected section, reducing the
number of contentions inside.

[ Impact: reduce lock contention in a reiserfs hotpath ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/inode.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a5f69ef..cd65176 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2685,6 +2685,8 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 	int update_sd = 0;
 	struct reiserfs_transaction_handle *th;
 	unsigned start;
+	int lock_depth = 0;
+	bool locked = false;
 
 	if ((unsigned long)fsdata & AOP_FLAG_CONT_EXPAND)
 		pos ++;
@@ -2711,9 +2713,11 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 	 ** to do the i_size updates here.
 	 */
 	pos += copied;
+
 	if (pos > inode->i_size) {
 		struct reiserfs_transaction_handle myth;
-		reiserfs_write_lock(inode->i_sb);
+		lock_depth = reiserfs_write_lock_once(inode->i_sb);
+		locked = true;
 		/* If the file have grown beyond the border where it
 		   can have a tail, unmark it as needing a tail
 		   packing */
@@ -2724,10 +2728,9 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 			REISERFS_I(inode)->i_flags &= ~i_pack_on_close_mask;
 
 		ret = journal_begin(&myth, inode->i_sb, 1);
-		if (ret) {
-			reiserfs_write_unlock(inode->i_sb);
+		if (ret)
 			goto journal_error;
-		}
+
 		reiserfs_update_inode_transaction(inode);
 		inode->i_size = pos;
 		/*
@@ -2739,34 +2742,36 @@ static int reiserfs_write_end(struct file *file, struct address_space *mapping,
 		reiserfs_update_sd(&myth, inode);
 		update_sd = 1;
 		ret = journal_end(&myth, inode->i_sb, 1);
-		reiserfs_write_unlock(inode->i_sb);
 		if (ret)
 			goto journal_error;
 	}
 	if (th) {
-		reiserfs_write_lock(inode->i_sb);
+		if (!locked) {
+			lock_depth = reiserfs_write_lock_once(inode->i_sb);
+			locked = true;
+		}
 		if (!update_sd)
 			mark_inode_dirty(inode);
 		ret = reiserfs_end_persistent_transaction(th);
-		reiserfs_write_unlock(inode->i_sb);
 		if (ret)
 			goto out;
 	}
 
       out:
+	if (locked)
+		reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 	unlock_page(page);
 	page_cache_release(page);
 	return ret == 0 ? copied : ret;
 
       journal_error:
+	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
+	locked = false;
 	if (th) {
-		reiserfs_write_lock(inode->i_sb);
 		if (!update_sd)
 			reiserfs_update_sd(th, inode);
 		ret = reiserfs_end_persistent_transaction(th);
-		reiserfs_write_unlock(inode->i_sb);
 	}
-
 	goto out;
 }
 
-- 
1.6.2.3

