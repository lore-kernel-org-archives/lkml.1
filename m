Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbZEHSg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbZEHSg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761223AbZEHSff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:35:35 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61221 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZEHSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QTCSAoPbRkMv92QvyO/HXTdwUdKtmvcU5abx0vTwTAp3bsFXypPsFdwfe6iLHW09b2
         C8xFP9re9XoUqjUMkfDArExlij4eM99805V6+Y6wcrTSpsnA1AIWxcYBLqN0sdOzgT7+
         +DydJC79NPg1QFO/9/3doToZZZ4nm8cNOHqEE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 4/7] kill-the-bkl/reiserfs: don't hold the write recursively in reiserfs_lookup()
Date: Fri,  8 May 2009 20:35:21 +0200
Message-Id: <1241807725-6263-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
References: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The write lock can be acquired recursively in reiserfs_lookup(). But we may
want to *really* release the lock before possible rescheduling from a
reiserfs_lookup() callee.

Hence we want to only acquire the lock once (ie: not recursively).

[ Impact: prevent from possible false unreleased write lock on sleeping ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/namei.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index efd4d72..bed3827 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -324,6 +324,7 @@ static struct dentry *reiserfs_lookup(struct inode *dir, struct dentry *dentry,
 				      struct nameidata *nd)
 {
 	int retval;
+	int lock_depth;
 	struct inode *inode = NULL;
 	struct reiserfs_dir_entry de;
 	INITIALIZE_PATH(path_to_entry);
@@ -331,7 +332,13 @@ static struct dentry *reiserfs_lookup(struct inode *dir, struct dentry *dentry,
 	if (REISERFS_MAX_NAME(dir->i_sb->s_blocksize) < dentry->d_name.len)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	reiserfs_write_lock(dir->i_sb);
+	/*
+	 * Might be called with or without the write lock, must be careful
+	 * to not recursively hold it in case we want to release the lock
+	 * before rescheduling.
+	 */
+	lock_depth = reiserfs_write_lock_once(dir->i_sb);
+
 	de.de_gen_number_bit_string = NULL;
 	retval =
 	    reiserfs_find_entry(dir, dentry->d_name.name, dentry->d_name.len,
@@ -347,14 +354,14 @@ static struct dentry *reiserfs_lookup(struct inode *dir, struct dentry *dentry,
 		    le32_to_cpu(INODE_PKEY
 				(REISERFS_SB(dir->i_sb)->priv_root->d_inode)->
 				k_objectid)) {
-			reiserfs_write_unlock(dir->i_sb);
+			reiserfs_write_unlock_once(dir->i_sb, lock_depth);
 			return ERR_PTR(-EACCES);
 		}
 
 		inode =
 		    reiserfs_iget(dir->i_sb, (struct cpu_key *)&(de.de_dir_id));
 		if (!inode || IS_ERR(inode)) {
-			reiserfs_write_unlock(dir->i_sb);
+			reiserfs_write_unlock_once(dir->i_sb, lock_depth);
 			return ERR_PTR(-EACCES);
 		}
 
@@ -363,7 +370,7 @@ static struct dentry *reiserfs_lookup(struct inode *dir, struct dentry *dentry,
 		if (IS_PRIVATE(dir))
 			inode->i_flags |= S_PRIVATE;
 	}
-	reiserfs_write_unlock(dir->i_sb);
+	reiserfs_write_unlock_once(dir->i_sb, lock_depth);
 	if (retval == IO_ERROR) {
 		return ERR_PTR(-EIO);
 	}
-- 
1.6.2.3

