Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYDBSBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYDBSBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYDBSBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:01:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34866 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbYDBSBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:01:36 -0400
To: haveblue@us.ibm.com
CC: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] vfs: ro-bind: fix leaking refcounts in setxattr
Message-Id: <E1Jh7H4-0006Uc-7q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Apr 2008 20:01:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

setxattr() and lsetxattr() were leaking mount/dentry references on
read-only mount.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/xattr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: vfs-2.6/fs/xattr.c
===================================================================
--- vfs-2.6.orig/fs/xattr.c	2008-04-02 19:53:18.000000000 +0200
+++ vfs-2.6/fs/xattr.c	2008-04-02 19:54:53.000000000 +0200
@@ -263,9 +263,10 @@ sys_setxattr(char __user *path, char __u
 		return error;
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
-		return error;
+		goto out_path_put;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
 	mnt_drop_write(nd.path.mnt);
+ out_path_put:
 	path_put(&nd.path);
 	return error;
 }
@@ -282,9 +283,10 @@ sys_lsetxattr(char __user *path, char __
 		return error;
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
-		return error;
+		goto out_path_put;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
 	mnt_drop_write(nd.path.mnt);
+ out_path_put:
 	path_put(&nd.path);
 	return error;
 }
