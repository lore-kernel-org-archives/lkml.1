Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbYBOWmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbYBOWmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764120AbYBOWhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:45 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60212 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763686AbYBOWhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:40 -0500
Subject: [PATCH 10/30] r/o bind mounts: elevate write count for vfs_rmdir()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:34 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223734.00CDD6B4@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Elevate the write count during the vfs_rmdir() call.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-do_rmdir-elevate-write-count fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-do_rmdir-elevate-write-count	2008-02-15 13:25:47.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-15 13:25:47.000000000 -0800
@@ -2189,7 +2189,12 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto exit3;
 	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+	mnt_drop_write(nd.path.mnt);
+exit3:
 	dput(dentry);
 exit2:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
_
