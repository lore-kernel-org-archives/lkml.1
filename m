Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXBNAjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXBNAjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbXBNAjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:39:54 -0500
Received: from gw.goop.org ([64.81.55.164]:48490 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbXBNAjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:39:53 -0500
Message-ID: <45D25A56.1000706@goop.org>
Date: Tue, 13 Feb 2007 16:39:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 16/21] Xen-paravirt: Add code into head.S to handle being
 booted by Xen
References: <20070213221729.772002682@goop.org> <20070213221830.707197267@goop.org> <20070213235424.GA1908@muc.de>
In-Reply-To: <20070213235424.GA1908@muc.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> --- a/arch/i386/kernel/entry.S
>> +++ b/arch/i386/kernel/entry.S
>> @@ -1001,6 +1001,83 @@ ENTRY(kernel_thread_helper)
>>  	CFI_ENDPROC
>>  ENDPROC(kernel_thread_helper)
>>  
>> +#ifdef CONFIG_XEN
>> +/* Xen only supports sysenter/sysexit in ring0 guests,
>> +   and only if it the guest asks for it.  So for now,
>> +   this should never be used. */
>> +ENTRY(xen_sti_sysexit)
>> +	CFI_STARTPROC
>> +	ud2
>> +	CFI_ENDPROC
>>     
>
> Please add ENDPROC()s too, otherwise Jan will be unhappy.
>   

Will do.

> Could be written in C with a real BUG? 
>   

I guess, but this seems simpler.  It could be removed altogether, but it
would be nice to make sure it never happens.

>> +ENTRY(xen_failsafe_callback)
>> +	CFI_STARTPROC
>> +	pushl %eax
>> +	CFI_ADJUST_CFA_OFFSET 4
>> +	movl $1,%eax
>> +1:	mov 4(%esp),%ds
>> +2:	mov 8(%esp),%es
>> +3:	mov 12(%esp),%fs
>> +4:	mov 16(%esp),%gs
>> +	testl %eax,%eax
>> +	popl %eax
>> +	CFI_ADJUST_CFA_OFFSET -4
>> +	jz 5f
>> +	addl $16,%esp		# EAX != 0 => Category 2 (Bad IRET)
>> +	CFI_ADJUST_CFA_OFFSET -16
>> +	jmp iret_exc
>> +5:	addl $16,%esp		# EAX == 0 => Category 1 (Bad segment)
>>     
>
> If you use lea you could move the two adds before the jz
>   

Yep.

>> +#ifdef CONFIG_XEN
>> +#include "../xen/xen-head.S"
>> +#endif
>>     
>
> Can this really not be linked separately? 
>   
xen-head.S jumps back to startup_paravirt.  That could be exported, and
then it could be linked separately.  There used to be a requirement that
the code in xen-head.S be at a compile-time known address, but that's no
longer the case.

>> +	
>>  /*
>>   * Real beginning of normal "text" segment
>>   */
>> @@ -528,7 +532,7 @@ ENTRY(_stext)
>>  /*
>>   * BSS section
>>   */
>> -.section ".bss.page_aligned","w"
>> +.section ".bss.page_aligned"
>>     
>
> Why? 
>   

I got complaints about section attribute mismatches without it.

>> -static fastcall void native_clts(void)
>> +fastcall void native_clts(void)
>>     
>
> Fastcalls should all go now
>   

Killing them here as we speak.

>> --- a/arch/i386/kernel/vmlinux.lds.S
>> +++ b/arch/i386/kernel/vmlinux.lds.S
>> @@ -93,6 +93,7 @@ SECTIONS
>>  
>>    . = ALIGN(4096);
>>    .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
>> +	*(.data.page_aligned)
>>     
>
> Weird that that didn't work before -- we already had page aligned data
> and it somehow managed to work. But ok.
>
>   
>>  	*(.data.idt)
>>    }
>>  
>> ===================================================================
>> --- a/arch/i386/mm/pgtable.c
>> +++ b/arch/i386/mm/pgtable.c
>> @@ -267,6 +267,7 @@ static void pgd_ctor(pgd_t *pgd)
>>  					swapper_pg_dir + USER_PTRS_PER_PGD,
>>  					KERNEL_PGD_PTRS);
>>  		} else {
>> +			memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
>>     
>
> That looks strange here. Belongs in a different patch? 
>   

This is a big rollup patch of all the core Xen stuff; the subject is
wrong.  But I added this for Xen because it needs to make sure the page
is all zero and doesn't have some left-over pieces of old pagetable.

>> +
>> +extern struct Xgt_desc_struct cpu_gdt_descr;
>> +extern struct i386_pda boot_pda;
>> +extern unsigned long init_pg_tables_end;
>>     
>
> No externs in .c files
>   

OK.

>> +
>> +static DEFINE_PER_CPU(unsigned, lazy_mode);
>> +
>> +/* Code defined in entry.S (not a function) */
>> +extern const char xen_sti_sysexit[];
>>     
>
> Ok except that
>
>   
>> +{
>> +	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
>> +	       paravirt_ops.name);
>>     
>
> Say something about Xen here?
>   

paravirt_ops.name mentions Xen.

>> +}
>> +
>> +static fastcall void xen_restore_fl(unsigned long flags)
>> +{
>> +	struct vcpu_info *vcpu;
>> +
>> +	preempt_disable();
>> +
>> +	/* convert from IF type flag */
>> +	flags = !(flags & X86_EFLAGS_IF);
>> +	vcpu = read_pda(xen.vcpu);
>> +	vcpu->evtchn_upcall_mask = flags;
>> +	if (flags == 0) {
>> +		barrier(); /* unmask then check (avoid races) */
>>     
>
> If the barrier is needed shouldn't it be a rmb() ? 
>
>   
>> +	vcpu = read_pda(xen.vcpu);
>> +	vcpu->evtchn_upcall_mask = 0;
>> +	barrier(); /* unmask then check (avoid races) */
>>     
>
> Similar.
>   

Erm, not sure.  The write needs to be complete before the read happens. 
Which is the right barrier for that?

>> +static fastcall void xen_load_gdt(const struct Xgt_desc_struct *dtr)
>> +{
>> +        unsigned long va;
>> +        int f;
>> +	unsigned size = dtr->size + 1;
>> +	unsigned long frames[16];
>> +
>> +	BUG_ON(size > 16*PAGE_SIZE);
>> +
>>     
>
> Indentation broken
>
> (more occurences in this file) 
>   

OK.

>> +	type = (high >> 8) & 0x1f;
>> +	dpl = (high >> 13) & 3;
>> +
>> +	if (type != 0xf && type != 0xe)
>> +		return 0;
>> +
>> +	info->vector = vector;
>> +	info->address = (high & 0xffff0000) | (low & 0x0000ffff);
>> +	info->cs = low >> 16;
>> +	info->flags = dpl;
>> +	/* interrupt gates clear IF */
>> +	if (type == 0xe)
>> +		info->flags |= 4;
>>     
>
> Nasty magic numbers? 
>   

Yeah.  Are there any existing definitions of the x86 gate types?

>> +	return 1;
>> +}
>> +
>> +#if 0
>> +static void unpack_desc(u32 low, u32 high,
>> +			unsigned long *base, unsigned long *limit,
>> +			unsigned char *type, unsigned char *flags)
>> +{
>> +	*base = (high & 0xff000000) | ((high << 16) & 0x00ff0000) | ((low >> 16) & 0xffff);
>> +	*limit = (high & 0x000f0000) | (low & 0xffff);
>> +	*type = (high >> 8) & 0xff;
>> +	*flags = (high >> 20) & 0xf;
>> +}
>> +#endif
>>     
>
> Remove? 
>   

Yep.

>> +
>> +/* Locations of each CPU's IDT */
>> +static DEFINE_PER_CPU(struct Xgt_desc_struct, idt_desc);
>>     
>
> Why is that private here? 
>   

It's a local per-cpu cache of the idt as set by the kernel.  Xen doesn't
use the idt directly, but it remembers what idt has been set so it can
tell if an idt descriptor update is affecting the current idt or
something else.  Its a bit over-engineered, since the idt isn't really
touched much at all.

>> +	/* Switch to new pagetable.  This is done before
>> +	   pagetable_init has done anything so that the new pages
>> +	   added to the table can be prepared properly for Xen.  */
>> +	printk("about to switch to new pagetable %p...\n", base);
>> +	xen_write_cr3(__pa(base));
>> +	printk("done\n");
>>     
>
> KERN_* ?
>   

Delete.  Don't really need it any more.

>> +	if (HYPERVISOR_update_descriptor(virt_to_machine(cpu_gdt_table +
>> +							 GDT_ENTRY_PDA).maddr,
>> +					 (u64)high << 32 | low))
>> +		BUG();
>>     
>
> Does a BUG that early actually do anything good?
>   

Under Xen, an early BUG gets a nice register dump and backtrack from the
hypervisor, so its pretty useful for debugging.

>> +
>> +/*
>> + * Accessors for packed IRQ information.
>> + */
>>     
>
> Wouldn't it be a little simpler to just use a bit field? 
>   

Yeah, or even just a simple structure, since the elements are
short/byte/byte.

>> +static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
>> +{
>> +	int irq = evtchn_to_irq[chn];
>> +
>> +	BUG_ON(irq == -1);
>> +	set_native_irq_info(irq, cpumask_of_cpu(cpu));
>> +
>> +	__clear_bit(chn, (unsigned long *)cpu_evtchn_mask[cpu_evtchn[chn]]);
>>     
>
> Why is the mask not unsigned long in the first place ?
>   

Hm, it was.  Seems completely redundant.

>> +  level is a bitset of pending events themselves.
>> +*/
>> +asmlinkage fastcall void xen_evtchn_do_upcall(struct pt_regs *regs)
>> +{
>> +	int cpu = smp_processor_id();
>>     
>
> Doesn't a preemptive kernel complain about this?
>   

Xen doesn't support preempt.

>> +	set_64bit((u64 *)ptep, pte_val_ma(pte));
>> +}
>> +
>> +void fastcall xen_pte_clear(struct mm_struct *mm, u32 addr,pte_t *ptep)
>> +{
>> +#if 1
>> +	ptep->pte_low = 0;
>> +	smp_wmb();
>> +	ptep->pte_high = 0;	
>> +#else
>> +	set_64bit((u64 *)ptep, 0);
>>     
>
> Eliminate #if please
>   

I need to test this a bit.  This is here because set_64bit doesn't work
properly under qemu (its emulation mis-reports the eip if the
instruction faults), but I haven't tested this under native.

>> +fastcall unsigned long long xen_pgd_val(pgd_t pgd)
>> +{
>> +	unsigned long long ret = pgd.pgd;
>> +	if (ret)
>> +		ret = machine_to_phys(XMADDR(ret)).paddr | 1;
>>     
>
> Why can they be 0 here anyways?
>
> Normally they are all considered undefined when not present
>   

Not sure.

>> +	rdtscll(now);
>> +	delta = now - shadow->tsc_timestamp;
>> +	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
>> +}
>> +
>> +
>> +static void xen_timer_interrupt_hook(void)
>>     
>
> Timer code ... hopefully dyntick will not all mess this up. It is scheduled
> to go into mainline RSN. You might have to do some more merging.
>   

Yep.

>> +
>> +char * __init xen_memory_setup(void);
>>     
>
> Prototypes don't need __init
>   

OK.

>> +void __init xen_arch_setup(void);
>> +void __init xen_init_IRQ(void);
>> +
>> @@ -53,6 +54,7 @@ struct paravirt_ops
>>  	void (*arch_setup)(void);
>>  	char *(*memory_setup)(void);
>>  	void (*init_IRQ)(void);
>> +	void (*init_pda)(struct i386_pda *, int cpu);
>>     
>
> Hmm weird. For what was that needed again? 
>   

The PDA structure contains some Xen-specific (or generally, paravirt
backend specific) parts, which need initialization when the rest of the
PDA is.

    J
