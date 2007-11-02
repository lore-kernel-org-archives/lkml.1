Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbXKCAHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbXKCAHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761992AbXKCABa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:34840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761979AbXKCAB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 21/54] kset: convert /sys/hypervisor to use kset_create
Date: Fri,  2 Nov 2007 16:58:59 -0700
Message-Id: <1194047972-9850-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.  We also
rename hypervisor_subsys to hypervisor_kset to catch all users of the
variable.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/s390/hypfs/inode.c   |    2 +-
 drivers/base/hypervisor.c |   14 ++++++++++----
 include/linux/kobject.h   |    4 ++--
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index c022ccc..387d0e4 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -506,7 +506,7 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	s390_subsys.kobj.kset = &hypervisor_subsys;
+	s390_subsys.kobj.kset = hypervisor_kset;
 	rc = subsystem_register(&s390_subsys);
 	if (rc)
 		goto fail_sysfs;
diff --git a/drivers/base/hypervisor.c b/drivers/base/hypervisor.c
index 14e75e9..cb2274f 100644
--- a/drivers/base/hypervisor.c
+++ b/drivers/base/hypervisor.c
@@ -2,19 +2,25 @@
  * hypervisor.c - /sys/hypervisor subsystem.
  *
  * Copyright (C) IBM Corp. 2006
+ * Copyright (C) 2007 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (C) 2007 Novell Inc.
  *
  * This file is released under the GPLv2
  */
 
 #include <linux/kobject.h>
 #include <linux/device.h>
-
+#include <linux/err.h>
 #include "base.h"
 
-decl_subsys(hypervisor, NULL);
-EXPORT_SYMBOL_GPL(hypervisor_subsys);
+struct kset *hypervisor_kset;
+EXPORT_SYMBOL_GPL(hypervisor_kset);
 
 int __init hypervisor_init(void)
 {
-	return subsystem_register(&hypervisor_subsys);
+	hypervisor_kset = kset_create_and_register("hypervisor", NULL,
+						   NULL, NULL);
+	if (IS_ERR(hypervisor_kset))
+		return PTR_ERR(hypervisor_kset);
+	return 0;
 }
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 4196ad8..63a6bf9 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -190,8 +190,8 @@ struct kset _name##_subsys = { \
 
 /* The global /sys/kernel/ kset for people to chain off of */
 extern struct kset *kernel_kset;
-/* The global /sys/hypervisor/ subsystem  */
-extern struct kset hypervisor_subsys;
+/* The global /sys/hypervisor/ kset for people to chain off of */
+extern struct kset *hypervisor_kset;
 
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
-- 
1.5.3.4

