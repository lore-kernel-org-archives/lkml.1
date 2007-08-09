Return-Path: <linux-kernel-owner+w=401wt.eu-S1763056AbXHIJ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763056AbXHIJ1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765504AbXHIJ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:12 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:38949 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938531AbXHIJ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:09 -0400
Message-Id: <20070809092502.976382639@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:50 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 4/9] exec: remove unnecessary check for MNT_NOEXEC
Content-Disposition: inline; filename=mnt_noexec_cleanup.patch
CC: Christoph Hellwig <hch@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

vfs_permission(MAY_EXEC) checks if the filesystem is mounted with
"noexec", so there's no need to repeat this check in sys_uselib() and
open_exec().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/exec.c
===================================================================
--- linux.orig/fs/exec.c	2007-08-09 11:01:54.000000000 +0200
+++ linux/fs/exec.c	2007-08-09 11:04:24.000000000 +0200
@@ -113,9 +113,6 @@ asmlinkage long sys_uselib(const char __
 	if (error)
 		goto out;
 
-	error = -EACCES;
-	if (nd.mnt->mnt_flags & MNT_NOEXEC)
-		goto exit;
 	error = -EINVAL;
 	if (!S_ISREG(nd.dentry->d_inode->i_mode))
 		goto exit;
@@ -659,8 +656,7 @@ struct file *open_exec(const char *name)
 	if (!err) {
 		struct inode *inode = nd.dentry->d_inode;
 		file = ERR_PTR(-EACCES);
-		if (!(nd.mnt->mnt_flags & MNT_NOEXEC) &&
-		    S_ISREG(inode->i_mode)) {
+		if (S_ISREG(inode->i_mode)) {
 			int err = vfs_permission(&nd, MAY_EXEC);
 			file = ERR_PTR(err);
 			if (!err) {

--
