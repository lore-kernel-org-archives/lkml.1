Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbYAYHc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbYAYHc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbYAYHRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:52744 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759165AbYAYHRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 051/196] kobject: convert configfs to use kobject_create
Date: Thu, 24 Jan 2008 23:09:49 -0800
Message-Id: <1201245134-4876-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a kset here, a simple kobject will do just fine, so
dynamically create the kobject and use it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/configfs/mount.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 374ddbd..1330046 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -128,7 +128,7 @@ void configfs_release_fs(void)
 }
 
 
-static decl_subsys(config, NULL);
+static struct kobject *config_kobj;
 
 static int __init configfs_init(void)
 {
@@ -140,9 +140,8 @@ static int __init configfs_init(void)
 	if (!configfs_dir_cachep)
 		goto out;
 
-	config_subsys.kobj.kset = &kernel_subsys;
-	err = subsystem_register(&config_subsys);
-	if (err) {
+	config_kobj = kobject_create_and_add("config", &kernel_subsys.kobj);
+	if (!config_kobj) {
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
 		goto out;
@@ -151,7 +150,7 @@ static int __init configfs_init(void)
 	err = register_filesystem(&configfs_fs_type);
 	if (err) {
 		printk(KERN_ERR "configfs: Unable to register filesystem!\n");
-		subsystem_unregister(&config_subsys);
+		kobject_unregister(config_kobj);
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
 		goto out;
@@ -160,7 +159,7 @@ static int __init configfs_init(void)
 	err = configfs_inode_init();
 	if (err) {
 		unregister_filesystem(&configfs_fs_type);
-		subsystem_unregister(&config_subsys);
+		kobject_unregister(config_kobj);
 		kmem_cache_destroy(configfs_dir_cachep);
 		configfs_dir_cachep = NULL;
 	}
@@ -171,7 +170,7 @@ out:
 static void __exit configfs_exit(void)
 {
 	unregister_filesystem(&configfs_fs_type);
-	subsystem_unregister(&config_subsys);
+	kobject_unregister(config_kobj);
 	kmem_cache_destroy(configfs_dir_cachep);
 	configfs_dir_cachep = NULL;
 	configfs_inode_exit();
-- 
1.5.3.8

