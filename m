Return-Path: <linux-kernel-owner+w=401wt.eu-S965198AbXGLA36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965198AbXGLA36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935651AbXGLASe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:18:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54033 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936897AbXGLARY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:24 -0400
Subject: [PATCH 08/23] make access() use mnt check
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:20 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001720.CC0E212B@kernel>
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
--- lxc/fs/open.c~make-access-use-helper	2007-07-10 12:46:07.000000000 -0700
+++ lxc-dave/fs/open.c	2007-07-10 12:46:07.000000000 -0700
@@ -396,8 +396,17 @@ asmlinkage long sys_faccessat(int dfd, c
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
