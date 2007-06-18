Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbXFRT1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbXFRT1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761264AbXFRT1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:27:14 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:34231 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761001AbXFRT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:27:13 -0400
Date: Mon, 18 Jun 2007 15:27:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>, prasanna@in.ibm.com
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, ananth@in.ibm.com
Subject: Re: [patch 4/8] Immediate Value - i386 Optimization; kprobes
Message-ID: <20070618192707.GA15809@Krystal>
References: <20070615202310.178466032@polymtl.ca> <20070615202926.152087904@polymtl.ca> <46730C5A.7080401@redhat.com> <20070618145702.GA5254@Krystal> <4676D2A9.6090403@redhat.com> <20070618115632.7aca8c0f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070618115632.7aca8c0f.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:05:08 up 21 days,  3:43,  3 users,  load average: 0.19, 0.76, 0.72
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prasanna,

Please see comments below about the patch.

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Mon, 18 Jun 2007 14:44:57 -0400
> Chuck Ebbert <cebbert@redhat.com> wrote:
> 
> > > I fancy it's done by the kprobe_page_fault handler, but I do not see
> > > clearly how writing the breakpoint from arch_arm_kprobe() in
> > > non-writeable memory is done.
> > 
> > Looks like it's not merged yet:
> > 
> > http://lkml.org/lkml/2007/6/7/2
> > 
> > This needs to go in before 2.6.22-final
> 
> Andi, I'll include the below two patches in the next batch, OK?
> 
> 
> 
> From: "S. P. Prasanna" <prasanna@in.ibm.com>
> 
> Fix the problem of page protection introduced by CONFIG_DEBUG_RODATA for
> x86_64 architecture.  As per Andi Kleen's suggestion, the kernel text pages
> are marked writeable only for a short duration to insert or remove the
> breakpoints.
> 
> Signed-off-by: Prasanna S P<prasanna@in.ibm.com>
> Acked-by: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86_64/kernel/kprobes.c |   26 ++++++++++++++++++++++++++
>  arch/x86_64/mm/init.c        |    6 +++++-
>  include/asm-x86_64/kprobes.h |   10 ++++++++++
>  3 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff -puN arch/x86_64/kernel/kprobes.c~kprobes-x86_64-fix-for-mark-ro-data arch/x86_64/kernel/kprobes.c
> --- a/arch/x86_64/kernel/kprobes.c~kprobes-x86_64-fix-for-mark-ro-data
> +++ a/arch/x86_64/kernel/kprobes.c
> @@ -209,16 +209,42 @@ static void __kprobes arch_copy_kprobe(s
>  
>  void __kprobes arch_arm_kprobe(struct kprobe *p)
>  {
> +	unsigned long addr = (unsigned long)p->addr;
> +	int page_readonly = 0;
> +
> +	if (kernel_readonly_text(addr)) {
> +		change_page_attr_addr(addr, 1, PAGE_KERNEL_EXEC);
> +		global_flush_tlb();
> +		page_readonly = 1;
> +	}
>  	*p->addr = BREAKPOINT_INSTRUCTION;
>  	flush_icache_range((unsigned long) p->addr,
>  			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
> +	if (page_readonly) {
> +		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
> +		global_flush_tlb();
> +	}
>  }
>  
>  void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  {
> +	unsigned long addr = (unsigned long)p->addr;
> +	int page_readonly = 0;
> +
> +	if (kernel_readonly_text(addr)) {
> +		change_page_attr_addr(addr, 1, PAGE_KERNEL_EXEC);
> +		global_flush_tlb();
> +		page_readonly = 1;
> +	}
> +
>  	*p->addr = p->opcode;
>  	flush_icache_range((unsigned long) p->addr,
>  			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
> +
> +	if (page_readonly) {
> +		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
> +		global_flush_tlb();
> +	}
>  }
>  
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
> diff -puN arch/x86_64/mm/init.c~kprobes-x86_64-fix-for-mark-ro-data arch/x86_64/mm/init.c
> --- a/arch/x86_64/mm/init.c~kprobes-x86_64-fix-for-mark-ro-data
> +++ a/arch/x86_64/mm/init.c
> @@ -48,6 +48,7 @@
>  #define Dprintk(x...)
>  #endif
>  
> +int kernel_text_is_ro;
>  const struct dma_mapping_ops* dma_ops;
>  EXPORT_SYMBOL(dma_ops);
>  
> @@ -600,10 +601,13 @@ void mark_rodata_ro(void)
>  {
>  	unsigned long start = (unsigned long)_stext, end;
>  
> +	kernel_text_is_ro = 1;
>  #ifdef CONFIG_HOTPLUG_CPU
>  	/* It must still be possible to apply SMP alternatives. */
> -	if (num_possible_cpus() > 1)
> +	if (num_possible_cpus() > 1) {
>  		start = (unsigned long)_etext;
> +		kernel_text_is_ro = 0;
> +	}
>  #endif
>  	end = (unsigned long)__end_rodata;
>  	start = (start + PAGE_SIZE - 1) & PAGE_MASK;
> diff -puN include/asm-x86_64/kprobes.h~kprobes-x86_64-fix-for-mark-ro-data include/asm-x86_64/kprobes.h
> --- a/include/asm-x86_64/kprobes.h~kprobes-x86_64-fix-for-mark-ro-data
> +++ a/include/asm-x86_64/kprobes.h
> @@ -26,6 +26,7 @@
>  #include <linux/types.h>
>  #include <linux/ptrace.h>
>  #include <linux/percpu.h>
> +#include <asm-generic/sections.h>
>  
>  #define  __ARCH_WANT_KPROBES_INSN_SLOT
>  
> @@ -88,4 +89,13 @@ extern int kprobe_handler(struct pt_regs
>  
>  extern int kprobe_exceptions_notify(struct notifier_block *self,
>  				    unsigned long val, void *data);
> +extern int kernel_text_is_ro;
> +static inline int kernel_readonly_text(unsigned long address)
> +{
> +	if (kernel_text_is_ro && ((address >= (unsigned long)_stext)
> +					&& (address < (unsigned long) _etext)))
> +		return 1;
> +
> +	return 0;
> +}
>  #endif				/* _ASM_KPROBES_H */
> _
> 
> 
> 
> From: "S. P. Prasanna" <prasanna@in.ibm.com>
> 
> Fix the problem of page protection introduced by CONFIG_DEBUG_RODATA. 
> CONFIG_DEBUG_RODATA marks the text pages as read-only, hence kprobes is
> unable to insert breakpoints in the kernel text.  This patch overrides the
> page protection when adding or removing a probe for the i386 architecture.
> 
> Signed-off-by: Prasanna S P<prasanna@in.ibm.com>
> Acked-by: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/kernel/kprobes.c |   26 ++++++++++++++++++++++++++
>  arch/i386/mm/init.c        |    2 ++
>  include/asm-i386/kprobes.h |   12 ++++++++++++
>  include/asm-i386/pgtable.h |    2 ++
>  4 files changed, 42 insertions(+)
> 
> diff -puN arch/i386/kernel/kprobes.c~kprobes-i386-fix-for-mark-ro-data arch/i386/kernel/kprobes.c
> --- a/arch/i386/kernel/kprobes.c~kprobes-i386-fix-for-mark-ro-data
> +++ a/arch/i386/kernel/kprobes.c
> @@ -169,16 +169,42 @@ int __kprobes arch_prepare_kprobe(struct
>  
>  void __kprobes arch_arm_kprobe(struct kprobe *p)
>  {
> +	unsigned long addr = (unsigned long) p->addr;
> +	int page_readonly = 0;
> +
> +	if (kernel_readonly_text(addr)) {
> +		page_readonly = 1;
> +		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
> +		global_flush_tlb();
> +	}
> +
>  	*p->addr = BREAKPOINT_INSTRUCTION;
>  	flush_icache_range((unsigned long) p->addr,
>  			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));

Something is weird here:

A- flush_icache_range does nothing on i386. However, I guess it's there
so the code is easier to port to other architectures.
B- since this code is meant to be eventually ported in some way, we have
to be aware that sizeof(kprobe_opcode_t) may differ from 1 byte and that
the instruction can be across a page boundary. However, I do not see
this case dealt properly.

So either we make this function architecture specific (by removing the
flush_icache_range), or we turn this into an architecture independant
function, but we make sure that we change the flags of every potential
pages affected.

> +
> +	if (page_readonly) {
> +		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
> +		global_flush_tlb();
> +	}
>  }
>  

Something like :

int ro_text = kernel_readonly_text(addr);

if (ro_text) {
  ...
}
...
if (ro_text) {
  ...
}

Seems nicer than setting a boolean in the middle of the function,
doesn't it ?


>  void __kprobes arch_disarm_kprobe(struct kprobe *p)
>  {
> +	unsigned long addr = (unsigned long) p->addr;
> +	int page_readonly = 0;
> +
> +	if (kernel_readonly_text(addr)) {
> +		page_readonly = 1;
> +		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
> +		global_flush_tlb();
> +	}
>  	*p->addr = p->opcode;
>  	flush_icache_range((unsigned long) p->addr,
>  			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
> +	if (page_readonly) {
> +		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
> +		global_flush_tlb();
> +	}
>  }
>  
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
> diff -puN arch/i386/mm/init.c~kprobes-i386-fix-for-mark-ro-data arch/i386/mm/init.c
> --- a/arch/i386/mm/init.c~kprobes-i386-fix-for-mark-ro-data
> +++ a/arch/i386/mm/init.c
> @@ -45,6 +45,7 @@
>  #include <asm/sections.h>
>  #include <asm/paravirt.h>
>  
> +int kernel_text_is_ro;
>  unsigned int __VMALLOC_RESERVE = 128 << 20;
>  
>  DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
> @@ -808,6 +809,7 @@ void mark_rodata_ro(void)
>  		change_page_attr(virt_to_page(start),
>  		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
>  		printk("Write protecting the kernel text: %luk\n", size >> 10);
> +		kernel_text_is_ro = 1;
>  	}
>  
>  	start += size;
> diff -puN include/asm-i386/kprobes.h~kprobes-i386-fix-for-mark-ro-data include/asm-i386/kprobes.h
> --- a/include/asm-i386/kprobes.h~kprobes-i386-fix-for-mark-ro-data
> +++ a/include/asm-i386/kprobes.h
> @@ -26,6 +26,8 @@
>   */
>  #include <linux/types.h>
>  #include <linux/ptrace.h>
> +#include <linux/pfn.h>
> +#include <asm-generic/sections.h>
>  
>  #define  __ARCH_WANT_KPROBES_INSN_SLOT
>  
> @@ -90,4 +92,14 @@ static inline void restore_interrupts(st
>  
>  extern int kprobe_exceptions_notify(struct notifier_block *self,
>  				    unsigned long val, void *data);
> +extern int kernel_text_is_ro;
> +static inline int kernel_readonly_text(unsigned long address)
> +{
> +
> +	if (kernel_text_is_ro && ((address >= PFN_ALIGN(_text))
> +				&& (address < PFN_ALIGN(_etext))))
> +		return 1;
> +
> +	return 0;
> +}

I see here that it does not check for module text addresses, which is
correct. module.c does not currently implement read-only pages for
module's text section. Is it planned ?

>  #endif				/* _ASM_KPROBES_H */
> diff -puN include/asm-i386/pgtable.h~kprobes-i386-fix-for-mark-ro-data include/asm-i386/pgtable.h
> --- a/include/asm-i386/pgtable.h~kprobes-i386-fix-for-mark-ro-data
> +++ a/include/asm-i386/pgtable.h
> @@ -159,6 +159,7 @@ void paging_init(void);
>  extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
>  #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
>  #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
> +#define __PAGE_KERNEL_RWX		(__PAGE_KERNEL_EXEC | _PAGE_RW)
>  #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
>  #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
>  #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
> @@ -167,6 +168,7 @@ extern unsigned long long __PAGE_KERNEL,
>  #define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO)
>  #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
>  #define PAGE_KERNEL_RX		__pgprot(__PAGE_KERNEL_RX)
> +#define PAGE_KERNEL_RWX		__pgprot(__PAGE_KERNEL_RWX)
>  #define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE)
>  #define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
>  #define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
> _
> 
There is a new define for i386, but not for x86_64 ? I doubt it is
required anyway, because __PAGE_KERNEL_EXEC implies
(__PAGE_KERNEL_RX | _PAGE_RW).

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
