Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZCBWQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZCBWQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZCBWQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:16:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46824 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZCBWQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:16:23 -0500
Message-ID: <49AC5A87.7000604@redhat.com>
Date: Mon, 02 Mar 2009 17:15:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
References: <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal>
In-Reply-To: <20090302171914.GB21735@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Index: linux-2.6/init/main.c
>> ===================================================================
>> --- linux-2.6.orig/init/main.c
>> +++ linux-2.6/init/main.c
>> @@ -676,6 +676,9 @@ asmlinkage void __init start_kernel(void
>>  	taskstats_init_early();
>>  	delayacct_init();
>>
>> +#ifdef CONFIG_X86
>> +	text_poke_init();
>> +#endif
> 
> All good, except this above. There should be an empty text_poke_init()
> in some header file, and an implementation for the X86 arch rather than
> a ifdef in init/main.c.

Hmm, I'd rather use __weak function instead of defining it in some header
files, because text_poke() and alternatives exist only on x86.

I know that we need to discuss cross modifying code on x86 with
Arjan or other Intel engineers. This patch may still be useful
for removing unnecessary vm_area allocation in text_poke().

Thank you,

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
  init/main.c                        |    5 +++++
  mm/vmalloc.c                       |    2 +-
  5 files changed, 37 insertions(+), 8 deletions(-)

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
@@ -526,6 +526,10 @@ void __init __weak thread_info_cache_ini
  {
  }

+void __init __weak text_poke_init(void)
+{
+}
+
  asmlinkage void __init start_kernel(void)
  {
  	char * command_line;
@@ -676,6 +680,7 @@ asmlinkage void __init start_kernel(void
  	taskstats_init_early();
  	delayacct_init();

+	text_poke_init();
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


