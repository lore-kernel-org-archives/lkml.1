Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbZCBRCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbZCBRCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZCBRCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:02:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45740 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbZCBRB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:01:59 -0500
Message-ID: <49AC10E9.1090102@redhat.com>
Date: Mon, 02 Mar 2009 12:01:29 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC][PATCH] x86: make text_poke() atomic
References: <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com> <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com>
In-Reply-To: <49A853CD.3020607@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Mathieu Desnoyers wrote:
>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>> Mathieu Desnoyers wrote:
>>>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>>>> Steven Rostedt wrote:
>>>>>> On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
>>>>>>>> Hmm, lets see. I simply set a bit in the PTE mappings. There's not many, 
>>>>>>>> since a lot are 2M pages, for x86_64. Call stop_machine, and now I can 
>>>>>>>> modify 1 or 20,000 locations. Set the PTE bit back. Note, the changing of 
>>>>>>>> the bits are only done when CONFIG_DEBUG_RODATA is set.
>>>>>>>>
>>>>>>>> text_poke requires allocating a page. Map the page into memory. Set up a 
>>>>>>>> break point.
>>>>>>> text_poke does not _require_ a break point. text_poke can work with
>>>>>>> stop_machine.
>>>>>> It can? Doesn't text_poke require allocating pages? The code called by 
>>>>>> stop_machine is all atomic. vmap does not give an option to allocate with 
>>>>>> GFP_ATOMIC.
>>>>> Hi,
>>>>>
>>>>> With my patch, text_poke() never allocate pages any more :)
>>>>>
>>>>> BTW, IMHO, both of your methods are useful and have trade-off.
>>>>>
>>>>> ftrace wants to change massive amount of code at once. If we do
>>>>> that with text_poke(), we have to map/unmap pages each time and
>>>>> it will take a long time -- might be longer than one stop_machine_run().
>>>>>
>>>>> On the other hand, text_poke() user like as kprobes and tracepoints,
>>>>> just want to change a few amount of code at once, and it will be
>>>>> added/removed incrementally. If we do that with stop_machine_run(),
>>>>> we'll be annoyed by frequent machine stops.(Moreover, kprobes uses
>>>>> breakpoint, so it doesn't need stop_machine_run())
>>>>>
>>>> Hi Masami,
>>>>
>>>> Is this text_poke version executable in atomic context ? If yes, then
>>>> that would be good to add a comment saying it. Please see below for
>>>> comments.
>>> Thank you for comments!
>>> I think it could be. ah, spin_lock might be changed to spin_lock_irqsave()...
>>>
>> You are right. If we plan to execute this in both atomic and non-atomic
>> context, spin_lock_irqsave would make sure we are always busy-looping
>> with interrupts off.
> 
> Oops, when I tested spin_lock_irqsave, it caused warnings.
> 
> ------------[ cut here ]------------
> WARNING: at /home/mhiramat/ksrc/linux-2.6/kernel/smp.c:329 smp_call_function_man
> y+0x37/0x1c9()
> Hardware name: Precision WorkStation T5400
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc6 #16
> Call Trace:
>  [<c042f7b1>] warn_slowpath+0x71/0xa8
>  [<c044dccb>] ? trace_hardirqs_on_caller+0x18/0x145
>  [<c06dc42f>] ? _spin_unlock_irq+0x22/0x2f
>  [<c044efc9>] ? print_lock_contention_bug+0x14/0xd7
>  [<c044efc9>] ? print_lock_contention_bug+0x14/0xd7
>  [<c044cfbb>] ? trace_hardirqs_off_caller+0x18/0xa3
>  [<c045383b>] smp_call_function_many+0x37/0x1c9
>  [<c04138fc>] ? do_flush_tlb_all+0x0/0x3c
>  [<c04138fc>] ? do_flush_tlb_all+0x0/0x3c
>  [<c04539e9>] smp_call_function+0x1c/0x23
>  [<c0433ee1>] on_each_cpu+0xf/0x3a
>  [<c04138c6>] flush_tlb_all+0x14/0x16
>  [<c04946f7>] unmap_kernel_range+0xf/0x11
>  [<c06dd78a>] text_poke+0xf1/0x12c
> 
> unmap_kernel_range() requires irq enabled, but spin_lock_irqsave
> (and stop_machine too)disables irq. so we have to solve this issue.
> 
> I have some ideas:
> 
> - export(just remove static) vunmap_page_range() and don't use
>   flush_tlb_all().
>  Because this vm_area are not used by other cpus, we don't need
>  to flush TLB of all cpus.
> 
> - make unmap_kernel_range_local() function.
> 
> - extend kmap_atomic_prot() to map lowmem page when the 'prot'
>   is different.
> 

I updated my patch based on the first idea.
I also checked that text_poke() can be called from stop_machine()
with this patch.
---

Use map_vm_area() instead of vmap() in text_poke() for avoiding page allocation
and delayed unmapping, and call vunmap_page_range() and local_flush_tlb()
directly because this mapping is temporary and local.

At the result of above change, text_poke() becomes atomic and can be called
from stop_machine() etc.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Nick Piggin <npiggin@suse.de>
---
  arch/x86/include/asm/alternative.h |    1 +
  arch/x86/kernel/alternative.c      |   36 +++++++++++++++++++++++++++++-------
  include/linux/vmalloc.h            |    1 +
  init/main.c                        |    3 +++
  mm/vmalloc.c                       |    2 +-
  5 files changed, 35 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/alternative.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/alternative.h
+++ linux-2.6/arch/x86/include/asm/alternative.h
@@ -177,6 +177,7 @@ extern void add_nops(void *insns, unsign
   * The _early version expects the memory to already be RW.
   */

+extern void text_poke_init(void);
  extern void *text_poke(void *addr, const void *opcode, size_t len);
  extern void *text_poke_early(void *addr, const void *opcode, size_t len);

Index: linux-2.6/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/alternative.c
+++ linux-2.6/arch/x86/kernel/alternative.c
@@ -12,6 +12,7 @@
  #include <asm/nmi.h>
  #include <asm/vsyscall.h>
  #include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
  #include <asm/io.h>

  #define MAX_PATCH_LEN (255-1)
@@ -485,6 +486,16 @@ void *text_poke_early(void *addr, const
  	return addr;
  }

+static struct vm_struct *text_poke_area[2];
+static DEFINE_SPINLOCK(text_poke_lock);
+
+void __init text_poke_init(void)
+{
+	text_poke_area[0] = get_vm_area(PAGE_SIZE, VM_ALLOC);
+	text_poke_area[1] = get_vm_area(2 * PAGE_SIZE, VM_ALLOC);
+	BUG_ON(!text_poke_area[0] || !text_poke_area[1]);
+}
+
  /**
   * text_poke - Update instructions on a live kernel
   * @addr: address to modify
@@ -501,8 +512,9 @@ void *__kprobes text_poke(void *addr, co
  	unsigned long flags;
  	char *vaddr;
  	int nr_pages = 2;
-	struct page *pages[2];
-	int i;
+	struct page *pages[2], **pgp = pages;
+	int i, ret;
+	struct vm_struct *vma;

  	if (!core_kernel_text((unsigned long)addr)) {
  		pages[0] = vmalloc_to_page(addr);
@@ -515,12 +527,22 @@ void *__kprobes text_poke(void *addr, co
  	BUG_ON(!pages[0]);
  	if (!pages[1])
  		nr_pages = 1;
-	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	BUG_ON(!vaddr);
-	local_irq_save(flags);
+	spin_lock_irqsave(&text_poke_lock, flags);
+	vma = text_poke_area[nr_pages-1];
+	ret = map_vm_area(vma, PAGE_KERNEL, &pgp);
+	BUG_ON(ret);
+	vaddr = vma->addr;
  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-	local_irq_restore(flags);
-	vunmap(vaddr);
+	/* Ported from unmap_kernel_range() */
+	flush_cache_vunmap((unsigned long)vma->addr, (unsigned long)vma->size);
+	vunmap_page_range((unsigned long)vma->addr,
+			  (unsigned long)vma->addr + (unsigned long)vma->size);
+	/*
+	 * Since this mapping is temporary, local and protected by spinlock,
+	 * we just need to flush TLB on local processor.
+	 */
+	local_flush_tlb();
+	spin_unlock_irqrestore(&text_poke_lock, flags);
  	sync_core();
  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
  	   that causes hangs on some VIA CPUs. */
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -676,6 +676,9 @@ asmlinkage void __init start_kernel(void
  	taskstats_init_early();
  	delayacct_init();

+#ifdef CONFIG_X86
+	text_poke_init();
+#endif
  	check_bugs();

  	acpi_early_init(); /* before LAPIC and SMP init */
Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -71,7 +71,7 @@ static void vunmap_pud_range(pgd_t *pgd,
  	} while (pud++, addr = next, addr != end);
  }

-static void vunmap_page_range(unsigned long addr, unsigned long end)
+void vunmap_page_range(unsigned long addr, unsigned long end)
  {
  	pgd_t *pgd;
  	unsigned long next;
Index: linux-2.6/include/linux/vmalloc.h
===================================================================
--- linux-2.6.orig/include/linux/vmalloc.h
+++ linux-2.6/include/linux/vmalloc.h
@@ -96,6 +96,7 @@ extern struct vm_struct *remove_vm_area(
  extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
  			struct page ***pages);
  extern void unmap_kernel_range(unsigned long addr, unsigned long size);
+extern void vunmap_page_range(unsigned long addr, unsigned long end);

  /* Allocate/destroy a 'vmalloc' VM area. */
  extern struct vm_struct *alloc_vm_area(size_t size);

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


