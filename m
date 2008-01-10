Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbYAJS4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbYAJS4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYAJSzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:55:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:4583 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642AbYAJSzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:55:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="320739384"
Message-Id: <20080110184856.611784000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:50 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 10/11] PAT x86: Handle /dev/mem mappings
Content-Disposition: inline; filename=devmem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward port of devmem.patch to x86 tree. With added bug fix of doing
cpa only with non zero flags.


Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Index: linux-2.6.git/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/pat.c	2008-01-08 12:45:05.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/pat.c	2008-01-08 12:51:02.000000000 -0800
@@ -2,12 +2,15 @@
 #include <linux/mm.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
+#include <linux/fs.h>
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/pat.h>
 #include <asm/e820.h>
+#include <asm/cacheflush.h>
+#include <asm/fcntl.h>
 
 static u64 boot_pat_state;
 int pat_wc_enabled = 0;
@@ -71,6 +74,16 @@
 {
 }
 
+static char *cattr_name(unsigned long flags)
+{
+	switch (flags & _PAGE_CACHE_MASK) {
+	case _PAGE_WC:  return "write combining";
+	case _PAGE_PCD: return "uncached";
+	case 0: 	return "default";
+	default: 	return "broken";
+	}
+}
+
 /* The global memattr list keeps track of caching attributes for specific
    physical memory areas. Conflicting caching attributes in different
    mappings can cause CPU cache corruption. To avoid this we keep track.
@@ -108,7 +121,7 @@
 		if (!is_memory_all_valid(start, end) && !fattr)
 			return -EINVAL;
 
-		if (attr & _PAGE_WC) {
+		if (attr == _PAGE_WC) {
 			if (!fattr)
 				return -EINVAL;
 			else
@@ -133,9 +146,10 @@
 
 			if (!fattr && attr != ml->attr) {
 				printk(
-	KERN_DEBUG "%s:%d conflicting cache attribute %Lx-%Lx %lx<->%lx\n",
+	KERN_DEBUG "%s:%d conflicting cache attribute %Lx-%Lx %s<->%s\n",
 					current->comm, current->pid,
-					start, end, attr, ml->attr);
+					start, end,
+					cattr_name(attr), cattr_name(ml->attr));
 				err = -EBUSY;
 				break;
 			}
@@ -168,8 +182,9 @@
 		if (ml->start == start && ml->end == end) {
 			if (ml->attr != attr)
 				printk(KERN_DEBUG
-	"%s:%d conflicting cache attributes on free %Lx-%Lx %lx<->%lx\n",
-			current->comm, current->pid, start, end, attr,ml->attr);
+	"%s:%d conflicting cache attributes on free %Lx-%Lx %s<->%s\n",
+			current->comm, current->pid, start, end,
+			cattr_name(attr), cattr_name(ml->attr));
 			list_del(&ml->nd);
 			kfree(ml);
 			err = 0;
@@ -178,9 +193,89 @@
 	}
 	spin_unlock(&mattr_lock);
 	if (err)
-		printk(KERN_DEBUG "%s:%d freeing invalid mattr %Lx-%Lx %lx\n",
+		printk(KERN_DEBUG "%s:%d freeing invalid mattr %Lx-%Lx %s\n",
 			current->comm, current->pid,
-			start, end, attr);
+			start, end, cattr_name(attr));
 	return err;
 }
 
+/* /dev/mem interface. Use the previous mapping */
+pgprot_t
+phys_mem_access_prot(struct file *file, unsigned long pfn, unsigned long size,
+		     pgprot_t vma_prot)
+{
+	u64 offset = pfn << PAGE_SHIFT;
+	unsigned long flags;
+	unsigned long want_flags = 0;
+	if (file->f_flags & O_SYNC)
+		want_flags = _PAGE_PCD;
+
+#ifdef CONFIG_X86_32
+	/*
+	 * On the PPro and successors, the MTRRs are used to set
+ 	 * memory types for physical addresses outside main memory,
+	 * so blindly setting PCD or PWT on those pages is wrong.
+	 * For Pentiums and earlier, the surround logic should disable
+	 * caching for the high addresses through the KEN pin, but
+	 * we maintain the tradition of paranoia in this code.
+	 */
+	if (!pat_wc_enabled &&
+	    ! ( test_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_K6_MTRR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability)) &&
+	   offset >= __pa(high_memory))
+		want_flags = _PAGE_PCD;
+#endif
+
+	/* ignore error because we can't handle it here */
+	reserve_mattr(offset, offset+size, want_flags, &flags);
+	if (flags != want_flags) {
+		printk(KERN_DEBUG
+	"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
+			current->comm, current->pid,
+			cattr_name(want_flags),
+			offset, offset+size,
+			cattr_name(flags));
+	}
+
+	if (offset < __pa(high_memory) && flags) {
+		/* RED-PEN when the kernel memory was write protected
+		   or similar before we'll destroy that here. need a pgprot
+		   mask in cpa? */
+		change_page_attr_addr((unsigned long)__va(offset),
+		                      size >> PAGE_SHIFT,
+		                      __pgprot(__PAGE_KERNEL | flags));
+	}
+	return __pgprot((pgprot_val(vma_prot) & ~_PAGE_CACHE_MASK)|flags);
+}
+
+void map_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
+{
+	u64 addr = (u64)pfn << PAGE_SHIFT;
+	unsigned long flags;
+	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+
+	reserve_mattr(addr, addr+size, want_flags, &flags);
+	if (flags != want_flags) {
+		printk(KERN_DEBUG
+	"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
+			current->comm, current->pid,
+			cattr_name(want_flags),
+			addr, addr+size,
+			cattr_name(flags));
+	}
+}
+
+void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
+{
+	u64 addr = (u64)pfn << PAGE_SHIFT;
+	unsigned long flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+
+	free_mattr(addr, addr+size, flags);
+	if (addr < __pa(high_memory) &&
+	   (pgprot_val(vma_prot) & _PAGE_CACHE_MASK))
+		change_page_attr_addr((unsigned long)__va(addr),
+		                      size >> PAGE_SHIFT,
+		                      PAGE_KERNEL);
+}
Index: linux-2.6.git/drivers/char/mem.c
===================================================================
--- linux-2.6.git.orig/drivers/char/mem.c	2008-01-08 12:40:52.000000000 -0800
+++ linux-2.6.git/drivers/char/mem.c	2008-01-08 12:47:47.000000000 -0800
@@ -41,36 +41,7 @@
  */
 static inline int uncached_access(struct file *file, unsigned long addr)
 {
-#if defined(__i386__) && !defined(__arch_um__)
-	/*
-	 * On the PPro and successors, the MTRRs are used to set
-	 * memory types for physical addresses outside main memory,
-	 * so blindly setting PCD or PWT on those pages is wrong.
-	 * For Pentiums and earlier, the surround logic should disable
-	 * caching for the high addresses through the KEN pin, but
-	 * we maintain the tradition of paranoia in this code.
-	 */
-	if (file->f_flags & O_SYNC)
-		return 1;
- 	return !( test_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability) ||
-		  test_bit(X86_FEATURE_K6_MTRR, boot_cpu_data.x86_capability) ||
-		  test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
-		  test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability) )
-	  && addr >= __pa(high_memory);
-#elif defined(__x86_64__) && !defined(__arch_um__)
-	/* 
-	 * This is broken because it can generate memory type aliases,
-	 * which can cause cache corruptions
-	 * But it is only available for root and we have to be bug-to-bug
-	 * compatible with i386.
-	 */
-	if (file->f_flags & O_SYNC)
-		return 1;
-	/* same behaviour as i386. PAT always set to cached and MTRRs control the
-	   caching behaviour. 
-	   Hopefully a full PAT implementation will fix that soon. */	   
-	return 0;
-#elif defined(CONFIG_IA64)
+#if defined(CONFIG_IA64)
 	/*
 	 * On ia64, we ignore O_SYNC because we cannot tolerate memory attribute aliases.
 	 */
@@ -271,6 +242,35 @@
 }
 #endif
 
+void __attribute__((weak))
+map_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
+{
+	/* nothing. architectures can override. */
+}
+
+void __attribute__((weak))
+unmap_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
+{
+	/* nothing. architectures can override. */
+}
+
+static void mmap_mem_open(struct vm_area_struct *vma)
+{
+	map_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
+		   vma->vm_page_prot);
+}
+
+static void mmap_mem_close(struct vm_area_struct *vma)
+{
+	unmap_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
+		     vma->vm_page_prot);
+}
+
+static struct vm_operations_struct mmap_mem_ops = {
+	.open  = mmap_mem_open,
+	.close = mmap_mem_close
+};
+
 static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -285,6 +285,8 @@
 						 size,
 						 vma->vm_page_prot);
 
+	vma->vm_ops = &mmap_mem_ops;
+
 	/* Remap-pfn-range will mark the range VM_IO and VM_RESERVED */
 	if (remap_pfn_range(vma,
 			    vma->vm_start,
Index: linux-2.6.git/include/asm-x86/pgtable.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/pgtable.h	2008-01-08 12:40:52.000000000 -0800
+++ linux-2.6.git/include/asm-x86/pgtable.h	2008-01-08 12:47:47.000000000 -0800
@@ -1,5 +1,17 @@
+#ifndef _ASM_X86_PGTABLE_H
+#define _ASM_X86_PGTABLE_H
+
 #ifdef CONFIG_X86_32
 # include "pgtable_32.h"
 #else
 # include "pgtable_64.h"
 #endif
+
+#ifndef __ASSEMBLY__
+#define __HAVE_PHYS_MEM_ACCESS_PROT
+struct file;
+pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+			      unsigned long size, pgprot_t vma_prot);
+#endif
+
+#endif
Index: linux-2.6.git/include/asm-x86/io.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/io.h	2008-01-08 12:45:17.000000000 -0800
+++ linux-2.6.git/include/asm-x86/io.h	2008-01-08 12:47:47.000000000 -0800
@@ -11,4 +11,9 @@
 
 extern void __iomem * ioremap_wc(unsigned long offset, unsigned long size);
 
+#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
+
+extern int valid_phys_addr_range(unsigned long addr, size_t count);
+extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
+
 #endif
Index: linux-2.6.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap.c	2008-01-08 12:45:17.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap.c	2008-01-08 12:47:47.000000000 -0800
@@ -1,5 +1,7 @@
 #include <linux/module.h>
+#include <linux/mm.h>
 
+#include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -29,3 +31,18 @@
 		return ioremap_nocache(phys_addr, size);
 }
 EXPORT_SYMBOL(ioremap_wc);
+
+int valid_phys_addr_range(unsigned long addr, size_t count)
+{
+	if (addr + count > __pa(high_memory))
+		return 0;
+
+	return 1;
+}
+
+int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
+{
+	u64 address = pfn << PAGE_SHIFT;
+	return (is_memory_all_valid(address, address + size) ||
+		!is_memory_any_valid(address, address + size));
+}

-- 
