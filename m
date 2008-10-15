Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbYJOOJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbYJOOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbYJOOE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:59 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45131 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYJOOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:49 -0400
Subject: [PATCH 5/6] vfs: remove LOOKUP_PARENT from non LOOKUP_PARENT lookup
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:11 +0900
Message-ID: <f29a09483e848f5f6f3526623.ps@mail.parknet.co.jp>
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
	<524881153e848f5f6f3426623.ps@mail.parknet.co.jp>
In-Reply-To: <524881153e848f5f6f3426623.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


lookup_hash() with LOOKUP_PARENT is bogus. And this prepares to add
new intent on those path.

The user of LOOKUP_PARENT intent is nfs only, and it checks whether
nd->flags has LOOKUP_CREATE or LOOKUP_OPEN, so the result is same.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/namei.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff -puN fs/namei.c~dcache-remove-parent fs/namei.c
--- linux-2.6/fs/namei.c~dcache-remove-parent	2008-08-26 11:13:30.000000000 +0900
+++ linux-2.6-hirofumi/fs/namei.c	2008-08-26 11:13:30.000000000 +0900
@@ -2176,16 +2176,19 @@ static long do_rmdir(int dfd, const char
 		return error;
 
 	switch(nd.last_type) {
-		case LAST_DOTDOT:
-			error = -ENOTEMPTY;
-			goto exit1;
-		case LAST_DOT:
-			error = -EINVAL;
-			goto exit1;
-		case LAST_ROOT:
-			error = -EBUSY;
-			goto exit1;
+	case LAST_DOTDOT:
+		error = -ENOTEMPTY;
+		goto exit1;
+	case LAST_DOT:
+		error = -EINVAL;
+		goto exit1;
+	case LAST_ROOT:
+		error = -EBUSY;
+		goto exit1;
 	}
+
+	nd.flags &= ~LOOKUP_PARENT;
+
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
@@ -2263,6 +2266,9 @@ static long do_unlinkat(int dfd, const c
 	error = -EISDIR;
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
+
+	nd.flags &= ~LOOKUP_PARENT;
+
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
@@ -2652,6 +2658,9 @@ asmlinkage long sys_renameat(int olddfd,
 	if (newnd.last_type != LAST_NORM)
 		goto exit2;
 
+	oldnd.flags &= ~LOOKUP_PARENT;
+	newnd.flags &= ~LOOKUP_PARENT;
+
 	trap = lock_rename(new_dir, old_dir);
 
 	old_dentry = lookup_hash(&oldnd);
_
