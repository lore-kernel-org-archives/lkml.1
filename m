Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbXJZG50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbXJZG50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758664AbXJZG4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:56:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:36693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299AbXJZG4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:56:40 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:47 2007
Message-Id: <20071026064047.118069717@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:26 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 02/45] Pass struct path down to remove_suid and children
Content-Disposition: inline; filename=remove_suid.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Required by a later patch that adds a struct vfsmount parameter to
notify_change().

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ntfs/file.c             |    2 +-
 fs/splice.c                |    4 ++--
 fs/xfs/linux-2.6/xfs_lrw.c |    2 +-
 include/linux/fs.h         |    4 ++--
 mm/filemap.c               |   16 ++++++++--------
 mm/filemap_xip.c           |    2 +-
 mm/shmem.c                 |    2 +-
 7 files changed, 16 insertions(+), 16 deletions(-)

--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2121,7 +2121,7 @@ static ssize_t ntfs_file_aio_write_noloc
 		goto out;
 	if (!count)
 		goto out;
-	err = remove_suid(file->f_path.dentry);
+	err = remove_suid(&file->f_path);
 	if (err)
 		goto out;
 	file_update_time(file);
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -782,7 +782,7 @@ generic_file_splice_write_nolock(struct 
 	ssize_t ret;
 	int err;
 
-	err = remove_suid(out->f_path.dentry);
+	err = remove_suid(&out->f_path);
 	if (unlikely(err))
 		return err;
 
@@ -842,7 +842,7 @@ generic_file_splice_write(struct pipe_in
 		if (killpriv)
 			err = security_inode_killpriv(out->f_path.dentry);
 		if (!err && killsuid)
-			err = __remove_suid(out->f_path.dentry, killsuid);
+			err = __remove_suid(&out->f_path, killsuid);
 		mutex_unlock(&inode->i_mutex);
 		if (err)
 			return err;
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -734,7 +734,7 @@ start:
 	     !capable(CAP_FSETID)) {
 		error = xfs_write_clear_setuid(xip);
 		if (likely(!error))
-			error = -remove_suid(file->f_path.dentry);
+			error = -remove_suid(&file->f_path);
 		if (unlikely(error)) {
 			goto out_unlock_internal;
 		}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1774,9 +1774,9 @@ extern void __iget(struct inode * inode)
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
-extern int __remove_suid(struct dentry *, int);
+extern int __remove_suid(struct path *, int);
 extern int should_remove_suid(struct dentry *);
-extern int remove_suid(struct dentry *);
+extern int remove_suid(struct path *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1629,26 +1629,26 @@ int should_remove_suid(struct dentry *de
 }
 EXPORT_SYMBOL(should_remove_suid);
 
-int __remove_suid(struct dentry *dentry, int kill)
+int __remove_suid(struct path *path, int kill)
 {
 	struct iattr newattrs;
 
 	newattrs.ia_valid = ATTR_FORCE | kill;
-	return notify_change(dentry, &newattrs);
+	return notify_change(path->dentry, &newattrs);
 }
 
-int remove_suid(struct dentry *dentry)
+int remove_suid(struct path *path)
 {
-	int killsuid = should_remove_suid(dentry);
-	int killpriv = security_inode_need_killpriv(dentry);
+	int killsuid = should_remove_suid(path->dentry);
+	int killpriv = security_inode_need_killpriv(path->dentry);
 	int error = 0;
 
 	if (killpriv < 0)
 		return killpriv;
 	if (killpriv)
-		error = security_inode_killpriv(dentry);
+		error = security_inode_killpriv(path->dentry);
 	if (!error && killsuid)
-		error = __remove_suid(dentry, killsuid);
+		error = __remove_suid(path, killsuid);
 
 	return error;
 }
@@ -2361,7 +2361,7 @@ __generic_file_aio_write_nolock(struct k
 	if (count == 0)
 		goto out;
 
-	err = remove_suid(file->f_path.dentry);
+	err = remove_suid(&file->f_path);
 	if (err)
 		goto out;
 
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -378,7 +378,7 @@ xip_file_write(struct file *filp, const 
 	if (count == 0)
 		goto out_backing;
 
-	ret = remove_suid(filp->f_path.dentry);
+	ret = remove_suid(&filp->f_path);
 	if (ret)
 		goto out_backing;
 
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1510,7 +1510,7 @@ shmem_file_write(struct file *file, cons
 	if (err || !count)
 		goto out;
 
-	err = remove_suid(file->f_path.dentry);
+	err = remove_suid(&file->f_path);
 	if (err)
 		goto out;
 

-- 

