Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbXGAHAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbXGAHAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbXGAHA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:00:29 -0400
Received: from DENETHOR.UNI-MUENSTER.DE ([128.176.180.180]:61163 "EHLO
	denethor.uni-muenster.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbXGAHA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:00:27 -0400
Date: Sun, 1 Jul 2007 08:53:43 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] update Documentation/filesystems/vfs.txt (second part)
Message-ID: <20070701065342.GA10346@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070624122116.GA8067@gollum.tnic> <w10qlMfE.1182764076.1306850.penberg@cs.helsinki.fi> <20070625190636.GA30724@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070625190636.GA30724@gollum.tnic>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---
From: Borislav Petkov <bbpetkov@yahoo.de>

Update the rest of Documentation/filesystems/vfs.txt

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--

Index: linux-2.6.22-rc6/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.22-rc6/Documentation/filesystems/vfs.txt.orig	2007-07-01 08:47:29.000000000 +0200
+++ linux-2.6.22-rc6/Documentation/filesystems/vfs.txt	2007-07-01 08:47:48.000000000 +0200
@@ -193,7 +193,7 @@
 -----------------------
 
 This describes how the VFS can manipulate the superblock of your
-filesystem. As of kernel 2.6.13, the following members are defined:
+filesystem. As of kernel 2.6.22, the following members are defined:
 
 struct super_operations {
         struct inode *(*alloc_inode)(struct super_block *sb);
@@ -216,8 +216,6 @@
         void (*clear_inode) (struct inode *);
         void (*umount_begin) (struct super_block *);
 
-        void (*sync_inodes) (struct super_block *sb,
-                                struct writeback_control *wbc);
         int (*show_options)(struct seq_file *, struct vfsmount *);
 
         ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
@@ -300,9 +298,6 @@
 
   umount_begin: called when the VFS is unmounting a filesystem.
 
-  sync_inodes: called when the VFS is writing out dirty data associated with
-  	a superblock.
-
   show_options: called by the VFS to show mount options for /proc/<pid>/mounts.
 
   quota_read: called by the VFS to read from filesystem quota file.
@@ -324,7 +319,7 @@
 -----------------------
 
 This describes how the VFS can manipulate an inode in your
-filesystem. As of kernel 2.6.13, the following members are defined:
+filesystem. As of kernel 2.6.22, the following members are defined:
 
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
@@ -348,6 +343,7 @@
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
+	void (*truncate_range)(struct inode *, loff_t, loff_t);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -444,6 +440,9 @@
   removexattr: called by the VFS to remove an extended attribute from
   	a file. This method is called by removexattr(2) system call.
 
+  truncate_range: a method provided by the underlying filesystem to truncate a
+  	range of blocks , i.e. punch a hole somewhere in a file.
+
 
 The Address Space Object
 ========================
@@ -522,7 +521,7 @@
 -------------------------------
 
 This describes how the VFS can manipulate mapping of a file to page cache in
-your filesystem. As of kernel 2.6.16, the following members are defined:
+your filesystem. As of kernel 2.6.22, the following members are defined:
 
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
@@ -543,6 +542,7 @@
 			int);
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
+	int (*launder_page) (struct page *);
 };
 
   writepage: called by the VM to write a dirty page to backing store.
@@ -689,6 +689,10 @@
 	transfer any private data across and update any references
         that it has to the page.
 
+  launder_page: Called before freeing a page - it writes back the dirty page. To
+  	prevent redirtying the page, it is kept locked during the whole
+	operation.
+
 The File Object
 ===============
 
@@ -699,9 +703,10 @@
 ----------------------
 
 This describes how the VFS can manipulate an open file. As of kernel
-2.6.17, the following members are defined:
+2.6.22, the following members are defined:
 
 struct file_operations {
+	struct module *owner;
 	loff_t (*llseek) (struct file *, loff_t, int);
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
@@ -728,10 +733,8 @@
 	int (*check_flags)(int);
 	int (*dir_notify)(struct file *filp, unsigned long arg);
 	int (*flock) (struct file *, int, struct file_lock *);
-	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned 
-int);
-	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned  
-int);
+	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned int);
+	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
 };
 
 Again, all methods are called without any locks being held, unless
-- 
Regards/Gruﬂ,
    Boris.
