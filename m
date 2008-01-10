Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYAJStq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYAJStq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758417AbYAJStX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:49:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:23280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988AbYAJStS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:49:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="283324601"
Message-Id: <20080110184855.906407000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:47 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 07/11] PAT x86: pat-conflict resolution using linear list
Content-Disposition: inline; filename=pat-conflict.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward port of pat-conflict.patch to x86 tree. Use a linear
list to keep track of all reserved region mappings.
Only UC access is allowed for RAM regions for now.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Index: linux-2.6.git/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_64.c	2008-01-08 12:43:13.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_64.c	2008-01-08 12:44:20.000000000 -0800
@@ -20,6 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/proto.h>
 #include <asm/e820.h>
+#include <asm/pat.h>
 
 unsigned long __phys_addr(unsigned long x)
 {
@@ -105,12 +106,23 @@
 		remove_vm_area((void *)(PAGE_MASK & (unsigned long) addr));
 		return NULL;
 	}
+
+	/* For plain ioremap() get the existing attributes. Otherwise
+	   check against the existing ones */
+	if (reserve_mattr(phys_addr, phys_addr + size, flags,
+			  flags ? NULL : &flags) < 0)
+		goto out;
+
 	if (flags && ioremap_change_attr(phys_addr, size, flags) < 0) {
-		area->flags &= 0xffffff;
-		vunmap(addr);
-		return NULL;
+		free_mattr(phys_addr, phys_addr + size, flags);
+		goto out;
 	}
 	return (__force void __iomem *) (offset + (char *)addr);
+
+out:
+	area->flags &= 0xffffff;
+	vunmap(addr);
+	return NULL;
 }
 EXPORT_SYMBOL(__ioremap);
 
@@ -178,8 +190,11 @@
 	}
 
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20)
-		ioremap_change_attr(p->phys_addr, p->size, 0);
+	if (p->flags >> 20) {
+		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
+		           p->flags>>20);
+		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
+	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
Index: linux-2.6.git/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/pat.c	2008-01-08 12:43:13.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/pat.c	2008-01-08 12:45:05.000000000 -0800
@@ -5,6 +5,9 @@
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
 #include <asm/processor.h>
+#include <asm/pgtable.h>
+#include <asm/pat.h>
+#include <asm/e820.h>
 
 static u64 boot_pat_state;
 int pat_wc_enabled = 0;
@@ -68,3 +71,116 @@
 {
 }
 
+/* The global memattr list keeps track of caching attributes for specific
+   physical memory areas. Conflicting caching attributes in different
+   mappings can cause CPU cache corruption. To avoid this we keep track.
+
+   The list is sorted and can contain multiple entries for each address
+   (this allows reference counting for overlapping areas). All the aliases
+   have the same cache attributes of course.  Zero attributes are represente
+   as holes.
+
+   Currently the data structure is a list because the number of mappings
+   are right now expected to be relatively small. If this should be a problem
+   it could be changed to a rbtree or similar.
+
+   mattr_lock protects the whole list. */
+
+struct memattr {
+	u64 start;
+	u64 end;
+	unsigned long attr;
+	struct list_head nd;
+};
+
+static LIST_HEAD(mattr_list);
+static DEFINE_SPINLOCK(mattr_lock); 	/* protects memattr list */
+
+int reserve_mattr(u64 start, u64 end, unsigned long attr, unsigned long *fattr)
+{
+	struct memattr *ma = NULL, *ml;
+	int err = 0;
+
+	if (fattr)
+		*fattr = attr;
+
+	if (is_memory_any_valid(start, end)) {
+		if (!is_memory_all_valid(start, end) && !fattr)
+			return -EINVAL;
+
+		if (attr & _PAGE_WC) {
+			if (!fattr)
+				return -EINVAL;
+			else
+				*fattr  = _PAGE_PCD;
+		}
+
+		return 0;
+	}
+
+	ma  = kmalloc(sizeof(struct memattr), GFP_KERNEL);
+	if (!ma)
+		return -ENOMEM;
+	ma->start = start;
+	ma->end = end;
+	ma->attr = attr;
+
+	spin_lock(&mattr_lock);
+	list_for_each_entry(ml, &mattr_list, nd) {
+		if (ml->start <= start && ml->end >= end) {
+			if (fattr)
+				ma->attr = *fattr = ml->attr;
+
+			if (!fattr && attr != ml->attr) {
+				printk(
+	KERN_DEBUG "%s:%d conflicting cache attribute %Lx-%Lx %lx<->%lx\n",
+					current->comm, current->pid,
+					start, end, attr, ml->attr);
+				err = -EBUSY;
+				break;
+			}
+		} else if (ml->start >= end) {
+			list_add(&ma->nd, ml->nd.prev);
+			ma = NULL;
+			break;
+		}
+	}
+
+	if (err)
+		kfree(ma);
+	else if (ma)
+		list_add_tail(&ma->nd, &mattr_list);
+
+	spin_unlock(&mattr_lock);
+	return err;
+}
+
+int free_mattr(u64 start, u64 end, unsigned long attr)
+{
+	struct memattr *ml;
+	int err = attr ? -EBUSY : 0;
+
+	if (is_memory_any_valid(start, end))
+		return 0;
+
+	spin_lock(&mattr_lock);
+	list_for_each_entry(ml, &mattr_list, nd) {
+		if (ml->start == start && ml->end == end) {
+			if (ml->attr != attr)
+				printk(KERN_DEBUG
+	"%s:%d conflicting cache attributes on free %Lx-%Lx %lx<->%lx\n",
+			current->comm, current->pid, start, end, attr,ml->attr);
+			list_del(&ml->nd);
+			kfree(ml);
+			err = 0;
+			break;
+		}
+	}
+	spin_unlock(&mattr_lock);
+	if (err)
+		printk(KERN_DEBUG "%s:%d freeing invalid mattr %Lx-%Lx %lx\n",
+			current->comm, current->pid,
+			start, end, attr);
+	return err;
+}
+
Index: linux-2.6.git/include/asm-x86/pat.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/include/asm-x86/pat.h	2008-01-08 12:44:20.000000000 -0800
@@ -0,0 +1,12 @@
+#ifndef _ASM_PAT_H
+#define _ASM_PAT_H 1
+
+#include <linux/types.h>
+
+/* Handle the page attribute table (PAT) of the CPU */
+
+int reserve_mattr(u64 start, u64 end, unsigned long attr, unsigned long *fattr);
+int free_mattr(u64 start, u64 end, unsigned long attr);
+
+#endif
+
Index: linux-2.6.git/arch/x86/mm/ioremap_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/ioremap_32.c	2008-01-08 12:43:13.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/ioremap_32.c	2008-01-08 12:44:20.000000000 -0800
@@ -17,6 +17,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
+#include <asm/pat.h>
 
 #define ISA_START_ADDRESS	0xa0000
 #define ISA_END_ADDRESS		0x100000
@@ -26,6 +27,42 @@
  */
 
 /*
+ * Fix up the linear direct mapping of the kernel to avoid cache attribute
+ * conflicts.
+ */
+static int
+ioremap_change_attr(unsigned long phys_addr, unsigned long size,
+					unsigned long flags)
+{
+	unsigned long last_addr;
+	int err = 0;
+
+	/* Guaranteed to be > phys_addr, as per __ioremap() */
+	last_addr = phys_addr + size - 1;
+	if (last_addr < virt_to_phys(high_memory) - 1) {
+		unsigned long vaddr = (unsigned long)__va(phys_addr);
+		unsigned long npages;
+
+		phys_addr &= PAGE_MASK;
+
+		/* This might overflow and become zero.. */
+		last_addr = PAGE_ALIGN(last_addr);
+
+		/* .. but that's ok, because modulo-2**n arithmetic will make
+	 	* the page-aligned "last - first" come out right.
+	 	*/
+		npages = (last_addr - phys_addr) >> PAGE_SHIFT;
+
+		err = change_page_attr_addr(vaddr, npages,
+		                       __pgprot(__PAGE_KERNEL|flags));
+		if (!err)
+			global_flush_tlb();
+	}
+
+	return err;
+}
+
+/*
  * Remap an arbitrary physical address space into the kernel virtual
  * address space. Needed when the kernel wants to access high addresses
  * directly.
@@ -90,7 +127,25 @@
 		vunmap((void __force *) addr);
 		return NULL;
 	}
+
+	/*
+	 * For plain ioremap() get the existing attributes. Otherwise
+	 * check against the existing ones.
+	 */
+	if (reserve_mattr(phys_addr, phys_addr + size, flags,
+	                  flags ? NULL : &flags) < 0)
+		goto out;
+
+	if (flags && ioremap_change_attr(phys_addr, size, flags) < 0) {
+		free_mattr(phys_addr, phys_addr + size, flags);
+		goto out;
+	}
 	return (void __iomem *) (offset + (char __iomem *)addr);
+
+out:
+	area->flags &= 0xffffff;
+	vunmap(addr);
+	return NULL;
 }
 EXPORT_SYMBOL(__ioremap);
 
@@ -118,36 +173,7 @@
 
 void __iomem *ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
-	unsigned long last_addr;
-	void __iomem *p = __ioremap(phys_addr, size, _PAGE_PCD);
-	if (!p) 
-		return p; 
-
-	/* Guaranteed to be > phys_addr, as per __ioremap() */
-	last_addr = phys_addr + size - 1;
-
-	if (last_addr < virt_to_phys(high_memory) - 1) {
-		struct page *ppage = virt_to_page(__va(phys_addr));		
-		unsigned long npages;
-
-		phys_addr &= PAGE_MASK;
-
-		/* This might overflow and become zero.. */
-		last_addr = PAGE_ALIGN(last_addr);
-
-		/* .. but that's ok, because modulo-2**n arithmetic will make
-	 	* the page-aligned "last - first" come out right.
-	 	*/
-		npages = (last_addr - phys_addr) >> PAGE_SHIFT;
-
-		if (change_page_attr(ppage, npages, PAGE_KERNEL_NOCACHE) < 0) { 
-			iounmap(p); 
-			p = NULL;
-		}
-		global_flush_tlb();
-	}
-
-	return p;					
+	return __ioremap(phys_addr, size, _PAGE_PCD);
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
@@ -194,12 +220,11 @@
 	}
 
 	/* Reset the direct mapping. Can block */
-	if ((p->flags >> 20) && p->phys_addr < virt_to_phys(high_memory) - 1) {
-		change_page_attr(virt_to_page(__va(p->phys_addr)),
-				 get_vm_area_size(p) >> PAGE_SHIFT,
-				 PAGE_KERNEL);
-		global_flush_tlb();
-	} 
+	if (p->flags >> 20) {
+		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
+		           p->flags>>20);
+		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
+	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);

-- 
