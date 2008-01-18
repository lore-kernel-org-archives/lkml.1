Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbYARAiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbYARAiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbYARAg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:36:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759910AbYARAgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:36:22 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/7] More lguest massage.
Date: Thu, 17 Jan 2008 22:35:49 -0200
Message-Id: <12006165781954-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12006165743557-git-send-email-gcosta@redhat.com>
References: <1200616550283-git-send-email-gcosta@redhat.com> <12006165571406-git-send-email-gcosta@redhat.com> <1200616561270-git-send-email-gcosta@redhat.com> <12006165651341-git-send-email-gcosta@redhat.com> <12006165701019-git-send-email-gcosta@redhat.com> <12006165743557-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wecan save some lines of code by getting rid of
*lg= cpu... lines of code spread everywhere by now.

he new macro lg_data(cpu) is used anywhere we'd otherwise use the
cpu->lg->lguest_dataconstruction, to prevent lines getting to big.

Signed-off-by:Glauber de Oliveira Costa <gcosta@redhat.com>
---
drivers/lguest/core.c                 |   24 +++----
drivers/lguest/hypercalls.c           |   49 +++++++--------
drivers/lguest/interrupts_and_traps.c |   54 ++++++++--------
drivers/lguest/lg.h                   |   30 +++++----
drivers/lguest/page_tables.c          |  114 ++++++++++++++++----------------
drivers/lguest/segments.c             |    8 +--
drivers/lguest/x86/core.c             |   30 ++++-----
7 files changed, 149 insertions(+), 160 deletions(-)

diff--git a/drivers/lguest/core.c b/drivers/lguest/core.c
index4c26ba7..bb42fd0 100644
---a/drivers/lguest/core.c
+++b/drivers/lguest/core.c
@@-151,23 +151,23 @@ int lguest_address_ok(const struct lguest *lg,
/* This routine copies memory from the Guest.  Here we can see how useful the
 * kill_lguest() routine we met in the Launcher can be: we return a random
 * value (all zeroes) instead of needing to return an error. */
-void__lgread(struct lguest *lg, void *b, unsigned long addr, unsigned bytes)
+void__lgread(struct lg_cpu *cpu, void *b, unsigned long addr, unsigned bytes)
{
-	if(!lguest_address_ok(lg, addr, bytes)
-	   || copy_from_user(b, lg->mem_base + addr, bytes) != 0) {
+	if(!lguest_address_ok(cpu->lg, addr, bytes)
+	   || copy_from_user(b, cpu->lg->mem_base + addr, bytes) != 0) {
		/* copy_from_user should do this, but as we rely on it... */
		memset(b, 0, bytes);
-		kill_guest(lg,"bad read address %#lx len %u", addr, bytes);
+		kill_guest(cpu,"bad read address %#lx len %u", addr, bytes);
	}
}

/* This is the write (copy into guest) version. */
-void__lgwrite(struct lguest *lg, unsigned long addr, const void *b,
+void__lgwrite(struct lg_cpu *cpu, unsigned long addr, const void *b,
	       unsigned bytes)
{
-	if(!lguest_address_ok(lg, addr, bytes)
-	   || copy_to_user(lg->mem_base + addr, b, bytes) != 0)
-		kill_guest(lg,"bad write address %#lx len %u", addr, bytes);
+	if(!lguest_address_ok(cpu->lg, addr, bytes)
+	   || copy_to_user(cpu->lg->mem_base + addr, b, bytes) != 0)
+		kill_guest(cpu,"bad write address %#lx len %u", addr, bytes);
}
/*:*/

@@-176,10 +176,8 @@ void __lgwrite(struct lguest *lg, unsigned long addr, const void *b,
 * going around and around until something interesting happens. */
int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
{
-	structlguest *lg = cpu->lg;
-
	/* We stop running once the Guest is dead. */
-	while(!lg->dead) {
+	while(!cpu->lg->dead) {
		/* First we run any hypercalls the Guest wants done. */
		if (cpu->hcall)
			do_hypercalls(cpu);
@@-212,7 +210,7 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)

		/* Just make absolutely sure the Guest is still alive.  One of
		 * those hypercalls could have been fatal, for example. */
-		if(lg->dead)
+		if(cpu->lg->dead)
			break;

		/* If the Guest asked to be stopped, we sleep.  The Guest's
@@-237,7 +235,7 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
		lguest_arch_handle_trap(cpu);
	}

-	if(lg->dead == ERR_PTR(-ERESTART))
+	if(cpu->lg->dead == ERR_PTR(-ERESTART))
		return -ERESTART;
	/* The Guest is dead => "No such file or directory" */
	return -ENOENT;
diff--git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index0471018..32666d0 100644
---a/drivers/lguest/hypercalls.c
+++b/drivers/lguest/hypercalls.c
@@-31,8 +31,6 @@
 * Or gets killed.  Or, in the case of LHCALL_CRASH, both. */
static void do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
{
-	structlguest *lg = cpu->lg;
-
	switch (args->arg0) {
	case LHCALL_FLUSH_ASYNC:
		/* This call does nothing, except by breaking out of the Guest
@@-41,7 +39,7 @@ static void do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
	case LHCALL_LGUEST_INIT:
		/* You can't get here unless you're already initialized.  Don't
		 * do that. */
-		kill_guest(lg,"already have lguest_data");
+		kill_guest(cpu,"already have lguest_data");
		break;
	case LHCALL_SHUTDOWN: {
		/* Shutdown is such a trivial hypercall that we do it in four
@@-49,11 +47,11 @@ static void do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
		char msg[128];
		/* If the lgread fails, it will call kill_guest() itself; the
		 * kill_guest() with the message will be ignored. */
-		__lgread(lg,msg, args->arg1, sizeof(msg));
+		__lgread(cpu,msg, args->arg1, sizeof(msg));
		msg[sizeof(msg)-1] = '\0';
-		kill_guest(lg,"CRASH: %s", msg);
+		kill_guest(cpu,"CRASH: %s", msg);
		if (args->arg2 == LGUEST_SHUTDOWN_RESTART)
-			lg->dead= ERR_PTR(-ERESTART);
+			cpu->lg->dead= ERR_PTR(-ERESTART);
		break;
	}
	case LHCALL_FLUSH_TLB:
@@-74,10 +72,10 @@ static void do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
		guest_set_stack(cpu, args->arg1, args->arg2, args->arg3);
		break;
	case LHCALL_SET_PTE:
-		guest_set_pte(lg,args->arg1, args->arg2, __pte(args->arg3));
+		guest_set_pte(cpu,args->arg1, args->arg2, __pte(args->arg3));
		break;
	case LHCALL_SET_PMD:
-		guest_set_pmd(lg,args->arg1, args->arg2);
+		guest_set_pmd(cpu->lg,args->arg1, args->arg2);
		break;
	case LHCALL_SET_CLOCKEVENT:
		guest_set_clockevent(cpu, args->arg1);
@@-96,7 +94,7 @@ static void do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
	default:
		/* It should be an architecture-specific hypercall. */
		if (lguest_arch_do_hcall(cpu, args))
-			kill_guest(lg,"Bad hypercall %li\n", args->arg0);
+			kill_guest(cpu,"Bad hypercall %li\n", args->arg0);
	}
}
/*:*/
@@-112,10 +110,9 @@ static void do_async_hcalls(struct lg_cpu *cpu)
{
	unsigned int i;
	u8 st[LHCALL_RING_SIZE];
-	structlguest *lg = cpu->lg;

	/* For simplicity, we copy the entire call status array in at once. */
-	if(copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
+	if(copy_from_user(&st, &cpu->lg->lguest_data->hcall_status, sizeof(st)))
		return;

	/* We process "struct lguest_data"s hcalls[] ring once. */
@@-137,9 +134,9 @@ static void do_async_hcalls(struct lg_cpu *cpu)

		/* Copy the hypercall arguments into a local copy of
		 * the hcall_args struct. */
-		if(copy_from_user(&args, &lg->lguest_data->hcalls[n],
+		if(copy_from_user(&args, &cpu->lg->lguest_data->hcalls[n],
				   sizeof(struct hcall_args))) {
-			kill_guest(lg,"Fetching async hypercalls");
+			kill_guest(cpu,"Fetching async hypercalls");
			break;
		}

@@-147,8 +144,8 @@ static void do_async_hcalls(struct lg_cpu *cpu)
		do_hcall(cpu, &args);

		/* Mark the hypercall done. */
-		if(put_user(0xFF, &lg->lguest_data->hcall_status[n])) {
-			kill_guest(lg,"Writing result for async hypercall");
+		if(put_user(0xFF, &cpu->lg->lguest_data->hcall_status[n])) {
+			kill_guest(cpu,"Writing result for async hypercall");
			break;
		}

@@-163,29 +160,28 @@ static void do_async_hcalls(struct lg_cpu *cpu)
 * Guest makes a hypercall, we end up here to set things up: */
static void initialize(struct lg_cpu *cpu)
{
-	structlguest *lg = cpu->lg;
	/* You can't do anything until you're initialized.  The Guest knows the
	 * rules, so we're unforgiving here. */
	if (cpu->hcall->arg0 != LHCALL_LGUEST_INIT) {
-		kill_guest(lg,"hypercall %li before INIT", cpu->hcall->arg0);
+		kill_guest(cpu,"hypercall %li before INIT", cpu->hcall->arg0);
		return;
	}

	if (lguest_arch_init_hypercalls(cpu))
-		kill_guest(lg,"bad guest page %p", lg->lguest_data);
+		kill_guest(cpu,"bad guest page %p", cpu->lg->lguest_data);

	/* The Guest tells us where we're not to deliver interrupts by putting
	 * the range of addresses into "struct lguest_data". */
-	if(get_user(lg->noirq_start, &lg->lguest_data->noirq_start)
-	   || get_user(lg->noirq_end, &lg->lguest_data->noirq_end))
-		kill_guest(lg,"bad guest page %p", lg->lguest_data);
+	if(get_user(cpu->lg->noirq_start, &cpu->lg->lguest_data->noirq_start)
+	   || get_user(cpu->lg->noirq_end, &cpu->lg->lguest_data->noirq_end))
+		kill_guest(cpu,"bad guest page %p", cpu->lg->lguest_data);

	/* We write the current time into the Guest's data page once so it can
	 * set its clock. */
-	write_timestamp(lg);
+	write_timestamp(cpu);

	/* page_tables.c will also do some setup. */
-	page_table_guest_data_init(lg);
+	page_table_guest_data_init(cpu);

	/* This is the one case where the above accesses might have been the
	 * first write to a Guest page.  This may have caused a copy-on-write
@@-237,10 +233,11 @@ void do_hypercalls(struct lg_cpu *cpu)

/* This routine supplies the Guest with time: it's used for wallclock time at
 * initial boot and as a rough time source if the TSC isn't available. */
-voidwrite_timestamp(struct lguest *lg)
+voidwrite_timestamp(struct lg_cpu *cpu)
{
	struct timespec now;
	ktime_get_real_ts(&now);
-	if(copy_to_user(&lg->lguest_data->time, &now, sizeof(struct timespec)))
-		kill_guest(lg,"Writing timestamp");
+	if(copy_to_user(&cpu->lg->lguest_data->time,
+			&now, sizeof(struct timespec)))
+		kill_guest(cpu,"Writing timestamp");
}
diff--git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index9ac7455..cef64d5 100644
---a/drivers/lguest/interrupts_and_traps.c
+++b/drivers/lguest/interrupts_and_traps.c
@@-41,11 +41,11 @@ static int idt_present(u32 lo, u32 hi)

/* We need a helper to "push" a value onto the Guest's stack, since that's a
 * big part of what delivering an interrupt does. */
-staticvoid push_guest_stack(struct lguest *lg, unsigned long *gstack, u32 val)
+staticvoid push_guest_stack(struct lg_cpu *cpu, unsigned long *gstack, u32 val)
{
	/* Stack grows upwards: move stack then write value. */
	*gstack -= 4;
-	lgwrite(lg,*gstack, u32, val);
+	lgwrite(cpu,*gstack, u32, val);
}

/*H:210 The set_guest_interrupt() routine actually delivers the interrupt or
@@-65,7 +65,6 @@ static void set_guest_interrupt(struct lg_cpu *cpu, u32 lo, u32 hi, int has_err)
	unsigned long gstack, origstack;
	u32 eflags, ss, irq_enable;
	unsigned long virtstack;
-	structlguest *lg = cpu->lg;

	/* There are two cases for interrupts: one where the Guest is already
	 * in the kernel, and a more complex one where the Guest is in
@@-81,8 +80,8 @@ static void set_guest_interrupt(struct lg_cpu *cpu, u32 lo, u32 hi, int has_err)
		 * stack: when the Guest does an "iret" back from the interrupt
		 * handler the CPU will notice they're dropping privilege
		 * levels and expect these here. */
-		push_guest_stack(lg,&gstack, cpu->regs->ss);
-		push_guest_stack(lg,&gstack, cpu->regs->esp);
+		push_guest_stack(cpu,&gstack, cpu->regs->ss);
+		push_guest_stack(cpu,&gstack, cpu->regs->esp);
	} else {
		/* We're staying on the same Guest (kernel) stack. */
		virtstack = cpu->regs->esp;
@@-96,20 +95,20 @@ static void set_guest_interrupt(struct lg_cpu *cpu, u32 lo, u32 hi, int has_err)
	 * Guest's "irq_enabled" field into the eflags word: we saw the Guest
	 * copy it back in "lguest_iret". */
	eflags = cpu->regs->eflags;
-	if(get_user(irq_enable, &lg->lguest_data->irq_enabled) == 0
+	if(get_user(irq_enable, &lg_data(cpu)->irq_enabled) == 0
	    && !(irq_enable & X86_EFLAGS_IF))
		eflags &= ~X86_EFLAGS_IF;

	/* An interrupt is expected to push three things on the stack: the old
	 * "eflags" word, the old code segment, and the old instruction
	 * pointer. */
-	push_guest_stack(lg,&gstack, eflags);
-	push_guest_stack(lg,&gstack, cpu->regs->cs);
-	push_guest_stack(lg,&gstack, cpu->regs->eip);
+	push_guest_stack(cpu,&gstack, eflags);
+	push_guest_stack(cpu,&gstack, cpu->regs->cs);
+	push_guest_stack(cpu,&gstack, cpu->regs->eip);

	/* For the six traps which supply an error code, we push that, too. */
	if (has_err)
-		push_guest_stack(lg,&gstack, cpu->regs->errcode);
+		push_guest_stack(cpu,&gstack, cpu->regs->errcode);

	/* Now we've pushed all the old state, we change the stack, the code
	 * segment and the address to execute. */
@@-121,8 +120,8 @@ static void set_guest_interrupt(struct lg_cpu *cpu, u32 lo, u32 hi, int has_err)
	/* There are two kinds of interrupt handlers: 0xE is an "interrupt
	 * gate" which expects interrupts to be disabled on entry. */
	if (idt_type(lo, hi) == 0xE)
-		if(put_user(0, &lg->lguest_data->irq_enabled))
-			kill_guest(lg,"Disabling interrupts");
+		if(put_user(0, &lg_data(cpu)->irq_enabled))
+			kill_guest(cpu,"Disabling interrupts");
}

/*H:205
@@-133,17 +132,16 @@ static void set_guest_interrupt(struct lg_cpu *cpu, u32 lo, u32 hi, int has_err)
void maybe_do_interrupt(struct lg_cpu *cpu)
{
	unsigned int irq;
-	structlguest *lg = cpu->lg;
	DECLARE_BITMAP(blk, LGUEST_IRQS);
	struct desc_struct *idt;

	/* If the Guest hasn't even initialized yet, we can do nothing. */
-	if(!lg->lguest_data)
+	if(!lg_data(cpu))
		return;

	/* Take our "irqs_pending" array and remove any interrupts the Guest
	 * wants blocked: the result ends up in "blk". */
-	if(copy_from_user(&blk, lg->lguest_data->blocked_interrupts,
+	if(copy_from_user(&blk, lg_data(cpu)->blocked_interrupts,
			   sizeof(blk)))
		return;

@@-157,19 +155,20 @@ void maybe_do_interrupt(struct lg_cpu *cpu)

	/* They may be in the middle of an iret, where they asked us never to
	 * deliver interrupts. */
-	if(cpu->regs->eip >= lg->noirq_start && cpu->regs->eip < lg->noirq_end)
+	if(cpu->regs->eip >= cpu->lg->noirq_start &&
+	  (cpu->regs->eip < cpu->lg->noirq_end))
		return;

	/* If they're halted, interrupts restart them. */
	if (cpu->halted) {
		/* Re-enable interrupts. */
-		if(put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled))
-			kill_guest(lg,"Re-enabling interrupts");
+		if(put_user(X86_EFLAGS_IF, &lg_data(cpu)->irq_enabled))
+			kill_guest(cpu,"Re-enabling interrupts");
		cpu->halted = 0;
	} else {
		/* Otherwise we check if they have interrupts disabled. */
		u32 irq_enabled;
-		if(get_user(irq_enabled, &lg->lguest_data->irq_enabled))
+		if(get_user(irq_enabled, &lg_data(cpu)->irq_enabled))
			irq_enabled = 0;
		if (!irq_enabled)
			return;
@@-194,7 +193,7 @@ void maybe_do_interrupt(struct lg_cpu *cpu)
	 * did this more often, but it can actually be quite slow: doing it
	 * here is a compromise which means at least it gets updated every
	 * timer interrupt. */
-	write_timestamp(lg);
+	write_timestamp(cpu);
}
/*:*/

@@-315,10 +314,9 @@ void pin_stack_pages(struct lg_cpu *cpu)
{
	unsigned int i;

-	structlguest *lg = cpu->lg;
	/* Depending on the CONFIG_4KSTACKS option, the Guest can have one or
	 * two pages of stack space. */
-	for(i = 0; i < lg->stack_pages; i++)
+	for(i = 0; i < cpu->lg->stack_pages; i++)
		/* The stack grows *upwards*, so the address we're given is the
		 * start of the page after the kernel stack.  Subtract one to
		 * get back onto the first stack page, and keep subtracting to
@@-339,10 +337,10 @@ void guest_set_stack(struct lg_cpu *cpu, u32 seg, u32 esp, unsigned int pages)
	/* You are not allowed have a stack segment with privilege level 0: bad
	 * Guest! */
	if ((seg & 0x3) != GUEST_PL)
-		kill_guest(cpu->lg,"bad stack segment %i", seg);
+		kill_guest(cpu,"bad stack segment %i", seg);
	/* We only expect one or two stack pages. */
	if (pages > 2)
-		kill_guest(cpu->lg,"bad stack pages %u", pages);
+		kill_guest(cpu,"bad stack pages %u", pages);
	/* Save where the stack is, and how many pages */
	cpu->ss1 = seg;
	cpu->esp1 = esp;
@@-356,7 +354,7 @@ void guest_set_stack(struct lg_cpu *cpu, u32 seg, u32 esp, unsigned int pages)

/*H:235 This is the routine which actually checks the Guest's IDT entry and
 * transfers it into the entry in "struct lguest": */
-staticvoid set_trap(struct lguest *lg, struct desc_struct *trap,
+staticvoid set_trap(struct lg_cpu *cpu, struct desc_struct *trap,
		     unsigned int num, u32 lo, u32 hi)
{
	u8 type = idt_type(lo, hi);
@@-369,7 +367,7 @@ static void set_trap(struct lguest *lg, struct desc_struct *trap,

	/* We only support interrupt and trap gates. */
	if (type != 0xE && type != 0xF)
-		kill_guest(lg,"bad IDT type %i", type);
+		kill_guest(cpu,"bad IDT type %i", type);

	/* We only copy the handler address, present bit, privilege level and
	 * type.  The privilege level controls where the trap can be triggered
@@-399,9 +397,9 @@ void load_guest_idt_entry(struct lg_cpu *cpu, unsigned int num, u32 lo, u32 hi)

	/* Check that the Guest doesn't try to step outside the bounds. */
	if (num >= ARRAY_SIZE(cpu->arch.idt))
-		kill_guest(cpu->lg,"Setting idt entry %u", num);
+		kill_guest(cpu,"Setting idt entry %u", num);
	else
-		set_trap(cpu->lg,&cpu->arch.idt[num], num, lo, hi);
+		set_trap(cpu,&cpu->arch.idt[num], num, lo, hi);
}

/* The default entry for each interrupt points into the Switcher routines which
diff--git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index5458af8..f9707cf 100644
---a/drivers/lguest/lg.h
+++b/drivers/lguest/lg.h
@@-106,27 +106,29 @@ struct lguest
	const char *dead;
};

+#definelg_data(cpu) ((cpu)->lg->lguest_data)
+
extern struct mutex lguest_lock;

/* core.c: */
int lguest_address_ok(const struct lguest *lg,
		      unsigned long addr, unsigned long len);
-void__lgread(struct lguest *, void *, unsigned long, unsigned);
-void__lgwrite(struct lguest *, unsigned long, const void *, unsigned);
+void__lgread(struct lg_cpu *, void *, unsigned long, unsigned);
+void__lgwrite(struct lg_cpu *, unsigned long, const void *, unsigned);

/*H:035 Using memory-copy operations like that is usually inconvient, so we
 * have the following helper macros which read and write a specific type (often
 * an unsigned long).
 *
 * This reads into a variable of the given type then returns that. */
-#definelgread(lg, addr, type)						\
-	({type _v; __lgread((lg), &_v, (addr), sizeof(_v)); _v; })
+#definelgread(cpu, addr, type)						\
+	({type _v; __lgread((cpu), &_v, (addr), sizeof(_v)); _v; })

/* This checks that the variable is of the given type, then writes it out. */
-#definelgwrite(lg, addr, type, val)				\
+#definelgwrite(cpu, addr, type, val)				\
	do {							\
		typecheck(type, val);				\
-		__lgwrite((lg),(addr), &(val), sizeof(val));	\
+		__lgwrite((cpu),(addr), &(val), sizeof(val));	\
	} while(0)
/* (end of memory access helper routines) :*/

@@-170,13 +172,13 @@ void guest_new_pagetable(struct lg_cpu *cpu, unsigned long pgtable);
void guest_set_pmd(struct lguest *lg, unsigned long gpgdir, u32 i);
void guest_pagetable_clear_all(struct lg_cpu *cpu);
void guest_pagetable_flush_user(struct lg_cpu *cpu);
-voidguest_set_pte(struct lguest *lg, unsigned long gpgdir,
+voidguest_set_pte(struct lg_cpu *cpu, unsigned long gpgdir,
		   unsigned long vaddr, pte_t val);
void map_switcher_in_guest(struct lg_cpu *cpu, struct lguest_pages *pages);
int demand_page(struct lg_cpu *cpu, unsigned long cr2, int errcode);
void pin_page(struct lg_cpu *cpu, unsigned long vaddr);
unsigned long guest_pa(struct lg_cpu *cpu, unsigned long vaddr);
-voidpage_table_guest_data_init(struct lguest *lg);
+voidpage_table_guest_data_init(struct lg_cpu *cpu);

/* <arch>/core.c: */
void lguest_arch_host_init(void);
@@-196,7 +198,7 @@ void lguest_device_remove(void);

/* hypercalls.c: */
void do_hypercalls(struct lg_cpu *cpu);
-voidwrite_timestamp(struct lguest *lg);
+voidwrite_timestamp(struct lg_cpu *cpu);

/*L:035
 * Let's step aside for the moment, to study one important routine that's used
@@-222,12 +224,12 @@ void write_timestamp(struct lguest *lg);
 * Like any macro which uses an "if", it is safely wrapped in a run-once "do {
 * } while(0)".
 */
-#definekill_guest(lg, fmt...)					\
+#definekill_guest(cpu, fmt...)					\
do {								\
-	if(!(lg)->dead) {					\
-		(lg)->dead= kasprintf(GFP_ATOMIC, fmt);	\
-		if(!(lg)->dead)				\
-			(lg)->dead= ERR_PTR(-ENOMEM);		\
+	if(!(cpu)->lg->dead) {					\
+		(cpu)->lg->dead= kasprintf(GFP_ATOMIC, fmt);	\
+		if(!(cpu)->lg->dead)				\
+			(cpu)->lg->dead= ERR_PTR(-ENOMEM);	\
	}							\
} while(0)
/* (End of aside) :*/
diff--git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
indexc9acafc..399c05d 100644
---a/drivers/lguest/page_tables.c
+++b/drivers/lguest/page_tables.c
@@-68,17 +68,17 @@ static DEFINE_PER_CPU(pte_t *, switcher_pte_pages);
 * page directory entry (PGD) for that address.  Since we keep track of several
 * page tables, the "i" argument tells us which one we're interested in (it's
 * usually the current one). */
-staticpgd_t *spgd_addr(struct lguest *lg, u32 i, unsigned long vaddr)
+staticpgd_t *spgd_addr(struct lg_cpu *cpu, u32 i, unsigned long vaddr)
{
	unsigned int index = pgd_index(vaddr);

	/* We kill any Guest trying to touch the Switcher addresses. */
	if (index >= SWITCHER_PGD_INDEX) {
-		kill_guest(lg,"attempt to access switcher pages");
+		kill_guest(cpu,"attempt to access switcher pages");
		index = 0;
	}
	/* Return a pointer index'th pgd entry for the i'th page table. */
-	return&lg->pgdirs[i].pgdir[index];
+	return&cpu->lg->pgdirs[i].pgdir[index];
}

/* This routine then takes the page directory entry returned above, which
@@-137,7 +137,7 @@ static unsigned long get_pfn(unsigned long virtpfn, int write)
 * entry can be a little tricky.  The flags are (almost) the same, but the
 * Guest PTE contains a virtual page number: the CPU needs the real page
 * number. */
-staticpte_t gpte_to_spte(struct lguest *lg, pte_t gpte, int write)
+staticpte_t gpte_to_spte(struct lg_cpu *cpu, pte_t gpte, int write)
{
	unsigned long pfn, base, flags;

@@-148,7 +148,7 @@ static pte_t gpte_to_spte(struct lguest *lg, pte_t gpte, int write)
	flags = (pte_flags(gpte) & ~_PAGE_GLOBAL);

	/* The Guest's pages are offset inside the Launcher. */
-	base= (unsigned long)lg->mem_base / PAGE_SIZE;
+	base= (unsigned long)cpu->lg->mem_base / PAGE_SIZE;

	/* We need a temporary "unsigned long" variable to hold the answer from
	 * get_pfn(), because it returns 0xFFFFFFFF on failure, which wouldn't
@@-156,7 +156,7 @@ static pte_t gpte_to_spte(struct lguest *lg, pte_t gpte, int write)
	 * page, given the virtual number. */
	pfn = get_pfn(base + pte_pfn(gpte), write);
	if (pfn == -1UL) {
-		kill_guest(lg,"failed to get page %lu", pte_pfn(gpte));
+		kill_guest(cpu,"failed to get page %lu", pte_pfn(gpte));
		/* When we destroy the Guest, we'll go through the shadow page
		 * tables and release_pte() them.  Make sure we don't think
		 * this one is valid! */
@@-176,17 +176,18 @@ static void release_pte(pte_t pte)
}
/*:*/

-staticvoid check_gpte(struct lguest *lg, pte_t gpte)
+staticvoid check_gpte(struct lg_cpu *cpu, pte_t gpte)
{
	if ((pte_flags(gpte) & (_PAGE_PWT|_PAGE_PSE))
-	   || pte_pfn(gpte) >= lg->pfn_limit)
-		kill_guest(lg,"bad page table entry");
+	   || pte_pfn(gpte) >= cpu->lg->pfn_limit)
+		kill_guest(cpu,"bad page table entry");
}

-staticvoid check_gpgd(struct lguest *lg, pgd_t gpgd)
+staticvoid check_gpgd(struct lg_cpu *cpu, pgd_t gpgd)
{
-	if((pgd_flags(gpgd) & ~_PAGE_TABLE) || pgd_pfn(gpgd) >= lg->pfn_limit)
-		kill_guest(lg,"bad page directory entry");
+	if((pgd_flags(gpgd) & ~_PAGE_TABLE) ||
+	  (pgd_pfn(gpgd) >= cpu->lg->pfn_limit))
+		kill_guest(cpu,"bad page directory entry");
}

/*H:330
@@-206,27 +207,26 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
	unsigned long gpte_ptr;
	pte_t gpte;
	pte_t *spte;
-	structlguest *lg = cpu->lg;

	/* First step: get the top-level Guest page table entry. */
-	gpgd= lgread(lg, gpgd_addr(cpu, vaddr), pgd_t);
+	gpgd= lgread(cpu, gpgd_addr(cpu, vaddr), pgd_t);
	/* Toplevel not present?  We can't map it in. */
	if (!(pgd_flags(gpgd) & _PAGE_PRESENT))
		return 0;

	/* Now look at the matching shadow entry. */
-	spgd= spgd_addr(lg, cpu->cpu_pgd, vaddr);
+	spgd= spgd_addr(cpu, cpu->cpu_pgd, vaddr);
	if (!(pgd_flags(*spgd) & _PAGE_PRESENT)) {
		/* No shadow entry: allocate a new shadow PTE page. */
		unsigned long ptepage = get_zeroed_page(GFP_KERNEL);
		/* This is not really the Guest's fault, but killing it is
		 * simple for this corner case. */
		if (!ptepage) {
-			kill_guest(lg,"out of memory allocating pte page");
+			kill_guest(cpu,"out of memory allocating pte page");
			return 0;
		}
		/* We check that the Guest pgd is OK. */
-		check_gpgd(lg,gpgd);
+		check_gpgd(cpu,gpgd);
		/* And we copy the flags to the shadow PGD entry.  The page
		 * number in the shadow PGD is the page we just allocated. */
		*spgd = __pgd(__pa(ptepage) | pgd_flags(gpgd));
@@-235,7 +235,7 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
	/* OK, now we look at the lower level in the Guest page table: keep its
	 * address, because we might update it later. */
	gpte_ptr = gpte_addr(gpgd, vaddr);
-	gpte= lgread(lg, gpte_ptr, pte_t);
+	gpte= lgread(cpu, gpte_ptr, pte_t);

	/* If this page isn't in the Guest page tables, we can't page it in. */
	if (!(pte_flags(gpte) & _PAGE_PRESENT))
@@-252,7 +252,7 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)

	/* Check that the Guest PTE flags are OK, and the page number is below
	 * the pfn_limit (ie. not mapping the Launcher binary). */
-	check_gpte(lg,gpte);
+	check_gpte(cpu,gpte);

	/* Add the _PAGE_ACCESSED and (for a write) _PAGE_DIRTY flag */
	gpte = pte_mkyoung(gpte);
@@-268,17 +268,17 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
	/* If this is a write, we insist that the Guest page is writable (the
	 * final arg to gpte_to_spte()). */
	if (pte_dirty(gpte))
-		*spte= gpte_to_spte(lg, gpte, 1);
+		*spte= gpte_to_spte(cpu, gpte, 1);
	else
		/* If this is a read, don't set the "writable" bit in the page
		 * table entry, even if the Guest says it's writable.  That way
		 * we will come back here when a write does actually occur, so
		 * we can update the Guest's _PAGE_DIRTY flag. */
-		*spte= gpte_to_spte(lg, pte_wrprotect(gpte), 0);
+		*spte= gpte_to_spte(cpu, pte_wrprotect(gpte), 0);

	/* Finally, we write the Guest PTE entry back: we've set the
	 * _PAGE_ACCESSED and maybe the _PAGE_DIRTY flags. */
-	lgwrite(lg,gpte_ptr, pte_t, gpte);
+	lgwrite(cpu,gpte_ptr, pte_t, gpte);

	/* The fault is fixed, the page table is populated, the mapping
	 * manipulated, the result returned and the code complete.  A small
@@-303,7 +303,7 @@ static int page_writable(struct lg_cpu *cpu, unsigned long vaddr)
	unsigned long flags;

	/* Look at the current top level entry: is it present? */
-	spgd= spgd_addr(cpu->lg, cpu->cpu_pgd, vaddr);
+	spgd= spgd_addr(cpu, cpu->cpu_pgd, vaddr);
	if (!(pgd_flags(*spgd) & _PAGE_PRESENT))
		return 0;

@@-320,7 +320,7 @@ static int page_writable(struct lg_cpu *cpu, unsigned long vaddr)
void pin_page(struct lg_cpu *cpu, unsigned long vaddr)
{
	if (!page_writable(cpu, vaddr) && !demand_page(cpu, vaddr, 2))
-		kill_guest(cpu->lg,"bad stack page %#lx", vaddr);
+		kill_guest(cpu,"bad stack page %#lx", vaddr);
}

/*H:450 If we chase down the release_pgd() code, it looks like this: */
@@-372,14 +372,14 @@ unsigned long guest_pa(struct lg_cpu *cpu, unsigned long vaddr)
	pte_t gpte;

	/* First step: get the top-level Guest page table entry. */
-	gpgd= lgread(cpu->lg, gpgd_addr(cpu, vaddr), pgd_t);
+	gpgd= lgread(cpu, gpgd_addr(cpu, vaddr), pgd_t);
	/* Toplevel not present?  We can't map it in. */
	if (!(pgd_flags(gpgd) & _PAGE_PRESENT))
-		kill_guest(cpu->lg,"Bad address %#lx", vaddr);
+		kill_guest(cpu,"Bad address %#lx", vaddr);

-	gpte= lgread(cpu->lg, gpte_addr(gpgd, vaddr), pte_t);
+	gpte= lgread(cpu, gpte_addr(gpgd, vaddr), pte_t);
	if (!(pte_flags(gpte) & _PAGE_PRESENT))
-		kill_guest(cpu->lg,"Bad address %#lx", vaddr);
+		kill_guest(cpu,"Bad address %#lx", vaddr);

	return pte_pfn(gpte) * PAGE_SIZE | (vaddr & ~PAGE_MASK);
}
@@-404,16 +404,16 @@ static unsigned int new_pgdir(struct lg_cpu *cpu,
			      int *blank_pgdir)
{
	unsigned int next;
-	structlguest *lg = cpu->lg;

	/* We pick one entry at random to throw out.  Choosing the Least
	 * Recently Used might be better, but this is easy. */
-	next= random32() % ARRAY_SIZE(lg->pgdirs);
+	next= random32() % ARRAY_SIZE(cpu->lg->pgdirs);
	/* If it's never been allocated at all before, try now. */
-	if(!lg->pgdirs[next].pgdir) {
-		lg->pgdirs[next].pgdir= (pgd_t *)get_zeroed_page(GFP_KERNEL);
+	if(!cpu->lg->pgdirs[next].pgdir) {
+		cpu->lg->pgdirs[next].pgdir=
+					(pgd_t*)get_zeroed_page(GFP_KERNEL);
		/* If the allocation fails, just keep using the one we have */
-		if(!lg->pgdirs[next].pgdir)
+		if(!cpu->lg->pgdirs[next].pgdir)
			next = cpu->cpu_pgd;
		else
			/* This is a blank page, so there are no kernel
@@-421,9 +421,9 @@ static unsigned int new_pgdir(struct lg_cpu *cpu,
			*blank_pgdir = 1;
	}
	/* Record which Guest toplevel this shadows. */
-	lg->pgdirs[next].gpgdir= gpgdir;
+	cpu->lg->pgdirs[next].gpgdir= gpgdir;
	/* Release all the non-kernel mappings. */
-	flush_user_mappings(lg,next);
+	flush_user_mappings(cpu->lg,next);

	return next;
}
@@-436,13 +436,12 @@ static unsigned int new_pgdir(struct lg_cpu *cpu,
void guest_new_pagetable(struct lg_cpu *cpu, unsigned long pgtable)
{
	int newpgdir, repin = 0;
-	structlguest *lg = cpu->lg;

	/* Look to see if we have this one already. */
-	newpgdir= find_pgdir(lg, pgtable);
+	newpgdir= find_pgdir(cpu->lg, pgtable);
	/* If not, we allocate or mug an existing one: if it's a fresh one,
	 * repin gets set to 1. */
-	if(newpgdir == ARRAY_SIZE(lg->pgdirs))
+	if(newpgdir == ARRAY_SIZE(cpu->lg->pgdirs))
		newpgdir = new_pgdir(cpu, pgtable, &repin);
	/* Change the current pgd index to the new one. */
	cpu->cpu_pgd = newpgdir;
@@-499,11 +498,11 @@ void guest_pagetable_clear_all(struct lg_cpu *cpu)
 * _PAGE_ACCESSED then we can put a read-only PTE entry in immediately, and if
 * they set _PAGE_DIRTY then we can put a writable PTE entry in immediately.
 */
-staticvoid do_set_pte(struct lguest *lg, int idx,
+staticvoid do_set_pte(struct lg_cpu *cpu, int idx,
		       unsigned long vaddr, pte_t gpte)
{
	/* Look up the matching shadow page directory entry. */
-	pgd_t*spgd = spgd_addr(lg, idx, vaddr);
+	pgd_t*spgd = spgd_addr(cpu, idx, vaddr);

	/* If the top level isn't present, there's no entry to update. */
	if (pgd_flags(*spgd) & _PAGE_PRESENT) {
@@-515,8 +514,8 @@ static void do_set_pte(struct lguest *lg, int idx,
		 * as well put that entry they've given us in now.  This shaves
		 * 10% off a copy-on-write micro-benchmark. */
		if (pte_flags(gpte) & (_PAGE_DIRTY | _PAGE_ACCESSED)) {
-			check_gpte(lg,gpte);
-			*spte= gpte_to_spte(lg, gpte,
+			check_gpte(cpu,gpte);
+			*spte= gpte_to_spte(cpu, gpte,
					     pte_flags(gpte) & _PAGE_DIRTY);
		} else
			/* Otherwise kill it and we can demand_page() it in
@@-535,22 +534,22 @@ static void do_set_pte(struct lguest *lg, int idx,
 *
 * The benefit is that when we have to track a new page table, we can copy keep
 * all the kernel mappings.  This speeds up context switch immensely. */
-voidguest_set_pte(struct lguest *lg,
+voidguest_set_pte(struct lg_cpu *cpu,
		   unsigned long gpgdir, unsigned long vaddr, pte_t gpte)
{
	/* Kernel mappings must be changed on all top levels.  Slow, but
	 * doesn't happen often. */
-	if(vaddr >= lg->kernel_address) {
+	if(vaddr >= cpu->lg->kernel_address) {
		unsigned int i;
-		for(i = 0; i < ARRAY_SIZE(lg->pgdirs); i++)
-			if(lg->pgdirs[i].pgdir)
-				do_set_pte(lg,i, vaddr, gpte);
+		for(i = 0; i < ARRAY_SIZE(cpu->lg->pgdirs); i++)
+			if(cpu->lg->pgdirs[i].pgdir)
+				do_set_pte(cpu,i, vaddr, gpte);
	} else {
		/* Is this page table one we have a shadow for? */
-		intpgdir = find_pgdir(lg, gpgdir);
-		if(pgdir != ARRAY_SIZE(lg->pgdirs))
+		intpgdir = find_pgdir(cpu->lg, gpgdir);
+		if(pgdir != ARRAY_SIZE(cpu->lg->pgdirs))
			/* If so, do the update. */
-			do_set_pte(lg,pgdir, vaddr, gpte);
+			do_set_pte(cpu,pgdir, vaddr, gpte);
	}
}

@@-601,21 +600,22 @@ int init_guest_pagetable(struct lguest *lg, unsigned long pgtable)
}

/* When the Guest calls LHCALL_LGUEST_INIT we do more setup. */
-voidpage_table_guest_data_init(struct lguest *lg)
+voidpage_table_guest_data_init(struct lg_cpu *cpu)
{
	/* We get the kernel address: above this is all kernel memory. */
-	if(get_user(lg->kernel_address, &lg->lguest_data->kernel_address)
+	if(get_user(cpu->lg->kernel_address, &lg_data(cpu)->kernel_address)
	    /* We tell the Guest that it can't use the top 4MB of virtual
	     * addresses used by the Switcher. */
-	   || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
-	   || put_user(lg->pgdirs[0].gpgdir, &lg->lguest_data->pgdir))
-		kill_guest(lg,"bad guest page %p", lg->lguest_data);
+	   || put_user(4U*1024*1024, &lg_data(cpu)->reserve_mem)
+	   || put_user(cpu->lg->pgdirs[0].gpgdir, &lg_data(cpu)->pgdir))
+		kill_guest(cpu,"bad guest page %p", lg_data(cpu));

	/* In flush_user_mappings() we loop from 0 to
	 * "pgd_index(lg->kernel_address)".  This assumes it won't hit the
	 * Switcher mappings, so check that now. */
-	if(pgd_index(lg->kernel_address) >= SWITCHER_PGD_INDEX)
-		kill_guest(lg,"bad kernel address %#lx", lg->kernel_address);
+	if(pgd_index(cpu->lg->kernel_address) >= SWITCHER_PGD_INDEX)
+		kill_guest(cpu,"bad kernel address %#lx",
+				cpu->lg->kernel_address);
}

/* When a Guest dies, our cleanup is fairly simple. */
diff--git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index635f54c..ec6aa3f 100644
---a/drivers/lguest/segments.c
+++b/drivers/lguest/segments.c
@@-148,14 +148,13 @@ void copy_gdt(const struct lg_cpu *cpu, struct desc_struct *gdt)
 * We copy it from the Guest and tweak the entries. */
void load_guest_gdt(struct lg_cpu *cpu, unsigned long table, u32 num)
{
-	structlguest *lg = cpu->lg;
	/* We assume the Guest has the same number of GDT entries as the
	 * Host, otherwise we'd have to dynamically allocate the Guest GDT. */
	if (num > ARRAY_SIZE(cpu->arch.gdt))
-		kill_guest(lg,"too many gdt entries %i", num);
+		kill_guest(cpu,"too many gdt entries %i", num);

	/* We read the whole thing in, then fix it up. */
-	__lgread(lg,cpu->arch.gdt, table, num * sizeof(cpu->arch.gdt[0]));
+	__lgread(cpu,cpu->arch.gdt, table, num * sizeof(cpu->arch.gdt[0]));
	fixup_gdt_table(cpu, 0, ARRAY_SIZE(cpu->arch.gdt));
	/* Mark that the GDT changed so the core knows it has to copy it again,
	 * even if the Guest is run on the same CPU. */
@@-169,9 +168,8 @@ void load_guest_gdt(struct lg_cpu *cpu, unsigned long table, u32 num)
void guest_load_tls(struct lg_cpu *cpu, unsigned long gtls)
{
	struct desc_struct *tls = &cpu->arch.gdt[GDT_ENTRY_TLS_MIN];
-	structlguest *lg = cpu->lg;

-	__lgread(lg,tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
+	__lgread(cpu,tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
	fixup_gdt_table(cpu, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
	/* Note that just the TLS entries have changed. */
	cpu->changed |= CHANGED_GDT_TLS;
diff--git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
indexdea52d5..8521be4 100644
---a/drivers/lguest/x86/core.c
+++b/drivers/lguest/x86/core.c
@@-94,7 +94,7 @@ static void copy_in_guest_info(struct lg_cpu *cpu, struct lguest_pages *pages)
	/* Set up the two "TSS" members which tell the CPU what stack to use
	 * for traps which do directly into the Guest (ie. traps at privilege
	 * level 1). */
-	pages->state.guest_tss.sp1= cpu->esp1;
+	pages->state.guest_tss.esp1= cpu->esp1;
	pages->state.guest_tss.ss1 = cpu->ss1;

	/* Copy direct-to-Guest trap entries. */
@@-117,7 +117,6 @@ static void run_guest_once(struct lg_cpu *cpu, struct lguest_pages *pages)
{
	/* This is a dummy value we need for GCC's sake. */
	unsigned int clobber;
-	structlguest *lg = cpu->lg;

	/* Copy the guest-specific information into this CPU's "struct
	 * lguest_pages". */
@@-144,7 +143,7 @@ static void run_guest_once(struct lg_cpu *cpu, struct lguest_pages *pages)
		      * 0-th argument above, ie "a").  %ebx contains the
		      * physical address of the Guest's top-level page
		      * directory. */
-		    : "0"(pages), "1"(__pa(lg->pgdirs[cpu->cpu_pgd].pgdir))
+		    : "0"(pages), "1"(__pa(cpu->lg->pgdirs[cpu->cpu_pgd].pgdir))
		     /* We tell gcc that all these registers could change,
		      * which means we don't have to save and restore them in
		      * the Switcher. */
@@-217,7 +216,6 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 * instructions and skip over it.  We return true if we did. */
static int emulate_insn(struct lg_cpu *cpu)
{
-	structlguest *lg = cpu->lg;
	u8 insn;
	unsigned int insnlen = 0, in = 0, shift = 0;
	/* The eip contains the *virtual* address of the Guest's instruction:
@@-231,7 +229,7 @@ static int emulate_insn(struct lg_cpu *cpu)
		return 0;

	/* Decoding x86 instructions is icky. */
-	insn= lgread(lg, physaddr, u8);
+	insn= lgread(cpu, physaddr, u8);

	/* 0x66 is an "operand prefix".  It means it's using the upper 16 bits
	   of the eax register. */
@@-239,7 +237,7 @@ static int emulate_insn(struct lg_cpu *cpu)
		shift = 16;
		/* The instruction is 1 byte so far, read the next byte. */
		insnlen = 1;
-		insn= lgread(lg, physaddr + insnlen, u8);
+		insn= lgread(cpu, physaddr + insnlen, u8);
	}

	/* We can ignore the lower bit for the moment and decode the 4 opcodes
@@-283,7 +281,6 @@ static int emulate_insn(struct lg_cpu *cpu)
/*H:050 Once we've re-enabled interrupts, we look at why the Guest exited. */
void lguest_arch_handle_trap(struct lg_cpu *cpu)
{
-	structlguest *lg = cpu->lg;
	switch (cpu->regs->trapnum) {
	case 13: /* We've intercepted a General Protection Fault. */
		/* Check if this was one of those annoying IN or OUT
@@-315,9 +312,9 @@ void lguest_arch_handle_trap(struct lg_cpu *cpu)
		 * Note that if the Guest were really messed up, this could
		 * happen before it's done the LHCALL_LGUEST_INIT hypercall, so
		 * lg->lguest_data could be NULL */
-		if(lg->lguest_data &&
-		   put_user(cpu->arch.last_pagefault, &lg->lguest_data->cr2))
-			kill_guest(lg,"Writing cr2");
+		if(lg_data(cpu) &&
+		   put_user(cpu->arch.last_pagefault, &lg_data(cpu)->cr2))
+			kill_guest(cpu,"Writing cr2");
		break;
	case 7: /* We've intercepted a Device Not Available fault. */
		/* If the Guest doesn't want to know, we already restored the
@@-345,7 +342,7 @@ void lguest_arch_handle_trap(struct lg_cpu *cpu)
		/* If the Guest doesn't have a handler (either it hasn't
		 * registered any yet, or it's one of the faults we don't let
		 * it handle), it dies with a cryptic error message. */
-		kill_guest(lg,"unhandled trap %li at %#lx (%#lx)",
+		kill_guest(cpu,"unhandled trap %li at %#lx (%#lx)",
			   cpu->regs->trapnum, cpu->regs->eip,
			   cpu->regs->trapnum == 14 ? cpu->arch.last_pagefault
			   : cpu->regs->errcode);
@@-514,11 +511,10 @@ int lguest_arch_do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
int lguest_arch_init_hypercalls(struct lg_cpu *cpu)
{
	u32 tsc_speed;
-	structlguest *lg = cpu->lg;

	/* The pointer to the Guest's "struct lguest_data" is the only
	 * argument.  We check that address now. */
-	if(!lguest_address_ok(lg, cpu->hcall->arg1, sizeof(*lg->lguest_data)))
+	if(!lguest_address_ok(cpu->lg, cpu->hcall->arg1, sizeof(*lg_data(cpu))))
		return -EFAULT;

	/* Having checked it, we simply set lg->lguest_data to point straight
@@-526,7 +522,7 @@ int lguest_arch_init_hypercalls(struct lg_cpu *cpu)
	 * copy_to_user/from_user from now on, instead of lgread/write.  I put
	 * this in to show that I'm not immune to writing stupid
	 * optimizations. */
-	lg->lguest_data= lg->mem_base + cpu->hcall->arg1;
+	lg_data(cpu)= cpu->lg->mem_base + cpu->hcall->arg1;

	/* We insist that the Time Stamp Counter exist and doesn't change with
	 * cpu frequency.  Some devious chip manufacturers decided that TSC
@@-539,12 +535,12 @@ int lguest_arch_init_hypercalls(struct lg_cpu *cpu)
		tsc_speed = tsc_khz;
	else
		tsc_speed = 0;
-	if(put_user(tsc_speed, &lg->lguest_data->tsc_khz))
+	if(put_user(tsc_speed, &lg_data(cpu)->tsc_khz))
		return -EFAULT;

	/* The interrupt code might not like the system call vector. */
-	if(!check_syscall_vector(lg))
-		kill_guest(lg,"bad syscall vector");
+	if(!check_syscall_vector(cpu->lg))
+		kill_guest(cpu,"bad syscall vector");

	return 0;
}
--
1.5.0.6

