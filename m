Return-Path: <linux-kernel-owner+w=401wt.eu-S1764248AbXKCASc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764248AbXKCASc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbXKCADt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:03:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:41263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761990AbXKCADs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:03:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 54/54] kset: remove decl_subsys macro
Date: Fri,  2 Nov 2007 16:59:32 -0700
Message-Id: <1194047972-9850-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is no longer used.  ksets should be created dynamically with
a call to kset_create_and_register() not declared statically.

Yes, there are 5 remaining static struct kset usages in the kernel tree,
but they will be fixed up soon.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c    |   11 +++++++++--
 include/linux/kobject.h |    6 ------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 27256b3..c854158 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -453,8 +453,15 @@ static struct kset_uevent_ops class_uevent_ops = {
 	.uevent =	class_uevent,
 };
 
-static decl_subsys(class_obj, &class_uevent_ops);
-
+/*
+ * DO NOT copy how this is created, kset_create_and_register() should be
+ * called, but this is a hold-over from the old-way and will be deleted
+ * entirely soon.
+ */
+static struct kset class_obj_subsys = {
+	.kobj = { .k_name = "class_obj", },
+	.uevent_ops = &class_uevent_ops,
+};
 
 static int class_device_add_attrs(struct class_device * cd)
 {
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 05c8ef8..0e8f21e 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -192,12 +192,6 @@ extern struct kobject * kset_find_obj(struct kset *, const char *);
 #define set_kset_name(str)	.kset = { .kobj = { .k_name = str } }
 
 
-#define decl_subsys(_name,_uevent_ops) \
-struct kset _name##_subsys = { \
-	.kobj = { .k_name = __stringify(_name) }, \
-	.uevent_ops =_uevent_ops, \
-}
-
 /* The global /sys/kernel/ kset for people to chain off of */
 extern struct kset *kernel_kset;
 /* The global /sys/hypervisor/ kset for people to chain off of */
-- 
1.5.3.4

