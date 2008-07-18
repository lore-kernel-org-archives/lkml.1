Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbYGRClY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbYGRClY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbYGRCk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:40:58 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:20695
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757830AbYGRCk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:40:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANeff0jLO9AP/2dsb2JhbACvdg
X-IronPort-AV: E=Sophos;i="4.31,207,1215360000"; 
   d="scan'208";a="343549431"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/7] autofs4 - cleanup redundant readir code
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Jul 2008 10:37:02 +0800
Message-ID: <20080718023700.12802.52927.stgit@raven.themaw.net>
In-Reply-To: <20080718023651.12802.59107.stgit@raven.themaw.net>
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mount triggering functionality of readdir and related functions
is no longer used (and is quite broken as well). The unused portions
have been removed.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/root.c |  149 ++++++-----------------------------------------------
 1 files changed, 16 insertions(+), 133 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2a1a631..e842b0a 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -25,8 +25,6 @@ static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
 static int autofs4_root_ioctl(struct inode *, struct file *,unsigned int,unsigned long);
 static int autofs4_dir_open(struct inode *inode, struct file *file);
-static int autofs4_dir_close(struct inode *inode, struct file *file);
-static int autofs4_dir_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
@@ -44,9 +42,9 @@ const struct file_operations autofs4_root_operations = {
 
 const struct file_operations autofs4_dir_operations = {
 	.open		= autofs4_dir_open,
-	.release	= autofs4_dir_close,
+	.release	= dcache_dir_close,
 	.read		= generic_read_dir,
-	.readdir	= autofs4_dir_readdir,
+	.readdir	= dcache_readdir,
 };
 
 const struct inode_operations autofs4_indirect_root_inode_operations = {
@@ -98,17 +96,7 @@ static int autofs4_root_readdir(struct file *file, void *dirent,
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
-	struct vfsmount *mnt = file->f_path.mnt;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *cursor;
-	int status;
-
-	status = dcache_dir_open(inode, file);
-	if (status)
-		goto out;
-
-	cursor = file->private_data;
-	cursor->d_fsdata = NULL;
 
 	DPRINTK("file=%p dentry=%p %.*s",
 		file, dentry, dentry->d_name.len, dentry->d_name.name);
@@ -116,129 +104,24 @@ static int autofs4_dir_open(struct inode *inode, struct file *file)
 	if (autofs4_oz_mode(sbi))
 		goto out;
 
-	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
-		dcache_dir_close(inode, file);
-		status = -EBUSY;
-		goto out;
-	}
-
-	status = -ENOENT;
-	if (!d_mountpoint(dentry) && dentry->d_op && dentry->d_op->d_revalidate) {
-		struct nameidata nd;
-		int empty, ret;
-
-		/* In case there are stale directory dentrys from a failed mount */
-		spin_lock(&dcache_lock);
-		empty = list_empty(&dentry->d_subdirs);
+	/*
+	 * An empty directory in an autofs file system is always a
+	 * mount point. The daemon must have failed to mount this
+	 * during lookup so it doesn't exist. This can happen, for
+	 * example, if user space returns an incorrect status for a
+	 * mount request. Otherwise we're doing a readdir on the
+	 * autofs file system so just let the libfs routines handle
+	 * it.
+	 */
+	spin_lock(&dcache_lock);
+	if (!d_mountpoint(dentry) && __simple_empty(dentry)) {
 		spin_unlock(&dcache_lock);
-
-		if (!empty)
-			d_invalidate(dentry);
-
-		nd.flags = LOOKUP_DIRECTORY;
-		ret = (dentry->d_op->d_revalidate)(dentry, &nd);
-
-		if (ret <= 0) {
-			if (ret < 0)
-				status = ret;
-			dcache_dir_close(inode, file);
-			goto out;
-		}
+		return -ENOENT;
 	}
+	spin_unlock(&dcache_lock);
 
-	if (d_mountpoint(dentry)) {
-		struct file *fp = NULL;
-		struct path fp_path = { .dentry = dentry, .mnt = mnt };
-
-		path_get(&fp_path);
-
-		if (!autofs4_follow_mount(&fp_path.mnt, &fp_path.dentry)) {
-			path_put(&fp_path);
-			dcache_dir_close(inode, file);
-			goto out;
-		}
-
-		fp = dentry_open(fp_path.dentry, fp_path.mnt, file->f_flags);
-		status = PTR_ERR(fp);
-		if (IS_ERR(fp)) {
-			dcache_dir_close(inode, file);
-			goto out;
-		}
-		cursor->d_fsdata = fp;
-	}
-	return 0;
-out:
-	return status;
-}
-
-static int autofs4_dir_close(struct inode *inode, struct file *file)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *cursor = file->private_data;
-	int status = 0;
-
-	DPRINTK("file=%p dentry=%p %.*s",
-		file, dentry, dentry->d_name.len, dentry->d_name.name);
-
-	if (autofs4_oz_mode(sbi))
-		goto out;
-
-	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
-		status = -EBUSY;
-		goto out;
-	}
-
-	if (d_mountpoint(dentry)) {
-		struct file *fp = cursor->d_fsdata;
-		if (!fp) {
-			status = -ENOENT;
-			goto out;
-		}
-		filp_close(fp, current->files);
-	}
-out:
-	dcache_dir_close(inode, file);
-	return status;
-}
-
-static int autofs4_dir_readdir(struct file *file, void *dirent, filldir_t filldir)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
-	struct dentry *cursor = file->private_data;
-	int status;
-
-	DPRINTK("file=%p dentry=%p %.*s",
-		file, dentry, dentry->d_name.len, dentry->d_name.name);
-
-	if (autofs4_oz_mode(sbi))
-		goto out;
-
-	if (autofs4_ispending(dentry)) {
-		DPRINTK("dentry busy");
-		return -EBUSY;
-	}
-
-	if (d_mountpoint(dentry)) {
-		struct file *fp = cursor->d_fsdata;
-
-		if (!fp)
-			return -ENOENT;
-
-		if (!fp->f_op || !fp->f_op->readdir)
-			goto out;
-
-		status = vfs_readdir(fp, filldir, dirent);
-		file->f_pos = fp->f_pos;
-		if (status)
-			autofs4_copy_atime(file, fp);
-		return status;
-	}
 out:
-	return dcache_readdir(file, dirent, filldir);
+	return dcache_dir_open(inode, file);
 }
 
 static int try_to_fill_dentry(struct dentry *dentry, int flags)
