Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYCRFZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYCRFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYCRFYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:13 -0400
Received: from gw.goop.org ([64.81.55.164]:37843 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbYCRFYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 22 of 31] x86: unify KERNEL_PGD_PTRS
X-Mercurial-Node: a75818f2d2cccec8e757b32dbd62e6a3e37db757
Message-Id: <a75818f2d2cccec8e757.1205797033@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>,
       Andi Kleen <ak@suse.de>, Zach Amsden <zach@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make KERNEL_PGD_PTRS common, as previously it was only being defined
for 32-bit.

There are a couple of follow-on changes from this:
 - KERNEL_PGD_PTRS was being defined in terms of USER_PGD_PTRS.  The
   definition of USER_PGD_PTRS doesn't really make much sense on x86-64,
   since it can have two different user address-space configurations.
   I renamed USER_PGD_PTRS to KERNEL_PGD_BOUNDARY, which is meaningful
   for all of 32/32, 32/64 and 64/64 process configurations.

 - USER_PTRS_PER_PGD was also defined and was being used for similar
   purposes.  Converting its users to KERNEL_PGD_BOUNDARY left it
   completely unused, and so I removed it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Zach Amsden <zach@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/reboot.c            |    4 ++--
 arch/x86/kernel/smpboot_32.c        |    4 ++--
 arch/x86/kernel/vmi_32.c            |    2 +-
 arch/x86/mach-voyager/voyager_smp.c |    4 ++--
 arch/x86/mm/init_32.c               |    2 +-
 arch/x86/mm/pgtable.c               |   12 ++++++------
 include/asm-x86/pgtable.h           |    4 +++-
 include/asm-x86/pgtable_32.h        |    3 ---
 8 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -8,6 +8,7 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
+#include <asm/pgtable.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
 
@@ -15,7 +16,6 @@
 # include <linux/dmi.h>
 # include <linux/ctype.h>
 # include <linux/mc146818rtc.h>
-# include <asm/pgtable.h>
 #else
 # include <asm/iommu.h>
 #endif
@@ -266,7 +266,7 @@
 	/* Remap the kernel at virtual address zero, as well as offset zero
 	   from the kernel segment.  This assumes the kernel segment starts at
 	   virtual address PAGE_OFFSET. */
-	memcpy(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
+	memcpy(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 		sizeof(swapper_pg_dir [0]) * KERNEL_PGD_PTRS);
 
 	/*
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -782,8 +782,8 @@
 	INIT_WORK(&info.task, do_warm_boot_cpu);
 
 	/* init low mem mapping */
-	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
-			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
+	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+			min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
 	flush_tlb_all();
 	schedule_work(&info.task);
 	wait_for_completion(&done);
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -320,7 +320,7 @@
 	 * pdes need to be zeroed.
 	 */
 	if (type & VMI_PAGE_CLONE)
-		limit = USER_PTRS_PER_PGD;
+		limit = KERNEL_PGD_BOUNDARY;
 	for (i = 0; i < limit; i++)
 		BUG_ON(ptr[i]);
 }
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -566,8 +566,8 @@
 		hijack_source.idt.Offset, stack_start.sp));
 
 	/* init lowmem identity mapping */
-	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
-			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
+	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+			min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
 	flush_tlb_all();
 
 	if (quad_boot) {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -467,7 +467,7 @@
 	 * Note that "pgd_clear()" doesn't do it for
 	 * us, because pgd_clear() is a no-op on i386.
 	 */
-	for (i = 0; i < USER_PTRS_PER_PGD; i++) {
+	for (i = 0; i < KERNEL_PGD_BOUNDARY; i++) {
 #ifdef CONFIG_X86_PAE
 		set_pgd(swapper_pg_dir+i, __pgd(1 + __pa(empty_zero_page)));
 #else
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -104,7 +104,7 @@
  * -- wli
  */
 #define UNSHARED_PTRS_PER_PGD				\
-	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
+	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
 static void pgd_ctor(void *p)
 {
@@ -112,7 +112,7 @@
 	unsigned long flags;
 
 	/* Clear usermode parts of PGD */
-	memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
+	memset(pgd, 0, KERNEL_PGD_BOUNDARY*sizeof(pgd_t));
 
 	spin_lock_irqsave(&pgd_lock, flags);
 
@@ -121,12 +121,12 @@
 	   references from swapper_pg_dir. */
 	if (PAGETABLE_LEVELS == 2 ||
 	    (PAGETABLE_LEVELS == 3 && SHARED_KERNEL_PMD)) {
-		clone_pgd_range(pgd + USER_PTRS_PER_PGD,
-				swapper_pg_dir + USER_PTRS_PER_PGD,
+		clone_pgd_range(pgd + KERNEL_PGD_BOUNDARY,
+				swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 				KERNEL_PGD_PTRS);
 		paravirt_alloc_pmd_clone(__pa(pgd) >> PAGE_SHIFT,
 					 __pa(swapper_pg_dir) >> PAGE_SHIFT,
-					 USER_PTRS_PER_PGD,
+					 KERNEL_PGD_BOUNDARY,
 					 KERNEL_PGD_PTRS);
 	}
 
@@ -201,7 +201,7 @@
 			return 0;
 		}
 
-		if (i >= USER_PTRS_PER_PGD)
+		if (i >= KERNEL_PGD_BOUNDARY)
 			memcpy(pmd, (pmd_t *)pgd_page_vaddr(swapper_pg_dir[i]),
 			       sizeof(pmd_t) * PTRS_PER_PMD);
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_PGTABLE_H
 #define _ASM_X86_PGTABLE_H
 
-#define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
 #define FIRST_USER_ADDRESS	0
 
 #define _PAGE_BIT_PRESENT	0
@@ -240,6 +239,9 @@
 # include "pgtable_64.h"
 #endif
 
+#define KERNEL_PGD_BOUNDARY	pgd_index(PAGE_OFFSET)
+#define KERNEL_PGD_PTRS		(PTRS_PER_PGD - KERNEL_PGD_BOUNDARY)
+
 #ifndef __ASSEMBLY__
 
 enum {
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -47,9 +47,6 @@
 
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
-
-#define USER_PGD_PTRS (PAGE_OFFSET >> PGDIR_SHIFT)
-#define KERNEL_PGD_PTRS (PTRS_PER_PGD-USER_PGD_PTRS)
 
 /* Just any arbitrary offset to the start of the vmalloc VM area: the
  * current 8MB value just means that there will be a 8MB "hole" after the


