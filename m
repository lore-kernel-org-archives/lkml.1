Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYFZIO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYFZIO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbYFZINy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:13:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:51817 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYFZINu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:13:50 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com, vgoyal@redhat.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 1/2] Add /sys/firmware/memmap
Date: Thu, 26 Jun 2008 10:14:26 +0200
Message-Id: <1214468067-1231-2-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214468067-1231-1-git-send-email-bwalle@suse.de>
References: <1214468067-1231-1-git-send-email-bwalle@suse.de>
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
 drivers/firmware/Kconfig     |    4 +
 drivers/firmware/Makefile    |    1 +
 drivers/firmware/memmap.c    |  164 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/firmware-map.h |   63 ++++++++++++++++
 4 files changed, 232 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firmware/memmap.c
 create mode 100644 include/linux/firmware-map.h

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index dc2cec6..1008737 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -26,6 +26,10 @@ config EDD_OFF
 	  kernel. Say N if you want EDD enabled by default. EDD can be dynamically set
 	  using the kernel parameter 'edd={on|skipmbr|off}'.
 
+config FIRMWARE_MEMMAP
+    def_bool y
+    depends on X86_64 || X86_32
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
index 0000000..998166a
--- /dev/null
+++ b/drivers/firmware/memmap.c
@@ -0,0 +1,164 @@
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
+ * Registration functions ------------------------------------------------------
+ */
+
+/*
+ * Firmware memory map entries
+ */
+LIST_HEAD(map_entries);
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
+
+	list_add_tail(&entry->list, &map_entries);
+
+	return 0;
+}
+
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
+int firmware_map_add_early(resource_size_t start, resource_size_t end,
+			   const char *type)
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
+ * Sysfs functions
+ */
+
+struct memmap_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct firmware_map_entry *entry, char *buf);
+};
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
+static struct sysfs_ops memmap_attr_ops = {
+	.show = memmap_attr_show,
+};
+
+static struct kobj_type memmap_ktype = {
+	.sysfs_ops	= &memmap_attr_ops,
+	.default_attrs	= def_attrs,
+};
+
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
+		kobject_init_and_add(&entry->kobj, &memmap_ktype,
+			NULL, "%d", i++);
+	}
+
+	return 0;
+}
+late_initcall(memmap_init);
+
diff --git a/include/linux/firmware-map.h b/include/linux/firmware-map.h
new file mode 100644
index 0000000..c6bd934
--- /dev/null
+++ b/include/linux/firmware-map.h
@@ -0,0 +1,63 @@
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
+/**
+ * Adds a firmware mapping entry. This function uses kmalloc() for memory
+ * allocation. Use firmware_map_add_early() if you want to use the bootmem
+ * allocator.
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
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (inclusive).
+ * @type:  Type of the memory range.
+ *
+ * Returns 0 on success, or -ENOMEM if no memory could be allocated.
+ */
+int firmware_map_add_early(resource_size_t start, resource_size_t end,
+			   const char *type);
+
+#endif /* _LINUX_FIRMWARE_MAP_H */
-- 
1.5.6

