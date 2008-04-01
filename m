Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbYDAVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbYDAVMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760412AbYDAVIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:08:13 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45633 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386AbYDAVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:08:12 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 13/14] Unionfs: don't purge lower sb data on remount
Date: Tue,  1 Apr 2008 17:06:55 -0400
Message-Id: <12070840223433-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is no longer needed, as we don't have upper and lower pages.  Plus this
was racy, requiring the unexported inode_lock variable.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   11 -----------
 fs/unionfs/super.c  |    8 +++++---
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 5e498c2..ee0da4f 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -273,17 +273,6 @@ static inline void purge_inode_data(struct inode *inode)
 	 */
 }
 
-void purge_sb_data(struct super_block *sb)
-{
-	struct inode *inode;
-
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE))
-			continue;
-		purge_inode_data(inode);
-	}
-}
-
 /*
  * Revalidate a single file/symlink/special dentry.  Assume that info nodes
  * of the dentry and its parent are locked.  Assume that parent(s) are all
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 4cddc83..82b4045 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -747,10 +747,12 @@ out_no_change:
 	 * function).  This revalidation will happen lazily and
 	 * incrementally, as users perform operations on cached inodes.  We
 	 * would like to encourage this revalidation to happen sooner if
-	 * possible, so we try to invalidate as many other pages in our
-	 * superblock as we can.
+	 * possible, so we like to try to invalidate as many other pages in
+	 * our superblock as we can.  We used to call drop_pagecache_sb() or
+	 * a variant thereof, but either method was racy (drop_caches alone
+	 * is known to be racy).  So now we let the revalidation happen on a
+	 * per file basis in ->d_revalidate.
 	 */
-	purge_sb_data(sb);
 
 	/* grab new lower super references; release old ones */
 	for (i = 0; i < new_branches; i++)
-- 
1.5.2.2

