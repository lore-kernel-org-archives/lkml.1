Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0CJKvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:51:22 -0500
Received: from mx2.compro.net ([12.186.155.4]:19024 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab0CJKvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:51:19 -0500
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 05:51:19 EST
X-IronPort-AV: E=Sophos;i="4.49,613,1262581200"; 
   d="scan'208";a="5055033"
Message-ID: <962a29981078ad4ba63b82b4d1bba4a7.squirrel@mail.compro.net>
In-Reply-To: <2234BBB33B4B2048B28E3B3ACFC9795C01A6792D@CNBEEXC007.nsn-intra.net>
References: <20100308155252Z.fujita.tomonori@lab.ntt.co.jp>
    <2234BBB33B4B2048B28E3B3ACFC9795C01A6792D@CNBEEXC007.nsn-intra.net>
Date: Wed, 10 Mar 2010 05:37:12 -0500
Subject: Re: Failed to alloc 4M DMA memory in the 256M system
From: "Mark Hounschell" <markh@compro.net>
To: "Zhu, Yijun (NSN - CN/Beijing)" <yijun.zhu@nsn.com>
Cc: linux-kernel@vger.kernel.org
Reply-To: markh@compro.net
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100310053710_53241"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20100310053710_53241
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Zhu, Yijun (NSN - CN/Beijing) wrote:
>
> Hi All:
>
> I try to alloc 4M memory for the DMA purpose in the 256M system running
> V2.6.29. But failed.
>
> I check the system, there is no 4M DMA memory in the DMA zone free list
> indeed, So I'd like to
> ask for that Is it possible for me to alloc 4M(or larger) DMA memory in
> the linux system.
> if YES, HOW?
>
> I forgot to say my hardware is based on X86.
>
> Thank you in advance.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

There is still a bigphysarea patch around that works for me. (attached)  I
know of no other way using the hardware I need to do it with. IE, no
scatter/gather capabilities so memory must be contiguous. I personally
haven't used it with more than 2M but it should work.

Regards
Mark
------=_20100310053710_53241
Content-Type: text/x-patch; name="bigphysarea-2.6.32.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="bigphysarea-2.6.32.patch"

diff -urN linux-2.6.32-rc8-lcrs-orig/arch/x86/Kconfig linux-2.6.32-rc8-lcrs/arch/x86/Kconfig
--- linux-2.6.32-rc8-lcrs-orig/arch/x86/Kconfig	2009-11-19 17:32:38.000000000 -0500
+++ linux-2.6.32-rc8-lcrs/arch/x86/Kconfig	2009-11-24 05:15:51.000000000 -0500
@@ -1814,6 +1814,15 @@
 
 endmenu
 
+config BIGPHYS_AREA
+        bool "Support for big physical area reservation"
+	depends on X86_32
+        ---help---
+          Enables kernel support for reserving large areas of physical memory
+          at boot-time for use by certain device drivers (such as video
+          framegrabbers, etc.) which require it. To use this feature, boot
+          the kernel with the boot-time option 'bigphysarea=nnn' where
+          'nnn' is the number of pages (a page is usually 4K) to reserve.
 
 menu "Bus options (PCI etc.)"
 
diff -urN linux-2.6.32-rc8-lcrs-orig/Documentation/bigphysarea.txt linux-2.6.32-rc8-lcrs/Documentation/bigphysarea.txt
--- linux-2.6.32-rc8-lcrs-orig/Documentation/bigphysarea.txt	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.32-rc8-lcrs/Documentation/bigphysarea.txt	2009-11-24 05:15:51.000000000 -0500
@@ -0,0 +1,62 @@
+Bigphysarea
+===========
+
+This set of functions give you the ability to allocate big
+continuous (DMAable) memory for the entire runtime of Linux.
+Big meaning here more than 128KB, the maximum allocation
+limit of kmalloc(). Due to fragmentation reasons kmalloc()
+is unable to garantee allocs of this order during a prolonged
+run of the kernel. This new pool of memory blob can be used
+during the initialization or use of soundcards of framegrabbers
+which are designed without DMA scatter-gatter capabilities.
+
+Enjoy
+
+
+How to start
+============
+First add bigphysarea=<number of pages to alloc> to the
+commandline of your kernel. Either do this by adding an
+append= line to your /etc/lilo/conf setup or use some
+magic marker...
+After booting the new kernel there should be a /proc/bigphysarea
+file telling your how many blocks/bytes are available.
+
+The interface description
+=========================
+The big physical area is mainly managed by two functions. The first one,
+
+caddr_t bigphysarea_alloc_pages(int count, int align, int priority)
+
+allocates 'count' pages. The pages are aligned so that there base
+address is a multiple of 'PAGE_SIZE * align'. If you don't need more
+than page alignment, set 'align' to 0 or 1. 'priority' has the same
+meaning as in kmalloc, it can be GFP_ATOMIC (for calls from interrupt
+handlers) or GFP_KERNEL (for usual calls). The base address of the
+allocated area is returned.
+
+Allocation can fail for two reasons, in both cases NULL is
+returned. First, the physical area is scattered too much or there is
+not enough memory, second it is not possible to allocate some memory
+with kmalloc for administration of the physical area (very unlikely).
+
+To free an allocated area, just call
+
+void bigphysarea_free_pages(caddr_t base)
+
+with 'base' set to the value returned by 'bigphysarea_alloc_pages'. 
+
+An example how to use this functions can be found in 'module.c'.
+
+There is still the old interface introduced by M. Welsh:
+
+caddr_t bigphysarea_alloc(int size)
+void bigphysarea_free(caddr_t addr, int size)
+
+The first function allocates 'size' bytes physically continous
+memory. To free the area, bigphysarea_free with a pointer to the area
+and its size has to be called. Due to a new allocation algorithm, the
+size parameter is no longer really needed when freeing an area.
+
+In the current version it is not safe to call any of the functions
+from an interrupt handler.
diff -urN linux-2.6.32-rc8-lcrs-orig/include/linux/bigphysarea.h linux-2.6.32-rc8-lcrs/include/linux/bigphysarea.h
--- linux-2.6.32-rc8-lcrs-orig/include/linux/bigphysarea.h	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.32-rc8-lcrs/include/linux/bigphysarea.h	2009-11-24 05:15:51.000000000 -0500
@@ -0,0 +1,29 @@
+/* linux/mm/bigphysarea.h, M. Welsh (mdw@cs.cornell.edu)
+ * Copyright (c) 1996 by Matt Welsh.
+ * Extended by Roger Butenuth (butenuth@uni-paderborn.de), October 1997
+ * Extended for linux-2.1.121 till 2.4.0 (June 2000)
+ *     by Pauline Middelink <middelink@polyware.nl>
+ *
+ * This is a set of routines which allow you to reserve a large (?)
+ * amount of physical memory at boot-time, which can be allocated/deallocated
+ * by drivers. This memory is intended to be used for devices such as
+ * video framegrabbers which need a lot of physical RAM (above the amount
+ * allocated by kmalloc). This is by no means efficient or recommended;
+ * to be used only in extreme circumstances.
+ *
+ */
+
+#ifndef __LINUX_BIGPHYSAREA_H
+#define __LINUX_BIGPHYSAREA_H
+
+#include <linux/types.h>
+
+/* original interface */
+extern caddr_t	bigphysarea_alloc(int size);
+extern void	bigphysarea_free(caddr_t addr, int size);
+
+/* new interface */
+extern caddr_t	bigphysarea_alloc_pages(int count, int align, int priority);
+extern void	bigphysarea_free_pages(caddr_t base);
+
+#endif // __LINUX_BIGPHYSAREA_H
diff -urN linux-2.6.32-rc8-lcrs-orig/kernel/kallsyms.c linux-2.6.32-rc8-lcrs/kernel/kallsyms.c
--- linux-2.6.32-rc8-lcrs-orig/kernel/kallsyms.c	2009-11-19 17:32:38.000000000 -0500
+++ linux-2.6.32-rc8-lcrs/kernel/kallsyms.c	2009-11-24 05:15:51.000000000 -0500
@@ -20,6 +20,9 @@
 #include <linux/proc_fs.h>
 #include <linux/sched.h>	/* for cond_resched */
 #include <linux/mm.h>
+#ifdef CONFIG_BIGPHYS_AREA
+#include <linux/bigphysarea.h>
+#endif
 #include <linux/ctype.h>
 
 #include <asm/sections.h>
@@ -364,6 +367,13 @@
 	return len;
 }
 EXPORT_SYMBOL_GPL(sprint_symbol);
+#ifdef CONFIG_BIGPHYS_AREA
+EXPORT_SYMBOL(bigphysarea_alloc);
+EXPORT_SYMBOL(bigphysarea_free);
+EXPORT_SYMBOL(bigphysarea_alloc_pages);
+EXPORT_SYMBOL(bigphysarea_free_pages);
+#endif
+
 
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
diff -urN linux-2.6.32-rc8-lcrs-orig/mm/bigphysarea.c linux-2.6.32-rc8-lcrs/mm/bigphysarea.c
--- linux-2.6.32-rc8-lcrs-orig/mm/bigphysarea.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.32-rc8-lcrs/mm/bigphysarea.c	2009-11-24 05:15:51.000000000 -0500
@@ -0,0 +1,373 @@
+/* linux/mm/bigphysarea.c, M. Welsh (mdw@cs.cornell.edu)
+ * Copyright (c) 1996 by Matt Welsh.
+ * Extended by Roger Butenuth (butenuth@uni-paderborn.de), October 1997
+ * Extended for linux-2.1.121 till 2.4.0 (June 2000)
+ *     by Pauline Middelink <middelink@polyware.nl>
+ * Extended and adapted for linux-2.6.x 
+ *     by J. Joe Feise <jfeise@feise.com>
+ *
+ * This is a set of routines which allow you to reserve a large (?) 
+ * amount of physical memory at boot-time, which can be allocated/deallocated
+ * by drivers. This memory is intended to be used for devices such as 
+ * video framegrabbers which need a lot of physical RAM (above the amount
+ * allocated by kmalloc). This is by no means efficient or recommended;
+ * to be used only in extreme circumstances.
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ * 
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/autoconf.h>
+#include <linux/ptrace.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/proc_fs.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/bigphysarea.h>
+
+static int read_proc(char *page, char **start, off_t off,
+		int count, int *eof, void *data);
+
+typedef struct range_struct {
+	struct range_struct *next;
+	caddr_t base;			/* base of allocated block */
+	size_t  size;			/* size in bytes */
+} range_t;
+
+/*
+ * 0: nothing initialized
+ * 1: bigphysarea_pages initialized
+ * 2: free list initialized
+ */
+static int	init_level = 0;
+static int	bigphysarea_pages = 0;
+static caddr_t	bigphysarea = 0;
+static range_t	*free_list = NULL;
+static range_t	*used_list = NULL;
+static struct resource mem_resource = { "Bigphysarea", 0, 0, IORESOURCE_MEM|IORESOURCE_BUSY };
+
+static
+int __init bigphysarea_init(void)
+{
+        struct proc_dir_entry *res;
+
+	if (bigphysarea_pages == 0 || bigphysarea == 0)
+		return -EINVAL;
+
+	/* create /proc entry for it */
+        res = create_proc_entry("bigphysarea", 0444, NULL);
+        if (!res) {
+		/* ohoh, no way to free the allocated memory!
+		 * continue without proc support, it is not fatal in itself
+		 */
+/*		free_bootmem((unsigned long)bigphysarea>>PAGE_SHIFT,bigphysarea_pages<<PAGE_SHIFT);
+		bigphysarea = 0;
+		return -ENOMEM;
+*/
+	}
+	else
+		res->read_proc = read_proc;
+
+	init_level = 1;
+
+	printk(KERN_INFO "bigphysarea: Allocated %d pages at 0x%p.\n",
+	       bigphysarea_pages, bigphysarea);
+
+	return 0;
+}
+
+__initcall(bigphysarea_init);
+
+/*
+ * call when 'bigphysarea=' is given on the commandline.
+ *
+ * Strangely, bootmem is still active during this call, but
+ * during the processing of the initcalls it isn't anymore!
+ * So we alloc the needed memory here instead of bigphysarea_init().
+ */
+static
+int __init bigphysarea_setup(char *str)
+{
+	int par;
+	if (get_option(&str,&par)) {
+		bigphysarea_pages = par;
+		// Alloc the memory
+		bigphysarea = alloc_bootmem_low_pages(bigphysarea_pages<<PAGE_SHIFT);
+		if (!bigphysarea) {
+			printk(KERN_CRIT "bigphysarea: not enough memory for %d pages\n",bigphysarea_pages);
+			return -ENOMEM;
+		}
+
+		// register the resource for it
+		mem_resource.start = (unsigned long)virt_to_phys(bigphysarea);
+		mem_resource.end = mem_resource.start + (bigphysarea_pages<<PAGE_SHIFT);
+		request_resource(&iomem_resource, &mem_resource);
+	}
+	return 1;
+}
+
+__setup("bigphysarea=", bigphysarea_setup);
+
+/*
+ * When we have pages but don't have a freelist, put all pages in
+ * one free list entry. Return 0 on success, 1 on error.
+ */
+static
+int init2(int priority)
+{
+	if (init_level == 1) {
+		free_list = kmalloc(sizeof(range_t), priority);
+		if (free_list != NULL) {
+			free_list->next = NULL;
+			free_list->base = bigphysarea;
+			free_list->size = bigphysarea_pages * PAGE_SIZE;
+			init_level = 2;
+			return 0;
+		}
+	}
+	return 1;
+}
+
+
+/*
+ * Allocate `count' pages from the big physical area. Pages are aligned to
+ * a multiple of `align'. `priority' has the same meaning in kmalloc, it
+ * is needed for management information.
+ * This function may not be called from an interrupt!
+ */
+caddr_t bigphysarea_alloc_pages(int count, int align, int priority)
+{
+	range_t *range, **range_ptr, *new_range, *align_range;
+	caddr_t aligned_base=0;
+
+	if (init_level < 2)
+		if (init2(priority))
+			return 0;
+	new_range   = NULL;
+	align_range = NULL;
+
+	if (align == 0)
+		align = PAGE_SIZE;
+	else
+		align = align * PAGE_SIZE;
+	/*
+	 * Search a free block which is large enough, even with alignment.
+	 */
+	range_ptr = &free_list;
+	while (*range_ptr != NULL) {
+		range = *range_ptr;
+		aligned_base =
+		  (caddr_t)((((unsigned long)range->base + align - 1) / align) * align);
+		if (aligned_base + count * PAGE_SIZE <= 
+		    range->base + range->size)
+			break;
+	     range_ptr = &range->next;
+	}
+	if (*range_ptr == NULL)
+		return 0;
+	range = *range_ptr;
+	/*
+	 * When we have to align, the pages needed for alignment can
+	 * be put back to the free pool.
+	 * We check here if we need a second range data structure later
+	 * and allocate it now, so that we don't have to check for a
+	 * failed kmalloc later.
+	 */
+	if (aligned_base - range->base + count * PAGE_SIZE < range->size) {
+		new_range = kmalloc(sizeof(range_t), priority);
+		if (new_range == NULL)
+			return NULL;
+	}
+	if (aligned_base != range->base) {
+		align_range = kmalloc(sizeof(range_t), priority);
+		if (align_range == NULL) {
+			if (new_range != NULL)
+				kfree(new_range);
+			return NULL;
+		}
+		align_range->base = range->base;
+		align_range->size = aligned_base - range->base;
+		range->base = aligned_base;
+		range->size -= align_range->size;
+		align_range->next = range;
+		*range_ptr = align_range;
+		range_ptr = &align_range->next;
+	}
+	if (new_range != NULL) {
+		/*
+		 * Range is larger than needed, create a new list element for
+		 * the used list and shrink the element in the free list.
+		 */
+		new_range->base        = range->base;
+		new_range->size        = count * PAGE_SIZE;
+		range->base = new_range->base + new_range->size;
+		range->size = range->size - new_range->size;
+	} else {
+		/*
+		 * Range fits perfectly, remove it from free list.
+		 */
+		*range_ptr = range->next;
+		new_range = range;
+	}
+	/*
+	 * Insert block into used list
+	 */
+	new_range->next = used_list;
+	used_list = new_range;
+
+	return new_range->base;
+}
+
+/*
+ * Free pages allocated with `bigphysarea_alloc_pages'. `base' must be an
+ * address returned by `bigphysarea_alloc_pages'.
+ * This function my not be called from an interrupt!
+ */
+void bigphysarea_free_pages(caddr_t base)
+{
+	range_t *prev, *next, *range, **range_ptr;
+  
+	/*
+	 * Search the block in the used list.
+	 */
+	for (range_ptr = &used_list;
+	     *range_ptr != NULL;
+	     range_ptr = &(*range_ptr)->next)
+		if ((*range_ptr)->base == base)
+			break;
+	if (*range_ptr == NULL) {
+		printk("bigphysarea_free_pages(0x%08x), not allocated!\n",
+		       (unsigned)base);
+		return;
+	}
+	range = *range_ptr;
+	/*
+	 * Remove range from the used list:
+	 */
+	*range_ptr = (*range_ptr)->next;
+	/*
+	 * The free-list is sorted by address, search insertion point
+	 * and insert block in free list.
+	 */
+	for (range_ptr = &free_list, prev = NULL;
+	     *range_ptr != NULL;
+	     prev = *range_ptr, range_ptr = &(*range_ptr)->next)
+		if ((*range_ptr)->base >= base)
+			break;
+	range->next  = *range_ptr;
+	*range_ptr   = range;
+	/*
+	 * Concatenate free range with neighbors, if possible.
+	 * Try for upper neighbor (next in list) first, then
+	 * for lower neighbor (predecessor in list).
+	 */
+	if (range->next != NULL &&
+	    range->base + range->size == range->next->base) {
+		next = range->next;
+		range->size += range->next->size;
+		range->next = next->next;
+		kfree(next);
+	}
+	if (prev != NULL &&
+	    prev->base + prev->size == range->base) {
+		prev->size += prev->next->size;
+		prev->next = range->next;
+		kfree(range);
+	}
+}
+
+caddr_t bigphysarea_alloc(int size)
+{
+	int pages = (size + PAGE_SIZE - 1) / PAGE_SIZE;
+
+	return bigphysarea_alloc_pages(pages, 1, GFP_KERNEL);
+}
+
+void bigphysarea_free(caddr_t addr, int size)
+{
+	(void)size;
+	bigphysarea_free_pages(addr);
+}
+
+static int proc_calc_metrics(char *page, char **start, off_t off,
+                                 int count, int *eof, int len)
+{
+        if (len <= off+count)
+		*eof = 1;
+        *start = page + off;
+        len -= off;
+        if (len>count)
+		len = count;
+        if (len<0)
+		len = 0;
+        return len;
+}
+
+static
+int read_proc(char *page, char **start, off_t off,
+		int count, int *eof, void *data)
+{
+	int     len;
+	range_t *ptr;
+	int     free_count, free_total, free_max;
+	int     used_count, used_total, used_max;
+
+	if (init_level == 1)
+	  init2(GFP_KERNEL);
+
+	free_count = 0;
+	free_total = 0;
+	free_max   = 0;
+	for (ptr = free_list; ptr != NULL; ptr = ptr->next) {
+		free_count++;
+		free_total += ptr->size;
+		if (ptr->size > free_max)
+			free_max = ptr->size;
+	}
+
+	used_count = 0;
+	used_total = 0;
+	used_max   = 0;
+	for (ptr = used_list; ptr != NULL; ptr = ptr->next) {
+		used_count++;
+		used_total += ptr->size;
+		if (ptr->size > used_max)
+			used_max = ptr->size;
+	}
+
+	if (bigphysarea_pages == 0) {
+		len = sprintf(page, "No big physical area allocated!\n");
+	}
+	else {
+		len = sprintf(page,
+			"Big physical area, size %ld kB\n"
+			"                       free list:             used list:\n"
+			"number of blocks:      %8d               %8d\n"
+			"size of largest block: %8d kB            %8d kB\n"
+			"total:                 %8d kB            %8d kB\n",
+		     bigphysarea_pages * PAGE_SIZE / 1024,
+		     free_count, used_count,
+		     free_max / 1024, used_max / 1024,
+		     free_total / 1024, used_total /1024);
+	}
+	return  proc_calc_metrics(page, start, off, count, eof, len);
+}
+
diff -urN linux-2.6.32-rc8-lcrs-orig/mm/Makefile linux-2.6.32-rc8-lcrs/mm/Makefile
--- linux-2.6.32-rc8-lcrs-orig/mm/Makefile	2009-11-19 17:32:38.000000000 -0500
+++ linux-2.6.32-rc8-lcrs/mm/Makefile	2009-11-24 05:15:51.000000000 -0500
@@ -45,3 +45,4 @@
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+obj-$(CONFIG_BIGPHYS_AREA) += bigphysarea.o
------=_20100310053710_53241--


