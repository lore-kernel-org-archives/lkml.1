Return-Path: <linux-kernel-owner+w=401wt.eu-S965070AbXBQI5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965070AbXBQI5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965074AbXBQI5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:57:09 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33987 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073AbXBQI5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:57:07 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Michael Halcrow <mhalcrow@us.ibm.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/2] eCryptfs: convert lookup_one_len() to lookup_one_len_nd()
Date: Sat, 17 Feb 2007 03:56:55 -0500
Message-Id: <11717026163831-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.19.gddff
In-Reply-To: <11717026161843-git-send-email-jsipek@cs.sunysb.edu>
References: <11717026161843-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Halcrow <mhalcrow@us.ibm.com>

Call the new lookup_one_len_nd() rather than lookup_one_len().  This fixes an
oops when stacked on NFS.

Note that there are still some issues with eCryptfs on NFS having to do with
directory deletion (I'm not getting an oops, just an -EBUSY).

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/ecryptfs/inode.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 11f5e50..4c3d786 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -283,7 +283,9 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 	int rc = 0;
 	struct dentry *lower_dir_dentry;
 	struct dentry *lower_dentry;
+	struct dentry *dentry_save;
 	struct vfsmount *lower_mnt;
+	struct vfsmount *mnt_save;
 	char *encoded_name;
 	unsigned int encoded_namelen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
@@ -310,9 +312,13 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 	ecryptfs_printk(KERN_DEBUG, "encoded_name = [%s]; encoded_namelen "
 			"= [%d]\n", encoded_name, encoded_namelen);
-	lower_dentry = lookup_one_len(encoded_name, lower_dir_dentry,
-				      encoded_namelen - 1);
+	dentry_save = nd->dentry;
+	mnt_save = nd->mnt;
+	lower_dentry = lookup_one_len_nd(encoded_name, lower_dir_dentry,
+					 (encoded_namelen - 1), nd);
 	kfree(encoded_name);
+	nd->mnt = mnt_save;
+	nd->dentry = dentry_save;
 	if (IS_ERR(lower_dentry)) {
 		ecryptfs_printk(KERN_ERR, "ERR from lower_dentry\n");
 		rc = PTR_ERR(lower_dentry);
-- 
1.5.0.19.gddff

