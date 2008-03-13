Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYCMNFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYCMNFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYCMNEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:04:50 -0400
Received: from styx.suse.cz ([82.119.242.94]:44000 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753094AbYCMNEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:04:48 -0400
Date: Thu, 13 Mar 2008 14:04:47 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH 2/4] ext3: Make ext3 handle quotaon on remount
Message-ID: <20080313130447.GH12523@duck.suse.cz>
References: <20080313125944.GF12523@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313125944.GF12523@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update ext3 handle quotaon on remount RW.

Signed-off-by: Jan Kara <jack@suse.cz>

---
 super.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index ad53606..5711d24 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -685,7 +685,7 @@ static int ext3_acquire_dquot(struct dquot *dquot);
 static int ext3_release_dquot(struct dquot *dquot);
 static int ext3_mark_dquot_dirty(struct dquot *dquot);
 static int ext3_write_info(struct super_block *sb, int type);
-static int ext3_quota_on(struct super_block *sb, int type, int format_id, char *path);
+static int ext3_quota_on(struct super_block *sb, int type, int format_id, char *path, int remount);
 static int ext3_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
@@ -1415,7 +1415,7 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if (sb_dqopt(sb)->files[i])
-			vfs_quota_off(sb, i);
+			vfs_quota_off(sb, i, 0);
 	}
 #endif
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
@@ -2743,17 +2743,17 @@ static int ext3_quota_on_mount(struct super_block *sb, int type)
  * Standard function to be called on quota_on
  */
 static int ext3_quota_on(struct super_block *sb, int type, int format_id,
-			 char *path)
+			 char *path, int remount)
 {
 	int err;
 	struct nameidata nd;
 
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
-	/* Not journalling quota? */
-	if (!EXT3_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !EXT3_SB(sb)->s_qf_names[GRPQUOTA])
-		return vfs_quota_on(sb, type, format_id, path);
+	/* Not journalling quota or remount? */
+	if ((!EXT3_SB(sb)->s_qf_names[USRQUOTA] &&
+	    !EXT3_SB(sb)->s_qf_names[GRPQUOTA]) || remount)
+		return vfs_quota_on(sb, type, format_id, path, remount);
 	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (err)
 		return err;
@@ -2762,13 +2762,13 @@ static int ext3_quota_on(struct super_block *sb, int type, int format_id,
 		path_put(&nd.path);
 		return -EXDEV;
 	}
-	/* Quotafile not of fs root? */
+	/* Quotafile not in fs root? */
 	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
 		printk(KERN_WARNING
 			"EXT3-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
 	path_put(&nd.path);
-	return vfs_quota_on(sb, type, format_id, path);
+	return vfs_quota_on(sb, type, format_id, path, remount);
 }
 
 /* Read data from quotafile - avoid pagecache and such because we cannot afford
