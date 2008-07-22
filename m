Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbYGVFiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbYGVFiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbYGVFY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038AbYGVFY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Kay Sievers <kay.sievers@vrfy.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/79] class: add lockdep infrastructure
Date: Mon, 21 Jul 2008 22:19:13 -0700
Message-Id: <1216703983-21448-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>

This adds the infrastructure to properly handle lockdep issues when the
internal class semaphore is changed to a mutex.

Matthew wrote the original patch, and Greg fixed it up to work properly
with the class_create() function.


From: Matthew Wilcox <matthew@wil.cx>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c   |   11 ++++++-----
 include/linux/device.h |   25 +++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index d24d211..8900056 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -134,7 +134,7 @@ static void remove_class_attrs(struct class *cls)
 	}
 }
 
-int class_register(struct class *cls)
+int __class_register(struct class *cls, struct lock_class_key *key)
 {
 	struct class_private *cp;
 	int error;
@@ -178,6 +178,7 @@ int class_register(struct class *cls)
 	class_put(cls);
 	return error;
 }
+EXPORT_SYMBOL_GPL(__class_register);
 
 void class_unregister(struct class *cls)
 {
@@ -203,7 +204,8 @@ static void class_create_release(struct class *cls)
  * Note, the pointer created here is to be destroyed when finished by
  * making a call to class_destroy().
  */
-struct class *class_create(struct module *owner, const char *name)
+struct class *__class_create(struct module *owner, const char *name,
+			     struct lock_class_key *key)
 {
 	struct class *cls;
 	int retval;
@@ -218,7 +220,7 @@ struct class *class_create(struct module *owner, const char *name)
 	cls->owner = owner;
 	cls->class_release = class_create_release;
 
-	retval = class_register(cls);
+	retval = __class_register(cls, key);
 	if (retval)
 		goto error;
 
@@ -228,6 +230,7 @@ error:
 	kfree(cls);
 	return ERR_PTR(retval);
 }
+EXPORT_SYMBOL_GPL(__class_create);
 
 /**
  * class_destroy - destroys a struct class structure
@@ -412,9 +415,7 @@ int __init classes_init(void)
 
 EXPORT_SYMBOL_GPL(class_create_file);
 EXPORT_SYMBOL_GPL(class_remove_file);
-EXPORT_SYMBOL_GPL(class_register);
 EXPORT_SYMBOL_GPL(class_unregister);
-EXPORT_SYMBOL_GPL(class_create);
 EXPORT_SYMBOL_GPL(class_destroy);
 
 EXPORT_SYMBOL_GPL(class_interface_register);
diff --git a/include/linux/device.h b/include/linux/device.h
index b055608..0e1d24c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/klist.h>
 #include <linux/list.h>
+#include <linux/lockdep.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/module.h>
@@ -205,8 +206,18 @@ struct class {
 
 extern struct kobject *sysfs_dev_block_kobj;
 extern struct kobject *sysfs_dev_char_kobj;
-extern int __must_check class_register(struct class *class);
+extern int __must_check __class_register(struct class *class,
+					 struct lock_class_key *key);
 extern void class_unregister(struct class *class);
+
+/* This is a #define to keep the compiler from merging different
+ * instances of the __key variable */
+#define class_register(class)			\
+({						\
+	static struct lock_class_key __key;	\
+	__class_register(class, &__key);	\
+})
+
 extern int class_for_each_device(struct class *class, struct device *start,
 				 void *data,
 				 int (*fn)(struct device *dev, void *data));
@@ -239,9 +250,19 @@ struct class_interface {
 extern int __must_check class_interface_register(struct class_interface *);
 extern void class_interface_unregister(struct class_interface *);
 
-extern struct class *class_create(struct module *owner, const char *name);
+extern struct class * __must_check __class_create(struct module *owner,
+						  const char *name,
+						  struct lock_class_key *key);
 extern void class_destroy(struct class *cls);
 
+/* This is a #define to keep the compiler from merging different
+ * instances of the __key variable */
+#define class_create(owner, name)		\
+({						\
+	static struct lock_class_key __key;	\
+	__class_create(owner, name, &__key);	\
+})
+
 /*
  * The type of device, "struct device" is embedded in. A class
  * or bus can contain devices of different types
-- 
1.5.6.3

