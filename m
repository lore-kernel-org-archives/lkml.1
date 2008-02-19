Return-Path: <linux-kernel-owner+w=401wt.eu-S1762301AbYBSEN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762301AbYBSEN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbYBSEL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:11:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:58476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYBSELw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:11:52 -0500
Message-Id: <20080219040829.668040560@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:44 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 09/11] split out libfs/super.c from libfs.c
Content-Disposition: inline; filename=libfs-super.o
X-Provags-ID: V01U2FsdGVkX18u+OQ5iPb1B708TniclV8PdElxHAXwP6g8OLV
 jUHSegfhLfUaRCFgxK2eLpnt73NoqwmSXvdmkv73VDjLdbn6hn
 abS44wS9FUg8PISwNEgSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all super block manipulation code in libfs in a single
source file.

Signed-off-by: Arnd Bergman <arnd@arndb.de>
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -12,63 +12,6 @@
 
 #include <asm/uaccess.h>
 
-static const struct super_operations simple_super_operations = {
-	.statfs		= simple_statfs,
-};
-
-/*
- * Common helper for pseudo-filesystems (sockfs, pipefs, bdev - stuff that
- * will never be mountable)
- */
-int get_sb_pseudo(struct file_system_type *fs_type, char *name,
-	const struct super_operations *ops, unsigned long magic,
-	struct vfsmount *mnt)
-{
-	struct super_block *s = sget(fs_type, NULL, set_anon_super, NULL);
-	struct dentry *dentry;
-	struct inode *root;
-	struct qstr d_name = {.name = name, .len = strlen(name)};
-
-	if (IS_ERR(s))
-		return PTR_ERR(s);
-
-	s->s_flags = MS_NOUSER;
-	s->s_maxbytes = ~0ULL;
-	s->s_blocksize = 1024;
-	s->s_blocksize_bits = 10;
-	s->s_magic = magic;
-	s->s_op = ops ? ops : &simple_super_operations;
-	s->s_time_gran = 1;
-	root = new_inode(s);
-	if (!root)
-		goto Enomem;
-	/*
-	 * since this is the first inode, make it number 1. New inodes created
-	 * after this must take care not to collide with it (by passing
-	 * max_reserved of 1 to iunique).
-	 */
-	root->i_ino = 1;
-	root->i_mode = S_IFDIR | S_IRUSR | S_IWUSR;
-	root->i_uid = root->i_gid = 0;
-	root->i_atime = root->i_mtime = root->i_ctime = CURRENT_TIME;
-	dentry = d_alloc(NULL, &d_name);
-	if (!dentry) {
-		iput(root);
-		goto Enomem;
-	}
-	dentry->d_sb = s;
-	dentry->d_parent = dentry;
-	d_instantiate(dentry, root);
-	s->s_root = dentry;
-	s->s_flags |= MS_ACTIVE;
-	return simple_set_mnt(mnt, s);
-
-Enomem:
-	up_write(&s->s_umount);
-	deactivate_super(s);
-	return -ENOMEM;
-}
-
 int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
@@ -238,7 +181,6 @@ ssize_t simple_read_from_buffer(void __u
 	return count;
 }
 
-EXPORT_SYMBOL(get_sb_pseudo);
 EXPORT_SYMBOL(simple_write_begin);
 EXPORT_SYMBOL(simple_write_end);
 EXPORT_SYMBOL(simple_empty);
Index: linux-2.6/fs/libfs/super.c
===================================================================
--- linux-2.6.orig/fs/libfs/super.c
+++ linux-2.6/fs/libfs/super.c
@@ -54,6 +54,60 @@ static const struct super_operations sim
 };
 
 /*
+ * Common helper for pseudo-filesystems (sockfs, pipefs, bdev - stuff that
+ * will never be mountable)
+ */
+int get_sb_pseudo(struct file_system_type *fs_type, char *name,
+	const struct super_operations *ops, unsigned long magic,
+	struct vfsmount *mnt)
+{
+	struct super_block *s = sget(fs_type, NULL, set_anon_super, NULL);
+	struct dentry *dentry;
+	struct inode *root;
+	struct qstr d_name = {.name = name, .len = strlen(name)};
+
+	if (IS_ERR(s))
+		return PTR_ERR(s);
+
+	s->s_flags = MS_NOUSER;
+	s->s_maxbytes = ~0ULL;
+	s->s_blocksize = 1024;
+	s->s_blocksize_bits = 10;
+	s->s_magic = magic;
+	s->s_op = ops ? ops : &simple_super_operations;
+	s->s_time_gran = 1;
+	root = new_inode(s);
+	if (!root)
+		goto Enomem;
+	/*
+	 * since this is the first inode, make it number 1. New inodes created
+	 * after this must take care not to collide with it (by passing
+	 * max_reserved of 1 to iunique).
+	 */
+	root->i_ino = 1;
+	root->i_mode = S_IFDIR | S_IRUSR | S_IWUSR;
+	root->i_uid = root->i_gid = 0;
+	root->i_atime = root->i_mtime = root->i_ctime = CURRENT_TIME;
+	dentry = d_alloc(NULL, &d_name);
+	if (!dentry) {
+		iput(root);
+		goto Enomem;
+	}
+	dentry->d_sb = s;
+	dentry->d_parent = dentry;
+	d_instantiate(dentry, root);
+	s->s_root = dentry;
+	s->s_flags |= MS_ACTIVE;
+	return simple_set_mnt(mnt, s);
+
+Enomem:
+	up_write(&s->s_umount);
+	deactivate_super(s);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(get_sb_pseudo);
+
+/*
  * the inodes created here are not hashed. If you use iunique to generate
  * unique inode values later for this filesystem, then you must take care
  * to pass it an appropriate max_reserved value to avoid collisions.

-- 

