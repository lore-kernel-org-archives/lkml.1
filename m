Return-Path: <linux-kernel-owner+w=401wt.eu-S1946427AbXBIMkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946427AbXBIMkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946428AbXBIMkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:40:19 -0500
Received: from ozlabs.org ([203.10.76.45]:42300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946427AbXBIMkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:40:18 -0500
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <200702091109.20061.ak@muc.de>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012761.2718.40.camel@localhost.localdomain>
	 <1171012827.2718.42.camel@localhost.localdomain>
	 <200702091109.20061.ak@muc.de>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 23:39:31 +1100
Message-Id: <1171024771.2718.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 11:09 +0100, Andi Kleen wrote:
> On Friday 09 February 2007 10:20, Rusty Russell wrote:
> > Unfortunately, we don't have the build infrastructure for "private"
> > asm-offsets.h files, so there's a not-so-neat include in
> > arch/i386/kernel/asm-offsets.c.
> 
> Ask the kbuild people to fix that? 
> 
> It indeed looks ugly.
> 
> I bet Xen et.al. could make good use of that too.

Yes.   I originally had the constants #defined in the header and a whole
heap of BUILD_BUG_ON(XYZ_offset != offsetof(xyz)) in my module, which
was even uglier (but at least contained in my code).

> > +# This links the hypervisor in the right place and turns it into a C array.
> > +$(obj)/hypervisor-raw: $(obj)/hypervisor.o
> > +	@$(LD) -static -Tdata=`printf %#x $$(($(HYPE_ADDR)))` -Ttext=`printf %#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE)))` -o $@ $< && $(OBJCOPY) -O binary $@
> > +$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
> > +	@od -tx1 -An -v $< | sed -e 's/^ /0x/' -e 's/$$/,/' -e 's/ /,0x/g' > $@
> 
> an .S file with .incbin is more efficient and simpler
> (note it has to be an separate .S file, otherwise icecream/distcc break) 
> 
> It won't allow to show off any sed skills, but I guess we can live with that ;-)

Good idea, except I currently use sizeof(hypervisor_blob): I'd have to
extract the size separately and hand it in the CFLAGS 8(

> > +static struct vm_struct *hypervisor_vma;
> > +static int cpu_had_pge;
> > +static struct {
> > +	unsigned long offset;
> > +	unsigned short segment;
> > +} lguest_entry;
> > +struct page *hype_pages; /* Contiguous pages. */
> 
> Statics? looks funky.  Why only a single hypervisor_vma?

We only have one switcher: it contains an array of "struct
lguest_state"; one for each guest.  (This is host code we're looking at
here).

> > +/* IDT entries are at start of hypervisor. */
> > +const unsigned long *__lguest_default_idt_entries(void)
> > +{
> > +	return (void *)HYPE_ADDR;
> > +}
> > +
> > +/* Next is switch_to_guest */
> > +static void *__lguest_switch_to_guest(void)
> > +{
> > +	return (void *)HYPE_ADDR + HYPE_DATA_SIZE;
> > +}
> > +
> > +/* Then we use everything else to hold guest state. */
> > +struct lguest_state *__lguest_states(void)
> > +{
> > +	return (void *)HYPE_ADDR + sizeof(hypervisor_blob);
> 
> This cries for asm_offsets.h too, doesn't it? 

HYPE_DATA_SIZE is the size of the hypervisor.S data segment, I'm not
sure how I'd get that into asm_offsets....

> > +}
> > +
> > +static __init int map_hypervisor(void)
> > +{
> > +	unsigned int i;
> > +	int err;
> > +	struct page *pages[HYPERVISOR_PAGES], **pagep = pages;
> > +
> > +	hype_pages = alloc_pages(GFP_KERNEL|__GFP_ZERO,
> > +				 get_order(HYPERVISOR_SIZE));
> 
> Wasteful because of the rounding. Probably wants reintroduction
> of alloc_pages_exact()

HYPERVISOR_SIZE here is 64k, so it's actually OK (we use the space after
the ~3k text & data from hypervisor.S to hold as many struct
lguest_state's as we can).  The name is bad tho; SWITCHER_MAP_SIZE would
probably be better...

> > +
> > +static __exit void unmap_hypervisor(void)
> > +{
> > +	vunmap(hypervisor_vma->addr);
> > +	__free_pages(hype_pages, get_order(HYPERVISOR_SIZE));
> 
> Shouldn't you clean up the GDTs too? 

I could, but there doesn't seem a great deal of point.  If anyone else
is using them, we're in trouble already...

> > +/* IN/OUT insns: enough to get us past boot-time probing. */
> > +static int emulate_insn(struct lguest *lg)
> > +{
> > +	u8 insn;
> > +	unsigned int insnlen = 0, in = 0, shift = 0;
> > +	unsigned long physaddr = guest_pa(lg, lg->state->regs.eip);
> > +
> > +	/* This only works for addresses in linear mapping... */
> > +	if (lg->state->regs.eip < lg->page_offset)
> > +		return 0;
> 
> Shouldn't there be a printk here?

No, the guest should not be able to evoke a printk from the host kernel.
In this case, however, we'll reflect the trap to the kernel, or if the
kernel hasn't installed an IDT yet we'll kill the guest and the lguest
program will get the string "unhandled trap 13 at <EIP> (err=0)".

Basically this emulation code is simply to get us through all that
annoying early boot probing (paravirt_ops does *not* override in/out).

> > +/* Saves exporting idt_table from kernel */
> > +static struct desc_struct *get_idt_table(void)
> > +{
> > +	struct Xgt_desc_struct idt;
> > +
> > +	asm("sidt %0":"=m" (idt));
> 
> Nasty, but ok.
> 
> > +	return (void *)idt.address;
> > +}
> > +
> > +extern asmlinkage void math_state_restore(void);
> 
> No externs in .c files

Agreed, will fix.

> > +
> > +/* Trap page resets this when it reloads gs. */
> > +static int new_gfp_eip(struct lguest *lg, struct lguest_regs *regs)
> > +{
> > +	u32 eip;
> > +	get_user(eip, &lg->lguest_data->gs_gpf_eip);
> > +	if (eip == regs->eip)
> > +		return 0;
> > +	put_user(regs->eip, &lg->lguest_data->gs_gpf_eip);
> 
> No fault checking? 

What do we care if the guest process has unmapped the lguest_data page:
it's his funeral.  We could put a kill_guest there, but it seems a waste
of code to me.

> lhread/write use probably also needs to be double checked that a malicious
> guest can't put the kernel into a loop.

How?  

> > +static void set_ts(unsigned int guest_ts)
> > +{
> > +	u32 cr0;
> > +	if (guest_ts) {
> > +		asm("movl %%cr0,%0":"=r" (cr0));
> > +		if (!(cr0 & 8))
> > +			asm("movl %0,%%cr0": :"r" (cr0|8));
> > +	}
> 
> We have macros and defines for this in standard headers.

This was in prep to unexport paravirt_ops, but you threatened the freeze
on me so I pushed this ahead.

Some of this code will get cleaned up along with others when that patch
goes through (my idea is that we'll make sure to expose the native
versions as inlines, so this code can use native_read_cr0 etc. directly.
lguest hosts cannot be paravirtualized anyway 8).

> > +		if (signal_pending(current))
> > +			return -EINTR
> 
> Probably needs freezer checking here somewhere.

Yes, that code always mystified me...

> > +		if (lg->halted) {
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +			schedule_timeout(1);
> 
> 1?  And what is that good for anyways?

It's waiting for the dynamic tick code to go in.  Again, I was hoping
that that would go in and I could go in behind it, but you made it clear
that waiting longer isn't an option.

> > +				/* FIXME: If it's reloading %gs in a loop? */
> 
> Yes what then? Have you tried it?
> 
> In general i miss printks when things go wrong. Do you expect
> all users to have a gdbstub ready? @)

If this happens then the process inside the guest which is doing this
will get a Segmentation Fault, because we'll deliver a GPF to the kernel
at that EIP.  In practice, glibc doesn't do this that I have found.  The
note is there so I think harder about it if anyone reports strange segvs
under lguest 8)

> > +pending_dma:
> > +	put_user(lg->pending_dma, (unsigned long *)user);
> > +	put_user(lg->pending_addr, (unsigned long *)user+1);
> 
> error checking? How do you avoid loops?

Why?  And I still don't get what loops?

> > +	if (cpu_has_pge) { /* We have a broader idea of "global". */
> > +		cpu_had_pge = 1;
> > +		on_each_cpu(adjust_pge, 0, 0, 1);
> 
> cpu hotplug? 

Good catch.  Should lock out cpu hotplug during this.  Once it's done,
we're fine, because we clear the feature bit.  Same when putting it
back.

> > +		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
> > +	}
> > +	return 0;
> > +}
> > 
> > +	case LHCALL_CRASH: {
> > +		char msg[128];
> > +		lhread(lg, msg, regs->edx, sizeof(msg));
> > +		msg[sizeof(msg)-1] = '\0';
> 
> Might be safer to vet for isprint here.

Hmm, I hope the kasprintf won't barf... this buffer gets handed straight
to the lguest process on its next read.

> > +#define log(...)					\
> > +	do {						\
> > +		mm_segment_t oldfs = get_fs();		\
> > +		char buf[100];				\
> 
> At least older gccs will accumulate the bufs in a function, eventually possibly blowing
> the stack. Better use a function.

Or I'll kill the macro altogether.  It's useful for shotgun debugging a
guest, but it's unused.

> > +	/* If they're halted, we re-enable interrupts. */
> > +	if (lg->halted) {
> > +		/* Re-enable interrupts. */
> > +		put_user(512, &lg->lguest_data->irq_enabled);
> 
> interesting magic number

Yeah, we don't define it anywhere, and we probably should.  From
irqflags.h:

static inline int raw_irqs_disabled_flags(unsigned long flags)
{
	return !(flags & (1 << 9));
}

8(

> > +	/* Ignore NMI, doublefault, hypercall, spurious interrupt. */
> > +	if (i == 2 || i == 8 || i == 15 || i == LGUEST_TRAP_ENTRY)
> > +		return;
> > +	/* FIXME: We should handle debug and int3 */
> > +	else if (i == 1 || i == 3)
> > +		return;
> > +	/* We intercept page fault, general protection fault and fpu missing */
> > +	else if (i == 13)
> > +		copy_trap(lg, &lg->gpf_trap, &d);
> > +	else if (i == 14)
> > +		copy_trap(lg, &lg->page_trap, &d);
> > +	else if (i == 7)
> > +		copy_trap(lg, &lg->fpu_trap, &d);
> > +	/* Other traps go straight to guest. */
> > +	else if (i < FIRST_EXTERNAL_VECTOR || i == SYSCALL_VECTOR)
> > +		setup_idt(lg, i, &d);
> > +	/* A virtual interrupt */
> > +	else if (i < FIRST_EXTERNAL_VECTOR + LGUEST_IRQS)
> > +		copy_trap(lg, &lg->interrupt[i-FIRST_EXTERNAL_VECTOR], &d);\
> 
> switch is not cool enough anymore?

It would have to be a switch then gunk at the bottom, because those last
two tests don't switch-ify.  IIRC I changed back from a switch because
of that.

> > +	down(&lguest_lock);
> 
> i suspect mutexes are the new way to do this

Yep, will replace.

> > +	down_read(&current->mm->mmap_sem);
> > +	if (get_futex_key((u32 __user *)addr, &key) != 0) {
> > +		kill_guest(lg, "bad dma address %#lx", addr);
> > +		goto unlock;
> 
> Risky? Use probe_kernel_address et.al.?

No, get_futex_key handles anything; we rely on that in futex.c

> > +#if 0
> > +/* FIXME: Use asm-offsets here... */
> 
> Remove?

Yep, done in the split-up version...

> > +extern int mce_disabled;
> 
> tststs

I'll get that too 8)

> > +
> > +/* FIXME: Update iff tsc rate changes. */
> 
> It does.

Hey, but I have a FIXME for it!

> > +static fastcall void lguest_cpuid(unsigned int *eax, unsigned int *ebx,
> > +				 unsigned int *ecx, unsigned int *edx)
> > +{
> > +	int is_feature = (*eax == 1);
> > +
> > +	asm volatile ("cpuid"
> > +		      : "=a" (*eax),
> > +			"=b" (*ebx),
> > +			"=c" (*ecx),
> > +			"=d" (*edx)
> > +		      : "0" (*eax), "2" (*ecx));
> 
> What's wrong with the standard cpuid*() macros?

Good call... we expose native_cpuid so I should use that (I can't use
cpuid: this *is* cpuid!)

> > +	extern struct Xgt_desc_struct cpu_gdt_descr;
> > +	extern struct i386_pda boot_pda;
> 
> No externs in .c

Yes, ugly code.  Usually this stuff is done in asm, so it doesn't exist
in a header.  I'll fix it.

> > +
> > +	paravirt_ops.name = "lguest";
> 
> Can you just statically initialize this and then copy over? 

Sure, but then I'll hit all the things I don't want to override, and
it'll be far less clear.

> > +	asm volatile ("mov %0, %%gs" : : "r" (__KERNEL_PDA) : "memory");
> 
> This will be %fs soon.

I know, I had to change this back to backport from -mm tree 8(
Fortunately, the breakage is *really* obvious when it happens.

> ... haven't read everything else. the IO driver earlier was also not very closely looked at.

OK, I'll resend patches (in 4 parts) based on these comments (and
Andrew's).

Thanks!
Rusty.


