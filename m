Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbYG3CqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbYG3CqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYG3CoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:25 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46252 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbYG3CoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:19 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 15/19] Unionfs: properly hash newly created inodes
Date: Tue, 29 Jul 2008 22:43:45 -0400
Message-Id: <12173858431092-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes LTP's syscalls/rename13 test.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    2 +-
 fs/unionfs/main.c  |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index fa3c518..a05b412 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -339,7 +339,7 @@ check_link:
 
 	/* Its a hard link, so use the same inode */
 	new_dentry->d_inode = igrab(old_dentry->d_inode);
-	d_instantiate(new_dentry, new_dentry->d_inode);
+	d_add(new_dentry, new_dentry->d_inode);
 	unionfs_copy_attr_all(dir, lower_new_dentry->d_parent->d_inode);
 	fsstack_copy_inode_size(dir, lower_new_dentry->d_parent->d_inode);
 
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 0cdd50b..fea670b 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -128,6 +128,9 @@ skip:
 	/* only (our) lookup wants to do a d_add */
 	switch (flag) {
 	case INTERPOSE_DEFAULT:
+		/* for operations which create new inodes */
+		d_add(dentry, inode);
+		break;
 	case INTERPOSE_REVAL_NEG:
 		d_instantiate(dentry, inode);
 		break;
-- 
1.5.2.2

