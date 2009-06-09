Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbZFIIlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbZFIIlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbZFIIlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:41:00 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:38087 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbZFIIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:40:58 -0400
Date: Tue, 9 Jun 2009 10:40:03 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2] pm: Move nvs routines into a seperate file.
Message-ID: <20090609104003.50830165@gondolin>
In-Reply-To: <200906082048.28779.rjw@sisk.pl>
References: <20090604161847.513682672@de.ibm.com>
	<20090608063501.GC1444@ucw.cz>
	<20090608173611.16238cf9@gondolin>
	<200906082048.28779.rjw@sisk.pl>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *_nvs_* routines in swsusp.c make use of the io*map()
functions, which are only provided for HAS_IOMEM, thus
breaking compilation if HAS_IOMEM is not set. Fix this
by moving the *_nvs_* routines into hibernation_nvs.c, which
is only compiled if HAS_IOMEM is set.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 include/linux/suspend.h        |   18 +++--
 kernel/power/Kconfig           |    4 +
 kernel/power/Makefile          |    1 
 kernel/power/hibernation_nvs.c |  135 +++++++++++++++++++++++++++++++++++++++++
 kernel/power/swsusp.c          |  122 -------------------------------------
 5 files changed, 151 insertions(+), 129 deletions(-)

--- /dev/null
+++ linux-suspend/kernel/power/hibernation_nvs.c
@@ -0,0 +1,135 @@
+/*
+ * linux/kernel/power/hibernation_nvs.c
+ *
+ * Copyright (C) 2008,2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * Routines for NVS memory handling
+ */
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/suspend.h>
+
+/*
+ * Platforms, like ACPI, may want us to save some memory used by them during
+ * hibernation and to restore the contents of this memory during the subsequent
+ * resume.  The code below implements a mechanism allowing us to do that.
+ */
+
+struct nvs_page {
+	unsigned long phys_start;
+	unsigned int size;
+	void *kaddr;
+	void *data;
+	struct list_head node;
+};
+
+static LIST_HEAD(nvs_list);
+
+/**
+ *	hibernate_nvs_register - register platform NVS memory region to save
+ *	@start - physical address of the region
+ *	@size - size of the region
+ *
+ *	The NVS region need not be page-aligned (both ends) and we arrange
+ *	things so that the data from page-aligned addresses in this region will
+ *	be copied into separate RAM pages.
+ */
+int hibernate_nvs_register(unsigned long start, unsigned long size)
+{
+	struct nvs_page *entry, *next;
+
+	while (size > 0) {
+		unsigned int nr_bytes;
+
+		entry = kzalloc(sizeof(struct nvs_page), GFP_KERNEL);
+		if (!entry)
+			goto Error;
+
+		list_add_tail(&entry->node, &nvs_list);
+		entry->phys_start = start;
+		nr_bytes = PAGE_SIZE - (start & ~PAGE_MASK);
+		entry->size = (size < nr_bytes) ? size : nr_bytes;
+
+		start += entry->size;
+		size -= entry->size;
+	}
+	return 0;
+
+ Error:
+	list_for_each_entry_safe(entry, next, &nvs_list, node) {
+		list_del(&entry->node);
+		kfree(entry);
+	}
+	return -ENOMEM;
+}
+
+/**
+ *	hibernate_nvs_free - free data pages allocated for saving NVS regions
+ */
+void hibernate_nvs_free(void)
+{
+	struct nvs_page *entry;
+
+	list_for_each_entry(entry, &nvs_list, node)
+		if (entry->data) {
+			free_page((unsigned long)entry->data);
+			entry->data = NULL;
+			if (entry->kaddr) {
+				iounmap(entry->kaddr);
+				entry->kaddr = NULL;
+			}
+		}
+}
+
+/**
+ *	hibernate_nvs_alloc - allocate memory necessary for saving NVS regions
+ */
+int hibernate_nvs_alloc(void)
+{
+	struct nvs_page *entry;
+
+	list_for_each_entry(entry, &nvs_list, node) {
+		entry->data = (void *)__get_free_page(GFP_KERNEL);
+		if (!entry->data) {
+			hibernate_nvs_free();
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+/**
+ *	hibernate_nvs_save - save NVS memory regions
+ */
+void hibernate_nvs_save(void)
+{
+	struct nvs_page *entry;
+
+	printk(KERN_INFO "PM: Saving platform NVS memory\n");
+
+	list_for_each_entry(entry, &nvs_list, node)
+		if (entry->data) {
+			entry->kaddr = ioremap(entry->phys_start, entry->size);
+			memcpy(entry->data, entry->kaddr, entry->size);
+		}
+}
+
+/**
+ *	hibernate_nvs_restore - restore NVS memory regions
+ *
+ *	This function is going to be called with interrupts disabled, so it
+ *	cannot iounmap the virtual addresses used to access the NVS region.
+ */
+void hibernate_nvs_restore(void)
+{
+	struct nvs_page *entry;
+
+	printk(KERN_INFO "PM: Restoring platform NVS memory\n");
+
+	list_for_each_entry(entry, &nvs_list, node)
+		if (entry->data)
+			memcpy(entry->kaddr, entry->data, entry->size);
+}
--- linux-suspend.orig/kernel/power/swsusp.c
+++ linux-suspend/kernel/power/swsusp.c
@@ -186,125 +186,3 @@ void swsusp_show_speed(struct timeval *s
 			centisecs / 100, centisecs % 100,
 			kps / 1000, (kps % 1000) / 10);
 }
-
-/*
- * Platforms, like ACPI, may want us to save some memory used by them during
- * hibernation and to restore the contents of this memory during the subsequent
- * resume.  The code below implements a mechanism allowing us to do that.
- */
-
-struct nvs_page {
-	unsigned long phys_start;
-	unsigned int size;
-	void *kaddr;
-	void *data;
-	struct list_head node;
-};
-
-static LIST_HEAD(nvs_list);
-
-/**
- *	hibernate_nvs_register - register platform NVS memory region to save
- *	@start - physical address of the region
- *	@size - size of the region
- *
- *	The NVS region need not be page-aligned (both ends) and we arrange
- *	things so that the data from page-aligned addresses in this region will
- *	be copied into separate RAM pages.
- */
-int hibernate_nvs_register(unsigned long start, unsigned long size)
-{
-	struct nvs_page *entry, *next;
-
-	while (size > 0) {
-		unsigned int nr_bytes;
-
-		entry = kzalloc(sizeof(struct nvs_page), GFP_KERNEL);
-		if (!entry)
-			goto Error;
-
-		list_add_tail(&entry->node, &nvs_list);
-		entry->phys_start = start;
-		nr_bytes = PAGE_SIZE - (start & ~PAGE_MASK);
-		entry->size = (size < nr_bytes) ? size : nr_bytes;
-
-		start += entry->size;
-		size -= entry->size;
-	}
-	return 0;
-
- Error:
-	list_for_each_entry_safe(entry, next, &nvs_list, node) {
-		list_del(&entry->node);
-		kfree(entry);
-	}
-	return -ENOMEM;
-}
-
-/**
- *	hibernate_nvs_free - free data pages allocated for saving NVS regions
- */
-void hibernate_nvs_free(void)
-{
-	struct nvs_page *entry;
-
-	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data) {
-			free_page((unsigned long)entry->data);
-			entry->data = NULL;
-			if (entry->kaddr) {
-				iounmap(entry->kaddr);
-				entry->kaddr = NULL;
-			}
-		}
-}
-
-/**
- *	hibernate_nvs_alloc - allocate memory necessary for saving NVS regions
- */
-int hibernate_nvs_alloc(void)
-{
-	struct nvs_page *entry;
-
-	list_for_each_entry(entry, &nvs_list, node) {
-		entry->data = (void *)__get_free_page(GFP_KERNEL);
-		if (!entry->data) {
-			hibernate_nvs_free();
-			return -ENOMEM;
-		}
-	}
-	return 0;
-}
-
-/**
- *	hibernate_nvs_save - save NVS memory regions
- */
-void hibernate_nvs_save(void)
-{
-	struct nvs_page *entry;
-
-	printk(KERN_INFO "PM: Saving platform NVS memory\n");
-
-	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data) {
-			entry->kaddr = ioremap(entry->phys_start, entry->size);
-			memcpy(entry->data, entry->kaddr, entry->size);
-		}
-}
-
-/**
- *	hibernate_nvs_restore - restore NVS memory regions
- *
- *	This function is going to be called with interrupts disabled, so it
- *	cannot iounmap the virtual addresses used to access the NVS region.
- */
-void hibernate_nvs_restore(void)
-{
-	struct nvs_page *entry;
-
-	printk(KERN_INFO "PM: Restoring platform NVS memory\n");
-
-	list_for_each_entry(entry, &nvs_list, node)
-		if (entry->data)
-			memcpy(entry->kaddr, entry->data, entry->size);
-}
--- linux-suspend.orig/kernel/power/Kconfig
+++ linux-suspend/kernel/power/Kconfig
@@ -116,9 +116,13 @@ config SUSPEND_FREEZER
 
 	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
 
+config HIBERNATION_NVS
+	bool
+
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
 	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
+	select HIBERNATION_NVS if HAS_IOMEM
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
 	  called "hibernation" in user interfaces.  STD checkpoints the
--- linux-suspend.orig/kernel/power/Makefile
+++ linux-suspend/kernel/power/Makefile
@@ -7,5 +7,6 @@ obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
+obj-$(CONFIG_HIBERNATION_NVS)	+= hibernation_nvs.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
--- linux-suspend.orig/include/linux/suspend.h
+++ linux-suspend/include/linux/suspend.h
@@ -245,11 +245,6 @@ extern unsigned long get_safe_page(gfp_t
 
 extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
 extern int hibernate(void);
-extern int hibernate_nvs_register(unsigned long start, unsigned long size);
-extern int hibernate_nvs_alloc(void);
-extern void hibernate_nvs_free(void);
-extern void hibernate_nvs_save(void);
-extern void hibernate_nvs_restore(void);
 extern bool system_entering_hibernation(void);
 #else /* CONFIG_HIBERNATION */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
@@ -258,6 +253,16 @@ static inline void swsusp_unset_page_fre
 
 static inline void hibernation_set_ops(struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
+static inline bool system_entering_hibernation(void) { return false; }
+#endif /* CONFIG_HIBERNATION */
+
+#ifdef CONFIG_HIBERNATION_NVS
+extern int hibernate_nvs_register(unsigned long start, unsigned long size);
+extern int hibernate_nvs_alloc(void);
+extern void hibernate_nvs_free(void);
+extern void hibernate_nvs_save(void);
+extern void hibernate_nvs_restore(void);
+#else /* CONFIG_HIBERNATION_NVS */
 static inline int hibernate_nvs_register(unsigned long a, unsigned long b)
 {
 	return 0;
@@ -266,8 +271,7 @@ static inline int hibernate_nvs_alloc(vo
 static inline void hibernate_nvs_free(void) {}
 static inline void hibernate_nvs_save(void) {}
 static inline void hibernate_nvs_restore(void) {}
-static inline bool system_entering_hibernation(void) { return false; }
-#endif /* CONFIG_HIBERNATION */
+#endif /* CONFIG_HIBERNATION_NVS */
 
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
