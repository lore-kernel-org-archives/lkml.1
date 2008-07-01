Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYGAUsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYGAUsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYGAUsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:48:01 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48299 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYGAUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:48:00 -0400
To: casey@schaufler-ca.com
CC: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] smack: remove unnecessary xattr checks
Message-Id: <E1KDmlY-0006ML-If@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 01 Jul 2008 22:47:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey,

This is an untested patch, if it looks OK, can you please apply it to
your tree (or ACK it)?

Thanks,
Miklos

----
From: Miklos Szeredi <mszeredi@suse.cz>

getxattr() calls security_inode_permission(MAY_READ) so
smack_inode_getxattr() is unnecessary.

setxattr() and removexattr() call security_inode_permission(MAY_WRITE)
so the write permission checks in smack_inode_setxattr() and
smack_inode_removexattr() are unnecessary.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 security/smack/smack_lsm.c |   19 -------------------
 1 file changed, 19 deletions(-)

Index: linux-2.6/security/smack/smack_lsm.c
===================================================================
--- linux-2.6.orig/security/smack/smack_lsm.c	2008-07-01 21:44:05.000000000 +0200
+++ linux-2.6/security/smack/smack_lsm.c	2008-07-01 21:45:27.000000000 +0200
@@ -588,9 +588,6 @@ static int smack_inode_setxattr(struct d
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
 
-	if (rc == 0)
-		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
-
 	return rc;
 }
 
@@ -636,18 +633,6 @@ static void smack_inode_post_setxattr(st
 }
 
 /*
- * smack_inode_getxattr - Smack check on getxattr
- * @dentry: the object
- * @name: unused
- *
- * Returns 0 if access is permitted, an error code otherwise
- */
-static int smack_inode_getxattr(struct dentry *dentry, const char *name)
-{
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
-}
-
-/*
  * smack_inode_removexattr - Smack check on removexattr
  * @dentry: the object
  * @name: name of the attribute
@@ -668,9 +653,6 @@ static int smack_inode_removexattr(struc
 	} else
 		rc = cap_inode_removexattr(dentry, name);
 
-	if (rc == 0)
-		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
-
 	return rc;
 }
 
@@ -2606,7 +2588,6 @@ struct security_operations smack_ops = {
 	.inode_getattr = 		smack_inode_getattr,
 	.inode_setxattr = 		smack_inode_setxattr,
 	.inode_post_setxattr = 		smack_inode_post_setxattr,
-	.inode_getxattr = 		smack_inode_getxattr,
 	.inode_removexattr = 		smack_inode_removexattr,
 	.inode_need_killpriv =		cap_inode_need_killpriv,
 	.inode_killpriv =		cap_inode_killpriv,
