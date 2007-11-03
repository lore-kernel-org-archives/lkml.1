Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbXKCBXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbXKCBXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXKCBXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:23:13 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35194 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXKCBXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:23:12 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 1/8] Unionfs: delete whiteouts in sticky directories
Date: Fri,  2 Nov 2007 21:22:42 -0400
Message-Id: <11940529693030-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
References: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to maintain Unix semantics.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 6ca52f4..f4facf4 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -90,6 +90,23 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 			err = vfs_unlink(lower_dir_dentry->d_inode, wh_dentry);
 			unlock_dir(lower_dir_dentry);
 
+			/*
+			 * Whiteouts are special files and should be deleted
+			 * no matter what (as if they never existed), in
+			 * order to allow this create operation to succeed.
+			 * This is especially important in sticky
+			 * directories: a whiteout may have been created by
+			 * one user, but the newly created file may be
+			 * created by another user.  Therefore, in order to
+			 * maintain Unix semantics, if the vfs_unlink above
+			 * ailed, then we have to try to directly unlink the
+			 * whiteout.  Note: in the ODF version of unionfs,
+			 * whiteout are handled much more cleanly.
+			 */
+			if (err == -EPERM) {
+				struct inode *inode = lower_dir_dentry->d_inode;
+				err = inode->i_op->unlink(inode, wh_dentry);
+			}
 			if (err) {
 				printk(KERN_ERR "unionfs: create: could not "
 				       "unlink whiteout, err = %d\n", err);
-- 
1.5.2.2

