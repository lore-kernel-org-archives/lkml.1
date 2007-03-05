Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbXCEB4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbXCEB4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbXCEBzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:55:48 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38375 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbXCEBzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:22 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 04/13] fs/unionfs/: Several small cleanups in unionfs_interpose
Date: Sun,  4 Mar 2007 20:54:54 -0500
Message-Id: <11730597042630-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1) No need to lock the inode - lockdep was complaining about potential
circular dependency

2) No need to use temporary variable for iunique() inode number

3) Removed unneeded comment

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/main.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index bd64242..a37916d 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -66,19 +66,14 @@ int unionfs_interpose(struct dentry *dentry, struct super_block *sb, int flag)
 			err = -ENOMEM;
 			goto out;
 		}
-		mutex_lock(&inode->i_mutex);
 	} else {
-		ino_t ino;
 		/* get unique inode number for unionfs */
-		ino = iunique(sb, UNIONFS_ROOT_INO);
-
-		inode = iget(sb, ino);
+		inode = iget(sb, iunique(sb, UNIONFS_ROOT_INO));
 		if (!inode) {
-			err = -EACCES;	/* should be impossible??? */
+			err = -EACCES;
 			goto out;
 		}
 
-		mutex_lock(&inode->i_mutex);
 		if (atomic_read(&inode->i_count) > 1)
 			goto skip;
 	}
@@ -147,8 +142,6 @@ skip:
 		BUG();
 	}
 
-	mutex_unlock(&inode->i_mutex);
-
 out:
 	return err;
 }
-- 
1.5.0.2.260.g2eb065

