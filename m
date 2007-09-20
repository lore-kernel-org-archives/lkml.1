Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbXITUBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbXITUBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbXITTxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42289 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbXITTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:22 -0400
Subject: [PATCH 23/25] do_rmdir(): elevate write count
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:19 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195319.D360DF72@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Elevate the write count during the vfs_rmdir() call.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---

 lxc-dave/fs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/namei.c~do-rmdir-elevate-write-count fs/namei.c
--- lxc/fs/namei.c~do-rmdir-elevate-write-count	2007-09-20 12:16:22.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-20 12:16:22.000000000 -0700
@@ -2148,7 +2148,12 @@ static long do_rmdir(int dfd, const char
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
