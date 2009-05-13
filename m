Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZEMJiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZEMJiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 05:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZEMJiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 05:38:08 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39430 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbZEMJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 05:38:03 -0400
Date: Wed, 13 May 2009 11:27:56 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: [PATCH] Physical Memory Management [1/1]
In-reply-to: <op.utu26hq77p4s8u@amdc030>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Message-id: <op.utu28uui7p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
User-Agent: Opera Mail/10.00 (Win32)
References: <op.utu26hq77p4s8u@amdc030>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Physical Memory Management (or PMM) added
    
    PMM allows allocation of continiuous blocks of physical memory.
    Via a device and ioctl(2) calls it allows allocation to be made
    from user space.  Moreover, it can be integrated with System V
    IPC allowing PMM-unaware but shmem-aware programs (notably X11)
    use shared continiuous blocks of physical memory.
    
    Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>

diff --git a/include/linux/pmm.h b/include/linux/pmm.h
new file mode 100644
index 0000000..bf6febe
--- /dev/null
+++ b/include/linux/pmm.h
@@ -0,0 +1,146 @@
+#ifndef __KERNEL_PMM_H
+#define __KERNEL_PMM_H
+
+/*
+ * Physical Memory Managment module
+ * Copyright (c) 2009 by Samsung Electronics.  All rights reserved.
+ * Written by Michal Nazarewicz (mina86@mina86.com)
+ */
+
+
+#include <linux/ioctl.h>
+
+
+
+#if defined CONFIG_PMM_PLATFORM_HAS_OWN_INIT
+   /* Definition of platform dependend memory types. */
+#  include <asm/pmm-plat.h>
+#else
+/**
+ * Number of types of memory.  Must be positive number no greater then
+ * 16 (in fact 32 but let keep it under 16).
+ */
+#  define PMM_MEMORY_TYPES  1
+
+/** A general purpose memory. */
+#define PMM_MEM_GENERAL     1
+
+
+#  ifdef __KERNEL__
+
+/** Mask of types that user space tools can allocate. */
+#    define PMM_USER_MEMORY_TYPES_MASK 1
+
+#  endif
+
+#endif
+
+
+
+/** An information about area exportable to user space. */
+struct pmm_area_info {
+	unsigned magic;      /**< Magic number (must be PMM_MAGIC) */
+	size_t   size;       /**< Size of the area */
+	unsigned type;       /**< Memory's type */
+	unsigned flags;      /**< Flags (unused as of yet) */
+	size_t   alignment;   /**< Area's alignment as a power of two */
+};
+
+/** Value of pmm_area_info::magic field. */
+#define PMM_MAGIC (('p' << 24) | ('M' << 16) | ('m' << 8) | 0x42)
+
+
+/**
+ * Allocates area.  Accepts struct pmm_area_info as in/out
+ * argument.  Meaning of each field is as follows:
+ * - size     size in bytes of desired area.
+ * - type     mask of types to allocate from
+ * - flags    additional flags (no flags defined yet)
+ * - alignment area's alignment as a power of two
+ * Returns area's key or -1 on error.
+ */
+#define IOCTL_PMM_ALLOC    _IOWR('p', 0, struct pmm_area_info)
+
+
+
+struct pmm_shm_info {
+	unsigned magic;      /**< Magic number (must be PMM_MAGIC) */
+	key_t    key;
+	int      shmflg;
+};
+
+/* TODO document */
+#define IOCTL_PMM_SHMGET   _IOR('p', 0, struct pmm_shm_info)
+
+
+
+
+#if __KERNEL__
+
+
+/**
+ * Allocates continuous block of memory.  Allocated area must be
+ * released (@see pmm_release()) when code no longer uses it.
+ * Arguments to the function are passed in a pmm_area_info
+ * structure (which see).  Meaning of each is described below:
+ *
+ * \a info->u.size specifies how large the area shall be.  It must
+ * be page aligned.
+ *
+ * \a info->u.type is a bitwise OR of all memory types that should be
+ * tried.  The module may define several types of memory and user
+ * space programs may desire to allocate areas of different types.
+ * This attribute specifies what types user space tool is interested
+ * in.  Area will be allocated in first type that had enough space.
+ *
+ * \a info->u.flags is a bitwise OR of additional flags.  None are
+ * defined as of yet.
+ *
+ * \a info->u.alignment specifies size alignment of a physical
+ * address of the area.  It must be power of two or zero.  If given,
+ * physical address will be a multiple of that value.  In fact, the
+ * area may have a bigger alignment -- the final alignment will be saved
+ * in info structure.
+ *
+ * If the area is allocated sucesfully \a info is filled with
+ * information about the area.
+ *
+ * @param  info    input/output argument
+ * @return area's physical address or zero on error
+ */
+__must_check
+size_t pmm_alloc(struct pmm_area_info *info);
+
+
+/**
+ * Increases PMM's area reference counter.
+ * @param  addr block's physical address.
+ * @return zero on success, negative on error
+ */
+int    pmm_get(size_t paddr);
+
+/**
+ * Decreases PMM's area reference counter and possibly frees it if it
+ * reaches zero.
+ *
+ * @param  addr block's physical address.
+ * @return zero on success, negative on error
+ */
+int    pmm_put(size_t paddr);
+
+
+
+#if defined CONFIG_PMM_PLATFORM_HAS_OWN_INIT
+
+typedef int (*pmm_add_region_func)(size_t paddr, size_t size,
+                                   unsigned type, unsigned flags);
+
+/** Defined by platform, used by pmm_module_init(). */
+void pmm_module_platform_init(pmm_add_region_func add_region);
+
+#endif /* CONFIG_PMM_PLATFORM_HAS_OWN_INIT */
+
+
+#endif /* __KERNEL__ */
+
+#endif /* __KERNEL_PMM_H */
diff --git a/ipc/shm.c b/ipc/shm.c
index 05d51d2..6a7c68f 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -805,6 +805,10 @@ out:
  */
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 {
+#if defined CONFIG_PMM_SHM
+	extern const struct file_operations pmm_fops;
+#endif
+
 	struct shmid_kernel *shp;
 	unsigned long addr;
 	unsigned long size;
@@ -876,7 +880,14 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 	path.dentry = dget(shp->shm_file->f_path.dentry);
 	path.mnt    = shp->shm_file->f_path.mnt;
 	shp->shm_nattch++;
-	size = i_size_read(path.dentry->d_inode);
+
+#if defined CONFIG_PMM_SHM
+	if (shp->shm_file->f_op == &pmm_fops)
+		size = *(size_t *)shp->shm_file->private_data;
+	else
+#endif
+		size = i_size_read(path.dentry->d_inode);
+
 	shm_unlock(shp);
 
 	err = -ENOMEM;
@@ -963,6 +974,10 @@ SYSCALL_DEFINE3(shmat, int, shmid, char __user *, shmaddr, int, shmflg)
  */
 SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
 {
+#if defined CONFIG_PMM_SHM
+	extern const struct file_operations pmm_fops;
+#endif
+
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *next;
 	unsigned long addr = (unsigned long)shmaddr;
@@ -1009,7 +1024,13 @@ SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
 			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) {
 
 
-			size = vma->vm_file->f_path.dentry->d_inode->i_size;
+#if defined CONFIG_PMM_SHM
+			if (shm_file_data(vma->vm_file)->file->f_op ==
+			    &pmm_fops) {
+				size = *(size_t *)vma->vm_file->private_data;
+			} else
+#endif
+				size = vma->vm_file->f_path.dentry->d_inode->i_size;
 			do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 			/*
 			 * We discovered the size of the shm segment, so
diff --git a/mm/Kconfig b/mm/Kconfig
index a5b7781..b8dcff2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -216,3 +216,90 @@ config UNEVICTABLE_LRU
 
 config MMU_NOTIFIER
 	bool
+
+
+
+#
+# If platform defins it's own pmm_module_platform_init() function it
+# should select this option.  If it is set PMM won't compile it's own
+# implementation of this function.
+#
+# Moreover, if platform defines it's own init function it must create
+# a asm/pmm-plat.h header file as well with definitions of memory
+# types and such.  The simplest pmm-plat.h header file may be a copy
+# of a part of linux/pmm.h #if'ed with CONFIG_PMM_PLATFORM_HAS_OWN_INIT.
+#
+config PMM_PLATFORM_HAS_OWN_INIT
+	bool
+	default no
+
+#
+# To check if PMM is enabled.
+#
+config PMM_ENABLED
+	bool
+	default no
+
+
+config PMM_USE_OWN_INIT
+	bool
+	default no
+
+
+config PMM
+	tristate "Physical Memory Management"
+	default no
+	select PMM_ENABLED
+	select PMM_USE_OWN_INIT if ! PMM_PLATFORM_HAS_OWN_INIT
+	help
+	  This option enables support for Physical Memory Management
+	  driver.  It allows allocating continuous physical memory blocks
+	  from memory areas reserved during boot time.  Memory can be
+	  further divided into several types (like SDRAM or SRAM).
+
+	  Choosing M here will make PMM SysV IPC support unavailable.  If
+	  you are not sure, say N here.
+
+config PMM_DEVICE
+	bool "PMM user space device"
+	depends on PMM
+	default yes
+	help
+	  This options makes PMM register a "pmm" misc device throught
+	  which user space applications may allocate continuous memory
+	  blocks.
+
+config PMM_SHM
+	bool "PMM SysV IPC integration"
+	depends on PMM = y && PMM_DEVICE && SYSVIPC
+	default yes
+	help
+	  This options enables PMM to associate a PMM allocated area with
+	  a SysV shared memory ids.  This may be usefull for
+	  X applications which share memory throught a shared momey id
+	  (shmid).
+
+config PMM_DEBUG
+	bool "PMM Debug output (DEVELOPMENT)"
+	depends on PMM
+	default no
+	help
+	  This enables additional debug output from PMM module.  With this
+	  option PMM will printk whenever most of the functions are
+	  called.  This may be helpful when debugging, otherwise it
+	  provides no functionality.
+
+	  If you are not sure, say N here.
+
+config PMM_DEBUG_FS
+	bool "PMM debugfs interface (DEVELOPMENT)"
+	depends on PMM
+	default no
+	select DEBUG_FS
+	help
+	  This enables debugfs interface for PMM module.  The interface
+	  provides files with a list of allocated areas as well as free
+	  regions (holes).  This may be helpful when debugging, otherwise
+	  it provides little functionality.
+
+	  If you are not sure, say N here.
diff --git a/mm/Makefile b/mm/Makefile
index 72255be..0c5d5c4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -33,3 +33,5 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_PMM) += pmm.o
+obj-$(CONFIG_PMM_USE_OWN_INIT) += pmm-init.o
diff --git a/mm/pmm-init.c b/mm/pmm-init.c
new file mode 100644
index 0000000..f5abfb5
--- /dev/null
+++ b/mm/pmm-init.c
@@ -0,0 +1,56 @@
+/*
+ * Physical Memory Managment initialisation code
+ * Copyright (c) 2009 by Samsung Electronics.  All rights reserved.
+ * Written by Michal Nazarewicz (mina86@mina86.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ */
+
+
+#include <linux/kernel.h>      /* memparse() */
+#include <linux/module.h>      /* For EXPORT_SYMBOL */
+#include <linux/bootmem.h>     /* alloc_bootmem_low_pages() */
+#include <linux/ioport.h>      /* struct resource & friends */
+#include <linux/pmm.h>         /* For pmm_module_platform_init() prototype */
+
+
+struct resource pmm_mem_resource = {
+	0, 0, "Physical Memory Management", 0
+};
+EXPORT_SYMBOL(pmm_mem_resource);
+
+static int __init pmm_platform_init(char *str)
+{
+	unsigned long long size;
+	void *vaddr;
+	int ret;
+
+	size = memparse(str, 0);
+	if ((size & ~PAGE_MASK)) {
+		printk(KERN_CRIT "pmm: %llx: not page aligned\n", size);
+		return -EINVAL;
+	}
+
+	if (size > 1 << 30) {
+		printk(KERN_CRIT "pmm: %llx: more then 1GiB? Come on...\n",
+		       size);
+		return -EINVAL;
+	}
+
+	vaddr = alloc_bootmem_low_pages(size);
+	if (!vaddr) {
+		printk(KERN_ERR "pmm: alloc_bootmem_low_pages failed\n");
+		return -ENOMEM;
+	}
+
+	pmm_mem_resource.start = virt_to_phys(vaddr);
+	pmm_mem_resource.end   = pmm_mem_resource.start + size;
+	ret = request_resource(&iomem_resource, &pmm_mem_resource);
+	if (ret)
+		printk(KERN_ERR "pmm: request_resource failed: %d\n", ret);
+
+	return 0;
+}
+__setup("pmm=", pmm_platform_init);
diff --git a/mm/pmm.c b/mm/pmm.c
new file mode 100644
index 0000000..1611a5f
--- /dev/null
+++ b/mm/pmm.c
@@ -0,0 +1,1237 @@
+/*
+ * Physical Memory Managment
+ * Copyright (c) 2009 by Samsung Electronics.  All rights reserved.
+ * Written by Michal Nazarewicz (mina86@mina86.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ */
+
+#include <linux/errno.h>       /* Error numbers */
+#include <linux/file.h>        /* fput() */
+#include <linux/fs.h>          /* struct file */
+#include <linux/kref.h>        /* struct kref */
+#include <linux/mm.h>          /* Memory stuff */
+#include <linux/mman.h>
+#include <linux/module.h>      /* Standard module stuff */
+#include <linux/rbtree.h>      /* rb_node, rb_root & co */
+#include <linux/sched.h>       /* struct task_struct */
+#include <linux/types.h>       /* Just to be safe ;) */
+#include <linux/uaccess.h>     /* __copy_{to,from}_user */
+
+#if !defined CONFIG_PMM_PLATFORM_HAS_OWN_INIT
+#  include <linux/ioport.h>    /* struct resource & friends */
+#endif
+
+#if defined CONFIG_PMM_DEVICE
+#  include <linux/miscdevice.h>/* misc_register() and company */
+#  if defined CONFIG_PMM_SHM
+#    include <linux/file.h>    /* fput(), get_file() */
+#    include <linux/ipc_namespace.h>   /* ipc_namespace */
+#    include <linux/nsproxy.h> /* current->nsproxy */
+#    include <linux/security.h>/* security_shm_{alloc,free}() */
+#    include <linux/shm.h>     /* struct shmid_kernel */
+
+#    include "../ipc/util.h"   /* ipc_* */
+
+#    define shm_ids(ns)     ((ns)->ids[IPC_SHM_IDS])
+#    define shm_unlock(shp) ipc_unlock(&(shp)->shm_perm)
+#  endif
+#endif
+
+#if defined CONFIG_PMM_DEBUG_FS
+#  include <linux/debugfs.h>   /* Whole debugfs stuff */
+#endif
+
+#include <linux/pmm.h>         /* PMM's stuff */
+
+
+/* Check if PMM_MEMORY_TYPES has a valid value. */
+#if PMM_MEMORY_TYPES < 1 || PMM_MEMORY_TYPES > 32
+#  error PMM_MEMORY_TYPES < 1 || PMM_MEMORY_TYPES > 32
+#endif
+
+
+/* Debug messages. */
+#if defined CONFIG_PMM_DEBUG
+#  if defined DEBUG
+#    undef  DEBUG
+#  endif
+#  define DEBUG(fmt, ...) \
+	printk(KERN_INFO "pmm debug: " fmt "\n", ##__VA_ARGS__)
+#else
+#  define DEBUG(fmt, ...) do { } while (0)
+#endif
+
+
+
+/********************************************************************/
+/****************************** Global ******************************/
+/********************************************************************/
+
+
+/** PMM Item's flags.  See pmm_item structure. */
+enum {
+	PMM_HOLE         = 1 << 31,  /**< This item is a hole, not area */
+	PMM_ITEM_LAST    = 1 << 30   /**< The item is at the end of the region. */
+};
+
+
+
+/**
+ * A structure describing a single allocated area or a hole.
+ */
+struct pmm_item {
+	/* Keep size as the first element! Several functions assume it is
+	   there! */
+	size_t         size;           /**< Area's size. */
+	size_t         start;          /**< Starting address. */
+	unsigned       flags;          /**< Undocummented as of yet. */
+#if PMM_MEMORY_TYPES != 1
+	unsigned       type;           /**< Memory type. */
+#endif
+
+	/** Node in rb tree sorted by starting address. */
+	struct rb_node by_start;
+
+	union {
+		/**
+		 * Node in rb tree sorted by hole's size.  There is one tree
+		 * per memory type.  Meaningful only for holes.
+		 */
+		struct rb_node by_size_per_type;
+		/**
+		 * Number of struct file or devices that reffer to this area.
+		 */
+		struct kref          refcount;
+	};
+};
+
+#if PMM_MEMORY_TYPES == 1
+#  define PMM_TYPE(obj) 1
+#else
+#  define PMM_TYPE(obj) ((obj)->type)
+#endif
+
+
+
+/** Mutex used throught all the module. */
+static DEFINE_MUTEX(pmm_mutex);
+
+
+/** A per type rb tree of holes sorted by size. */
+static struct pmm_mem_type {
+	struct rb_root root;
+} pmm_mem_types[PMM_MEMORY_TYPES];
+
+
+/** A rb tree of holes and areas sorted by starting address. */
+static struct rb_root pmm_items = RB_ROOT;
+
+
+
+
+
+/****************************************************************************/
+/****************************** Core functions ******************************/
+/****************************************************************************/
+
+
+static        void __pmm_item_insert_by_size (struct pmm_item *item);
+static inline void __pmm_item_erase_by_size  (struct pmm_item *item);
+static        void __pmm_item_insert_by_start(struct pmm_item *item);
+static inline void __pmm_item_erase_by_start (struct pmm_item *item);
+
+
+
+/**
+ * Takes a \a size bytes large area from hole \a hole.  Takes \a
+ * alignment into consideration.  \a hole must be able to hold the
+ * area.
+ * @param  hole     hole to take area from
+ * @param  size     area's size
+ * @param  alignment area's starting address alignment (must be power of two)
+ * @return allocated area or NULL on error (if kmalloc() failed)
+ */
+static struct pmm_item *__pmm_hole_take(struct pmm_item *hole,
+                                        size_t size, size_t alignment);
+
+
+/**
+ * Tries to merge two holes.  Both arguments points to \c by_start
+ * fields of the holes.  If both are not NULL and the previous hole's
+ * end address is the same as next hole's start address then both
+ * holes are merged.  Previous hole is freed.  In any case, the hole
+ * that has a larger starting address is preserved (but possibly
+ * enlarged).
+ *
+ * @param  prev_node \c by_start \c rb_node of a previous hole
+ * @param  next_node \c by_start \c rb_node of a next hole
+ * @return hole with larger start address (possibli merged with
+ *         previous one).
+ */
+static void __pmm_hole_merge_maybe(struct rb_node *prev_node,
+                                   struct rb_node *next_node);
+
+
+/**
+ * Tries to allocate an area of given memory type.  \a node is a root
+ * of a by_size_per_type tree (as name points out each memory type has
+ * its own by_size tree).  The function implements best fit algorithm
+ * searching for the smallest hole where area can be allocated in.
+ *
+ * @param  node     by_size_per_type tree root
+ * @param  size     area's size
+ * @param  alignment area's starting address alignment (must be power of two)
+ */
+static struct pmm_item *__pmm_alloc(struct pmm_mem_type *mem_type,
+                                    size_t size, size_t alignment);
+
+
+/**
+ * Finds item by start address.
+ * @param  start start address.
+ * @param  msg   string to add to warning messages.
+ */
+static struct pmm_item *__pmm_find_area(size_t start, const char *msg);
+
+
+
+/****************************** Allocation ******************************/
+
+__must_check
+static struct pmm_item *pmm_alloc_internal(struct pmm_area_info *info)
+{
+	struct pmm_item *area = 0;
+	unsigned i = 0, mask = 1;
+
+	DEBUG("pmm_alloc(%8x, %d, %04x, %8x)",
+	      info->size, info->type, info->flags, info->alignment);
+
+	/* Verify */
+	if (!info->size || (info->alignment & (info->alignment - 1)))
+		return 0;
+
+	if (info->alignment < PAGE_SIZE)
+		info->alignment = PAGE_SIZE;
+
+	info->size = PAGE_ALIGN(info->size);
+
+
+	/* Find area */
+	info->type &= (1 << PMM_MEMORY_TYPES) - 1;
+	mutex_lock(&pmm_mutex);
+	do {
+		if (info->type & mask)
+			area = __pmm_alloc(pmm_mem_types + i,
+			                   info->size, info->alignment);
+		mask <<= 1;
+	} while (!area && mask < info->type);
+	mutex_unlock(&pmm_mutex);
+
+
+	/* Return result */
+	if (area) {
+		kref_init(&area->refcount);
+
+		info->magic     = PMM_MAGIC;
+		info->size      = area->size;
+		info->type      = PMM_TYPE(area);
+		info->flags     = area->flags;
+		info->alignment =
+			(area->start ^ (area->start - 1)) & area->start;
+	}
+	return area;
+}
+
+__must_check
+size_t pmm_alloc(struct pmm_area_info *info)
+{
+	struct pmm_item *area = pmm_alloc_internal(info);
+	return area ? area->start : 0;
+}
+EXPORT_SYMBOL(pmm_alloc);
+
+int    pmm_get(size_t paddr)
+{
+	struct pmm_item *area;
+	int ret = 0;
+
+	mutex_lock(&pmm_mutex);
+
+	area = __pmm_find_area(paddr, "pmm_get");
+	if (area)
+		kref_get(&area->refcount);
+	else
+		ret = -ENOENT;
+
+	mutex_unlock(&pmm_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(pmm_get);
+
+
+/****************************** Deallocation ******************************/
+
+static void __pmm_kref_release(struct kref *kref)
+{
+	struct pmm_item *area = container_of(kref, struct pmm_item, refcount);
+
+	mutex_lock(&pmm_mutex);
+
+	/* Convert area into hole */
+	area->flags |= PMM_HOLE;
+	__pmm_item_insert_by_size(area);
+	/* PMM_ITEM_LAST flag is preserved */
+
+	/* Merge with prev and next sibling */
+	__pmm_hole_merge_maybe(rb_prev(&area->by_start), &area->by_start);
+	__pmm_hole_merge_maybe(&area->by_start, rb_next(&area->by_start));
+
+	mutex_unlock(&pmm_mutex);
+}
+
+#if defined CONFIG_PMM_DEVICE
+
+static int  pmm_put_internal(struct pmm_item *area)
+{
+	if (area) {
+		if (area->flags & PMM_HOLE) {
+			printk(KERN_ERR "pmm: pmm_put_int: item at 0x%08x is a hole\n",
+			       area->start);
+			return -ENOENT;
+		}
+		kref_put(&area->refcount, __pmm_kref_release);
+	}
+	return 0;
+}
+
+#endif
+
+int    pmm_put(size_t paddr)
+{
+	if (paddr) {
+		struct pmm_item *area;
+		mutex_lock(&pmm_mutex);
+		area = __pmm_find_area(paddr, "pmm_put");
+		mutex_unlock(&pmm_mutex);
+
+		if (!area)
+			return -ENOENT;
+		kref_put(&area->refcount, __pmm_kref_release);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(pmm_put);
+
+
+
+
+
+/************************************************************************/
+/****************************** PMM device ******************************/
+/************************************************************************/
+
+#if defined CONFIG_PMM_DEVICE
+
+static int pmm_file_open(struct inode *inode, struct file *file);
+static int pmm_file_release(struct inode *inode, struct file *file);
+static int pmm_file_ioctl(struct inode *inode, struct file *file,
+                          unsigned cmd, unsigned long arg);
+static int pmm_file_mmap(struct file *file, struct vm_area_struct *vma);
+
+/* Cannot be static if CONFIG_PMM_SHM is on, ipc/shm.c uses it's address. */
+#if !defined CONFIG_PMM_SHM
+static
+#endif
+const struct file_operations pmm_fops = {
+	.owner   = THIS_MODULE,
+	.open    = pmm_file_open,
+	.release = pmm_file_release,
+	.ioctl   = pmm_file_ioctl,
+	.mmap    = pmm_file_mmap,
+};
+
+
+
+static int pmm_file_open(struct inode *inode, struct file *file)
+{
+	DEBUG("file_open(%p)", file);
+	file->private_data = 0;
+	return 0;
+}
+
+
+static int pmm_file_release(struct inode *inode, struct file *file)
+{
+	DEBUG("file_release(%p)", file);
+
+	if (file->private_data != 0)
+		pmm_put_internal(file->private_data);
+
+	return 0;
+}
+
+
+
+#if defined CONFIG_PMM_SHM
+
+/*
+ * Called from ipcneew() with shm_ids.rw_mutex held as a writer.  See
+ * newseg() in ipc/shm.c for some more info (this function is based on
+ * that one).
+ */
+struct file *shmem_pmm_file_setup(char *name, loff_t size);
+
+static int pmm_newseg(struct ipc_namespace *ns, struct ipc_params *params)
+{
+	key_t        key      = params->key;
+	struct file *pmm_file = (void *)params->u.size; /* XXX */
+	int          shmflg   = params->flg;
+
+	struct pmm_item *area = pmm_file->private_data;
+	const int numpages    = (area->size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	struct file *file;
+	struct shmid_kernel *shp;
+	char name[13];
+	int ret;
+
+	if (ns->shm_tot + numpages > ns->shm_ctlall)
+		return -ENOSPC;
+
+	shp = ipc_rcu_alloc(sizeof(*shp));
+	if (!shp)
+		return -ENOMEM;
+
+	shp->shm_perm.key  = key;
+	shp->shm_perm.mode = (shmflg & S_IRWXUGO);
+	shp->mlock_user    = NULL;
+
+	shp->shm_perm.security = NULL;
+	ret = security_shm_alloc(shp);
+	if (ret) {
+		ipc_rcu_putref(shp);
+		return ret;
+	}
+
+	sprintf(name, "SYSV%08x", key);
+	file = shmem_pmm_file_setup(name, area->size);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto no_file;
+	}
+
+	file->private_data     = area;
+	file->f_op             = &pmm_fops;
+	kref_get(&area->refcount);
+
+	/*
+	 * shmid gets reported as "inode#" in /proc/pid/maps.
+	 * proc-ps tools use this. Changing this will break them.
+	 */
+	file->f_dentry->d_inode->i_ino = shp->shm_perm.id;
+
+	ret = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
+	if (ret < 0)
+		goto no_id;
+
+	shp->shm_cprid  = task_tgid_vnr(current);
+	shp->shm_lprid  = 0;
+	shp->shm_atim   = shp->shm_dtim = 0;
+	shp->shm_ctim   = get_seconds();
+	shp->shm_segsz  = area->size;
+	shp->shm_nattch = 0;
+	shp->shm_file   = file;
+
+	ns->shm_tot += numpages;
+	ret = shp->shm_perm.id;
+	shm_unlock(shp);
+	return ret;
+
+no_id:
+	fput(file);
+no_file:
+	security_shm_free(shp);
+	ipc_rcu_putref(shp);
+	return ret;
+}
+
+#endif /* CONFIG_PMM_SHM */
+
+
+
+static int pmm_file_ioctl(struct inode *inode, struct file *file,
+                          unsigned cmd, unsigned long arg)
+{
+	DEBUG("file_ioctl(%p, cmd = %d, arg = %lu)", file, cmd, arg);
+
+	switch (cmd) {
+	case IOCTL_PMM_ALLOC: {
+		struct pmm_area_info info;
+		struct pmm_item     *area;
+		if (!arg)
+			return -EINVAL;
+		if (file->private_data)
+			return -EBADFD;
+		if (copy_from_user(&info, (void *)arg, sizeof info))
+			return -EFAULT;
+		if (info.magic != PMM_MAGIC)
+			return -ENOTTY;
+		area = pmm_alloc_internal(&info);
+		if (!area)
+			return -ENOMEM;
+		if (copy_to_user((void *)arg, &info, sizeof info)) {
+			pmm_put_internal(area);
+			return -EFAULT;
+		}
+		file->private_data = area;
+		return 0;
+	}
+
+	case IOCTL_PMM_SHMGET: {
+#if defined CONFIG_PMM_SHM
+		struct pmm_shm_info  info;
+		struct ipc_namespace *ns;
+		struct ipc_params shm_params;
+		struct ipc_ops shm_ops;
+
+		if (!arg)
+			return -EINVAL;
+		if (!file->private_data)
+			return -EBADFD;
+		if (copy_from_user(&info, (void *)arg, sizeof info))
+			return -EFAULT;
+		if (info.magic != PMM_MAGIC)
+			return -ENOTTY;
+
+		ns = current->nsproxy->ipc_ns;
+
+		shm_params.key    = info.key;
+		shm_params.flg    = info.shmflg | IPC_CREAT | IPC_EXCL;
+		shm_params.u.size = (size_t)file; /* XXX */
+
+		shm_ops.getnew      = pmm_newseg;
+		/* We can set those two to NULL since thanks to IPC_CREAT |
+		   IPC_EXCL flags util.c never reffer to those functions. */
+		shm_ops.associate   = 0;
+		shm_ops.more_checks = 0;
+
+		return ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
+#else
+		return -ENOSYS;
+#endif
+	}
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+
+
+#if defined CONFIG_PMM_SHM
+/* We add a dummy vm_operations_struct with a dummy fault handler as
+   some kernel code may check if fault is set and treate situantion
+   when it isn't as a bug (that's the case in ipc/shm.c for instance).
+   This code should be safe as the area is physical and fault shall
+   never happen (the pages are always in memory). */
+static int  pmm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	(void)vma; (void)vmf;
+	return -EFAULT;
+}
+
+static const struct vm_operations_struct pmm_vm_ops = {
+	.fault	= pmm_vm_fault,
+};
+#endif
+
+
+static int pmm_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int ret = -EBADFD;
+	DEBUG("pmm_file_mmap(%p, %p)", (void *)file, (void *)vma);
+	if (file->private_data) {
+		const size_t pgoff  = vma->vm_pgoff;
+		const size_t offset = pgoff << PAGE_SHIFT;
+		const size_t length = vma->vm_end - vma->vm_start;
+		struct pmm_item *const area = file->private_data;
+
+		if (offset >= area->size || length > area->size ||
+		    offset + length > area->size)
+			return -ENOSPC;
+
+		printk(KERN_INFO
+		       "start = %zu, off = %zu, pfn = %zu, len = %zu\n",
+		       area->start, offset, area->start >> PAGE_SHIFT + pgoff,
+		       length);
+		ret = remap_pfn_range(vma, vma->vm_start,
+		                      area->start >> PAGE_SHIFT + pgoff,
+		                      length, vma->vm_page_prot);
+		if (ret < 0)
+			return ret;
+
+#if defined CONFIG_PMM_SHM
+		vma->vm_ops = &pmm_vm_ops;
+
+		/*
+		 * From mm/memory.c:
+		 *
+		 *     There's a horrible special case to handle
+		 *     copy-on-write behaviour that some programs
+		 *     depend on. We mark the "original" un-COW'ed
+		 *     pages by matching them up with "vma->vm_pgoff".
+		 *
+		 * Unfortunatelly, this brakes shmdt() when PMM area
+		 * is converted into System V IPC.  As those pages
+		 * won't be COW pages we revert changes made by
+		 * remap_pfn_range() to vma->vm_pgoff.
+		 */
+		vma->vm_pgoff = pgoff;
+#endif
+	}
+	return ret;
+}
+
+
+#endif /* CONFIG_PMM_DEVICE */
+
+
+
+
+
+/**********************************************************************/
+/****************************** Debug FS ******************************/
+/**********************************************************************/
+
+#if defined CONFIG_PMM_DEBUG_FS
+
+static struct dentry *pmm_debugfs_dir;
+
+
+static int     pmm_debugfs_items_open (struct inode *, struct file *);
+static int     pmm_debugfs_holes_per_type_open
+                                      (struct inode *, struct file *);
+static int     pmm_debugfs_release    (struct inode *, struct file *);
+static ssize_t pmm_debugfs_read       (struct file *, char __user *,
+                                       size_t, loff_t *);
+static loff_t  pmm_debugfs_llseek     (struct file *, loff_t, int);
+
+
+static const struct {
+	const struct file_operations items;
+	const struct file_operations holes_per_type;
+} pmm_debugfs_fops = {
+	.items = {
+		.owner   = THIS_MODULE,
+		.open    = pmm_debugfs_items_open,
+		.release = pmm_debugfs_release,
+		.read    = pmm_debugfs_read,
+		.llseek  = pmm_debugfs_llseek,
+	},
+	.holes_per_type = {
+		.owner   = THIS_MODULE,
+		.open    = pmm_debugfs_holes_per_type_open,
+		.release = pmm_debugfs_release,
+		.read    = pmm_debugfs_read,
+		.llseek  = pmm_debugfs_llseek,
+	},
+};
+
+
+struct pmm_debugfs_buffer {
+	size_t size;
+	size_t capacity;
+	char buffer[];
+};
+
+static struct pmm_debugfs_buffer *
+pmm_debugfs_buf_cat(struct pmm_debugfs_buffer *buf,
+                    void *data, size_t size);
+
+
+
+
+static void pmm_debugfs_init(void)
+{
+	static const u8 pmm_memory_types = PMM_MEMORY_TYPES;
+	static char pmm_debugfs_names[PMM_MEMORY_TYPES][4];
+
+	struct dentry *dir;
+	unsigned i;
+
+	if (pmm_debugfs_dir)
+		return;
+
+	dir = pmm_debugfs_dir = debugfs_create_dir("pmm", 0);
+	if (!dir || dir == ERR_PTR(-ENODEV)) {
+		pmm_debugfs_dir = 0;
+		return;
+	}
+
+	debugfs_create_file("items", 0440, dir, 0, &pmm_debugfs_fops.items);
+
+	dir = debugfs_create_dir("types", dir);
+	if (!dir)
+		return;
+
+	debugfs_create_u8("count", 0440, dir, (u8*)&pmm_memory_types);
+	for (i = 0; i < PMM_MEMORY_TYPES; ++i) {
+		sprintf(pmm_debugfs_names[i], "%u", i);
+		debugfs_create_file(pmm_debugfs_names[i], 0440, dir,
+		                    pmm_mem_types + i,
+		                    &pmm_debugfs_fops.holes_per_type);
+	}
+}
+
+
+static void pmm_debugfs_done(void)
+{
+	if (pmm_debugfs_dir) {
+		debugfs_remove_recursive(pmm_debugfs_dir);
+		pmm_debugfs_dir = 0;
+	}
+}
+
+
+static int     pmm_debugfs__open      (struct inode *i, struct file *f,
+                                       struct rb_root *root, int by_start)
+{
+	struct pmm_debugfs_buffer *buf = 0;
+	struct rb_node *node;
+	int ret = 0;
+
+	mutex_lock(&pmm_mutex);
+
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		size_t size = 128;
+		char tmp[128];
+
+		struct pmm_item *item;
+		item = by_start
+			? rb_entry(node, struct pmm_item, by_start)
+			: rb_entry(node, struct pmm_item, by_size_per_type);
+		size = sprintf(tmp, "%c %08x %08x [%08x] fl %08x tp %08x\n",
+		               item->flags & PMM_HOLE ? 'f' : 'a',
+		               item->start, item->start + item->size,
+		               item->size, item->flags, PMM_TYPE(item));
+
+		buf = pmm_debugfs_buf_cat(buf, tmp, size);
+		if (!buf) {
+			ret = -ENOMEM;
+			break;
+		}
+	}
+
+	f->private_data = buf;
+
+	mutex_unlock(&pmm_mutex);
+	return ret;
+
+}
+
+
+static int     pmm_debugfs_items_open (struct inode *i, struct file *f)
+{
+	return pmm_debugfs__open(i, f, &pmm_items, 1);
+}
+
+static int     pmm_debugfs_holes_per_type_open
+                                      (struct inode *i, struct file *f)
+{
+	return pmm_debugfs__open(i, f, i->i_private, 0);
+}
+
+
+
+static int     pmm_debugfs_release    (struct inode *i, struct file *f)
+{
+	kfree(f->private_data);
+	return 0;
+}
+
+
+static ssize_t pmm_debugfs_read       (struct file *f, char __user *user_buf,
+                                       size_t size, loff_t *offp)
+{
+	const struct pmm_debugfs_buffer *const buf = f->private_data;
+	const loff_t off = *offp;
+
+	if (!buf || off >= buf->size)
+		return 0;
+
+	if (size >= buf->size - off)
+		size = buf->size - off;
+
+	size -= copy_to_user(user_buf, buf->buffer + off, size);
+	*offp += off + size;
+
+	return size;
+}
+
+
+static loff_t  pmm_debugfs_llseek     (struct file *f, loff_t offset,
+                                       int whence)
+{
+	switch (whence) {
+	case SEEK_END:
+		offset += ((struct pmm_debugfs_buffer *)f->private_data)->size;
+		break;
+	case SEEK_CUR:
+		offset += f->f_pos;
+		break;
+	}
+
+	return offset >= 0 ? f->f_pos = offset : -EINVAL;
+}
+
+
+
+
+static struct pmm_debugfs_buffer *
+pmm_debugfs_buf_cat(struct pmm_debugfs_buffer *buf,
+                    void *data, size_t size)
+{
+	/* Allocate more memory; buf may be NULL */
+	if (!buf || buf->size + size > buf->capacity) {
+		const size_t tmp = (buf ? buf->size : 0) + size + sizeof *buf;
+		size_t s = (buf ? buf->capacity + sizeof *buf : 128);
+		struct pmm_debugfs_buffer *b;
+
+		while (s < tmp)
+			s <<= 1;
+
+		b = krealloc(buf, s, GFP_KERNEL);
+		if (!b) {
+			kfree(buf);
+			return 0;
+		}
+
+		if (!buf)
+			b->size = 0;
+
+		buf = b;
+		buf->capacity = s - sizeof *buf;
+	}
+
+	memcpy(buf->buffer + buf->size, data, size);
+	buf->size += size;
+
+	return buf;
+}
+
+
+#endif /* CONFIG_PMM_DEBUG_FS */
+
+
+
+
+
+/****************************************************************************/
+/****************************** Initialisation ******************************/
+/****************************************************************************/
+
+#if defined CONFIG_PMM_DEVICE
+static struct miscdevice pmm_miscdev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name  = "pmm",
+	.fops  = &pmm_fops
+};
+
+static int pmm_miscdev_registered;
+#endif
+
+static const char banner[] __initdata =
+	KERN_INFO "PMM Driver, (c) 2009 Samsung Electronics\n";
+
+
+
+static int  __init pmm_add_region(size_t paddr, size_t size,
+                                  unsigned type, unsigned flags)
+{
+	/* Create hole */
+	struct pmm_item     *hole;
+
+	if (!type || (type & (type - 1)) ||
+	    type > (1 << (PMM_MEMORY_TYPES - 1))) {
+		printk(KERN_ERR "pmm: invalid memory type: %u\n", type);
+		return -EINVAL;
+	}
+
+	hole = kmalloc(sizeof *hole, GFP_KERNEL);
+	if (!hole) {
+		printk(KERN_ERR "pmm: not enough memory to add region\n");
+		return -ENOMEM;
+	}
+
+	DEBUG("pmm_add_region(%8x, %8x, %d, %04x)", paddr, size, type, flags);
+
+	hole->start = paddr;
+	hole->size  = size;
+	hole->flags = flags | PMM_ITEM_LAST | PMM_HOLE;
+#if PMM_MEMORY_TYPES != 1
+	hole->type  = type;
+#endif
+
+	mutex_lock(&pmm_mutex);
+
+	__pmm_item_insert_by_size (hole);
+	__pmm_item_insert_by_start(hole);
+
+	mutex_unlock(&pmm_mutex);
+
+	return 0;
+}
+
+
+static int __init pmm_module_init(void)
+{
+#if !defined CONFIG_PMM_PLATFORM_HAS_OWN_INIT
+	/* Not nice having extern here but no use cluttering header files. */
+	extern struct resource pmm_mem_resource;
+#endif
+
+#if defined CONFIG_PMM_DEVICE
+	int ret;
+#endif
+
+
+	printk(banner);
+	DEBUG("pmm: loading");
+
+
+#if defined CONFIG_PMM_PLATFORM_HAS_OWN_INIT
+	ret = pmm_module_platform_init(pmm_add_region);
+#else
+	if (pmm_mem_resource.start)
+		pmm_add_region(pmm_mem_resource.start,
+		               pmm_mem_resource.end - pmm_mem_resource.start,
+		               PMM_MEM_GENERAL, 0);
+	else
+		return -ENOMEM;
+#endif
+
+
+#if defined CONFIG_PMM_DEVICE
+	/* Register misc device */
+	ret = misc_register(&pmm_miscdev);
+	if (ret)
+		/*
+		 * Even if we don't register the misc device we can continue
+		 * providing kernel level API, so we don't return here with
+		 * error.
+		 */
+		printk(KERN_WARNING
+		       "pmm: could not register misc device (ret = %d)\n",
+		       ret);
+	else
+		pmm_miscdev_registered = 1;
+#endif
+
+
+#if defined CONFIG_PMM_DEBUG_FS
+	pmm_debugfs_init();
+#endif
+
+
+	DEBUG("pmm: loaded");
+	return 0;
+}
+module_init(pmm_module_init);
+
+
+static void __exit pmm_module_exit(void)
+{
+#if defined CONFIG_PMM_DEVICE
+	if (pmm_miscdev_registered)
+		misc_deregister(&pmm_miscdev);
+#endif
+
+#if defined CONFIG_PMM_DEBUG_FS
+	pmm_debugfs_done();
+#endif
+
+	printk(KERN_INFO "PMM driver module exit\n");
+}
+module_exit(pmm_module_exit);
+
+
+MODULE_AUTHOR("Michal Nazarewicz");
+MODULE_LICENSE("GPL");
+
+
+
+
+
+/***************************************************************************/
+/************************* Internal core functions *************************/
+/***************************************************************************/
+
+static        void __pmm_item_insert_by_size (struct pmm_item *item)
+{
+	struct rb_node **link, *parent = 0;
+	const size_t size = item->size;
+	unsigned n = 0;
+
+#if PMM_MEMORY_TYPES != 1
+	unsigned type = item->type;
+	while (n < PMM_MEMORY_TYPES && (type >>= 1))
+		++n;
+#endif
+
+	/* Figure out where to put new node */
+	for (link = &pmm_mem_types[n].root.rb_node; *link; ) {
+		struct pmm_item *h;
+		parent = *link;
+		h = rb_entry(parent, struct pmm_item, by_size_per_type);
+		link = size <= h->size ? &parent->rb_left : &parent->rb_right;
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&item->by_size_per_type, parent, link);
+	rb_insert_color(&item->by_size_per_type, &pmm_mem_types[n].root);
+}
+
+
+static inline void __pmm_item_erase_by_size  (struct pmm_item *item)
+{
+	unsigned n = 0;
+#if PMM_MEMORY_TYPES != 1
+	unsigned type = item->type;
+	while (n < PMM_MEMORY_TYPES && (type >>= 1))
+		++n;
+#endif
+	rb_erase(&item->by_size_per_type, &pmm_mem_types[n].root);
+}
+
+
+static        void __pmm_item_insert_by_start(struct pmm_item *item)
+{
+	struct rb_node **link, *parent = 0;
+	const size_t start = item->start;
+
+	/* Figure out where to put new node */
+	for (link = &pmm_items.rb_node; *link; ) {
+		struct pmm_item *h;
+		parent = *link;
+		h = rb_entry(parent, struct pmm_item, by_start);
+		link = start <= h->start ? &parent->rb_left : &parent->rb_right;
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&item->by_start, parent, link);
+	rb_insert_color(&item->by_start, &pmm_items);
+}
+
+
+static inline void __pmm_item_erase_by_start (struct pmm_item *item)
+{
+	rb_erase(&item->by_start, &pmm_items);
+}
+
+
+static struct pmm_item *__pmm_hole_take(struct pmm_item *hole,
+                                        size_t size, size_t alignment)
+{
+	struct pmm_item *area;
+
+	/* There are three cases:
+	   1. the area takes the whole hole,
+	   2. the area is at the begining or at the end of the hole, or
+	   3. the area is in the middle of the hole. */
+
+
+	/* Case 1 */
+	if (size == hole->size) {
+		/* Convert hole into area */
+		__pmm_item_erase_by_size(hole);
+		hole->flags &= ~PMM_HOLE;
+		/* A PMM_ITEM_LAST flag is set if we are spliting last hole */
+		return hole;
+	}
+
+
+	/* Allocate */
+	area = kmalloc(sizeof *area, GFP_KERNEL);
+	if (!area)
+		return 0;
+
+	area->start = ALIGN(hole->start, alignment);
+	area->size  = size;
+#if PMM_MEMORY_TYPES != 1
+	area->type  = hole->type;
+#endif
+	/* A PMM_ITEM_LAST flag is set if we are spliting last hole */
+	area->flags = hole->flags & ~PMM_HOLE;
+
+
+	/* If there is to be space before the area or this is a last item
+	   in given region try allocating area at the end.  As a side
+	   effect, first allocation will be usually from the end but we
+	   don't care. ;) */
+	if ((area->start != hole->start || (hole->flags & PMM_ITEM_LAST))
+	    && area->start + area->size != hole->start + hole->size) {
+		size_t left = hole->start + hole->size -
+			area->start - area->size;
+		if (left % alignment == 0)
+			area->start += left;
+	}
+
+
+	/* Case 2 */
+	if (area->start == hole->start ||
+	    area->start + area->size == hole->start + hole->size) {
+		/* Alter hole's size */
+		hole->size -= size;
+		__pmm_item_erase_by_size (hole);
+		__pmm_item_insert_by_size(hole);
+
+		/* Alter hole's start; it does not require updating the tree */
+		if (area->start == hole->start) {
+			hole->start += area->size;
+			area->flags &= ~PMM_ITEM_LAST;
+		} else
+			hole->flags &= ~PMM_ITEM_LAST;
+
+	/* Case 3 */
+	} else {
+		struct pmm_item *next = kmalloc(sizeof *next, GFP_KERNEL);
+		size_t hole_end = hole->start + hole->size;
+
+		if (!next) {
+			kfree(area);
+			return 0;
+		}
+
+		/* Alter hole's size */
+		hole->size = area->start - hole->start;
+		hole->flags &= ~PMM_ITEM_LAST;
+		__pmm_item_erase_by_size(hole);
+		__pmm_item_insert_by_size(hole);
+
+		/* Add next hole */
+		next->start = area->start + area->size;
+		next->size  = hole_end - next->start;
+#if PMM_MEMORY_TYPES != 1
+		next->type  = hole->type;
+#endif
+		next->flags = hole->flags;
+		__pmm_item_insert_by_size (next);
+		__pmm_item_insert_by_start(next);
+
+		/* Since there is a hole after this area it (the area) is not
+		   last so clear the flag. */
+		area->flags &= ~PMM_ITEM_LAST;
+	}
+
+
+	/* Add area to the tree */
+	__pmm_item_insert_by_start(area);
+	return area;
+}
+
+
+static void __pmm_hole_merge_maybe(struct rb_node *prev_node,
+                                   struct rb_node *next_node)
+{
+	if (next_node && prev_node) {
+		struct pmm_item *prev, *next;
+		prev = rb_entry(prev_node, struct pmm_item, by_start);
+		next = rb_entry(next_node, struct pmm_item, by_start);
+
+		if ((prev->flags & next->flags & PMM_HOLE) &&
+		    prev->start + prev->size == next->start) {
+			/* Remove previous hole from trees */
+			__pmm_item_erase_by_size (prev);
+			__pmm_item_erase_by_start(prev);
+
+			/* Alter next hole */
+			next->size += prev->size;
+			next->start = prev->start;
+			__pmm_item_erase_by_size (next);
+			__pmm_item_insert_by_size(next);
+			/* No need to update by start tree */
+
+			/* Free prev hole */
+			kfree(prev);
+
+			/* Since we are deleting previous hole adding it to the
+			   next the PMM_ITEM_LAST flag is preserved. */
+		}
+	}
+}
+
+
+static struct pmm_item *__pmm_alloc(struct pmm_mem_type *mem_type,
+                                    size_t size, size_t alignment)
+{
+	struct rb_node *node = mem_type->root.rb_node;
+	struct pmm_item *hole = 0;
+
+	/* Find a smallest hole >= size */
+	while (node) {
+		struct pmm_item *const h =
+			rb_entry(node, struct pmm_item, by_size_per_type);
+		if (h->size < size)
+			node = node->rb_left;  /* Go to larger holes. */
+		else {
+			hole = h;              /* This hole is ok ... */
+			node = node->rb_right; /* ... but try smaller */
+		}
+	}
+
+	/* Iterate over holes and find first which fits */
+	while (hole) {
+		const size_t start = ALIGN(hole->start, alignment);
+		if (start >=  hole->start &&    /* just in case of overflows */
+		    start < hole->start + hole->size &&
+		    start + size <= hole->start + hole->size)
+			break;
+		hole = (node = rb_next(&hole->by_size_per_type))
+			? rb_entry(node, struct pmm_item, by_size_per_type)
+			: 0;
+	}
+
+	/* Return */
+	return hole ? __pmm_hole_take(hole, size, alignment) : 0;
+}
+
+
+static struct pmm_item *__pmm_find_area(size_t paddr, const char *msg)
+{
+	struct rb_node  *node = pmm_items.rb_node;
+	struct pmm_item *area;
+
+	/* NULL */
+	if (!paddr)
+		return 0;
+
+	/* Find the area */
+	while (node) {
+		area = rb_entry(node, struct pmm_item, by_start);
+		if (paddr < area->start)
+			node = node->rb_left;
+		else if (paddr > area->start)
+			node = node->rb_right;
+		else
+			break;
+	}
+
+	/* Not found? */
+	if (!node) {
+		printk(KERN_ERR "pmm: %s: area at 0x%08x does not exist\n",
+		       msg, paddr);
+		return 0;
+	}
+
+	/* Not an area but a hole */
+	if (area->flags & PMM_HOLE) {
+		printk(KERN_ERR "pmm: %s: item at 0x%08x is a hole\n",
+		       msg, paddr);
+		return 0;
+	}
+
+	/* Return */
+	return area;
+}
diff --git a/mm/shmem.c b/mm/shmem.c
index 4103a23..8041150 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2587,13 +2587,8 @@ int shmem_unuse(swp_entry_t entry, struct page *page)
 
 /* common code */
 
-/**
- * shmem_file_setup - get an unlinked file living in tmpfs
- * @name: name for dentry (to be seen in /proc/<pid>/maps
- * @size: size to be set for the file
- * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
- */
-struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
+static struct file *__shmem_file_setup(char *name, loff_t size,
+                                       unsigned long flags, int pmm_area)
 {
 	int error;
 	struct file *file;
@@ -2604,11 +2599,13 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 	if (IS_ERR(shm_mnt))
 		return (void *)shm_mnt;
 
-	if (size < 0 || size > SHMEM_MAX_BYTES)
-		return ERR_PTR(-EINVAL);
+	if (!pmm_area) {
+		if (size < 0 || size > SHMEM_MAX_BYTES)
+			return ERR_PTR(-EINVAL);
 
-	if (shmem_acct_size(flags, size))
-		return ERR_PTR(-ENOMEM);
+		if (shmem_acct_size(flags, size))
+			return ERR_PTR(-ENOMEM);
+	}
 
 	error = -ENOMEM;
 	this.name = name;
@@ -2636,9 +2633,11 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 		  &shmem_file_operations);
 
 #ifndef CONFIG_MMU
-	error = ramfs_nommu_expand_for_mapping(inode, size);
-	if (error)
-		goto close_file;
+	if (!pmm_area) {
+		error = ramfs_nommu_expand_for_mapping(inode, size);
+		if (error)
+			goto close_file;
+	}
 #endif
 	return file;
 
@@ -2647,11 +2646,37 @@ close_file:
 put_dentry:
 	dput(dentry);
 put_memory:
-	shmem_unacct_size(flags, size);
+	if (!pmm_area)
+		shmem_unacct_size(flags, size);
 	return ERR_PTR(error);
 }
+
+/**
+ * shmem_file_setup - get an unlinked file living in tmpfs
+ * @name: name for dentry (to be seen in /proc/<pid>/maps
+ * @size: size to be set for the file
+ * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
+ */
+struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
+{
+	return __shmem_file_setup(name, size, flags, 0);
+}
 EXPORT_SYMBOL_GPL(shmem_file_setup);
 
+
+#if defined CONFIG_PMM_SHM
+
+/*
+ * PMM uses this function when converting a PMM area into a System
+ * V shared memory.
+ */
+struct file *shmem_pmm_file_setup(char *name, loff_t size)
+{
+	return __shmem_file_setup(name, size, 0, 1);
+}
+
+#endif
+
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
  * @vma: the vma to be mmapped is prepared by do_mmap_pgoff

