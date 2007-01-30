Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbXA3K0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbXA3K0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933015AbXA3K0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:26:25 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39379 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbXA3K0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:26:19 -0500
Message-Id: <20070130102909.745100000@bull.net>
References: <20070130101143.296619000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 30 Jan 2007 11:11:46 +0100
From: Nadia.Derbey@bull.net
To: akpm@osdl.org, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 3/6] AKT - tunables associated kobjects
Content-Disposition: inline; filename=auto_tuning_kobjects.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 03/06]    


Introduces the kobjects associated to each tunable and the sysfs registration


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 include/linux/akt.h         |   25 ++++-
 init/main.c                 |    1 
 kernel/autotune/Makefile    |    2 
 kernel/autotune/akt.c       |   91 ++++++++++++++++++
 kernel/autotune/akt_sysfs.c |  214 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 330 insertions(+), 3 deletions(-)

Index: linux-2.6.20-rc4/include/linux/akt.h
===================================================================
--- linux-2.6.20-rc4.orig/include/linux/akt.h	2007-01-29 15:07:54.000000000 +0100
+++ linux-2.6.20-rc4/include/linux/akt.h	2007-01-29 15:32:48.000000000 +0100
@@ -48,6 +48,16 @@ typedef int (*auto_tune_fn)(int, struct 
 
 
 /*
+ * for sysfs support
+ */
+struct tunable_kobject {
+	struct kobject kobj;
+	struct auto_tune *tun;
+};
+
+
+
+/*
  * Structure used to describe the min / max values for a tunable inside the
  * auto_tune structure.
  */
@@ -62,7 +72,12 @@ struct tunable_limit {
  * allocated for each registered tunable, and the associated kobject exported
  * via sysfs.
  *
- * The structure lock (tunable_lck) protects
+ * This structure may be accessed in 2 ways:
+ *   . directly from inside the kernel susbsystem that uses it (during tunable
+ *     automatic adjustment)
+ *   . from sysfs, while updating the kobject attributes
+ *
+ * In both cases, the structure lock (tunable_lck) is taken: it protects
  * against concurrent accesses to tunable and checked pointers
  *
  * A pointer to this structure is passed in to  the automatic adjustment
@@ -92,6 +107,7 @@ struct auto_tune {
 					/* reach */
 	struct tunable_limit max;	/* max value the tunable can ever */
 					/* reach */
+	struct tunable_kobject    tun_kobj;	/* used for sysfs support */
 	void *tunable;	/* address of the tunable to adjust */
 	void *checked;	/* address of the variable that is controlled by */
 			/* the tunable. This is the calling subsystem's */
@@ -141,6 +157,7 @@ static inline int is_tunable_registered(
 		.max	= {						\
 			.value		= (_max),			\
 		},							\
+		.tun_kobj	= { .tun = NULL, },			\
 		.tunable	= (_tun),				\
 		.checked	= (_chk),				\
 	}
@@ -194,8 +211,12 @@ static inline int activate_auto_tuning(i
 }
 
 
+extern void init_auto_tuning(void);
 extern int register_tunable(struct auto_tune *);
 extern int unregister_tunable(struct auto_tune *);
+extern int tunable_sysfs_setup(struct auto_tune *);
+extern ssize_t show_tuning_mode(struct auto_tune *, char *);
+extern ssize_t store_tuning_mode(struct auto_tune *, const char *, size_t);
 
 
 #else	/* CONFIG_AKT */
@@ -210,6 +231,8 @@ extern int unregister_tunable(struct aut
 #define register_tunable(a)                 0
 #define unregister_tunable(a)               0
 
+static inline void init_auto_tuning(void)   { }
+
 #endif	/* CONFIG_AKT */
 
 extern void fork_late_init(void);
Index: linux-2.6.20-rc4/init/main.c
===================================================================
--- linux-2.6.20-rc4.orig/init/main.c	2007-01-29 13:36:41.000000000 +0100
+++ linux-2.6.20-rc4/init/main.c	2007-01-29 15:33:43.000000000 +0100
@@ -614,6 +614,7 @@ asmlinkage void __init start_kernel(void
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();
+	init_auto_tuning();
 	fork_late_init();
 #ifdef CONFIG_PROC_FS
 	proc_root_init();
Index: linux-2.6.20-rc4/kernel/autotune/Makefile
===================================================================
--- linux-2.6.20-rc4.orig/kernel/autotune/Makefile	2007-01-29 13:40:06.000000000 +0100
+++ linux-2.6.20-rc4/kernel/autotune/Makefile	2007-01-29 15:34:30.000000000 +0100
@@ -2,6 +2,6 @@
 # Makefile for akt
 #
 
-obj-y := akt.o
+obj-y := akt.o akt_sysfs.o
 
 
Index: linux-2.6.20-rc4/kernel/autotune/akt.c
===================================================================
--- linux-2.6.20-rc4.orig/kernel/autotune/akt.c	2007-01-29 14:03:16.000000000 +0100
+++ linux-2.6.20-rc4/kernel/autotune/akt.c	2007-01-29 15:42:55.000000000 +0100
@@ -26,6 +26,8 @@
  *   FUNCTIONS:
  *              register_tunable           (exported)
  *              unregister_tunable         (exported)
+ *              show_tuning_mode           (exported)
+ *              store_tuning_mode          (exported)
  */
 
 #include <linux/init.h>
@@ -34,6 +36,9 @@
 #include <linux/akt.h>
 
 
+#define AKT_AUTO   1
+#define AKT_MANUAL 0
+
 /**
  * register_tunable - Inserts a tunable structure into sysfs
  * @tun:	tunable structure to be registered
@@ -50,6 +55,8 @@
  */
 int register_tunable(struct auto_tune *tun)
 {
+	int rc = 0;
+
 	if (tun == NULL) {
 		printk(KERN_ERR
 			"AKT: Bad tunable structure pointer (NULL)\n");
@@ -80,7 +87,10 @@ int register_tunable(struct auto_tune *t
 		return -EINVAL;
 	}
 
-	return 0;
+	if (!(rc = tunable_sysfs_setup(tun)))
+		tun->flags |= TUNABLE_REGISTERED;
+
+	return rc;
 }
 
 EXPORT_SYMBOL_GPL(register_tunable);
@@ -117,3 +127,82 @@ int unregister_tunable(struct auto_tune 
 }
 
 EXPORT_SYMBOL_GPL(unregister_tunable);
+
+
+/**
+ * show_tuning_mode - Outputs the tuning mode of a given tunable
+ * @tun_addr:	registered tunable structure to check
+ * @buf:	output buffer
+ *
+ * This is the get operation called by tunable_attr_show (i.e. when the file
+ * /sys/tunables/<tunable>/autotune is displayed).
+ * Outputs "1" if the corresponding tunable is automatically adjustable,
+ * "0" else
+ *
+ * Returns:	>0 - output string length (including the '\0')
+ *		<0 - failure
+ */
+ssize_t show_tuning_mode(struct auto_tune *tun_addr, char *buf)
+{
+	int valid;
+
+	if (tun_addr == NULL) {
+		printk(KERN_ERR "AKT: tunable address is invalid\n");
+		return -EINVAL;
+	}
+
+	spin_lock(&tun_addr->tunable_lck);
+
+	valid = is_auto_tune_enabled(tun_addr);
+
+	spin_unlock(&tun_addr->tunable_lck);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", valid);
+}
+
+
+/**
+ * store_tuning_mode - Sets the tuning mode of a given tunable
+ * @tun_addr:	registered tunable structure to set
+ * @buf:	input buffer
+ * @count:	input buffer length (including the '\0')
+ *
+ * This is the set operation called by tunable_attr_store (i.e. when a string
+ * is stored into /sys/tunables/<tunable>/autotune).
+ * "1" makes the corresponding tunable automatically adjustable
+ * "0" makes the corresponding tunable manually adjustable
+ *
+ * Returns:	>0 - number of characters used from the input buffer
+ *		<0 - failure
+ */
+ssize_t store_tuning_mode(struct auto_tune *tun_addr, const char *buffer,
+			size_t count)
+{
+	int new_value;
+
+	if (sscanf(buffer, "%d", &new_value) != 1)
+		return -EINVAL;
+
+	if (new_value != AKT_AUTO && new_value != AKT_MANUAL)
+		return -EINVAL;
+
+	if (tun_addr == NULL) {
+		printk(KERN_ERR "AKT: NULL pointer  passed in\n");
+		return -EINVAL;
+	}
+
+	spin_lock(&tun_addr->tunable_lck);
+
+	switch (new_value) {
+	case AKT_AUTO:
+		tun_addr->flags |= AUTO_TUNE_ENABLE;
+		break;
+	case AKT_MANUAL:
+		tun_addr->flags &= ~AUTO_TUNE_ENABLE;
+		break;
+	}
+
+	spin_unlock(&tun_addr->tunable_lck);
+
+	return strnlen(buffer, PAGE_SIZE);
+}
Index: linux-2.6.20-rc4/kernel/autotune/akt_sysfs.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20-rc4/kernel/autotune/akt_sysfs.c	2007-01-29 15:39:05.000000000 +0100
@@ -0,0 +1,214 @@
+/*
+ * linux/kernel/autotune/akt_sysfs.c
+ *
+ * Automatic Kernel Tunables for Linux
+ * sysfs bindings for AKT
+ *
+ * Copyright (C) 2006 Bull S.A.S
+ *
+ * Author: Nadia Derbey <Nadia.Derbey@bull.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * FUNCTIONS:
+ *            tunable_attr_show      (static)
+ *            tunable_attr_store     (static)
+ *            tunable_sysfs_setup
+ *            add_tunable_attrs      (static)
+ *            init_auto_tuning
+ */
+
+
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/module.h>
+#include <linux/akt.h>
+
+
+
+
+struct tunable_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct auto_tune *, char *);
+	ssize_t (*store)(struct auto_tune *, const char *, size_t);
+};
+
+#define TUNABLE_ATTR(_name, _mode, _show, _store)	\
+struct tunable_attribute tun_attr_##_name = __ATTR(_name, _mode, _show, _store)
+
+
+static TUNABLE_ATTR(autotune, S_IWUSR | S_IRUGO, show_tuning_mode,
+		store_tuning_mode);
+
+static struct tunable_attribute *tunable_sysfs_attrs[] = {
+	&tun_attr_autotune,	/* to (de)activate auto tuning */
+	NULL,
+};
+
+
+
+#define to_tunable_kobj(obj)  container_of(obj, struct tunable_kobject, kobj)
+#define to_tunable(obj)       container_of(obj, struct auto_tune, tun_kobj)
+#define to_tunable_attr(_attr)	\
+	container_of(_attr, struct tunable_attribute, attr)
+
+
+static int add_tunable_attrs(struct auto_tune *);
+
+
+/**
+ * tunable_attr_show - Show method for the tunables subsystem
+ * @kobj:	tunable associated kobject
+ * @attr:	tunable attribute to read. Can be one of:
+ *			tun_attr_autotune
+ * @buf:	output buffer
+ *
+ * Forwards any read call to the show method of the owning attribute
+ *
+ * Returns:	>0 - output string length (including the '\0')
+ *		<0 - failure
+ */
+static ssize_t tunable_attr_show(struct kobject *kobj,
+				struct attribute *attr,
+				char *buf)
+{
+	struct tunable_attribute *tun_attr = to_tunable_attr(attr);
+	struct tunable_kobject *tkobj = to_tunable_kobj(kobj);
+	struct auto_tune *tunable = to_tunable(tkobj);
+	ssize_t count = -EIO;
+
+	if (tun_attr->show)
+		count = tun_attr->show(tunable, buf);
+	return count;
+}
+
+
+/**
+ * tunable_attr_store - Store method for the tunables subsystem
+ * @kobj:	tunable associated kobject
+ * @attr:	tunable attribute to update. Can be one of:
+ *			tun_attr_autotune
+ * @buf:	input buffer
+ * @count:	input buffer length (including the '\0')
+ *
+ * Forwards any write call to the store method of the owning attribute
+ *
+ * Returns:	>0 - number of characters used from the input buffer
+ *		<0 - failure
+ */
+static ssize_t tunable_attr_store(struct kobject *kobj,
+				struct attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct tunable_attribute *tun_attr = to_tunable_attr(attr);
+	struct tunable_kobject *tkobj = to_tunable_kobj(kobj);
+	struct auto_tune *tunable = to_tunable(tkobj);
+	ssize_t ret = -EIO;
+
+	if (tun_attr->store)
+		ret = tun_attr->store(tunable, buf, count);
+	return ret;
+}
+
+
+static struct sysfs_ops tunables_sysfs_ops = {
+	.show	= tunable_attr_show,
+	.store	= tunable_attr_store,
+};
+
+
+static struct kobj_type tunables_ktype = {
+	.sysfs_ops	= &tunables_sysfs_ops,
+};
+
+
+decl_subsys(tunables, &tunables_ktype, NULL);
+
+
+/**
+ * tunable_sysfs_setup - Registers one tunable into sysfs
+ * @tunable:	tunable structure to be registered
+ *
+ * Called by register_tunable()
+ * The tunable is a kobject with 1 attributes:
+ *	autotune (rw): enables to (de)activate the auto tuning for the tunable
+ *
+ * Returns:	0 - successful
+ *		<0 - failure
+ */
+
+#define tunable_kobj(t) t->tun_kobj.kobj
+
+int tunable_sysfs_setup(struct auto_tune *tunable)
+{
+	int err = 0;
+
+	memset(&(tunable_kobj(tunable)), 0, sizeof(tunable_kobj(tunable)));
+	if ((err = kobject_set_name(&(tunable_kobj(tunable)), "%s",
+							tunable->name)))
+		return err;
+
+	kobj_set_kset_s(&(tunable->tun_kobj), tunables_subsys);
+	tunable->tun_kobj.tun = tunable;
+
+	if ((err = kobject_register(&(tunable_kobj(tunable)))))
+		return err;
+
+	if ((err = add_tunable_attrs(tunable)))
+		kobject_unregister(&(tunable_kobj(tunable)));
+
+	return err;
+}
+
+
+/**
+ * add_tunable_attrs - Creates the attributes for a tunable
+ * @tunable:	tunable structure being registered
+ *
+ * Called by tunable_sysfs_setup()
+ * Adds the set of predefined attributes for a tunable being registered
+ *
+ * Returns:	0 - successful
+ *		<0 - failure
+ */
+static int add_tunable_attrs(struct auto_tune *tunable)
+{
+	struct tunable_attribute *attr;
+	int error = 0;
+	int i;
+
+	for (i = 0; (attr = tunable_sysfs_attrs[i]) && !error; i++) {
+		error = sysfs_create_file(&(tunable_kobj(tunable)),
+			&(attr->attr));
+	}
+
+	return error;
+}
+
+
+/**
+ * init_auto_tuning - registers the tunables subssystem in sysfs
+ */
+void __init init_auto_tuning(void)
+{
+	int error = subsystem_register(&tunables_subsys);
+
+	if (error)
+		printk(KERN_ERR
+			"AKT: Failed registering tunables subsystem\n");
+}

--
