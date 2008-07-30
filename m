Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbYG3MGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbYG3MGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYG3MGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:06:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50164 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYG3MGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:06:33 -0400
To: viro@ZenIV.linux.org.uk
Cc: akpm@linux-foundation.org, jmorris@namei.org, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] vfs: make security_inode_setattr() calling consistent
Message-Id: <E1KOARi-0004wu-1G@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 14:06:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Call security_inode_setattr() consistetly before inode_change_ok().
It doesn't make sense to try to "optimize" the i_op->setattr == NULL
case, as most filesystem do define their own setattr function.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/attr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2008-07-30 13:52:35.000000000 +0200
+++ linux-2.6/fs/attr.c	2008-07-30 13:52:41.000000000 +0200
@@ -159,17 +159,17 @@ int notify_change(struct dentry * dentry
 	if (!(attr->ia_valid & ~(ATTR_KILL_SUID | ATTR_KILL_SGID)))
 		return 0;
 
+	error = security_inode_setattr(dentry, attr);
+	if (error)
+		return error;
+
 	if (ia_valid & ATTR_SIZE)
 		down_write(&dentry->d_inode->i_alloc_sem);
 
 	if (inode->i_op && inode->i_op->setattr) {
-		error = security_inode_setattr(dentry, attr);
-		if (!error)
-			error = inode->i_op->setattr(dentry, attr);
+		error = inode->i_op->setattr(dentry, attr);
 	} else {
 		error = inode_change_ok(inode, attr);
-		if (!error)
-			error = security_inode_setattr(dentry, attr);
 		if (!error) {
 			if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
 			    (ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid))
