Return-Path: <linux-kernel-owner+w=401wt.eu-S934441AbYBOWuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441AbYBOWuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbYBOWiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:07 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49094 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765617AbYBOWh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:58 -0500
Subject: [PATCH 25/30] r/o bind mounts: make access() use new r/o helper
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:55 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223755.2E311074@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is OK to let access() go without using a mnt_want/drop_write() pair because
it doesn't actually do writes to the filesystem, and it is inherently racy
anyway.  This is a rare case when it is OK to use __mnt_is_readonly()
directly.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/open.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-make-access-use-mnt-check fs/open.c
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-make-access-use-mnt-check	2008-02-15 13:25:57.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-15 13:25:57.000000000 -0800
@@ -459,8 +459,17 @@ asmlinkage long sys_faccessat(int dfd, c
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.path.dentry->d_inode->i_mode))
 		goto out_path_release;
-
-	if(IS_RDONLY(nd.path.dentry->d_inode))
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
+	if (__mnt_is_readonly(nd.path.mnt))
 		res = -EROFS;
 
 out_path_release:
_
