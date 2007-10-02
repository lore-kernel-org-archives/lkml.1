Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbXJBPxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbXJBPxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbXJBPwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:32 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:58971 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbXJBPwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:31 -0400
Message-Id: <20071002155217.370453674@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:31 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 05/12] VFS: allow filesystems to implement atomic open+truncate
Content-Disposition: inline; filename=vfs_atomic_open_truncate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new attribute flag ATTR_OPEN, with the meaning: "truncation was
initiated by open() due to the O_TRUNC flag".

This way filesystems wanting to implement truncation within their
->open() method can ignore such truncate requests.

This is a quick & dirty hack, but it comes for free.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namei.c
===================================================================
--- linux.orig/fs/namei.c	2007-09-25 21:32:04.000000000 +0200
+++ linux/fs/namei.c	2007-09-25 21:56:30.000000000 +0200
@@ -1667,8 +1667,10 @@ int may_open(struct nameidata *nd, int a
 		error = locks_verify_locked(inode);
 		if (!error) {
 			DQUOT_INIT(inode);
-			
-			error = do_truncate(dentry, 0, ATTR_MTIME|ATTR_CTIME, NULL);
+
+			error = do_truncate(dentry, 0,
+					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
+					    NULL);
 		}
 		put_write_access(inode);
 		if (error)
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-09-25 21:32:05.000000000 +0200
+++ linux/include/linux/fs.h	2007-09-25 21:56:30.000000000 +0200
@@ -337,6 +337,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
 #define ATTR_KILL_PRIV	16384
+#define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It

--
