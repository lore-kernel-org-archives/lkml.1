Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbYBLL3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbYBLL3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762028AbYBLL2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:28:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51249 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760799AbYBLL2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:28:46 -0500
Date: Tue, 12 Feb 2008 12:27:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [git pull] kgdb-light -v10
Message-ID: <20080212112747.GA1569@elte.hu>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212100327.GA30873@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


this is kgdb-light, version -v10 (against Linus-latest), and can be 
pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git

shortlog, diffstat and full patch can be found further below.

in -v10 i have depleted Andi Kleen's (known ;) pool of last-minute 
objections against kgdb. In order of seriosity:

> > +		machine_restart(NULL);
> 
> It's still likely to deadlock on MP I think

correct (just like SysRq-B can hang) - in -v10 i've fixed this by 
changing it to machine_emergency_restart().

> > +static struct task_struct *getthread(struct pt_regs *regs, int tid)
> > +{
> > +	if (num_online_cpus() && (tid >= pid_max + num_online_cpus()))
> > +		return NULL;
> 
> I still don't think this check makes sense.

it's a sensible check, it validates a remote-provided "tid" against the 
range we accept. (It's a bit superfluous as find_task_by_pid() is safe 
enough.)

Anyway, this point is moot because this check is gone in -v10.

> > +
> > +	if (tid >= pid_max)
> > +		return idle_task(tid - pid_max);
> 
> Hmm, so idle thread numbers depend on a sysctl? That seems weird. 
> Would be probably better to just give them negative numbers.

yes, i thought about that too yesterday, but was unsure how the rest of 
the code would code with that. It's no big issue and i have no strong 
feelings either way.

I changed this in -v10 to map idle tasks to negative tids.

> > +	return pid_max + raw_smp_processor_id();
> 
> Whatever that shadowpid is. [...]

GDB wants to track threads, but on the Linux side each idle task has PID 
0, so GDB cannot track them. The shadow PID is this remapped space.

> [...] Seems like a weird concept.

GDB simply needs an ID it can work with - there's nothing weird about 
that.

> > +	/* Disable hardware debugging while we are in kgdb: */
> > +	set_debugreg(0UL, 7);

as Roland explained it, the simplicity and of this code intentional.

Anyway, no strong feelings and it's now fixed in -v10.

> > +/**
> > + *	kgdb_arch_handle_exception - Handle architecture specific GDB packets.
> 
> All the kerneldoc comments are useless if you don't add the file to 
> Documentation/DocBook/*.tmpl

That's wrong: in-source documentation is never useless. If it happens to 
meet DocBook style that's an added bonus. If the DocBook template is 
added later on that's double bonus.

> > +unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs)
> > +{
> > +	return instruction_pointer(regs);
> 
> That wrapper should not be needed; everybody can use 
> instruction_pointer() directly, no?

no, not all architectures have it. This is a weak alias that is 
otherwise not linked into the kernel.

> > +	case DIE_NMIWATCHDOG:
> > +		if (atomic_read(&kgdb_active) != -1) {
> 
> I don't think that case should happen during roundup for once. If it 
> happens something is wrong.

this code is just being a tad over-cautious.

> > +	default:
> > +		if (user_mode(regs))
> > +			return NOTIFY_DONE;
> 
> That seems weird. I think other parts try to support user mode 
> debugging too. In theory there is no reason it shouldn't be able to do 
> this (except that you have to make sure to not break regular gdb of 
> course)

The currently submitted code does not try to support user mode 
debugging. It might be a nice add-on later, if done cleanly and 
correctly enough. If you are interested we welcome patches from you!

> > +	/*
> > +	 * Lowest-prio notifier priority, we want to be notified last:
> > +	 */
> > +	.priority	= -INT_MAX,
> 
> This means kcrash will have priority won't it? Doesn't seem correct.

yes, this means if the user has configured kcrash as well then that will 
have priority over kgdb. This is the intended behavior.

> First nobody answered the "kgdb clean enough for a module" high level 
> question yet. Is it good enough for that?

i disagree that a kernel debugger should necessarily be a kernel module. 
It might be nice at a future stage, but right now it would just 
introduce unnecessary complexity.

> > i reworked and cleaned up all the kgdb locking code completely. No 
> > more NR_CPUS spinlocks, there's now proper use of barriers, etc. No 
> > more silly "timeouts" for locking either ... There's now a very 
> > well-defined
> 
> A timeout for waiting for other CPUs is actually not a bad idea for a 
> debugger. After all you still want to debug even if some other CPUs 
> are dead.

i went for correctness and simplicity first. If a system is hung, the 
debugging CPU might hang too at any time. A timeout on the other hand 
introduces the possibility of a 'dead' CPU just coming back to life 
after the 'timeout', corrupting debugger data. So for now the rule is 
very simple.

timeouts might be an optional "would be nice" feature for later on.

> > previously Mark indicated some sort of sprintf return value breakage 
> > he observed, and kgdb would rely on sprintf return values so i'm 
> > inclined to leave it as-is. We can fix that later, it's not 
> > critical.
> 
> Pretty much all the proc output and sysfs show functions rely on these 
> return values, so if there is a problem it is likely very obscure.

you are wrong, as procfs does not rely on it for a protocol stack. It 
relies on it mostly for user-space "this many bytes were processed" 
return values and those values are often wrong and user-space just 
handles it gratiously.

Anyway, the presence of a few special parsers that impact nothing else 
but kgdb is not even close to being a merge showstopper, it is something 
that can be consolidated later on. We've already got 7 instances of KGDB 
code in the upstream kernel:

  ./sparc/kernel/sparc-stub.c
  ./cris/arch-v32/kernel/kgdb.c
  ./cris/arch-v10/kernel/kgdb.c
  ./mips/kernel/gdb-stub.c
  ./frv/kernel/gdb-stub.c
  ./mn10300/kernel/gdb-stub.c
  ./ppc/kernel/ppc-stub.c

so obviously these parsers work in practice.

	Ingo

------------------>
Ingo Molnar (2):
      uaccess: add probe_kernel_write()
      x86: kgdb support

Jason Wessel (3):
      kgdb: core
      consoles: polling support, kgdboc
      kgdb: document parameters

 Documentation/kernel-parameters.txt |    5 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/kgdb.c              |  417 +++++++++
 drivers/char/tty_io.c               |   47 +
 drivers/serial/8250.c               |   58 ++
 drivers/serial/Kconfig              |    3 +
 drivers/serial/Makefile             |    1 +
 drivers/serial/kgdboc.c             |  163 ++++
 drivers/serial/serial_core.c        |   70 ++-
 include/asm-x86/kgdb.h              |   81 ++
 include/linux/kgdb.h                |  271 ++++++
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   12 +
 include/linux/uaccess.h             |   22 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 1675 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   27 +
 mm/Makefile                         |    2 +-
 mm/maccess.c                        |   49 +
 21 files changed, 2908 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb
 create mode 100644 mm/maccess.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a4fc7fc..6e97307 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -930,6 +930,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
 			in oops dumps.
 
+	kgdboc=		[HW] kgdb over consoles.
+			Requires a tty driver that supports console polling.
+			(only serial suported for now)
+			Format: <serial_device>[,baud]
+
 	l2cr=		[PPC]
 
 	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index aaed1a3..c8dd8f9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -21,6 +21,7 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_ARCH_KGDB
 
 config GENERIC_LOCKBREAK
 	def_bool n
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 76ec0f8..4cd39cd 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
+obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
new file mode 100644
index 0000000..bc762d8
--- /dev/null
+++ b/arch/x86/kernel/kgdb.c
@@ -0,0 +1,417 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+/*
+ * Copyright (C) 2004 Amit S. Kale <amitkale@linsyssoft.com>
+ * Copyright (C) 2000-2001 VERITAS Software Corporation.
+ * Copyright (C) 2002 Andi Kleen, SuSE Labs
+ * Copyright (C) 2004 LinSysSoft Technologies Pvt. Ltd.
+ * Copyright (C) 2007 MontaVista Software, Inc.
+ * Copyright (C) 2007-2008 Jason Wessel, Wind River Systems, Inc.
+ */
+/****************************************************************************
+ *  Contributor:     Lake Stevens Instrument Division$
+ *  Written by:      Glenn Engel $
+ *  Updated by:	     Amit Kale<akale@veritas.com>
+ *  Updated by:	     Tom Rini <trini@kernel.crashing.org>
+ *  Updated by:	     Jason Wessel <jason.wessel@windriver.com>
+ *  Modified for 386 by Jim Kingdon, Cygnus Support.
+ *  Origianl kgdb, compatibility with 2.1.xx kernel by
+ *  David Grothe <dave@gcom.com>
+ *  Integrated into 2.2.5 kernel by Tigran Aivazian <tigran@sco.com>
+ *  X86_64 changes from Andi Kleen's patch merged by Jim Houston
+ */
+#include <linux/spinlock.h>
+#include <linux/kdebug.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/ptrace.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/kgdb.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+
+#include <asm/apicdef.h>
+#include <asm/system.h>
+
+#ifdef CONFIG_X86_32
+# include <mach_ipi.h>
+#else
+# include <asm/mach_apic.h>
+#endif
+
+/*
+ * Put the error code here just in case the user cares:
+ */
+static int gdb_x86errcode;
+
+/*
+ * Likewise, the vector number here (since GDB only gets the signal
+ * number through the usual means, and that's not very specific):
+ */
+static int gdb_x86vector = -1;
+
+/**
+ *	pt_regs_to_gdb_regs - Convert ptrace regs to GDB regs
+ *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
+ *	@regs: The &struct pt_regs of the current process.
+ *
+ *	Convert the pt_regs in @regs into the format for registers that
+ *	GDB expects, stored in @gdb_regs.
+ */
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	gdb_regs[GDB_AX]	= regs->ax;
+	gdb_regs[GDB_BX]	= regs->bx;
+	gdb_regs[GDB_CX]	= regs->cx;
+	gdb_regs[GDB_DX]	= regs->dx;
+	gdb_regs[GDB_SI]	= regs->si;
+	gdb_regs[GDB_DI]	= regs->di;
+	gdb_regs[GDB_BP]	= regs->bp;
+	gdb_regs[GDB_PS]	= regs->flags;
+	gdb_regs[GDB_PC]	= regs->ip;
+#ifdef CONFIG_X86_32
+	gdb_regs[GDB_DS]	= regs->ds;
+	gdb_regs[GDB_ES]	= regs->es;
+	gdb_regs[GDB_CS]	= regs->cs;
+	gdb_regs[GDB_SS]	= __KERNEL_DS;
+	gdb_regs[GDB_FS]	= 0xFFFF;
+	gdb_regs[GDB_GS]	= 0xFFFF;
+#else
+	gdb_regs[GDB_R8]	= regs->r8;
+	gdb_regs[GDB_R9]	= regs->r9;
+	gdb_regs[GDB_R10]	= regs->r10;
+	gdb_regs[GDB_R11]	= regs->r11;
+	gdb_regs[GDB_R12]	= regs->r12;
+	gdb_regs[GDB_R13]	= regs->r13;
+	gdb_regs[GDB_R14]	= regs->r14;
+	gdb_regs[GDB_R15]	= regs->r15;
+#endif
+	gdb_regs[GDB_SP]	= regs->sp;
+}
+
+/**
+ *	sleeping_thread_to_gdb_regs - Convert ptrace regs to GDB regs
+ *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
+ *	@p: The &struct task_struct of the desired process.
+ *
+ *	Convert the register values of the sleeping process in @p to
+ *	the format that GDB expects.
+ *	This function is called when kgdb does not have access to the
+ *	&struct pt_regs and therefore it should fill the gdb registers
+ *	@gdb_regs with what has	been saved in &struct thread_struct
+ *	thread field during switch_to.
+ */
+void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
+{
+	gdb_regs[GDB_AX]	= 0;
+	gdb_regs[GDB_BX]	= 0;
+	gdb_regs[GDB_CX]	= 0;
+	gdb_regs[GDB_DX]	= 0;
+	gdb_regs[GDB_SI]	= 0;
+	gdb_regs[GDB_DI]	= 0;
+	gdb_regs[GDB_BP]	= *(unsigned long *)p->thread.sp;
+#ifdef CONFIG_X86_32
+	gdb_regs[GDB_DS]	= __KERNEL_DS;
+	gdb_regs[GDB_ES]	= __KERNEL_DS;
+	gdb_regs[GDB_PS]	= 0;
+	gdb_regs[GDB_CS]	= __KERNEL_CS;
+	gdb_regs[GDB_PC]	= p->thread.ip;
+	gdb_regs[GDB_SS]	= __KERNEL_DS;
+	gdb_regs[GDB_FS]	= 0xFFFF;
+	gdb_regs[GDB_GS]	= 0xFFFF;
+#else
+	gdb_regs[GDB_PS]	= *(unsigned long *)(p->thread.sp + 8);
+	gdb_regs[GDB_PC]	= 0;
+	gdb_regs[GDB_R8]	= 0;
+	gdb_regs[GDB_R9]	= 0;
+	gdb_regs[GDB_R10]	= 0;
+	gdb_regs[GDB_R11]	= 0;
+	gdb_regs[GDB_R12]	= 0;
+	gdb_regs[GDB_R13]	= 0;
+	gdb_regs[GDB_R14]	= 0;
+	gdb_regs[GDB_R15]	= 0;
+#endif
+	gdb_regs[GDB_SP]	= p->thread.sp;
+}
+
+/**
+ *	gdb_regs_to_pt_regs - Convert GDB regs to ptrace regs.
+ *	@gdb_regs: A pointer to hold the registers we've received from GDB.
+ *	@regs: A pointer to a &struct pt_regs to hold these values in.
+ *
+ *	Convert the GDB regs in @gdb_regs into the pt_regs, and store them
+ *	in @regs.
+ */
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
+{
+	regs->ax		= gdb_regs[GDB_AX];
+	regs->bx		= gdb_regs[GDB_BX];
+	regs->cx		= gdb_regs[GDB_CX];
+	regs->dx		= gdb_regs[GDB_DX];
+	regs->si		= gdb_regs[GDB_SI];
+	regs->di		= gdb_regs[GDB_DI];
+	regs->bp		= gdb_regs[GDB_BP];
+	regs->flags		= gdb_regs[GDB_PS];
+	regs->ip		= gdb_regs[GDB_PC];
+#ifdef CONFIG_X86_32
+	regs->ds		= gdb_regs[GDB_DS];
+	regs->es		= gdb_regs[GDB_ES];
+	regs->cs		= gdb_regs[GDB_CS];
+#else
+	regs->r8		= gdb_regs[GDB_R8];
+	regs->r9		= gdb_regs[GDB_R9];
+	regs->r10		= gdb_regs[GDB_R10];
+	regs->r11		= gdb_regs[GDB_R11];
+	regs->r12		= gdb_regs[GDB_R12];
+	regs->r13		= gdb_regs[GDB_R13];
+	regs->r14		= gdb_regs[GDB_R14];
+	regs->r15		= gdb_regs[GDB_R15];
+#endif
+}
+
+/**
+ *	kgdb_post_primary_code - Save error vector/code numbers.
+ *	@regs: Original pt_regs.
+ *	@e_vector: Original error vector.
+ *	@err_code: Original error code.
+ *
+ *	This is needed on architectures which support SMP and KGDB.
+ *	This function is called after all the slave cpus have been put
+ *	to a know spin state and the primary CPU has control over KGDB.
+ */
+void kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
+{
+	/* primary processor is completely in the debugger */
+	gdb_x86vector = e_vector;
+	gdb_x86errcode = err_code;
+}
+
+#ifdef CONFIG_SMP
+/**
+ *	kgdb_roundup_cpus - Get other CPUs into a holding pattern
+ *	@flags: Current IRQ state
+ *
+ *	On SMP systems, we need to get the attention of the other CPUs
+ *	and get them be in a known state.  This should do what is needed
+ *	to get the other CPUs to call kgdb_wait(). Note that on some arches,
+ *	the NMI approach is not used for rounding up all the CPUs. For example,
+ *	in case of MIPS, smp_call_function() is used to roundup CPUs. In
+ *	this case, we have to make sure that interrupts are enabled before
+ *	calling smp_call_function(). The argument to this function is
+ *	the flags that will be used when restoring the interrupts. There is
+ *	local_irq_save() call before kgdb_roundup_cpus().
+ *
+ *	On non-SMP systems, this is not called.
+ */
+void kgdb_roundup_cpus(unsigned long flags)
+{
+	send_IPI_allbutself(APIC_DM_NMI);
+}
+#endif
+
+/**
+ *	kgdb_arch_handle_exception - Handle architecture specific GDB packets.
+ *	@vector: The error vector of the exception that happened.
+ *	@signo: The signal number of the exception that happened.
+ *	@err_code: The error code of the exception that happened.
+ *	@remcom_in_buffer: The buffer of the packet we have read.
+ *	@remcom_out_buffer: The buffer of %BUFMAX bytes to write a packet into.
+ *	@regs: The &struct pt_regs of the current process.
+ *
+ *	This function MUST handle the 'c' and 's' command packets,
+ *	as well packets to set / remove a hardware breakpoint, if used.
+ *	If there are additional packets which the hardware needs to handle,
+ *	they are handled here.  The code should return -1 if it wants to
+ *	process more packets, and a %0 or %1 if it wants to exit from the
+ *	kgdb callback.
+ */
+int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
+			       char *remcomInBuffer, char *remcomOutBuffer,
+			       struct pt_regs *linux_regs)
+{
+	unsigned long addr;
+	char *ptr;
+	int newPC;
+
+	switch (remcomInBuffer[0]) {
+	case 'c':
+	case 's':
+		/* try to read optional parameter, pc unchanged if no parm */
+		ptr = &remcomInBuffer[1];
+		if (kgdb_hex2long(&ptr, &addr))
+			linux_regs->ip = addr;
+		newPC = linux_regs->ip;
+
+		/* clear the trace bit */
+		linux_regs->flags &= ~TF_MASK;
+		atomic_set(&kgdb_cpu_doing_single_step, -1);
+
+		/* set the trace bit if we're stepping */
+		if (remcomInBuffer[0] == 's') {
+			linux_regs->flags |= TF_MASK;
+			kgdb_single_step = 1;
+			if (kgdb_contthread) {
+				atomic_set(&kgdb_cpu_doing_single_step,
+					   raw_smp_processor_id());
+			}
+		}
+
+		return 0;
+	}
+
+	/* this means that we do not want to exit from the handler: */
+	return -1;
+}
+
+static inline int
+single_step_cont(struct pt_regs *regs, struct die_args *args)
+{
+	/*
+	 * Single step exception from kernel space to user space so
+	 * eat the exception and continue the process:
+	 */
+	printk(KERN_ERR "KGDB: trap/step from kernel to user space, "
+			"resuming...\n");
+	kgdb_arch_handle_exception(args->trapnr, args->signr,
+				   args->err, "c", "", regs);
+
+	return NOTIFY_STOP;
+}
+
+static int __kgdb_notify(struct die_args *args, unsigned long cmd)
+{
+	struct pt_regs *regs = args->regs;
+
+	switch (cmd) {
+	case DIE_NMI:
+		if (atomic_read(&kgdb_active) != -1) {
+			/* KGDB CPU roundup */
+			kgdb_nmicallback(raw_smp_processor_id(), regs);
+			return NOTIFY_STOP;
+		}
+		return NOTIFY_DONE;
+
+	case DIE_NMI_IPI:
+		if (atomic_read(&kgdb_active) != -1) {
+			/* KGDB CPU roundup: */
+			if (kgdb_nmicallback(raw_smp_processor_id(), regs))
+				return NOTIFY_DONE;
+			return NOTIFY_STOP;
+		}
+		return NOTIFY_DONE;
+
+	case DIE_NMIWATCHDOG:
+		if (atomic_read(&kgdb_active) != -1) {
+			/* KGDB CPU roundup: */
+			kgdb_nmicallback(raw_smp_processor_id(), regs);
+			return NOTIFY_STOP;
+		}
+		/* Enter debugger: */
+		break;
+
+	case DIE_DEBUG:
+		if (atomic_read(&kgdb_cpu_doing_single_step) ==
+			raw_smp_processor_id() &&
+			user_mode(regs))
+			return single_step_cont(regs, args);
+		/* fall through */
+	default:
+		if (user_mode(regs))
+			return NOTIFY_DONE;
+	}
+
+	if (kgdb_handle_exception(args->trapnr, args->signr, args->err, regs))
+		return NOTIFY_DONE;
+
+	return NOTIFY_STOP;
+}
+
+static int
+kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
+{
+	unsigned long flags;
+	int ret;
+
+	local_irq_save(flags);
+	ret = __kgdb_notify(ptr, cmd);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static struct notifier_block kgdb_notifier = {
+	.notifier_call	= kgdb_notify,
+
+	/*
+	 * Lowest-prio notifier priority, we want to be notified last:
+	 */
+	.priority	= -INT_MAX,
+};
+
+/**
+ *	kgdb_arch_init - Perform any architecture specific initalization.
+ *
+ *	This function will handle the initalization of any architecture
+ *	specific callbacks.
+ */
+int kgdb_arch_init(void)
+{
+	return register_die_notifier(&kgdb_notifier);
+}
+
+/**
+ *	kgdb_arch_exit - Perform any architecture specific uninitalization.
+ *
+ *	This function will handle the uninitalization of any architecture
+ *	specific callbacks, for dynamic registration and unregistration.
+ */
+void kgdb_arch_exit(void)
+{
+	unregister_die_notifier(&kgdb_notifier);
+}
+
+/**
+ *
+ *	kgdb_skipexception - Bail of of KGDB when we've been triggered.
+ *	@exception: Exception vector number
+ *	@regs: Current &struct pt_regs.
+ *
+ *	On some architectures we need to skip a breakpoint exception when
+ *	it occurs after a breakpoint has been removed.
+ *
+ * Skip an int3 exception when it occurs after a breakpoint has been
+ * removed. Backtrack eip by 1 since the int3 would have caused it to
+ * increment by 1.
+ */
+int kgdb_skipexception(int exception, struct pt_regs *regs)
+{
+	if (exception == 3 && kgdb_isremovedbreak(regs->ip - 1)) {
+		regs->ip -= 1;
+		return 1;
+	}
+	return 0;
+}
+
+unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
+{
+	if (exception == 3)
+		return instruction_pointer(regs) - 1;
+	return instruction_pointer(regs);
+}
+
+struct kgdb_arch arch_kgdb_ops = {
+	/* Breakpoint instruction: */
+	.gdb_bpt_instr		= { 0xcc },
+};
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 613ec81..4d3c701 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1155,6 +1155,48 @@ static struct tty_driver *get_tty_driver(dev_t device, int *index)
 	return NULL;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+
+/**
+ *	tty_find_polling_driver	-	find device of a polled tty
+ *	@name: name string to match
+ *	@line: pointer to resulting tty line nr
+ *
+ *	This routine returns a tty driver structure, given a name
+ *	and the condition that the tty driver is capable of polled
+ *	operation.
+ */
+struct tty_driver *tty_find_polling_driver(char *name, int *line)
+{
+	struct tty_driver *p, *res = NULL;
+	int tty_line = 0;
+	char *str;
+
+	mutex_lock(&tty_mutex);
+	/* Search through the tty devices to look for a match */
+	list_for_each_entry(p, &tty_drivers, tty_drivers) {
+		str = name + strlen(p->name);
+		tty_line = simple_strtoul(str, &str, 10);
+		if (*str == ',')
+			str++;
+		if (*str == '\0')
+			str = 0;
+
+		if (tty_line >= 0 && tty_line <= p->num && p->poll_init &&
+				!p->poll_init(p, tty_line, str)) {
+
+			res = p;
+			*line = tty_line;
+			break;
+		}
+	}
+	mutex_unlock(&tty_mutex);
+
+	return res;
+}
+EXPORT_SYMBOL_GPL(tty_find_polling_driver);
+#endif
+
 /**
  *	tty_check_change	-	check for POSIX terminal changes
  *	@tty: tty to check
@@ -3850,6 +3892,11 @@ void tty_set_operations(struct tty_driver *driver,
 	driver->write_proc = op->write_proc;
 	driver->tiocmget = op->tiocmget;
 	driver->tiocmset = op->tiocmset;
+#ifdef CONFIG_CONSOLE_POLL
+	driver->poll_init = op->poll_init;
+	driver->poll_get_char = op->poll_get_char;
+	driver->poll_put_char = op->poll_put_char;
+#endif
 }
 
 
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 77f7a7f..96a585e 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1740,6 +1740,60 @@ static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
 	}
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+/*
+ * Console polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+static int serial8250_get_poll_char(struct uart_port *port)
+{
+	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	unsigned char lsr = serial_inp(up, UART_LSR);
+
+	while (!(lsr & UART_LSR_DR))
+		lsr = serial_inp(up, UART_LSR);
+
+	return serial_inp(up, UART_RX);
+}
+
+
+static void serial8250_put_poll_char(struct uart_port *port,
+			 unsigned char c)
+{
+	unsigned int ier;
+	struct uart_8250_port *up = (struct uart_8250_port *)port;
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = serial_in(up, UART_IER);
+	if (up->capabilities & UART_CAP_UUE)
+		serial_out(up, UART_IER, UART_IER_UUE);
+	else
+		serial_out(up, UART_IER, 0);
+
+	wait_for_xmitr(up, BOTH_EMPTY);
+	/*
+	 *	Send the character out.
+	 *	If a LF, also do CR...
+	 */
+	serial_out(up, UART_TX, c);
+	if (c == 10) {
+		wait_for_xmitr(up, BOTH_EMPTY);
+		serial_out(up, UART_TX, 13);
+	}
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(up, BOTH_EMPTY);
+	serial_out(up, UART_IER, ier);
+}
+
+#endif /* CONFIG_CONSOLE_POLL */
+
 static int serial8250_startup(struct uart_port *port)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
@@ -2386,6 +2440,10 @@ static struct uart_ops serial8250_pops = {
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = serial8250_get_poll_char,
+	.poll_put_char = serial8250_put_poll_char,
+#endif
 };
 
 static struct uart_8250_port serial8250_ports[UART_NR];
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index b82595c..5d9667c 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -961,6 +961,9 @@ config SERIAL_CORE
 config SERIAL_CORE_CONSOLE
 	bool
 
+config CONSOLE_POLL
+	bool
+
 config SERIAL_68328
 	bool "68328 serial support"
 	depends on M68328 || M68EZ328 || M68VZ328
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 640cfe4..3cbea54 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -66,4 +66,5 @@ obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
+obj-$(CONFIG_KGDB_SERIAL_CONSOLE) += kgdboc.o
 obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
new file mode 100644
index 0000000..3418307
--- /dev/null
+++ b/drivers/serial/kgdboc.c
@@ -0,0 +1,163 @@
+/*
+ * Based on the same principle as kgdboe using the NETPOLL api, this
+ * driver uses a console polling api to implement a gdb serial inteface
+ * which is multiplexed on a console port.
+ *
+ * Maintainer: Jason Wessel <jason.wessel@windriver.com>
+ *
+ * 2007-2008 (c) Jason Wessel - Wind River Systems, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/kgdb.h>
+#include <linux/tty.h>
+
+#define MAX_CONFIG_LEN		40
+
+static struct kgdb_io		kgdboc_io_ops;
+
+/* -1 = init not run yet, 0 = unconfigured, 1 = configured. */
+static int configured		= -1;
+
+static char config[MAX_CONFIG_LEN];
+static struct kparam_string kps = {
+	.string			= config,
+	.maxlen			= MAX_CONFIG_LEN,
+};
+
+static struct tty_driver	*kgdb_tty_driver;
+static int			kgdb_tty_line;
+
+static int kgdboc_option_setup(char *opt)
+{
+	if (strlen(opt) > MAX_CONFIG_LEN) {
+		printk(KERN_ERR "kgdboc: config string too long\n");
+		return -ENOSPC;
+	}
+	strcpy(config, opt);
+
+	return 0;
+}
+
+__setup("kgdboc=", kgdboc_option_setup);
+
+static int configure_kgdboc(void)
+{
+	struct tty_driver *p;
+	int tty_line = 0;
+	int err;
+
+	err = kgdboc_option_setup(config);
+	if (err || !strlen(config) || isspace(config[0]))
+		goto noconfig;
+
+	err = -ENODEV;
+
+	p = tty_find_polling_driver(config, &tty_line);
+	if (!p)
+		goto noconfig;
+
+	kgdb_tty_driver = p;
+	kgdb_tty_line = tty_line;
+
+	err = kgdb_register_io_module(&kgdboc_io_ops);
+	if (err)
+		goto noconfig;
+
+	configured = 1;
+
+	return 0;
+
+noconfig:
+	config[0] = 0;
+	configured = 0;
+
+	return err;
+}
+
+static int __init init_kgdboc(void)
+{
+	/* Already configured? */
+	if (configured == 1)
+		return 0;
+
+	return configure_kgdboc();
+}
+
+static void cleanup_kgdboc(void)
+{
+	if (configured == 1)
+		kgdb_unregister_io_module(&kgdboc_io_ops);
+}
+
+static int kgdboc_get_char(void)
+{
+	return kgdb_tty_driver->poll_get_char(kgdb_tty_driver, kgdb_tty_line);
+}
+
+static void kgdboc_put_char(u8 chr)
+{
+	kgdb_tty_driver->poll_put_char(kgdb_tty_driver, kgdb_tty_line, chr);
+}
+
+static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
+{
+	if (strlen(kmessage) >= MAX_CONFIG_LEN) {
+		printk(KERN_ERR "kgdboc: config string too long\n");
+		return -ENOSPC;
+	}
+
+	/* Only copy in the string if the init function has not run yet */
+	if (configured < 0) {
+		strcpy(config, kmessage);
+		return 0;
+	}
+
+	if (kgdb_connected) {
+		printk(KERN_ERR
+		       "kgdboc: Cannot reconfigure while KGDB is connected.\n");
+
+		return -EBUSY;
+	}
+
+	strcpy(config, kmessage);
+
+	if (configured == 1)
+		cleanup_kgdboc();
+
+	/* Go and configure with the new params. */
+	return configure_kgdboc();
+}
+
+static void kgdboc_pre_exp_handler(void)
+{
+	/* Increment the module count when the debugger is active */
+	if (!kgdb_connected)
+		try_module_get(THIS_MODULE);
+}
+
+static void kgdboc_post_exp_handler(void)
+{
+	/* decrement the module count when the debugger detaches */
+	if (!kgdb_connected)
+		module_put(THIS_MODULE);
+}
+
+static struct kgdb_io kgdboc_io_ops = {
+	.name			= "kgdboc",
+	.read_char		= kgdboc_get_char,
+	.write_char		= kgdboc_put_char,
+	.pre_exception		= kgdboc_pre_exp_handler,
+	.post_exception		= kgdboc_post_exp_handler,
+};
+
+module_init(init_kgdboc);
+module_exit(cleanup_kgdboc);
+module_param_call(kgdboc, param_set_kgdboc_var, param_get_string, &kps, 0644);
+MODULE_PARM_DESC(kgdboc, "<serial_device>[,baud]");
+MODULE_DESCRIPTION("KGDB Console TTY Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 0f5a179..cec193b 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1827,7 +1827,7 @@ uart_get_console(struct uart_port *ports, int nr, struct console *co)
  *	options.  The format of the string is <baud><parity><bits><flow>,
  *	eg: 115200n8r
  */
-void __init
+void
 uart_parse_options(char *options, int *baud, int *parity, int *bits, int *flow)
 {
 	char *s = options;
@@ -1872,7 +1872,7 @@ static const struct baud_rates baud_rates[] = {
  *	@bits: number of data bits
  *	@flow: flow control character - 'r' (rts)
  */
-int __init
+int
 uart_set_options(struct uart_port *port, struct console *co,
 		 int baud, int parity, int bits, int flow)
 {
@@ -1924,7 +1924,12 @@ uart_set_options(struct uart_port *port, struct console *co,
 	port->mctrl |= TIOCM_DTR;
 
 	port->ops->set_termios(port, &termios, &dummy);
-	co->cflag = termios.c_cflag;
+	/*
+	 * Allow the setting of the UART parameters with a NULL console
+	 * too:
+	 */
+	if (co)
+		co->cflag = termios.c_cflag;
 
 	return 0;
 }
@@ -2182,6 +2187,60 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 	}
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+
+static int uart_poll_init(struct tty_driver *driver, int line, char *options)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	if (!state || !state->port)
+		return -1;
+
+	port = state->port;
+	if (!(port->ops->poll_get_char && port->ops->poll_put_char))
+		return -1;
+
+	if (options) {
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+		return uart_set_options(port, NULL, baud, parity, bits, flow);
+	}
+
+	return 0;
+}
+
+static int uart_poll_get_char(struct tty_driver *driver, int line)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+
+	if (!state || !state->port)
+		return -1;
+
+	port = state->port;
+	return port->ops->poll_get_char(port);
+}
+
+static void uart_poll_put_char(struct tty_driver *driver, int line, char ch)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+
+	if (!state || !state->port)
+		return;
+
+	port = state->port;
+	port->ops->poll_put_char(port, ch);
+}
+#endif
+
 static const struct tty_operations uart_ops = {
 	.open		= uart_open,
 	.close		= uart_close,
@@ -2206,6 +2265,11 @@ static const struct tty_operations uart_ops = {
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_init	= uart_poll_init,
+	.poll_get_char	= uart_poll_get_char,
+	.poll_put_char	= uart_poll_put_char,
+#endif
 };
 
 /**
diff --git a/include/asm-x86/kgdb.h b/include/asm-x86/kgdb.h
new file mode 100644
index 0000000..484c475
--- /dev/null
+++ b/include/asm-x86/kgdb.h
@@ -0,0 +1,81 @@
+#ifndef _ASM_KGDB_H_
+#define _ASM_KGDB_H_
+
+/*
+ * Copyright (C) 2001-2004 Amit S. Kale
+ * Copyright (C) 2008 Wind River Systems, Inc.
+ */
+
+/*
+ * BUFMAX defines the maximum number of characters in inbound/outbound
+ * buffers at least NUMREGBYTES*2 are needed for register packets
+ * Longer buffer is needed to list all threads
+ */
+#define BUFMAX			1024
+
+/*
+ *  Note that this register image is in a different order than
+ *  the register image that Linux produces at interrupt time.
+ *
+ *  Linux's register image is defined by struct pt_regs in ptrace.h.
+ *  Just why GDB uses a different order is a historical mystery.
+ */
+#ifdef CONFIG_X86_32
+enum regnames {
+	GDB_AX,			/* 0 */
+	GDB_CX,			/* 1 */
+	GDB_DX,			/* 2 */
+	GDB_BX,			/* 3 */
+	GDB_SP,			/* 4 */
+	GDB_BP,			/* 5 */
+	GDB_SI,			/* 6 */
+	GDB_DI,			/* 7 */
+	GDB_PC,			/* 8 also known as eip */
+	GDB_PS,			/* 9 also known as eflags */
+	GDB_CS,			/* 10 */
+	GDB_SS,			/* 11 */
+	GDB_DS,			/* 12 */
+	GDB_ES,			/* 13 */
+	GDB_FS,			/* 14 */
+	GDB_GS,			/* 15 */
+};
+#else /* ! CONFIG_X86_32 */
+enum regnames {
+	GDB_AX,			/* 0 */
+	GDB_DX,			/* 1 */
+	GDB_CX,			/* 2 */
+	GDB_BX,			/* 3 */
+	GDB_SI,			/* 4 */
+	GDB_DI,			/* 5 */
+	GDB_BP,			/* 6 */
+	GDB_SP,			/* 7 */
+	GDB_R8,			/* 8 */
+	GDB_R9,			/* 9 */
+	GDB_R10,		/* 10 */
+	GDB_R11,		/* 11 */
+	GDB_R12,		/* 12 */
+	GDB_R13,		/* 13 */
+	GDB_R14,		/* 14 */
+	GDB_R15,		/* 15 */
+	GDB_PC,			/* 16 */
+	GDB_PS,			/* 17 */
+};
+#endif /* CONFIG_X86_32 */
+
+/*
+ * Number of bytes of registers:
+ */
+#ifdef CONFIG_X86_32
+# define NUMREGBYTES		64
+#else
+# define NUMREGBYTES		((GDB_PS+1)*8)
+#endif
+
+static inline void arch_kgdb_breakpoint(void)
+{
+	asm("   int $3");
+}
+#define BREAK_INSTR_SIZE	1
+#define CACHE_FLUSH_IS_SAFE	1
+
+#endif				/* _ASM_KGDB_H_ */
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
new file mode 100644
index 0000000..b2be3a8
--- /dev/null
+++ b/include/linux/kgdb.h
@@ -0,0 +1,271 @@
+/*
+ * This provides the callbacks and functions that KGDB needs to share between
+ * the core, I/O and arch-specific portions.
+ *
+ * Author: Amit Kale <amitkale@linsyssoft.com> and
+ *         Tom Rini <trini@kernel.crashing.org>
+ *
+ * 2001-2004 (c) Amit S. Kale and 2003-2005 (c) MontaVista Software, Inc.
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+#ifndef _KGDB_H_
+#define _KGDB_H_
+
+#include <linux/serial_8250.h>
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/atomic.h>
+#include <asm/kgdb.h>
+
+struct pt_regs;
+
+/*
+ *	kgdb_skipexception - Bail of of KGDB when we've been triggered.
+ *	@exception: Exception vector number
+ *	@regs: Current &struct pt_regs.
+ *
+ *	On some architectures we need to skip a breakpoint exception when
+ *	it occurs after a breakpoint has been removed.
+ */
+extern int kgdb_skipexception(int exception, struct pt_regs *regs);
+
+/*
+ *	kgdb_post_primary_code - Save error vector/code numbers.
+ *	@regs: Original pt_regs.
+ *	@e_vector: Original error vector.
+ *	@err_code: Original error code.
+ *
+ *	This is needed on architectures which support SMP and KGDB.
+ *	This function is called after all the secondary cpus have been put
+ *	to a know spin state and the primary CPU has control over KGDB.
+ */
+extern void kgdb_post_primary_code(struct pt_regs *regs, int e_vector,
+				  int err_code);
+
+/*
+ *	kgdb_disable_hw_debug - Disable hardware debugging while we in kgdb.
+ *	@regs: Current &struct pt_regs.
+ *
+ *	This function will be called if the particular architecture must
+ *	disable hardware debugging while it is processing gdb packets or
+ *	handling exception.
+ */
+extern void kgdb_disable_hw_debug(struct pt_regs *regs);
+
+struct tasklet_struct;
+struct task_struct;
+struct uart_port;
+
+/* To enter the debugger explicitly. */
+void kgdb_breakpoint(void);
+
+extern int kgdb_connected;
+
+extern atomic_t			kgdb_setting_breakpoint;
+extern atomic_t			kgdb_cpu_doing_single_step;
+
+extern struct task_struct	*kgdb_usethread;
+extern struct task_struct	*kgdb_contthread;
+
+enum kgdb_bptype {
+	BP_BREAKPOINT = 0,
+	BP_HARDWARE_BREAKPOINT,
+	BP_WRITE_WATCHPOINT,
+	BP_READ_WATCHPOINT,
+	BP_ACCESS_WATCHPOINT
+};
+
+enum kgdb_bpstate {
+	BP_UNDEFINED = 0,
+	BP_REMOVED,
+	BP_SET,
+	BP_ACTIVE
+};
+
+struct kgdb_bkpt {
+	unsigned long		bpt_addr;
+	unsigned char		saved_instr[BREAK_INSTR_SIZE];
+	enum kgdb_bptype	type;
+	enum kgdb_bpstate	state;
+};
+
+#ifndef KGDB_MAX_BREAKPOINTS
+# define KGDB_MAX_BREAKPOINTS	1000
+#endif
+
+#define KGDB_HW_BREAKPOINT	1
+
+/*
+ * Functions each KGDB-supporting architecture must provide:
+ */
+
+/*
+ *	kgdb_arch_init - Perform any architecture specific initalization.
+ *
+ *	This function will handle the initalization of any architecture
+ *	specific callbacks.
+ */
+extern int kgdb_arch_init(void);
+
+/*
+ *	kgdb_arch_exit - Perform any architecture specific uninitalization.
+ *
+ *	This function will handle the uninitalization of any architecture
+ *	specific callbacks, for dynamic registration and unregistration.
+ */
+extern void kgdb_arch_exit(void);
+
+/*
+ *	pt_regs_to_gdb_regs - Convert ptrace regs to GDB regs
+ *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
+ *	@regs: The &struct pt_regs of the current process.
+ *
+ *	Convert the pt_regs in @regs into the format for registers that
+ *	GDB expects, stored in @gdb_regs.
+ */
+extern void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs);
+
+/*
+ *	sleeping_thread_to_gdb_regs - Convert ptrace regs to GDB regs
+ *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
+ *	@p: The &struct task_struct of the desired process.
+ *
+ *	Convert the register values of the sleeping process in @p to
+ *	the format that GDB expects.
+ *	This function is called when kgdb does not have access to the
+ *	&struct pt_regs and therefore it should fill the gdb registers
+ *	@gdb_regs with what has	been saved in &struct thread_struct
+ *	thread field during switch_to.
+ */
+extern void
+sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p);
+
+/*
+ *	gdb_regs_to_pt_regs - Convert GDB regs to ptrace regs.
+ *	@gdb_regs: A pointer to hold the registers we've received from GDB.
+ *	@regs: A pointer to a &struct pt_regs to hold these values in.
+ *
+ *	Convert the GDB regs in @gdb_regs into the pt_regs, and store them
+ *	in @regs.
+ */
+extern void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs);
+
+/*
+ *	kgdb_arch_handle_exception - Handle architecture specific GDB packets.
+ *	@vector: The error vector of the exception that happened.
+ *	@signo: The signal number of the exception that happened.
+ *	@err_code: The error code of the exception that happened.
+ *	@remcom_in_buffer: The buffer of the packet we have read.
+ *	@remcom_out_buffer: The buffer of %BUFMAX bytes to write a packet into.
+ *	@regs: The &struct pt_regs of the current process.
+ *
+ *	This function MUST handle the 'c' and 's' command packets,
+ *	as well packets to set / remove a hardware breakpoint, if used.
+ *	If there are additional packets which the hardware needs to handle,
+ *	they are handled here.  The code should return -1 if it wants to
+ *	process more packets, and a %0 or %1 if it wants to exit from the
+ *	kgdb callback.
+ */
+extern int
+kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			   char *remcom_in_buffer,
+			   char *remcom_out_buffer,
+			   struct pt_regs *regs);
+
+/*
+ *	kgdb_roundup_cpus - Get other CPUs into a holding pattern
+ *	@flags: Current IRQ state
+ *
+ *	On SMP systems, we need to get the attention of the other CPUs
+ *	and get them be in a known state.  This should do what is needed
+ *	to get the other CPUs to call kgdb_wait(). Note that on some arches,
+ *	the NMI approach is not used for rounding up all the CPUs. For example,
+ *	in case of MIPS, smp_call_function() is used to roundup CPUs. In
+ *	this case, we have to make sure that interrupts are enabled before
+ *	calling smp_call_function(). The argument to this function is
+ *	the flags that will be used when restoring the interrupts. There is
+ *	local_irq_save() call before kgdb_roundup_cpus().
+ *
+ *	On non-SMP systems, this is not called.
+ */
+extern void kgdb_roundup_cpus(unsigned long flags);
+
+/* Optional functions. */
+extern int kgdb_validate_break_address(unsigned long addr);
+extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
+extern int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle);
+
+/*
+ * struct kgdb_arch - Describe architecture specific values.
+ * @gdb_bpt_instr: The instruction to trigger a breakpoint.
+ * @flags: Flags for the breakpoint, currently just %KGDB_HW_BREAKPOINT.
+ * @set_breakpoint: Allow an architecture to specify how to set a software
+ * breakpoint.
+ * @remove_breakpoint: Allow an architecture to specify how to remove a
+ * software breakpoint.
+ * @set_hw_breakpoint: Allow an architecture to specify how to set a hardware
+ * breakpoint.
+ * @remove_hw_breakpoint: Allow an architecture to specify how to remove a
+ * hardware breakpoint.
+ * @remove_all_hw_break: Allow an architecture to specify how to remove all
+ * hardware breakpoints.
+ * @correct_hw_break: Allow an architecture to specify how to correct the
+ * hardware debug registers.
+ */
+struct kgdb_arch {
+	unsigned char		gdb_bpt_instr[BREAK_INSTR_SIZE];
+	unsigned long		flags;
+
+	int	(*set_breakpoint)(unsigned long, char *);
+	int	(*remove_breakpoint)(unsigned long, char *);
+	int	(*set_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
+	int	(*remove_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
+	void	(*remove_all_hw_break)(void);
+	void	(*correct_hw_break)(void);
+};
+
+/*
+ * struct kgdb_io - Describe the interface for an I/O driver to talk with KGDB.
+ * @name: Name of the I/O driver.
+ * @read_char: Pointer to a function that will return one char.
+ * @write_char: Pointer to a function that will write one char.
+ * @flush: Pointer to a function that will flush any pending writes.
+ * @init: Pointer to a function that will initialize the device.
+ * @pre_exception: Pointer to a function that will do any prep work for
+ * the I/O driver.
+ * @post_exception: Pointer to a function that will do any cleanup work
+ * for the I/O driver.
+ */
+struct kgdb_io {
+	const char		*name;
+	int			(*read_char) (void);
+	void			(*write_char) (u8);
+	void			(*flush) (void);
+	int			(*init) (void);
+	void			(*pre_exception) (void);
+	void			(*post_exception) (void);
+};
+
+extern struct kgdb_arch		arch_kgdb_ops;
+
+extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
+extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
+
+extern int kgdb_hex2long(char **ptr, long *long_val);
+extern int kgdb_mem2hex(char *mem, char *buf, int count);
+extern int kgdb_hex2mem(char *buf, char *mem, int count);
+
+extern int kgdb_isremovedbreak(unsigned long addr);
+
+extern int
+kgdb_handle_exception(int ex_vector, int signo, int err_code,
+		      struct pt_regs *regs);
+extern int kgdb_nmicallback(int cpu, void *regs);
+
+extern int			kgdb_single_step;
+extern atomic_t			kgdb_active;
+
+#endif /* _KGDB_H_ */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 1a0b6cf..7d1a46b 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -211,6 +211,10 @@ struct uart_ops {
 	void		(*config_port)(struct uart_port *, int);
 	int		(*verify_port)(struct uart_port *, struct serial_struct *);
 	int		(*ioctl)(struct uart_port *, unsigned int, unsigned long);
+#ifdef CONFIG_CONSOLE_POLL
+	void	(*poll_put_char)(struct uart_port *, unsigned char);
+	int		(*poll_get_char)(struct uart_port *);
+#endif
 };
 
 #define UART_CONFIG_TYPE	(1 << 0)
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 85c95cd..21f69ac 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -125,6 +125,7 @@
 #include <linux/cdev.h>
 
 struct tty_struct;
+struct tty_driver;
 
 struct tty_operations {
 	int  (*open)(struct tty_struct * tty, struct file * filp);
@@ -157,6 +158,11 @@ struct tty_operations {
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
+#ifdef CONFIG_CONSOLE_POLL
+	int (*poll_init)(struct tty_driver *driver, int line, char *options);
+	int (*poll_get_char)(struct tty_driver *driver, int line);
+	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
+#endif
 };
 
 struct tty_driver {
@@ -220,6 +226,11 @@ struct tty_driver {
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
+#ifdef CONFIG_CONSOLE_POLL
+	int (*poll_init)(struct tty_driver *driver, int line, char *options);
+	int (*poll_get_char)(struct tty_driver *driver, int line);
+	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
+#endif
 
 	struct list_head tty_drivers;
 };
@@ -230,6 +241,7 @@ struct tty_driver *alloc_tty_driver(int lines);
 void put_tty_driver(struct tty_driver *driver);
 void tty_set_operations(struct tty_driver *driver,
 			const struct tty_operations *op);
+extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
 
 /* tty driver magic number */
 #define TTY_DRIVER_MAGIC		0x5402
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 975c963..fec6dec 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -84,4 +84,26 @@ static inline unsigned long __copy_from_user_nocache(void *to,
 		ret;					\
 	})
 
+/*
+ * probe_kernel_read(): safely attempt to read from a location
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from address @src to the buffer at @dst.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+extern long probe_kernel_read(void *dst, void *src, size_t size);
+
+/*
+ * probe_kernel_write(): safely attempt to write to a location
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+extern long probe_kernel_write(void *dst, void *src, size_t size);
+
 #endif		/* __LINUX_UACCESS_H__ */
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c584c5..05c8003 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
+obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
new file mode 100644
index 0000000..21d30cf
--- /dev/null
+++ b/kernel/kgdb.c
@@ -0,0 +1,1675 @@
+/*
+ * KGDB stub.
+ *
+ * Maintainer: Jason Wessel <jason.wessel@windriver.com>
+ *
+ * Copyright (C) 2000-2001 VERITAS Software Corporation.
+ * Copyright (C) 2002-2004 Timesys Corporation
+ * Copyright (C) 2003-2004 Amit S. Kale <amitkale@linsyssoft.com>
+ * Copyright (C) 2004 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2004-2006 Tom Rini <trini@kernel.crashing.org>
+ * Copyright (C) 2004-2006 LinSysSoft Technologies Pvt. Ltd.
+ * Copyright (C) 2005-2008 Wind River Systems, Inc.
+ * Copyright (C) 2007 MontaVista Software, Inc.
+ * Copyright (C) 2008 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *
+ * Contributors at various stages not listed above:
+ *  Jason Wessel ( jason.wessel@windriver.com )
+ *  George Anzinger <george@mvista.com>
+ *  Anurekh Saxena (anurekh.saxena@timesys.com)
+ *  Lake Stevens Instrument Division (Glenn Engel)
+ *  Jim Kingdon, Cygnus Support.
+ *
+ * Original KGDB stub: David Grothe <dave@gcom.com>,
+ * Tigran Aivazian <tigran@sco.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+#include <linux/pid_namespace.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/console.h>
+#include <linux/threads.h>
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
+#include <linux/reboot.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/sysrq.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/pid.h>
+#include <linux/smp.h>
+#include <linux/mm.h>
+
+#include <asm/cacheflush.h>
+#include <asm/byteorder.h>
+#include <asm/atomic.h>
+#include <asm/system.h>
+
+static int kgdb_break_asap;
+
+struct kgdb_state {
+	int			ex_vector;
+	int			signo;
+	int			err_code;
+	int			cpu;
+	int			pass_exception;
+	long			threadid;
+	long			kgdb_usethreadid;
+	struct pt_regs		*linux_regs;
+};
+
+static struct debuggerinfo_struct {
+	void			*debuggerinfo;
+	struct task_struct	*task;
+} kgdb_info[NR_CPUS];
+
+/**
+ * kgdb_connected - Is a host GDB connected to us?
+ */
+int				kgdb_connected;
+EXPORT_SYMBOL_GPL(kgdb_connected);
+
+/* All the KGDB handlers are installed */
+static int			kgdb_io_module_registered;
+
+/* Guard for recursive entry */
+static int			exception_level;
+
+static struct kgdb_io		*kgdb_io_ops;
+static DEFINE_SPINLOCK(kgdb_registration_lock);
+
+/* kgdb console driver is loaded */
+static int kgdb_con_registered;
+/* determine if kgdb console output should be used */
+static int kgdb_use_con;
+
+static int __init opt_kgdb_con(char *str)
+{
+	kgdb_use_con = 1;
+	return 0;
+}
+
+early_param("kgdbcon", opt_kgdb_con);
+
+module_param(kgdb_use_con, int, 0644);
+
+/*
+ * Holds information about breakpoints in a kernel. These breakpoints are
+ * added and removed by gdb.
+ */
+static struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
+	[0 ... KGDB_MAX_BREAKPOINTS-1] = { .state = BP_UNDEFINED }
+};
+
+/*
+ * The CPU# of the active CPU, or -1 if none:
+ */
+atomic_t			kgdb_active = ATOMIC_INIT(-1);
+
+/*
+ * We use NR_CPUs not PERCPU, in case kgdb is used to debug early
+ * bootup code (which might not have percpu set up yet):
+ */
+static atomic_t			passive_cpu_wait[NR_CPUS];
+static atomic_t			cpu_in_kgdb[NR_CPUS];
+atomic_t			kgdb_setting_breakpoint;
+
+struct task_struct		*kgdb_usethread;
+struct task_struct		*kgdb_contthread;
+
+int				kgdb_single_step;
+
+/* Our I/O buffers. */
+static char			remcom_in_buffer[BUFMAX];
+static char			remcom_out_buffer[BUFMAX];
+
+/* Storage for the registers, in GDB format. */
+static unsigned long		gdb_regs[(NUMREGBYTES +
+					sizeof(unsigned long) - 1) /
+					sizeof(unsigned long)];
+
+/* to keep track of the CPU which is doing the single stepping*/
+atomic_t			kgdb_cpu_doing_single_step = ATOMIC_INIT(-1);
+
+/*
+ * Finally, some KGDB code :-)
+ */
+
+/*
+ * Weak aliases for breakpoint management,
+ * can be overriden by architectures when needed:
+ */
+int __weak kgdb_validate_break_address(unsigned long addr)
+{
+	char tmp_variable[BREAK_INSTR_SIZE];
+
+	return probe_kernel_read(tmp_variable, (char *)addr, BREAK_INSTR_SIZE);
+}
+
+int __weak kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
+{
+	int err;
+
+	err = probe_kernel_read(saved_instr, (char *)addr, BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+
+	return probe_kernel_write((char *)addr, arch_kgdb_ops.gdb_bpt_instr,
+				  BREAK_INSTR_SIZE);
+}
+
+int __weak kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
+{
+	return probe_kernel_write((char *)addr,
+				  (char *)bundle, BREAK_INSTR_SIZE);
+}
+
+unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs)
+{
+	return instruction_pointer(regs);
+}
+
+int __weak kgdb_arch_init(void)
+{
+	return 0;
+}
+
+/**
+ *	kgdb_disable_hw_debug - Disable hardware debugging while we in kgdb.
+ *	@regs: Current &struct pt_regs.
+ *
+ *	This function will be called if the particular architecture must
+ *	disable hardware debugging while it is processing gdb packets or
+ *	handling exception.
+ */
+void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
+{
+}
+
+/*
+ * GDB remote protocol parser:
+ */
+
+static const char	hexchars[] = "0123456789abcdef";
+
+static int hex(char ch)
+{
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/* scan for the sequence $<data>#<checksum> */
+static void get_packet(char *buffer)
+{
+	unsigned char checksum;
+	unsigned char xmitcsum;
+	int count;
+	char ch;
+
+	do {
+		/*
+		 * Spin and wait around for the start character, ignore all
+		 * other characters:
+		 */
+		while ((ch = (kgdb_io_ops->read_char())) != '$')
+			/* nothing */;
+
+		kgdb_connected = 1;
+		checksum = 0;
+		xmitcsum = -1;
+
+		count = 0;
+
+		/*
+		 * now, read until a # or end of buffer is found:
+		 */
+		while (count < (BUFMAX - 1)) {
+			ch = kgdb_io_ops->read_char();
+			if (ch == '#')
+				break;
+			checksum = checksum + ch;
+			buffer[count] = ch;
+			count = count + 1;
+		}
+		buffer[count] = 0;
+
+		if (ch == '#') {
+			xmitcsum = hex(kgdb_io_ops->read_char()) << 4;
+			xmitcsum += hex(kgdb_io_ops->read_char());
+
+			if (checksum != xmitcsum)
+				/* failed checksum */
+				kgdb_io_ops->write_char('-');
+			else
+				/* successful transfer */
+				kgdb_io_ops->write_char('+');
+			if (kgdb_io_ops->flush)
+				kgdb_io_ops->flush();
+		}
+	} while (checksum != xmitcsum);
+}
+
+/*
+ * Send the packet in buffer.
+ * Check for gdb connection if asked for.
+ */
+static void put_packet(char *buffer)
+{
+	unsigned char checksum;
+	int count;
+	char ch;
+
+	/*
+	 * $<packet info>#<checksum>.
+	 */
+	while (1) {
+		kgdb_io_ops->write_char('$');
+		checksum = 0;
+		count = 0;
+
+		while ((ch = buffer[count])) {
+			kgdb_io_ops->write_char(ch);
+			checksum += ch;
+			count++;
+		}
+
+		kgdb_io_ops->write_char('#');
+		kgdb_io_ops->write_char(hexchars[checksum >> 4]);
+		kgdb_io_ops->write_char(hexchars[checksum & 0xf]);
+		if (kgdb_io_ops->flush)
+			kgdb_io_ops->flush();
+
+		/* Now see what we get in reply. */
+		ch = kgdb_io_ops->read_char();
+
+		if (ch == 3)
+			ch = kgdb_io_ops->read_char();
+
+		/* If we get an ACK, we are done. */
+		if (ch == '+')
+			return;
+
+		/*
+		 * If we get the start of another packet, this means
+		 * that GDB is attempting to reconnect.  We will NAK
+		 * the packet being sent, and stop trying to send this
+		 * packet.
+		 */
+		if (ch == '$') {
+			kgdb_io_ops->write_char('-');
+			if (kgdb_io_ops->flush)
+				kgdb_io_ops->flush();
+			return;
+		}
+	}
+}
+
+static char *pack_hex_byte(char *pkt, u8 byte)
+{
+	*pkt++ = hexchars[byte >> 4];
+	*pkt++ = hexchars[byte & 0xf];
+
+	return pkt;
+}
+
+/*
+ * Convert the memory pointed to by mem into hex, placing result in buf.
+ * Return a pointer to the last char put in buf (null). May return an error.
+ */
+int kgdb_mem2hex(char *mem, char *buf, int count)
+{
+	char *tmp;
+	int err;
+
+	/*
+	 * We use the upper half of buf as an intermediate buffer for the
+	 * raw memory copy.  Hex conversion will work against this one.
+	 */
+	tmp = buf + count;
+
+	err = probe_kernel_read(tmp, mem, count);
+	if (!err) {
+		while (count > 0) {
+			buf = pack_hex_byte(buf, *tmp);
+			tmp++;
+			count--;
+		}
+
+		*buf = 0;
+	}
+
+	return err;
+}
+
+/*
+ * Copy the binary array pointed to by buf into mem.  Fix $, #, and
+ * 0x7d escaped with 0x7d.  Return a pointer to the character after
+ * the last byte written.
+ */
+static int kgdb_ebin2mem(char *buf, char *mem, int count)
+{
+	int err = 0;
+	char c;
+
+	while (count-- > 0) {
+		c = *buf++;
+		if (c == 0x7d)
+			c = *buf++ ^ 0x20;
+
+		err = probe_kernel_write(mem, &c, 1);
+		if (err)
+			break;
+
+		mem++;
+	}
+
+	return err;
+}
+
+/*
+ * Convert the hex array pointed to by buf into binary to be placed in mem.
+ * Return a pointer to the character AFTER the last byte written.
+ * May return an error.
+ */
+int kgdb_hex2mem(char *buf, char *mem, int count)
+{
+	char *tmp_raw;
+	char *tmp_hex;
+
+	/*
+	 * We use the upper half of buf as an intermediate buffer for the
+	 * raw memory that is converted from hex.
+	 */
+	tmp_raw = buf + count * 2;
+
+	tmp_hex = tmp_raw - 1;
+	while (tmp_hex >= buf) {
+		tmp_raw--;
+		*tmp_raw = hex(*tmp_hex--);
+		*tmp_raw |= hex(*tmp_hex--) << 4;
+	}
+
+	return probe_kernel_write(mem, tmp_raw, count);
+}
+
+/*
+ * While we find nice hex chars, build a long_val.
+ * Return number of chars processed.
+ */
+int kgdb_hex2long(char **ptr, long *long_val)
+{
+	int hex_val;
+	int num = 0;
+
+	*long_val = 0;
+
+	while (**ptr) {
+		hex_val = hex(**ptr);
+		if (hex_val < 0)
+			break;
+
+		*long_val = (*long_val << 4) | hex_val;
+		num++;
+		(*ptr)++;
+	}
+
+	return num;
+}
+
+/* Write memory due to an 'M' or 'X' packet. */
+static int write_mem_msg(int binary)
+{
+	char *ptr = &remcom_in_buffer[1];
+	unsigned long addr;
+	unsigned long length;
+	int err;
+
+	if (kgdb_hex2long(&ptr, &addr) > 0 && *(ptr++) == ',' &&
+	    kgdb_hex2long(&ptr, &length) > 0 && *(ptr++) == ':') {
+		if (binary)
+			err = kgdb_ebin2mem(ptr, (char *)addr, length);
+		else
+			err = kgdb_hex2mem(ptr, (char *)addr, length);
+		if (err)
+			return err;
+		if (CACHE_FLUSH_IS_SAFE)
+			flush_icache_range(addr, addr + length + 1);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void error_packet(char *pkt, int error)
+{
+	error = -error;
+	pkt[0] = 'E';
+	pkt[1] = hexchars[(error / 10)];
+	pkt[2] = hexchars[(error % 10)];
+	pkt[3] = '\0';
+}
+
+/*
+ * Thread ID accessors. We represent a flat TID space to GDB, where
+ * the per CPU idle threads (which under Linux all have PID 0) are
+ * remapped to negative TIDs.
+ */
+
+#define BUF_THREAD_ID_SIZE	16
+
+static char *pack_threadid(char *pkt, unsigned char *id)
+{
+	char *limit;
+
+	limit = pkt + BUF_THREAD_ID_SIZE;
+	while (pkt < limit)
+		pkt = pack_hex_byte(pkt, *id++);
+
+	return pkt;
+}
+
+static void int_to_threadref(unsigned char *id, int value)
+{
+	unsigned char *scan;
+	int i = 4;
+
+	scan = (unsigned char *)id;
+	while (i--)
+		*scan++ = 0;
+	*scan++ = (value >> 24) & 0xff;
+	*scan++ = (value >> 16) & 0xff;
+	*scan++ = (value >> 8) & 0xff;
+	*scan++ = (value & 0xff);
+}
+
+static struct task_struct *getthread(struct pt_regs *regs, int tid)
+{
+	/*
+	 * Non-positive TIDs are remapped idle tasks:
+	 */
+	if (tid <= 0)
+		return idle_task(-tid);
+
+	/*
+	 * find_task_by_pid() does not take the tasklist lock anymore
+	 * but is nicely RCU locked - hence is a pretty resilient
+	 * thing to use:
+	 */
+	return find_task_by_pid(tid);
+}
+
+/*
+ * CPU debug state control:
+ */
+
+#ifdef CONFIG_SMP
+static void kgdb_wait(struct pt_regs *regs)
+{
+	unsigned long flags;
+	int cpu;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	kgdb_info[cpu].debuggerinfo = regs;
+	kgdb_info[cpu].task = current;
+	/*
+	 * Make sure the above info reaches the primary CPU before
+	 * our cpu_in_kgdb[] flag setting does:
+	 */
+	smp_wmb();
+	atomic_set(&cpu_in_kgdb[cpu], 1);
+
+	/*
+	 * The primary CPU must be active to enter here, but this is
+	 * guard in case the primary CPU had not been selected if
+	 * this was an entry via nmi.
+	 */
+	while (atomic_read(&kgdb_active) == -1)
+		cpu_relax();
+
+	/* Wait till primary CPU goes completely into the debugger. */
+	while (!atomic_read(&cpu_in_kgdb[atomic_read(&kgdb_active)]))
+		cpu_relax();
+
+	/* Wait till primary CPU is done with debugging */
+	while (atomic_read(&passive_cpu_wait[cpu]))
+		cpu_relax();
+
+	kgdb_info[cpu].debuggerinfo = NULL;
+	kgdb_info[cpu].task = NULL;
+
+	/* fix up hardware debug registers on local cpu */
+	if (arch_kgdb_ops.correct_hw_break)
+		arch_kgdb_ops.correct_hw_break();
+
+	/* Signal the primary CPU that we are done: */
+	atomic_set(&cpu_in_kgdb[cpu], 0);
+	local_irq_restore(flags);
+}
+#endif
+
+/*
+ * Some architectures need cache flushes when we set/clear a
+ * breakpoint:
+ */
+static void kgdb_flush_swbreak_addr(unsigned long addr)
+{
+	if (!CACHE_FLUSH_IS_SAFE)
+		return;
+
+	if (current->mm) {
+		flush_cache_range(current->mm->mmap_cache,
+				  addr, addr + BREAK_INSTR_SIZE);
+	} else {
+		flush_icache_range(addr, addr + BREAK_INSTR_SIZE);
+	}
+}
+
+/*
+ * SW breakpoint management:
+ */
+static int kgdb_activate_sw_breakpoints(void)
+{
+	unsigned long addr;
+	int error = 0;
+	int i;
+
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state != BP_SET)
+			continue;
+
+		addr = kgdb_break[i].bpt_addr;
+		error = kgdb_arch_set_breakpoint(addr,
+				kgdb_break[i].saved_instr);
+		if (error)
+			return error;
+
+		kgdb_flush_swbreak_addr(addr);
+		kgdb_break[i].state = BP_ACTIVE;
+	}
+	return 0;
+}
+
+static int kgdb_set_sw_break(unsigned long addr)
+{
+	int err = kgdb_validate_break_address(addr);
+	int breakno = -1;
+	int i;
+
+	if (err)
+		return err;
+
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if ((kgdb_break[i].state == BP_SET) &&
+					(kgdb_break[i].bpt_addr == addr))
+			return -EEXIST;
+	}
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state == BP_REMOVED &&
+					kgdb_break[i].bpt_addr == addr) {
+			breakno = i;
+			break;
+		}
+	}
+
+	if (breakno == -1) {
+		for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+			if (kgdb_break[i].state == BP_UNDEFINED) {
+				breakno = i;
+				break;
+			}
+		}
+	}
+
+	if (breakno == -1)
+		return -E2BIG;
+
+	kgdb_break[breakno].state = BP_SET;
+	kgdb_break[breakno].type = BP_BREAKPOINT;
+	kgdb_break[breakno].bpt_addr = addr;
+
+	return 0;
+}
+
+static int kgdb_deactivate_sw_breakpoints(void)
+{
+	unsigned long addr;
+	int error = 0;
+	int i;
+
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state != BP_ACTIVE)
+			continue;
+		addr = kgdb_break[i].bpt_addr;
+		error = kgdb_arch_remove_breakpoint(addr,
+					kgdb_break[i].saved_instr);
+		if (error)
+			return error;
+
+		kgdb_flush_swbreak_addr(addr);
+		kgdb_break[i].state = BP_SET;
+	}
+	return 0;
+}
+
+static int kgdb_remove_sw_break(unsigned long addr)
+{
+	int i;
+
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if ((kgdb_break[i].state == BP_SET) &&
+				(kgdb_break[i].bpt_addr == addr)) {
+			kgdb_break[i].state = BP_REMOVED;
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+int kgdb_isremovedbreak(unsigned long addr)
+{
+	int i;
+
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if ((kgdb_break[i].state == BP_REMOVED) &&
+					(kgdb_break[i].bpt_addr == addr))
+			return 1;
+	}
+	return 0;
+}
+
+int remove_all_break(void)
+{
+	unsigned long addr;
+	int error;
+	int i;
+
+	/* Clear memory breakpoints. */
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if (kgdb_break[i].state != BP_SET)
+			continue;
+		addr = kgdb_break[i].bpt_addr;
+		error = kgdb_arch_remove_breakpoint(addr,
+				kgdb_break[i].saved_instr);
+		if (error)
+			return error;
+		kgdb_break[i].state = BP_REMOVED;
+	}
+
+	/* Clear hardware breakpoints. */
+	if (arch_kgdb_ops.remove_all_hw_break)
+		arch_kgdb_ops.remove_all_hw_break();
+
+	return 0;
+}
+
+/*
+ * Remap normal tasks to their real PID, idle tasks to -1 ... -NR_CPUs:
+ */
+static inline int shadow_pid(int realpid)
+{
+	if (realpid)
+		return realpid;
+
+	return -1-raw_smp_processor_id();
+}
+
+static char gdbmsgbuf[BUFMAX + 1];
+
+static void kgdb_msg_write(const char *s, int len)
+{
+	char *bufptr;
+	int wcount;
+	int i;
+
+	/* 'O'utput */
+	gdbmsgbuf[0] = 'O';
+
+	/* Fill and send buffers... */
+	while (len > 0) {
+		bufptr = gdbmsgbuf + 1;
+
+		/* Calculate how many this time */
+		if ((len << 1) > (BUFMAX - 2))
+			wcount = (BUFMAX - 2) >> 1;
+		else
+			wcount = len;
+
+		/* Pack in hex chars */
+		for (i = 0; i < wcount; i++)
+			bufptr = pack_hex_byte(bufptr, s[i]);
+		*bufptr = '\0';
+
+		/* Move up */
+		s += wcount;
+		len -= wcount;
+
+		/* Write packet */
+		put_packet(gdbmsgbuf);
+	}
+}
+
+/*
+ * Return true if there is a valid kgdb I/O module.  Also if no
+ * debugger is attached a message can be printed to the console about
+ * waiting for the debugger to attach.
+ *
+ * The print_wait argument is only to be true when called from inside
+ * the core kgdb_handle_exception, because it will wait for the
+ * debugger to attach.
+ */
+static int kgdb_io_ready(int print_wait)
+{
+	if (!kgdb_io_ops)
+		return 0;
+	if (kgdb_connected)
+		return 1;
+	if (atomic_read(&kgdb_setting_breakpoint))
+		return 1;
+	if (print_wait)
+		printk(KERN_CRIT "KGDB: Waiting for remote debugger\n");
+	return 1;
+}
+
+/*
+ * All the functions that start with gdb_cmd are the various
+ * operations to implement the handlers for the gdbserial protocol
+ * where KGDB is communicating with an external debugger
+ */
+
+/* Handle the '?' status packets */
+static void gdb_cmd_status(struct kgdb_state *ks)
+{
+	/*
+	 * We know that this packet is only sent
+	 * during initial connect.  So to be safe,
+	 * we clear out our breakpoints now in case
+	 * GDB is reconnecting.
+	 */
+	remove_all_break();
+
+	remcom_out_buffer[0] = 'S';
+	pack_hex_byte(&remcom_out_buffer[1], ks->signo);
+}
+
+/* Handle the 'g' get registers request */
+static void gdb_cmd_getregs(struct kgdb_state *ks)
+{
+	struct task_struct *thread;
+	void *local_debuggerinfo;
+	int i;
+
+	thread = kgdb_usethread;
+	if (!thread) {
+		thread = kgdb_info[ks->cpu].task;
+		local_debuggerinfo = kgdb_info[ks->cpu].debuggerinfo;
+	} else {
+		local_debuggerinfo = NULL;
+		for (i = 0; i < NR_CPUS; i++) {
+			/*
+			 * Try to find the task on some other
+			 * or possibly this node if we do not
+			 * find the matching task then we try
+			 * to approximate the results.
+			 */
+			if (thread == kgdb_info[i].task)
+				local_debuggerinfo = kgdb_info[i].debuggerinfo;
+		}
+	}
+
+	/*
+	 * All threads that don't have debuggerinfo should be
+	 * in __schedule() sleeping, since all other CPUs
+	 * are in kgdb_wait, and thus have debuggerinfo.
+	 */
+	if (local_debuggerinfo) {
+		pt_regs_to_gdb_regs(gdb_regs, local_debuggerinfo);
+	} else {
+		/*
+		 * Pull stuff saved during switch_to; nothing
+		 * else is accessible (or even particularly
+		 * relevant).
+		 *
+		 * This should be enough for a stack trace.
+		 */
+		sleeping_thread_to_gdb_regs(gdb_regs, thread);
+	}
+	kgdb_mem2hex((char *)gdb_regs, remcom_out_buffer, NUMREGBYTES);
+}
+
+/* Handle the 'G' set registers request */
+static void gdb_cmd_setregs(struct kgdb_state *ks)
+{
+	kgdb_hex2mem(&remcom_in_buffer[1], (char *)gdb_regs, NUMREGBYTES);
+
+	if (kgdb_usethread && kgdb_usethread != current) {
+		error_packet(remcom_out_buffer, -EINVAL);
+	} else {
+		gdb_regs_to_pt_regs(gdb_regs, ks->linux_regs);
+		strcpy(remcom_out_buffer, "OK");
+	}
+}
+
+/* Handle the 'm' memory read bytes */
+static void gdb_cmd_memread(struct kgdb_state *ks)
+{
+	char *ptr = &remcom_in_buffer[1];
+	unsigned long length;
+	unsigned long addr;
+	int err;
+
+	if (kgdb_hex2long(&ptr, &addr) > 0 && *ptr++ == ',' &&
+					kgdb_hex2long(&ptr, &length) > 0) {
+		err = kgdb_mem2hex((char *)addr, remcom_out_buffer, length);
+		if (err)
+			error_packet(remcom_out_buffer, err);
+	} else {
+		error_packet(remcom_out_buffer, -EINVAL);
+	}
+}
+
+/* Handle the 'M' memory write bytes */
+static void gdb_cmd_memwrite(struct kgdb_state *ks)
+{
+	int err = write_mem_msg(0);
+
+	if (err)
+		error_packet(remcom_out_buffer, err);
+	else
+		strcpy(remcom_out_buffer, "OK");
+}
+
+/* Handle the 'X' memory binary write bytes */
+static void gdb_cmd_binwrite(struct kgdb_state *ks)
+{
+	int err = write_mem_msg(1);
+
+	if (err)
+		error_packet(remcom_out_buffer, err);
+	else
+		strcpy(remcom_out_buffer, "OK");
+}
+
+/* Handle the 'D' or 'k', detach or kill packets */
+static void gdb_cmd_detachkill(struct kgdb_state *ks)
+{
+	int error;
+
+	/* The detach case */
+	if (remcom_in_buffer[0] == 'D') {
+		error = remove_all_break();
+		if (error < 0) {
+			error_packet(remcom_out_buffer, error);
+		} else {
+			strcpy(remcom_out_buffer, "OK");
+			kgdb_connected = 0;
+		}
+		put_packet(remcom_out_buffer);
+	} else {
+		/*
+		 * Assume the kill case, with no exit code checking,
+		 * trying to force detach the debugger:
+		 */
+		remove_all_break();
+		kgdb_connected = 0;
+	}
+}
+
+/* Handle the 'R' reboot packets */
+static int gdb_cmd_reboot(struct kgdb_state *ks)
+{
+	/* For now, only honor R0 */
+	if (strcmp(remcom_in_buffer, "R0") == 0) {
+		printk(KERN_CRIT "Executing emergency reboot\n");
+		strcpy(remcom_out_buffer, "OK");
+		put_packet(remcom_out_buffer);
+
+		/*
+		 * Execution should not return from
+		 * machine_emergency_restart()
+		 */
+		machine_emergency_restart();
+		kgdb_connected = 0;
+
+		return 1;
+	}
+	return 0;
+}
+
+/* Handle the 'q' query packets */
+static void gdb_cmd_query(struct kgdb_state *ks)
+{
+	struct task_struct *thread;
+	unsigned char thref[8];
+	char *ptr;
+	int i;
+
+	switch (remcom_in_buffer[1]) {
+	case 's':
+	case 'f':
+		if (memcmp(remcom_in_buffer + 2, "ThreadInfo", 10)) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			break;
+		}
+
+		if (remcom_in_buffer[1] == 'f')
+			ks->threadid = 1;
+
+		remcom_out_buffer[0] = 'm';
+		ptr = remcom_out_buffer + 1;
+
+		for (i = 0; i < 17; ks->threadid++) {
+			thread = getthread(ks->linux_regs, ks->threadid);
+			if (thread) {
+				int_to_threadref(thref, ks->threadid);
+				pack_threadid(ptr, thref);
+				ptr += BUF_THREAD_ID_SIZE;
+				*(ptr++) = ',';
+				i++;
+			}
+		}
+		*(--ptr) = '\0';
+		break;
+
+	case 'C':
+		/* Current thread id */
+		strcpy(remcom_out_buffer, "QC");
+		ks->threadid = shadow_pid(current->pid);
+		int_to_threadref(thref, ks->threadid);
+		pack_threadid(remcom_out_buffer + 2, thref);
+		break;
+	case 'T':
+		if (memcmp(remcom_in_buffer + 1, "ThreadExtraInfo,", 16)) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			break;
+		}
+		ks->threadid = 0;
+		ptr = remcom_in_buffer + 17;
+		kgdb_hex2long(&ptr, &ks->threadid);
+		if (!getthread(ks->linux_regs, ks->threadid)) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			break;
+		}
+		if (ks->threadid > 0) {
+			kgdb_mem2hex(getthread(ks->linux_regs,
+					ks->threadid)->comm,
+					remcom_out_buffer, 16);
+		} else {
+			static char tmpstr[23 + BUF_THREAD_ID_SIZE];
+
+			sprintf(tmpstr, "Shadow task %d for pid 0",
+					(int)(-ks->threadid-1));
+			kgdb_mem2hex(tmpstr, remcom_out_buffer, strlen(tmpstr));
+		}
+		break;
+	}
+}
+
+/* Handle the 'H' task query packets */
+static void gdb_cmd_task(struct kgdb_state *ks)
+{
+	struct task_struct *thread;
+	char *ptr;
+
+	switch (remcom_in_buffer[1]) {
+	case 'g':
+		ptr = &remcom_in_buffer[2];
+		kgdb_hex2long(&ptr, &ks->threadid);
+		thread = getthread(ks->linux_regs, ks->threadid);
+		if (!thread && ks->threadid > 0) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			break;
+		}
+		kgdb_usethread = thread;
+		ks->kgdb_usethreadid = ks->threadid;
+		strcpy(remcom_out_buffer, "OK");
+		break;
+	case 'c':
+		ptr = &remcom_in_buffer[2];
+		kgdb_hex2long(&ptr, &ks->threadid);
+		if (!ks->threadid) {
+			kgdb_contthread = NULL;
+		} else {
+			thread = getthread(ks->linux_regs, ks->threadid);
+			if (!thread && ks->threadid > 0) {
+				error_packet(remcom_out_buffer, -EINVAL);
+				break;
+			}
+			kgdb_contthread = thread;
+		}
+		strcpy(remcom_out_buffer, "OK");
+		break;
+	}
+}
+
+/* Handle the 'T' thread query packets */
+static void gdb_cmd_thread(struct kgdb_state *ks)
+{
+	char *ptr = &remcom_in_buffer[1];
+	struct task_struct *thread;
+
+	kgdb_hex2long(&ptr, &ks->threadid);
+	thread = getthread(ks->linux_regs, ks->threadid);
+	if (thread)
+		strcpy(remcom_out_buffer, "OK");
+	else
+		error_packet(remcom_out_buffer, -EINVAL);
+}
+
+/* Handle the 'z' or 'Z' breakpoint remove or set packets */
+static void gdb_cmd_break(struct kgdb_state *ks)
+{
+	/*
+	 * Since GDB-5.3, it's been drafted that '0' is a software
+	 * breakpoint, '1' is a hardware breakpoint, so let's do that.
+	 */
+	char *bpt_type = &remcom_in_buffer[1];
+	char *ptr = &remcom_in_buffer[2];
+	unsigned long addr;
+	unsigned long length;
+	int error = 0;
+
+	if (arch_kgdb_ops.set_hw_breakpoint && *bpt_type >= '1') {
+		/* Unsupported */
+		if (*bpt_type > '4')
+			return;
+	} else {
+		if (*bpt_type != '0' && *bpt_type != '1')
+			/* Unsupported. */
+			return;
+	}
+
+	/*
+	 * Test if this is a hardware breakpoint, and
+	 * if we support it:
+	 */
+	if (*bpt_type == '1' && !(arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT))
+		/* Unsupported. */
+		return;
+
+	if (*(ptr++) != ',') {
+		error_packet(remcom_out_buffer, -EINVAL);
+		return;
+	}
+	if (!kgdb_hex2long(&ptr, &addr)) {
+		error_packet(remcom_out_buffer, -EINVAL);
+		return;
+	}
+	if (*(ptr++) != ',' ||
+		!kgdb_hex2long(&ptr, &length)) {
+		error_packet(remcom_out_buffer, -EINVAL);
+		return;
+	}
+
+	if (remcom_in_buffer[0] == 'Z' && *bpt_type == '0')
+		error = kgdb_set_sw_break(addr);
+	else if (remcom_in_buffer[0] == 'z' && *bpt_type == '0')
+		error = kgdb_remove_sw_break(addr);
+	else if (remcom_in_buffer[0] == 'Z')
+		error = arch_kgdb_ops.set_hw_breakpoint(addr,
+			(int)length, *bpt_type);
+	else if (remcom_in_buffer[0] == 'z')
+		error = arch_kgdb_ops.remove_hw_breakpoint(addr,
+			(int) length, *bpt_type);
+
+	if (error == 0)
+		strcpy(remcom_out_buffer, "OK");
+	else
+		error_packet(remcom_out_buffer, error);
+}
+
+/* Handle the 'C' signal / exception passing packets */
+static int gdb_cmd_exception_pass(struct kgdb_state *ks)
+{
+	/* C09 == pass exception
+	 * C15 == detach kgdb, pass exception
+	 */
+	if (remcom_in_buffer[1] == '0' && remcom_in_buffer[2] == '9') {
+
+		ks->pass_exception = 1;
+		remcom_in_buffer[0] = 'c';
+
+	} else if (remcom_in_buffer[1] == '1' && remcom_in_buffer[2] == '5') {
+
+		ks->pass_exception = 1;
+		remcom_in_buffer[0] = 'D';
+		remove_all_break();
+		kgdb_connected = 0;
+		return 1;
+
+	} else {
+		error_packet(remcom_out_buffer, -EINVAL);
+		return 0;
+	}
+
+	/* Indicate fall through */
+	return -1;
+}
+
+/*
+ * This function performs all gdbserial command procesing
+ */
+static int gdb_serial_stub(struct kgdb_state *ks)
+{
+	int error = 0;
+	int tmp;
+
+	/* Clear the out buffer. */
+	memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
+
+	if (kgdb_connected) {
+		unsigned char thref[8];
+		char *ptr;
+
+		/* Reply to host that an exception has occurred */
+		ptr = remcom_out_buffer;
+		*ptr++ = 'T';
+		ptr = pack_hex_byte(ptr, ks->signo);
+		ptr += strlen(strcpy(ptr, "thread:"));
+		int_to_threadref(thref, shadow_pid(current->pid));
+		ptr = pack_threadid(ptr, thref);
+		*ptr++ = ';';
+		put_packet(remcom_out_buffer);
+	}
+
+	kgdb_usethread = kgdb_info[ks->cpu].task;
+	ks->kgdb_usethreadid = shadow_pid(kgdb_info[ks->cpu].task->pid);
+	ks->pass_exception = 0;
+
+	while (1) {
+		error = 0;
+
+		/* Clear the out buffer. */
+		memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
+
+		get_packet(remcom_in_buffer);
+
+		switch (remcom_in_buffer[0]) {
+		case '?': /* gdbserial status */
+			gdb_cmd_status(ks);
+			break;
+		case 'g': /* return the value of the CPU registers */
+			gdb_cmd_getregs(ks);
+			break;
+		case 'G': /* set the value of the CPU registers - return OK */
+			gdb_cmd_setregs(ks);
+			break;
+		case 'm': /* mAA..AA,LLLL  Read LLLL bytes at address AA..AA */
+			gdb_cmd_memread(ks);
+			break;
+		case 'M': /* MAA..AA,LLLL: Write LLLL bytes at address AA..AA */
+			gdb_cmd_memwrite(ks);
+			break;
+		case 'X': /* XAA..AA,LLLL: Write LLLL bytes at address AA..AA */
+			gdb_cmd_binwrite(ks);
+			break;
+			/* kill or detach. KGDB should treat this like a
+			 * continue.
+			 */
+		case 'D': /* Debugger detach */
+		case 'k': /* Debugger detach via kill */
+			gdb_cmd_detachkill(ks);
+			goto default_handle;
+		case 'R': /* Reboot */
+			if (gdb_cmd_reboot(ks))
+				goto default_handle;
+			break;
+		case 'q': /* query command */
+			gdb_cmd_query(ks);
+			break;
+		case 'H': /* task related */
+			gdb_cmd_task(ks);
+			break;
+		case 'T': /* Query thread status */
+			gdb_cmd_thread(ks);
+			break;
+		case 'z': /* Break point remove */
+		case 'Z': /* Break point set */
+			gdb_cmd_break(ks);
+			break;
+		case 'C': /* Exception passing */
+			tmp = gdb_cmd_exception_pass(ks);
+			if (tmp > 0)
+				goto default_handle;
+			if (tmp == 0)
+				break;
+			/* Fall through on tmp < 0 */
+		case 'c': /* Continue packet */
+		case 's': /* Single step packet */
+			if (kgdb_contthread && kgdb_contthread != current) {
+				/* Can't switch threads in kgdb */
+				error_packet(remcom_out_buffer, -EINVAL);
+				break;
+			}
+			kgdb_activate_sw_breakpoints();
+			/* Fall through to default processing */
+		default:
+default_handle:
+			error = kgdb_arch_handle_exception(ks->ex_vector,
+						ks->signo,
+						ks->err_code,
+						remcom_in_buffer,
+						remcom_out_buffer,
+						ks->linux_regs);
+			/*
+			 * Leave cmd processing on error, detach,
+			 * kill, continue, or single step.
+			 */
+			if (error >= 0 || remcom_in_buffer[0] == 'D' ||
+			    remcom_in_buffer[0] == 'k') {
+				error = 0;
+				goto kgdb_exit;
+			}
+
+		}
+
+		/* reply to the request */
+		put_packet(remcom_out_buffer);
+	}
+
+kgdb_exit:
+	if (ks->pass_exception)
+		error = 1;
+	return error;
+}
+
+static int kgdb_reenter_check(struct kgdb_state *ks)
+{
+	unsigned long addr;
+
+	if (atomic_read(&kgdb_active) != raw_smp_processor_id())
+		return 0;
+
+	/* Panic on recursive debugger calls: */
+	exception_level++;
+	addr = kgdb_arch_pc(ks->ex_vector, ks->linux_regs);
+	kgdb_deactivate_sw_breakpoints();
+
+	/*
+	 * If the break point removed ok at the place exception
+	 * occurred, try to recover and print a warning to the end
+	 * user because the user planted a breakpoint in a place that
+	 * KGDB needs in order to function.
+	 */
+	if (kgdb_remove_sw_break(addr) == 0) {
+		exception_level = 0;
+		kgdb_skipexception(ks->ex_vector, ks->linux_regs);
+		kgdb_activate_sw_breakpoints();
+		printk(KERN_CRIT "KGDB: re-enter error: breakpoint removed\n");
+		WARN_ON_ONCE(1);
+
+		return 1;
+	}
+	remove_all_break();
+	kgdb_skipexception(ks->ex_vector, ks->linux_regs);
+
+	if (exception_level > 1) {
+		dump_stack();
+		panic("Recursive entry to debugger");
+	}
+
+	printk(KERN_CRIT "KGDB: re-enter exception: ALL breakpoints killed\n");
+	dump_stack();
+	panic("Recursive entry to debugger");
+
+	return 1;
+}
+
+/*
+ * kgdb_handle_exception() - main entry point from a kernel exception
+ *
+ * Locking hierarchy:
+ *	interface locks, if any (begin_session)
+ *	kgdb lock (kgdb_active)
+ */
+int
+kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
+{
+	struct kgdb_state kgdb_var;
+	struct kgdb_state *ks = &kgdb_var;
+	unsigned long flags;
+	int error = 0;
+	int i, cpu;
+
+	ks->cpu			= raw_smp_processor_id();
+	ks->ex_vector		= evector;
+	ks->signo		= signo;
+	ks->ex_vector		= evector;
+	ks->err_code		= ecode;
+	ks->kgdb_usethreadid	= 0;
+	ks->linux_regs		= regs;
+
+	if (kgdb_reenter_check(ks))
+		return 0; /* Ouch, double exception ! */
+
+acquirelock:
+	/*
+	 * Interrupts will be restored by the 'trap return' code, except when
+	 * single stepping.
+	 */
+	local_irq_save(flags);
+
+	cpu = raw_smp_processor_id();
+
+	/*
+	 * Acquire the kgdb_active lock:
+	 */
+	while (atomic_cmpxchg(&kgdb_active, -1, cpu) != -1)
+		cpu_relax();
+
+	/*
+	 * Do not start the debugger connection on this CPU if the last
+	 * instance of the exception handler wanted to come into the
+	 * debugger on a different CPU via a single step
+	 */
+	if (atomic_read(&kgdb_cpu_doing_single_step) != -1 &&
+	    atomic_read(&kgdb_cpu_doing_single_step) != cpu) {
+
+		atomic_set(&kgdb_active, -1);
+		local_irq_restore(flags);
+
+		goto acquirelock;
+	}
+
+	if (!kgdb_io_ready(1)) {
+		error = 1;
+		goto kgdb_restore; /* No I/O connection, so resume the system */
+	}
+
+	/*
+	 * Don't enter if we have hit a removed breakpoint.
+	 */
+	if (kgdb_skipexception(ks->ex_vector, ks->linux_regs))
+		goto kgdb_restore;
+
+	/* Call the I/O driver's pre_exception routine */
+	if (kgdb_io_ops->pre_exception)
+		kgdb_io_ops->pre_exception();
+
+	kgdb_info[ks->cpu].debuggerinfo = ks->linux_regs;
+	kgdb_info[ks->cpu].task = current;
+
+	kgdb_disable_hw_debug(ks->linux_regs);
+
+	/*
+	 * Get the passive CPU lock which will hold all the non-primary
+	 * CPU in a spin state while the debugger is active
+	 */
+	if (!kgdb_single_step || !kgdb_contthread) {
+		for (i = 0; i < NR_CPUS; i++)
+			atomic_set(&passive_cpu_wait[i], 1);
+	}
+
+#ifdef CONFIG_SMP
+	/* Signal the other CPUs to enter kgdb_wait() */
+	if (!kgdb_single_step || !kgdb_contthread)
+		kgdb_roundup_cpus(flags);
+#endif
+
+	/*
+	 * spin_lock code is good enough as a barrier so we don't
+	 * need one here:
+	 */
+	atomic_set(&cpu_in_kgdb[ks->cpu], 1);
+
+	/*
+	 * Wait for the other CPUs to be notified and be waiting for us:
+	 */
+	for_each_online_cpu(i) {
+		while (!atomic_read(&cpu_in_kgdb[i]))
+			cpu_relax();
+	}
+
+	/*
+	 * At this point the primary processor is completely
+	 * in the debugger and all secondary CPUs are quiescent
+	 */
+	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
+	kgdb_deactivate_sw_breakpoints();
+	kgdb_single_step = 0;
+	kgdb_contthread = NULL;
+	exception_level = 0;
+
+	/* Talk to debugger with gdbserial protocol */
+	error = gdb_serial_stub(ks);
+
+	/* Call the I/O driver's post_exception routine */
+	if (kgdb_io_ops->post_exception)
+		kgdb_io_ops->post_exception();
+
+	kgdb_info[ks->cpu].debuggerinfo = NULL;
+	kgdb_info[ks->cpu].task = NULL;
+	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
+
+	if (!kgdb_single_step || !kgdb_contthread) {
+		for (i = NR_CPUS-1; i >= 0; i--)
+			atomic_set(&passive_cpu_wait[i], 0);
+		/*
+		 * Wait till all the CPUs have quit
+		 * from the debugger.
+		 */
+		for_each_online_cpu(i) {
+			while (atomic_read(&cpu_in_kgdb[i]))
+				cpu_relax();
+		}
+	}
+
+kgdb_restore:
+	/* Free kgdb_active */
+	atomic_set(&kgdb_active, -1);
+	local_irq_restore(flags);
+
+	return error;
+}
+
+int kgdb_nmicallback(int cpu, void *regs)
+{
+#ifdef CONFIG_SMP
+	if (!atomic_read(&cpu_in_kgdb[cpu]) &&
+			atomic_read(&kgdb_active) != cpu) {
+		kgdb_wait((struct pt_regs *)regs);
+		return 0;
+	}
+#endif
+	return 1;
+}
+
+void kgdb_console_write(struct console *co, const char *s, unsigned count)
+{
+	unsigned long flags;
+
+	/* If we're debugging, or KGDB has not connected, don't try
+	 * and print. */
+	if (!kgdb_connected || atomic_read(&kgdb_active) != -1)
+		return;
+
+	local_irq_save(flags);
+	kgdb_msg_write(s, count);
+	local_irq_restore(flags);
+}
+
+static struct console kgdbcons = {
+	.name		= "kgdb",
+	.write		= kgdb_console_write,
+	.flags		= CON_PRINTBUFFER | CON_ENABLED,
+	.index		= -1,
+};
+
+#ifdef CONFIG_MAGIC_SYSRQ
+static void sysrq_handle_gdb(int key, struct tty_struct *tty)
+{
+	if (!kgdb_io_ops) {
+		printk(KERN_CRIT "ERROR: No KGDB I/O module available\n");
+		return;
+	}
+	if (!kgdb_connected)
+		printk(KERN_CRIT "Entering KGDB\n");
+
+	kgdb_breakpoint();
+}
+
+static struct sysrq_key_op sysrq_gdb_op = {
+	.handler	= sysrq_handle_gdb,
+	.help_msg	= "Gdb",
+	.action_msg	= "GDB",
+};
+#endif
+
+static void kgdb_register_callbacks(void)
+{
+	if (!kgdb_io_module_registered) {
+		kgdb_io_module_registered = 1;
+		kgdb_arch_init();
+#ifdef CONFIG_MAGIC_SYSRQ
+		register_sysrq_key('g', &sysrq_gdb_op);
+#endif
+		if (kgdb_use_con && !kgdb_con_registered) {
+			register_console(&kgdbcons);
+			kgdb_con_registered = 1;
+		}
+	}
+}
+
+static void kgdb_unregister_callbacks(void)
+{
+	/*
+	 * When this routine is called KGDB should unregister from the
+	 * panic handler and clean up, making sure it is not handling any
+	 * break exceptions at the time.
+	 */
+	if (kgdb_io_module_registered) {
+		kgdb_io_module_registered = 0;
+		kgdb_arch_exit();
+#ifdef CONFIG_MAGIC_SYSRQ
+		unregister_sysrq_key('g', &sysrq_gdb_op);
+#endif
+		if (kgdb_con_registered) {
+			unregister_console(&kgdbcons);
+			kgdb_con_registered = 0;
+		}
+	}
+}
+
+static void kgdb_initial_breakpoint(void)
+{
+	kgdb_break_asap = 0;
+
+	printk(KERN_CRIT "kgdb: Waiting for connection from remote gdb...\n");
+	kgdb_breakpoint();
+}
+
+/**
+ *	kkgdb_register_io_module - register KGDB IO module
+ *	@new_kgdb_io_ops: the io ops vector
+ *
+ *	Register it with the KGDB core.
+ */
+int kgdb_register_io_module(struct kgdb_io *new_kgdb_io_ops)
+{
+	int err;
+
+	spin_lock(&kgdb_registration_lock);
+
+	if (kgdb_io_ops) {
+		spin_unlock(&kgdb_registration_lock);
+
+		printk(KERN_ERR "kgdb: Another I/O driver is already "
+				"registered with KGDB.\n");
+		return -EBUSY;
+	}
+
+	if (new_kgdb_io_ops->init) {
+		err = new_kgdb_io_ops->init();
+		if (err) {
+			spin_unlock(&kgdb_registration_lock);
+			return err;
+		}
+	}
+
+	kgdb_io_ops = new_kgdb_io_ops;
+
+	spin_unlock(&kgdb_registration_lock);
+
+	printk(KERN_INFO "kgdb: Registered I/O driver %s.\n",
+	       new_kgdb_io_ops->name);
+
+	/* Arm KGDB now. */
+	kgdb_register_callbacks();
+
+	if (kgdb_break_asap)
+		kgdb_initial_breakpoint();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kgdb_register_io_module);
+
+/**
+ *	kkgdb_unregister_io_module - unregister KGDB IO module
+ *	@old_kgdb_io_ops: the io ops vector
+ *
+ *	Unregister it with the KGDB core.
+ */
+void kgdb_unregister_io_module(struct kgdb_io *old_kgdb_io_ops)
+{
+	BUG_ON(kgdb_connected);
+
+	/*
+	 * KGDB is no longer able to communicate out, so
+	 * unregister our callbacks and reset state.
+	 */
+	kgdb_unregister_callbacks();
+
+	spin_lock(&kgdb_registration_lock);
+
+	WARN_ON_ONCE(kgdb_io_ops != old_kgdb_io_ops);
+	kgdb_io_ops = NULL;
+
+	spin_unlock(&kgdb_registration_lock);
+
+	printk(KERN_INFO
+		"kgdb: Unregistered I/O driver %s, debugger disabled.\n",
+		old_kgdb_io_ops->name);
+}
+EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
+
+/**
+ * kgdb_breakpoint - generate breakpoint exception
+ *
+ * This function will generate a breakpoint exception.  It is used at the
+ * beginning of a program to sync up with a debugger and can be used
+ * otherwise as a quick means to stop program execution and "break" into
+ * the debugger.
+ */
+void kgdb_breakpoint(void)
+{
+	atomic_set(&kgdb_setting_breakpoint, 1);
+	wmb(); /* Sync point before breakpoint */
+	arch_kgdb_breakpoint();
+	wmb(); /* Sync point after breakpoint */
+	atomic_set(&kgdb_setting_breakpoint, 0);
+}
+EXPORT_SYMBOL_GPL(kgdb_breakpoint);
+
+static int __init opt_kgdb_wait(char *str)
+{
+	kgdb_break_asap = 1;
+
+	if (kgdb_io_module_registered)
+		kgdb_initial_breakpoint();
+
+	return 0;
+}
+
+early_param("kgdbwait", opt_kgdb_wait);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a370fe8..a904916 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -618,3 +618,5 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
 source "samples/Kconfig"
+
+source "lib/Kconfig.kgdb"
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
new file mode 100644
index 0000000..9631ba3
--- /dev/null
+++ b/lib/Kconfig.kgdb
@@ -0,0 +1,27 @@
+
+menuconfig KGDB
+	bool "KGDB: kernel debugging with remote gdb"
+	select FRAME_POINTER
+	depends on HAVE_ARCH_KGDB
+	depends on DEBUG_KERNEL && EXPERIMENTAL
+	help
+	  If you say Y here, it will be possible to remotely debug the
+	  kernel using gdb.  Documentation of kernel debugger is available
+	  at http://kgdb.sourceforge.net as well as in DocBook form
+	  in Documentation/DocBook/.  If unsure, say N.
+
+config HAVE_ARCH_KGDB_SHADOW_INFO
+	bool
+
+config HAVE_ARCH_KGDB
+	bool
+
+config KGDB_SERIAL_CONSOLE
+	tristate "KGDB: use kgdb over the serial console"
+	depends on KGDB
+	select CONSOLE_POLL
+	select MAGIC_SYSRQ
+	default y
+	help
+	  Share a serial console with kgdb. Sysrq-g must be used
+	  to break in initially.
diff --git a/mm/Makefile b/mm/Makefile
index 9f117ba..fb9e7ac 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -8,7 +8,7 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
-			   page_alloc.o page-writeback.o pdflush.o \
+			   maccess.o page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o $(mmu-y)
diff --git a/mm/maccess.c b/mm/maccess.c
new file mode 100644
index 0000000..24f81b9
--- /dev/null
+++ b/mm/maccess.c
@@ -0,0 +1,49 @@
+/*
+ * Access kernel memory without faulting.
+ */
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+
+/**
+ * probe_kernel_read(): safely attempt to read from a location
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from address @src to the buffer at @dst.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+long probe_kernel_read(void *dst, void *src, size_t size)
+{
+	long ret;
+
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(dst,
+			(__force const void __user *)src, size);
+	pagefault_enable();
+
+	return ret ? -EFAULT : 0;
+}
+EXPORT_SYMBOL_GPL(probe_kernel_read);
+
+/**
+ * probe_kernel_write(): safely attempt to write to a location
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+long probe_kernel_write(void *dst, void *src, size_t size)
+{
+	long ret;
+
+	pagefault_disable();
+	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
+	pagefault_enable();
+
+	return ret ? -EFAULT : 0;
+}
+EXPORT_SYMBOL_GPL(probe_kernel_write);
