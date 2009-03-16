Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbZCPT0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbZCPT0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbZCPTZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:25:55 -0400
Received: from gw.goop.org ([64.81.55.164]:39596 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbZCPTZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:25:54 -0400
Message-ID: <49BEA7BE.6050400@goop.org>
Date: Mon, 16 Mar 2009 12:25:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97D5.4010002@zytor.com>
In-Reply-To: <49BE97D5.4010002@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> Yinghai Lu wrote:
>>> could be max_pfn_mapped change in head_32.S that reduce mapping 
>>> range to _end only.
>>>   
>>
>> Yes, I would say you're right.  Trimming the mapping to _end only 
>> leaves the space under the kernel avaliable for allocating pagetable 
>> from e820 space.  In this case we've got DEBUG_PAGEALLOC enabled, 
>> which inhibits the use of PSE, and BIOS corruption checking on, which 
>> eats a chunk of low memory.  In combination, there's only 0x8f000 
>> bytes free below the kernel, and it needs 0xe1000 to allocate for 
>> pagetables.
>>
>> Reverting 2bd2753ff46346543ab92e80df9d96366e21baa5 fixes the problem 
>> for me, though it does result in a kernel with a 73MB BSS...
>>
>
> Waitaminute... there is no way we could end up with 73 MB page tables 
> unless something is seriously screwy.  Even with PAE and !PSE, we only 
> get 2 MB worth of page tables for each 1 GB mapped -- even with a 4:4 
> scheme this is only 8 MB.

Yes, something odd happened there.

Anyway, this patch fixes it.  I also removed ALLOCATOR_SLOP, because it 
is left over from when we used the bootmem allocator for the linear 
mapping pagetable, before using e820 allocation.

Did you also want to pull the changes to put the brk in .brk and rename 
the reservation symbols?

    J

The following changes since commit 2bd2753ff46346543ab92e80df9d96366e21baa5:
  Yinghai Lu (1):
        x86: put initial_pg_tables into .bss

are available in the git repository at:

  ssh://master.kernel.org/~jeremy/git/xen.git tip/x86/setup-memory

Jeremy Fitzhardinge (2):
      x86-32: make sure we map enough to fit linear map pagetables
      x86-32: remove ALLOCATOR_SLOP from head_32.S

 arch/x86/kernel/head_32.S |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

>From 378c46828de3f34d94d83f08b2d6d81a0fc8f108 Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Mon, 16 Mar 2009 12:07:54 -0700
Subject: [PATCH] x86-32: make sure we map enough to fit linear map pagetables

head_32.S needs to map the kernel itself, and enough space so
that mm/init.c can allocate space from the e820 allocator
for the linear map of low memory.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index c79741c..e929619 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -38,8 +38,8 @@
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
 /*
- * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.
+ * This is how much memory in addition to the memory covered up to
+ * and including _end we need mapped initially.
  * We need:
  *     (KERNEL_IMAGE_SIZE/4096) / 1024 pages (worst case, non PAE)
  *     (KERNEL_IMAGE_SIZE/4096) / 512 + 4 pages (worst case for PAE)
@@ -52,19 +52,28 @@
  * KERNEL_IMAGE_SIZE should be greater than pa(_end)
  * and small than max_low_pfn, otherwise will waste some page table entries
  */
-LOW_PAGES = (KERNEL_IMAGE_SIZE + PAGE_SIZE_asm - 1)>>PAGE_SHIFT
 
 #if PTRS_PER_PMD > 1
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PMD) + PTRS_PER_PGD
+#define PAGE_TABLE_SIZE(pages) (((pages) / PTRS_PER_PMD) + PTRS_PER_PGD)
 #else
-PAGE_TABLE_SIZE = (LOW_PAGES / PTRS_PER_PGD)
+#define PAGE_TABLE_SIZE(pages) ((pages) / PTRS_PER_PGD)
 #endif
 ALLOCATOR_SLOP = 4
 
-INIT_MAP_SIZE = (PAGE_TABLE_SIZE + ALLOCATOR_SLOP) * PAGE_SIZE_asm
-RESERVE_BRK(pagetables, INIT_MAP_SIZE)
+/* Enough space to fit pagetables for the low memory linear map */
+MAPPING_BEYOND_END = (PAGE_TABLE_SIZE(1 << (32 - PAGE_SHIFT)) * PAGE_SIZE)
 
 /*
+ * Worst-case size of the kernel mapping we need to make:
+ * the worst-case size of the kernel itself, plus the extra we need
+ * to map for the linear map.
+ */
+KERNEL_PAGES = (KERNEL_IMAGE_SIZE + MAPPING_BEYOND_END)>>PAGE_SHIFT
+
+INIT_MAP_SIZE = (PAGE_TABLE_SIZE(KERNEL_PAGES) + ALLOCATOR_SLOP) * PAGE_SIZE_asm
+RESERVE_BRK(pagetables, INIT_MAP_SIZE)
+	
+/*
  * 32-bit kernel entrypoint; only used by the boot CPU.  On entry,
  * %esi points to the real-mode code as a 32-bit pointer.
  * CS and DS must be 4 GB flat segments, but we don't depend on
@@ -197,9 +206,9 @@ default_entry:
 	loop 11b
 
 	/*
-	 * End condition: we must map up to the end.
+	 * End condition: we must map up to the end + MAPPING_BEYOND_END.
 	 */
-	movl $pa(_end) + PTE_IDENT_ATTR, %ebp
+	movl $pa(_end) + MAPPING_BEYOND_END + PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 1:
@@ -229,9 +238,9 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	addl $0x1000,%eax
 	loop 11b
 	/*
-	 * End condition: we must map up to end
+	 * End condition: we must map up to the end + MAPPING_BEYOND_END.
 	 */
-	movl $pa(_end) + PTE_IDENT_ATTR, %ebp
+	movl $pa(_end) + MAPPING_BEYOND_END + PTE_IDENT_ATTR, %ebp
 	cmpl %ebp,%eax
 	jb 10b
 	addl $__PAGE_OFFSET, %edi


