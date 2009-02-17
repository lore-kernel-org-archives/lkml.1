Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZBQIMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZBQIMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZBQIK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:10:56 -0500
Received: from sh.osrg.net ([192.16.179.4]:55127 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZBQIKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:10:48 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH mmotm 4/6] nilfs2: use unlocked_ioctl
Date: Tue, 17 Feb 2009 16:42:04 +0900
Message-Id: <1234856526-1947-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Feb 2009 17:10:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg suggested converting ->ioctl operations to use
->unlocked_ioctl to avoid BKL.

The conversion was verified to be safe, so I will take it on this
occasion.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/dir.c   |    2 +-
 fs/nilfs2/file.c  |    2 +-
 fs/nilfs2/ioctl.c |    4 ++--
 fs/nilfs2/nilfs.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 393316c..54100ac 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -702,7 +702,7 @@ struct file_operations nilfs_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= nilfs_readdir,
-	.ioctl		= nilfs_ioctl,
+	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 1670038..df74577 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -138,7 +138,7 @@ struct file_operations nilfs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
-	.ioctl		= nilfs_ioctl,
+	.unlocked_ioctl	= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_ioctl,
 #endif	/* CONFIG_COMPAT */
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 33aff88..cfb2789 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -600,9 +600,9 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
 	return 0;
 }
 
-int nilfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		unsigned long arg)
+long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	void __user *argp = (void * __user *)arg;
 
 	switch (cmd) {
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index ad17fa9..f865ecb 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -242,7 +242,7 @@ extern void nilfs_set_link(struct inode *, struct nilfs_dir_entry *,
 extern int nilfs_sync_file(struct file *, struct dentry *, int);
 
 /* ioctl.c */
-int nilfs_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+long nilfs_ioctl(struct file *, unsigned int, unsigned long);
 int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *, void __user *);
 
 /* inode.c */
-- 
1.5.6.5

