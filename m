Return-Path: <linux-kernel-owner+w=401wt.eu-S1760654AbYGAQte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbYGAQte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYGAQst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:48:49 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:13951 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYGAQsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:48:47 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080701648.901668603@firstfloor.org>
In-Reply-To: <20080701648.901668603@firstfloor.org>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/4] Add utility functions for simple int/ulong variable sysdev attributes
Message-Id: <20080701164842.E5AFE1B431B@basil.firstfloor.org>
Date: Tue,  1 Jul 2008 18:48:42 +0200 (CEST)
X-OriginalArrivalTime: 01 Jul 2008 16:41:22.0054 (UTC) FILETIME=[4B572260:01C8DB99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds a new sysdev_ext_attribute that stores a pointer to the variable
it manages and some utility functions/macro to easily use them.

Previously all users wrote custom macros to generate show/store
functions for each variable, with this it is possible to avoid
that in many cases.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/drivers/base/sys.c
===================================================================
--- linux.orig/drivers/base/sys.c
+++ linux/drivers/base/sys.c
@@ -474,3 +474,52 @@ int __init system_bus_init(void)
 
 EXPORT_SYMBOL_GPL(sysdev_register);
 EXPORT_SYMBOL_GPL(sysdev_unregister);
+
+#define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
+
+ssize_t sysdev_store_ulong(struct sys_device *sysdev,
+			   struct sysdev_attribute *attr,
+			   const char *buf, size_t size)
+{
+	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	char *end;
+	unsigned long new = simple_strtoul(buf, &end, 0);
+	if (end == buf)
+		return -EINVAL;
+	*(unsigned long *)(ea->var) = new;
+	return end - buf;
+}
+EXPORT_SYMBOL_GPL(sysdev_store_ulong);
+
+ssize_t sysdev_show_ulong(struct sys_device *sysdev,
+			  struct sysdev_attribute *attr,
+			  char *buf)
+{
+	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	return snprintf(buf, PAGE_SIZE, "%lx\n", *(unsigned long *)(ea->var));
+}
+EXPORT_SYMBOL_GPL(sysdev_show_ulong);
+
+ssize_t sysdev_store_int(struct sys_device *sysdev,
+			   struct sysdev_attribute *attr,
+			   const char *buf, size_t size)
+{
+	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	char *end;
+	long new = simple_strtol(buf, &end, 0);
+	if (end == buf || new > INT_MAX || new < INT_MIN)
+		return -EINVAL;
+	*(int *)(ea->var) = new;
+	return end - buf;
+}
+EXPORT_SYMBOL_GPL(sysdev_store_int);
+
+ssize_t sysdev_show_int(struct sys_device *sysdev,
+			  struct sysdev_attribute *attr,
+			  char *buf)
+{
+	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	return snprintf(buf, PAGE_SIZE, "%d\n", *(int *)(ea->var));
+}
+EXPORT_SYMBOL_GPL(sysdev_show_int);
+
Index: linux/include/linux/sysdev.h
===================================================================
--- linux.orig/include/linux/sysdev.h
+++ linux/include/linux/sysdev.h
@@ -119,4 +119,38 @@ struct sysdev_attribute { 
 extern int sysdev_create_file(struct sys_device *, struct sysdev_attribute *);
 extern void sysdev_remove_file(struct sys_device *, struct sysdev_attribute *);
 
+struct sysdev_ext_attribute {
+	struct sysdev_attribute attr;
+	void *var;
+};
+
+/*
+ * Support for simple variable sysdev attributes.
+ * The pointer to the variable is stored in a sysdev_ext_attribute
+ */
+
+/* Add more types as needed */
+
+extern ssize_t sysdev_show_ulong(struct sys_device *, struct sysdev_attribute *,
+				char *);
+extern ssize_t sysdev_store_ulong(struct sys_device *,
+			struct sysdev_attribute *, const char *, size_t);
+extern ssize_t sysdev_show_int(struct sys_device *, struct sysdev_attribute *,
+				char *);
+extern ssize_t sysdev_store_int(struct sys_device *,
+			struct sysdev_attribute *, const char *, size_t);
+
+#define _SYSDEV_ULONG_ATTR(_name, _mode, _var)				\
+	{ _SYSDEV_ATTR(_name, _mode, sysdev_show_ulong, sysdev_store_ulong), \
+	  &(_var) }
+#define SYSDEV_ULONG_ATTR(_name, _mode, _var)			\
+	struct sysdev_ext_attribute attr_##_name = 		\
+		_SYSDEV_ULONG_ATTR(_name, _mode, _var);
+#define _SYSDEV_INT_ATTR(_name, _mode, _var)				\
+	{ _SYSDEV_ATTR(_name, _mode, sysdev_show_int, sysdev_store_int), \
+	  &(_var) }
+#define SYSDEV_INT_ATTR(_name, _mode, _var)			\
+	struct sysdev_ext_attribute attr_##_name = 		\
+		_SYSDEV_INT_ATTR(_name, _mode, _var);
+
 #endif /* _SYSDEV_H_ */
