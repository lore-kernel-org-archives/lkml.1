Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYCSUfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYCSUfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757794AbYCSTlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:41:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:13573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbYCSTla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="536061933"
Message-Id: <20080319000059.862269000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:20 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 08/13] x86: PAT phys_mem_access_prot_allowed for dev/mem mmap
Content-Disposition: inline; filename=x86_phys_mem_access_prot.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce phys_mem_access_prot_allowed(), which checks whether the mapping
is possible, without any conflicts and returns success or failure based on that.
phys_mem_access_prot() by itself does not allow failure case. This ability
to return error is needed for PAT where we may have aliasing conflicts.

x86 setup __HAVE_PHYS_MEM_ACCESS_PROT and move x86 specific code out of
/dev/mem into arch specific area.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/pat.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/pat.c	2008-03-18 03:11:03.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/pat.c	2008-03-18 09:20:33.000000000 -0700
@@ -400,3 +400,42 @@
 	return err;
 }
 
+
+/* /dev/mem interface. Use the previous mapping */
+pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+				unsigned long size, pgprot_t vma_prot)
+{
+	return vma_prot;
+}
+
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+				unsigned long size, pgprot_t *vma_prot)
+{
+
+	if (file->f_flags & O_SYNC) {
+		*vma_prot = pgprot_noncached(*vma_prot);
+		return 1;
+	}
+
+#ifdef CONFIG_X86_32
+	/*
+	 * On the PPro and successors, the MTRRs are used to set
+	 * memory types for physical addresses outside main memory,
+	 * so blindly setting UC or PWT on those pages is wrong.
+	 * For Pentiums and earlier, the surround logic should disable
+	 * caching for the high addresses through the KEN pin, but
+	 * we maintain the tradition of paranoia in this code.
+	 */
+	if (!pat_wc_enabled &&
+	    ! ( test_bit(X86_FEATURE_MTRR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_K6_MTRR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_CYRIX_ARR, boot_cpu_data.x86_capability) ||
+		test_bit(X86_FEATURE_CENTAUR_MCR, boot_cpu_data.x86_capability)) &&
+	   (pfn << PAGE_SHIFT) >= __pa(high_memory)) {
+		*vma_prot = pgprot_noncached(*vma_prot);
+		return 1;
+	}
+#endif
+
+	return 1;
+}
Index: linux-2.6-x86.git/include/asm-x86/pgtable.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/pgtable.h	2008-03-18 02:16:04.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/pgtable.h	2008-03-18 09:20:25.000000000 -0700
@@ -205,6 +205,15 @@
 
 #define canon_pgprot(p) __pgprot(pgprot_val(p) & __supported_pte_mask)
 
+#ifndef __ASSEMBLY__
+#define __HAVE_PHYS_MEM_ACCESS_PROT
+struct file;
+pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
+                              unsigned long size, pgprot_t vma_prot);
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+                              unsigned long size, pgprot_t *vma_prot);
+#endif
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */
Index: linux-2.6-x86.git/drivers/char/mem.c
===================================================================
--- linux-2.6-x86.git.orig/drivers/char/mem.c	2008-03-18 03:11:12.000000000 -0700
+++ linux-2.6-x86.git/drivers/char/mem.c	2008-03-18 09:20:33.000000000 -0700
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
@@ -283,6 +254,12 @@
 	return written;
 }
 
+int __attribute__((weak)) phys_mem_access_prot_allowed(struct file *file,
+	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
+{
+	return 1;
+}
+
 #ifndef __HAVE_PHYS_MEM_ACCESS_PROT
 static pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				     unsigned long size, pgprot_t vma_prot)
@@ -336,6 +313,10 @@
 	if (!range_is_allowed(vma->vm_pgoff, size))
 		return -EPERM;
 
+	if (!phys_mem_access_prot_allowed(file, vma->vm_pgoff, size,
+						&vma->vm_page_prot))
+		return -EINVAL;
+
 	vma->vm_page_prot = phys_mem_access_prot(file, vma->vm_pgoff,
 						 size,
 						 vma->vm_page_prot);

-- 
