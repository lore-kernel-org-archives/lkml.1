Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbXKCABg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbXKCABg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbXKCAAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761343AbXKCAAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 05/54] kset: convert fuse to use kset_create
Date: Fri,  2 Nov 2007 16:58:43 -0700
Message-Id: <1194047972-9850-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/fuse/inode.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 2df24c6..ca80a7b 100644
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
@@ -791,32 +788,38 @@ static void fuse_fs_cleanup(void)
 	kmem_cache_destroy(fuse_inode_cachep);
 }
 
+static struct kset *fuse_kset;
+static struct kset *connections_kset;
+
 static int fuse_sysfs_init(void)
 {
 	int err;
 
-	fuse_subsys.kobj.kset = &fs_subsys;
-	err = subsystem_register(&fuse_subsys);
-	if (err)
+	fuse_kset = kset_create_and_register("fuse", NULL, NULL, &fs_subsys);
+	if (IS_ERR(fuse_kset)) {
+		err = PTR_ERR(fuse_kset);
 		goto out_err;
+	}
 
-	connections_subsys.kobj.kset = &fuse_subsys;
-	err = subsystem_register(&connections_subsys);
-	if (err)
+	connections_kset = kset_create_and_register("connections", NULL,
+						    NULL, fuse_kset);
+	if (IS_ERR(connections_kset)) {
+		err = PTR_ERR(connections_kset);
 		goto out_fuse_unregister;
+	}
 
 	return 0;
 
  out_fuse_unregister:
-	subsystem_unregister(&fuse_subsys);
+	kset_unregister(fuse_kset);
  out_err:
 	return err;
 }
 
 static void fuse_sysfs_cleanup(void)
 {
-	subsystem_unregister(&connections_subsys);
-	subsystem_unregister(&fuse_subsys);
+	kset_unregister(connections_kset);
+	kset_unregister(fuse_kset);
 }
 
 static int __init fuse_init(void)
-- 
1.5.3.4

