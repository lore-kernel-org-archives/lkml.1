Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbXITT5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbXITT5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXITTxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51283 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbXITTxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:14 -0400
Subject: [PATCH 02/25] rearrange may_open() to be r/o friendly
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:52:50 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195250.7656557C@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


may_open() calls vfs_permission() before it does checks for
IS_RDONLY(inode).  It checks _again_ inside of vfs_permission().

The check inside of vfs_permission() is going away eventually.
With the mnt_want/drop_write() functions, all of the r/o
checks (except for this one) are consistently done before
calling permission().  Because of this, I'd like to use
permission() to hold a debugging check to make sure that
the mnt_want/drop_write() calls are actually being made.

So, to do this:
1. remove the IS_RDONLY() check from permission()
2. enforce that you must mnt_want_write() before
   even calling permission()
3. actually add the debugging check to permission()

We need to rearrange may_open() to do r/o checks
before calling permission().  Here's the patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~rearrange-permission-and-ro-checks-in-may_open fs/namei.c
--- lxc/fs/namei.c~rearrange-permission-and-ro-checks-in-may_open	2007-09-20 12:16:09.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-20 12:16:09.000000000 -0700
@@ -1579,10 +1579,6 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISDIR(inode->i_mode) && (flag & FMODE_WRITE))
 		return -EISDIR;
 
-	error = vfs_permission(nd, acc_mode);
-	if (error)
-		return error;
-
 	/*
 	 * FIFO's, sockets and device files are special: they don't
 	 * actually live on the filesystem itself, and as such you
@@ -1597,6 +1593,10 @@ int may_open(struct nameidata *nd, int a
 		flag &= ~O_TRUNC;
 	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
 		return -EROFS;
+
+	error = vfs_permission(nd, acc_mode);
+	if (error)
+		return error;
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
_
