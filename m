Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbXKCAC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbXKCAC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761652AbXKCAAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:44 -0400
Received: from mail.suse.de ([195.135.220.2]:41057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761649AbXKCAAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Subject: [PATCH 09/54] kset: convert ecryptfs to use kset_create
Date: Fri,  2 Nov 2007 16:58:47 -0700
Message-Id: <1194047972-9850-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Halcrow <mhalcrow@us.ibm.com>
Cc: Phillip Hellewell <phillip@hellewell.homeip.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/main.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 18ab012..5bfdf96 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -730,7 +730,7 @@ static int ecryptfs_init_kmem_caches(void)
 	return 0;
 }
 
-static decl_subsys(ecryptfs, NULL);
+static struct kset *ecryptfs_kset;
 
 static ssize_t version_show(struct kset *kset, char *buff)
 {
@@ -794,18 +794,18 @@ static int do_sysfs_registration(void)
 {
 	int rc;
 
-	ecryptfs_subsys.kobj.kset = &fs_subsys;
-	rc = subsystem_register(&ecryptfs_subsys);
-	if (rc) {
-		printk(KERN_ERR
-		       "Unable to register ecryptfs sysfs subsystem\n");
+	ecryptfs_kset = kset_create_and_register("ecryptfs", NULL,
+						 NULL, &fs_subsys);
+	if (IS_ERR(ecryptfs_kset)) {
+		printk(KERN_ERR "Unable to create ecryptfs kset\n");
+		rc = PTR_ERR(ecryptfs_kset);
 		goto out;
 	}
-	rc = sysfs_create_group(&ecryptfs_subsys.kobj, &attr_group);
+	rc = sysfs_create_group(&ecryptfs_kset->kobj, &attr_group);
 	if (rc) {
 		printk(KERN_ERR
 		       "Unable to create ecryptfs version attributes\n");
-		subsystem_unregister(&ecryptfs_subsys);
+		subsystem_unregister(ecryptfs_kset);
 	}
 out:
 	return rc;
@@ -813,8 +813,8 @@ out:
 
 static void do_sysfs_unregistration(void)
 {
-	sysfs_remove_group(&ecryptfs_subsys.kobj, &attr_group);
-	subsystem_unregister(&ecryptfs_subsys);
+	sysfs_remove_group(&ecryptfs_kset->kobj, &attr_group);
+	subsystem_unregister(ecryptfs_kset);
 }
 
 static int __init ecryptfs_init(void)
-- 
1.5.3.4

