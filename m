Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbXKAXMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbXKAXMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbXKAXIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42604 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbXKAXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:46 -0400
Subject: [PATCH 07/27] r-o-bind-mounts-do_rmdir-elevate-write-count
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:35 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230835.0185DD99@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Elevate the write count during the vfs_rmdir() call.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-do_rmdir-elevate-write-count fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-do_rmdir-elevate-write-count	2007-11-01 14:46:09.000000000 -0700
+++ linux-2.6.git-dave/fs/namei.c	2007-11-01 14:46:09.000000000 -0700
@@ -2174,7 +2174,12 @@ static long do_rmdir(int dfd, const char
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
