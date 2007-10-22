Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbXJVHEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbXJVHEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbXJVHEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:04:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49641 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbXJVHEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:04:23 -0400
Date: Mon, 22 Oct 2007 12:34:19 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] Rename {__}d_path() to {__}print_path() and fix comments
Message-ID: <20071022070419.GN6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes the name of d_path() and __d_path() to print_path() and __print_path()
respectively and fixes the kerneldoc comments for print_path().

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 arch/blackfin/kernel/traps.c      |    2 -
 drivers/md/bitmap.c               |    2 -
 drivers/usb/gadget/file_storage.c |    4 +--
 fs/compat_ioctl.c                 |    3 +-
 fs/dcache.c                       |   41 +++++++++++++++++---------------------
 fs/dcookies.c                     |    2 -
 fs/ecryptfs/super.c               |    2 -
 fs/nfsd/export.c                  |    2 -
 fs/proc/base.c                    |    2 -
 fs/seq_file.c                     |    2 -
 fs/sysfs/file.c                   |    2 -
 fs/unionfs/super.c                |    2 -
 include/linux/dcache.h            |    2 -
 kernel/audit.c                    |    2 -
 14 files changed, 34 insertions(+), 36 deletions(-)

--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -102,7 +102,7 @@ static int printk_address(unsigned long 
 				struct file *file = vma->vm_file;
 				if (file) {
 					char _tmpbuf[256];
-					name = d_path(file->f_dentry,
+					name = print_path(file->f_dentry,
 					              file->f_vfsmnt,
 					              _tmpbuf,
 					              sizeof(_tmpbuf));
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -215,7 +215,7 @@ char *file_path(struct file *file, char 
 	d = file->f_path.dentry;
 	v = file->f_path.mnt;
 
-	buf = d_path(d, v, buf, count);
+	buf = print_path(d, v, buf, count);
 
 	return IS_ERR(buf) ? NULL : buf;
 }
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3567,7 +3567,7 @@ static ssize_t show_file(struct device *
 
 	down_read(&fsg->filesem);
 	if (backing_file_is_open(curlun)) {	// Get the complete pathname
-		p = d_path(curlun->filp->f_path.dentry,
+		p = print_path(curlun->filp->f_path.dentry,
 				curlun->filp->f_path.mnt, buf, PAGE_SIZE - 1);
 		if (IS_ERR(p))
 			rc = PTR_ERR(p);
@@ -3985,7 +3985,7 @@ static int __init fsg_bind(struct usb_ga
 		if (backing_file_is_open(curlun)) {
 			p = NULL;
 			if (pathbuf) {
-				p = d_path(curlun->filp->f_path.dentry,
+				p = print_path(curlun->filp->f_path.dentry,
 					curlun->filp->f_path.mnt,
 					pathbuf, PATH_MAX);
 				if (IS_ERR(p))
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -3544,7 +3544,8 @@ static void compat_ioctl_error(struct fi
 	/* find the name of the device. */
 	path = (char *)__get_free_page(GFP_KERNEL);
 	if (path) {
-		fn = d_path(filp->f_path.dentry, filp->f_path.mnt, path, PAGE_SIZE);
+		fn = print_path(filp->f_path.dentry, filp->f_path.mnt,
+				path, PAGE_SIZE);
 		if (IS_ERR(fn))
 			fn = "?";
 	}
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1762,23 +1762,7 @@ shouldnt_be_hashed:
 	goto shouldnt_be_hashed;
 }
 
-/**
- * d_path - return the path of a dentry
- * @dentry: dentry to report
- * @vfsmnt: vfsmnt to which the dentry belongs
- * @root: root dentry
- * @rootmnt: vfsmnt to which the root dentry belongs
- * @buffer: buffer to return value in
- * @buflen: buffer length
- *
- * Convert a dentry into an ASCII path name. If the entry has been deleted
- * the string " (deleted)" is appended. Note that this is ambiguous.
- *
- * Returns the buffer or an error code if the path was too long.
- *
- * "buflen" should be positive. Caller holds the dcache_lock.
- */
-static char * __d_path( struct dentry *dentry, struct vfsmount *vfsmnt,
+static char *__print_path( struct dentry *dentry, struct vfsmount *vfsmnt,
 			struct path *root, char *buffer, int buflen)
 {
 	char * end = buffer+buflen;
@@ -1845,8 +1829,21 @@ Elong:
 	return ERR_PTR(-ENAMETOOLONG);
 }
 
-/* write full pathname into buffer and return start of pathname */
-char * d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
+/**
+ * print_path - return the path of a dentry
+ * @dentry: dentry to report
+ * @vfsmnt: vfsmnt to which the dentry belongs
+ * @buffer: buffer to return value in
+ * @buflen: buffer length
+ *
+ * Convert a dentry into an ASCII path name. If the entry has been deleted
+ * the string " (deleted)" is appended. Note that this is ambiguous.
+ *
+ * Returns the buffer or an error code if the path was too long.
+ *
+ * "buflen" should be positive.
+ */
+char *print_path(struct dentry *dentry, struct vfsmount *vfsmnt,
 				char *buf, int buflen)
 {
 	char *res;
@@ -1867,7 +1864,7 @@ char * d_path(struct dentry *dentry, str
 	path_get(&current->fs->root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(dentry, vfsmnt, &root, buf, buflen);
+	res = __print_path(dentry, vfsmnt, &root, buf, buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -1935,7 +1932,7 @@ asmlinkage long sys_getcwd(char __user *
 		unsigned long len;
 		char * cwd;
 
-		cwd = __d_path(pwd.dentry, pwd.mnt, &root, page, PAGE_SIZE);
+		cwd = __print_path(pwd.dentry, pwd.mnt, &root, page, PAGE_SIZE);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
@@ -2179,7 +2176,7 @@ EXPORT_SYMBOL(d_invalidate);
 EXPORT_SYMBOL(d_lookup);
 EXPORT_SYMBOL(d_move);
 EXPORT_SYMBOL_GPL(d_materialise_unique);
-EXPORT_SYMBOL(d_path);
+EXPORT_SYMBOL(print_path);
 EXPORT_SYMBOL(d_prune_aliases);
 EXPORT_SYMBOL(d_rehash);
 EXPORT_SYMBOL(d_splice_alias);
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -174,7 +174,7 @@ asmlinkage long sys_lookup_dcookie(u64 c
 		goto out;
 
 	/* FIXME: (deleted) ? */
-	path = d_path(dcs->dentry, dcs->vfsmnt, kbuf, PAGE_SIZE);
+	path = print_path(dcs->dentry, dcs->vfsmnt, kbuf, PAGE_SIZE);
 
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -174,7 +174,7 @@ static int ecryptfs_show_options(struct 
 		rc = -ENOMEM;
 		goto out;
 	}
-	path = d_path(lower_root_dentry, lower_mnt, tmp_page, PAGE_SIZE);
+	path = print_path(lower_root_dentry, lower_mnt, tmp_page, PAGE_SIZE);
 	if (IS_ERR(path)) {
 		rc = PTR_ERR(path);
 		goto out;
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -349,7 +349,7 @@ static void svc_export_request(struct ca
 	char *pth;
 
 	qword_add(bpp, blen, exp->ex_client->name);
-	pth = d_path(exp->ex_dentry, exp->ex_mnt, *bpp, *blen);
+	pth = print_path(exp->ex_dentry, exp->ex_mnt, *bpp, *blen);
 	if (IS_ERR(pth)) {
 		/* is this correct? */
 		(*bpp)[0] = '\n';
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1056,7 +1056,7 @@ static int do_proc_readlink(struct path 
 		return -ENOMEM;
 
 	inode = path->dentry->d_inode;
-	pathname = d_path(path->dentry, path->mnt, tmp, PAGE_SIZE);
+	pathname = print_path(path->dentry, path->mnt, tmp, PAGE_SIZE);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -355,7 +355,7 @@ int seq_path(struct seq_file *m,
 {
 	if (m->count < m->size) {
 		char *s = m->buf + m->count;
-		char *p = d_path(dentry, mnt, s, m->size - m->count);
+		char *p = print_path(dentry, mnt, s, m->size - m->count);
 		if (!IS_ERR(p)) {
 			while (s <= p) {
 				char c = *p++;
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -355,7 +355,7 @@ static int sysfs_open_file(struct inode 
 	int error;
 	char *p;
 
-	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
+	p = print_path(file->f_dentry, sysfs_mount, last_sysfs_file,
 		   sizeof(last_sysfs_file));
 	if (p)
 		memmove(last_sysfs_file, p, strlen(p) + 1);
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -975,7 +975,7 @@ static int unionfs_show_options(struct s
 
 	seq_printf(m, ",dirs=");
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		path = d_path(unionfs_lower_dentry_idx(sb->s_root, bindex),
+		path = print_path(unionfs_lower_dentry_idx(sb->s_root, bindex),
 			      unionfs_lower_mnt_idx(sb->s_root, bindex),
 			      tmp_page, PAGE_SIZE);
 		if (IS_ERR(path)) {
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -300,7 +300,7 @@ extern int d_validate(struct dentry *, s
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
-extern char * d_path(struct dentry *, struct vfsmount *, char *, int);
+extern char *print_path(struct dentry *, struct vfsmount *, char *, int);
   
 /* Allocation counts.. */
 
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1407,7 +1407,7 @@ void audit_log_d_path(struct audit_buffe
 		audit_log_format(ab, "<no memory>");
 		return;
 	}
-	p = d_path(dentry, vfsmnt, path, PATH_MAX+11);
+	p = print_path(dentry, vfsmnt, path, PATH_MAX+11);
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");
