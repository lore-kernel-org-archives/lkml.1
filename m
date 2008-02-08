Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYBHWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYBHWj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbYBHW1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:35 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46539 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759031AbYBHW1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:24 -0500
Subject: [RFC][PATCH 25/30] r/o bind mounts: make access() use new r/o helper
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:27:21 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222721.BD3F6746@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is OK to let access() go without using a mnt_want/drop_write() pair because
it doesn't actually do writes to the filesystem, and it is inherently racy
anyway.  This is a rare case when it is OK to use __mnt_is_readonly()
directly.

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/open.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-make-access-use-mnt-check fs/open.c
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-make-access-use-mnt-check	2008-02-08 13:04:58.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-08 13:04:58.000000000 -0800
@@ -459,8 +459,17 @@ asmlinkage long sys_faccessat(int dfd, c
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.dentry->d_inode->i_mode))
 		goto out_path_release;
-
-	if(IS_RDONLY(nd.dentry->d_inode))
+	/*
+	 * This is a rare case where using __mnt_is_readonly()
+	 * is OK without a mnt_want/drop_write() pair.  Since
+	 * no actual write to the fs is performed here, we do
+	 * not need to telegraph to that to anyone.
+	 *
+	 * By doing this, we accept that this access is
+	 * inherently racy and know that the fs may change
+	 * state before we even see this result.
+	 */
+	if (__mnt_is_readonly(nd.mnt))
 		res = -EROFS;
 
 out_path_release:
_
