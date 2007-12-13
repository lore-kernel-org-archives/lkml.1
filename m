Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXLMX7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXLMX7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934166AbXLMX6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:58:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:60218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764708AbXLMX6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:58:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="237491366"
Message-Id: <20071213235712.584411000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:50 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 07/12] PAT 64b: dev mem chanegs for pat
Content-Disposition: inline; filename=devmem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward port of devmem.patch to x86 tree. With added bug fix of doing
cpa only with non zero flags.

TBD:

1. Handle RAM pages with UC/WC and /dev/mem mapping conflicts. This
conflict with RAM mapped as UC (identity mapping) and /dev/mem mapping
is already there in current mainline kernel.

2. For fork(), for every /dev/mem mapping, we have to keep track
of the usage by doing reserve_mattr().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc4/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/mm/pat.c	2007-12-11 15:39:28.000000000 -0800
+++ linux-2.6.24-rc4/arch/x86/mm/pat.c	2007-12-11 15:59:29.000000000 -0800
@@ -3,11 +3,14 @@
 #include <linux/kernel.h>
 #include <linux/rbtree.h>
 #include <linux/gfp.h>
+#include <linux/fs.h>
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
 #include <asm/processor.h>
 #include <asm/pgtable.h>
 #include <asm/pat.h>
+#include <asm/cacheflush.h>
+#include <asm/fcntl.h>
 
 static u64 boot_pat_state;
 
@@ -57,6 +60,16 @@
 	}
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
@@ -105,9 +118,10 @@
 			}
 			if (attr != ml->attr) {
 				printk(
-	KERN_ERR "%s:%d conflicting cache attribute %Lx-%Lx %lx<->%lx\n",
+	KERN_ERR "%s:%d conflicting cache attribute %Lx-%Lx %s<->%s\n",
 					current->comm, current->pid,
-					start, end, attr, ml->attr);
+					start, end,
+					cattr_name(attr), cattr_name(ml->attr));
 				err = -EBUSY;
 				break;
 			}
@@ -134,19 +148,60 @@
 		if (ml->start == start && ml->end == end) {
 			if (ml->attr != attr)
 				printk(KERN_ERR
-	"%s:%d conflicting cache attributes on free %Lx-%Lx %lx<->%lx\n",
-			current->comm, current->pid, start, end, attr,ml->attr);
+	"%s:%d conflicting cache attributes on free %Lx-%Lx %s<->%s\n",
+			current->comm, current->pid, start, end,
+			cattr_name(attr), cattr_name(ml->attr));
 			list_del(&ml->nd);
 			kfree(ml);
 			err = 0;
 			break;
 		}
 	}
 	spin_unlock(&mattr_lock);
 	if (err)
-		printk(KERN_ERR "%s:%d freeing invalid mattr %Lx-%Lx %lx\n",
+		printk(KERN_ERR "%s:%d freeing invalid mattr %Lx-%Lx %s\n",
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
+	if ((file->f_flags & O_SYNC) || (offset >= __pa(high_memory)))
+		want_flags = _PAGE_PCD;
+
+	/* ignore error because we can't handle it here */
+	reserve_mattr(offset, offset+size, want_flags, &flags);
+	if (flags != want_flags) {
+		printk(KERN_INFO
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
+		change_page_attr_addr(offset, size >> PAGE_SHIFT,
+				     __pgprot(__PAGE_KERNEL | flags));
+	}
+	return __pgprot((pgprot_val(vma_prot) & ~_PAGE_CACHE_MASK)|flags);
+}
+
+void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
+{
+	u64 addr = (u64)pfn << PAGE_SHIFT;
+	free_mattr(addr, size, 0);
+	if (addr < __pa(high_memory) &&
+	   (pgprot_val(vma_prot) & _PAGE_CACHE_MASK))
+		change_page_attr_addr(addr, size >> PAGE_SHIFT, PAGE_KERNEL);
+}
Index: linux-2.6.24-rc4/drivers/char/mem.c
===================================================================
--- linux-2.6.24-rc4.orig/drivers/char/mem.c	2007-12-11 14:24:56.000000000 -0800
+++ linux-2.6.24-rc4/drivers/char/mem.c	2007-12-11 15:59:29.000000000 -0800
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
@@ -271,6 +242,22 @@
 }
 #endif
 
+void __attribute__((weak))
+unmap_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
+{
+	/* nothing. architectures can override. */
+}
+
+static void mmap_mem_close(struct vm_area_struct *vma)
+{
+	unmap_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
+		     vma->vm_page_prot);
+}
+
+static struct vm_operations_struct mmap_mem_ops = {
+	.close = mmap_mem_close
+};
+
 static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 {
 	size_t size = vma->vm_end - vma->vm_start;
@@ -285,6 +272,8 @@
 						 size,
 						 vma->vm_page_prot);
 
+	vma->vm_ops = &mmap_mem_ops;
+
 	/* Remap-pfn-range will mark the range VM_IO and VM_RESERVED */
 	if (remap_pfn_range(vma,
 			    vma->vm_start,
Index: linux-2.6.24-rc4/include/asm-x86/pgtable_64.h
===================================================================
--- linux-2.6.24-rc4.orig/include/asm-x86/pgtable_64.h	2007-12-11 15:08:12.000000000 -0800
+++ linux-2.6.24-rc4/include/asm-x86/pgtable_64.h	2007-12-11 15:59:29.000000000 -0800
@@ -452,6 +452,12 @@
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
 #include <asm-generic/pgtable.h>
+
+#define __HAVE_PHYS_MEM_ACCESS_PROT
+struct file;
+pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+                              unsigned long size, pgprot_t vma_prot);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _X86_64_PGTABLE_H */

-- 
