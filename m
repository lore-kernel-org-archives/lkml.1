Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbXKZQrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbXKZQrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbXKZQpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:39 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52782 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbXKZQp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:28 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 11/16] Unionfs: update times in setattr
Date: Mon, 26 Nov 2007 11:44:08 -0500
Message-Id: <11960954582192-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to maintain Unix semantics via utimes(2).

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index ef61d9c..63ff3d3 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -1090,6 +1090,18 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 	/* get the size from the first lower inode */
 	lower_inode = unionfs_lower_inode(inode);
 	unionfs_copy_attr_all(inode, lower_inode);
+	/*
+	 * unionfs_copy_attr_all will copy the lower times to our inode if
+	 * the lower ones are newer (useful for cache coherency).  However,
+	 * ->setattr is the only place in which we may have to copy the
+	 * lower inode times absolutely, to support utimes(2).
+	 */
+	if (ia->ia_valid & ATTR_MTIME_SET)
+		inode->i_mtime = lower_inode->i_mtime;
+	if (ia->ia_valid & ATTR_CTIME)
+		inode->i_ctime = lower_inode->i_ctime;
+	if (ia->ia_valid & ATTR_ATIME_SET)
+		inode->i_atime = lower_inode->i_atime;
 	fsstack_copy_inode_size(inode, lower_inode);
 	/* if setattr succeeded, then parent dir may have changed */
 	unionfs_copy_attr_times(dentry->d_parent->d_inode);
-- 
1.5.2.2

