Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbXIQSez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbXIQSez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbXIQS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36750 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbXIQS1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:52 -0400
Subject: [PATCH 22/24] do_rmdir(): elevate write count
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:47 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182747.9A3B809F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Elevate the write count during the vfs_rmdir() call.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/namei.c~do-rmdir-elevate-write-count fs/namei.c
--- lxc/fs/namei.c~do-rmdir-elevate-write-count	2007-09-17 09:44:09.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-17 09:44:09.000000000 -0700
@@ -2173,7 +2173,12 @@ static long do_rmdir(int dfd, const char
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
