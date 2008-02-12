Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbYBLJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbYBLJ2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 04:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYBLJ2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 04:28:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60513 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYBLJ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 04:28:00 -0500
Date: Tue, 12 Feb 2008 11:03:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v9
Message-ID: <20080212100327.GA30873@one.firstfloor.org>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211230335.GA16102@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 12:03:35AM +0100, Ingo Molnar wrote:
> > The synchronization code looks as bad as it was before.

First nobody answered the "kgdb clean enough for a module"
high level question yet. Is it good enough for that?

> 
> i reworked and cleaned up all the kgdb locking code completely. No more 
> NR_CPUS spinlocks, there's now proper use of barriers, etc. No more 
> silly "timeouts" for locking either ... There's now a very well-defined 

A timeout for waiting for other CPUs is actually not a bad idea for a 
debugger. After all you still want to debug even if some other CPUs
are dead.

> and clean locking state-machine for the primary CPU and the secondary 
> CPUs. I re-tested it all on SMP hardware as well.

If it's very clean you should consider sharing it with kdump.

> previously Mark indicated some sort of sprintf return value breakage he 
> observed, and kgdb would rely on sprintf return values so i'm inclined 
> to leave it as-is. We can fix that later, it's not critical.

Pretty much all the proc output and sysfs show functions rely on these return 
values, so if there is a problem it is likely very obscure.

> +	gdb_regs[GDB_BP]	= *(unsigned long *)p->thread.sp;
> +#ifdef CONFIG_X86_32
> +	gdb_regs[GDB_DS]	= __KERNEL_DS;
> +	gdb_regs[GDB_ES]	= __KERNEL_DS;
> +	gdb_regs[GDB_PS]	= 0;
> +	gdb_regs[GDB_CS]	= __KERNEL_CS;
> +	gdb_regs[GDB_PC]	= p->thread.ip;
> +	gdb_regs[GDB_SS]	= __KERNEL_DS;
> +	gdb_regs[GDB_FS]	= 0xFFFF;
> +	gdb_regs[GDB_GS]	= 0xFFFF;
> +#else
> +	gdb_regs[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
> +	gdb_regs[GDB_PC]	= 0;
> +	gdb_regs[GDB_R8]	= 0;
> +	gdb_regs[GDB_R9]	= 0;
> +	gdb_regs[GDB_R10]	= 0;
> +	gdb_regs[GDB_R11]	= 0;
> +	gdb_regs[GDB_R12]	= 0;
> +	gdb_regs[GDB_R13]	= 0;
> +	gdb_regs[GDB_R14]	= 0;
> +	gdb_regs[GDB_R15]	= 0;

The 64bit gdb actually supports segment registers:

static int amd64_linux_gregset64_reg_offset[] =
{
  RAX * 8, RBX * 8,             /* %rax, %rbx */
  RCX * 8, RDX * 8,             /* %rcx, %rdx */
  RSI * 8, RDI * 8,             /* %rsi, %rdi */
  RBP * 8, RSP * 8,             /* %rbp, %rsp */
  R8 * 8, R9 * 8,               /* %r8 ... */
  R10 * 8, R11 * 8,
  R12 * 8, R13 * 8,
  R14 * 8, R15 * 8,             /* ... %r15 */
  RIP * 8, EFLAGS * 8,          /* %rip, %eflags */
  CS * 8, SS * 8,               /* %cs, %ss */
  DS * 8, ES * 8,               /* %ds, %es */
  FS * 8, GS * 8,               /* %fs, %gs */
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1,
  -1, -1, -1, -1, -1, -1, -1, -1, -1,
  ORIG_RAX * 8
};

> + *
> + *	This function will be called if the particular architecture must
> + *	disable hardware debugging while it is processing gdb packets or
> + *	handling exception.
> + */
> +void kgdb_disable_hw_debug(struct pt_regs *regs)
> +{
> +	/* Disable hardware debugging while we are in kgdb: */
> +	set_debugreg(0UL, 7);

You silently overwrite any user ptrace hw breakpoints right? To do it cleanly 
would still require a reservation frame work.

> +/**
> + *	kgdb_arch_handle_exception - Handle architecture specific GDB packets.

All the kerneldoc comments are useless if you don't add the file
to Documentation/DocBook/*.tmpl

> +static int __kgdb_notify(struct die_args *args, unsigned long cmd)
> +{
> +	struct pt_regs *regs = args->regs;
> +
> +	switch (cmd) {
> +	case DIE_NMI:
> +		if (atomic_read(&kgdb_active) != -1) {
> +			/* KGDB CPU roundup */
> +			kgdb_nmicallback(raw_smp_processor_id(), regs);
> +			return NOTIFY_STOP;
> +		}
> +		return NOTIFY_DONE;
> +
> +	case DIE_NMI_IPI:
> +		if (atomic_read(&kgdb_active) != -1) {
> +			/* KGDB CPU roundup: */
> +			if (kgdb_nmicallback(raw_smp_processor_id(), regs))
> +				return NOTIFY_DONE;
> +			return NOTIFY_STOP;
> +		}
> +		return NOTIFY_DONE;
> +
> +	case DIE_NMIWATCHDOG:
> +		if (atomic_read(&kgdb_active) != -1) {

I don't think that case should happen during roundup for once. If it happens 
something is wrong.

In fact both handling DIE_NMI and DIE_NMI_IPI is fishy too.

> +			/* KGDB CPU roundup: */
> +			kgdb_nmicallback(raw_smp_processor_id(), regs);
> +			return NOTIFY_STOP;
> +		}
> +		/* Enter debugger: */
> +		break;
> +
> +	case DIE_DEBUG:
> +		if (atomic_read(&kgdb_cpu_doing_single_step) ==
> +			raw_smp_processor_id() &&
> +			user_mode(regs))
> +			return single_step_cont(regs, args);
> +		/* fall through */
> +	default:
> +		if (user_mode(regs))
> +			return NOTIFY_DONE;

That seems weird. I think other parts try to support user mode debugging
too. In theory there is no reason it shouldn't be able to do this
(except that you have to make sure to not break regular gdb of course) 

> +
> +static struct notifier_block kgdb_notifier = {
> +	.notifier_call	= kgdb_notify,
> +
> +	/*
> +	 * Lowest-prio notifier priority, we want to be notified last:
> +	 */
> +	.priority	= -INT_MAX,

This means kcrash will have priority won't it? Doesn't seem correct.

> +	int			pass_exception;
> +	long			threadid;
> +	long			kgdb_usethreadid;
> +	struct pt_regs		*linux_regs;
> +};
> +
> +static struct debuggerinfo_struct {
> +	void			*debuggerinfo;
> +	struct task_struct	*task;
> +} kgdb_info[NR_CPUS];

> +int __weak kgdb_validate_break_address(unsigned long addr)
> +{
> +	char tmp_variable[BREAK_INSTR_SIZE];
> +
> +	return probe_kernel_read(tmp_variable, (char *)addr, BREAK_INSTR_SIZE);

Ok I have not checked, but I hope you have strong protections against
reentry of the debugger just in case an exception here falls down to
the die notifiers

> +{
> +	return probe_kernel_write((char *)addr,
> +				  (char *)bundle, BREAK_INSTR_SIZE);
> +}
> +
> +unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs)
> +{
> +	return instruction_pointer(regs);

That wrapper should not be needed; everybody can use instruction_pointer()
directly, no?


> +static const char	hexchars[] = "0123456789abcdef";
> +
> +static int hex(char ch)

... Ok i already commented on the hex mess.


> +{
> +	error = -error;
> +	pkt[0] = 'E';
> +	pkt[1] = hexchars[(error / 10)];
> +	pkt[2] = hexchars[(error % 10)];

e.g. you surely don't need sprintf return values for that one.

> +static struct task_struct *getthread(struct pt_regs *regs, int tid)
> +{
> +	if (num_online_cpus() && (tid >= pid_max + num_online_cpus()))
> +		return NULL;

I still don't think this check makes sense.

> +
> +	if (tid >= pid_max)
> +		return idle_task(tid - pid_max);

Hmm, so idle thread numbers depend on a sysctl? That seems weird.
Would be probably better to just give them negative numbers.



> +
> +	if (!tid)
> +		return NULL;
> +
> +	/*
> +	 * find_task_by_pid() does not take the tasklist lock anymore
> +	 * but is nicely RCU locked - hence is a pretty resilient
> +	 * thing to use:
> +	 */
> +	return find_task_by_pid(tid);

You don't think find_task_by_pid() will handle 0 tid?


> +
> +static inline int shadow_pid(int realpid)
> +{
> +	if (realpid)
> +		return realpid;
> +
> +	return pid_max + raw_smp_processor_id();

Whatever that shadowpid is. Seems like a weird concept.

> +	if (strcmp(remcom_in_buffer, "R0") == 0) {
> +		printk(KERN_CRIT "Executing reboot\n");
> +		strcpy(remcom_out_buffer, "OK");
> +		put_packet(remcom_out_buffer);
> +
> +		/*
> +		 * Execution should not return from
> +		 * machine_restart()
> +		 */
> +		machine_restart(NULL);

It's still likely to deadlock on MP I think

[...] Haven't read further.

-Andi

