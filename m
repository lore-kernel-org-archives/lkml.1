Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbYE1ODB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbYE1ODB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYE1OCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:02:53 -0400
Received: from gw.goop.org ([64.81.55.164]:47739 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYE1OCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:02:52 -0400
Message-ID: <483D65E6.3020604@goop.org>
Date: Wed, 28 May 2008 15:02:14 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       x86@kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [bisected] Re: [PATCH 05 of 12] xen: add p2m mfn_list_list
References: <patchbomb.1211550067@localhost> <a405e5f9ddf6f5f142ea.1211550072@localhost> <20080528122813.GA5502@elte.hu>
In-Reply-To: <20080528122813.GA5502@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> When saving a domain, the Xen tools need to remap all our mfns to 
>> portable pfns.  In order to remap our p2m table, it needs to know 
>> where all its pages are, so maintain the references to the p2m table 
>> for it to use.
>>     
>
> -tip tree auto-testing found the following early bootup hang:
>
> -------------->
> get_memcfg_from_srat: assigning address to rsdp
> RSD PTR  v0 [Nvidia]
> BUG: Int 14: CR2 ffd00040
>      EDI 8092fbfe  ESI ffd00040  EBP 80b0aee8  ESP 80b0aed0
>      EBX 000f76f0  EDX 0000000e  ECX 00000003  EAX ffd00040
>      err 00000000  EIP 802c055a   CS 00000060  flg 00010006
> Stack: ffd00040 80bc78d0 80b0af6c 80b1dbfe 8093d8ba 00000008 80b42810 80b4ddb4
>        80b42842 00000000 80b0af1c 801079c8 808e724e 00000000 80b42871 802c0531
>        00000100 00000000 0003fff0 80b0af40 80129999 00040100 00040100 00000000
> Pid: 0, comm: swapper Not tainted 2.6.26-rc4-sched-devel.git #570
>  [<802c055a>] ? strncmp+0x11/0x25
>  [<80b1dbfe>] ? get_memcfg_from_srat+0xb4/0x568
>  [<801079c8>] ? mcount_call+0x5/0x9
>  [<802c0531>] ? strcmp+0xa/0x22
>  [<80129999>] ? printk+0x38/0x3a
>  [<80129999>] ? printk+0x38/0x3a
>  [<8011b122>] ? memory_present+0x66/0x6f
>  [<80b216b4>] ? setup_memory+0x13/0x40c
>  [<80b16b47>] ? propagate_e820_map+0x80/0x97
>  [<80b1622a>] ? setup_arch+0x248/0x477
>  [<80129999>] ? printk+0x38/0x3a
>  [<80b11759>] ? start_kernel+0x6e/0x2eb
>  [<80b110fc>] ? i386_start_kernel+0xeb/0xf2
>  =======================
> <------
>
> with this config:
>
>    http://redhat.com/~mingo/misc/config-Wed_May_28_01_33_33_CEST_2008.bad
>
> The thing is, the crash makes little sense at first sight. We crash on a 
> benign-looking printk. The code around it got changed in -tip but 
> checking those topic branches individually did not reproduce the bug.
>
> Bisection led to this commit:
>
> |   d5edbc1f75420935b1ec7e65df10c8f81cea82de is first bad commit
> |   commit d5edbc1f75420935b1ec7e65df10c8f81cea82de
> |   Author: Jeremy Fitzhardinge <jeremy@goop.org>
> |   Date:   Mon May 26 23:31:22 2008 +0100
> |
> |   xen: add p2m mfn_list_list
>
> Which is somewhat surprising, as on native hardware Xen client side 
> should have little to no side-effects.
>
> After some head scratching, it turns out the following happened: 
> randconfig enabled the following Xen options:
>
>   CONFIG_XEN=y
>   CONFIG_XEN_MAX_DOMAIN_MEMORY=8
>   # CONFIG_XEN_BLKDEV_FRONTEND is not set
>   # CONFIG_XEN_NETDEV_FRONTEND is not set
>   CONFIG_HVC_XEN=y
>   # CONFIG_XEN_BALLOON is not set
>
> which activated this piece of code in arch/x86/xen/mmu.c:
>
>   
>> @@ -69,6 +69,13 @@
>>  	__attribute__((section(".data.page_aligned"))) =
>>  		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
>>  
>> +/* Arrays of p2m arrays expressed in mfns used for save/restore */
>> +static unsigned long p2m_top_mfn[TOP_ENTRIES]
>> +	__attribute__((section(".bss.page_aligned")));
>> +
>> +static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
>> +	__attribute__((section(".bss.page_aligned")));
>>     
>
> The problem is, you must only put variables into .bss.page_aligned that 
> have a _size_ that is _exactly_ page aligned. In this case the size of 
> p2m_top_mfn_list is not page aligned:
>
>  80b8d000 b p2m_top_mfn
>  80b8f000 b p2m_top_mfn_list
>  80b8f008 b softirq_stack
>  80b97008 b hardirq_stack
>  80b9f008 b bm_pte
>
> So all subsequent variables get unaligned which, depending on luck, 
> breaks the kernel in various funny ways. In this case what killed the 
> kernel first was the misaligned bootmap pte page, resulting in that 
> creative crash above.
>
> Anyway, this was a fun bug to track down :-)
>   

Thanks for that. That's pretty subtle...

> I think the moral is that .bss.page_aligned is a dangerous construct in 
> its current form, and the symptoms of breakage are very non-trivial, so 
> i think we need build-time checks to make sure all symbols in 
> .bss.page_aligned are truly page aligned.
>
> Sam, any ideas how to accomplish that best?
>   

The use of __section(.data.page_aligned) (or worse 
__attribute__((section(".data.page_aligned"))) is fairly verbose and 
brittle. I've got a (totally untested) proposed patch below, to 
introduce __page_aligned_data|bss which sets the section and the 
alignment. This will work, but it requires that all page-aligned 
variables also have an alignment associated with them, so that mis-sized 
ones don't push the others around.

There aren't very many users of .data|bss.page_aligned, so it should be 
easy enough to fix them all up.

A link-time warning would be good too, of course.

> The Xen fix below gets the kernel booting again. I suspect we really 
> need this list to stay in its separate page due to Xen assumptions, even 
> though it's only 8 bytes large?
>   

Yes, that's right. It can never get to page size, but it must be on its 
own page because its only ever referred to by page number; these pages 
are read from outside the VM when doing save/restore.

> 	Ingo
>
> ---
>  arch/x86/xen/mmu.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Index: linux/arch/x86/xen/mmu.c
> ===================================================================
> --- linux.orig/arch/x86/xen/mmu.c
> +++ linux/arch/x86/xen/mmu.c
> @@ -73,7 +73,8 @@ static unsigned long *p2m_top[TOP_ENTRIE
>  static unsigned long p2m_top_mfn[TOP_ENTRIES]
>  	__attribute__((section(".bss.page_aligned")));
>  
> -static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
> +static unsigned long p2m_top_mfn_list[
> +			PAGE_ALIGN(TOP_ENTRIES / P2M_ENTRIES_PER_PAGE)]
>  	__attribute__((section(".bss.page_aligned")));
>   

That's a bit severe - it expands it to 4 pages ;)

J


Subject: make page-aligned data and bss less fragile

Making a variable page-aligned by using
__attribute__((section(".data.page_aligned"))) is fragile because if
sizeof(variable) is not also a multiple of page size, it leaves
variables in the remainder of the section unaligned.

This patch introduces two new qualifiers, __page_aligned_data and
__page_aligned_bss to set the section *and* the alignment of
variables.  This makes page-aligned variables more robust because the
linker will make sure they're aligned properly.  Unfortunately it
requires *all* page-aligned data to use these macros...

---
 arch/x86/kernel/irq_32.c  |    7 ++-----
 arch/x86/kernel/setup64.c |    2 +-
 arch/x86/mm/ioremap.c     |    3 +--
 arch/x86/xen/mmu.c        |   12 +++++-------
 include/linux/linkage.h   |    4 ++++
 5 files changed, 13 insertions(+), 15 deletions(-)

===================================================================
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -83,11 +83,8 @@
 static union irq_ctx *hardirq_ctx[NR_CPUS] __read_mostly;
 static union irq_ctx *softirq_ctx[NR_CPUS] __read_mostly;
 
-static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
-
-static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+static char softirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
+static char hardirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
 
 static void call_on_stack(void *func, void *stack)
 {
===================================================================
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -40,7 +40,7 @@
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.page_aligned")));
+char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
 
 unsigned long __supported_pte_mask __read_mostly = ~0UL;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
===================================================================
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -403,8 +403,7 @@
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
 static __initdata int after_paging_init;
-static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
-		__section(.bss.page_aligned);
+static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)] __page_aligned_bss;
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -46,6 +46,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/paravirt.h>
+#include <asm/linkage.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -60,21 +61,18 @@
 #define TOP_ENTRIES		(MAX_DOMAIN_PAGES / P2M_ENTRIES_PER_PAGE)
 
 /* Placeholder for holes in the address space */
-static unsigned long p2m_missing[P2M_ENTRIES_PER_PAGE]
-	__attribute__((section(".data.page_aligned"))) =
+static unsigned long p2m_missing[P2M_ENTRIES_PER_PAGE] __page_aligned_data =
 		{ [ 0 ... P2M_ENTRIES_PER_PAGE-1 ] = ~0UL };
 
  /* Array of pointers to pages containing p2m entries */
-static unsigned long *p2m_top[TOP_ENTRIES]
-	__attribute__((section(".data.page_aligned"))) =
+static unsigned long *p2m_top[TOP_ENTRIES] __page_aligned_data =
 		{ [ 0 ... TOP_ENTRIES - 1] = &p2m_missing[0] };
 
 /* Arrays of p2m arrays expressed in mfns used for save/restore */
-static unsigned long p2m_top_mfn[TOP_ENTRIES]
-	__attribute__((section(".bss.page_aligned")));
+static unsigned long p2m_top_mfn[TOP_ENTRIES] __page_aligned_bss;
 
 static unsigned long p2m_top_mfn_list[TOP_ENTRIES / P2M_ENTRIES_PER_PAGE]
-	__attribute__((section(".bss.page_aligned")));
+	__page_aligned_bss;
 
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
===================================================================
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_LINKAGE_H
 #define _LINUX_LINKAGE_H
 
+#include <linux/compiler.h>
 #include <asm/linkage.h>
 
 #define notrace __attribute__((no_instrument_function))
@@ -18,6 +19,9 @@
 #ifndef asmregparm
 # define asmregparm
 #endif
+
+#define __page_aligned_data	__section(.data.page_aligned) __aligned(PAGE_SIZE)
+#define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
 
 /*
  * This is used by architectures to keep arguments on the stack


