Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0CBX5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:57:36 -0500
Received: from kroah.org ([198.145.64.141]:38528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0CBX3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/62] driver core: Add class_attr_string for simple read-only string
Date: Tue,  2 Mar 2010 15:28:15 -0800
Message-Id: <1267572541-410-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Several drivers just export a static string as class attributes.

Use the new extensible attribute support to define a simple
CLASS_ATTR_STRING() macro for this.

This will allow to remove code from drivers in followon patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c   |   10 ++++++++++
 include/linux/device.h |   17 +++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 34a2de9..2e297cc 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -490,6 +490,16 @@ void class_interface_unregister(struct class_interface *class_intf)
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
diff --git a/include/linux/device.h b/include/linux/device.h
index 190f8d3..f95d5bf 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -265,6 +265,23 @@ extern int __must_check class_create_file(struct class *class,
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
-- 
1.7.0.1

