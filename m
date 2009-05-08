Return-Path: <linux-kernel-owner+w=401wt.eu-S1763736AbZEHSgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763736AbZEHSgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760571AbZEHSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:35:34 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61221 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZEHSfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x0NvggXxm0M4Lrv0FckTcMhlIJcVZlRSU05sEen5vnJVYnE8DAHS7rJSQ6W2jvq8tI
         q3V/y42G1Pmh2f++0za8R7RipF05GGSUUM1YYeQtJZ1fc4nvahQl1grcpZTQXeCE7p7i
         42I1NM9Syyl89heEBE6cEa86o8KkitkbTtYyc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 3/7] kill-the-bkl/reiserfs: lock only once on reiserfs_get_block()
Date: Fri,  8 May 2009 20:35:20 +0200
Message-Id: <1241807725-6263-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
References: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_get_block() is one of these sites where the write lock might
be acquired recursively.

It's a particular problem because this function is called very often.
It's a hot spot which needs to reschedule() periodically while converting
direct items to indirect ones because it can take some time.

Then if we are applying the write lock release/reacquire pattern on
schedule() here, it may not produce the desired effect since we may have
locked in more than one depth.

The solution is to use reiserfs_write_lock_once() which won't try
to reacquire the lock recursively. Then the lock will be *really*
released before schedule().

Also, we only release the lock if TIF_NEED_RESCHED is set to not
create wasteful numerous contentions.

[ Impact: fix a too long holded lock case in reiserfs_get_block() ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/inode.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 153668e..a5f69ef 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -605,6 +605,7 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 	__le32 *item;
 	int done;
 	int fs_gen;
+	int lock_depth;
 	struct reiserfs_transaction_handle *th = NULL;
 	/* space reserved in transaction batch:
 	   . 3 balancings in direct->indirect conversion
@@ -620,11 +621,11 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 	loff_t new_offset =
 	    (((loff_t) block) << inode->i_sb->s_blocksize_bits) + 1;
 
-	reiserfs_write_lock(inode->i_sb);
+	lock_depth = reiserfs_write_lock_once(inode->i_sb);
 	version = get_inode_item_key_version(inode);
 
 	if (!file_capable(inode, block)) {
-		reiserfs_write_unlock(inode->i_sb);
+		reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 		return -EFBIG;
 	}
 
@@ -636,7 +637,7 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 		/* find number of block-th logical block of the file */
 		ret = _get_block_create_0(inode, block, bh_result,
 					  create | GET_BLOCK_READ_DIRECT);
-		reiserfs_write_unlock(inode->i_sb);
+		reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 		return ret;
 	}
 	/*
@@ -754,7 +755,7 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 		if (!dangle && th)
 			retval = reiserfs_end_persistent_transaction(th);
 
-		reiserfs_write_unlock(inode->i_sb);
+		reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 
 		/* the item was found, so new blocks were not added to the file
 		 ** there is no need to make sure the inode is updated with this
@@ -1005,9 +1006,11 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 		 * long time.  reschedule if needed and also release the write
 		 * lock for others.
 		 */
-		reiserfs_write_unlock(inode->i_sb);
-		cond_resched();
-		reiserfs_write_lock(inode->i_sb);
+		if (need_resched()) {
+			reiserfs_write_unlock_once(inode->i_sb, lock_depth);
+			schedule();
+			lock_depth = reiserfs_write_lock_once(inode->i_sb);
+		}
 
 		retval = search_for_position_by_key(inode->i_sb, &key, &path);
 		if (retval == IO_ERROR) {
@@ -1042,7 +1045,7 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 			retval = err;
 	}
 
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 	reiserfs_check_path(&path);
 	return retval;
 }
-- 
1.6.2.3

