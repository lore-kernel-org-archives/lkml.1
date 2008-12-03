Return-Path: <linux-kernel-owner+w=401wt.eu-S1762003AbYLCUcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003AbYLCUcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbYLCUBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:01:54 -0500
Received: from kumera.dghda.com ([80.68.90.171]:2865 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723AbYLCUBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:01:53 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: akpm@linux-foundation.org
Cc: Andreas Dilger <adilger@sun.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Duane Griffin <duaneg@dghda.com>
Subject: [PATCH 1/6] ext2: don't inherit inappropriate inode flags from parent
Date: Wed,  3 Dec 2008 19:54:58 +0000
Message-Id: <1228334103-15948-2-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
References: <1228334103-15948-1-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present BTREE/INDEX is the only flag that new ext2 inodes do NOT
inherit from their parent. In addition prevent the flags DIRTY, ECOMPR,
INDEX, IMAGIC and TOPDIR from being inherited. List inheritable flags
explicitly to prevent future flags from accidentally being inherited.

This fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/ext2/ialloc.c        |    2 +-
 include/linux/ext2_fs.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 8d0add6..8c1897e 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -565,7 +565,7 @@ got:
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	memset(ei->i_data, 0, sizeof(ei->i_data));
-	ei->i_flags = EXT2_I(dir)->i_flags & ~EXT2_BTREE_FL;
+	ei->i_flags = EXT2_I(dir)->i_flags & EXT2_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT2_IMMUTABLE_FL|EXT2_APPEND_FL);
 	/* dirsync is only applied to directories */
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 78c775a..c3a0518 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -194,6 +194,13 @@ struct ext2_group_desc
 #define EXT2_FL_USER_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
 #define EXT2_FL_USER_MODIFIABLE		FS_FL_USER_MODIFIABLE	/* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT2_FL_INHERITED (EXT2_SECRM_FL | EXT2_UNRM_FL | EXT2_COMPR_FL |\
+			   EXT2_SYNC_FL | EXT2_IMMUTABLE_FL | EXT2_APPEND_FL |\
+			   EXT2_NODUMP_FL | EXT2_NOATIME_FL | EXT2_COMPRBLK_FL|\
+			   EXT2_NOCOMP_FL | EXT2_JOURNAL_DATA_FL |\
+			   EXT2_NOTAIL_FL | EXT2_DIRSYNC_FL)
+
 /*
  * ioctl commands
  */
-- 
1.5.6.4

