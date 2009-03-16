Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZCPDRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZCPDRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZCPDQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:16:59 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:27214
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbZCPDQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:16:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIphvUl8qWbQ/2dsb2JhbADQQYN/Bg
X-IronPort-AV: E=Sophos;i="4.38,370,1233500400"; 
   d="scan'208";a="325654582"
From: Ian Kent <raven@themaw.net>
Subject: [REPOST PATCH] autofs4 - cleanup expire code duplication
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 16 Mar 2009 12:16:53 +0900
Message-ID: <20090316031653.26866.50267.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A significant portion of the autofs_dev_ioctl_expire() and
autofs4_expire_multi() functions is duplicated code. This patch
cleans that up.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---

 fs/autofs4/autofs_i.h  |    2 ++
 fs/autofs4/dev-ioctl.c |   29 +----------------------------
 fs/autofs4/expire.c    |   27 +++++++++++++++++----------
 3 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index a768031..b7ff33c 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -186,6 +186,8 @@ int autofs4_expire_wait(struct dentry *dentry);
 int autofs4_expire_run(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *,
 			struct autofs_packet_expire __user *);
+int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			    struct autofs_sb_info *sbi, int when);
 int autofs4_expire_multi(struct super_block *, struct vfsmount *,
 			struct autofs_sb_info *, int __user *);
 struct dentry *autofs4_expire_direct(struct super_block *sb,
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 025e105..9e5ae8a 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -525,40 +525,13 @@ static int autofs_dev_ioctl_expire(struct file *fp,
 				   struct autofs_sb_info *sbi,
 				   struct autofs_dev_ioctl *param)
 {
-	struct dentry *dentry;
 	struct vfsmount *mnt;
-	int err = -EAGAIN;
 	int how;
 
 	how = param->expire.how;
 	mnt = fp->f_path.mnt;
 
-	if (autofs_type_trigger(sbi->type))
-		dentry = autofs4_expire_direct(sbi->sb, mnt, sbi, how);
-	else
-		dentry = autofs4_expire_indirect(sbi->sb, mnt, sbi, how);
-
-	if (dentry) {
-		struct autofs_info *ino = autofs4_dentry_ino(dentry);
-
-		/*
-		 * This is synchronous because it makes the daemon a
-		 * little easier
-		*/
-		err = autofs4_wait(sbi, dentry, NFY_EXPIRE);
-
-		spin_lock(&sbi->fs_lock);
-		if (ino->flags & AUTOFS_INF_MOUNTPOINT) {
-			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
-			sbi->sb->s_root->d_mounted++;
-		}
-		ino->flags &= ~AUTOFS_INF_EXPIRING;
-		complete_all(&ino->expire_complete);
-		spin_unlock(&sbi->fs_lock);
-		dput(dentry);
-	}
-
-	return err;
+	return autofs4_do_expire_multi(sbi->sb, mnt, sbi, how);
 }
 
 /* Check if autofs mount point is in use */
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index e3bd507..75f7dda 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -478,22 +478,16 @@ int autofs4_expire_run(struct super_block *sb,
 	return ret;
 }
 
-/* Call repeatedly until it returns -EAGAIN, meaning there's nothing
-   more to be done */
-int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
-			struct autofs_sb_info *sbi, int __user *arg)
+int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			    struct autofs_sb_info *sbi, int when)
 {
 	struct dentry *dentry;
 	int ret = -EAGAIN;
-	int do_now = 0;
-
-	if (arg && get_user(do_now, arg))
-		return -EFAULT;
 
 	if (autofs_type_trigger(sbi->type))
-		dentry = autofs4_expire_direct(sb, mnt, sbi, do_now);
+		dentry = autofs4_expire_direct(sb, mnt, sbi, when);
 	else
-		dentry = autofs4_expire_indirect(sb, mnt, sbi, do_now);
+		dentry = autofs4_expire_indirect(sb, mnt, sbi, when);
 
 	if (dentry) {
 		struct autofs_info *ino = autofs4_dentry_ino(dentry);
@@ -516,3 +510,16 @@ int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 	return ret;
 }
 
+/* Call repeatedly until it returns -EAGAIN, meaning there's nothing
+   more to be done */
+int autofs4_expire_multi(struct super_block *sb, struct vfsmount *mnt,
+			struct autofs_sb_info *sbi, int __user *arg)
+{
+	int do_now = 0;
+
+	if (arg && get_user(do_now, arg))
+		return -EFAULT;
+
+	return autofs4_do_expire_multi(sb, mnt, sbi, do_now);
+}
+

