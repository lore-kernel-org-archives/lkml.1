Return-Path: <linux-kernel-owner+w=401wt.eu-S938169AbZDJMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938169AbZDJMhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937953AbZDJMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:36:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:45731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936905AbZDJMgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:36:43 -0400
Date: Fri, 10 Apr 2009 12:34:55 GMT
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409212709.085210000@intel.com>
References: <20090409212709.085210000@intel.com>
Subject: [tip:x86/pat] x86, PAT: Remove duplicate memtype reserve in devmem mmap
Message-ID: <tip-0c3c8a18361a636069f5a5d9d0d0f9c2124e6b94@git.kernel.org>
Git-Commit-ID: 0c3c8a18361a636069f5a5d9d0d0f9c2124e6b94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:34:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c3c8a18361a636069f5a5d9d0d0f9c2124e6b94
Gitweb:     http://git.kernel.org/tip/0c3c8a18361a636069f5a5d9d0d0f9c2124e6b94
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 9 Apr 2009 14:26:52 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:55:48 +0200

x86, PAT: Remove duplicate memtype reserve in devmem mmap

/dev/mem mmap code was doing memtype reserve/free for a while now.
Recently we added memtype tracking in remap_pfn_range, and /dev/mem mmap
uses it indirectly. So, we don't need seperate tracking in /dev/mem code
any more. That means another ~100 lines of code removed :-).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <20090409212709.085210000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/pat.h |    4 ---
 arch/x86/mm/pat.c          |   60 +------------------------------------------
 drivers/char/mem.c         |   27 -------------------
 3 files changed, 2 insertions(+), 89 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index 2cd07b9..7af14e5 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -18,9 +18,5 @@ extern int free_memtype(u64 start, u64 end);
 
 extern int kernel_map_sync_memtype(u64 base, unsigned long size,
 		unsigned long flag);
-extern void map_devmem(unsigned long pfn, unsigned long size,
-		       struct pgprot vma_prot);
-extern void unmap_devmem(unsigned long pfn, unsigned long size,
-			 struct pgprot vma_prot);
 
 #endif /* _ASM_X86_PAT_H */
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 8d3de95..cc5e0e2 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -536,9 +536,7 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
 {
-	u64 offset = ((u64) pfn) << PAGE_SHIFT;
-	unsigned long flags = -1;
-	int retval;
+	unsigned long flags = _PAGE_CACHE_WB;
 
 	if (!range_is_allowed(pfn, size))
 		return 0;
@@ -566,65 +564,11 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 	}
 #endif
 
-	/*
-	 * With O_SYNC, we can only take UC_MINUS mapping. Fail if we cannot.
-	 *
-	 * Without O_SYNC, we want to get
-	 * - WB for WB-able memory and no other conflicting mappings
-	 * - UC_MINUS for non-WB-able memory with no other conflicting mappings
-	 * - Inherit from confliting mappings otherwise
-	 */
-	if (flags != -1) {
-		retval = reserve_memtype(offset, offset + size, flags, NULL);
-	} else {
-		retval = reserve_memtype(offset, offset + size,
-					_PAGE_CACHE_WB, &flags);
-	}
-
-	if (retval < 0)
-		return 0;
-
-	if (((pfn < max_low_pfn_mapped) ||
-	     (pfn >= (1UL<<(32 - PAGE_SHIFT)) && pfn < max_pfn_mapped)) &&
-	    ioremap_change_attr((unsigned long)__va(offset), size, flags) < 0) {
-		free_memtype(offset, offset + size);
-		printk(KERN_INFO
-		"%s:%d /dev/mem ioremap_change_attr failed %s for %Lx-%Lx\n",
-			current->comm, current->pid,
-			cattr_name(flags),
-			offset, (unsigned long long)(offset + size));
-		return 0;
-	}
-
 	*vma_prot = __pgprot((pgprot_val(*vma_prot) & ~_PAGE_CACHE_MASK) |
 			     flags);
 	return 1;
 }
 
-void map_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
-{
-	unsigned long want_flags = (pgprot_val(vma_prot) & _PAGE_CACHE_MASK);
-	u64 addr = (u64)pfn << PAGE_SHIFT;
-	unsigned long flags;
-
-	reserve_memtype(addr, addr + size, want_flags, &flags);
-	if (flags != want_flags) {
-		printk(KERN_INFO
-		"%s:%d /dev/mem expected mapping type %s for %Lx-%Lx, got %s\n",
-			current->comm, current->pid,
-			cattr_name(want_flags),
-			addr, (unsigned long long)(addr + size),
-			cattr_name(flags));
-	}
-}
-
-void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
-{
-	u64 addr = (u64)pfn << PAGE_SHIFT;
-
-	free_memtype(addr, addr + size);
-}
-
 /*
  * Change the memory type for the physial address range in kernel identity
  * mapping space if that range is a part of identity map.
@@ -662,8 +606,8 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 {
 	int is_ram = 0;
 	int ret;
-	unsigned long flags;
 	unsigned long want_flags = (pgprot_val(*vma_prot) & _PAGE_CACHE_MASK);
+	unsigned long flags = want_flags;
 
 	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 3586b3b..8f05c38 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -301,33 +301,7 @@ static inline int private_mapping_ok(struct vm_area_struct *vma)
 }
 #endif
 
-void __attribute__((weak))
-map_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
-{
-	/* nothing. architectures can override. */
-}
-
-void __attribute__((weak))
-unmap_devmem(unsigned long pfn, unsigned long len, pgprot_t prot)
-{
-	/* nothing. architectures can override. */
-}
-
-static void mmap_mem_open(struct vm_area_struct *vma)
-{
-	map_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
-			vma->vm_page_prot);
-}
-
-static void mmap_mem_close(struct vm_area_struct *vma)
-{
-	unmap_devmem(vma->vm_pgoff,  vma->vm_end - vma->vm_start,
-			vma->vm_page_prot);
-}
-
 static struct vm_operations_struct mmap_mem_ops = {
-	.open  = mmap_mem_open,
-	.close = mmap_mem_close,
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 	.access = generic_access_phys
 #endif
@@ -362,7 +336,6 @@ static int mmap_mem(struct file * file, struct vm_area_struct * vma)
 			    vma->vm_pgoff,
 			    size,
 			    vma->vm_page_prot)) {
-		unmap_devmem(vma->vm_pgoff, size, vma->vm_page_prot);
 		return -EAGAIN;
 	}
 	return 0;
