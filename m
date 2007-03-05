Return-Path: <linux-kernel-owner+w=401wt.eu-S1750735AbXCEB6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750735AbXCEB6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXCEB6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:58:30 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38359 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbXCEBzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:13 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 01/13] fs/unionfs: Fix a memory leak & null pointer dereference
Date: Sun,  4 Mar 2007 20:54:51 -0500
Message-Id: <11730597042675-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 379c525..66d6ce9 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -230,7 +230,7 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	unionfs_read_lock(sb);
 	if (!unionfs_d_revalidate(dentry, NULL) && !d_deleted(dentry)) {
 		err = -ESTALE;
-		goto out;
+		goto out_nofree;
 	}
 
 	sbgen = atomic_read(&UNIONFS_SB(sb)->generation);
@@ -286,6 +286,9 @@ int unionfs_file_revalidate(struct file *file, int willwrite)
 	}
 
 out:
+	if (err)
+		kfree(UNIONFS_F(file)->lower_files);
+out_nofree:
 	unionfs_unlock_dentry(dentry);
 	unionfs_read_unlock(dentry->d_sb);
 	return err;
@@ -391,7 +394,7 @@ int unionfs_open(struct inode *inode, struct file *file)
 	file->private_data = kzalloc(sizeof(struct unionfs_file_info), GFP_KERNEL);
 	if (!UNIONFS_F(file)) {
 		err = -ENOMEM;
-		goto out;
+		goto out_nofree;
 	}
 	fbstart(file) = -1;
 	fbend(file) = -1;
@@ -444,7 +447,7 @@ out:
 		kfree(UNIONFS_F(file)->lower_files);
 		kfree(UNIONFS_F(file));
 	}
-
+out_nofree:
 	return err;
 }
 
-- 
1.5.0.2.260.g2eb065

