Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbXJLJYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbXJLJYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbXJLJJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:09:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760355AbXJLJJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:09:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 31/31] IGET: Remove iget() and the read_inode() super op as
	being obsolete [try #4]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 12 Oct 2007 10:09:47 +0100
Message-ID: <20071012090946.3442.90746.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
References: <20071012090709.3442.69133.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the old iget() call and the read_inode() superblock operation it uses
as these are really obsolete, and the use of read_inode() does not produce
proper error handling (no distinction between ENOMEM and EIO when marking
an inode bad).

Furthermore, this removes the temptation to use iget() to find an inode by
number in a filesystem from code outside that filesystem.

iget_locked() should be used instead.  A new function is added in an earlier
patch (iget_failed) that is to be called to mark an inode as bad, unlock it and
release it should the get routine fail.
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

Note that is_bad_inode() does not need to be called.  The error returned by
thingyfs_iget() should render it unnecessary.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/Exporting |    5 -----
 Documentation/filesystems/Locking   |    3 ---
 Documentation/filesystems/porting   |   12 ++++++------
 Documentation/filesystems/vfs.txt   |   17 +++--------------
 fs/inode.c                          |    4 ----
 include/linux/fs.h                  |   14 --------------
 6 files changed, 9 insertions(+), 46 deletions(-)

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
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 3b0fb22..93d9362 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -34,8 +34,8 @@ FOO_I(inode) (see in-tree filesystems for examples).
 
 Make them ->alloc_inode and ->destroy_inode in your super_operations.
 
-Keep in mind that now you need explicit initialization of private data -
-typically in ->read_inode() and after getting an inode from new_inode().
+Keep in mind that now you need explicit initialization of private data
+typically between calling iget_locked() and unlocking the inode.
 
 At some point that will become mandatory.
 
@@ -173,10 +173,10 @@ should be a non-blocking function that initializes those parts of a
 newly created inode to allow the test function to succeed. 'data' is
 passed as an opaque value to both test and set functions.
 
-When the inode has been created by iget5_locked(), it will be returned with
-the I_NEW flag set and will still be locked. read_inode has not been
-called so the file system still has to finalize the initialization. Once
-the inode is initialized it must be unlocked by calling unlock_new_inode().
+When the inode has been created by iget5_locked(), it will be returned with the
+I_NEW flag set and will still be locked.  The filesystem then needs to finalize
+the initialization. Once the inode is initialized it must be unlocked by
+calling unlock_new_inode().
 
 The filesystem is responsible for setting (and possibly testing) i_ino
 when appropriate. There is also a simpler iget_locked function that
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 045f3e0..133bc88 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -203,8 +203,6 @@ struct super_operations {
         struct inode *(*alloc_inode)(struct super_block *sb);
         void (*destroy_inode)(struct inode *);
 
-        void (*read_inode) (struct inode *);
-
         void (*dirty_inode) (struct inode *);
         int (*write_inode) (struct inode *, int);
         void (*put_inode) (struct inode *);
@@ -242,15 +240,6 @@ or bottom half).
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
-
   dirty_inode: this method is called by the VFS to mark an inode dirty.
 
   write_inode: this method is called when the VFS needs to write an
@@ -308,9 +297,9 @@ or bottom half).
 
   quota_write: called by the VFS to write to filesystem quota file.
 
-The read_inode() method is responsible for filling in the "i_op"
-field. This is a pointer to a "struct inode_operations" which
-describes the methods that can be performed on individual inodes.
+Whoever sets up the inode is responsible for filling in the "i_op" field. This
+is a pointer to a "struct inode_operations" which describes the methods that
+can be performed on individual inodes.
 
 
 The Inode Object
diff --git a/fs/inode.c b/fs/inode.c
index 29f5068..8c156c6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -901,8 +901,6 @@ EXPORT_SYMBOL(ilookup);
  * @set:	callback used to initialize a new struct inode
  * @data:	opaque data pointer to pass to @test and @set
  *
- * This is iget() without the read_inode() portion of get_new_inode().
- *
  * iget5_locked() uses ifind() to search for the inode specified by @hashval
  * and @data in the inode cache and if present it is returned with an increased
  * reference count. This is a generalized version of iget_locked() for file
@@ -939,8 +937,6 @@ EXPORT_SYMBOL(iget5_locked);
  * @sb:		super block of file system
  * @ino:	inode number to get
  *
- * This is iget() without the read_inode() portion of get_new_inode_fast().
- *
  * iget_locked() uses ifind_fast() to search for the inode specified by @ino in
  * the inode cache and if present it is returned with an increased reference
  * count. This is for file systems where the inode number is sufficient for
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c24d433..42aabc1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1181,8 +1181,6 @@ struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
-	void (*read_inode) (struct inode *);
-  
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*put_inode) (struct inode *);
@@ -1618,18 +1616,6 @@ extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*te
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
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);

