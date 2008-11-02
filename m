Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYKBCZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYKBCZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYKBCXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:23:47 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:34655 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbYKBCXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:23:46 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: glommer@redhat.com, mingo@elte.hu
Subject: [PATCH 6/6] x86: Unify fixmap.h
Date: Sun,  2 Nov 2008 00:23:53 -0200
Message-Id: <1225592633-9948-7-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1225592633-9948-6-git-send-email-gustavo@las.ic.unicamp.br>
References: <1225592633-9948-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1225592633-9948-6-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches unify fixmap_32.h and fixmap_64.h into fixmap.h.
Things that we can't merge now are using CONFIG_X86_{32,64}
(e.g.:vsyscall and EFI)

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
Acked-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/include/asm/fixmap.h    |  156 +++++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/fixmap_32.h |  123 ------------------------------
 arch/x86/include/asm/fixmap_64.h |   94 -----------------------
 3 files changed, 154 insertions(+), 219 deletions(-)
 delete mode 100644 arch/x86/include/asm/fixmap_32.h
 delete mode 100644 arch/x86/include/asm/fixmap_64.h

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 8668a94..f400f3a 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -1,11 +1,162 @@
+/*
+ * fixmap.h: compile-time virtual memory allocation
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1998 Ingo Molnar
+ *
+ * Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
+ */
+
 #ifndef _ASM_X86_FIXMAP_H
 #define _ASM_X86_FIXMAP_H
 
+#ifndef __ASSEMBLY__
+#include <linux/kernel.h>
+#include <asm/acpi.h>
+#include <asm/apicdef.h>
+#include <asm/page.h>
+#ifdef CONFIG_HIGHMEM
+#include <linux/threads.h>
+#include <asm/kmap_types.h>
+#endif
+#ifdef CONFIG_X86_64
+#include <asm/vsyscall.h>
+#ifdef CONFIG_EFI
+#include <asm/efi.h>
+#endif
+#endif
+
+/*
+ * We can't declare FIXADDR_TOP as variable for x86_64 because vsyscall
+ * uses fixmaps that relies on FIXADDR_TOP for proper address calculation.
+ * Because of this, FIXADDR_TOP x86 integration was left as later work.
+ */
 #ifdef CONFIG_X86_32
-# include "fixmap_32.h"
+/* used by vmalloc.c, vsyscall.lds.S.
+ *
+ * Leave one empty page between vmalloc'ed areas and
+ * the start of the fixmap.
+ */
+extern unsigned long __FIXADDR_TOP;
+#define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
+
+#define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
+#define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
 #else
-# include "fixmap_64.h"
+#define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
+
+/* Only covers 32bit vsyscalls currently. Need another set for 64bit. */
+#define FIXADDR_USER_START	((unsigned long)VSYSCALL32_VSYSCALL)
+#define FIXADDR_USER_END	(FIXADDR_USER_START + PAGE_SIZE)
+#endif
+
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process.
+ * for x86_32: We allocate these special addresses
+ * from the end of virtual memory (0xfffff000) backwards.
+ * Also this lets us do fail-safe vmalloc(), we
+ * can guarantee that these special addresses and
+ * vmalloc()-ed addresses never overlap.
+ *
+ * these 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages. (or larger if used with an increment
+ * highger than 1) use fixmap_set(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ * TLB entries of such buffers will not be flushed across
+ * task switches.
+ */
+
+enum fixed_addresses {
+#ifdef CONFIG_X86_32
+	FIX_HOLE,
+	FIX_VDSO,
+#else
+	VSYSCALL_LAST_PAGE,
+	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
+			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
+	VSYSCALL_HPET,
+#endif
+	FIX_DBGP_BASE,
+	FIX_EARLYCON_MEM_BASE,
+#ifdef CONFIG_X86_LOCAL_APIC
+	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 #endif
+#ifdef CONFIG_X86_IO_APIC
+	FIX_IO_APIC_BASE_0,
+	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
+#endif
+#ifdef CONFIG_X86_64
+#ifdef CONFIG_EFI
+	FIX_EFI_IO_MAP_LAST_PAGE,
+	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
+				  + MAX_EFI_IO_PAGES - 1,
+#endif
+#endif
+#ifdef CONFIG_X86_VISWS_APIC
+	FIX_CO_CPU,	/* Cobalt timer */
+	FIX_CO_APIC,	/* Cobalt APIC Redirection Table */
+	FIX_LI_PCIA,	/* Lithium PCI Bridge A */
+	FIX_LI_PCIB,	/* Lithium PCI Bridge B */
+#endif
+#ifdef CONFIG_X86_F00F_BUG
+	FIX_F00F_IDT,	/* Virtual mapping for IDT */
+#endif
+#ifdef CONFIG_X86_CYCLONE_TIMER
+	FIX_CYCLONE_TIMER, /*cyclone timer register*/
+#endif
+#ifdef CONFIG_HIGHMEM
+	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
+	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
+#endif
+#ifdef CONFIG_X86_32
+#ifdef CONFIG_PCI_MMCONFIG
+	FIX_PCIE_MCFG,
+#endif
+#endif
+#ifdef CONFIG_PARAVIRT
+	FIX_PARAVIRT_BOOTMAP,
+#endif
+	__end_of_permanent_fixed_addresses,
+#ifdef CONFIG_ACPI
+	FIX_ACPI_BEGIN,
+	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
+#endif
+#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
+	FIX_OHCI1394_BASE,
+#endif
+	/*
+	 * 256 temporary boot-time mappings, used by early_ioremap(),
+	 * before ioremap() is functional.
+	 *
+	 * We round it up to the next 256 pages boundary so that we
+	 * can have a single pgd entry and a single pte table:
+	 */
+#define NR_FIX_BTMAPS		64
+#define FIX_BTMAPS_SLOTS	4
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
+			(__end_of_permanent_fixed_addresses & 255),
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
+#ifdef CONFIG_X86_32
+	FIX_WP_TEST,
+#endif
+	__end_of_fixed_addresses
+};
+
+
+extern void reserve_top_address(unsigned long reserve);
+
+#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
+#define FIXADDR_BOOT_START	(FIXADDR_TOP - FIXADDR_BOOT_SIZE)
 
 extern int fixmaps_set;
 
@@ -65,4 +216,5 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
 	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
 	return __virt_to_fix(vaddr);
 }
+#endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_FIXMAP_H */
diff --git a/arch/x86/include/asm/fixmap_32.h b/arch/x86/include/asm/fixmap_32.h
deleted file mode 100644
index 5d533f0..0000000
--- a/arch/x86/include/asm/fixmap_32.h
+++ /dev/null
@@ -1,123 +0,0 @@
-/*
- * fixmap.h: compile-time virtual memory allocation
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1998 Ingo Molnar
- *
- * Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
- */
-
-#ifndef _ASM_X86_FIXMAP_32_H
-#define _ASM_X86_FIXMAP_32_H
-
-
-/* used by vmalloc.c, vsyscall.lds.S.
- *
- * Leave one empty page between vmalloc'ed areas and
- * the start of the fixmap.
- */
-extern unsigned long __FIXADDR_TOP;
-#define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
-#define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
-
-#ifndef __ASSEMBLY__
-#include <linux/kernel.h>
-#include <asm/acpi.h>
-#include <asm/apicdef.h>
-#include <asm/page.h>
-#ifdef CONFIG_HIGHMEM
-#include <linux/threads.h>
-#include <asm/kmap_types.h>
-#endif
-
-/*
- * Here we define all the compile-time 'special' virtual
- * addresses. The point is to have a constant address at
- * compile time, but to set the physical address only
- * in the boot process. We allocate these special addresses
- * from the end of virtual memory (0xfffff000) backwards.
- * Also this lets us do fail-safe vmalloc(), we
- * can guarantee that these special addresses and
- * vmalloc()-ed addresses never overlap.
- *
- * these 'compile-time allocated' memory buffers are
- * fixed-size 4k pages. (or larger if used with an increment
- * highger than 1) use fixmap_set(idx,phys) to associate
- * physical memory with fixmap indices.
- *
- * TLB entries of such buffers will not be flushed across
- * task switches.
- */
-enum fixed_addresses {
-	FIX_HOLE,
-	FIX_VDSO,
-	FIX_DBGP_BASE,
-	FIX_EARLYCON_MEM_BASE,
-#ifdef CONFIG_X86_LOCAL_APIC
-	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
-#endif
-#ifdef CONFIG_X86_IO_APIC
-	FIX_IO_APIC_BASE_0,
-	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS-1,
-#endif
-#ifdef CONFIG_X86_VISWS_APIC
-	FIX_CO_CPU,	/* Cobalt timer */
-	FIX_CO_APIC,	/* Cobalt APIC Redirection Table */
-	FIX_LI_PCIA,	/* Lithium PCI Bridge A */
-	FIX_LI_PCIB,	/* Lithium PCI Bridge B */
-#endif
-#ifdef CONFIG_X86_F00F_BUG
-	FIX_F00F_IDT,	/* Virtual mapping for IDT */
-#endif
-#ifdef CONFIG_X86_CYCLONE_TIMER
-	FIX_CYCLONE_TIMER, /*cyclone timer register*/
-#endif
-#ifdef CONFIG_HIGHMEM
-	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
-	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
-#endif
-#ifdef CONFIG_PCI_MMCONFIG
-	FIX_PCIE_MCFG,
-#endif
-#ifdef CONFIG_PARAVIRT
-	FIX_PARAVIRT_BOOTMAP,
-#endif
-	__end_of_permanent_fixed_addresses,
-	/*
-	 * 256 temporary boot-time mappings, used by early_ioremap(),
-	 * before ioremap() is functional.
-	 *
-	 * We round it up to the next 256 pages boundary so that we
-	 * can have a single pgd entry and a single pte table:
-	 */
-#define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_SLOTS	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
-			(__end_of_permanent_fixed_addresses & 255),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
-	FIX_WP_TEST,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
-	__end_of_fixed_addresses
-};
-
-extern void reserve_top_address(unsigned long reserve);
-
-
-#define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
-
-#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
-#define FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
-#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
-#define FIXADDR_BOOT_START	(FIXADDR_TOP - FIXADDR_BOOT_SIZE)
-
-#endif /* !__ASSEMBLY__ */
-#endif /* _ASM_X86_FIXMAP_32_H */
diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
deleted file mode 100644
index 5dc7941..0000000
--- a/arch/x86/include/asm/fixmap_64.h
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * fixmap.h: compile-time virtual memory allocation
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1998 Ingo Molnar
- */
-
-#ifndef _ASM_X86_FIXMAP_64_H
-#define _ASM_X86_FIXMAP_64_H
-
-#include <linux/kernel.h>
-#include <asm/acpi.h>
-#include <asm/apicdef.h>
-#include <asm/page.h>
-#include <asm/vsyscall.h>
-#include <asm/efi.h>
-
-/*
- * Here we define all the compile-time 'special' virtual
- * addresses. The point is to have a constant address at
- * compile time, but to set the physical address only
- * in the boot process.
- *
- * These 'compile-time allocated' memory buffers are
- * fixed-size 4k pages (or larger if used with an increment
- * higher than 1). Use set_fixmap(idx,phys) to associate
- * physical memory with fixmap indices.
- *
- * TLB entries of such buffers will not be flushed across
- * task switches.
- */
-
-enum fixed_addresses {
-	VSYSCALL_LAST_PAGE,
-	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
-			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
-	VSYSCALL_HPET,
-	FIX_DBGP_BASE,
-	FIX_EARLYCON_MEM_BASE,
-#ifdef CONFIG_X86_LOCAL_APIC
-	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
-#endif
-#ifdef CONFIG_X86_IO_APIC
-	FIX_IO_APIC_BASE_0,
-	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
-#endif
-#ifdef CONFIG_EFI
-	FIX_EFI_IO_MAP_LAST_PAGE,
-	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
-				  + MAX_EFI_IO_PAGES - 1,
-#endif
-#ifdef CONFIG_PARAVIRT
-	FIX_PARAVIRT_BOOTMAP,
-#endif
-	__end_of_permanent_fixed_addresses,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
-#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
-	FIX_OHCI1394_BASE,
-#endif
-	/*
-	 * 256 temporary boot-time mappings, used by early_ioremap(),
-	 * before ioremap() is functional.
-	 *
-	 * We round it up to the next 256 pages boundary so that we
-	 * can have a single pgd entry and a single pte table:
-	 */
-#define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_SLOTS	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
-			(__end_of_permanent_fixed_addresses & 255),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
-	__end_of_fixed_addresses
-};
-
-extern void reserve_top_address(unsigned long reserve);
-
-#define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
-
-#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
-#define FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
-#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
-#define FIXADDR_BOOT_START	(FIXADDR_TOP - FIXADDR_BOOT_SIZE)
-
-/* Only covers 32bit vsyscalls currently. Need another set for 64bit. */
-#define FIXADDR_USER_START	((unsigned long)VSYSCALL32_VSYSCALL)
-#define FIXADDR_USER_END	(FIXADDR_USER_START + PAGE_SIZE)
-
-#endif /* _ASM_X86_FIXMAP_64_H */
-- 
1.5.6.4

