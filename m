Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbXITIH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbXITIH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbXITIF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:05:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:41325 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXITIFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=jADcRenSlVBpmOo8d27Xe1+xxwHRWrIGN1ORhwlhKP+k0SIrX8sutrEueUZ9fgMFVksFUYdpl8QyyUMKXRA1xoztbOS1JPsrXvTQiSsrDMWq9i7xsK12N9CNjfrVRWAy0aaNWbzNwlArVlsBQxoasguDUDIVcRzdo0KQK0pkj6g=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 02/22] sysfs: separate out sysfs-kobject.h and fs/sysfs/kobject.c
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:39 +0900
Message-Id: <11902755391604-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs is about to get a new interface which is independent from the
driver model and kobject.  Create include sysfs-kobject.h and move all
kobject based interface into it.  Also, create fs/sysfs/kobject.c
which is currently empty but will host compatibility interface
functions based on the new interface.

sysfs-kobject.h is automatically included from sysfs.h for
compatibility for now.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/Makefile             |    2 +-
 fs/sysfs/kobject.c            |   15 +++
 include/linux/sysfs-kobject.h |  200 +++++++++++++++++++++++++++++++++++++++++
 include/linux/sysfs.h         |  197 +++-------------------------------------
 4 files changed, 230 insertions(+), 184 deletions(-)
 create mode 100644 fs/sysfs/kobject.c
 create mode 100644 include/linux/sysfs-kobject.h

diff --git a/fs/sysfs/Makefile b/fs/sysfs/Makefile
index 7a1ceb9..f58bce9 100644
--- a/fs/sysfs/Makefile
+++ b/fs/sysfs/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-y		:= inode.o file.o dir.o symlink.o mount.o bin.o \
-		   group.o
+		   group.o kobject.o
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
new file mode 100644
index 0000000..5ebd755
--- /dev/null
+++ b/fs/sysfs/kobject.c
@@ -0,0 +1,15 @@
+/*
+ * sysfs/kobject.c - compatibility sysfs interface based on kobject
+ *
+ * Copyright (c) 2001,2002 Patrick Mochel
+ * Copyright (c) 2004 Silicon Graphics, Inc.
+ *
+ * This is compatibility interface which wraps the primary interface
+ * defined in linux/sysfs.h to remain compatible with the original
+ * kobject based interface.
+ *
+ * Please see Documentation/filesystems/sysfs.txt for more information.
+ */
+
+#include <linux/sysfs.h>
+#include <linux/sysfs-kobject.h>
diff --git a/include/linux/sysfs-kobject.h b/include/linux/sysfs-kobject.h
new file mode 100644
index 0000000..4c821c2
--- /dev/null
+++ b/include/linux/sysfs-kobject.h
@@ -0,0 +1,200 @@
+/*
+ * sysfs-kobject.h - compatibility sysfs interface based on kobject
+ *
+ * Copyright (c) 2001,2002 Patrick Mochel
+ * Copyright (c) 2004 Silicon Graphics, Inc.
+ *
+ * This is compatibility interface which wraps the primary interface
+ * defined in linux/sysfs.h to remain compatible with the original
+ * kobject based interface.  Please don't use in new codes.
+ *
+ * Please see Documentation/filesystems/sysfs.txt for more information.
+ */
+
+#ifndef _SYSFS_KOBJECT_H
+#define _SYSFS_KOBJECT_H
+
+#include <linux/sysfs.h>
+
+struct kobject;
+struct module;
+
+/* FIXME
+ * The *owner field is no longer used, but leave around
+ * until the tree gets cleaned up fully.
+ */
+struct attribute {
+	const char		*name;
+	struct module		*owner;
+	mode_t			mode;
+};
+
+struct attribute_group {
+	const char		*name;
+	struct attribute	**attrs;
+};
+
+/**
+ * Use these macros to make defining attributes easier. See include/linux/device.h
+ * for examples..
+ */
+
+#define __ATTR(_name,_mode,_show,_store) { \
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show	= _show,					\
+	.store	= _store,					\
+}
+
+#define __ATTR_RO(_name) { \
+	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
+	.show	= _name##_show,					\
+}
+
+#define __ATTR_NULL { .attr = { .name = NULL } }
+
+#define attr_name(_attr) (_attr).attr.name
+
+struct bin_attribute {
+	struct attribute	attr;
+	size_t			size;
+	void			*private;
+	ssize_t (*read)(struct kobject *, struct bin_attribute *,
+			char *, loff_t, size_t);
+	ssize_t (*write)(struct kobject *, struct bin_attribute *,
+			 char *, loff_t, size_t);
+	int (*mmap)(struct kobject *, struct bin_attribute *attr,
+		    struct vm_area_struct *vma);
+};
+
+struct sysfs_ops {
+	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
+	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
+};
+
+#ifdef CONFIG_SYSFS
+
+int __must_check sysfs_create_dir(struct kobject *kobj);
+void sysfs_remove_dir(struct kobject *kobj);
+int __must_check sysfs_rename_dir(struct kobject *kobj, const char *new_name);
+int __must_check sysfs_move_dir(struct kobject *kobj,
+				struct kobject *new_parent_kobj);
+
+int __must_check sysfs_create_file(struct kobject *kobj,
+				   const struct attribute *attr);
+int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
+				  mode_t mode);
+void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
+
+int __must_check sysfs_create_bin_file(struct kobject *kobj,
+				       struct bin_attribute *attr);
+void sysfs_remove_bin_file(struct kobject *kobj, struct bin_attribute *attr);
+
+int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
+				   const char *name);
+void sysfs_remove_link(struct kobject *kobj, const char *name);
+
+int __must_check sysfs_create_group(struct kobject *kobj,
+				    const struct attribute_group *grp);
+void sysfs_remove_group(struct kobject *kobj,
+			const struct attribute_group *grp);
+int sysfs_add_file_to_group(struct kobject *kobj,
+			const struct attribute *attr, const char *group);
+void sysfs_remove_file_from_group(struct kobject *kobj,
+			const struct attribute *attr, const char *group);
+
+void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
+
+#else /* CONFIG_SYSFS */
+
+static inline int sysfs_create_dir(struct kobject *kobj)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_dir(struct kobject *kobj)
+{
+	;
+}
+
+static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
+{
+	return 0;
+}
+
+static inline int sysfs_move_dir(struct kobject *kobj,
+				 struct kobject *new_parent_kobj)
+{
+	return 0;
+}
+
+static inline int sysfs_create_file(struct kobject *kobj,
+				    const struct attribute *attr)
+{
+	return 0;
+}
+
+static inline int sysfs_chmod_file(struct kobject *kobj,
+				   struct attribute *attr, mode_t mode)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_file(struct kobject *kobj,
+				     const struct attribute *attr)
+{
+	;
+}
+
+static inline int sysfs_create_bin_file(struct kobject *kobj,
+					struct bin_attribute *attr)
+{
+	return 0;
+}
+
+static inline int sysfs_remove_bin_file(struct kobject *kobj,
+					struct bin_attribute *attr)
+{
+	return 0;
+}
+
+static inline int sysfs_create_link(struct kobject *kobj,
+				    struct kobject *target, const char *name)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
+{
+	;
+}
+
+static inline int sysfs_create_group(struct kobject *kobj,
+				     const struct attribute_group *grp)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_group(struct kobject *kobj,
+				      const struct attribute_group *grp)
+{
+	;
+}
+
+static inline int sysfs_add_file_to_group(struct kobject *kobj,
+		const struct attribute *attr, const char *group)
+{
+	return 0;
+}
+
+static inline void sysfs_remove_file_from_group(struct kobject *kobj,
+		const struct attribute *attr, const char *group)
+{
+}
+
+static inline void sysfs_notify(struct kobject *kobj, char *dir, char *attr)
+{
+}
+
+#endif /* CONFIG_SYSFS */
+
+#endif /* _SYSFS_KOBJECT_H */
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 8af072e..38b73f9 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -1,8 +1,13 @@
 /*
  * sysfs.h - definitions for the device driver filesystem
  *
- * Copyright (c) 2001,2002 Patrick Mochel
- * Copyright (c) 2004 Silicon Graphics, Inc.
+ * Primary sysfs interface based on sysfs_dirent
+ *
+ * If you're using sysfs directly instead of via driver model, please
+ * use this interface.  It's independent from the driver model and
+ * kobject, cleaner and includes more features such as plugging of
+ * subtree while building it.  Kobject-based compatibility interface
+ * is defined in linux/sysfs-kobject.h
  *
  * Please see Documentation/filesystems/sysfs.txt for more information.
  */
@@ -11,195 +16,16 @@
 #define _SYSFS_H_
 
 #include <linux/compiler.h>
-#include <linux/errno.h>
-#include <linux/list.h>
-#include <asm/atomic.h>
-
-struct kobject;
-struct module;
-
-/* FIXME
- * The *owner field is no longer used, but leave around
- * until the tree gets cleaned up fully.
- */
-struct attribute {
-	const char		*name;
-	struct module		*owner;
-	mode_t			mode;
-};
-
-struct attribute_group {
-	const char		*name;
-	struct attribute	**attrs;
-};
-
-
-
-/**
- * Use these macros to make defining attributes easier. See include/linux/device.h
- * for examples..
- */
-
-#define __ATTR(_name,_mode,_show,_store) { \
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show	= _show,					\
-	.store	= _store,					\
-}
-
-#define __ATTR_RO(_name) { \
-	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
-	.show	= _name##_show,					\
-}
-
-#define __ATTR_NULL { .attr = { .name = NULL } }
-
-#define attr_name(_attr) (_attr).attr.name
+#include <linux/types.h>
 
 struct vm_area_struct;
 
-struct bin_attribute {
-	struct attribute	attr;
-	size_t			size;
-	void			*private;
-	ssize_t (*read)(struct kobject *, struct bin_attribute *,
-			char *, loff_t, size_t);
-	ssize_t (*write)(struct kobject *, struct bin_attribute *,
-			 char *, loff_t, size_t);
-	int (*mmap)(struct kobject *, struct bin_attribute *attr,
-		    struct vm_area_struct *vma);
-};
-
-struct sysfs_ops {
-	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
-	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
-};
-
 #ifdef CONFIG_SYSFS
 
-int __must_check sysfs_create_dir(struct kobject *kobj);
-void sysfs_remove_dir(struct kobject *kobj);
-int __must_check sysfs_rename_dir(struct kobject *kobj, const char *new_name);
-int __must_check sysfs_move_dir(struct kobject *kobj,
-				struct kobject *new_parent_kobj);
-
-int __must_check sysfs_create_file(struct kobject *kobj,
-				   const struct attribute *attr);
-int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
-				  mode_t mode);
-void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
-
-int __must_check sysfs_create_bin_file(struct kobject *kobj,
-				       struct bin_attribute *attr);
-void sysfs_remove_bin_file(struct kobject *kobj, struct bin_attribute *attr);
-
-int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
-				   const char *name);
-void sysfs_remove_link(struct kobject *kobj, const char *name);
-
-int __must_check sysfs_create_group(struct kobject *kobj,
-				    const struct attribute_group *grp);
-void sysfs_remove_group(struct kobject *kobj,
-			const struct attribute_group *grp);
-int sysfs_add_file_to_group(struct kobject *kobj,
-			const struct attribute *attr, const char *group);
-void sysfs_remove_file_from_group(struct kobject *kobj,
-			const struct attribute *attr, const char *group);
-
-void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
-
-extern int __must_check sysfs_init(void);
+int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
 
-static inline int sysfs_create_dir(struct kobject *kobj)
-{
-	return 0;
-}
-
-static inline void sysfs_remove_dir(struct kobject *kobj)
-{
-	;
-}
-
-static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
-{
-	return 0;
-}
-
-static inline int sysfs_move_dir(struct kobject *kobj,
-				 struct kobject *new_parent_kobj)
-{
-	return 0;
-}
-
-static inline int sysfs_create_file(struct kobject *kobj,
-				    const struct attribute *attr)
-{
-	return 0;
-}
-
-static inline int sysfs_chmod_file(struct kobject *kobj,
-				   struct attribute *attr, mode_t mode)
-{
-	return 0;
-}
-
-static inline void sysfs_remove_file(struct kobject *kobj,
-				     const struct attribute *attr)
-{
-	;
-}
-
-static inline int sysfs_create_bin_file(struct kobject *kobj,
-					struct bin_attribute *attr)
-{
-	return 0;
-}
-
-static inline int sysfs_remove_bin_file(struct kobject *kobj,
-					struct bin_attribute *attr)
-{
-	return 0;
-}
-
-static inline int sysfs_create_link(struct kobject *kobj,
-				    struct kobject *target, const char *name)
-{
-	return 0;
-}
-
-static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
-{
-	;
-}
-
-static inline int sysfs_create_group(struct kobject *kobj,
-				     const struct attribute_group *grp)
-{
-	return 0;
-}
-
-static inline void sysfs_remove_group(struct kobject *kobj,
-				      const struct attribute_group *grp)
-{
-	;
-}
-
-static inline int sysfs_add_file_to_group(struct kobject *kobj,
-		const struct attribute *attr, const char *group)
-{
-	return 0;
-}
-
-static inline void sysfs_remove_file_from_group(struct kobject *kobj,
-		const struct attribute *attr, const char *group)
-{
-}
-
-static inline void sysfs_notify(struct kobject *kobj, char *dir, char *attr)
-{
-}
-
 static inline int __must_check sysfs_init(void)
 {
 	return 0;
@@ -207,4 +33,9 @@ static inline int __must_check sysfs_init(void)
 
 #endif /* CONFIG_SYSFS */
 
+/*
+ * Implicitly include kobject based compatibility interface for now
+ */
+#include <linux/sysfs-kobject.h>
+
 #endif /* _SYSFS_H_ */
-- 
1.5.0.3


