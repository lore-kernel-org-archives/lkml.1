Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbYCSUEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbYCSUEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbYCSTiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:16661 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbYCSTiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="356900594"
Message-Id: <20080319000100.097179000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:21 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 09/13] x86: PAT use reserve free memtype in mmap of /dev/mem
Content-Disposition: inline; filename=use_reserve_free_memtype_devmmemmap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use reserve_memtype and free_memtype wrappers for /dev/mem mmaps. The memtype
is slightly complicated here, given that we have to support existing X mappings.
We fallback on UC_MINUS for that.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/pat.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/pat.c	2008-03-18 03:33:01.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/pat.c	2008-03-18 09:20:21.000000000 -0700
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
+#include <linux/bootmem.h>
 
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
@@ -21,6 +22,7 @@
 #include <asm/cacheflush.h>
 #include <asm/fcntl.h>
 #include <asm/mtrr.h>
+#include <asm/io.h>
 
 int pat_wc_enabled = 1;
 
@@ -195,6 +197,21 @@
 	return 0;
 }
 
+/*
+ * req_type typically has one of the:
+ * - _PAGE_CACHE_WB
+ * - _PAGE_CACHE_WC
+ * - _PAGE_CACHE_UC_MINUS
+ * - _PAGE_CACHE_UC
+ *
+ * req_type will have a special case value '-1', when requester want to inherit
+ * the memory type from mtrr (if WB), existing PAT, defaulting to UC_MINUS.
+ *
+ * If ret_type is NULL, function will return an error if it cannot reserve the
+ * region with req_type. If ret_type is non-null, function will return
+ * available type in ret_type in case of no error. In case of any error
+ * it will return a negative return value.
+ */
 int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 			unsigned long *ret_type)
 {
@@ -205,9 +222,14 @@
 
 	/* Only track when pat_wc_enabled */
 	if (!pat_wc_enabled) {
-		if (ret_type)
-			*ret_type = req_type;
-
+		/* This is identical to page table setting without PAT */
+		if (ret_type) {
+			if (req_type == -1) {
+				*ret_type = _PAGE_CACHE_WB;
+			} else {
+				*ret_type = req_type;
+			}
+		}
 		return 0;
 	}
 
@@ -219,8 +241,29 @@
 		return 0;
 	}
 
-	req_type &= _PAGE_CACHE_MASK;
-	err = pat_x_mtrr_type(start, end, req_type, &actual_type);
+	if (req_type == -1) {
+		/*
+		 * Special case where caller wants to inherit from mtrr or
+		 * existing pat mapping, defaulting to UC_MINUS in case of
+		 * no match.
+		 */
+		u8 mtrr_type = mtrr_type_lookup(start, end);
+		if (mtrr_type == 0xFE) { /* MTRR match error */
+			err = -1;
+		}
+
+		if (mtrr_type == MTRR_TYPE_WRBACK) {
+			req_type = _PAGE_CACHE_WB;
+			actual_type = _PAGE_CACHE_WB;
+		} else {
+			req_type = _PAGE_CACHE_UC_MINUS;
+			actual_type = _PAGE_CACHE_UC_MINUS;
+		}
+	} else {
+		req_type &= _PAGE_CACHE_MASK;
+		err = pat_x_mtrr_type(start, end, req_type, &actual_type);
+	}
+
 	if (err) {
 		if (ret_type)
 			*ret_type = actual_type;
@@ -401,7 +444,14 @@
 }
 
 
-/* /dev/mem interface. Use the previous mapping */
+/*
+ * /dev/mem mmap interface. The memtype used for mapping varies:
+ * - Use UC for mappings with O_SYNC flag
+ * - Without O_SYNC flag, if there is any conflict in reserve_memtype,
+ *   inherit the memtype from existing mapping.
+ * - Else use UC_MINUS memtype (for backward compatibility with existing
+ *   X drivers.
+ */
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
@@ -411,10 +461,13 @@
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
 {
+	u64 offset = ((u64) pfn) << PAGE_SHIFT;
+	unsigned long flags = _PAGE_CACHE_UC_MINUS;
+	unsigned long ret_flags;
+	int retval;
 
 	if (file->f_flags & O_SYNC) {
-		*vma_prot = pgprot_noncached(*vma_prot);
-		return 1;
+		flags = _PAGE_CACHE_UC;
 	}
 
 #ifdef CONFIG_X86_32
@@ -432,10 +485,65 @@
 		test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
 		test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability)) &&
 	   (pfn << PAGE_SHIFT) >= __pa(high_memory)) {
-		*vma_prot = pgprot_noncached(*vma_prot);
-		return 1;
+		flags = _PAGE_CACHE_UC;
 	}
 #endif
 
+	/*
+	 * With O_SYNC, we can only take UC mapping. Fail if we cannot.
+	 * Without O_SYNC, we want to get
+	 * - WB for WB-able memory and no other conflicting mappings
+	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
+	 * - Inherit from confliting mappings otherwise
+	 */
+	if (flags != _PAGE_CACHE_UC_MINUS) {
+		retval = reserve_memtype(offset, offset + size, flags, NULL);
+	} else {
+		retval = reserve_memtype(offset, offset + size, -1, &ret_flags);
+	}
+
+	if (retval < 0)
+		return 0;
+
+	flags = ret_flags;
+
+	if (pfn <= max_pfn_mapped &&
+            ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
+		free_memtype(offset, offset + size);
+		printk(KERN_DEBUG
+		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
+			current->comm, current->pid,
+			cattr_name(flags),
+			offset, offset + size);
+		return 0;
+	}
+
+	*vma_prot = __pgprot((pgprot_val(*vma_prot) & ~_PAGE_CACHE_MASK) |
+			     flags);
 	return 1;
 }
+
+void map_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
+{
+	u64 addr = (u64)pfn << PAGE_SHIFT;
+	unsigned long flags;
+	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
+
+	reserve_memtype(addr, addr + size, want_flags, &flags);
+	if (flags != want_flags) {
+		printk(KERN_DEBUG
+		"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
+			current->comm, current->pid,
+			cattr_name(want_flags),
+			addr, addr + size,
+			cattr_name(flags));
+	}
+}
+
+void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
+{
+	u64 addr = (u64)pfn << PAGE_SHIFT;
+
+	free_memtype(addr, addr + size);
+}
+
Index: linux-2.6-x86.git/drivers/char/mem.c
===================================================================
--- linux-2.6-x86.git.orig/drivers/char/mem.c	2008-03-18 03:33:01.000000000 -0700
+++ linux-2.6-x86.git/drivers/char/mem.c	2008-03-18 03:38:05.000000000 -0700
@@ -300,6 +300,35 @@
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
+			vma->vm_page_prot);
+}
+
+static void mmap_mem_close(struct vm_area_struct *vma)
+{
+	unmap_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
+			vma->vm_page_prot);
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
@@ -321,13 +350,17 @@
 						 size,
 						 vma->vm_page_prot);
 
+	vma->vm_ops = &mmap_mem_ops;
+
 	/* Remap-pfn-range will mark the range VM_IO and VM_RESERVED */
 	if (remap_pfn_range(vma,
 			    vma->vm_start,
 			    vma->vm_pgoff,
 			    size,
-			    vma->vm_page_prot))
+			    vma->vm_page_prot)) {
+		unmap_devmem(vma->vm_pgoff, size, vma->vm_page_prot);
 		return -EAGAIN;
+	}
 	return 0;
 }
 

-- 
