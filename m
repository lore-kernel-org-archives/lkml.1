Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbXKAXPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbXKAXPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbXKAXJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:09:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49692 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216AbXKAXI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:58 -0400
Subject: [PATCH 21/27] r-o-bind-mounts-make-access-use-mnt-check
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:54 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230854.14E2845F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
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
--- linux-2.6.git/fs/open.c~r-o-bind-mounts-make-access-use-mnt-check	2007-11-01 14:46:18.000000000 -0700
+++ linux-2.6.git-dave/fs/open.c	2007-11-01 14:46:18.000000000 -0700
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
