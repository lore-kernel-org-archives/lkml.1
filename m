Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbXJDQAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbXJDQAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759775AbXJDP53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 11:57:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759631AbXJDP5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 11:57:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/32] IGET: Mark iget() and read_inode() as being obsolete
	[try #2]
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Thu, 04 Oct 2007 16:56:32 +0100
Message-ID: <20071004155632.2814.55633.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark iget() and read_inode() as being obsolete and remove references to them
from the documentation.

Typically a filesystem will be modified such that the read_inode function
becomes an internal iget function, for example the following:

	void thingyfs_read_inode(struct inode *inode)
	{
		...
	}

would be changed into something like:

	struct inode *thingyfs_iget(struct super_block *sp, unsigned long ino)
	{
		struct inode *inode;
		int ret;
		
		inode = iget_locked(sb, ino);
		if (!inode)
			return ERR_PTR(-ENOMEM);
		if (!(inode->i_state & I_NEW))
			return inode;

		...
		unlock_new_inode(inode);
		return inode;
	error:
		iget_failed(inode);
		return ERR_PTR(ret);
	}

and then thingyfs_iget() would be called rather than iget(), for example:

	ret = -EINVAL;
	inode = iget(sb, ino);
	if (!inode || is_bad_inode(inode))
		goto error;

becomes:

	inode = thingyfs_iget(sb, ino);
	if (IS_ERR(inode)) {
		ret = PTR_ERR(inode);
		goto error;
	}

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/Exporting |    5 -----
 Documentation/filesystems/Locking   |    3 ---
 Documentation/filesystems/vfs.txt   |   16 +++++-----------
 fs/inode.c                          |   16 ++++++++++++++++
 include/linux/fs.h                  |   16 +++-------------
 5 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/Documentation/filesystems/Exporting b/Documentation/filesystems/Exporting
index 31047e0..22ce3b2 100644
--- a/Documentation/filesystems/Exporting
+++ b/Documentation/filesystems/Exporting
@@ -144,11 +144,6 @@ filesystem:
     decode_fh passes two datums through find_exported_dentry.  One that 
     should be used to identify the target object, and one that can be
     used to identify the object's parent, should that be necessary.
-    The default get_dentry function assumes that the datum contains an
-    inode number and a generation number, and it attempts to get the
-    inode using "iget" and check it's validity by matching the
-    generation number.  A filesystem should only depend on the default
-    if iget can safely be used this way.
 
 If decode_fh and/or encode_fh are left as NULL, then default
 implementations are used.  These defaults are suitable for ext2 and 
diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index f0f8258..d155893 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -90,7 +90,6 @@ of the locking scheme for directory operations.
 prototypes:
 	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
-	void (*read_inode) (struct inode *);
 	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*put_inode) (struct inode *);
@@ -114,7 +113,6 @@ locking rules:
 			BKL	s_lock	s_umount
 alloc_inode:		no	no	no
 destroy_inode:		no
-read_inode:		no				(see below)
 dirty_inode:		no				(must not sleep)
 write_inode:		no
 put_inode:		no
@@ -133,7 +131,6 @@ show_options:		no				(vfsmount->sem)
 quota_read:		no	no	no		(see below)
 quota_write:		no	no	no		(see below)
 
-->read_inode() is not a method - it's a callback used in iget().
 ->remount_fs() will have the s_umount lock if it's already mounted.
 When called from get_sb_single, it does NOT have the s_umount lock.
 ->quota_read() and ->quota_write() functions are both guaranteed to
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 045f3e0..63c7e91 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -242,14 +242,8 @@ or bottom half).
   	->alloc_inode was defined and simply undoes anything done by
 	->alloc_inode.
 
-  read_inode: this method is called to read a specific inode from the
-        mounted filesystem.  The i_ino member in the struct inode is
-	initialized by the VFS to indicate which inode to read. Other
-	members are filled in by this method.
-
-	You can set this to NULL and use iget5_locked() instead of iget()
-	to read inodes.  This is necessary for filesystems for which the
-	inode number is not sufficient to identify an inode.
+  read_inode: deprecated, do not use.  Use iget_locked() instead of iget() and
+	return a proper error value.
 
   dirty_inode: this method is called by the VFS to mark an inode dirty.
 
@@ -308,9 +302,9 @@ or bottom half).
 
   quota_write: called by the VFS to write to filesystem quota file.
 
-The read_inode() method is responsible for filling in the "i_op"
-field. This is a pointer to a "struct inode_operations" which
-describes the methods that can be performed on individual inodes.
+Whoever sets up the inode is responsible for filling in the "i_op" field. This
+is a pointer to a "struct inode_operations" which describes the methods that
+can be performed on individual inodes.
 
 
 The Inode Object
diff --git a/fs/inode.c b/fs/inode.c
index 29f5068..f78db20 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1427,3 +1427,19 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 		       mode);
 }
 EXPORT_SYMBOL(init_special_inode);
+
+/*
+ * old deprecated inode creator
+ */
+struct inode *iget(struct super_block *sb, unsigned long ino)
+{
+	struct inode *inode = iget_locked(sb, ino);
+	
+	if (inode && (inode->i_state & I_NEW)) {
+		sb->s_op->read_inode(inode);
+		unlock_new_inode(inode);
+	}
+
+	return inode;
+}
+EXPORT_SYMBOL(iget);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c24d433..dfa07d2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1181,7 +1181,7 @@ struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
-	void (*read_inode) (struct inode *);
+	void (*read_inode) (struct inode *) __deprecated;
   
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
@@ -1618,18 +1618,8 @@ extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*te
 extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern void unlock_new_inode(struct inode *);
 
-static inline struct inode *iget(struct super_block *sb, unsigned long ino)
-{
-	struct inode *inode = iget_locked(sb, ino);
-	
-	if (inode && (inode->i_state & I_NEW)) {
-		sb->s_op->read_inode(inode);
-		unlock_new_inode(inode);
-	}
-
-	return inode;
-}
-
+extern struct inode *iget(struct super_block *sb, unsigned long ino)
+	__deprecated;
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);

