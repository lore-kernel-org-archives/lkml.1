Return-Path: <linux-kernel-owner+w=401wt.eu-S1764653AbYEFJTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764653AbYEFJTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764160AbYEFJOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:14:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59534 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763731AbYEFJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:14:34 -0400
Message-Id: <20080506091418.842237934@szeredi.hu>
References: <20080506091327.259950960@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 May 2008 11:13:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 10/24] vfs: truncate: append-only checking cleanup
Content-Disposition: inline; filename=truncate_append_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move the append-only checks from truncate to notify_change().  Checks
for append-only files are always performed by the VFS and not by the
filesystem so this belongs in notify_change(), and not in
inode_change_ok().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/attr.c  |    6 ++++++
 fs/namei.c |    2 --
 fs/open.c  |    8 --------
 3 files changed, 6 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-06 11:04:35.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-06 11:04:36.000000000 +0200
@@ -253,10 +253,6 @@ static long do_sys_truncate(const char _
 	if (error)
 		goto mnt_drop_write_and_out;
 
-	error = -EPERM;
-	if (IS_APPEND(inode))
-		goto mnt_drop_write_and_out;
-
 	error = get_write_access(inode);
 	if (error)
 		goto mnt_drop_write_and_out;
@@ -321,10 +317,6 @@ static long do_sys_ftruncate(unsigned in
 	if (small && length > MAX_NON_LFS)
 		goto out_putf;
 
-	error = -EPERM;
-	if (IS_APPEND(inode))
-		goto out_putf;
-
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
 		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2008-05-06 11:04:35.000000000 +0200
+++ linux-2.6/fs/attr.c	2008-05-06 11:04:36.000000000 +0200
@@ -114,6 +114,12 @@ int notify_change(struct dentry * dentry
 			return -EPERM;
 	}
 
+	/*
+	 * IS_IMMUTABLE() is checked by caller for truncation
+	 */
+	if ((ia_valid & ATTR_SIZE) && IS_APPEND(inode))
+		return -EPERM;
+
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-06 11:04:29.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-06 11:04:36.000000000 +0200
@@ -1639,8 +1639,6 @@ int may_open(struct nameidata *nd, int a
 	if (IS_APPEND(inode)) {
 		if  ((flag & FMODE_WRITE) && !(flag & O_APPEND))
 			return -EPERM;
-		if (flag & O_TRUNC)
-			return -EPERM;
 	}
 
 	/* O_NOATIME can only be set by the owner or superuser */

--
