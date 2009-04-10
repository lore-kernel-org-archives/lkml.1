Return-Path: <linux-kernel-owner+w=401wt.eu-S939332AbZDJSdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939332AbZDJSdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765860AbZDJScz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:32:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:49729 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763054AbZDJScy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:32:54 -0400
Date: Fri, 10 Apr 2009 18:30:36 GMT
From: Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, ananth@in.ibm.com,
       garyhade@us.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       ananth@in.ibm.com, garyhade@us.ibm.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <49DE3695.6040800@redhat.com>
References: <49DE3695.6040800@redhat.com>
Subject: [tip:x86/urgent] x86: fix set_fixmap to use phys_addr_t
Message-ID: <tip-9b987aeb4a7bc42a3eb8361030b820b0263c31f1@git.kernel.org>
Git-Commit-ID: 9b987aeb4a7bc42a3eb8361030b820b0263c31f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 18:30:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b987aeb4a7bc42a3eb8361030b820b0263c31f1
Gitweb:     http://git.kernel.org/tip/9b987aeb4a7bc42a3eb8361030b820b0263c31f1
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 9 Apr 2009 10:55:33 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 20:27:13 +0200

x86: fix set_fixmap to use phys_addr_t

Impact: fix kprobes crash on 32-bit with RAM above 4G

Use phys_addr_t for receiving a physical address argument
instead of unsigned long. This allows fixmap to handle
pages higher than 4GB on x86-32.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: systemtap-ml <systemtap@sources.redhat.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <49DE3695.6040800@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/fixmap.h   |    4 ++--
 arch/x86/include/asm/io.h       |    6 ++++--
 arch/x86/include/asm/paravirt.h |    4 ++--
 arch/x86/mm/ioremap.c           |   23 +++++++++++++----------
 arch/x86/mm/pgtable.c           |    3 ++-
 arch/x86/xen/mmu.c              |    2 +-
 6 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 81937a5..2d81af3 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -151,11 +151,11 @@ extern pte_t *pkmap_page_table;
 
 void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
 void native_set_fixmap(enum fixed_addresses idx,
-		       unsigned long phys, pgprot_t flags);
+		       phys_addr_t phys, pgprot_t flags);
 
 #ifndef CONFIG_PARAVIRT
 static inline void __set_fixmap(enum fixed_addresses idx,
-				unsigned long phys, pgprot_t flags)
+				phys_addr_t phys, pgprot_t flags)
 {
 	native_set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index e5383e3..7373932 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -193,8 +193,10 @@ extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
  */
 extern void early_ioremap_init(void);
 extern void early_ioremap_reset(void);
-extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
-extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
+extern void __iomem *early_ioremap(resource_size_t phys_addr,
+				   unsigned long size);
+extern void __iomem *early_memremap(resource_size_t phys_addr,
+				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 
 #define IO_SPACE_LIMIT 0xffff
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 7727aa8..378e369 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -347,7 +347,7 @@ struct pv_mmu_ops {
 	/* Sometimes the physical address is a pfn, and sometimes its
 	   an mfn.  We can tell which is which from the index. */
 	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
-			   unsigned long phys, pgprot_t flags);
+			   phys_addr_t phys, pgprot_t flags);
 };
 
 struct raw_spinlock;
@@ -1432,7 +1432,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 void arch_flush_lazy_mmu_mode(void);
 
 static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
-				unsigned long phys, pgprot_t flags)
+				phys_addr_t phys, pgprot_t flags)
 {
 	pv_mmu_ops.set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0dfa09d..09daebf 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -547,7 +547,7 @@ void __init early_ioremap_reset(void)
 }
 
 static void __init __early_set_fixmap(enum fixed_addresses idx,
-				   unsigned long phys, pgprot_t flags)
+				      phys_addr_t phys, pgprot_t flags)
 {
 	unsigned long addr = __fix_to_virt(idx);
 	pte_t *pte;
@@ -566,7 +566,7 @@ static void __init __early_set_fixmap(enum fixed_addresses idx,
 }
 
 static inline void __init early_set_fixmap(enum fixed_addresses idx,
-					   unsigned long phys, pgprot_t prot)
+					   phys_addr_t phys, pgprot_t prot)
 {
 	if (after_paging_init)
 		__set_fixmap(idx, phys, prot);
@@ -607,9 +607,10 @@ static int __init check_early_ioremap_leak(void)
 late_initcall(check_early_ioremap_leak);
 
 static void __init __iomem *
-__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
+__early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 {
-	unsigned long offset, last_addr;
+	unsigned long offset;
+	resource_size_t last_addr;
 	unsigned int nrpages;
 	enum fixed_addresses idx0, idx;
 	int i, slot;
@@ -625,15 +626,15 @@ __early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 	}
 
 	if (slot < 0) {
-		printk(KERN_INFO "early_iomap(%08lx, %08lx) not found slot\n",
-			 phys_addr, size);
+		printk(KERN_INFO "early_iomap(%08llx, %08lx) not found slot\n",
+			 (u64)phys_addr, size);
 		WARN_ON(1);
 		return NULL;
 	}
 
 	if (early_ioremap_debug) {
-		printk(KERN_INFO "early_ioremap(%08lx, %08lx) [%d] => ",
-		       phys_addr, size, slot);
+		printk(KERN_INFO "early_ioremap(%08llx, %08lx) [%d] => ",
+		       (u64)phys_addr, size, slot);
 		dump_stack();
 	}
 
@@ -680,13 +681,15 @@ __early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 }
 
 /* Remap an IO device */
-void __init __iomem *early_ioremap(unsigned long phys_addr, unsigned long size)
+void __init __iomem *
+early_ioremap(resource_size_t phys_addr, unsigned long size)
 {
 	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
 }
 
 /* Remap memory */
-void __init __iomem *early_memremap(unsigned long phys_addr, unsigned long size)
+void __init __iomem *
+early_memremap(resource_size_t phys_addr, unsigned long size)
 {
 	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 5b7c7c8..7aa03a5 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -345,7 +345,8 @@ void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
 	fixmaps_set++;
 }
 
-void native_set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
+void native_set_fixmap(enum fixed_addresses idx, phys_addr_t phys,
+		       pgprot_t flags)
 {
 	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index db3802f..2a81838 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1750,7 +1750,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 }
 #endif	/* CONFIG_X86_64 */
 
-static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
+static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 {
 	pte_t pte;
 
