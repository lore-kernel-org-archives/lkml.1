Return-Path: <linux-kernel-owner+w=401wt.eu-S937855AbXGLAYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937855AbXGLAYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964922AbXGLARx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56934 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964896AbXGLARq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:46 -0400
Subject: [PATCH 23/23] do_rmdir(): elevate write count
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:41 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001741.DAA48BFD@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Elevate the write count during the vfs_rmdir() call.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/namei.c~do-rmdir-elevate-write-count fs/namei.c
--- lxc/fs/namei.c~do-rmdir-elevate-write-count	2007-07-10 12:46:16.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-07-10 12:46:16.000000000 -0700
@@ -2115,7 +2115,12 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto exit3;
 	error = vfs_rmdir(nd.dentry->d_inode, dentry);
+	mnt_drop_write(nd.mnt);
+exit3:
 	dput(dentry);
 exit2:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
_
