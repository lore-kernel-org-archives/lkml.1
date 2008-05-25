Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYEYSEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYEYSEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbYEYSDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:03:53 -0400
Received: from atflat.net ([80.229.16.180]:43721 "EHLO holly.atflat.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756211AbYEYSDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:03:51 -0400
From: Tom Spink <tspink@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tom Spink <tspink@gmail.com>
Subject: [RFC PATCH 2/2] xfs: Make XFS use the new file system init infrastructure
Date: Sun, 25 May 2008 18:48:19 +0100
Message-Id: <1211737699-25615-3-git-send-email-tspink@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1211737699-25615-2-git-send-email-tspink@gmail.com>
References: <>
 <1211737699-25615-1-git-send-email-tspink@gmail.com>
 <1211737699-25615-2-git-send-email-tspink@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes XFS use the file system type specific init and exit
callbacks, so that XFS only initialises when it's used for the first
time.

This is useful for when XFS is compiled into the kernel, but never
actually used as it stops XFS from creating global threads, until
they are needed.

Signed-off-by: Tom Spink <tspink@gmail.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   55 +++++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 742b2c7..3e7340a 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1422,23 +1422,9 @@ static struct quotactl_ops xfs_quotactl_operations = {
 	.set_xquota		= xfs_fs_setxquota,
 };
 
-static struct file_system_type xfs_fs_type = {
-	.owner			= THIS_MODULE,
-	.name			= "xfs",
-	.get_sb			= xfs_fs_get_sb,
-	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
-};
-
-
-STATIC int __init
-init_xfs_fs( void )
+static int xfs_fs_init(void)
 {
-	int			error;
-	static char		message[] __initdata = KERN_INFO \
-		XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled\n";
-
-	printk(message);
+	int error;
 
 	ktrace_init(64);
 
@@ -1455,14 +1441,8 @@ init_xfs_fs( void )
 	uuid_init();
 	vfs_initquota();
 
-	error = register_filesystem(&xfs_fs_type);
-	if (error)
-		goto undo_register;
 	return 0;
 
-undo_register:
-	xfs_buf_terminate();
-
 undo_buffers:
 	xfs_destroy_zones();
 
@@ -1470,17 +1450,42 @@ undo_zones:
 	return error;
 }
 
-STATIC void __exit
-exit_xfs_fs( void )
+static void xfs_fs_exit(void)
 {
 	vfs_exitquota();
-	unregister_filesystem(&xfs_fs_type);
 	xfs_cleanup();
 	xfs_buf_terminate();
 	xfs_destroy_zones();
 	ktrace_uninit();
 }
 
+static struct file_system_type xfs_fs_type = {
+	.owner			= THIS_MODULE,
+	.name			= "xfs",
+	.get_sb			= xfs_fs_get_sb,
+	.kill_sb		= kill_block_super,
+	.fs_flags		= FS_REQUIRES_DEV,
+	.init			= xfs_fs_init,
+	.exit			= xfs_fs_exit,
+};
+
+
+STATIC int __init
+init_xfs_fs( void )
+{
+	static char		message[] __initdata = KERN_INFO \
+		XFS_VERSION_STRING " with " XFS_BUILD_OPTIONS " enabled\n";
+
+	printk(message);
+	return register_filesystem(&xfs_fs_type);
+}
+
+STATIC void __exit
+exit_xfs_fs( void )
+{
+	unregister_filesystem(&xfs_fs_type);
+}
+
 module_init(init_xfs_fs);
 module_exit(exit_xfs_fs);
 
-- 
1.5.4.3

