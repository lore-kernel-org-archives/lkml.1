Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYC2VG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYC2VG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYC2VGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:06:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:21305 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYC2VGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:06:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ix03vm9UYlC1s6zVleHchoue0Mt6orvP4mTsW4wVEk80ncoNgUOOUGg8fBCDQVAGr+lE1QnVcT8tazAOPh56fP5APJ1Y2hv3G/L/OkF3XkxhQv2rY0UA+9ioQmfuAtslBUjTQ1Pm3YHlBvTNkRerEtfdYol8GhJYH3ov0e8DpcA=
Date: Sun, 30 Mar 2008 00:02:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm 3/3] proc: drop several "PDE valid/invalid" checks
Message-ID: <20080329210257.GC16275@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc-misc code is noticeably full of "if (de)" checks when PDE passed
is always valid. Remove them.

Addition of such check in proc_lookup_de() is for failed lookup case.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |   33 ++++++++++---------------
 fs/proc/inode.c   |   69 +++++++++++++++++++++++++-----------------------------
 2 files changed, 46 insertions(+), 56 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -388,20 +388,18 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 
 	lock_kernel();
 	spin_lock(&proc_subdir_lock);
-	if (de) {
-		for (de = de->subdir; de ; de = de->next) {
-			if (de->namelen != dentry->d_name.len)
-				continue;
-			if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
-				unsigned int ino;
-
-				ino = de->low_ino;
-				de_get(de);
-				spin_unlock(&proc_subdir_lock);
-				error = -EINVAL;
-				inode = proc_get_inode(dir->i_sb, ino, de);
-				goto out_unlock;
-			}
+	for (de = de->subdir; de ; de = de->next) {
+		if (de->namelen != dentry->d_name.len)
+			continue;
+		if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
+			unsigned int ino;
+
+			ino = de->low_ino;
+			de_get(de);
+			spin_unlock(&proc_subdir_lock);
+			error = -EINVAL;
+			inode = proc_get_inode(dir->i_sb, ino, de);
+			goto out_unlock;
 		}
 	}
 	spin_unlock(&proc_subdir_lock);
@@ -413,7 +411,8 @@ out_unlock:
 		d_add(dentry, inode);
 		return NULL;
 	}
-	de_put(de);
+	if (de)
+		de_put(de);
 	return ERR_PTR(error);
 }
 
@@ -443,10 +442,6 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
 	lock_kernel();
 
 	ino = inode->i_ino;
-	if (!de) {
-		ret = -EINVAL;
-		goto out;
-	}
 	i = filp->f_pos;
 	switch (i) {
 		case 0:
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -25,8 +25,7 @@
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de)
 {
-	if (de)
-		atomic_inc(&de->count);
+	atomic_inc(&de->count);
 	return de;
 }
 
@@ -35,18 +34,16 @@ struct proc_dir_entry *de_get(struct proc_dir_entry *de)
  */
 void de_put(struct proc_dir_entry *de)
 {
-	if (de) {	
-		lock_kernel();		
-		if (!atomic_read(&de->count)) {
-			printk("de_put: entry %s already free!\n", de->name);
-			unlock_kernel();
-			return;
-		}
-
-		if (atomic_dec_and_test(&de->count))
-			free_proc_entry(de);
+	lock_kernel();		
+	if (!atomic_read(&de->count)) {
+		printk("de_put: entry %s already free!\n", de->name);
 		unlock_kernel();
+		return;
 	}
+
+	if (atomic_dec_and_test(&de->count))
+		free_proc_entry(de);
+	unlock_kernel();
 }
 
 /*
@@ -392,7 +389,7 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 {
 	struct inode * inode;
 
-	if (de != NULL && !try_module_get(de->owner))
+	if (!try_module_get(de->owner))
 		goto out_mod;
 
 	inode = iget_locked(sb, ino);
@@ -402,30 +399,29 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 		PROC_I(inode)->fd = 0;
 		PROC_I(inode)->pde = de;
-		if (de) {
-			if (de->mode) {
-				inode->i_mode = de->mode;
-				inode->i_uid = de->uid;
-				inode->i_gid = de->gid;
-			}
-			if (de->size)
-				inode->i_size = de->size;
-			if (de->nlink)
-				inode->i_nlink = de->nlink;
-			if (de->proc_iops)
-				inode->i_op = de->proc_iops;
-			if (de->proc_fops) {
-				if (S_ISREG(inode->i_mode)) {
+
+		if (de->mode) {
+			inode->i_mode = de->mode;
+			inode->i_uid = de->uid;
+			inode->i_gid = de->gid;
+		}
+		if (de->size)
+			inode->i_size = de->size;
+		if (de->nlink)
+			inode->i_nlink = de->nlink;
+		if (de->proc_iops)
+			inode->i_op = de->proc_iops;
+		if (de->proc_fops) {
+			if (S_ISREG(inode->i_mode)) {
 #ifdef CONFIG_COMPAT
-					if (!de->proc_fops->compat_ioctl)
-						inode->i_fop =
-							&proc_reg_file_ops_no_compat;
-					else
+				if (!de->proc_fops->compat_ioctl)
+					inode->i_fop =
+						&proc_reg_file_ops_no_compat;
+				else
 #endif
-						inode->i_fop = &proc_reg_file_ops;
-				} else {
-					inode->i_fop = de->proc_fops;
-				}
+					inode->i_fop = &proc_reg_file_ops;
+			} else {
+				inode->i_fop = de->proc_fops;
 			}
 		}
 		unlock_new_inode(inode);
@@ -433,8 +429,7 @@ struct inode *proc_get_inode(struct super_block *sb, unsigned int ino,
 	return inode;
 
 out_ino:
-	if (de != NULL)
-		module_put(de->owner);
+	module_put(de->owner);
 out_mod:
 	return NULL;
 }			

