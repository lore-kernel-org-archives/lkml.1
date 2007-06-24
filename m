Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbXFXMjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbXFXMjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 08:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbXFXMjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 08:39:33 -0400
Received: from DENETHOR.UNI-MUENSTER.DE ([128.176.180.180]:41739 "EHLO
	denethor.uni-muenster.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbXFXMjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 08:39:31 -0400
X-Greylist: delayed 1022 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jun 2007 08:39:31 EDT
Date: Sun, 24 Jun 2007 14:21:16 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] update description in Documentation/filesystems/vfs.txt
Message-ID: <20070624122116.GA8067@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While reading the said file I noticed some discrepancies between the actual
code and the info in the docs. Here's an update that attempts to match it to
the code in the current 2.6.22-rc5.

---
From: Borislav Petkov <bbpetkov@yahoo.de>

Update the description of struct file_system_type and get_sb() in
Documentation/filesystems/vfs.txt to match the current code.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--

Index: linux-2.6.22-rc5/Documentation/filesystems/vfs.txt
===================================================================
--- linux-2.6.22-rc5/Documentation/filesystems/vfs.txt.orig	2007-06-24 13:42:40.000000000 +0200
+++ linux-2.6.22-rc5/Documentation/filesystems/vfs.txt	2007-06-24 14:14:48.000000000 +0200
@@ -3,7 +3,7 @@
 
 	Original author: Richard Gooch <rgooch@atnf.csiro.au>
 
-		  Last updated on October 28, 2005
+		  Last updated on Juni 24, 2007.
 
   Copyright (C) 1999 Richard Gooch
   Copyright (C) 2005 Pekka Enberg
@@ -107,7 +107,7 @@
 struct file_system_type
 -----------------------
 
-This describes the filesystem. As of kernel 2.6.13, the following
+This describes the filesystem. As of kernel 2.6.22, the following
 members are defined:
 
 struct file_system_type {
@@ -119,6 +119,8 @@
         struct module *owner;
         struct file_system_type * next;
         struct list_head fs_supers;
+	struct lock_class_key s_lock_key;
+	struct lock_class_key s_umount_key;
 };
 
   name: the name of the filesystem type, such as "ext2", "iso9660",
@@ -137,11 +139,12 @@
 
   next: for internal VFS use: you should initialize this to NULL
 
+  s_lock_key, s_umount_key: lockdep-specific
+
 The get_sb() method has the following arguments:
 
-  struct super_block *sb: the superblock structure. This is partially
-	initialized by the VFS and the rest must be initialized by the
-	get_sb() method
+  struct file_system_type *fs_type: decribes the filesystem, partly initialized
+  	by the specific filesystem code
 
   int flags: mount flags
 
@@ -150,12 +153,13 @@
   void *data: arbitrary mount options, usually comes as an ASCII
 	string
 
-  int silent: whether or not to be silent on error
+  struct vfsmount *mnt: a vfs-internal representation of a mount point
 
 The get_sb() method must determine if the block device specified
-in the superblock contains a filesystem of the type the method
-supports. On success the method returns the superblock pointer, on
-failure it returns NULL.
+in the dev_name and fs_type contains a filesystem of the type the method
+supports. If it succeeds in opening the named block device, it initializes a
+struct super_block descriptor for the filesystem contained by the block device.
+On failure it returns an error.
 
 The most interesting member of the superblock structure that the
 get_sb() method fills in is the "s_op" field. This is a pointer to
-- 
Regards/Gruﬂ,
    Boris.
