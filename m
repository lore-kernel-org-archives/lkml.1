Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZIGVGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZIGVGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZIGVGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:06:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbZIGVGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:06:00 -0400
Date: Mon, 7 Sep 2009 14:05:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
cc: Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 7/8] ext[234]: move over to 'check_acl' permission model
In-Reply-To: <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909071404370.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain> <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain> <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2009 12:12:24 -0700

Don't implement per-filesystem 'extX_permission()' functions that have
to be called for every path component operation, and instead just expose
the actual ACL checking so that the VFS layer can now do it for us.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/ext2/acl.c   |    8 +-------
 fs/ext2/acl.h   |    4 ++--
 fs/ext2/file.c  |    2 +-
 fs/ext2/namei.c |    4 ++--
 fs/ext3/acl.c   |    8 +-------
 fs/ext3/acl.h   |    4 ++--
 fs/ext3/file.c  |    2 +-
 fs/ext3/namei.c |    4 ++--
 fs/ext4/acl.c   |    8 +-------
 fs/ext4/acl.h   |    4 ++--
 fs/ext4/file.c  |    2 +-
 fs/ext4/namei.c |    4 ++--
 12 files changed, 18 insertions(+), 36 deletions(-)

diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index d636e12..a63d442 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -230,7 +230,7 @@ ext2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 	return error;
 }
 
-static int
+int
 ext2_check_acl(struct inode *inode, int mask)
 {
 	struct posix_acl *acl = ext2_get_acl(inode, ACL_TYPE_ACCESS);
@@ -246,12 +246,6 @@ ext2_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
-int
-ext2_permission(struct inode *inode, int mask)
-{
-	return generic_permission(inode, mask, ext2_check_acl);
-}
-
 /*
  * Initialize the ACLs of a new inode. Called from ext2_new_inode.
  *
diff --git a/fs/ext2/acl.h b/fs/ext2/acl.h
index ecefe47..3ff6cbb 100644
--- a/fs/ext2/acl.h
+++ b/fs/ext2/acl.h
@@ -54,13 +54,13 @@ static inline int ext2_acl_count(size_t size)
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 
 /* acl.c */
-extern int ext2_permission (struct inode *, int);
+extern int ext2_check_acl (struct inode *, int);
 extern int ext2_acl_chmod (struct inode *);
 extern int ext2_init_acl (struct inode *, struct inode *);
 
 #else
 #include <linux/sched.h>
-#define ext2_permission NULL
+#define ext2_check_acl	NULL
 #define ext2_get_acl	NULL
 #define ext2_set_acl	NULL
 
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 2b9e47d..a2f3afd 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -85,6 +85,6 @@ const struct inode_operations ext2_file_inode_operations = {
 	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
-	.permission	= ext2_permission,
+	.check_acl	= ext2_check_acl,
 	.fiemap		= ext2_fiemap,
 };
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index e1dedb0..58051df 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -396,7 +396,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
-	.permission	= ext2_permission,
+	.check_acl	= ext2_check_acl,
 };
 
 const struct inode_operations ext2_special_inode_operations = {
@@ -407,5 +407,5 @@ const struct inode_operations ext2_special_inode_operations = {
 	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
-	.permission	= ext2_permission,
+	.check_acl	= ext2_check_acl,
 };
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index e167bae..c9b0df3 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -238,7 +238,7 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
 	return error;
 }
 
-static int
+int
 ext3_check_acl(struct inode *inode, int mask)
 {
 	struct posix_acl *acl = ext3_get_acl(inode, ACL_TYPE_ACCESS);
@@ -254,12 +254,6 @@ ext3_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
-int
-ext3_permission(struct inode *inode, int mask)
-{
-	return generic_permission(inode, mask, ext3_check_acl);
-}
-
 /*
  * Initialize the ACLs of a new inode. Called from ext3_new_inode.
  *
diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
index 07d15a3..5973346 100644
--- a/fs/ext3/acl.h
+++ b/fs/ext3/acl.h
@@ -54,13 +54,13 @@ static inline int ext3_acl_count(size_t size)
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
 
 /* acl.c */
-extern int ext3_permission (struct inode *, int);
+extern int ext3_check_acl (struct inode *, int);
 extern int ext3_acl_chmod (struct inode *);
 extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
 
 #else  /* CONFIG_EXT3_FS_POSIX_ACL */
 #include <linux/sched.h>
-#define ext3_permission NULL
+#define ext3_check_acl NULL
 
 static inline int
 ext3_acl_chmod(struct inode *inode)
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 5b49704..2992532 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -137,7 +137,7 @@ const struct inode_operations ext3_file_inode_operations = {
 	.listxattr	= ext3_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.permission	= ext3_permission,
+	.check_acl	= ext3_check_acl,
 	.fiemap		= ext3_fiemap,
 };
 
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 6ff7b97..aad6400 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2445,7 +2445,7 @@ const struct inode_operations ext3_dir_inode_operations = {
 	.listxattr	= ext3_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.permission	= ext3_permission,
+	.check_acl	= ext3_check_acl,
 };
 
 const struct inode_operations ext3_special_inode_operations = {
@@ -2456,5 +2456,5 @@ const struct inode_operations ext3_special_inode_operations = {
 	.listxattr	= ext3_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.permission	= ext3_permission,
+	.check_acl	= ext3_check_acl,
 };
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index f6d8967..0df88b2 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -236,7 +236,7 @@ ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 	return error;
 }
 
-static int
+int
 ext4_check_acl(struct inode *inode, int mask)
 {
 	struct posix_acl *acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
@@ -252,12 +252,6 @@ ext4_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
-int
-ext4_permission(struct inode *inode, int mask)
-{
-	return generic_permission(inode, mask, ext4_check_acl);
-}
-
 /*
  * Initialize the ACLs of a new inode. Called from ext4_new_inode.
  *
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 949789d..9d843d5 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -54,13 +54,13 @@ static inline int ext4_acl_count(size_t size)
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 
 /* acl.c */
-extern int ext4_permission(struct inode *, int);
+extern int ext4_check_acl(struct inode *, int);
 extern int ext4_acl_chmod(struct inode *);
 extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
 
 #else  /* CONFIG_EXT4_FS_POSIX_ACL */
 #include <linux/sched.h>
-#define ext4_permission NULL
+#define ext4_check_acl NULL
 
 static inline int
 ext4_acl_chmod(struct inode *inode)
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3f1873f..27f3c53 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -207,7 +207,7 @@ const struct inode_operations ext4_file_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.permission	= ext4_permission,
+	.check_acl	= ext4_check_acl,
 	.fallocate	= ext4_fallocate,
 	.fiemap		= ext4_fiemap,
 };
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index de04013..114abe5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2536,7 +2536,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.permission	= ext4_permission,
+	.check_acl	= ext4_check_acl,
 	.fiemap         = ext4_fiemap,
 };
 
@@ -2548,5 +2548,5 @@ const struct inode_operations ext4_special_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.removexattr	= generic_removexattr,
 #endif
-	.permission	= ext4_permission,
+	.check_acl	= ext4_check_acl,
 };
-- 
1.6.4.1.209.g74b8

