Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbXIQS3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbXIQS3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbXIQS1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35988 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbXIQS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:31 -0400
Subject: [PATCH 08/24] make access() use mnt check
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:28 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182728.116CADE8@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is OK to let access() go without using a mnt_want/drop_write()
pair because it doesn't actually do writes to the filesystem,
and it is inherently racy anyway.  This is a rare case when it is
OK to use __mnt_is_readonly() directly.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/open.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/open.c~make-access-use-helper fs/open.c
--- lxc/fs/open.c~make-access-use-helper	2007-09-17 09:44:00.000000000 -0700
+++ lxc-dave/fs/open.c	2007-09-17 09:44:00.000000000 -0700
@@ -457,8 +457,17 @@ asmlinkage long sys_faccessat(int dfd, c
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
