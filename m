Return-Path: <linux-kernel-owner+w=401wt.eu-S1946291AbXBIKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946291AbXBIKK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946298AbXBIKKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:10:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:34132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946291AbXBIKJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:09:47 -0500
From: Andi Kleen <ak@muc.de>
To: virtualization@lists.osdl.org
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
Date: Fri, 9 Feb 2007 11:09:19 +0100
User-Agent: KMail/1.9.5
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012761.2718.40.camel@localhost.localdomain> <1171012827.2718.42.camel@localhost.localdomain>
In-Reply-To: <1171012827.2718.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091109.20061.ak@muc.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 10:20, Rusty Russell wrote:
> This is the core of lguest: both the guest code (always compiled in to
> the image so it can boot under lguest), and the host code (lg.ko).
> 
> There is only one config prompt at the moment: lguest is currently
> designed to run exactly the same guest and host kernels so we can
> frob the ABI freely.
> 
> Unfortunately, we don't have the build infrastructure for "private"
> asm-offsets.h files, so there's a not-so-neat include in
> arch/i386/kernel/asm-offsets.c.

Ask the kbuild people to fix that? 

It indeed looks ugly.

I bet Xen et.al. could make good use of that too.

> +# This links the hypervisor in the right place and turns it into a C array.
> +$(obj)/hypervisor-raw: $(obj)/hypervisor.o
> +	@$(LD) -static -Tdata=`printf %#x $$(($(HYPE_ADDR)))` -Ttext=`printf %#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE)))` -o $@ $< && $(OBJCOPY) -O binary $@
> +$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
> +	@od -tx1 -An -v $< | sed -e 's/^ /0x/' -e 's/$$/,/' -e 's/ /,0x/g' > $@

an .S file with .incbin is more efficient and simpler
(note it has to be an separate .S file, otherwise icecream/distcc break) 

It won't allow to show off any sed skills, but I guess we can live with that ;-)


> +static struct vm_struct *hypervisor_vma;
> +static int cpu_had_pge;
> +static struct {
> +	unsigned long offset;
> +	unsigned short segment;
> +} lguest_entry;
> +struct page *hype_pages; /* Contiguous pages. */

Statics? looks funky.  Why only a single hypervisor_vma?

> +struct lguest lguests[MAX_LGUEST_GUESTS];
> +DECLARE_MUTEX(lguest_lock);
> +
> +/* IDT entries are at start of hypervisor. */
> +const unsigned long *__lguest_default_idt_entries(void)
> +{
> +	return (void *)HYPE_ADDR;
> +}
> +
> +/* Next is switch_to_guest */
> +static void *__lguest_switch_to_guest(void)
> +{
> +	return (void *)HYPE_ADDR + HYPE_DATA_SIZE;
> +}
> +
> +/* Then we use everything else to hold guest state. */
> +struct lguest_state *__lguest_states(void)
> +{
> +	return (void *)HYPE_ADDR + sizeof(hypervisor_blob);

This cries for asm_offsets.h too, doesn't it? 

> +}
> +
> +static __init int map_hypervisor(void)
> +{
> +	unsigned int i;
> +	int err;
> +	struct page *pages[HYPERVISOR_PAGES], **pagep = pages;
> +
> +	hype_pages = alloc_pages(GFP_KERNEL|__GFP_ZERO,
> +				 get_order(HYPERVISOR_SIZE));

Wasteful because of the rounding. Probably wants reintroduction
of alloc_pages_exact()


> +
> +static __exit void unmap_hypervisor(void)
> +{
> +	vunmap(hypervisor_vma->addr);
> +	__free_pages(hype_pages, get_order(HYPERVISOR_SIZE));

Shouldn't you clean up the GDTs too? 

> +}
> +
> +/* IN/OUT insns: enough to get us past boot-time probing. */
> +static int emulate_insn(struct lguest *lg)
> +{
> +	u8 insn;
> +	unsigned int insnlen = 0, in = 0, shift = 0;
> +	unsigned long physaddr = guest_pa(lg, lg->state->regs.eip);
> +
> +	/* This only works for addresses in linear mapping... */
> +	if (lg->state->regs.eip < lg->page_offset)
> +		return 0;

Shouldn't there be a printk here?

> +/* Saves exporting idt_table from kernel */
> +static struct desc_struct *get_idt_table(void)
> +{
> +	struct Xgt_desc_struct idt;
> +
> +	asm("sidt %0":"=m" (idt));

Nasty, but ok.

> +	return (void *)idt.address;
> +}
> +
> +extern asmlinkage void math_state_restore(void);

No externs in .c files

> +
> +/* Trap page resets this when it reloads gs. */
> +static int new_gfp_eip(struct lguest *lg, struct lguest_regs *regs)
> +{
> +	u32 eip;
> +	get_user(eip, &lg->lguest_data->gs_gpf_eip);
> +	if (eip == regs->eip)
> +		return 0;
> +	put_user(regs->eip, &lg->lguest_data->gs_gpf_eip);

No fault checking? 

lhread/write use probably also needs to be double checked that a malicious
guest can't put the kernel into a loop.

> +	return 1;
> +}
> +
> +static void set_ts(unsigned int guest_ts)
> +{
> +	u32 cr0;
> +	if (guest_ts) {
> +		asm("movl %%cr0,%0":"=r" (cr0));
> +		if (!(cr0 & 8))
> +			asm("movl %0,%%cr0": :"r" (cr0|8));
> +	}

We have macros and defines for this in standard headers.
\
> +	while (!lg->dead) {
> +		unsigned int cr2 = 0; /* Damn gcc */
> +
> +		/* Hypercalls first: we might have been out to userspace */
> +		if (do_async_hcalls(lg))
> +			goto pending_dma;
> +
> +		if (regs->trapnum == LGUEST_TRAP_ENTRY) {
> +			/* Only do hypercall once. */
> +			regs->trapnum = 255;
> +			if (hypercall(lg, regs))
> +				goto pending_dma;
> +		}
> +
> +		if (signal_pending(current))
> +			return -EINTR

Probably needs freezer checking here somewhere.

> ; 
> +		maybe_do_interrupt(lg);
> +
> +		if (lg->dead)
> +			break;
> +
> +		if (lg->halted) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			schedule_timeout(1);

1?  And what is that good for anyways?

> +				/* FIXME: If it's reloading %gs in a loop? */

Yes what then? Have you tried it?

In general i miss printks when things go wrong. Do you expect
all users to have a gdbstub ready? @)

> +pending_dma:
> +	put_user(lg->pending_dma, (unsigned long *)user);
> +	put_user(lg->pending_addr, (unsigned long *)user+1);

error checking? How do you avoid loops?


> +	if (cpu_has_pge) { /* We have a broader idea of "global". */
> +		cpu_had_pge = 1;
> +		on_each_cpu(adjust_pge, 0, 0, 1);

cpu hotplug? 

> +		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
> +	}
> +	return 0;
> +}
> 
> +	case LHCALL_CRASH: {
> +		char msg[128];
> +		lhread(lg, msg, regs->edx, sizeof(msg));
> +		msg[sizeof(msg)-1] = '\0';

Might be safer to vet for isprint here

> +#define log(...)					\
> +	do {						\
> +		mm_segment_t oldfs = get_fs();		\
> +		char buf[100];				\

At least older gccs will accumulate the bufs in a function, eventually possibly blowing
the stack. Better use a function.


> +	/* If they're halted, we re-enable interrupts. */
> +	if (lg->halted) {
> +		/* Re-enable interrupts. */
> +		put_user(512, &lg->lguest_data->irq_enabled);

interesting magic number

> +	/* Ignore NMI, doublefault, hypercall, spurious interrupt. */
> +	if (i == 2 || i == 8 || i == 15 || i == LGUEST_TRAP_ENTRY)
> +		return;
> +	/* FIXME: We should handle debug and int3 */
> +	else if (i == 1 || i == 3)
> +		return;
> +	/* We intercept page fault, general protection fault and fpu missing */
> +	else if (i == 13)
> +		copy_trap(lg, &lg->gpf_trap, &d);
> +	else if (i == 14)
> +		copy_trap(lg, &lg->page_trap, &d);
> +	else if (i == 7)
> +		copy_trap(lg, &lg->fpu_trap, &d);
> +	/* Other traps go straight to guest. */
> +	else if (i < FIRST_EXTERNAL_VECTOR || i == SYSCALL_VECTOR)
> +		setup_idt(lg, i, &d);
> +	/* A virtual interrupt */
> +	else if (i < FIRST_EXTERNAL_VECTOR + LGUEST_IRQS)
> +		copy_trap(lg, &lg->interrupt[i-FIRST_EXTERNAL_VECTOR], &d);\

switch is not cool enough anymore?

>
> +	down(&lguest_lock);

i suspect mutexes are the new way to do this

> +	down_read(&current->mm->mmap_sem);
> +	if (get_futex_key((u32 __user *)addr, &key) != 0) {
> +		kill_guest(lg, "bad dma address %#lx", addr);
> +		goto unlock;

Risky? Use probe_kernel_address et.al.?

> +#if 0
> +/* FIXME: Use asm-offsets here... */

Remove?

> +extern int mce_disabled;

tststs

> +
> +/* FIXME: Update iff tsc rate changes. */

It does.


> +static fastcall void lguest_cpuid(unsigned int *eax, unsigned int *ebx,
> +				 unsigned int *ecx, unsigned int *edx)
> +{
> +	int is_feature = (*eax == 1);
> +
> +	asm volatile ("cpuid"
> +		      : "=a" (*eax),
> +			"=b" (*ebx),
> +			"=c" (*ecx),
> +			"=d" (*edx)
> +		      : "0" (*eax), "2" (*ecx));

What's wrong with the standard cpuid*() macros?

> +	extern struct Xgt_desc_struct cpu_gdt_descr;
> +	extern struct i386_pda boot_pda;

No externs in .c

> +
> +	paravirt_ops.name = "lguest";

Can you just statically initialize this and then copy over? 

> +	asm volatile ("mov %0, %%gs" : : "r" (__KERNEL_PDA) : "memory");

This will be %fs soon.


... haven't read everything else. the IO driver earlier was also not very closely looked at.

-Andi
