Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbXICCf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbXICCf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbXICC0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:11 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57698 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbXICCZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:25:13 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 18/32] Unionfs: unionfs_ioctl bug fixes
Date: Sun,  2 Sep 2007 22:20:41 -0400
Message-Id: <11887860582504-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Properly update lower objects, and release lower mnts upon ioctl success or
failure.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 1050c49..eee68b8 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -684,12 +684,15 @@ static int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
 {
 	int err = 0;
 	fd_set branchlist;
-
 	int bstart = 0, bend = 0, bindex = 0;
+	int orig_bstart, orig_bend;
 	struct dentry *dentry, *lower_dentry;
+	struct vfsmount *mnt;
 
-	dentry = file->f_dentry;
+	dentry = file->f_path.dentry;
 	unionfs_lock_dentry(dentry);
+	orig_bstart = dbstart(dentry);
+	orig_bend = dbend(dentry);
 	if ((err = unionfs_partial_lookup(dentry)))
 		goto out;
 	bstart = dbstart(dentry);
@@ -703,7 +706,25 @@ static int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
 			continue;
 		if (lower_dentry->d_inode)
 			FD_SET(bindex, &branchlist);
+		/* purge any lower objects after partial_lookup */
+		if (bindex < orig_bstart || bindex > orig_bend) {
+			dput(lower_dentry);
+			unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
+			iput(unionfs_lower_inode_idx(dentry->d_inode, bindex));
+			unionfs_set_lower_inode_idx(dentry->d_inode, bindex,
+						    NULL);
+			mnt = unionfs_lower_mnt_idx(dentry, bindex);
+			if (!mnt)
+				continue;
+			unionfs_mntput(dentry, bindex);
+			unionfs_set_lower_mnt_idx(dentry, bindex, NULL);
+		}
 	}
+	/* restore original dentry's offsets */
+	set_dbstart(dentry, orig_bstart);
+	set_dbend(dentry, orig_bend);
+	ibstart(dentry->d_inode) = orig_bstart;
+	ibend(dentry->d_inode) = orig_bend;
 
 	err = copy_to_user((void __user *)arg, &branchlist, sizeof(fd_set));
 	if (err)
-- 
1.5.2.2.238.g7cbf2f2

