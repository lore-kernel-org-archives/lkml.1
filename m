Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYAYHcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYAYHcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbYAYHRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:24 -0500
Received: from ns1.suse.de ([195.135.220.2]:52756 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758724AbYAYHRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Subject: [PATCH 052/196] kset: convert ecryptfs to use kset_create
Date: Thu, 24 Jan 2008 23:09:50 -0800
Message-Id: <1201245134-4876-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Halcrow <mhalcrow@us.ibm.com>
Cc: Phillip Hellewell <phillip@hellewell.homeip.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/main.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index fe2f44f..4750d82 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -734,7 +734,7 @@ static int ecryptfs_init_kmem_caches(void)
 	return 0;
 }
 
-static decl_subsys(ecryptfs, NULL);
+static struct kset *ecryptfs_kset;
 
 static ssize_t version_show(struct kset *kset, char *buff)
 {
@@ -798,18 +798,17 @@ static int do_sysfs_registration(void)
 {
 	int rc;
 
-	ecryptfs_subsys.kobj.kset = &fs_subsys;
-	rc = subsystem_register(&ecryptfs_subsys);
-	if (rc) {
-		printk(KERN_ERR
-		       "Unable to register ecryptfs sysfs subsystem\n");
+	ecryptfs_kset = kset_create_and_add("ecryptfs", NULL, &fs_subsys.kobj);
+	if (!ecryptfs_kset) {
+		printk(KERN_ERR "Unable to create ecryptfs kset\n");
+		rc = -ENOMEM;
 		goto out;
 	}
-	rc = sysfs_create_group(&ecryptfs_subsys.kobj, &attr_group);
+	rc = sysfs_create_group(&ecryptfs_kset->kobj, &attr_group);
 	if (rc) {
 		printk(KERN_ERR
 		       "Unable to create ecryptfs version attributes\n");
-		subsystem_unregister(&ecryptfs_subsys);
+		kset_unregister(ecryptfs_kset);
 	}
 out:
 	return rc;
@@ -817,8 +816,8 @@ out:
 
 static void do_sysfs_unregistration(void)
 {
-	sysfs_remove_group(&ecryptfs_subsys.kobj, &attr_group);
-	subsystem_unregister(&ecryptfs_subsys);
+	sysfs_remove_group(&ecryptfs_kset->kobj, &attr_group);
+	kset_unregister(ecryptfs_kset);
 }
 
 static int __init ecryptfs_init(void)
-- 
1.5.3.8

