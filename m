Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbYAYHcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbYAYHcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbYAYHRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596AbYAYHRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 050/196] kobject: convert debugfs to use kobject_create
Date: Thu, 24 Jan 2008 23:09:48 -0800
Message-Id: <1201245134-4876-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a kset here, a simple kobject will do just fine, so
dynamically create the kobject and use it.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index f7f1351..6672142 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -426,20 +426,19 @@ exit:
 }
 EXPORT_SYMBOL_GPL(debugfs_rename);
 
-static decl_subsys(debug, NULL);
+static struct kobject *debug_kobj;
 
 static int __init debugfs_init(void)
 {
 	int retval;
 
-	debug_subsys.kobj.kset = &kernel_subsys;
-	retval = subsystem_register(&debug_subsys);
-	if (retval)
-		return retval;
+	debug_kobj = kobject_create_and_add("debug", &kernel_subsys.kobj);
+	if (!debug_kobj)
+		return -EINVAL;
 
 	retval = register_filesystem(&debug_fs_type);
 	if (retval)
-		subsystem_unregister(&debug_subsys);
+		kobject_unregister(debug_kobj);
 	return retval;
 }
 
@@ -447,7 +446,7 @@ static void __exit debugfs_exit(void)
 {
 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	unregister_filesystem(&debug_fs_type);
-	subsystem_unregister(&debug_subsys);
+	kobject_unregister(debug_kobj);
 }
 
 core_initcall(debugfs_init);
-- 
1.5.3.8

