Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYAYHhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYAYHhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbYAYHSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:18:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394AbYAYHSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:18:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 064/196] kobject: convert /sys/hypervisor to use kobject_create
Date: Thu, 24 Jan 2008 23:10:02 -0800
Message-Id: <1201245134-4876-64-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a kset here, a simple kobject will do just fine, so
dynamically create the kobject and use it.

We also rename hypervisor_subsys to hypervisor_kset to catch all users
of the variable.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/s390/hypfs/inode.c   |    2 +-
 drivers/base/hypervisor.c |   12 ++++++++----
 include/linux/kobject.h   |    4 ++--
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index c022ccc..b0ad479 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -506,7 +506,7 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	s390_subsys.kobj.kset = &hypervisor_subsys;
+	s390_subsys.kobj.parent = hypervisor_kobj;
 	rc = subsystem_register(&s390_subsys);
 	if (rc)
 		goto fail_sysfs;
diff --git a/drivers/base/hypervisor.c b/drivers/base/hypervisor.c
index 14e75e9..6428cba 100644
--- a/drivers/base/hypervisor.c
+++ b/drivers/base/hypervisor.c
@@ -2,19 +2,23 @@
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
 #include "base.h"
 
-decl_subsys(hypervisor, NULL);
-EXPORT_SYMBOL_GPL(hypervisor_subsys);
+struct kobject *hypervisor_kobj;
+EXPORT_SYMBOL_GPL(hypervisor_kobj);
 
 int __init hypervisor_init(void)
 {
-	return subsystem_register(&hypervisor_subsys);
+	hypervisor_kobj = kobject_create_and_add("hypervisor", NULL);
+	if (!hypervisor_kobj)
+		return -ENOMEM;
+	return 0;
 }
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index bd741e8..f2483f6 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -196,8 +196,8 @@ struct kset _name##_subsys = { \
 
 /* The global /sys/kernel/ kset for people to chain off of */
 extern struct kset *kernel_kset;
-/* The global /sys/hypervisor/ subsystem  */
-extern struct kset hypervisor_subsys;
+/* The global /sys/hypervisor/ kobject for people to chain off of */
+extern struct kobject *hypervisor_kobj;
 
 extern int __must_check subsystem_register(struct kset *);
 extern void subsystem_unregister(struct kset *);
-- 
1.5.3.8

