Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbXJANU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbXJANU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXJANMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:12:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbXJANMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:12:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/30] IGET: Remove iget() and the read_inode() super op as
	being obsolete
To: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Mon, 01 Oct 2007 14:11:55 +0100
Message-ID: <20071001131155.29339.20338.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
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

iget_locked() should be used instead.  A new function is added (iget_failed)
that is to be called to mark an inode as bad, unlock it and release it should
the get routine fail.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/porting |    4 ++--
 Documentation/filesystems/vfs.txt |    5 -----
 fs/inode.c                        |   16 ----------------
 include/linux/fs.h                |    4 ----
 4 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 3b0fb22..c20eae9 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -34,8 +34,8 @@ FOO_I(inode) (see in-tree filesystems for examples).
 
 Make them ->alloc_inode and ->destroy_inode in your super_operations.
 
-Keep in mind that now you need explicit initialization of private data -
-typically in ->read_inode() and after getting an inode from new_inode().
+Keep in mind that now you need explicit initialization of private data
+typically between calling iget_locked() and calling unlocking the inode.
 
 At some point that will become mandatory.
 
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 63c7e91..133bc88 100644
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
@@ -242,9 +240,6 @@ or bottom half).
   	->alloc_inode was defined and simply undoes anything done by
 	->alloc_inode.
 
-  read_inode: deprecated, do not use.  Use iget_locked() instead of iget() and
-	return a proper error value.
-
   dirty_inode: this method is called by the VFS to mark an inode dirty.
 
   write_inode: this method is called when the VFS needs to write an
diff --git a/fs/inode.c b/fs/inode.c
index f78db20..29f5068 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1427,19 +1427,3 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 		       mode);
 }
 EXPORT_SYMBOL(init_special_inode);
-
-/*
- * old deprecated inode creator
- */
-struct inode *iget(struct super_block *sb, unsigned long ino)
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
-EXPORT_SYMBOL(iget);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dfa07d2..42aabc1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1181,8 +1181,6 @@ struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
-	void (*read_inode) (struct inode *) __deprecated;
-  
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*put_inode) (struct inode *);
@@ -1618,8 +1616,6 @@ extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*te
 extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern void unlock_new_inode(struct inode *);
 
-extern struct inode *iget(struct super_block *sb, unsigned long ino)
-	__deprecated;
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);

