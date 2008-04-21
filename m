Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbYDUQp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYDUQp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYDUQpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:45:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:34474 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754584AbYDUQpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:45:17 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, urhausen@urifabi.net,
       Jan Kara <jack@suse.cz>
Subject: [PATCH] reiserfs: Unpack tails on quota files
Date: Mon, 21 Apr 2008 18:45:14 +0200
Message-Id: <12087963143563-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: y
References: y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quota files cannot have tails because quota_write and quota_read functions do
not support them. So far when quota files did have tail, we just refused to
turn quotas on it. Sadly this check has been wrong and so there are now plenty
installations where quota files don't have NOTAIL flag set and so now after
fixing the check, they suddently fail to turn quotas on. Since it's easy to
unpack the tail from kernel, do this from reiserfs_quota_on() which solves the
problem and is generally nicer to users anyway.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: urhausen@urifabi.net

---
 fs/reiserfs/ioctl.c         |    4 +---
 fs/reiserfs/super.c         |   17 ++++++++++++-----
 include/linux/reiserfs_fs.h |    1 +
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index e0f0f09..9f877ab 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -11,8 +11,6 @@
 #include <linux/smp_lock.h>
 #include <linux/compat.h>
 
-static int reiserfs_unpack(struct inode *inode, struct file *filp);
-
 /*
 ** reiserfs_ioctl - handler for ioctl for inode
 ** supported commands:
@@ -140,7 +138,7 @@ int reiserfs_prepare_write(struct file *f, struct page *page,
 ** Function try to convert tail from direct item into indirect.
 ** It set up nopack attribute in the REISERFS_I(inode)->nopack
 */
-static int reiserfs_unpack(struct inode *inode, struct file *filp)
+int reiserfs_unpack(struct inode *inode, struct file *filp)
 {
 	int retval = 0;
 	int index;
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 65e17e1..1dfbc7d 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2025,6 +2025,7 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 {
 	int err;
 	struct nameidata nd;
+	struct inode *inode;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
@@ -2036,12 +2037,18 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 		path_put(&nd.path);
 		return -EXDEV;
 	}
+	inode = nd.path.dentry->d_inode;
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
-	if (!(REISERFS_I(nd.path.dentry->d_inode)->i_flags & i_nopack_mask)) {
-		reiserfs_warning(sb,
-				 "reiserfs: Quota file must have tail packing disabled.");
-		path_put(&nd.path);
-		return -EINVAL;
+	if (!(REISERFS_I(inode)->i_flags & i_nopack_mask)) {
+		err = reiserfs_unpack(inode, NULL);
+		if (err) {
+			reiserfs_warning(sb,
+				"reiserfs: Unpacking tail of quota file failed"
+				" (%d). Cannot turn on quotas.", err);
+			path_put(&nd.path);
+			return -EINVAL;
+		}
+		mark_inode_dirty(inode);
 	}
 	/* Not journalling quota? No more tests needed... */
 	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 8e7eff2..4aacaee 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2176,6 +2176,7 @@ int reiserfs_ioctl(struct inode *inode, struct file *filp,
 		   unsigned int cmd, unsigned long arg);
 long reiserfs_compat_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
+int reiserfs_unpack(struct inode *inode, struct file *filp);
 
 /* ioctl's command */
 #define REISERFS_IOC_UNPACK		_IOW(0xCD,1,long)
-- 
1.5.2.4

