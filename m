Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYCMNFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYCMNFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYCMNFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:05:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:35682 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754035AbYCMNFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:05:37 -0400
Date: Thu, 13 Mar 2008 14:05:35 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-list@namesys.com,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Michael Tokarev <mjt@tls.msk.ru>
Subject: [PATCH 3/4] ext4: Make ext4 handle quotaon on remount
Message-ID: <20080313130535.GI12523@duck.suse.cz>
References: <20080313125944.GF12523@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313125944.GF12523@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update ext4 to handle quotaon on remount RW.

Signed-off-by: Jan Kara <jack@suse.cz>

---
 super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 13383ba..5aaf03c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -813,7 +813,7 @@ static int ext4_acquire_dquot(struct dquot *dquot);
 static int ext4_release_dquot(struct dquot *dquot);
 static int ext4_mark_dquot_dirty(struct dquot *dquot);
 static int ext4_write_info(struct super_block *sb, int type);
-static int ext4_quota_on(struct super_block *sb, int type, int format_id, char *path);
+static int ext4_quota_on(struct super_block *sb, int type, int format_id, char *path, int remount);
 static int ext4_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
@@ -1632,7 +1632,7 @@ static void ext4_orphan_cleanup (struct super_block * sb,
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if (sb_dqopt(sb)->files[i])
-			vfs_quota_off(sb, i);
+			vfs_quota_off(sb, i, 0);
 	}
 #endif
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
@@ -3143,7 +3143,7 @@ static int ext4_quota_on_mount(struct super_block *sb, int type)
  * Standard function to be called on quota_on
  */
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
-			 char *path)
+			 char *path, int remount)
 {
 	int err;
 	struct nameidata nd;
@@ -3151,9 +3151,9 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	if (!test_opt(sb, QUOTA))
 		return -EINVAL;
 	/* Not journalling quota? */
-	if (!EXT4_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !EXT4_SB(sb)->s_qf_names[GRPQUOTA])
-		return vfs_quota_on(sb, type, format_id, path);
+	if ((!EXT4_SB(sb)->s_qf_names[USRQUOTA] &&
+	    !EXT4_SB(sb)->s_qf_names[GRPQUOTA]) || remount)
+		return vfs_quota_on(sb, type, format_id, path, remount);
 	err = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (err)
 		return err;
@@ -3168,7 +3168,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 			"EXT4-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
 	path_put(&nd.path);
-	return vfs_quota_on(sb, type, format_id, path);
+	return vfs_quota_on(sb, type, format_id, path, remount);
 }
 
 /* Read data from quotafile - avoid pagecache and such because we cannot afford
