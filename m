Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbXGLAZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbXGLAZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964901AbXGLARp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:45 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54530 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857AbXGLARi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:38 -0400
Subject: [PATCH 18/23] elevate writer count for do_sys_truncate()
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:34 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001734.F5F178B0@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/open.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/open.c~elevate-writer-count-for-do-sys-truncate fs/open.c
--- lxc/fs/open.c~elevate-writer-count-for-do-sys-truncate	2007-07-10 12:46:13.000000000 -0700
+++ lxc-dave/fs/open.c	2007-07-10 12:46:13.000000000 -0700
@@ -243,28 +243,28 @@ static long do_sys_truncate(const char _
 	if (!S_ISREG(inode->i_mode))
 		goto dput_and_out;
 
-	error = vfs_permission(&nd, MAY_WRITE);
+	error = mnt_want_write(nd.mnt);
 	if (error)
 		goto dput_and_out;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto dput_and_out;
+	error = vfs_permission(&nd, MAY_WRITE);
+	if (error)
+		goto mnt_drop_write_and_out;
 
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	/*
 	 * Make sure that there are no leases.
 	 */
 	error = break_lease(inode, FMODE_WRITE);
 	if (error)
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	error = get_write_access(inode);
 	if (error)
-		goto dput_and_out;
+		goto mnt_drop_write_and_out;
 
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
@@ -273,6 +273,8 @@ static long do_sys_truncate(const char _
 	}
 	put_write_access(inode);
 
+mnt_drop_write_and_out:
+	mnt_drop_write(nd.mnt);
 dput_and_out:
 	path_release(&nd);
 out:
_
