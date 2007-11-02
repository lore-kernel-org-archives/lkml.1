Return-Path: <linux-kernel-owner+w=401wt.eu-S1763053AbXKCAJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763053AbXKCAJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761457AbXKCABy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:41157 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762103AbXKCABx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 27/54] kset: convert s390 hypervisor kset to use kset_create
Date: Fri,  2 Nov 2007 16:59:05 -0700
Message-Id: <1194047972-9850-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael Holzheu <holzheu@de.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/s390/hypfs/inode.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 387d0e4..b8f124a 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -490,7 +490,7 @@ static struct super_operations hypfs_s_ops = {
 	.show_options	= hypfs_show_options,
 };
 
-static decl_subsys(s390, NULL);
+static struct kset *s390_kset;
 
 static int __init hypfs_init(void)
 {
@@ -506,17 +506,20 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	s390_subsys.kobj.kset = hypervisor_kset;
-	rc = subsystem_register(&s390_subsys);
-	if (rc)
+
+	s390_kset = kset_create_and_register("s390", NULL, NULL,
+		    hypervisor_kset);
+	if (IS_PTR(s390_kset)) {
+		rc = PTR_ERR(s390_kset);
 		goto fail_sysfs;
+	}
 	rc = register_filesystem(&hypfs_type);
 	if (rc)
 		goto fail_filesystem;
 	return 0;
 
 fail_filesystem:
-	subsystem_unregister(&s390_subsys);
+	kset_unregister(s390_kset);
 fail_sysfs:
 	if (!MACHINE_IS_VM)
 		hypfs_diag_exit();
@@ -530,7 +533,7 @@ static void __exit hypfs_exit(void)
 	if (!MACHINE_IS_VM)
 		hypfs_diag_exit();
 	unregister_filesystem(&hypfs_type);
-	subsystem_unregister(&s390_subsys);
+	kset_unregister(s390_kset);
 }
 
 module_init(hypfs_init)
-- 
1.5.3.4

