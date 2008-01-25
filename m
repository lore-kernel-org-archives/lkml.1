Return-Path: <linux-kernel-owner+w=401wt.eu-S1761259AbYAYHb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbYAYHb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbYAYHRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:07 -0500
Received: from ns.suse.de ([195.135.220.2]:52726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758743AbYAYHRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:06 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 048/196] kobject: convert fuse to use kobject_create
Date: Thu, 24 Jan 2008 23:09:46 -0800
Message-Id: <1201245134-4876-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a kset here, a simple kobject will do just fine, so
dynamically create the kobject and use it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/fuse/inode.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f5e4182..9211806 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -744,9 +744,6 @@ static inline void unregister_fuseblk(void)
 }
 #endif
 
-static decl_subsys(fuse, NULL);
-static decl_subsys(connections, NULL);
-
 static void fuse_inode_init_once(struct kmem_cache *cachep, void *foo)
 {
 	struct inode * inode = foo;
@@ -791,32 +788,37 @@ static void fuse_fs_cleanup(void)
 	kmem_cache_destroy(fuse_inode_cachep);
 }
 
+static struct kobject *fuse_kobj;
+static struct kobject *connections_kobj;
+
 static int fuse_sysfs_init(void)
 {
 	int err;
 
-	fuse_subsys.kobj.kset = &fs_subsys;
-	err = subsystem_register(&fuse_subsys);
-	if (err)
+	fuse_kobj = kobject_create_and_add("fuse", &fs_subsys.kobj);
+	if (!fuse_kobj) {
+		err = -ENOMEM;
 		goto out_err;
+	}
 
-	connections_subsys.kobj.kset = &fuse_subsys;
-	err = subsystem_register(&connections_subsys);
-	if (err)
+	connections_kobj = kobject_create_and_add("connections", fuse_kobj);
+	if (!connections_kobj) {
+		err = -ENOMEM;
 		goto out_fuse_unregister;
+	}
 
 	return 0;
 
  out_fuse_unregister:
-	subsystem_unregister(&fuse_subsys);
+	kobject_unregister(fuse_kobj);
  out_err:
 	return err;
 }
 
 static void fuse_sysfs_cleanup(void)
 {
-	subsystem_unregister(&connections_subsys);
-	subsystem_unregister(&fuse_subsys);
+	kobject_unregister(connections_kobj);
+	kobject_unregister(fuse_kobj);
 }
 
 static int __init fuse_init(void)
-- 
1.5.3.8

