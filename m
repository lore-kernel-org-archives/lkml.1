Return-Path: <linux-kernel-owner+w=401wt.eu-S1763229AbYAYHx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763229AbYAYHx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761442AbYAYHgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:15 -0500
Received: from mail.suse.de ([195.135.220.2]:55294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761521AbYAYHgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 095/196] kset: remove decl_subsys macro
Date: Thu, 24 Jan 2008 23:32:04 -0800
Message-Id: <1201246425-5058-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is no longer used.  ksets should be created dynamically with
a call to kset_create_and_add() not declared statically.

Yes, there are 5 remaining static struct kset usages in the kernel tree,
but they will be fixed up soon.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c    |   11 +++++++++--
 include/linux/kobject.h |    6 ------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index d8a92c6..304f90e 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -453,8 +453,15 @@ static struct kset_uevent_ops class_uevent_ops = {
 	.uevent =	class_uevent,
 };
 
-static decl_subsys(class_obj, &class_uevent_ops);
-
+/*
+ * DO NOT copy how this is created, kset_create_and_add() should be
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
index 673623f..9da3523 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -198,12 +198,6 @@ extern struct kobject * kset_find_obj(struct kset *, const char *);
 #define set_kset_name(str)	.kset = { .kobj = { .k_name = str } }
 
 
-#define decl_subsys(_name,_uevent_ops) \
-struct kset _name##_subsys = { \
-	.kobj = { .k_name = __stringify(_name) }, \
-	.uevent_ops =_uevent_ops, \
-}
-
 /* The global /sys/kernel/ kset for people to chain off of */
 extern struct kset *kernel_kset;
 /* The global /sys/hypervisor/ kobject for people to chain off of */
-- 
1.5.3.8

