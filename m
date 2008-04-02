Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbYDBUlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbYDBUlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764111AbYDBU0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:26:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:35369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764101AbYDBU0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:26:20 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: [PATCH 59/62] ocfs2: Convert ocfs2 over to unlocked_ioctl
Date: Wed,  2 Apr 2008 13:24:55 -0700
Message-Id: <1207167898446-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: 12071673121124-git-send-email-mfasheh@suse.com
References: 12071673121124-git-send-email-mfasheh@suse.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi-suse@firstfloor.org>

As far as I can see there is nothing in ocfs2_ioctl that requires the BKL,
so use unlocked_ioctl

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/file.c  |    4 ++--
 fs/ocfs2/ioctl.c |   12 +++---------
 fs/ocfs2/ioctl.h |    3 +--
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ed5d523..9154c82 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2242,7 +2242,7 @@ const struct file_operations ocfs2_fops = {
 	.open		= ocfs2_file_open,
 	.aio_read	= ocfs2_file_aio_read,
 	.aio_write	= ocfs2_file_aio_write,
-	.ioctl		= ocfs2_ioctl,
+	.unlocked_ioctl	= ocfs2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
@@ -2258,7 +2258,7 @@ const struct file_operations ocfs2_dops = {
 	.fsync		= ocfs2_sync_file,
 	.release	= ocfs2_dir_release,
 	.open		= ocfs2_dir_open,
-	.ioctl		= ocfs2_ioctl,
+	.unlocked_ioctl	= ocfs2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index ab1c216..b413166 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -113,9 +113,9 @@ bail:
 	return status;
 }
 
-int ocfs2_ioctl(struct inode * inode, struct file * filp,
-	unsigned int cmd, unsigned long arg)
+long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int flags;
 	int new_clusters;
 	int status;
@@ -169,9 +169,6 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 #ifdef CONFIG_COMPAT
 long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int ret;
-
 	switch (cmd) {
 	case OCFS2_IOC32_GETFLAGS:
 		cmd = OCFS2_IOC_GETFLAGS;
@@ -191,9 +188,6 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return -ENOIOCTLCMD;
 	}
 
-	lock_kernel();
-	ret = ocfs2_ioctl(inode, file, cmd, arg);
-	unlock_kernel();
-	return ret;
+	return ocfs2_ioctl(file, cmd, arg);
 }
 #endif
diff --git a/fs/ocfs2/ioctl.h b/fs/ocfs2/ioctl.h
index 4d6c4f4..cf9a5ee 100644
--- a/fs/ocfs2/ioctl.h
+++ b/fs/ocfs2/ioctl.h
@@ -10,8 +10,7 @@
 #ifndef OCFS2_IOCTL_H
 #define OCFS2_IOCTL_H
 
-int ocfs2_ioctl(struct inode * inode, struct file * filp,
-	unsigned int cmd, unsigned long arg);
+long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg);
 
 #endif /* OCFS2_IOCTL_H */
-- 
1.5.4.1

