Return-Path: <linux-kernel-owner+w=401wt.eu-S933188AbXF2H2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbXF2H2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932897AbXF2H0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:26:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46312 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762814AbXF2H0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:26:33 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 2/5] Unionfs: Add missing unlock call in unionfs_file_release
Date: Fri, 29 Jun 2007 03:26:18 -0400
Message-Id: <1183101982279-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
References: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 6d87426..8527ac6 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -559,7 +559,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 	 * support.
 	 */
 	if ((err = unionfs_file_revalidate(file, 1)))
-		return err;
+		goto out;
 	fileinfo = UNIONFS_F(file);
 	BUG_ON(file->f_dentry->d_inode != inode);
 	inodeinfo = UNIONFS_I(inode);
@@ -596,7 +596,9 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 		fileinfo->rdstate = NULL;
 	}
 	kfree(fileinfo);
-	return 0;
+out:
+	unionfs_read_unlock(sb);
+	return err;
 }
 
 /* pass the ioctl to the lower fs */
-- 
1.5.2.2.238.g7cbf2f2

