Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYEIULX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYEIULX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYEIULH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:11:07 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37474 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYEIULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:11:04 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 1/2] Unionfs: use new umount_begin prototype
Date: Fri,  9 May 2008 16:07:15 -0400
Message-Id: <12103636373706-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12103636363945-git-send-email-ezk@cs.sunysb.edu>
References: <12103636363945-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/super.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 82b4045..b110760 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -961,32 +961,21 @@ static int unionfs_write_inode(struct inode *inode, int sync)
  * Used only in nfs, to kill any pending RPC tasks, so that subsequent
  * code can actually succeed and won't leave tasks that need handling.
  */
-static void unionfs_umount_begin(struct vfsmount *mnt, int flags)
+static void unionfs_umount_begin(struct super_block *sb)
 {
-	struct super_block *sb, *lower_sb;
-	struct vfsmount *lower_mnt;
+	struct super_block *lower_sb;
 	int bindex, bstart, bend;
 
-	if (!(flags & MNT_FORCE))
-		/*
-		 * we are not being MNT_FORCE'd, therefore we should emulate
-		 * old behavior
-		 */
-		return;
-
-	sb = mnt->mnt_sb;
-
 	unionfs_read_lock(sb, UNIONFS_SMUTEX_CHILD);
 
 	bstart = sbstart(sb);
 	bend = sbend(sb);
 	for (bindex = bstart; bindex <= bend; bindex++) {
-		lower_mnt = unionfs_lower_mnt_idx(sb->s_root, bindex);
 		lower_sb = unionfs_lower_super_idx(sb, bindex);
 
-		if (lower_mnt && lower_sb && lower_sb->s_op &&
+		if (lower_sb && lower_sb->s_op &&
 		    lower_sb->s_op->umount_begin)
-			lower_sb->s_op->umount_begin(lower_mnt, flags);
+			lower_sb->s_op->umount_begin(lower_sb);
 	}
 
 	unionfs_read_unlock(sb);
-- 
1.5.2.2

