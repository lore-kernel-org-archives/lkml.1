Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbXKCACm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbXKCACm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761585AbXKCAAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:34789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761572AbXKCAAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 08/54] kset: convert configfs to use kset_create
Date: Fri,  2 Nov 2007 16:58:46 -0700
Message-Id: <1194047972-9850-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/configfs/mount.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 374ddbd..8674e6d 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -128,7 +128,7 @@ void configfs_release_fs(void)
 }
 
 
-static decl_subsys(config, NULL);
+static struct kset *config_kset;
 
 static int __init configfs_init(void)
 {
@@ -140,9 +140,9 @@ static int __init configfs_init(void)
 	if (!configfs_dir_cachep)
 		goto out;
 
-	config_subsys.kobj.kset = &kernel_subsys;
-	err = subsystem_register(&config_subsys);
-	if (err) {
+	config_kset = kset_create_and_register("config", NULL,
+					       NULL, &kernel_subsys);
+	if (IS_ERR(config_kset)) {
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
 		goto out;
@@ -151,7 +151,7 @@ static int __init configfs_init(void)
 	err = register_filesystem(&configfs_fs_type);
 	if (err) {
 		printk(KERN_ERR "configfs: Unable to register filesystem!\n");
-		subsystem_unregister(&config_subsys);
+		kset_unregister(config_kset);
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
 		goto out;
@@ -160,7 +160,7 @@ static int __init configfs_init(void)
 	err = configfs_inode_init();
 	if (err) {
 		unregister_filesystem(&configfs_fs_type);
-		subsystem_unregister(&config_subsys);
+		kset_unregister(config_kset);
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
 	}
@@ -171,7 +171,7 @@ out:
 static void __exit configfs_exit(void)
 {
 	unregister_filesystem(&configfs_fs_type);
-	subsystem_unregister(&config_subsys);
+	kset_unregister(config_kset);
 	kmem_cache_destroy(configfs_dir_cachep);
 	configfs_dir_cachep = NULL;
 	configfs_inode_exit();
-- 
1.5.3.4

