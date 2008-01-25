Return-Path: <linux-kernel-owner+w=401wt.eu-S1761652AbYAYHhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761652AbYAYHhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbYAYHSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:52889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbYAYHSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 065/196] kobject: convert s390 hypervisor to use kobject_create
Date: Thu, 24 Jan 2008 23:10:03 -0800
Message-Id: <1201245134-4876-65-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a kset here, a simple kobject will do just fine, so
dynamically create the kobject and use it.

Thanks to Cornelia for the build fix.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael Holzheu <holzheu@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/s390/hypfs/inode.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index b0ad479..631a610 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -490,7 +490,7 @@ static struct super_operations hypfs_s_ops = {
 	.show_options	= hypfs_show_options,
 };
 
-static decl_subsys(s390, NULL);
+static struct kobject *s390_kobj;
 
 static int __init hypfs_init(void)
 {
@@ -506,17 +506,18 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	s390_subsys.kobj.parent = hypervisor_kobj;
-	rc = subsystem_register(&s390_subsys);
-	if (rc)
+	s390_kobj = kobject_create_and_add("s390", hypervisor_kobj);
+	if (!s390_kobj) {
+		rc = -ENOMEM;;
 		goto fail_sysfs;
+	}
 	rc = register_filesystem(&hypfs_type);
 	if (rc)
 		goto fail_filesystem;
 	return 0;
 
 fail_filesystem:
-	subsystem_unregister(&s390_subsys);
+	kobject_unregister(s390_kobj);
 fail_sysfs:
 	if (!MACHINE_IS_VM)
 		hypfs_diag_exit();
@@ -530,7 +531,7 @@ static void __exit hypfs_exit(void)
 	if (!MACHINE_IS_VM)
 		hypfs_diag_exit();
 	unregister_filesystem(&hypfs_type);
-	subsystem_unregister(&s390_subsys);
+	kobject_unregister(s390_kobj);
 }
 
 module_init(hypfs_init)
-- 
1.5.3.8

