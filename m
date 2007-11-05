Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbXKEQeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbXKEQeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXKEQdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:33:37 -0500
Received: from ns.suse.de ([195.135.220.2]:44630 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbXKEQdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:33:32 -0500
Message-Id: <20071105163234.688960656@hasse.suse.de>
User-Agent: quilt/0.46-1
Date: Mon, 05 Nov 2007 17:32:41 +0100
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 9/9] d_path: Make d_path() use a struct path
References: <20071105163232.550298985@hasse.suse.de>
Content-Disposition: inline; filename=vfs/d_path-use_struct_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

d_path() is used on a <dentry,vfsmount> pair. Lets use a struct path to
reflect this.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---
 arch/blackfin/kernel/traps.c      |   12 +++++-------
 drivers/md/bitmap.c               |    8 +-------
 drivers/usb/gadget/file_storage.c |    8 +++-----
 fs/compat_ioctl.c                 |    2 +-
 fs/dcache.c                       |   12 +++++-------
 fs/dcookies.c                     |    2 +-
 fs/ecryptfs/super.c               |    5 ++---
 fs/nfsd/export.c                  |    3 ++-
 fs/proc/base.c                    |    2 +-
 fs/seq_file.c                     |    4 +++-
 fs/sysfs/file.c                   |    5 ++---
 fs/unionfs/super.c                |    3 +--
 include/linux/dcache.h            |    5 +++--
 kernel/audit.c                    |    2 +-
 14 files changed, 31 insertions(+), 42 deletions(-)

Index: b/arch/blackfin/kernel/traps.c
===================================================================
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -98,15 +98,13 @@ static int printk_address(unsigned long 
 			struct vm_area_struct *vma = vml->vma;
 
 			if (address >= vma->vm_start && address < vma->vm_end) {
+				char _tmpbuf[256];
 				char *name = p->comm;
 				struct file *file = vma->vm_file;
-				if (file) {
-					char _tmpbuf[256];
-					name = d_path(file->f_dentry,
-					              file->f_vfsmnt,
-					              _tmpbuf,
-					              sizeof(_tmpbuf));
-				}
+
+				if (file)
+					name = d_path(&file->f_path, _tmpbuf,
+						      sizeof(_tmpbuf));
 
 				/* FLAT does not have its text aligned to the start of
 				 * the map while FDPIC ELF does ...
Index: b/drivers/md/bitmap.c
===================================================================
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -206,16 +206,10 @@ static void bitmap_checkfree(struct bitm
 /* copy the pathname of a file to a buffer */
 char *file_path(struct file *file, char *buf, int count)
 {
-	struct dentry *d;
-	struct vfsmount *v;
-
 	if (!buf)
 		return NULL;
 
-	d = file->f_path.dentry;
-	v = file->f_path.mnt;
-
-	buf = d_path(d, v, buf, count);
+	buf = d_path(&file->f_path, buf, count);
 
 	return IS_ERR(buf) ? NULL : buf;
 }
Index: b/drivers/usb/gadget/file_storage.c
===================================================================
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3567,8 +3567,7 @@ static ssize_t show_file(struct device *
 
 	down_read(&fsg->filesem);
 	if (backing_file_is_open(curlun)) {	// Get the complete pathname
-		p = d_path(curlun->filp->f_path.dentry,
-				curlun->filp->f_path.mnt, buf, PAGE_SIZE - 1);
+		p = d_path(&curlun->filp->f_path, buf, PAGE_SIZE - 1);
 		if (IS_ERR(p))
 			rc = PTR_ERR(p);
 		else {
@@ -3985,9 +3984,8 @@ static int __init fsg_bind(struct usb_ga
 		if (backing_file_is_open(curlun)) {
 			p = NULL;
 			if (pathbuf) {
-				p = d_path(curlun->filp->f_path.dentry,
-					curlun->filp->f_path.mnt,
-					pathbuf, PATH_MAX);
+				p = d_path(&curlun->filp->f_path,
+					   pathbuf, PATH_MAX);
 				if (IS_ERR(p))
 					p = NULL;
 			}
Index: b/fs/compat_ioctl.c
===================================================================
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -3544,7 +3544,7 @@ static void compat_ioctl_error(struct fi
 	/* find the name of the device. */
 	path = (char *)__get_free_page(GFP_KERNEL);
 	if (path) {
-		fn = d_path(filp->f_path.dentry, filp->f_path.mnt, path, PAGE_SIZE);
+		fn = d_path(&filp->f_path, path, PAGE_SIZE);
 		if (IS_ERR(fn))
 			fn = "?";
 	}
Index: b/fs/dcache.c
===================================================================
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1831,8 +1831,7 @@ Elong:
 
 /**
  * d_path - return the path of a dentry
- * @dentry: dentry to report
- * @vfsmnt: vfsmnt to which the dentry belongs
+ * @path: path to report
  * @buf: buffer to return value in
  * @buflen: buffer length
  *
@@ -1843,8 +1842,7 @@ Elong:
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  */
-char *d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-	     char *buf, int buflen)
+char *d_path(struct path *path, char *buf, int buflen)
 {
 	char *res;
 	struct path root;
@@ -1856,15 +1854,15 @@ char *d_path(struct dentry *dentry, stru
 	 * user wants to identify the object in /proc/pid/fd/.  The little hack
 	 * below allows us to generate a name for these objects on demand:
 	 */
-	if (dentry->d_op && dentry->d_op->d_dname)
-		return dentry->d_op->d_dname(dentry, buf, buflen);
+	if (path->dentry->d_op && path->dentry->d_op->d_dname)
+		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	read_lock(&current->fs->lock);
 	root = current->fs->root;
 	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, &root, buf, buflen);
+	res = __d_path(path->dentry, path->mnt, &root, buf, buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
Index: b/fs/dcookies.c
===================================================================
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -170,7 +170,7 @@ asmlinkage long sys_lookup_dcookie(u64 c
 		goto out;
 
 	/* FIXME: (deleted) ? */
-	path = d_path(dcs->path.dentry, dcs->path.mnt, kbuf, PAGE_SIZE);
+	path = d_path(&dcs->path, kbuf, PAGE_SIZE);
 
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
Index: b/fs/ecryptfs/super.c
===================================================================
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -163,8 +163,7 @@ static void ecryptfs_clear_inode(struct 
 static int ecryptfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
-	struct dentry *lower_root_dentry = ecryptfs_dentry_to_lower(sb->s_root);
-	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(sb->s_root);
+	struct path *lower_root = &ecryptfs_dentry_to_private(sb->s_root)->lower_path;
 	char *tmp_page;
 	char *path;
 	int rc = 0;
@@ -174,7 +173,7 @@ static int ecryptfs_show_options(struct 
 		rc = -ENOMEM;
 		goto out;
 	}
-	path = d_path(lower_root_dentry, lower_mnt, tmp_page, PAGE_SIZE);
+	path = d_path(lower_root, tmp_page, PAGE_SIZE);
 	if (IS_ERR(path)) {
 		rc = PTR_ERR(path);
 		goto out;
Index: b/fs/nfsd/export.c
===================================================================
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -345,7 +345,7 @@ static void svc_export_request(struct ca
 	char *pth;
 
 	qword_add(bpp, blen, exp->ex_client->name);
-	pth = d_path(exp->ex_path.dentry, exp->ex_path.mnt, *bpp, *blen);
+	pth = d_path(&exp->ex_path, *bpp, *blen);
 	if (IS_ERR(pth)) {
 		/* is this correct? */
 		(*bpp)[0] = '\n';
Index: b/fs/proc/base.c
===================================================================
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1054,7 +1054,7 @@ static int do_proc_readlink(struct path 
 	if (!tmp)
 		return -ENOMEM;
 
-	pathname = d_path(path->dentry, path->mnt, tmp, PAGE_SIZE);
+	pathname = d_path(path, tmp, PAGE_SIZE);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;
Index: b/fs/seq_file.c
===================================================================
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -353,8 +353,7 @@ int seq_path(struct seq_file *m, struct 
 {
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
-		char *p = d_path(path->dentry, path->mnt, s,
-				 m->size - m->count);
+		char *p = d_path(path, s, m->size - m->count);
 		if (!IS_ERR(p)) {
 			while (s <= p) {
 				char c = *p++;
Index: b/fs/sysfs/file.c
===================================================================
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -355,9 +355,8 @@ static int sysfs_open_file(struct inode 
 	int error;
 	char *p;
 
-	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
-		   sizeof(last_sysfs_file));
-	if (p)
+	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
+	if (!IS_ERR(p))
 		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	/* need attr_sd for attr and ops, its parent for kobj */
Index: b/fs/unionfs/super.c
===================================================================
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -974,8 +974,7 @@ static int unionfs_show_options(struct s
 
 	seq_printf(m, ",dirs=");
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		path = d_path(unionfs_lower_dentry_idx(sb->s_root, bindex),
-			      unionfs_lower_mnt_idx(sb->s_root, bindex),
+		path = d_path(&UNIONFS_D(sb->s_root)->lower_paths[bindex],
 			      tmp_page, PAGE_SIZE);
 		if (IS_ERR(path)) {
 			ret = PTR_ERR(path);
Index: b/include/linux/dcache.h
===================================================================
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -10,6 +10,7 @@
 #include <linux/rcupdate.h>
 
 struct nameidata;
+struct path;
 struct vfsmount;
 
 /*
@@ -300,8 +301,8 @@ extern int d_validate(struct dentry *, s
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
-extern char * d_path(struct dentry *, struct vfsmount *, char *, int);
-  
+extern char *d_path(struct path *, char *, int);
+
 /* Allocation counts.. */
 
 /**
Index: b/kernel/audit.c
===================================================================
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1407,7 +1407,7 @@ void audit_log_d_path(struct audit_buffe
 		audit_log_format(ab, "<no memory>");
 		return;
 	}
-	p = d_path(path->dentry, path->mnt, pathname, PATH_MAX+11);
+	p = d_path(path, pathname, PATH_MAX+11);
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");


