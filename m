Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbXJJQfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbXJJQfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbXJJQe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:34:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57075 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbXJJQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:34:57 -0400
Subject: [RFC][PATCH 6/7] kill filp_open()
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 10 Oct 2007 09:34:45 -0700
References: <20071010163439.0F8089F7@kernel>
In-Reply-To: <20071010163439.0F8089F7@kernel>
Message-Id: <20071010163445.FB080E3B@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace all callers with open_namei() directly, and move the
nameidata stack allocation into open_namei().

Does it make sense to still call it open_namei(), even though it
doesn't actually take a nameidata any more?

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/drivers/usb/gadget/file_storage.c |    5 +-
 lxc-dave/fs/exec.c                         |    2 
 lxc-dave/fs/namei.c                        |   69 ++++++++++++++---------------
 lxc-dave/fs/open.c                         |    6 --
 lxc-dave/fs/reiserfs/journal.c             |    2 
 lxc-dave/include/linux/fs.h                |    2 
 lxc-dave/kernel/acct.c                     |    2 
 lxc-dave/mm/swapfile.c                     |    4 -
 lxc-dave/sound/sound_firmware.c            |    2 
 9 files changed, 47 insertions(+), 47 deletions(-)

diff -puN drivers/usb/gadget/file_storage.c~kill-filp_open drivers/usb/gadget/file_storage.c
--- lxc/drivers/usb/gadget/file_storage.c~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/drivers/usb/gadget/file_storage.c	2007-10-03 09:01:47.000000000 -0700
@@ -3468,16 +3468,17 @@ static int open_backing_file(struct lun 
 	struct inode			*inode = NULL;
 	loff_t				size;
 	loff_t				num_sectors;
+	int				mode = O_LARGEFILE;
 
 	/* R/W if we can, R/O if we must */
 	ro = curlun->ro;
 	if (!ro) {
-		filp = filp_open(filename, O_RDWR | O_LARGEFILE, 0);
+		filp = open_namei(AT_FDCWD, filename, O_RDWR | mode, 0);
 		if (-EROFS == PTR_ERR(filp))
 			ro = 1;
 	}
 	if (ro)
-		filp = filp_open(filename, O_RDONLY | O_LARGEFILE, 0);
+		filp = open_namei(AT_FDCWD, filename, O_RDONLY | mode, 0);
 	if (IS_ERR(filp)) {
 		LINFO(curlun, "unable to open backing file: %s\n", filename);
 		return PTR_ERR(filp);
diff -puN fs/exec.c~kill-filp_open fs/exec.c
--- lxc/fs/exec.c~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/fs/exec.c	2007-10-03 09:01:47.000000000 -0700
@@ -1764,7 +1764,7 @@ int do_coredump(long signr, int exit_cod
  			goto fail_unlock;
  		}
  	} else
- 		file = filp_open(corename,
+		file = open_namei(AT_FDCWD, corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
 	if (IS_ERR(file))
diff -puN fs/namei.c~kill-filp_open fs/namei.c
--- lxc/fs/namei.c~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-10-03 09:01:47.000000000 -0700
@@ -1729,8 +1729,9 @@ static inline int sys_open_flags_to_name
  * SMP-safe
  */
 struct file *open_namei(int dfd, const char *pathname, int sys_open_flag,
-			int mode, struct nameidata *nd)
+			int mode)
 {
+	struct nameidata nd;
 	int acc_mode, error;
 	struct path path;
 	struct dentry *dir;
@@ -1753,7 +1754,7 @@ struct file *open_namei(int dfd, const c
 	 */
 	if (!(flag & O_CREAT)) {
 		error = path_lookup_open(dfd, pathname, lookup_flags(flag),
-					 nd, flag);
+					 &nd, flag);
 		if (error)
 			return ERR_PTR(error);
 		goto ok;
@@ -1762,7 +1763,7 @@ struct file *open_namei(int dfd, const c
 	/*
 	 * Create - we need to know the parent.
 	 */
-	error = path_lookup_create(dfd,pathname,LOOKUP_PARENT,nd,flag,mode);
+	error = path_lookup_create(dfd,pathname,LOOKUP_PARENT,&nd,flag,mode);
 	if (error)
 		return ERR_PTR(error);
 
@@ -1772,14 +1773,14 @@ struct file *open_namei(int dfd, const c
 	 * will not do.
 	 */
 	error = -EISDIR;
-	if (nd->last_type != LAST_NORM || nd->last.name[nd->last.len])
+	if (nd.last_type != LAST_NORM || nd.last.name[nd.last.len])
 		goto exit;
 
-	dir = nd->dentry;
-	nd->flags &= ~LOOKUP_PARENT;
+	dir = nd.dentry;
+	nd.flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(nd);
-	path.mnt = nd->mnt;
+	path.dentry = lookup_hash(&nd);
+	path.mnt = nd.mnt;
 
 do_last:
 	error = PTR_ERR(path.dentry);
@@ -1788,17 +1789,17 @@ do_last:
 		goto exit;
 	}
 
-	if (IS_ERR(nd->intent.open.file)) {
-		error = PTR_ERR(nd->intent.open.file);
+	if (IS_ERR(nd.intent.open.file)) {
+		error = PTR_ERR(nd.intent.open.file);
 		goto exit_mutex_unlock;
 	}
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = __open_namei_create(nd, &path, flag, mode);
+		error = __open_namei_create(&nd, &path, flag, mode);
 		if (error)
 			goto exit;
-		return nameidata_to_filp(nd, sys_open_flag);
+		return nameidata_to_filp(&nd, sys_open_flag);
 	}
 
 	/*
@@ -1823,24 +1824,24 @@ do_last:
 	if (path.dentry->d_inode->i_op && path.dentry->d_inode->i_op->follow_link)
 		goto do_link;
 
-	path_to_nameidata(&path, nd);
+	path_to_nameidata(&path, &nd);
 	error = -EISDIR;
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
-	error = may_open(nd, acc_mode, flag);
+	error = may_open(&nd, acc_mode, flag);
 	if (error)
 		goto exit;
-	return nameidata_to_filp(nd, sys_open_flag);
+	return nameidata_to_filp(&nd, sys_open_flag);
 
 exit_mutex_unlock:
 	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
-	dput_path(&path, nd);
+	dput_path(&path, &nd);
 exit:
-	if (!IS_ERR(nd->intent.open.file))
-		release_open_intent(nd);
-	path_release(nd);
+	if (!IS_ERR(&nd.intent.open.file))
+		release_open_intent(&nd);
+	path_release(&nd);
 	return ERR_PTR(error);
 
 do_link:
@@ -1854,42 +1855,42 @@ do_link:
 	 * After that we have the parent and last component, i.e.
 	 * we are in the same situation as after the first path_walk().
 	 * Well, almost - if the last component is normal we get its copy
-	 * stored in nd->last.name and we will have to putname() it when we
+	 * stored in nd.last.name and we will have to putname() it when we
 	 * are done. Procfs-like symlinks just set LAST_BIND.
 	 */
-	nd->flags |= LOOKUP_PARENT;
-	error = security_inode_follow_link(path.dentry, nd);
+	nd.flags |= LOOKUP_PARENT;
+	error = security_inode_follow_link(path.dentry, &nd);
 	if (error)
 		goto exit_dput;
-	error = __do_follow_link(&path, nd);
+	error = __do_follow_link(&path, &nd);
 	if (error) {
 		/* Does someone understand code flow here? Or it is only
 		 * me so stupid? Anathema to whoever designed this non-sense
 		 * with "intent.open".
 		 */
-		release_open_intent(nd);
+		release_open_intent(&nd);
 		return ERR_PTR(error);
 	}
-	nd->flags &= ~LOOKUP_PARENT;
-	if (nd->last_type == LAST_BIND)
+	nd.flags &= ~LOOKUP_PARENT;
+	if (nd.last_type == LAST_BIND)
 		goto ok;
 	error = -EISDIR;
-	if (nd->last_type != LAST_NORM)
+	if (nd.last_type != LAST_NORM)
 		goto exit;
-	if (nd->last.name[nd->last.len]) {
-		__putname(nd->last.name);
+	if (nd.last.name[nd.last.len]) {
+		__putname(nd.last.name);
 		goto exit;
 	}
 	error = -ELOOP;
 	if (count++==32) {
-		__putname(nd->last.name);
+		__putname(nd.last.name);
 		goto exit;
 	}
-	dir = nd->dentry;
+	dir = nd.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(nd);
-	path.mnt = nd->mnt;
-	__putname(nd->last.name);
+	path.dentry = lookup_hash(&nd);
+	path.mnt = nd.mnt;
+	__putname(nd.last.name);
 	goto do_last;
 }
 
diff -puN fs/open.c~kill-filp_open fs/open.c
--- lxc/fs/open.c~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/fs/open.c	2007-10-03 09:01:47.000000000 -0700
@@ -845,8 +845,7 @@ cleanup_file:
 
 struct file *filp_open(const char *filename, int flags, int mode)
 {
-	struct nameidata nd;
-	return open_namei(AT_FDCWD, filename, flags, mode, &nd);
+	return open_namei(AT_FDCWD, filename, flags, mode);
 }
 EXPORT_SYMBOL(filp_open);
 
@@ -1050,8 +1049,7 @@ long do_sys_open(int dfd, const char __u
 
 	fd = get_unused_fd_flags(flags);
 	if (fd >= 0) {
-		struct nameidata nd;
-		struct file *f = open_namei(dfd, tmp, flags, mode, &nd);
+		struct file *f = open_namei(dfd, tmp, flags, mode);
 
 		if (IS_ERR(f)) {
 			put_unused_fd(fd);
diff -puN fs/reiserfs/journal.c~kill-filp_open fs/reiserfs/journal.c
--- lxc/fs/reiserfs/journal.c~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/fs/reiserfs/journal.c	2007-10-03 09:01:47.000000000 -0700
@@ -2623,7 +2623,7 @@ static int journal_init_dev(struct super
 		return 0;
 	}
 
-	journal->j_dev_file = filp_open(jdev_name, 0, 0);
+	journal->j_dev_file = open_namei(AT_FDCWD, jdev_name, 0, 0);
 	if (!IS_ERR(journal->j_dev_file)) {
 		struct inode *jdev_inode = journal->j_dev_file->f_mapping->host;
 		if (!S_ISBLK(jdev_inode->i_mode)) {
diff -puN include/linux/fs.h~kill-filp_open include/linux/fs.h
--- lxc/include/linux/fs.h~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/include/linux/fs.h	2007-10-03 09:01:47.000000000 -0700
@@ -1721,7 +1721,7 @@ extern struct file *create_read_pipe(str
 extern struct file *create_write_pipe(void);
 extern void free_write_pipe(struct file *);
 
-extern struct file *open_namei(int dfd, const char *, int, int, struct nameidata *);
+extern struct file *open_namei(int dfd, const char *, int, int);
 extern int may_open(struct nameidata *, int, int);
 
 extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
diff -puN kernel/acct.c~kill-filp_open kernel/acct.c
--- lxc/kernel/acct.c~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/kernel/acct.c	2007-10-03 09:01:47.000000000 -0700
@@ -208,7 +208,7 @@ static int acct_on(char *name)
 	int error;
 
 	/* Difference from BSD - they don't do O_APPEND */
-	file = filp_open(name, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
+	file = open_namei(AT_FDCWD, name, O_WRONLY|O_APPEND|O_LARGEFILE, 0);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff -puN mm/swapfile.c~kill-filp_open mm/swapfile.c
--- lxc/mm/swapfile.c~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/mm/swapfile.c	2007-10-03 09:01:47.000000000 -0700
@@ -1198,7 +1198,7 @@ asmlinkage long sys_swapoff(const char _
 	if (IS_ERR(pathname))
 		goto out;
 
-	victim = filp_open(pathname, O_RDWR|O_LARGEFILE, 0);
+	victim = open_namei(AT_FDCWD, pathname, O_RDWR|O_LARGEFILE, 0);
 	putname(pathname);
 	err = PTR_ERR(victim);
 	if (IS_ERR(victim))
@@ -1477,7 +1477,7 @@ asmlinkage long sys_swapon(const char __
 		name = NULL;
 		goto bad_swap_2;
 	}
-	swap_file = filp_open(name, O_RDWR|O_LARGEFILE, 0);
+	swap_file = open_namei(AT_FDCWD, name, O_RDWR|O_LARGEFILE, 0);
 	error = PTR_ERR(swap_file);
 	if (IS_ERR(swap_file)) {
 		swap_file = NULL;
diff -puN sound/sound_firmware.c~kill-filp_open sound/sound_firmware.c
--- lxc/sound/sound_firmware.c~kill-filp_open	2007-10-03 09:01:47.000000000 -0700
+++ lxc-dave/sound/sound_firmware.c	2007-10-03 09:01:47.000000000 -0700
@@ -14,7 +14,7 @@ static int do_mod_firmware_load(const ch
 	char *dp;
 	loff_t pos;
 
-	filp = filp_open(fn, 0, 0);
+	filp = open_namei(AT_FDCWD, fn, 0, 0);
 	if (IS_ERR(filp))
 	{
 		printk(KERN_INFO "Unable to load '%s'.\n", fn);
_
