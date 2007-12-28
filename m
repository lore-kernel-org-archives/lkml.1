Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbXL1Uu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbXL1Uu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbXL1UoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:21 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37171 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbXL1Un4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:56 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 27/30] Unionfs: cleanup lower inodes after successful unlink
Date: Fri, 28 Dec 2007 15:43:01 -0500
Message-Id: <1198874598761-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/unlink.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 1e81494..a1c82b6 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -91,7 +91,9 @@ out:
 int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int err = 0;
+	struct inode *inode = dentry->d_inode;
 
+	BUG_ON(S_ISDIR(inode->i_mode));
 	unionfs_read_lock(dentry->d_sb, UNIONFS_SMUTEX_CHILD);
 	unionfs_lock_dentry(dentry, UNIONFS_DMUTEX_CHILD);
 
@@ -104,8 +106,13 @@ int unionfs_unlink(struct inode *dir, struct dentry *dentry)
 	err = unionfs_unlink_whiteout(dir, dentry);
 	/* call d_drop so the system "forgets" about us */
 	if (!err) {
-		if (!S_ISDIR(dentry->d_inode->i_mode))
-			unionfs_postcopyup_release(dentry);
+		unionfs_postcopyup_release(dentry);
+		if (inode->i_nlink == 0) {
+			/* drop lower inodes */
+			iput(unionfs_lower_inode(inode));
+			unionfs_set_lower_inode(inode, NULL);
+			ibstart(inode) = ibend(inode) = -1;
+		}
 		d_drop(dentry);
 		/*
 		 * if unlink/whiteout succeeded, parent dir mtime has
-- 
1.5.2.2

