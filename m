Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYEJPd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYEJPd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 11:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYEJPdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 11:33:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:40193 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYEJPdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 11:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=fZt/CGw55Fqw7oapc+s3+IIQKN3V7J8x0TSL4EHZZoDQSy4jbGNHaBLs7ir84augyuMuZGWVhH+wRGxw8PduXyIPILO3CIWMn/l7+om4EH6WSZ26rav9gS3/0Aon1lSxvmJUER2UnSpiIY4OqQHdvUVDg8CpHYHOMZUt1dk0wXM=
Date: Sat, 10 May 2008 17:33:08 +0200
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: use set_memory_4k() instead of disabling PSE
Message-ID: <20080510153307.GA28901@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With this, we reduce the overall impact of kmemcheck by reverting some
earlier, now unnecessary, changes:

  Documentation/kmemcheck.txt  |  101 +++++
  MAINTAINERS                  |    8 +
  arch/x86/Kconfig.debug       |   87 ++++
  arch/x86/kernel/Makefile     |    2 +
- arch/x86/kernel/cpu/common.c |    7 +
  arch/x86/kernel/entry_32.S   |    8 +-
  arch/x86/kernel/entry_64.S   |    4 +-
- arch/x86/kernel/head_32.S    |    2 +-
- arch/x86/kernel/kmemcheck.c  |  964 ++++++++++++++++++++++++++++++++++++++++++
+ arch/x86/kernel/kmemcheck.c  |  963 ++++++++++++++++++++++++++++++++++++++++++
  arch/x86/kernel/process.c    |    2 +-
  arch/x86/kernel/process_32.c |    4 +-
  arch/x86/kernel/process_64.c |   12 +-
  arch/x86/kernel/traps_32.c   |   18 +-
  arch/x86/kernel/traps_64.c   |   16 +-
- arch/x86/mm/fault.c          |   25 +-
- arch/x86/mm/init_32.c        |    2 +-
+ arch/x86/mm/fault.c          |   35 ++
  include/asm-x86/kdebug.h     |    3 +-
  include/asm-x86/kmemcheck.h  |   30 ++
  include/asm-x86/pgtable.h    |    4 +-
  include/asm-x86/pgtable_32.h |    6 +
  include/asm-x86/pgtable_64.h |    6 +
  include/asm-x86/string_32.h  |    8 +
  include/asm-x86/string_64.h  |    1 +
  include/linux/gfp.h          |    3 +-
  include/linux/kmemcheck.h    |   61 +++
  include/linux/mm_types.h     |    4 +
  include/linux/slab.h         |    7 +
  include/linux/slab_def.h     |   81 ++++
  init/main.c                  |    2 +
  kernel/fork.c                |   16 +-
  kernel/sysctl.c              |   12 +
  mm/Makefile                  |    2 +-
  mm/kmemcheck.c               |   97 +++++
  mm/slab.c                    |  101 +----
  mm/slub.c                    |   17 +-
- 35 files changed, 1601 insertions(+), 122 deletions(-)
+ 32 files changed, 1605 insertions(+), 116 deletions(-)

which is probably a good thing if it is ever merged into mainline :-)

See patch description for more info.

Vegard


>From 648611a899fd61df8f44b6f78c2700a460913d67 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 10 May 2008 17:19:33 +0200
Subject: [PATCH] kmemcheck: use set_memory_4k() instead of disabling PSE

Thanks a bunch to Andi Kleen for this brilliant solution. Now all pages
that kmemcheck handle will be 4k in size, and we need no special-case code
to handle larger pages.

This will also greatly help the upcoming 64-bit support.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/cpu/common.c |    7 ------
 arch/x86/kernel/head_32.S    |    2 +-
 arch/x86/kernel/kmemcheck.c  |    9 +++----
 arch/x86/mm/fault.c          |   44 +++++++++++++++++++++++++++++------------
 arch/x86/mm/init_32.c        |    2 +-
 5 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 39933f6..35b4f6a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -651,13 +651,6 @@ void __init early_cpu_init(void)
 		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
 
 	early_cpu_detect();
-
-#ifdef CONFIG_KMEMCHECK
-	/*
-	 * We need 4K granular PTEs for kmemcheck:
-	 */
-	setup_clear_cpu_cap(X86_FEATURE_PSE);
-#endif
 }
 
 /* Make sure %fs is initialized properly in idle threads */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index c41ca7d..b2cc737 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -60,7 +60,7 @@ LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
  * pagetables from above the 16MB DMA limit, so we'll have to set
  * up pagetables 16MB more (worst-case):
  */
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
+#ifdef CONFIG_DEBUG_PAGEALLOC
 LOW_PAGES = LOW_PAGES + 0x1000000
 #endif
 
diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
index 7412a80..752a2d1 100644
--- a/arch/x86/kernel/kmemcheck.c
+++ b/arch/x86/kernel/kmemcheck.c
@@ -488,9 +488,7 @@ kmemcheck_show_pages(struct page *p, unsigned int n)
 		address = (unsigned long) page_address(&p[i]);
 		pte = lookup_address(address, &level);
 		BUG_ON(!pte);
-
-		if (level != PG_LEVEL_4K)
-			continue;
+		BUG_ON(level != PG_LEVEL_4K);
 
 		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
 		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_HIDDEN));
@@ -510,6 +508,8 @@ kmemcheck_hide_pages(struct page *p, unsigned int n)
 {
 	unsigned int i;
 
+	set_memory_4k((unsigned long) page_address(p), n);
+
 	for (i = 0; i < n; ++i) {
 		unsigned long address;
 		pte_t *pte;
@@ -518,8 +518,7 @@ kmemcheck_hide_pages(struct page *p, unsigned int n)
 		address = (unsigned long) page_address(&p[i]);
 		pte = lookup_address(address, &level);
 		BUG_ON(!pte);
-		if (level != PG_LEVEL_4K)
-			continue;
+		BUG_ON(level != PG_LEVEL_4K);
 
 		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
 		set_pte(pte, __pte(pte_val(*pte) | _PAGE_HIDDEN));
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 694a0b0..bde2361 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -492,8 +492,7 @@ static int spurious_fault(unsigned long address,
  *
  * This assumes no large pages in there.
  */
-static int vmalloc_fault(struct pt_regs *regs, unsigned long address,
-	unsigned long error_code)
+static int vmalloc_fault(unsigned long address)
 {
 #ifdef CONFIG_X86_32
 	unsigned long pgd_paddr;
@@ -510,17 +509,10 @@ static int vmalloc_fault(struct pt_regs *regs, unsigned long address,
 	pmd_k = vmalloc_sync_one(__va(pgd_paddr), address);
 	if (!pmd_k)
 		return -1;
+
 	pte_k = pte_offset_kernel(pmd_k, address);
-	if (!pte_present(*pte_k)) {
-		if (!pte_hidden(*pte_k))
-			return -1;
-
-		if (error_code & 2)
-			kmemcheck_access(regs, address, KMEMCHECK_WRITE);
-		else
-			kmemcheck_access(regs, address, KMEMCHECK_READ);
-		kmemcheck_show(regs);
-	}
+	if (!pte_present(*pte_k))
+		return -1;
 	return 0;
 #else
 	pgd_t *pgd, *pgd_ref;
@@ -573,6 +565,29 @@ static int vmalloc_fault(struct pt_regs *regs, unsigned long address,
 #endif
 }
 
+static bool kmemcheck_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
+{
+	pte_t *pte;
+	unsigned int level;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return false;
+	if (level != PG_LEVEL_4K)
+		return false;
+	if (!pte_hidden(*pte))
+		return false;
+
+	if (error_code & 2)
+		kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+	else
+		kmemcheck_access(regs, address, KMEMCHECK_READ);
+
+	kmemcheck_show(regs);
+	return true;
+}
+
 int show_unhandled_signals = 1;
 
 /*
@@ -638,7 +653,10 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(address >= TASK_SIZE64)) {
 #endif
 		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(regs, address, error_code) >= 0)
+		    vmalloc_fault(address) >= 0)
+			return;
+
+		if (kmemcheck_fault(regs, address, error_code))
 			return;
 
 		/* Can handle a stale RO->RW TLB */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 806c6aa..de236e4 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -92,7 +92,7 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
 		pte_t *page_table = NULL;
 
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
+#ifdef CONFIG_DEBUG_PAGEALLOC
 		page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
 #endif
 		if (!page_table) {
-- 
1.5.4.1

