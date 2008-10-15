Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbYJOWv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbYJOWv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYJOWue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:50:34 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54098 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbYJOWud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:50:33 -0400
Subject: [PATCH vfs-2.6 5/6] vfs: remove LOOKUP_PARENT from non LOOKUP_PARENT lookup
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Thu, 16 Oct 2008 07:50:29 +0900
Message-ID: <e8c7efff3e848f673b5520397.ps@mail.parknet.co.jp>
References: <e86c95d83e848f673b3120397.ps@mail.parknet.co.jp>
	<ef1e4d933e848f673b4220397.ps@mail.parknet.co.jp>
	<4e71a4b03e848f673b4320397.ps@mail.parknet.co.jp>
	<f5d2a7043e848f673b5420397.ps@mail.parknet.co.jp>
In-Reply-To: <f5d2a7043e848f673b5420397.ps@mail.parknet.co.jp>
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
--- vfs-2.6/fs/namei.c~dcache-remove-parent	2008-10-16 06:57:35.000000000 +0900
+++ vfs-2.6-hirofumi/fs/namei.c	2008-10-16 06:57:35.000000000 +0900
@@ -2170,16 +2170,19 @@ static long do_rmdir(int dfd, const char
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
@@ -2257,6 +2260,9 @@ static long do_unlinkat(int dfd, const c
 	error = -EISDIR;
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
+
+	nd.flags &= ~LOOKUP_PARENT;
+
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
@@ -2646,6 +2652,9 @@ asmlinkage long sys_renameat(int olddfd,
 	if (newnd.last_type != LAST_NORM)
 		goto exit2;
 
+	oldnd.flags &= ~LOOKUP_PARENT;
+	newnd.flags &= ~LOOKUP_PARENT;
+
 	trap = lock_rename(new_dir, old_dir);
 
 	old_dentry = lookup_hash(&oldnd);
_
