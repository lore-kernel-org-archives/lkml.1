Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYBJHOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYBJHOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbYBJHOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:14:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387AbYBJHNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:13:55 -0500
Date: Sun, 10 Feb 2008 08:13:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [3/6] kgdb: core
Message-ID: <20080210071331.GC3851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

kgdb core code. Handles the protocol and the arch details.

[ mingo@elte.hu: heavily modified, simplified and cleaned up. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-generic/kgdb.h |   93 ++
 include/linux/kgdb.h       |  264 +++++
 kernel/Makefile            |    1 
 kernel/kgdb.c              | 2020 +++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug          |    2 
 lib/Kconfig.kgdb           |   37 
 6 files changed, 2417 insertions(+)

Index: linux-kgdb.q/include/asm-generic/kgdb.h
===================================================================
--- /dev/null
+++ linux-kgdb.q/include/asm-generic/kgdb.h
@@ -0,0 +1,93 @@
+/*
+ * include/asm-generic/kgdb.h
+ *
+ * This provides the assembly level information so that KGDB can provide
+ * a GDB that has been patched with enough information to know to stop
+ * trying to unwind the function.
+ *
+ * Author: Tom Rini <trini@kernel.crashing.org>
+ *
+ * 2005 (c) MontaVista Software, Inc.
+ * 2006 (c) Embedded Alley Solutions, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef __ASM_GENERIC_KGDB_H__
+#define __ASM_GENERIC_KGDB_H__
+
+struct pt_regs;
+
+/**
+ *	kgdb_skipexception - Bail of of KGDB when we've been triggered.
+ *	@exception: Exception vector number
+ *	@regs: Current &struct pt_regs.
+ *
+ *	On some architectures we need to skip a breakpoint exception when
+ *	it occurs after a breakpoint has been removed.
+ */
+int kgdb_skipexception(int exception, struct pt_regs *regs);
+
+/**
+ *	kgdb_post_master_code - Save error vector/code numbers.
+ *	@regs: Original pt_regs.
+ *	@e_vector: Original error vector.
+ *	@err_code: Original error code.
+ *
+ *	This is needed on architectures which support SMP and KGDB.
+ *	This function is called after all the slave cpus have been put
+ *	to a know spin state and the master CPU has control over KGDB.
+ */
+extern void kgdb_post_master_code(struct pt_regs *regs, int e_vector,
+				  int err_code);
+
+/**
+ *	kgdb_disable_hw_debug - Disable hardware debugging while we in kgdb.
+ *	@regs: Current &struct pt_regs.
+ *
+ *	This function will be called if the particular architecture must
+ *	disable hardware debugging while it is processing gdb packets or
+ *	handling exception.
+ */
+extern void kgdb_disable_hw_debug(struct pt_regs *regs);
+
+#ifdef CONFIG_KGDB_ARCH_HAS_SHADOW_INFO
+/**
+ *	kgdb_shadowinfo - Get shadowed information on @threadid.
+ *	@regs: The &struct pt_regs of the current process.
+ *	@buffer: A buffer of %BUFMAX size.
+ *	@threadid: The thread id of the shadowed process to get information on.
+ */
+extern void kgdb_shadowinfo(struct pt_regs *regs, char *buffer,
+			    unsigned threadid);
+
+/**
+ *	kgdb_get_shadow_thread - Get the shadowed &task_struct of @threadid.
+ *	@regs: The &struct pt_regs of the current thread.
+ *	@threadid: The thread id of the shadowed process to get information on.
+ *
+ *	RETURN:
+ *	This returns a pointer to the &struct task_struct of the shadowed
+ *	thread, @threadid.
+ */
+extern struct task_struct *kgdb_get_shadow_thread(struct pt_regs *regs,
+						  int threadid);
+
+/**
+ *	kgdb_shadow_regs - Return the shadowed registers of @threadid.
+ *	@regs: The &struct pt_regs of the current thread.
+ *	@threadid: The thread id we want the &struct pt_regs for.
+ *
+ *	RETURN:
+ *	The a pointer to the &struct pt_regs of the shadowed thread @threadid.
+ */
+extern struct pt_regs *kgdb_shadow_regs(struct pt_regs *regs, int threadid);
+#else
+#define kgdb_shadowinfo(regs, buf, threadid)		do { } while (0)
+#define kgdb_get_shadow_thread(regs, threadid)		NULL
+#define kgdb_shadow_regs(regs, threadid)		NULL
+#endif
+
+#endif				/* __ASM_GENERIC_KGDB_H__ */
Index: linux-kgdb.q/include/linux/kgdb.h
===================================================================
--- /dev/null
+++ linux-kgdb.q/include/linux/kgdb.h
@@ -0,0 +1,264 @@
+/*
+ * include/linux/kgdb.h
+ *
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
+#include <asm/atomic.h>
+
+#ifdef CONFIG_KGDB
+#include <asm/kgdb.h>
+#include <linux/serial_8250.h>
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+struct tasklet_struct;
+struct pt_regs;
+struct task_struct;
+struct uart_port;
+
+/* To enter the debugger explicitly. */
+void kgdb_breakpoint(void);
+
+extern int kgdb_connected;
+extern int kgdb_may_fault;
+
+extern atomic_t			kgdb_setting_breakpoint;
+extern atomic_t			cpu_doing_single_step;
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
+/* The maximum number of KGDB I/O modules that can be loaded */
+#define KGDB_MAX_IO_HANDLERS	3
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
+/**
+ *	kgdb_arch_init - Perform any architecture specific initalization.
+ *
+ *	This function will handle the initalization of any architecture
+ *	specific callbacks.
+ */
+int kgdb_arch_init(void);
+
+/**
+ *	kgdb_arch_uninit - Perform any architecture specific uninitalization.
+ *
+ *	This function will handle the uninitalization of any architecture
+ *	specific callbacks, for dynamic registration and unregistration.
+ */
+void kgdb_arch_uninit(void);
+
+/**
+ *	pt_regs_to_gdb_regs - Convert ptrace regs to GDB regs
+ *	@gdb_regs: A pointer to hold the registers in the order GDB wants.
+ *	@regs: The &struct pt_regs of the current process.
+ *
+ *	Convert the pt_regs in @regs into the format for registers that
+ *	GDB expects, stored in @gdb_regs.
+ */
+void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs);
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
+void
+sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p);
+
+/**
+ *	gdb_regs_to_pt_regs - Convert GDB regs to ptrace regs.
+ *	@gdb_regs: A pointer to hold the registers we've received from GDB.
+ *	@regs: A pointer to a &struct pt_regs to hold these values in.
+ *
+ *	Convert the GDB regs in @gdb_regs into the pt_regs, and store them
+ *	in @regs.
+ */
+void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs);
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
+int kgdb_arch_handle_exception(int vector, int signo, int err_code,
+			       char *remcom_in_buffer,
+			       char *remcom_out_buffer,
+			       struct pt_regs *regs);
+
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
+void kgdb_roundup_cpus(unsigned long flags);
+
+/* Optional functions. */
+int kgdb_validate_break_address(unsigned long addr);
+int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
+int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle);
+
+/**
+ * struct kgdb_arch - Describe architecture specific values.
+ * @gdb_bpt_instr: The instruction to trigger a breakpoint.
+ * @flags: Flags for the breakpoint, currently just %KGDB_HW_BREAKPOINT.
+ * @shadowth: A value of %1 indicates we shadow information on processes.
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
+ *
+ * The @shadowth flag is an option to shadow information not retrievable by
+ * gdb otherwise.  This is deprecated in favor of a binutils which supports
+ * CFI macros.
+ */
+struct kgdb_arch {
+	unsigned char		gdb_bpt_instr[BREAK_INSTR_SIZE];
+	unsigned long		flags;
+	unsigned		shadowth;
+
+	int	(*set_breakpoint)(unsigned long, char *);
+	int	(*remove_breakpoint)(unsigned long, char *);
+	int	(*set_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
+	int	(*remove_hw_breakpoint)(unsigned long, int, enum kgdb_bptype);
+	void	(*remove_all_hw_break)(void);
+	void	(*correct_hw_break)(void);
+};
+
+/**
+ * struct kgdb_io - Describe the interface for an I/O driver to talk with KGDB.
+ * @name: Name of the I/O driver.
+ * @read_char: Pointer to a function that will return one char.
+ * @write_char: Pointer to a function that will write one char.
+ * @flush: Pointer to a function that will flush any pending writes.
+ * @init: Pointer to a function that will initialize the device.
+ * @late_init: Pointer to a function that will do any setup that has
+ * other dependencies.
+ * @pre_exception: Pointer to a function that will do any prep work for
+ * the I/O driver.
+ * @post_exception: Pointer to a function that will do any cleanup work
+ * for the I/O driver.
+ *
+ * The @init and @late_init function pointers allow for an I/O driver
+ * such as a serial driver to fully initialize the port with @init and
+ * be called very early, yet safely call request_irq() later in the boot
+ * sequence.
+ *
+ * @init is allowed to return a non-0 return value to indicate failure.
+ * If this is called early on, then KGDB will try again when it would call
+ * @late_init.  If it has failed later in boot as well, the user will be
+ * notified.
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
+int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
+void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
+
+int kgdb_hex2long(char **ptr, long *long_val);
+char *kgdb_mem2hex(char *mem, char *buf, int count);
+char *kgdb_hex2mem(char *buf, char *mem, int count);
+
+int kgdb_isremovedbreak(unsigned long addr);
+
+int kgdb_handle_exception(int ex_vector, int signo, int err_code,
+			  struct pt_regs *regs);
+int kgdb_nmicallback(int cpu, void *regs);
+
+extern int			debugger_step;
+extern atomic_t			debugger_active;
+
+#else /* !CONFIG_KGDB */
+static const atomic_t	debugger_active = ATOMIC_INIT(0);
+#endif /* !CONFIG_KGDB */
+
+#endif /* _KGDB_H_ */
Index: linux-kgdb.q/kernel/Makefile
===================================================================
--- linux-kgdb.q.orig/kernel/Makefile
+++ linux-kgdb.q/kernel/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilt
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
+obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
Index: linux-kgdb.q/kernel/kgdb.c
===================================================================
--- /dev/null
+++ linux-kgdb.q/kernel/kgdb.c
@@ -0,0 +1,2020 @@
+/*
+ * kernel/kgdb.c
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
+#include <linux/notifier.h>
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
+	int			all_cpus_synced;
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
+struct debuggerinfo_struct {
+	void			*debuggerinfo;
+	struct task_struct	*task;
+} kgdb_info[NR_CPUS];
+
+/*
+ * Could we be about to try and access a bad memory location?
+ * If so we also need to flag this has happened.
+ */
+int				kgdb_may_fault;
+
+/* Is a host GDB connected to us? */
+int				kgdb_connected;
+EXPORT_SYMBOL_GPL(kgdb_connected);
+
+/* All the KGDB handlers are installed */
+int				kgdb_io_module_registered;
+
+/* Guard for recursive entry */
+static int			exception_level;
+
+static struct kgdb_io		*kgdb_io_ops;
+static DEFINE_SPINLOCK(kgdb_registration_lock);
+
+/*
+ * Holds information about breakpoints in a kernel. These breakpoints are
+ * added and removed by gdb.
+ */
+struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
+	[0 ... KGDB_MAX_BREAKPOINTS-1] = { .state = BP_UNDEFINED }
+};
+
+/*
+ * KGDB locking is really nasty at places - but we really can only
+ * do sane debugging if all processors are in a controlled state.
+ *
+ * So we go through painful cycles of wait and see, with every
+ * CPU having a lock:
+ */
+
+/* How many times to count all of the waiting CPUs */
+#define ROUNDUP_WAIT		640000	/* Arbitrary, increase if needed. */
+#define BUF_THREAD_ID_SIZE	16
+
+static spinlock_t		slave_cpu_locks[NR_CPUS] = {
+	[0 ... NR_CPUS-1] = __SPIN_LOCK_UNLOCKED(slave_cpu_locks)
+};
+static atomic_t			cpu_in_kgdb[NR_CPUS];
+atomic_t			kgdb_setting_breakpoint;
+
+struct task_struct		*kgdb_usethread;
+struct task_struct		*kgdb_contthread;
+
+int				debugger_step;
+static atomic_t			kgdb_sync = ATOMIC_INIT(-1);
+atomic_t			debugger_active;
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
+atomic_t			cpu_doing_single_step = ATOMIC_INIT(-1);
+
+static int
+kgdb_notify_reboot(struct notifier_block *this, unsigned long code, void *x);
+
+/* reboot notifier block */
+static struct notifier_block kgdb_reboot_notifier = {
+	.notifier_call		= kgdb_notify_reboot,
+	.next			= NULL,
+	.priority		= INT_MAX,
+};
+
+/*
+ * Finally, some KGDB code :-)
+ */
+
+static char *kgdb_get_mem(char *addr, unsigned char *buf, int count)
+{
+	while (count) {
+		if ((unsigned long)addr < TASK_SIZE) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+		if (probe_kernel_address(addr, *buf)) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+		buf++;
+		addr++;
+		count--;
+	}
+	kgdb_may_fault = 0;
+
+	return NULL;
+}
+
+static char *kgdb_set_mem(char *addr, unsigned char *buf, int count)
+{
+	while (count) {
+		if ((unsigned long)addr < TASK_SIZE) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+		if (probe_kernel_write(addr, *buf)) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+		buf++;
+		addr++;
+		count--;
+	}
+	kgdb_may_fault = 0;
+
+	return NULL;
+}
+
+
+/*
+ * Weak aliases for breakpoint management,
+ * can be overriden by architectures when needed:
+ */
+int __weak kgdb_validate_break_address(unsigned long addr)
+{
+	char tmp_variable[BREAK_INSTR_SIZE];
+
+	if (!kgdb_get_mem((char *)addr, tmp_variable, BREAK_INSTR_SIZE))
+		return 0;
+	return -1;
+}
+
+int __weak kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
+{
+	if (kgdb_get_mem((char *)addr, saved_instr, BREAK_INSTR_SIZE))
+		return -1;
+
+	if (kgdb_set_mem((char *)addr, arch_kgdb_ops.gdb_bpt_instr,
+						BREAK_INSTR_SIZE))
+		return -1;
+	return 0;
+}
+
+int __weak kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
+{
+	if (kgdb_set_mem((char *)addr, (char *)bundle, BREAK_INSTR_SIZE))
+		return -1;
+	return 0;
+}
+
+unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs)
+{
+	return instruction_pointer(regs);
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
+		kgdb_io_ops->write_char(hexchars[checksum % 16]);
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
+/*
+ * Fault-tolerant memory accessor wrappers. Performance is a secondary
+ * concern, the primary concern is not to crash the debugger (or the
+ * debuggee):
+ */
+
+/*
+ * Convert the memory pointed to by mem into hex, placing result in buf.
+ * Return a pointer to the last char put in buf (null). May return an error.
+ */
+char *kgdb_mem2hex(char *mem, char *buf, int count)
+{
+	/*
+	 * Accessing some registers in a single load instruction is
+	 * required to avoid bad side effects for some I/O registers.
+	 */
+	if ((count == 2) && (((long)mem & 1) == 0)) {
+		u16 tmp_s;
+
+		if (probe_kernel_address(mem, tmp_s)) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+
+		mem += 2;
+#ifdef __BIG_ENDIAN
+		*buf++ = hexchars[(tmp_s >> 12) & 0xf];
+		*buf++ = hexchars[(tmp_s >> 8) & 0xf];
+		*buf++ = hexchars[(tmp_s >> 4) & 0xf];
+		*buf++ = hexchars[tmp_s & 0xf];
+#else
+		*buf++ = hexchars[(tmp_s >> 4) & 0xf];
+		*buf++ = hexchars[tmp_s & 0xf];
+		*buf++ = hexchars[(tmp_s >> 12) & 0xf];
+		*buf++ = hexchars[(tmp_s >> 8) & 0xf];
+#endif
+	} else if ((count == 4) && (((long)mem & 3) == 0)) {
+		u32 tmp_l;
+		if (probe_kernel_address(mem, tmp_l)) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+
+		mem += 4;
+#ifdef __BIG_ENDIAN
+		*buf++ = hexchars[(tmp_l >> 28) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 24) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 20) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 16) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 12) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 8) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 4) & 0xf];
+		*buf++ = hexchars[tmp_l & 0xf];
+#else
+		*buf++ = hexchars[(tmp_l >> 4) & 0xf];
+		*buf++ = hexchars[tmp_l & 0xf];
+		*buf++ = hexchars[(tmp_l >> 12) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 8) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 20) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 16) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 28) & 0xf];
+		*buf++ = hexchars[(tmp_l >> 24) & 0xf];
+#endif
+#ifdef CONFIG_64BIT
+	} else if ((count == 8) && (((long)mem & 7) == 0)) {
+		u64 tmp_ll;
+		if (probe_kernel_address(mem, tmp_ll)) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+
+		mem += 8;
+#ifdef __BIG_ENDIAN
+		*buf++ = hexchars[(tmp_ll >> 60) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 56) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 52) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 48) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 44) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 40) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 36) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 32) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 28) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 24) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 20) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 16) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 12) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 8) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 4) & 0xf];
+		*buf++ = hexchars[tmp_ll & 0xf];
+#else
+		*buf++ = hexchars[(tmp_ll >> 4) & 0xf];
+		*buf++ = hexchars[tmp_ll & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 12) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 8) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 20) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 16) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 28) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 24) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 36) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 32) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 44) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 40) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 52) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 48) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 60) & 0xf];
+		*buf++ = hexchars[(tmp_ll >> 56) & 0xf];
+#endif
+#endif
+	} else {
+		while (count-- > 0) {
+			unsigned char ch;
+
+			if (probe_kernel_address(mem, ch)) {
+				kgdb_may_fault = 0;
+				return ERR_PTR(-EINVAL);
+			}
+			mem++;
+			*buf++ = hexchars[ch >> 4];
+			*buf++ = hexchars[ch & 0xf];
+		}
+	}
+
+	kgdb_may_fault = 0;
+	*buf = 0;
+
+	return buf;
+}
+
+/*
+ * Copy the binary array pointed to by buf into mem.  Fix $, #, and
+ * 0x7d escaped with 0x7d.  Return a pointer to the character after
+ * the last byte written.
+ */
+static char *kgdb_ebin2mem(char *buf, char *mem, int count)
+{
+	for (; count > 0; count--, buf++) {
+		if (*buf == 0x7d) {
+			if (probe_kernel_write(mem, (char)(*buf ^ 0x20))) {
+				kgdb_may_fault = 0;
+				return ERR_PTR(-EINVAL);
+			}
+			buf++;
+		} else {
+			if (probe_kernel_write(mem, *buf)) {
+				kgdb_may_fault = 0;
+				return ERR_PTR(-EINVAL);
+			}
+		}
+		mem++;
+	}
+	kgdb_may_fault = 0;
+
+	return mem;
+}
+
+/*
+ * Convert the hex array pointed to by buf into binary to be placed in mem.
+ * Return a pointer to the character AFTER the last byte written.
+ * May return an error.
+ */
+char *kgdb_hex2mem(char *buf, char *mem, int count)
+{
+	if ((count == 2) && (((long)mem & 1) == 0)) {
+		u16 tmp_s = 0;
+
+#ifdef __BIG_ENDIAN
+		tmp_s |= hex(*buf++) << 12;
+		tmp_s |= hex(*buf++) << 8;
+		tmp_s |= hex(*buf++) << 4;
+		tmp_s |= hex(*buf++);
+#else
+		tmp_s |= hex(*buf++) << 4;
+		tmp_s |= hex(*buf++);
+		tmp_s |= hex(*buf++) << 12;
+		tmp_s |= hex(*buf++) << 8;
+#endif
+		if (probe_kernel_write(mem, tmp_s)) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+		mem += 2;
+	} else if ((count == 4) && (((long)mem & 3) == 0)) {
+		u32 tmp_l = 0;
+
+#ifdef __BIG_ENDIAN
+		tmp_l |= hex(*buf++) << 28;
+		tmp_l |= hex(*buf++) << 24;
+		tmp_l |= hex(*buf++) << 20;
+		tmp_l |= hex(*buf++) << 16;
+		tmp_l |= hex(*buf++) << 12;
+		tmp_l |= hex(*buf++) << 8;
+		tmp_l |= hex(*buf++) << 4;
+		tmp_l |= hex(*buf++);
+#else
+		tmp_l |= hex(*buf++) << 4;
+		tmp_l |= hex(*buf++);
+		tmp_l |= hex(*buf++) << 12;
+		tmp_l |= hex(*buf++) << 8;
+		tmp_l |= hex(*buf++) << 20;
+		tmp_l |= hex(*buf++) << 16;
+		tmp_l |= hex(*buf++) << 28;
+		tmp_l |= hex(*buf++) << 24;
+#endif
+		if (probe_kernel_write(mem, tmp_l)) {
+			kgdb_may_fault = 0;
+			return ERR_PTR(-EINVAL);
+		}
+		mem += 4;
+	} else {
+		int i;
+
+		for (i = 0; i < count; i++) {
+			unsigned char ch = hex(*buf++) << 4;
+
+			ch |= hex(*buf++);
+			if (probe_kernel_write(mem, ch)) {
+				kgdb_may_fault = 0;
+				return ERR_PTR(-EINVAL);
+			}
+			mem++;
+		}
+	}
+	kgdb_may_fault = 0;
+
+	return mem;
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
+		if (hex_val >= 0) {
+			*long_val = (*long_val << 4) | hex_val;
+			num++;
+		} else
+			break;
+
+		(*ptr)++;
+	}
+
+	return num;
+}
+
+/* Write memory due to an 'M' or 'X' packet. */
+static char *write_mem_msg(int binary)
+{
+	char *ptr = &remcom_in_buffer[1];
+	unsigned long addr;
+	unsigned long length;
+
+	if (kgdb_hex2long(&ptr, &addr) > 0 && *(ptr++) == ',' &&
+	    kgdb_hex2long(&ptr, &length) > 0 && *(ptr++) == ':') {
+		if (binary)
+			ptr = kgdb_ebin2mem(ptr, (char *)addr, length);
+		else
+			ptr = kgdb_hex2mem(ptr, (char *)addr, length);
+		if (IS_ERR(ptr))
+			return ptr;
+		if (CACHE_FLUSH_IS_SAFE)
+			flush_icache_range(addr, addr + length + 1);
+		return NULL;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+static inline char *pack_hex_byte(char *pkt, int byte)
+{
+	*pkt++ = hexchars[(byte >> 4) & 0xf];
+	*pkt++ = hexchars[(byte & 0xf)];
+
+	return pkt;
+}
+
+static inline void error_packet(char *pkt, int error)
+{
+	error = -error;
+	pkt[0] = 'E';
+	pkt[1] = hexchars[(error / 10)];
+	pkt[2] = hexchars[(error % 10)];
+	pkt[3] = '\0';
+}
+
+/*
+ * Black magic portion #2. Thread ID accessors.
+ */
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
+	if (init_pid_ns.last_pid == 0)
+		return current;
+
+	if (num_online_cpus() && (tid >= pid_max + num_online_cpus() +
+							arch_kgdb_ops.shadowth))
+		return NULL;
+
+	if (arch_kgdb_ops.shadowth && (tid >= pid_max + num_online_cpus())) {
+		return kgdb_get_shadow_thread(regs, tid - pid_max -
+					      num_online_cpus());
+	}
+
+	if (tid >= pid_max)
+		return idle_task(tid - pid_max);
+
+	if (!tid)
+		return NULL;
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
+	atomic_set(&cpu_in_kgdb[cpu], 1);
+
+	/*
+	 * The master CPU must be active to enter here, but this is
+	 * gaurd in case the master CPU had not been selected if
+	 * this was an entry via nmi.
+	 */
+	while (!atomic_read(&debugger_active))
+		cpu_relax();
+
+	/* Wait till master CPU goes completely into the debugger. */
+	while (!atomic_read(&cpu_in_kgdb[atomic_read(&debugger_active) - 1])) {
+		int i = 10;	/* an arbitrary number. Be nice. A bit. */
+
+		while (--i)
+			cpu_relax();
+	}
+
+	/* Wait till master CPU is done with debugging */
+	spin_lock(&slave_cpu_locks[cpu]);
+
+	kgdb_info[cpu].debuggerinfo = NULL;
+	kgdb_info[cpu].task = NULL;
+
+	/* fix up hardware debug registers on local cpu */
+	if (arch_kgdb_ops.correct_hw_break)
+		arch_kgdb_ops.correct_hw_break();
+
+	/* Signal the master CPU that we are done: */
+	atomic_set(&cpu_in_kgdb[cpu], 0);
+	spin_unlock(&slave_cpu_locks[cpu]);
+	local_irq_restore(flags);
+}
+#endif
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
+		if (CACHE_FLUSH_IS_SAFE) {
+			if (current->mm && addr < TASK_SIZE) {
+				flush_cache_range(current->mm->mmap_cache,
+						addr, addr + BREAK_INSTR_SIZE);
+			} else {
+				flush_icache_range(addr, addr +
+						BREAK_INSTR_SIZE);
+			}
+		}
+		kgdb_break[i].state = BP_ACTIVE;
+	}
+	return 0;
+}
+
+static int kgdb_set_sw_break(unsigned long addr)
+{
+	int error = kgdb_validate_break_address(addr);
+	int breakno = -1;
+	int i;
+
+	if (error < 0)
+		return error;
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
+		if (CACHE_FLUSH_IS_SAFE && current->mm &&
+				addr < TASK_SIZE) {
+			flush_cache_range(current->mm->mmap_cache,
+					addr, addr + BREAK_INSTR_SIZE);
+		} else if (CACHE_FLUSH_IS_SAFE) {
+			flush_icache_range(addr, addr + BREAK_INSTR_SIZE);
+		}
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
+static inline int shadow_pid(int realpid)
+{
+	if (realpid)
+		return realpid;
+
+	return pid_max + raw_smp_processor_id();
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
+int kgdb_io_ready(int print_wait)
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
+	/*
+	 * Also, if we haven't been able to roundup all
+	 * CPUs, send an 'O' packet informing the user
+	 * as much.  Only need to do this once.
+	 */
+	if (!ks->all_cpus_synced)
+		kgdb_msg_write("Not all CPUs have been synced for KGDB\n", 39);
+
+	remcom_out_buffer[0] = 'S';
+	remcom_out_buffer[1] = hexchars[ks->signo >> 4];
+	remcom_out_buffer[2] = hexchars[ks->signo % 16];
+}
+
+/* Handle the 'g' get registers request */
+static void gdb_cmd_getregs(struct kgdb_state *ks)
+{
+	struct pt_regs *shadowregs;
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
+	if (arch_kgdb_ops.shadowth &&
+			ks->kgdb_usethreadid >= pid_max + num_online_cpus()) {
+
+		shadowregs = kgdb_shadow_regs(ks->linux_regs,
+					  ks->kgdb_usethreadid -
+					  pid_max -
+					  num_online_cpus());
+		if (!shadowregs) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			return;
+		}
+		pt_regs_to_gdb_regs(gdb_regs, shadowregs);
+	} else {
+		if (local_debuggerinfo) {
+			pt_regs_to_gdb_regs(gdb_regs, local_debuggerinfo);
+		} else {
+			/*
+			 * Pull stuff saved during switch_to; nothing
+			 * else is accessible (or even particularly
+			 * relevant).
+			 *
+			 * This should be enough for a stack trace.
+			 */
+			sleeping_thread_to_gdb_regs(gdb_regs, thread);
+		}
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
+
+	if (kgdb_hex2long(&ptr, &addr) > 0 && *ptr++ == ',' &&
+					kgdb_hex2long(&ptr, &length) > 0) {
+
+		ptr = kgdb_mem2hex((char *)addr, remcom_out_buffer, length);
+		if (IS_ERR(ptr))
+			error_packet(remcom_out_buffer, PTR_ERR(ptr));
+	} else {
+		error_packet(remcom_out_buffer, -EINVAL);
+	}
+}
+
+/* Handle the 'M' memory write bytes */
+static void gdb_cmd_memwrite(struct kgdb_state *ks)
+{
+	char *ptr = write_mem_msg(0);
+
+	if (IS_ERR(ptr))
+		error_packet(remcom_out_buffer, PTR_ERR(ptr));
+	else
+		strcpy(remcom_out_buffer, "OK");
+}
+
+/* Handle the 'X' memory binary write bytes */
+static void gdb_cmd_binwrite(struct kgdb_state *ks)
+{
+	char *ptr = write_mem_msg(1);
+
+	if (IS_ERR(ptr))
+		error_packet(remcom_out_buffer, PTR_ERR(ptr));
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
+		printk(KERN_CRIT "Executing reboot\n");
+		strcpy(remcom_out_buffer, "OK");
+		put_packet(remcom_out_buffer);
+		emergency_sync();
+
+		/*
+		 * Execution should not return from
+		 * machine_restart()
+		 */
+		machine_restart(NULL);
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
+	int numshadowth = num_online_cpus() + arch_kgdb_ops.shadowth;
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
+		/*
+		 * If we have not yet completed in
+		 * pidhash_init() there isn't much we
+		 * can give back.
+		 */
+		if (init_pid_ns.last_pid == 0) {
+			if (remcom_in_buffer[1] == 'f')
+				strcpy(remcom_out_buffer, "m0000000000000001");
+			break;
+		}
+
+		if (remcom_in_buffer[1] == 'f')
+			ks->threadid = 1;
+
+		remcom_out_buffer[0] = 'm';
+		ptr = remcom_out_buffer + 1;
+
+		for (i = 0; i < 17 && ks->threadid < pid_max + numshadowth;
+							ks->threadid++) {
+
+			thread = getthread(ks->linux_regs, ks->threadid);
+			if (thread) {
+				int_to_threadref(thref, ks->threadid);
+				pack_threadid(ptr, thref);
+				ptr += 16;
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
+		if (ks->threadid < pid_max) {
+			kgdb_mem2hex(getthread(ks->linux_regs,
+					ks->threadid)->comm,
+					remcom_out_buffer, 16);
+		} else {
+			if (ks->threadid >= pid_max + num_online_cpus()) {
+				kgdb_shadowinfo(ks->linux_regs,
+					remcom_out_buffer,
+					ks->threadid - pid_max -
+					num_online_cpus());
+			} else {
+				static char tmpstr[23 + BUF_THREAD_ID_SIZE];
+				sprintf(tmpstr, "Shadow task %d for pid 0",
+						(int)(ks->threadid - pid_max));
+				kgdb_mem2hex(tmpstr, remcom_out_buffer,
+							 strlen(tmpstr));
+			}
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
+	} else {
+		if (kgdb_hex2long(&ptr, &addr)) {
+			if (*(ptr++) != ',' ||
+				!kgdb_hex2long(&ptr, &length)) {
+				error_packet(remcom_out_buffer, -EINVAL);
+				return;
+			}
+		} else {
+			error_packet(remcom_out_buffer, -EINVAL);
+			return;
+		}
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
+		/*
+		 * Warn debugger if the CPUs are not synced with an 'O'
+		 * packet:
+		 */
+		if (!ks->all_cpus_synced) {
+			kgdb_msg_write("Not all CPUs have been synced for "
+			       "KGDB\n", 39);
+		}
+		/* Reply to host that an exception has occurred */
+		ptr = remcom_out_buffer;
+		*ptr++ = 'T';
+		*ptr++ = hexchars[(ks->signo >> 4) % 16];
+		*ptr++ = hexchars[ks->signo % 16];
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
+	if (atomic_read(&debugger_active) != raw_smp_processor_id() + 1)
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
+ *	kgdb lock (debugger_active)
+ *
+ * Note that since we can be in here prior to our cpumask being filled
+ * out, we err on the side of caution and loop over NR_CPUS instead
+ * of a for_each_online_cpu.
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
+	ks->all_cpus_synced	= 0;
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
+	 * Being the process of declaring a master debug processor, the
+	 * goal is to have only one single processor set debugger_active
+	 * to the number of the cpu + 1.  The atomic variable kgdb_sync is
+	 * used to control the selection.
+	 */
+	while (1) {
+		i = 25;	/* an arbitrary number */
+		if (atomic_read(&kgdb_sync) < 0 &&
+			atomic_inc_and_test(&kgdb_sync)) {
+			atomic_set(&debugger_active, cpu + 1);
+			break;
+		}
+
+		while (--i)
+			cpu_relax();
+
+		if (atomic_read(&cpu_doing_single_step) != -1 &&
+				atomic_read(&cpu_doing_single_step) != cpu)
+			udelay(1);
+	}
+
+	/*
+	 * Do not start the debugger connection on this CPU if the last
+	 * instance of the exception handler wanted to come into the
+	 * debugger on a different CPU via a single step
+	 */
+	if (atomic_read(&cpu_doing_single_step) != -1 &&
+	    atomic_read(&cpu_doing_single_step) != cpu) {
+
+		atomic_set(&debugger_active, 0);
+		atomic_set(&kgdb_sync, -1);
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
+	 * Get the slave CPU lock which will hold all the non-master
+	 * CPU in a spin state while the debugger is active
+	 */
+	if (!debugger_step || !kgdb_contthread) {
+		for (i = 0; i < NR_CPUS; i++)
+			spin_lock(&slave_cpu_locks[i]);
+	}
+
+#ifdef CONFIG_SMP
+	/* Signal the other CPUs to enter kgdb_wait() */
+	if (!debugger_step || !kgdb_contthread)
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
+	 * Wait a reasonable time for the other CPUs to be notified and
+	 * be waiting for us.  Very early on this could be imperfect
+	 * as num_online_cpus() could be 0.
+	 */
+	for (i = 0; i < ROUNDUP_WAIT; i++) {
+		int num = 0;
+		int n;
+
+		for (n = 0; n < NR_CPUS; n++) {
+			if (atomic_read(&cpu_in_kgdb[n]))
+				num++;
+		}
+		if (num >= num_online_cpus()) {
+			ks->all_cpus_synced = 1;
+			break;
+		}
+	}
+
+	/* Master processor is completely in the debugger */
+	kgdb_post_master_code(ks->linux_regs, ks->ex_vector, ks->err_code);
+	kgdb_deactivate_sw_breakpoints();
+	debugger_step = 0;
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
+	if (!debugger_step || !kgdb_contthread) {
+		for (i = NR_CPUS-1; i >= 0; i--)
+			spin_unlock(&slave_cpu_locks[i]);
+		/*
+		 * Wait till all the CPUs have quit
+		 * from the debugger.
+		 */
+		for (i = 0; i < NR_CPUS; i++) {
+			while (atomic_read(&cpu_in_kgdb[i])) {
+				int j = 10;	/* an arbitrary number */
+
+				while (--j)
+					cpu_relax();
+			}
+		}
+	}
+
+#ifdef CONFIG_SMP
+	/*
+	 * This delay has a real purpose.  The problem is that if you
+	 * are single-stepping, you are sending an NMI to all the
+	 * other CPUs to stop them.  Interrupts come in, but don't get
+	 * handled.  Then you let them go just long enough to get into
+	 * their interrupt routines and use up some stack. You stop them
+	 * again, and then do the same thing.  After a while you blow
+	 * the stack on the other CPUs. This delay gives some time for
+	 * interrupts to be cleared out on the other CPUs.
+	 */
+	if (debugger_step)
+		mdelay(2);
+#endif
+kgdb_restore:
+	/* Free debugger_active */
+	atomic_set(&debugger_active, 0);
+	atomic_set(&kgdb_sync, -1);
+	local_irq_restore(flags);
+
+	return error;
+}
+
+/*
+ * GDB places a breakpoint at this function to know dynamically
+ * loaded objects. It's not defined static so that only one instance with this
+ * name exists in the kernel.
+ */
+
+int module_event(struct notifier_block *self, unsigned long val, void *data)
+{
+	return 0;
+}
+
+static struct notifier_block kgdb_module_load_nb = {
+	.notifier_call	= module_event,
+};
+
+int kgdb_nmicallback(int cpu, void *regs)
+{
+#ifdef CONFIG_SMP
+	if (!atomic_read(&cpu_in_kgdb[cpu]) &&
+		atomic_read(&debugger_active) != (cpu + 1)) {
+		kgdb_wait((struct pt_regs *)regs);
+		return 0;
+	}
+#endif
+	return 1;
+}
+
+/*
+ * This is called when a panic happens.  All we need to do is
+ * kgdb_breakpoint().
+ */
+static int
+kgdb_panic_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
+{
+	if (atomic_read(&debugger_active) != 0) {
+		printk(KERN_ERR "KGDB: Cannot handle panic while"
+				"debugger active\n");
+		dump_stack();
+		return NOTIFY_DONE;
+	}
+	printk(KERN_ERR "kgdb panic point\n");
+	kgdb_breakpoint();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kgdb_panic_notifier = {
+	.notifier_call	= kgdb_panic_notify,
+};
+
+#ifdef CONFIG_KGDB_CONSOLE_OUTPUT
+
+void kgdb_console_write(struct console *co, const char *s, unsigned count)
+{
+	unsigned long flags;
+
+	/* If we're debugging, or KGDB has not connected, don't try
+	 * and print. */
+	if (!kgdb_connected || atomic_read(&debugger_active) != 0)
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
+}
+;
+#endif
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
+		atomic_notifier_chain_register(&panic_notifier_list,
+					&kgdb_panic_notifier);
+		register_module_notifier(&kgdb_module_load_nb);
+		register_reboot_notifier(&kgdb_reboot_notifier);
+#ifdef CONFIG_MAGIC_SYSRQ
+		register_sysrq_key('g', &sysrq_gdb_op);
+#endif
+#ifdef CONFIG_KGDB_CONSOLE_OUTPUT
+		/* Initialize the console registration */
+		register_console(&kgdbcons);
+#endif
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
+		kgdb_arch_uninit();
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+					  &kgdb_panic_notifier);
+		unregister_module_notifier(&kgdb_module_load_nb);
+		unregister_reboot_notifier(&kgdb_reboot_notifier);
+#ifdef CONFIG_MAGIC_SYSRQ
+		unregister_sysrq_key('g', &sysrq_gdb_op);
+#endif
+#ifdef CONFIG_KGDB_CONSOLE_OUTPUT
+		/* Initialize the console registration */
+		unregister_console(&kgdbcons);
+#endif
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
+/*
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
+static int
+kgdb_notify_reboot(struct notifier_block *this, unsigned long code, void *x)
+{
+	unsigned long flags;
+
+	/*
+	 * If we're debugging, or KGDB has not connected, don't try
+	 * and print:
+	 */
+	if (!kgdb_connected || atomic_read(&debugger_active) != 0)
+		return 0;
+
+	if (code == SYS_RESTART || code == SYS_HALT || code == SYS_POWER_OFF) {
+		local_irq_save(flags);
+		put_packet("X00");
+		kgdb_connected = 0;
+		local_irq_restore(flags);
+	}
+	return NOTIFY_DONE;
+}
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
Index: linux-kgdb.q/lib/Kconfig.debug
===================================================================
--- linux-kgdb.q.orig/lib/Kconfig.debug
+++ linux-kgdb.q/lib/Kconfig.debug
@@ -632,3 +632,5 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
 source "samples/Kconfig"
+
+source "lib/Kconfig.kgdb"
Index: linux-kgdb.q/lib/Kconfig.kgdb
===================================================================
--- /dev/null
+++ linux-kgdb.q/lib/Kconfig.kgdb
@@ -0,0 +1,37 @@
+
+menuconfig KGDB
+	bool "KGDB: kernel debugging with remote gdb"
+	select FRAME_POINTER
+	depends on ARCH_SUPPORTS_KGDB
+	depends on DEBUG_KERNEL && EXPERIMENTAL
+	help
+	  If you say Y here, it will be possible to remotely debug the
+	  kernel using gdb.  Documentation of kernel debugger is available
+	  at http://kgdb.sourceforge.net as well as in DocBook form
+	  in Documentation/DocBook/.  If unsure, say N.
+
+config KGDB_ARCH_HAS_SHADOW_INFO
+	bool
+
+config KGDB_CONSOLE_OUTPUT
+	bool "KGDB: Console messages through gdb"
+	depends on KGDB
+	help
+	  If you say Y here, console messages will appear through gdb.
+	  Other consoles such as tty or ttyS will continue to work as usual.
+	  Note that if you use this in conjunction with KGDBOE, if the
+	  ethernet driver runs into an error condition during use with KGDB,
+	  it is possible to hit an infinite recursion, causing the kernel
+	  to crash, and typically reboot.  For this reason, it is preferable
+	  to use NETCONSOLE in conjunction with KGDBOE instead of
+	  KGDB_CONSOLE.
+
+config KGDBOC
+	tristate "KGDB: use kgdb over the serial console"
+	depends on KGDB
+	select CONSOLE_POLL
+	select MAGIC_SYSRQ
+	default y
+	help
+	  Share a serial console with kgdb. Sysrq-g must be used
+	  to break in initially.
