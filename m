Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZASR2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZASR2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZASR0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:26:25 -0500
Received: from ns2.suse.de ([195.135.220.15]:49833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609AbZASR0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:26:23 -0500
Message-ID: <4974B92D.6040803@suse.de>
Date: Tue, 20 Jan 2009 01:32:29 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/20] fs/efs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes efs return f_fsid info for statfs(2), and does a little variable renaming in
efs_statfs().

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/efs/super.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/efs/super.c b/fs/efs/super.c
index 73b19cf..f049428 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -329,18 +329,22 @@ out_no_fs:
 }

 static int efs_statfs(struct dentry *dentry, struct kstatfs *buf) {
-	struct efs_sb_info *sb = SUPER_INFO(dentry->d_sb);
+	struct super_block *sb = dentry->d_sb;
+	struct efs_sb_info *sbi = SUPER_INFO(sb);
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	buf->f_type    = EFS_SUPER_MAGIC;	/* efs magic number */
 	buf->f_bsize   = EFS_BLOCKSIZE;		/* blocksize */
-	buf->f_blocks  = sb->total_groups *	/* total data blocks */
-			(sb->group_size - sb->inode_blocks);
-	buf->f_bfree   = sb->data_free;		/* free data blocks */
-	buf->f_bavail  = sb->data_free;		/* free blocks for non-root */
-	buf->f_files   = sb->total_groups *	/* total inodes */
-			sb->inode_blocks *
+	buf->f_blocks  = sbi->total_groups *	/* total data blocks */
+			(sbi->group_size - sbi->inode_blocks);
+	buf->f_bfree   = sbi->data_free;	/* free data blocks */
+	buf->f_bavail  = sbi->data_free;	/* free blocks for non-root */
+	buf->f_files   = sbi->total_groups *	/* total inodes */
+			sbi->inode_blocks *
 			(EFS_BLOCKSIZE / sizeof(struct efs_dinode));
-	buf->f_ffree   = sb->inode_free;	/* free inodes */
+	buf->f_ffree   = sbi->inode_free;	/* free inodes */
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = EFS_MAXNAMELEN;	/* max filename length */

 	return 0;

-- 
Coly Li
SuSE Labs



