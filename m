Return-Path: <linux-kernel-owner+w=401wt.eu-S1763167AbYBSEPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763167AbYBSEPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760688AbYBSEMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:12:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760339AbYBSEMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:12:34 -0500
Message-Id: <20080219040829.836560927@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:45 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 10/11] split out libfs/inode.c from libfs.c
Content-Disposition: inline; filename=libfs-inode.diff
X-Provags-ID: V01U2FsdGVkX1+PP5EWEXVRC+tnP1zDdwNHIFFuRpkXZNY2xhe
 0UEpGS0MBum2Uio+MCInjjwjdcf8qeF40Jd9SMsq7B7L6qu5zM
 NHDl2Xe+ok1oma7VBY7nQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all inode manipulation code in libfs in a single
source file.

Signed-off-by: Arnd Bergman <arnd@arndb.de>

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -12,78 +12,6 @@
 
 #include <asm/uaccess.h>
 
-int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
-{
-	struct inode *inode = old_dentry->d_inode;
-
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	inc_nlink(inode);
-	atomic_inc(&inode->i_count);
-	dget(dentry);
-	d_instantiate(dentry, inode);
-	return 0;
-}
-
-int simple_empty(struct dentry *dentry)
-{
-	struct dentry *child;
-	int ret = 0;
-
-	spin_lock(&dcache_lock);
-	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child)
-		if (simple_positive(child))
-			goto out;
-	ret = 1;
-out:
-	spin_unlock(&dcache_lock);
-	return ret;
-}
-
-int simple_unlink(struct inode *dir, struct dentry *dentry)
-{
-	struct inode *inode = dentry->d_inode;
-
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
-	drop_nlink(inode);
-	dput(dentry);
-	return 0;
-}
-
-int simple_rmdir(struct inode *dir, struct dentry *dentry)
-{
-	if (!simple_empty(dentry))
-		return -ENOTEMPTY;
-
-	drop_nlink(dentry->d_inode);
-	simple_unlink(dir, dentry);
-	drop_nlink(dir);
-	return 0;
-}
-
-int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
-{
-	struct inode *inode = old_dentry->d_inode;
-	int they_are_dirs = S_ISDIR(old_dentry->d_inode->i_mode);
-
-	if (!simple_empty(new_dentry))
-		return -ENOTEMPTY;
-
-	if (new_dentry->d_inode) {
-		simple_unlink(new_dir, new_dentry);
-		if (they_are_dirs)
-			drop_nlink(old_dir);
-	} else if (they_are_dirs) {
-		drop_nlink(old_dir);
-		inc_nlink(new_dir);
-	}
-
-	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
-		new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;
-
-	return 0;
-}
-
 int simple_readpage(struct file *file, struct page *page)
 {
 	clear_highpage(page);
@@ -183,11 +111,6 @@ ssize_t simple_read_from_buffer(void __u
 
 EXPORT_SYMBOL(simple_write_begin);
 EXPORT_SYMBOL(simple_write_end);
-EXPORT_SYMBOL(simple_empty);
-EXPORT_SYMBOL(simple_link);
 EXPORT_SYMBOL(simple_prepare_write);
 EXPORT_SYMBOL(simple_readpage);
-EXPORT_SYMBOL(simple_rename);
-EXPORT_SYMBOL(simple_rmdir);
-EXPORT_SYMBOL(simple_unlink);
 EXPORT_SYMBOL(simple_read_from_buffer);
Index: linux-2.6/fs/libfs/inode.c
===================================================================
--- linux-2.6.orig/fs/libfs/inode.c
+++ linux-2.6/fs/libfs/inode.c
@@ -417,4 +417,79 @@ exit:
 }
 EXPORT_SYMBOL_GPL(simple_rename_named);
 
+int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
 
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	inc_nlink(inode);
+	atomic_inc(&inode->i_count);
+	dget(dentry);
+	d_instantiate(dentry, inode);
+	return 0;
+}
+EXPORT_SYMBOL(simple_link);
+
+int simple_empty(struct dentry *dentry)
+{
+	struct dentry *child;
+	int ret = 0;
+
+	spin_lock(&dcache_lock);
+	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child)
+		if (simple_positive(child))
+			goto out;
+	ret = 1;
+out:
+	spin_unlock(&dcache_lock);
+	return ret;
+}
+EXPORT_SYMBOL(simple_empty);
+
+int simple_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+
+	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+	drop_nlink(inode);
+	dput(dentry);
+	return 0;
+}
+EXPORT_SYMBOL(simple_unlink);
+
+int simple_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	if (!simple_empty(dentry))
+		return -ENOTEMPTY;
+
+	drop_nlink(dentry->d_inode);
+	simple_unlink(dir, dentry);
+	drop_nlink(dir);
+	return 0;
+}
+EXPORT_SYMBOL(simple_rmdir);
+
+int simple_rename(struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct inode *inode = old_dentry->d_inode;
+	int they_are_dirs = S_ISDIR(old_dentry->d_inode->i_mode);
+
+	if (!simple_empty(new_dentry))
+		return -ENOTEMPTY;
+
+	if (new_dentry->d_inode) {
+		simple_unlink(new_dir, new_dentry);
+		if (they_are_dirs)
+			drop_nlink(old_dir);
+	} else if (they_are_dirs) {
+		drop_nlink(old_dir);
+		inc_nlink(new_dir);
+	}
+
+	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
+		new_dir->i_mtime = inode->i_ctime = CURRENT_TIME;
+
+	return 0;
+}
+EXPORT_SYMBOL(simple_rename);

-- 

