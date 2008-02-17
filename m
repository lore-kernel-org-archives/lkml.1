Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYBQC6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYBQC6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYBQC5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:57:45 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36232 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYBQC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:57:42 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 01/17] Unionfs: grab lower super_block references
Date: Sat, 16 Feb 2008 21:57:10 -0500
Message-Id: <12032170471901-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents the lower super_block from being destroyed too early, when a
lower file system is being unmounted with MNT_FORCE or MNT_DETACH.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c  |    3 +++
 fs/unionfs/super.c |   14 ++++++++++++++
 fs/unionfs/union.h |    2 +-
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 23c18f7..ba3471d 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -636,6 +636,7 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	sbend(sb) = bend = lower_root_info->bend;
 	for (bindex = bstart; bindex <= bend; bindex++) {
 		struct dentry *d = lower_root_info->lower_paths[bindex].dentry;
+		atomic_inc(&d->d_sb->s_active);
 		unionfs_set_lower_super_idx(sb, bindex, d->d_sb);
 	}
 
@@ -711,6 +712,8 @@ out_dput:
 			dput(d);
 			/* initializing: can't use unionfs_mntput here */
 			mntput(m);
+			/* drop refs we took earlier */
+			atomic_dec(&d->d_sb->s_active);
 		}
 		kfree(lower_root_info->lower_paths);
 		kfree(lower_root_info);
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 986c980..175840f 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -116,6 +116,14 @@ static void unionfs_put_super(struct super_block *sb)
 		}
 	BUG_ON(leaks != 0);
 
+	/* decrement lower super references */
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		struct super_block *s;
+		s = unionfs_lower_super_idx(sb, bindex);
+		unionfs_set_lower_super_idx(sb, bindex, NULL);
+		atomic_dec(&s->s_active);
+	}
+
 	kfree(spd->data);
 	kfree(spd);
 	sb->s_fs_info = NULL;
@@ -729,6 +737,12 @@ out_no_change:
 	 */
 	purge_sb_data(sb);
 
+	/* grab new lower super references; release old ones */
+	for (i = 0; i < new_branches; i++)
+		atomic_inc(&new_data[i].sb->s_active);
+	for (i = 0; i < new_branches; i++)
+		atomic_dec(&UNIONFS_SB(sb)->data[i].sb->s_active);
+
 	/* copy new vectors into their correct place */
 	tmp_data = UNIONFS_SB(sb)->data;
 	UNIONFS_SB(sb)->data = new_data;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 4b4d6c9..786c4be 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -127,7 +127,7 @@ struct unionfs_dentry_info {
 
 /* These are the pointers to our various objects. */
 struct unionfs_data {
-	struct super_block *sb;
+	struct super_block *sb;	/* lower super_block */
 	atomic_t open_files;	/* number of open files on branch */
 	int branchperms;
 	int branch_id;		/* unique branch ID at re/mount time */
-- 
1.5.2.2

