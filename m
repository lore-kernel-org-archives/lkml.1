Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZIGVF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZIGVF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZIGVF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:05:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbZIGVFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:05:25 -0400
Date: Mon, 7 Sep 2009 14:04:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
cc: Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 6/8] shmfs: use 'check_acl' instead of 'permission'
In-Reply-To: <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909071404090.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain> <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2009 12:04:28 -0700

shmfs wants purely standard POSIX ACL semantics, so we can use the new
generic VFS layer POSIX ACL checking rather than cooking our own
'permission()' function.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/shmem_fs.h |    2 +-
 mm/shmem.c               |    6 +++---
 mm/shmem_acl.c           |   11 +----------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index abff6c9..6d3f2f4 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -39,7 +39,7 @@ static inline struct shmem_inode_info *SHMEM_I(struct inode *inode)
 }
 
 #ifdef CONFIG_TMPFS_POSIX_ACL
-int shmem_permission(struct inode *, int);
+int shmem_check_acl(struct inode *, int);
 int shmem_acl_init(struct inode *, struct inode *);
 
 extern struct xattr_handler shmem_xattr_acl_access_handler;
diff --git a/mm/shmem.c b/mm/shmem.c
index d713239..5a0b3d4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2446,7 +2446,7 @@ static const struct inode_operations shmem_inode_operations = {
 	.getxattr	= generic_getxattr,
 	.listxattr	= generic_listxattr,
 	.removexattr	= generic_removexattr,
-	.permission	= shmem_permission,
+	.check_acl	= shmem_check_acl,
 #endif
 
 };
@@ -2469,7 +2469,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.getxattr	= generic_getxattr,
 	.listxattr	= generic_listxattr,
 	.removexattr	= generic_removexattr,
-	.permission	= shmem_permission,
+	.check_acl	= shmem_check_acl,
 #endif
 };
 
@@ -2480,7 +2480,7 @@ static const struct inode_operations shmem_special_inode_operations = {
 	.getxattr	= generic_getxattr,
 	.listxattr	= generic_listxattr,
 	.removexattr	= generic_removexattr,
-	.permission	= shmem_permission,
+	.check_acl	= shmem_check_acl,
 #endif
 };
 
diff --git a/mm/shmem_acl.c b/mm/shmem_acl.c
index 606a8e7..df2c87f 100644
--- a/mm/shmem_acl.c
+++ b/mm/shmem_acl.c
@@ -157,7 +157,7 @@ shmem_acl_init(struct inode *inode, struct inode *dir)
 /**
  * shmem_check_acl  -  check_acl() callback for generic_permission()
  */
-static int
+int
 shmem_check_acl(struct inode *inode, int mask)
 {
 	struct posix_acl *acl = shmem_get_acl(inode, ACL_TYPE_ACCESS);
@@ -169,12 +169,3 @@ shmem_check_acl(struct inode *inode, int mask)
 	}
 	return -EAGAIN;
 }
-
-/**
- * shmem_permission  -  permission() inode operation
- */
-int
-shmem_permission(struct inode *inode, int mask)
-{
-	return generic_permission(inode, mask, shmem_check_acl);
-}
-- 
1.6.4.1.209.g74b8

