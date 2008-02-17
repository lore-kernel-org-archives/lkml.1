Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYBQDA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYBQDA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbYBQC6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:58:06 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36301 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbYBQC6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:58:01 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 04/17] Unionfs: uninline unionfs_copy_attr_times and unionfs_copy_attr_all
Date: Sat, 16 Feb 2008 21:57:13 -0500
Message-Id: <1203217048358-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces text size by about 6k.

Cc: Hugh Dickins <hugh@veritas.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/fanout.h |   50 --------------------------------------------------
 fs/unionfs/subr.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/unionfs/union.h  |    2 ++
 3 files changed, 52 insertions(+), 50 deletions(-)

diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 4d9a45f..29d42fb 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -313,54 +313,4 @@ static inline void verify_locked(struct dentry *d)
 	BUG_ON(!mutex_is_locked(&UNIONFS_D(d)->lock));
 }
 
-/* copy a/m/ctime from the lower branch with the newest times */
-static inline void unionfs_copy_attr_times(struct inode *upper)
-{
-	int bindex;
-	struct inode *lower;
-
-	if (!upper || ibstart(upper) < 0)
-		return;
-	for (bindex = ibstart(upper); bindex <= ibend(upper); bindex++) {
-		lower = unionfs_lower_inode_idx(upper, bindex);
-		if (!lower)
-			continue; /* not all lower dir objects may exist */
-		if (unlikely(timespec_compare(&upper->i_mtime,
-					      &lower->i_mtime) < 0))
-			upper->i_mtime = lower->i_mtime;
-		if (unlikely(timespec_compare(&upper->i_ctime,
-					      &lower->i_ctime) < 0))
-			upper->i_ctime = lower->i_ctime;
-		if (unlikely(timespec_compare(&upper->i_atime,
-					      &lower->i_atime) < 0))
-			upper->i_atime = lower->i_atime;
-	}
-}
-
-/*
- * A unionfs/fanout version of fsstack_copy_attr_all.  Uses a
- * unionfs_get_nlinks to properly calcluate the number of links to a file.
- * Also, copies the max() of all a/m/ctimes for all lower inodes (which is
- * important if the lower inode is a directory type)
- */
-static inline void unionfs_copy_attr_all(struct inode *dest,
-					 const struct inode *src)
-{
-	dest->i_mode = src->i_mode;
-	dest->i_uid = src->i_uid;
-	dest->i_gid = src->i_gid;
-	dest->i_rdev = src->i_rdev;
-
-	unionfs_copy_attr_times(dest);
-
-	dest->i_blkbits = src->i_blkbits;
-	dest->i_flags = src->i_flags;
-
-	/*
-	 * Update the nlinks AFTER updating the above fields, because the
-	 * get_links callback may depend on them.
-	 */
-	dest->i_nlink = unionfs_get_nlinks(dest);
-}
-
 #endif	/* not _FANOUT_H */
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 0a0fce9..68a6280 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -240,3 +240,53 @@ char *alloc_whname(const char *name, int len)
 
 	return buf;
 }
+
+/* copy a/m/ctime from the lower branch with the newest times */
+void unionfs_copy_attr_times(struct inode *upper)
+{
+	int bindex;
+	struct inode *lower;
+
+	if (!upper || ibstart(upper) < 0)
+		return;
+	for (bindex = ibstart(upper); bindex <= ibend(upper); bindex++) {
+		lower = unionfs_lower_inode_idx(upper, bindex);
+		if (!lower)
+			continue; /* not all lower dir objects may exist */
+		if (unlikely(timespec_compare(&upper->i_mtime,
+					      &lower->i_mtime) < 0))
+			upper->i_mtime = lower->i_mtime;
+		if (unlikely(timespec_compare(&upper->i_ctime,
+					      &lower->i_ctime) < 0))
+			upper->i_ctime = lower->i_ctime;
+		if (unlikely(timespec_compare(&upper->i_atime,
+					      &lower->i_atime) < 0))
+			upper->i_atime = lower->i_atime;
+	}
+}
+
+/*
+ * A unionfs/fanout version of fsstack_copy_attr_all.  Uses a
+ * unionfs_get_nlinks to properly calcluate the number of links to a file.
+ * Also, copies the max() of all a/m/ctimes for all lower inodes (which is
+ * important if the lower inode is a directory type)
+ */
+void unionfs_copy_attr_all(struct inode *dest,
+			   const struct inode *src)
+{
+	dest->i_mode = src->i_mode;
+	dest->i_uid = src->i_uid;
+	dest->i_gid = src->i_gid;
+	dest->i_rdev = src->i_rdev;
+
+	unionfs_copy_attr_times(dest);
+
+	dest->i_blkbits = src->i_blkbits;
+	dest->i_flags = src->i_flags;
+
+	/*
+	 * Update the nlinks AFTER updating the above fields, because the
+	 * get_links callback may depend on them.
+	 */
+	dest->i_nlink = unionfs_get_nlinks(dest);
+}
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 786c4be..0e0ccde 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -199,6 +199,8 @@ struct unionfs_dir_state {
 
 /* externs needed for fanout.h or sioq.h */
 extern int unionfs_get_nlinks(const struct inode *inode);
+extern void unionfs_copy_attr_times(struct inode *upper);
+extern void unionfs_copy_attr_all(struct inode *dest, const struct inode *src);
 
 /* include miscellaneous macros */
 #include "fanout.h"
-- 
1.5.2.2

