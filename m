Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXL1Uuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXL1Uuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXL1UoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:25 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37180 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbXL1UoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:44:00 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 29/30] Unionfs: implement d_iput method
Date: Fri, 28 Dec 2007 15:43:03 -0500
Message-Id: <11988745981620-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to drop lower objects early enough, under certain conditions,
so the lower objects don't stay behind until umount(). [LTP testing]

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dentry.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index 0e89308..0369d93 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -484,7 +484,49 @@ out:
 	return;
 }
 
+/*
+ * Called when we're removing the last reference to our dentry.  So we
+ * should drop all lower references too.
+ */
+static void unionfs_d_iput(struct dentry *dentry, struct inode *inode)
+{
+	int bindex, rc;
+
+	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
+
+	if (dbstart(dentry) < 0)
+		goto drop_lower_inodes;
+	for (bindex = dbstart(dentry); bindex <= dbend(dentry); bindex++) {
+		if (unionfs_lower_mnt_idx(dentry, bindex)) {
+			unionfs_mntput(dentry, bindex);
+			unionfs_set_lower_mnt_idx(dentry, bindex, NULL);
+		}
+		if (unionfs_lower_dentry_idx(dentry, bindex)) {
+			dput(unionfs_lower_dentry_idx(dentry, bindex));
+			unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
+		}
+	}
+	set_dbstart(dentry, -1);
+	set_dbend(dentry, -1);
+
+drop_lower_inodes:
+	rc = atomic_read(&inode->i_count);
+	if (rc == 1 && inode->i_nlink == 1 && ibstart(inode) >= 0) {
+		/* see Documentation/filesystems/unionfs/issues.txt */
+		lockdep_off();
+		iput(unionfs_lower_inode(inode));
+		lockdep_on();
+		unionfs_set_lower_inode(inode, NULL);
+		/* XXX: may need to set start/end to -1? */
+	}
+
+	iput(inode);
+
+	unionfs_read_unlock(dentry->d_sb);
+}
+
 struct dentry_operations unionfs_dops = {
 	.d_revalidate	= unionfs_d_revalidate,
 	.d_release	= unionfs_d_release,
+	.d_iput		= unionfs_d_iput,
 };
-- 
1.5.2.2

