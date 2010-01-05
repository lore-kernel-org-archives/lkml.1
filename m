Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641Ab0AELsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0AELsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164Ab0AELsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36335 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0AELsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:09 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [11/12] SYSFS: Add class_attr_string for simple read-only string
Message-Id: <20100105114808.92E7EB17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several drivers just export a static string as class attributes.

Use the new extensible attribute support to define a simple
CLASS_ATTR_STRING() macro for this.

This will allow to remove code from drivers in followon patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/base/class.c   |   10 ++++++++++
 include/linux/device.h |   17 +++++++++++++++++
 2 files changed, 27 insertions(+)

Index: linux-2.6.33-rc2-ak/drivers/base/class.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/class.c
+++ linux-2.6.33-rc2-ak/drivers/base/class.c
@@ -488,6 +488,16 @@ void class_interface_unregister(struct c
 	class_put(parent);
 }
 
+ssize_t show_class_attr_string(struct class *class, struct class_attribute *attr,
+                        	char *buf)
+{
+	struct class_attribute_string *cs;
+	cs = container_of(attr, struct class_attribute_string, attr);
+	return snprintf(buf, PAGE_SIZE, "%s\n", cs->str);
+}
+
+EXPORT_SYMBOL_GPL(show_class_attr_string);
+
 struct class_compat {
 	struct kobject *kobj;
 };
Index: linux-2.6.33-rc2-ak/include/linux/device.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/device.h
+++ linux-2.6.33-rc2-ak/include/linux/device.h
@@ -265,6 +265,23 @@ extern int __must_check class_create_fil
 extern void class_remove_file(struct class *class,
 			      const struct class_attribute *attr);
 
+/* Simple class attribute that is just a static string */
+
+struct class_attribute_string {
+	struct class_attribute attr;
+	char *str;
+};
+
+/* Currently read-only only */
+#define _CLASS_ATTR_STRING(_name, _mode, _str) \
+	{ __ATTR(_name, _mode, show_class_attr_string, NULL), _str }
+#define CLASS_ATTR_STRING(_name, _mode, _str) \
+	struct class_attribute_string class_attr_##_name = \
+		_CLASS_ATTR_STRING(_name, _mode, _str)
+
+extern ssize_t show_class_attr_string(struct class *class, struct class_attribute *attr,
+                        char *buf);
+
 struct class_interface {
 	struct list_head	node;
 	struct class		*class;
