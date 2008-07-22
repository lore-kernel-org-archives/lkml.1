Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYGVFqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYGVFqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbYGVF0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:26:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:43429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871AbYGVF0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:26:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 73/79] sysdev: Add utility functions for simple int/ulong variable sysdev attributes
Date: Mon, 21 Jul 2008 22:19:37 -0700
Message-Id: <1216703983-21448-73-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

This adds a new sysdev_ext_attribute that stores a pointer to the variable
it manages and some utility functions/macro to easily use them.

Previously all users wrote custom macros to generate show/store
functions for each variable, with this it is possible to avoid
that in many cases.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c     |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sysdev.h |   34 +++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index dc7dace..40fc14f 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -479,3 +479,52 @@ int __init system_bus_init(void)
 
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
diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
index 8dcf316..f395bb3 100644
--- a/include/linux/sysdev.h
+++ b/include/linux/sysdev.h
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
-- 
1.5.6.3

