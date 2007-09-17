Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbXIQLat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbXIQLat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXIQL3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:29:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbXIQL3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:29:32 -0400
Date: Mon, 17 Sep 2007 07:29:26 -0400
Message-Id: <200709171129.l8HBTQ2O024382@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 4/7] unionfs: fix unionfs_create and unionfs_setattr to handle ATTR_KILL_S*ID
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net,
       ecryptfs-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org,
       unionfs@filesystems.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow either function to trip the BUG() in notify_change. For
unionfs_setattr, clear ATTR_MODE if the either ATTR_KILL_S*ID is set.
This also allows the lower filesystem to interpret these bits in its
own way.

unionfs_create is setting the mode explicitly already, so don't set
ATTR_KILL_S*ID. Just fix up the mode to have the same effect. Also, move
locking the i_mutex to lower in the function. It's not needed until it
checks the i_size.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/unionfs/inode.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 59bb418..f2e7f25 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -78,15 +78,14 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 		struct dentry *lower_dir_dentry;
 		struct iattr newattrs;
 
-		mutex_lock(&wh_dentry->d_inode->i_mutex);
 		newattrs.ia_valid = ATTR_CTIME | ATTR_MODE | ATTR_ATIME
-			| ATTR_MTIME | ATTR_UID | ATTR_GID | ATTR_FORCE
-			| ATTR_KILL_SUID | ATTR_KILL_SGID;
+			| ATTR_MTIME | ATTR_UID | ATTR_GID | ATTR_FORCE;
 
-		newattrs.ia_mode = mode & ~current->fs->umask;
+		newattrs.ia_mode = mode & ~(current->fs->umask|S_ISUID|S_ISGID);
 		newattrs.ia_uid = current->fsuid;
 		newattrs.ia_gid = current->fsgid;
 
+		mutex_lock(&wh_dentry->d_inode->i_mutex);
 		if (wh_dentry->d_inode->i_size != 0) {
 			newattrs.ia_valid |= ATTR_SIZE;
 			newattrs.ia_size = 0;
@@ -1032,6 +1031,9 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	bend = dbend(dentry);
 	inode = dentry->d_inode;
 
+	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		ia->ia_valid &= ~ATTR_MODE;
+
 	for (bindex = bstart; (bindex <= bend) || (bindex == bstart);
 	     bindex++) {
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-- 
1.5.2.1

