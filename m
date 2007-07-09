Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbXGIC5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbXGIC5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758634AbXGIC45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:56:57 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:36839 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758633AbXGIC44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:56:56 -0400
Date: Sun, 8 Jul 2007 22:56:54 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] selinux: change sel_make_dir() to specify inode counter
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082256320.12256@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher J. PeBenito <cpebenito@tresys.com>

Specify the inode counter explicitly in sel_make_dir(), rather than always
using sel_last_ino.

Signed-off-by: Christopher J. PeBenito <cpebenito@tresys.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/selinuxfs.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index e955246..cf1acde 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1293,7 +1293,8 @@ out:
 	return ret;
 }
 
-static int sel_make_dir(struct inode *dir, struct dentry *dentry)
+static int sel_make_dir(struct inode *dir, struct dentry *dentry,
+			unsigned long *ino)
 {
 	int ret = 0;
 	struct inode *inode;
@@ -1305,7 +1306,7 @@ static int sel_make_dir(struct inode *dir, struct dentry *dentry)
 	}
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
-	inode->i_ino = ++sel_last_ino;
+	inode->i_ino = ++(*ino);
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	d_add(dentry, inode);
@@ -1351,7 +1352,7 @@ static int sel_fill_super(struct super_block * sb, void * data, int silent)
 		goto err;
 	}
 
-	ret = sel_make_dir(root_inode, dentry);
+	ret = sel_make_dir(root_inode, dentry, &sel_last_ino);
 	if (ret)
 		goto err;
 
@@ -1384,7 +1385,7 @@ static int sel_fill_super(struct super_block * sb, void * data, int silent)
 		goto err;
 	}
 
-	ret = sel_make_dir(root_inode, dentry);
+	ret = sel_make_dir(root_inode, dentry, &sel_last_ino);
 	if (ret)
 		goto err;
 
@@ -1398,7 +1399,7 @@ static int sel_fill_super(struct super_block * sb, void * data, int silent)
 		goto err;
 	}
 
-	ret = sel_make_dir(root_inode, dentry);
+	ret = sel_make_dir(root_inode, dentry, &sel_last_ino);
 	if (ret)
 		goto err;
 
-- 
1.5.0.6

