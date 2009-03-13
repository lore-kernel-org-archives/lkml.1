Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZCMW76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZCMW76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZCMW7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:59:48 -0400
Received: from gw.goop.org ([64.81.55.164]:36021 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbZCMW7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:59:47 -0400
Message-ID: <49BAE55F.40406@goop.org>
Date: Fri, 13 Mar 2009 15:59:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: add brk allocator for very early allocations
References: <49B7EDF4.7060904@goop.org> <49B800B8.2040009@kernel.org> <49B9A1CD.5040704@goop.org> <49B9AC7F.9030302@kernel.org> <49BAC1B0.6050107@goop.org> <49BAE210.7090300@zytor.com>
In-Reply-To: <49BAE210.7090300@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Those references are just the actual reservation of memory.  If all 
> the users of that memory are converted to either brk or bss, 
> INIT_MAP_BEYOND_END should be removed.  If all the users of that 
> memory aren't converted to brk to bss, we should do so.

I just added an adapted Yinghai's patch and added it to push/x86/brk.

    J


The following changes since commit 8131667360004a0b74e4dcadfee8a18d4e2b074f:
  Jeremy Fitzhardinge (1):
        x86: allow extend_brk users to reserve brk space

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/x86/brk

Yinghai Lu (1):
      x86: put initial_pg_tables into .bss -v4

 arch/x86/kernel/head_32.S        |   47 ++++++++++++++-----------------------
 arch/x86/kernel/vmlinux_32.lds.S |    6 +++++
 2 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 80dc05e..ad7dbbb 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -38,42 +38,30 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.
- * We need:
- *  - one bit for each possible page, but only in low memory, which means
- *     2^32/4096/8 = 128K worst case (4G/4G split.)
+ * This is how much memory for page table to and including _end
+ * we need mapped initially.
  *  - enough space to map all low memory, which means
- *     (2^32/4096) / 1024 pages (worst case, non PAE)
- *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
- *  - a few pages for allocator use before the kernel pagetable has
- *     been set up
+ *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
+ *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)
  *
  * Modulo rounding, each megabyte assigned here requires a kilobyte of
  * memory, which is currently unreclaimed.
  *
  * This should be a multiple of a page.
+ *
+ * KERNEL_IMAGE_SIZE should be greater than pa(_end)
+ * and small than max_low_pfn, otherwise will waste some page table entries
  */
 LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
 
-/*
- * To preserve the DMA pool in PAGEALLOC kernels, we'll allocate
- * pagetables from above the 16MB DMA limit, so we'll have to set
- * up pagetables 16MB more (worst-case):
- */
-#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
-LOW_PAGES = LOW_PAGES + 0x1000000
-#endif
-
 #if PTRS_PER_PMD > 1
 PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
 #else
 PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
 #endif
-BOOTBITMAP_SIZE = LOW_PAGES / 8
 ALLOCATOR_SLOP = 4
 
-INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + (PAGE_TABLE_SIZE + ALLOCATOR_SLOP)*PAGE_SIZE_asm
+INIT_MAP_SIZE = (PAGE_TABLE_SIZE + ALLOCATOR_SLOP) * PAGE_SIZE_asm
 
 RESERVE_BRK(pagetables, PAGE_TABLE_SIZE * PAGE_SIZE)
 
@@ -168,10 +156,10 @@ num_subarch_entries = (. - subarch_entries) / 4
 
 /*
  * Initialize page tables.  This creates a PDE and a set of page
- * tables, which are located immediately beyond _end.  The variable
+ * tables, which are located immediately beyond __brk_base.  The variable
  * _brk_end is set up to point to the first "safe" location.
  * Mappings are created both at virtual address 0 (identity mapping)
- * and PAGE_OFFSET for up to _end+sizeof(page tables)+INIT_MAP_BEYOND_END.
+ * and PAGE_OFFSET for up to _end.
  *
  * Note that the stack is not yet set up!
  */
@@ -210,10 +198,9 @@ default_entry:
 	loop 11b
 
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables.
+	 * End condition: we must map up to the end.
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $pa(_end) + PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
@@ -243,11 +230,9 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	addl $0x1000,%eax
 	loop 11b
 	/*
-	 * End condition: we must map up to and including INIT_MAP_BEYOND_END
-	 * bytes beyond the end of our own page tables; the +0x007 is
-	 * the attribute bits
+	 * End condition: we must map up to end
 	 */
-	leal (INIT_MAP_BEYOND_END+PTE_IDENT_ATTR)(%edi),%ebp
+	movl $pa(_end) + PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 	addl $__PAGE_OFFSET, %edi
@@ -638,6 +623,10 @@ swapper_pg_fixmap:
 	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
+
+.section ".bss.extra_page_aligned","wa"
+	.align PAGE_SIZE_asm
+	.fill INIT_MAP_SIZE,1,0
 /*
  * This starts the data section.
  */
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 4005279..c318dee 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -210,6 +210,12 @@ SECTIONS
   DWARF_DEBUG
 }
 
+/*
+ * Build-time check on the image size:
+ */
+ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+	"kernel image bigger than KERNEL_IMAGE_SIZE")
+
 #ifdef CONFIG_KEXEC
 /* Link time checks */
 #include <asm/kexec.h>

