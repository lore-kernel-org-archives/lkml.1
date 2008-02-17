Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYBQDAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYBQDAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbYBQC6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:58:13 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36325 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbYBQC6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:58:10 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 17/17] VFS/Unionfs: use generic path_get/path_put functions
Date: Sat, 16 Feb 2008 21:57:26 -0500
Message-Id: <1203217056421-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unionfs's versions thereof.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c     |   10 +++++-----
 fs/unionfs/super.c    |   27 ++++++++++++++-------------
 include/linux/namei.h |   12 ------------
 3 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 3585b29..8f59fb5 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -230,11 +230,11 @@ void unionfs_reinterpose(struct dentry *dentry)
 int check_branch(struct nameidata *nd)
 {
 	/* XXX: remove in ODF code -- stacking unions allowed there */
-	if (!strcmp(nd->dentry->d_sb->s_type->name, UNIONFS_NAME))
+	if (!strcmp(nd->path.dentry->d_sb->s_type->name, UNIONFS_NAME))
 		return -EINVAL;
-	if (!nd->dentry->d_inode)
+	if (!nd->path.dentry->d_inode)
 		return -ENOENT;
-	if (!S_ISDIR(nd->dentry->d_inode->i_mode))
+	if (!S_ISDIR(nd->path.dentry->d_inode->i_mode))
 		return -ENOTDIR;
 	return 0;
 }
@@ -375,8 +375,8 @@ static int parse_dirs_option(struct super_block *sb, struct unionfs_dentry_info
 			goto out;
 		}
 
-		lower_root_info->lower_paths[bindex].dentry = nd.dentry;
-		lower_root_info->lower_paths[bindex].mnt = nd.mnt;
+		lower_root_info->lower_paths[bindex].dentry = nd.path.dentry;
+		lower_root_info->lower_paths[bindex].mnt = nd.path.mnt;
 
 		set_branchperms(sb, bindex, perms);
 		set_branch_count(sb, bindex, 0);
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 773623e..fba1598 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -231,8 +231,8 @@ static noinline int do_remount_mode_option(char *optarg, int cur_branches,
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -274,8 +274,8 @@ static noinline int do_remount_del_option(char *optarg, int cur_branches,
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -358,8 +358,8 @@ static noinline int do_remount_add_option(char *optarg, int cur_branches,
 		goto out;
 	}
 	for (idx = 0; idx < cur_branches; idx++)
-		if (nd.mnt == new_lower_paths[idx].mnt &&
-		    nd.dentry == new_lower_paths[idx].dentry)
+		if (nd.path.mnt == new_lower_paths[idx].mnt &&
+		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
 	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
@@ -425,10 +425,10 @@ found_insertion_point:
 		memmove(&new_lower_paths[idx+1], &new_lower_paths[idx],
 			(cur_branches - idx) * sizeof(struct path));
 	}
-	new_lower_paths[idx].dentry = nd.dentry;
-	new_lower_paths[idx].mnt = nd.mnt;
+	new_lower_paths[idx].dentry = nd.path.dentry;
+	new_lower_paths[idx].mnt = nd.path.mnt;
 
-	new_data[idx].sb = nd.dentry->d_sb;
+	new_data[idx].sb = nd.path.dentry->d_sb;
 	atomic_set(&new_data[idx].open_files, 0);
 	new_data[idx].branchperms = perms;
 	new_data[idx].branch_id = ++*high_branch_id; /* assign new branch ID */
@@ -577,7 +577,7 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	memcpy(tmp_lower_paths, UNIONFS_D(sb->s_root)->lower_paths,
 	       cur_branches * sizeof(struct path));
 	for (i = 0; i < cur_branches; i++)
-		pathget(&tmp_lower_paths[i]); /* drop refs at end of fxn */
+		path_get(&tmp_lower_paths[i]); /* drop refs at end of fxn */
 
 	/*******************************************************************
 	 * For each branch command, do path_lookup on the requested branch,
@@ -1008,9 +1008,10 @@ static int unionfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 
 	seq_printf(m, ",dirs=");
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		path = d_path(unionfs_lower_dentry_idx(sb->s_root, bindex),
-			      unionfs_lower_mnt_idx(sb->s_root, bindex),
-			      tmp_page, PAGE_SIZE);
+		struct path p;
+		p.dentry = unionfs_lower_dentry_idx(sb->s_root, bindex);
+		p.mnt = unionfs_lower_mnt_idx(sb->s_root, bindex);
+		path = d_path(&p, tmp_page, PAGE_SIZE);
 		if (IS_ERR(path)) {
 			ret = PTR_ERR(path);
 			goto out;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 7ffeb21..24d88e9 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -93,16 +93,4 @@ static inline char *nd_get_link(struct nameidata *nd)
 	return nd->saved_names[nd->depth];
 }
 
-static inline void pathget(struct path *path)
-{
-	mntget(path->mnt);
-	dget(path->dentry);
-}
-
-static inline void pathput(struct path *path)
-{
-	dput(path->dentry);
-	mntput(path->mnt);
-}
-
 #endif /* _LINUX_NAMEI_H */
-- 
1.5.2.2

