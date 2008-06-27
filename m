Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYF0LMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYF0LMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYF0LMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:12:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:40874 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbYF0LMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:12:19 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: gregkh@suse.de, kexec@lists.infradead.org, yhlu.kernel@gmail.com,
       vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 1/2] Add /sys/firmware/memmap
Date: Fri, 27 Jun 2008 13:12:54 +0200
Message-Id: <1214565175-21512-2-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214565175-21512-1-git-send-email-bwalle@suse.de>
References: <1214565175-21512-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds /sys/firmware/memmap interface that represents the BIOS
(or Firmware) provided memory map. The tree looks like:

    /sys/firmware/memmap/0/start   (hex number)
                           end     (hex number)
                           type    (string)
    ...                 /1/start
                           end
                           type

With the following shell snippet one can print the memory map in the same form
the kernel prints itself when booting on x86 (the E820 map).

  --------- 8< --------------------------
    #!/bin/sh
    cd /sys/firmware/memmap
    for dir in * ; do
        start=$(cat $dir/start)
        end=$(cat $dir/end)
        type=$(cat $dir/type)
        printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type"
    done
  --------- >8 --------------------------

That patch only provides the needed interface:

 1. The sysfs interface.
 2. The structure and enumeration definition.
 3. The function firmware_map_add() and firmware_map_add_early()
    that should be called from architecture code (E820/EFI, for
    example) to add the contents to the interface.

If the kernel is compiled without CONFIG_FIRMWARE_MEMMAP, the interface does
nothing without cluttering the architecture-specific code with #ifdef's.

The purpose of the new interface is kexec: While /proc/iomem represents
the *used* memory map (e.g. modified via kernel parameters like 'memmap'
and 'mem'), the /sys/firmware/memmap tree represents the unmodified memory
map provided via the firmware. So kexec can:

 - use the original memory map for rebooting,
 - use the /proc/iomem for setting up the ELF core headers for kdump
   case that should only represent the memory of the system.

The patch has been tested on i386 and x86_64.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 Documentation/ABI/testing/sysfs-firmware-memmap |   71 ++++++++
 drivers/firmware/Kconfig                        |   10 +
 drivers/firmware/Makefile                       |    1 +
 drivers/firmware/memmap.c                       |  205 +++++++++++++++++++++++
 include/linux/firmware-map.h                    |   74 ++++++++
 5 files changed, 361 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-memmap
 create mode 100644 drivers/firmware/memmap.c
 create mode 100644 include/linux/firmware-map.h

diff --git a/Documentation/ABI/testing/sysfs-firmware-memmap b/Documentation/ABI/testing/sysfs-firmware-memmap
new file mode 100644
index 0000000..0d99ee6
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-memmap
@@ -0,0 +1,71 @@
+What:		/sys/firmware/memmap/
+Date:		June 2008
+Contact:	Bernhard Walle <bwalle@suse.de>
+Description:
+		On all platforms, the firmware provides a memory map which the
+		kernel reads. The resources from that memory map are registered
+		in the kernel resource tree and exposed to userspace via
+		/proc/iomem (together with other resources).
+
+		However, on most architectures that firmware-provided memory
+		map is modified afterwards by the kernel itself, either because
+		the kernel merges that memory map with other information or
+		just because the user overwrites that memory map via command
+		line.
+
+		kexec needs the raw firmware-provided memory map to setup the
+		parameter segment of the kernel that should be booted with
+		kexec. Also, the raw memory map is useful for debugging. For
+		that reason, /sys/firmware/memmap is an interface that provides
+		the raw memory map to userspace.
+
+		The structure is as follows: Under /sys/firmware/memmap there
+		are subdirectories with the number of the entry as their name:
+
+			/sys/firmware/memmap/0
+			/sys/firmware/memmap/1
+			/sys/firmware/memmap/2
+			/sys/firmware/memmap/3
+			...
+
+		The maximum depends on the number of memory map entries provided
+		by the firmware. The order is just the order that the firmware
+		provides.
+
+		Each directory contains three files:
+
+		start	: The start address (as hexadecimal number with the
+			  '0x' prefix).
+		end	: The end address, inclusive (regardless whether the
+			  firmware provides inclusive or exclusive ranges).
+		type	: Type of the entry as string. See below for a list of
+			  valid types.
+
+		So, for example:
+
+			/sys/firmware/memmap/0/start
+			/sys/firmware/memmap/0/end
+			/sys/firmware/memmap/0/type
+			/sys/firmware/memmap/1/start
+			...
+
+		Currently following types exist:
+
+		  - System RAM
+		  - ACPI Tables
+		  - ACPI Non-volatile Storage
+		  - reserved
+
+		Following shell snippet can be used to display that memory
+		map in a human-readable format:
+
+		-------------------- 8< ----------------------------------------
+		  #!/bin/bash
+		  cd /sys/firmware/memmap
+		  for dir in * ; do
+		      start=$(cat $dir/start)
+		      end=$(cat $dir/end)
+		      type=$(cat $dir/type)
+		      printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type"
+		  done
+		-------------------- >8 ----------------------------------------
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index dc2cec6..ebb9e51 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -26,6 +26,16 @@ config EDD_OFF
 	  kernel. Say N if you want EDD enabled by default. EDD can be dynamically set
 	  using the kernel parameter 'edd={on|skipmbr|off}'.
 
+config FIRMWARE_MEMMAP
+    bool "Add firmware-provided memory map to sysfs" if EMBEDDED
+    default (X86_64 || X86_32)
+    help
+      Add the firmware-provided (unmodified) memory map to /sys/firmware/memmap.
+      That memory map is used for example by kexec to set up parameter area
+      for the next kernel, but can also be used for debugging purposes.
+
+      See also Documentation/ABI/testing/sysfs-firmware-memmap.
+
 config EFI_VARS
 	tristate "EFI Variable Support via sysfs"
 	depends on EFI
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 4c91471..1c3c173 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_DCDBAS)		+= dcdbas.o
 obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
+obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
new file mode 100644
index 0000000..e23399c
--- /dev/null
+++ b/drivers/firmware/memmap.c
@@ -0,0 +1,205 @@
+/*
+ * linux/drivers/firmware/memmap.c
+ *  Copyright (C) 2008 SUSE LINUX Products GmbH
+ *  by Bernhard Walle <bwalle@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2.0 as published by
+ * the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/string.h>
+#include <linux/firmware-map.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/bootmem.h>
+
+/*
+ * Data types ------------------------------------------------------------------
+ */
+
+/*
+ * Firmware map entry. Because firmware memory maps are flat and not
+ * hierarchical, it's ok to organise them in a linked list. No parent
+ * information is necessary as for the resource tree.
+ */
+struct firmware_map_entry {
+	resource_size_t		start;	/* start of the memory range */
+	resource_size_t		end;	/* end of the memory range (incl.) */
+	const char		*type;	/* type of the memory range */
+	struct list_head	list;	/* entry for the linked list */
+	struct kobject		kobj;   /* kobject for each entry */
+};
+
+/*
+ * Forward declarations --------------------------------------------------------
+ */
+static ssize_t memmap_attr_show(struct kobject *kobj,
+				struct attribute *attr, char *buf);
+static ssize_t start_show(struct firmware_map_entry *entry, char *buf);
+static ssize_t end_show(struct firmware_map_entry *entry, char *buf);
+static ssize_t type_show(struct firmware_map_entry *entry, char *buf);
+
+/*
+ * Static data -----------------------------------------------------------------
+ */
+
+struct memmap_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct firmware_map_entry *entry, char *buf);
+};
+
+struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
+struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
+struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);
+
+/*
+ * These are default attributes that are added for every memmap entry.
+ */
+static struct attribute *def_attrs[] = {
+	&memmap_start_attr.attr,
+	&memmap_end_attr.attr,
+	&memmap_type_attr.attr,
+	NULL
+};
+
+static struct sysfs_ops memmap_attr_ops = {
+	.show = memmap_attr_show,
+};
+
+static struct kobj_type memmap_ktype = {
+	.sysfs_ops	= &memmap_attr_ops,
+	.default_attrs	= def_attrs,
+};
+
+/*
+ * Registration functions ------------------------------------------------------
+ */
+
+/*
+ * Firmware memory map entries
+ */
+static LIST_HEAD(map_entries);
+
+/**
+ * Common implementation of firmware_map_add() and firmware_map_add_early()
+ * which expects a pre-allocated struct firmware_map_entry.
+ *
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (inclusive).
+ * @type:  Type of the memory range.
+ * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
+ *         entry.
+ */
+static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
+				  const char *type,
+				  struct firmware_map_entry *entry)
+{
+	BUG_ON(start > end);
+
+	entry->start = start;
+	entry->end = end;
+	entry->type = type;
+	INIT_LIST_HEAD(&entry->list);
+	kobject_init(&entry->kobj, &memmap_ktype);
+
+	list_add_tail(&entry->list, &map_entries);
+
+	return 0;
+}
+
+/*
+ * See <linux/firmware-map.h> for documentation.
+ */
+int firmware_map_add(resource_size_t start, resource_size_t end,
+		     const char *type)
+{
+	struct firmware_map_entry *entry;
+
+	entry = kmalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
+	WARN_ON(!entry);
+	if (!entry)
+		return -ENOMEM;
+
+	return firmware_map_add_entry(start, end, type, entry);
+}
+
+/*
+ * See <linux/firmware-map.h> for documentation.
+ */
+int __init firmware_map_add_early(resource_size_t start, resource_size_t end,
+				  const char *type)
+{
+	struct firmware_map_entry *entry;
+
+	entry = alloc_bootmem_low(sizeof(struct firmware_map_entry));
+	WARN_ON(!entry);
+	if (!entry)
+		return -ENOMEM;
+
+	return firmware_map_add_entry(start, end, type, entry);
+}
+
+/*
+ * Sysfs functions -------------------------------------------------------------
+ */
+
+static ssize_t start_show(struct firmware_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->start);
+}
+
+static ssize_t end_show(struct firmware_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", entry->end);
+}
+
+static ssize_t type_show(struct firmware_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", entry->type);
+}
+
+#define to_memmap_attr(_attr) container_of(_attr, struct memmap_attribute, attr)
+#define to_memmap_entry(obj) container_of(obj, struct firmware_map_entry, kobj)
+
+static ssize_t memmap_attr_show(struct kobject *kobj,
+				struct attribute *attr, char *buf)
+{
+	struct firmware_map_entry *entry = to_memmap_entry(kobj);
+	struct memmap_attribute *memmap_attr = to_memmap_attr(attr);
+
+	return memmap_attr->show(entry, buf);
+}
+
+/*
+ * Initialises stuff and adds the entries in the map_entries list to
+ * sysfs. Important is that firmware_map_add() and firmware_map_add_early()
+ * must be called before late_initcall.
+ */
+static int __init memmap_init(void)
+{
+	int i = 0;
+	struct firmware_map_entry *entry;
+	struct kset *memmap_kset;
+
+	memmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
+	WARN_ON(!memmap_kset);
+	if (!memmap_kset)
+		return -ENOMEM;
+
+	list_for_each_entry(entry, &map_entries, list) {
+		entry->kobj.kset = memmap_kset;
+		kobject_add(&entry->kobj, NULL, "%d", i++);
+	}
+
+	return 0;
+}
+late_initcall(memmap_init);
+
diff --git a/include/linux/firmware-map.h b/include/linux/firmware-map.h
new file mode 100644
index 0000000..acbdbcc
--- /dev/null
+++ b/include/linux/firmware-map.h
@@ -0,0 +1,74 @@
+/*
+ * include/linux/firmware-map.h:
+ *  Copyright (C) 2008 SUSE LINUX Products GmbH
+ *  by Bernhard Walle <bwalle@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License v2.0 as published by
+ * the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef _LINUX_FIRMWARE_MAP_H
+#define _LINUX_FIRMWARE_MAP_H
+
+#include <linux/list.h>
+#include <linux/kobject.h>
+
+/*
+ * provide a dummy interface if CONFIG_FIRMWARE_MEMMAP is disabled
+ */
+#ifdef CONFIG_FIRMWARE_MEMMAP
+
+/**
+ * Adds a firmware mapping entry. This function uses kmalloc() for memory
+ * allocation. Use firmware_map_add_early() if you want to use the bootmem
+ * allocator.
+ *
+ * That function must be called before late_initcall.
+ *
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (inclusive).
+ * @type:  Type of the memory range.
+ *
+ * Returns 0 on success, or -ENOMEM if no memory could be allocated.
+ */
+int firmware_map_add(resource_size_t start, resource_size_t end,
+		     const char *type);
+
+/**
+ * Adds a firmware mapping entry. This function uses the bootmem allocator
+ * for memory allocation. Use firmware_map_add() if you want to use kmalloc().
+ *
+ * That function must be called before late_initcall.
+ *
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (inclusive).
+ * @type:  Type of the memory range.
+ *
+ * Returns 0 on success, or -ENOMEM if no memory could be allocated.
+ */
+int firmware_map_add_early(resource_size_t start, resource_size_t end,
+			   const char *type);
+
+#else /* CONFIG_FIRMWARE_MEMMAP */
+
+static inline int firmware_map_add(resource_size_t start, resource_size_t end,
+				   const char *type)
+{
+	return 0;
+}
+
+static inline int firmware_map_add_early(resource_size_t start,
+					 resource_size_t end, const char *type)
+{
+	return 0;
+}
+
+#endif /* CONFIG_FIRMWARE_MEMMAP */
+
+#endif /* _LINUX_FIRMWARE_MAP_H */
-- 
1.5.6

