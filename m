Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbXIZD2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbXIZD2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbXIZD2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:28:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34779 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbXIZD2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:28:37 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 14/25] Unionfs: add un/likely conditionals on headers
Date: Tue, 25 Sep 2007 23:09:53 -0400
Message-Id: <11907762102998-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/fanout.h |   13 ++++++++-----
 fs/unionfs/union.h  |    4 ++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 51aa0de..6405399 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -308,17 +308,20 @@ static inline void unionfs_copy_attr_times(struct inode *upper)
 	int bindex;
 	struct inode *lower;
 
-	if (!upper || ibstart(upper) < 0)
+	if (unlikely(!upper || ibstart(upper) < 0))
 		return;
 	for (bindex=ibstart(upper); bindex <= ibend(upper); bindex++) {
 		lower = unionfs_lower_inode_idx(upper, bindex);
-		if (!lower)
+		if (unlikely(!lower))
 			continue; /* not all lower dir objects may exist */
-		if (timespec_compare(&upper->i_mtime, &lower->i_mtime) < 0)
+		if (unlikely(timespec_compare(&upper->i_mtime,
+					      &lower->i_mtime) < 0))
 			upper->i_mtime = lower->i_mtime;
-		if (timespec_compare(&upper->i_ctime, &lower->i_ctime) < 0)
+		if (likely(timespec_compare(&upper->i_ctime,
+					    &lower->i_ctime) < 0))
 			upper->i_ctime = lower->i_ctime;
-		if (timespec_compare(&upper->i_atime, &lower->i_atime) < 0)
+		if (likely(timespec_compare(&upper->i_atime,
+					    &lower->i_atime) < 0))
 			upper->i_atime = lower->i_atime;
 	}
 }
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index d27844d..8df44a9 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -472,7 +472,7 @@ static inline struct vfsmount *unionfs_mntget(struct dentry *dentry,
 
 	mnt = mntget(unionfs_lower_mnt_idx(dentry, bindex));
 #ifdef CONFIG_UNION_FS_DEBUG
-	if (!mnt)
+	if (unlikely(!mnt))
 		printk(KERN_DEBUG "unionfs_mntget: mnt=%p bindex=%d\n",
 		       mnt, bindex);
 #endif /* CONFIG_UNION_FS_DEBUG */
@@ -484,7 +484,7 @@ static inline void unionfs_mntput(struct dentry *dentry, int bindex)
 {
 	struct vfsmount *mnt;
 
-	if (!dentry && bindex < 0)
+	if (unlikely(!dentry && bindex < 0))
 		return;
 	BUG_ON(!dentry || bindex < 0);
 
-- 
1.5.2.2

