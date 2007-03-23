Return-Path: <linux-kernel-owner+w=401wt.eu-S2992506AbXCWQKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992506AbXCWQKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992504AbXCWQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:10:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54578 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992500AbXCWQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:10:50 -0400
Subject: [Patch 2/7] integrity: fs hook placement
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, akpm@osdl.org
Content-Type: text/plain
Date: Fri, 23 Mar 2007 12:09:26 -0400
Message-Id: <1174666166.11149.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch places calls to the new integrity hooks in the appropriate
places in the fs directory. It is not meant in any way to be viewed
as a complete set, but used as a basis for an initial discussion.

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
signed-off-by: Kylene Hall <kjhall@us.ibm.com>
---
Index: linux-2.6.21-rc4-mm1/fs/ext3/xattr_security.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/fs/ext3/xattr_security.c
+++ linux-2.6.21-rc4-mm1/fs/ext3/xattr_security.c
@@ -10,6 +10,7 @@
 #include <linux/ext3_jbd.h>
 #include <linux/ext3_fs.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include "xattr.h"
 
 static size_t
@@ -58,12 +59,19 @@ ext3_init_security(handle_t *handle, str
 
 	err = security_inode_init_security(inode, dir, &name, &value, &len);
 	if (err) {
+		/* Even if creation of the security xattr fails, must
+		 * indicate this is a new inode. */
+		integrity_inode_init_integrity(inode, dir, NULL, NULL, NULL);
 		if (err == -EOPNOTSUPP)
 			return 0;
 		return err;
 	}
 	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
 				    name, value, len, 0);
+
+	integrity_inode_init_integrity(inode, dir, &name, &value, &len);
+	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
+				    name, value, len, 0);
 	kfree(name);
 	kfree(value);
 	return err;
Index: linux-2.6.21-rc4-mm1/include/linux/fs.h
===================================================================
--- linux-2.6.21-rc4-mm1.orig/include/linux/fs.h
+++ linux-2.6.21-rc4-mm1/include/linux/fs.h
@@ -591,6 +591,9 @@ struct inode {
 #ifdef CONFIG_SECURITY
 	void			*i_security;
 #endif
+#ifdef CONFIG_INTEGRITY
+	void			*i_integrity;
+#endif
 	void			*i_private; /* fs or device private pointer */
 };
 
Index: linux-2.6.21-rc4-mm1/fs/dcache.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/fs/dcache.c
+++ linux-2.6.21-rc4-mm1/fs/dcache.c
@@ -29,6 +29,7 @@
 #include <linux/file.h>
 #include <asm/uaccess.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/seqlock.h>
 #include <linux/swap.h>
 #include <linux/bootmem.h>
@@ -986,6 +987,7 @@ void d_instantiate(struct dentry *entry,
 	entry->d_inode = inode;
 	fsnotify_d_instantiate(entry, inode);
 	spin_unlock(&dcache_lock);
+	integrity_d_instantiate(entry, inode);
 	security_d_instantiate(entry, inode);
 }
 
@@ -1050,6 +1052,7 @@ struct dentry *d_instantiate_unique(stru
 	spin_unlock(&dcache_lock);
 
 	if (!result) {
+		integrity_d_instantiate(entry, inode);
 		security_d_instantiate(entry, inode);
 		return NULL;
 	}
@@ -1187,6 +1190,7 @@ struct dentry *d_splice_alias(struct ino
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
 			fsnotify_d_instantiate(new, inode);
 			spin_unlock(&dcache_lock);
+			integrity_d_instantiate(new, inode);
 			security_d_instantiate(new, inode);
 			d_rehash(dentry);
 			d_move(new, dentry);
@@ -1197,6 +1201,7 @@ struct dentry *d_splice_alias(struct ino
 			dentry->d_inode = inode;
 			fsnotify_d_instantiate(dentry, inode);
 			spin_unlock(&dcache_lock);
+			integrity_d_instantiate(dentry, inode);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1748,6 +1753,7 @@ found:
 	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
+		integrity_d_instantiate(dentry, inode);
 		security_d_instantiate(dentry, inode);
 		return NULL;
 	}
Index: linux-2.6.21-rc4-mm1/fs/file_table.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/fs/file_table.c
+++ linux-2.6.21-rc4-mm1/fs/file_table.c
@@ -13,6 +13,7 @@
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/eventpoll.h>
 #include <linux/rcupdate.h>
 #include <linux/mount.h>
@@ -169,6 +170,7 @@ void fastcall __fput(struct file *file)
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
+	integrity_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
@@ -240,6 +242,7 @@ void put_filp(struct file *file)
 {
 	if (atomic_dec_and_test(&file->f_count)) {
 		security_file_free(file);
+		integrity_file_free(file);
 		file_kill(file);
 		file_free(file);
 	}
Index: linux-2.6.21-rc4-mm1/fs/inode.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/fs/inode.c
+++ linux-2.6.21-rc4-mm1/fs/inode.c
@@ -17,6 +17,7 @@
 #include <linux/hash.h>
 #include <linux/swap.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/pagemap.h>
 #include <linux/cdev.h>
 #include <linux/bootmem.h>
@@ -142,6 +143,14 @@ static struct inode *alloc_inode(struct 
 			return NULL;
 		}
 
+		if (integrity_inode_alloc(inode)) {
+			if (inode->i_sb->s_op->destroy_inode)
+				inode->i_sb->s_op->destroy_inode(inode);
+			else
+				kmem_cache_free(inode_cachep, (inode));
+			return NULL;
+		}
+
 		mapping->a_ops = &empty_aops;
  		mapping->host = inode;
 		mapping->flags = 0;
@@ -172,6 +181,7 @@ void destroy_inode(struct inode *inode) 
 {
 	BUG_ON(inode_has_buffers(inode));
 	security_inode_free(inode);
+	integrity_inode_free(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
Index: linux-2.6.21-rc4-mm1/fs/xattr.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/fs/xattr.c
+++ linux-2.6.21-rc4-mm1/fs/xattr.c
@@ -14,6 +14,7 @@
 #include <linux/xattr.h>
 #include <linux/namei.h>
 #include <linux/security.h>
+#include <linux/integrity.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
 #include <linux/fsnotify.h>
@@ -84,11 +85,17 @@ vfs_setxattr(struct dentry *dentry, char
 	error = security_inode_setxattr(dentry, name, value, size, flags);
 	if (error)
 		goto out;
+
+	error = integrity_inode_setxattr(dentry, name, value, size, flags);
+	if (error)
+		goto out;
+
 	error = -EOPNOTSUPP;
 	if (inode->i_op->setxattr) {
 		error = inode->i_op->setxattr(dentry, name, value, size, flags);
 		if (!error) {
 			fsnotify_xattr(dentry);
+			integrity_inode_post_setxattr(dentry, name);
 			security_inode_post_setxattr(dentry, name, value,
 						     size, flags);
 		}
@@ -181,6 +188,8 @@ vfs_removexattr(struct dentry *dentry, c
 
 	mutex_lock(&inode->i_mutex);
 	error = inode->i_op->removexattr(dentry, name);
+	if (!error)
+		integrity_inode_post_setxattr(dentry, name);
 	mutex_unlock(&inode->i_mutex);
 
 	if (!error)


