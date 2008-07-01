Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbYGAUkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbYGAUkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYGAUkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:40:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43277 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYGAUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:40:45 -0400
To: jmorris@namei.org
CC: jjohansen@suse.de, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] security: fix dummy xattr functions
Message-Id: <E1KDmeW-0006KB-2x@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 01 Jul 2008 22:40:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

If this (untested) patch looks OK, could you please apply it to your
tree?

Thanks,
Miklos

----
From: Miklos Szeredi <mszeredi@suse.cz>

Replace open coded xattr checks with cap_inode_xxx() function calls in
dummy_inode_setxattr() and dummy_inode_removexattr().  The old ones
were out of sync with the cap_inode_xxx() implementation, which could
even be a security problem.

Noticed by John Johansen.

CC: John Johansen <jjohansen@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 security/dummy.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

Index: linux-2.6/security/dummy.c
===================================================================
--- linux-2.6.orig/security/dummy.c	2008-07-01 21:44:03.000000000 +0200
+++ linux-2.6/security/dummy.c	2008-07-01 21:51:08.000000000 +0200
@@ -370,11 +370,7 @@ static void dummy_inode_delete (struct i
 static int dummy_inode_setxattr (struct dentry *dentry, const char *name,
 				 const void *value, size_t size, int flags)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
-	    !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	return 0;
+	return cap_inode_setxattr(dentry, name, value, size, flags);
 }
 
 static void dummy_inode_post_setxattr (struct dentry *dentry, const char *name,
@@ -395,11 +391,7 @@ static int dummy_inode_listxattr (struct
 
 static int dummy_inode_removexattr (struct dentry *dentry, const char *name)
 {
-	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
-	    !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-	return 0;
+	return cap_inode_removexattr(dentry, name);
 }
 
 static int dummy_inode_need_killpriv(struct dentry *dentry)
