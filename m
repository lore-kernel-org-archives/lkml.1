Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbXKCACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbXKCACX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761524AbXKCAAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:31 -0400
Received: from ns.suse.de ([195.135.220.2]:41046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761521AbXKCAAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 07/54] kset: convert debugfs to use kset_create
Date: Fri,  2 Nov 2007 16:58:45 -0700
Message-Id: <1194047972-9850-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index f7f1351..9f8af79 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -426,20 +426,20 @@ exit:
 }
 EXPORT_SYMBOL_GPL(debugfs_rename);
 
-static decl_subsys(debug, NULL);
+static struct kset *debug_kset;
 
 static int __init debugfs_init(void)
 {
 	int retval;
 
-	debug_subsys.kobj.kset = &kernel_subsys;
-	retval = subsystem_register(&debug_subsys);
-	if (retval)
-		return retval;
+	debug_kset = kset_create_and_register("debug", NULL,
+					      NULL, &kernel_subsys);
+	if (IS_ERR(debug_kset))
+		return PTR_ERR(debug_kset);
 
 	retval = register_filesystem(&debug_fs_type);
 	if (retval)
-		subsystem_unregister(&debug_subsys);
+		kset_unregister(debug_kset);
 	return retval;
 }
 
@@ -447,7 +447,7 @@ static void __exit debugfs_exit(void)
 {
 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	unregister_filesystem(&debug_fs_type);
-	subsystem_unregister(&debug_subsys);
+	kset_unregister(debug_kset);
 }
 
 core_initcall(debugfs_init);
-- 
1.5.3.4

