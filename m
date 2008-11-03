Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYKCRLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYKCRLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYKCRK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:10:29 -0500
Received: from home.keithp.com ([63.227.221.253]:34185 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbYKCRK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:10:28 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Keith Packard <keithp@keithp.com>
Subject: [PATCH] [x86_32] Add io_map_atomic using fixmaps
Date: Mon,  3 Nov 2008 09:09:57 -0800
Message-Id: <1225732199-21560-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This steals the code used for CONFIG_HIGHMEM memory mappings except that
it's designed for dynamic io resource mapping. These fixmaps are available
even with CONFIG_HIGHMEM turned off.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 arch/x86/Kconfig                 |    4 ++
 arch/x86/include/asm/fixmap.h    |    4 ++
 arch/x86/include/asm/fixmap_32.h |    4 --
 arch/x86/include/asm/highmem.h   |    5 +--
 arch/x86/mm/Makefile             |    2 +-
 arch/x86/mm/init_32.c            |    3 +-
 arch/x86/mm/iomap_32.c           |   59 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/iomap.h          |   30 +++++++++++++++++++
 8 files changed, 100 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/mm/iomap_32.c
 create mode 100644 include/asm-x86/iomap.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 350bee1..a879393 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1890,6 +1890,10 @@ config SYSVIPC_COMPAT
 endmenu
 
 
+config HAVE_ATOMIC_IOMAP
+	def_bool y
+	depends on X86_32
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 8668a94..23696d4 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -9,6 +9,10 @@
 
 extern int fixmaps_set;
 
+extern pte_t *kmap_pte;
+extern pgprot_t kmap_prot;
+extern pte_t *pkmap_page_table;
+
 void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
 void native_set_fixmap(enum fixed_addresses idx,
 		       unsigned long phys, pgprot_t flags);
diff --git a/arch/x86/include/asm/fixmap_32.h b/arch/x86/include/asm/fixmap_32.h
index 09f29ab..c7115c1 100644
--- a/arch/x86/include/asm/fixmap_32.h
+++ b/arch/x86/include/asm/fixmap_32.h
@@ -28,10 +28,8 @@ extern unsigned long __FIXADDR_TOP;
 #include <asm/acpi.h>
 #include <asm/apicdef.h>
 #include <asm/page.h>
-#ifdef CONFIG_HIGHMEM
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
-#endif
 
 /*
  * Here we define all the compile-time 'special' virtual
@@ -75,10 +73,8 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_CYCLONE_TIMER
 	FIX_CYCLONE_TIMER, /*cyclone timer register*/
 #endif
-#ifdef CONFIG_HIGHMEM
 	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
 	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
-#endif
 #ifdef CONFIG_PCI_MMCONFIG
 	FIX_PCIE_MCFG,
 #endif
diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
index a3b3b7c..bf9276b 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -25,14 +25,11 @@
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
+#include <asm/fixmap.h>
 
 /* declarations for highmem.c */
 extern unsigned long highstart_pfn, highend_pfn;
 
-extern pte_t *kmap_pte;
-extern pgprot_t kmap_prot;
-extern pte_t *pkmap_page_table;
-
 /*
  * Right now we initialize only a single pte table. It can be extended
  * easily, subsequent pte tables have to be allocated in one physical
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 59f89b4..fea4565 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,7 +1,7 @@
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o gup.o
 
-obj-$(CONFIG_X86_32)		+= pgtable_32.o
+obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_X86_PTDUMP)	+= dump_pagetables.o
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 8396868..c483f42 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -334,7 +334,6 @@ int devmem_is_allowed(unsigned long pagenr)
 	return 0;
 }
 
-#ifdef CONFIG_HIGHMEM
 pte_t *kmap_pte;
 pgprot_t kmap_prot;
 
@@ -357,6 +356,7 @@ static void __init kmap_init(void)
 	kmap_prot = PAGE_KERNEL;
 }
 
+#ifdef CONFIG_HIGHMEM
 static void __init permanent_kmaps_init(pgd_t *pgd_base)
 {
 	unsigned long vaddr;
@@ -436,7 +436,6 @@ static void __init set_highmem_pages_init(void)
 #endif /* !CONFIG_NUMA */
 
 #else
-# define kmap_init()				do { } while (0)
 # define permanent_kmaps_init(pgd_base)		do { } while (0)
 # define set_highmem_pages_init()	do { } while (0)
 #endif /* CONFIG_HIGHMEM */
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
new file mode 100644
index 0000000..d0151d8
--- /dev/null
+++ b/arch/x86/mm/iomap_32.c
@@ -0,0 +1,59 @@
+/*
+ * Copyright © 2008 Ingo Molnar
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#include <asm/iomap.h>
+#include <linux/module.h>
+
+/* Map 'pfn' using fixed map 'type' and protections 'prot'
+ */
+void *
+iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+
+	pagefault_disable();
+
+	idx = type + KM_TYPE_NR*smp_processor_id();
+	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	set_pte(kmap_pte-idx, pfn_pte(pfn, prot));
+	arch_flush_lazy_mmu_mode();
+
+	return (void*) vaddr;
+}
+EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
+
+void
+iounmap_atomic(void *kvaddr, enum km_type type)
+{
+	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
+	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
+
+	/*
+	 * Force other mappings to Oops if they'll try to access this pte
+	 * without first remap it.  Keeping stale mappings around is a bad idea
+	 * also, in case the page changes cacheability attributes or becomes
+	 * a protected page in a hypervisor.
+	 */
+	if (vaddr == __fix_to_virt(FIX_KMAP_BEGIN+idx))
+		kpte_clear_flush(kmap_pte-idx, vaddr);
+
+	arch_flush_lazy_mmu_mode();
+	pagefault_enable();
+}
+EXPORT_SYMBOL_GPL(iounmap_atomic);
diff --git a/include/asm-x86/iomap.h b/include/asm-x86/iomap.h
new file mode 100644
index 0000000..c1f0628
--- /dev/null
+++ b/include/asm-x86/iomap.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright © 2008 Ingo Molnar
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+void *
+iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
+
+void
+iounmap_atomic(void *kvaddr, enum km_type type);
-- 
1.5.6.5

