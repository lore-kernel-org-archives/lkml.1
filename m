Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZDIFmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZDIFmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbZDIFiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:38:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58085
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759048AbZDIFiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:38:04 -0400
Date: Wed, 08 Apr 2009 22:37:53 -0700 (PDT)
Message-Id: <20090408.223753.57010559.davem@davemloft.net>
To: tj@kernel.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12]: sparc64: Get rid of real_setup_per_cpu_areas().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we defer the cpu_data() initializations to the end of per-cpu
setup, we can get rid of this local hack we had to setup the per-cpu
areas eary.

This is a necessary step in order to support HAVE_DYNAMIC_PER_CPU_AREA
since the per-cpu setup must run when page structs are available.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/percpu_64.h |    4 ----
 arch/sparc/kernel/smp_64.c         |   11 +++++------
 arch/sparc/mm/init_64.c            |    7 -------
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/sparc/include/asm/percpu_64.h b/arch/sparc/include/asm/percpu_64.h
index c0ab102..007aafb 100644
--- a/arch/sparc/include/asm/percpu_64.h
+++ b/arch/sparc/include/asm/percpu_64.h
@@ -9,8 +9,6 @@ register unsigned long __local_per_cpu_offset asm("g5");
 
 #include <asm/trap_block.h>
 
-extern void real_setup_per_cpu_areas(void);
-
 #define __per_cpu_offset(__cpu) \
 	(trap_block[(__cpu)].__per_cpu_base)
 #define per_cpu_offset(x) (__per_cpu_offset(x))
@@ -19,8 +17,6 @@ extern void real_setup_per_cpu_areas(void);
 
 #else /* ! SMP */
 
-#define real_setup_per_cpu_areas()		do { } while (0)
-
 #endif	/* SMP */
 
 #include <asm-generic/percpu.h>
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 73f5538..af0b28e 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -20,7 +20,7 @@
 #include <linux/cache.h>
 #include <linux/jiffies.h>
 #include <linux/profile.h>
-#include <linux/lmb.h>
+#include <linux/bootmem.h>
 #include <linux/cpu.h>
 
 #include <asm/head.h>
@@ -1371,9 +1371,9 @@ void smp_send_stop(void)
 {
 }
 
-void __init real_setup_per_cpu_areas(void)
+void __init setup_per_cpu_areas(void)
 {
-	unsigned long base, shift, paddr, goal, size, i;
+	unsigned long base, shift, goal, size, i;
 	char *ptr;
 
 	/* Copy section for each CPU (we discard the original) */
@@ -1383,13 +1383,12 @@ void __init real_setup_per_cpu_areas(void)
 	for (size = PAGE_SIZE; size < goal; size <<= 1UL)
 		shift++;
 
-	paddr = lmb_alloc(size * NR_CPUS, PAGE_SIZE);
-	if (!paddr) {
+	ptr = __alloc_bootmem(size * NR_CPUS, PAGE_SIZE, 0);
+	if (!ptr) {
 		prom_printf("Cannot allocate per-cpu memory.\n");
 		prom_halt();
 	}
 
-	ptr = __va(paddr);
 	base = ptr - __per_cpu_start;
 
 	for (i = 0; i < NR_CPUS; i++, ptr += size) {
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 785f0a2..b5a5932 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1679,11 +1679,6 @@ pgd_t swapper_pg_dir[2048];
 static void sun4u_pgprot_init(void);
 static void sun4v_pgprot_init(void);
 
-/* Dummy function */
-void __init setup_per_cpu_areas(void)
-{
-}
-
 void __init paging_init(void)
 {
 	unsigned long end_pfn, shift, phys_base;
@@ -1807,8 +1802,6 @@ void __init paging_init(void)
 		mdesc_populate_present_mask(CPU_MASK_ALL_PTR);
 	}
 
-	real_setup_per_cpu_areas();
-
 	/* Once the OF device tree and MDESC have been setup, we know
 	 * the list of possible cpus.  Therefore we can allocate the
 	 * IRQ stacks.
-- 
1.6.2.2

