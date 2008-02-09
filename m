Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYBINfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYBINfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYBINfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:35:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:60347 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbYBINey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:34:54 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/8] kgdb: core API and gdb protocol handler
Date: Sat,  9 Feb 2008 07:35:07 -0600
Message-Id: <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Feb 2008 13:34:53.0008 (UTC) FILETIME=[8D13F500:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

This patch provides all of the common code, documentation and basic
Kconfig changes, as well as the common hooks.  With out arch changes
this code does not actually do anything to the kernel.  The idea is
that each arch can add in a minimal set of hooks to make use of the
KGDB core.

The core contains the protocol handler to talk to a debugger client
such as gdb via the gdb serial protocol.  The core also contains the
needed hooks for an arch to be SMP and preempt safe.  The weak
definitions allow an arch to override a part of the core, if it the
arch impelmentation requires it.

Jason Wessel <jason.wessel@windriver.com>
 - breakup kgdb_handle_exeception
 - dyanmic registration of kgdb hooks
Jan Kiszka <jan.kiszka@web.de>
 - Reduce EXPORT_SYMBOLs, switch the rest to EXPORT_SYMBOL_GPL
 - Drop code that is (yet) unused
 - Rename variables, refactor their types (personal taste, for sure)
 - Remove "extern" for function prototypes
 - Remove MODULE_LICENSE/DESCRIPTION from kgdb core
 - Refactor Kconfig kgdb choices
Ingo Molnar <mingo@elte.hu>
 - clean up includes, eliminate duplicate ones.
 - general code cleanups and comments
Harvey Harrison <harvey.harrison@gmail.com>
 - compilation cleanups

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 Documentation/DocBook/Makefile  |    2 +-
 Documentation/DocBook/kgdb.tmpl |  163 ++++
 MAINTAINERS                     |    7 +
 include/asm-generic/kgdb.h      |  105 ++
 include/linux/clocksource.h     |    1 +
 include/linux/kgdb.h            |  268 ++++++
 include/linux/sched.h           |    1 +
 kernel/Makefile                 |    1 +
 kernel/kgdb.c                   | 2018 +++++++++++++++++++++++++++++++++++++++
 kernel/sched.c                  |    3 +-
 kernel/softlockup.c             |    7 +-
 kernel/time/clocksource.c       |   12 +
 lib/Kconfig.debug               |    2 +
 lib/Kconfig.kgdb                |   32 +
 14 files changed, 2619 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/DocBook/kgdb.tmpl
 create mode 100644 include/asm-generic/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 6a0ad47..1721ea4 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -6,7 +6,7 @@
 # To add a new book the only step required is to add the book to the
 # list of DOCBOOKS.
 
-DOCBOOKS := wanbook.xml z8530book.xml mcabook.xml videobook.xml \
+DOCBOOKS := wanbook.xml z8530book.xml mcabook.xml videobook.xml kgdb.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
new file mode 100644
index 0000000..c423411
--- /dev/null
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -0,0 +1,163 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
+
+<book id="kgdbInternals">
+ <bookinfo>
+  <title>KGDB Internals</title>
+
+  <authorgroup>
+   <author>
+    <firstname>Tom</firstname>
+    <surname>Rini</surname>
+    <affiliation>
+     <address>
+      <email>trini@kernel.crashing.org</email>
+     </address>
+    </affiliation>
+   </author>
+  </authorgroup>
+
+  <authorgroup>
+   <author>
+    <firstname>Amit S.</firstname>
+    <surname>Kale</surname>
+    <affiliation>
+     <address>
+      <email>amitkale@linsyssoft.com</email>
+     </address>
+    </affiliation>
+   </author>
+  </authorgroup>
+
+  <copyright>
+   <year>2004-2005</year>
+   <holder>MontaVista Software, Inc.</holder>
+  </copyright>
+  <copyright>
+   <year>2004</year>
+   <holder>Amit S. Kale</holder>
+  </copyright>
+
+  <legalnotice>
+   <para>
+   This file is licensed under the terms of the GNU General Public License
+   version 2. This program is licensed "as is" without any warranty of any
+   kind, whether express or implied.
+   </para>
+
+  </legalnotice>
+ </bookinfo>
+
+<toc></toc>
+  <chapter id="Introduction">
+    <title>Introduction</title>
+    <para>
+    kgdb is a source level debugger for linux kernel. It is used along
+    with gdb to debug a linux kernel. Kernel developers can debug a kernel
+    similar to application programs with the use of kgdb. It makes it
+    possible to place breakpoints in kernel code, step through the code
+    and observe variables.
+    </para>
+    <para>
+    Two machines are required for using kgdb. One of these machines is a
+    development machine and the other is a test machine. The machines are
+    typically connected through a serial line, a null-modem cable which
+    connects their serial ports.  It is also possible however, to use an
+    ethernet connection between the machines.  The kernel to be debugged
+    runs on the test machine. gdb runs on the development machine. The
+    serial line or ethernet connection is used by gdb to communicate to
+    the kernel being debugged.
+    </para>
+  </chapter>
+  <chapter id="CompilingAKernel">
+    <title>Compiling a kernel</title>
+    <para>
+    To enable <symbol>CONFIG_KGDB</symbol>, look under the "Kernel debugging"
+    and then select "KGDB: kernel debugging with remote gdb".
+    </para>
+    <para>
+    Next you should choose one of more I/O drivers to interconnect debugging
+    host and debugged target.  If debugging early boot steps is required,
+    at least one driver has to be built in.  I/O driver configuration takes
+    place via kernel or module parameters, see following chapter.
+    </para>
+    <para>
+    While KGDB is connect with the host, it can dump console messages over
+    this link.  This is specifically useful for collecting critical kernel
+    messages while only a single serial port is available.  Enable
+    <symbol>CONFIG_KGDB_CONSOLE</symbol> to activate this feature.
+    </para>
+  </chapter>
+  <chapter id="BootingTheKernel">
+    <title>Booting the kernel</title>
+    <para>
+    All drivers can be reconfigured at run time, if
+    <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol> are
+    enabled, by echo'ing a new config string to
+    <constant>/sys/module/&lt;driver&gt;/parameter/&lt;option&gt;</constant>.
+    The driver can be unconfigured by passing an empty string.  You cannot
+    change the configuration while the debugger is attached.  In that case
+    issue the required <constant>detach</constant> command via gdb first.
+    </para>
+  </chapter>
+  <chapter id="ConnectingGDB">
+  <title>Connecting gdb</title>
+    <para>
+    If you have used any of the methods to have KGDB stop and create
+    an initial breakpoint described in the previous chapter, kgdb prints
+    the message "Waiting for connection from remote gdb..." on the console
+    and waits for connection from gdb. At this point you connect gdb to kgdb.
+    </para>
+    <para>
+    Example (serial):
+    </para>
+    <programlisting>
+    % gdb ./vmlinux
+    (gdb) set remotebaud 115200
+    (gdb) target remote /dev/ttyS0
+    </programlisting>
+    <para>
+    Example (ethernet):
+    </para>
+    <programlisting>
+    % gdb ./vmlinux
+    (gdb) target remote udp:192.168.2.2:6443
+    </programlisting>
+    <para>
+    Once connected, you can debug a kernel the way you would debug an
+    application program.
+    </para>
+  </chapter>
+  <chapter id="CommonBackEndReq">
+    <title>The common backend (required)</title>
+      <para>
+      There are a few flags which must be set on every architecture in
+      their &lt;asm/kgdb.h&gt; file.  These are:
+      <itemizedlist>
+        <listitem>
+	  <para>
+	  NUMREGBYTES: The size in bytes of all of the registers, so
+	  that we can ensure they will all fit into a packet.
+	  </para>
+	  <para>
+	  BUFMAX: The size in bytes of the buffer GDB will read into.
+	  This must be larger than NUMREGBYTES.
+	  </para>
+	  <para>
+	  CACHE_FLUSH_IS_SAFE: Set to one if it is always safe to call
+	  flush_cache_range or flush_icache_range.  On some architectures,
+	  these functions may not be safe to call on SMP since we keep other
+	  CPUs in a holding pattern.
+	  </para>
+	</listitem>
+      </itemizedlist>
+      </para>
+      <para>
+      There are also the following functions for the common backend,
+      found in kernel/kgdb.c, that must be supplied by the
+      architecture-specific backend.  No weak version of these is provided.
+      </para>
+!Iinclude/linux/kgdb.h
+  </chapter>
+</book>
diff --git a/MAINTAINERS b/MAINTAINERS
index 0d6f511..71d20e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2311,6 +2311,13 @@ L:	linux-kernel@vger.kernel.org
 L:	kexec@lists.infradead.org
 S:	Maintained
 
+KGDB
+P:	Jason Wessel
+M:	jason.wessel@windriver.com
+W:	http://sourceforge.net/projects/kgdb
+L:	kgdb-bugreport@lists.sourceforge.net
+S:	Maintained
+
 KPROBES
 P:	Prasanna S Panchamukhi
 M:	prasanna@in.ibm.com
diff --git a/include/asm-generic/kgdb.h b/include/asm-generic/kgdb.h
new file mode 100644
index 0000000..24e0b6c
--- /dev/null
+++ b/include/asm-generic/kgdb.h
@@ -0,0 +1,105 @@
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
+#ifdef CONFIG_X86
+/**
+ *	kgdb_skipexception - Bail of of KGDB when we've been triggered.
+ *	@exception: Exception vector number
+ *	@regs: Current &struct pt_regs.
+ *
+ *	On some architectures we need to skip a breakpoint exception when
+ *	it occurs after a breakpoint has been removed.
+ */
+int kgdb_skipexception(int exception, struct pt_regs *regs);
+#else
+static inline int kgdb_skipexception(int exception, struct pt_regs *regs)
+{
+	return 0;
+}
+#endif
+
+#if defined(CONFIG_X86)
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
+#else
+#define kgdb_disable_hw_debug(regs)		do { } while (0)
+#define kgdb_post_master_code(regs, v, c)	do { } while (0)
+#endif
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
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 85778a4..3509447 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -216,6 +216,7 @@ static inline void clocksource_calculate_interval(struct clocksource *c,
 /* used to install a new clocksource */
 extern int clocksource_register(struct clocksource*);
 extern void clocksource_unregister(struct clocksource*);
+extern void clocksource_touch_watchdog(void);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
 extern void clocksource_resume(void);
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
new file mode 100644
index 0000000..7abe5bd
--- /dev/null
+++ b/include/linux/kgdb.h
@@ -0,0 +1,268 @@
+/*
+ * include/linux/kgdb.h
+ *
+ * This provides the hooks and functions that KGDB needs to share between
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
+void breakpoint(void);
+
+extern int kgdb_connected;
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
+ *	specific hooks.
+ */
+int kgdb_arch_init(void);
+
+/**
+ *	kgdb_arch_uninit - Perform any architecture specific uninitalization.
+ *
+ *	This function will handle the uninitalization of any architecture
+ *	specific hooks, for dynamic registration and unregistration.
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
+ *	kgdb hook.
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
+	const char	*name;
+	int		(*read_char) (void);
+	void		(*write_char) (u8);
+	void		(*flush) (void);
+	int		(*init) (void);
+	void		(*pre_exception) (void);
+	void		(*post_exception) (void);
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
+int kgdb_nmihook(int cpu, void *regs);
+
+extern int		debugger_step;
+extern atomic_t		debugger_active;
+
+static inline int kgdb_active(void)
+{
+	return (atomic_read(&debugger_active) != 0);
+}
+
+#else /* !CONFIG_KGDB */
+#define kgdb_active()		0
+#endif /* !CONFIG_KGDB */
+
+#endif /* _KGDB_H_ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 00e1441..7507f8e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -297,6 +297,7 @@ extern unsigned long  softlockup_thresh;
 extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
 extern unsigned long sysctl_hung_task_warnings;
+extern struct atomic_notifier_head softlock_chain;
 #else
 static inline void softlockup_tick(void)
 {
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
index 0000000..3f06d09
--- /dev/null
+++ b/kernel/kgdb.c
@@ -0,0 +1,2018 @@
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
+ *
+ * Contributors at various stages not listed above:
+ *  Jan Kiszka <jan.kiszka@web.de>
+ *  Jason Wessel <jason.wessel@windriver.com>
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
+#include <linux/clocksource.h>
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
+extern int pid_max;
+/* How many times to count all of the waiting CPUs */
+#define ROUNDUP_WAIT		640000	/* Arbitrary, increase if needed. */
+#define BUF_THREAD_ID_SIZE	16
+
+static spinlock_t		slave_cpu_locks[NR_CPUS] = {
+	[0 ... NR_CPUS-1] = __SPIN_LOCK_UNLOCKED(slave_cpu_locks)
+};
+static atomic_t			cpu_in_debugger[NR_CPUS];
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
+static int kgdb_mem_cpy(void *dst, void *src, int count)
+{
+	int leftover;
+
+	pagefault_disable();
+	leftover = __copy_from_user_inatomic(dst, src, count);
+	pagefault_enable();
+
+	if (leftover)
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * Weak aliases for breakpoint management,
+ * can be overriden by architectures when needed:
+ */
+int __weak kgdb_validate_break_address(unsigned long addr)
+{
+	char tmp_variable[BREAK_INSTR_SIZE];
+
+	if (!kgdb_mem_cpy(tmp_variable, (void *)addr, BREAK_INSTR_SIZE))
+		return 0;
+	return -1;
+}
+
+int __weak kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
+{
+	if (kgdb_mem_cpy(saved_instr, (void *)addr, BREAK_INSTR_SIZE))
+		return -1;
+
+	if (kgdb_mem_cpy((void *)addr, arch_kgdb_ops.gdb_bpt_instr,
+						BREAK_INSTR_SIZE))
+		return -1;
+	return 0;
+}
+
+int __weak kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
+{
+	if (kgdb_mem_cpy((void *)addr, bundle, BREAK_INSTR_SIZE))
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
+		if (kgdb_mem_cpy(&tmp_s, mem, count))
+			return ERR_PTR(-EINVAL);
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
+		if (kgdb_mem_cpy(&tmp_l, mem, count))
+			return ERR_PTR(-EINVAL);
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
+		if (kgdb_mem_cpy(&tmp_ll, mem, count))
+			return ERR_PTR(-EINVAL);
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
+			if (kgdb_mem_cpy(&ch, mem, 1))
+				return ERR_PTR(-EINVAL);
+			mem++;
+			*buf++ = hexchars[ch >> 4];
+			*buf++ = hexchars[ch & 0xf];
+		}
+	}
+
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
+			char c = *buf ^ 0x20;
+			if (kgdb_mem_cpy(mem, &c, 1))
+				return ERR_PTR(-EINVAL);
+			buf++;
+		} else
+			if (kgdb_mem_cpy(mem, buf, 1))
+				return ERR_PTR(-EINVAL);
+		mem++;
+	}
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
+		if (kgdb_mem_cpy(mem, &tmp_s, count) == -EFAULT)
+			return ERR_PTR(-EINVAL);
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
+		if (kgdb_mem_cpy(mem, &tmp_l, count) == -EFAULT)
+			return ERR_PTR(-EINVAL);
+		mem += 4;
+	} else {
+		int i;
+
+		for (i = 0; i < count; i++) {
+			unsigned char ch = hex(*buf++) << 4;
+
+			ch |= hex(*buf++);
+			if (kgdb_mem_cpy(mem, &ch, 1) == -EFAULT)
+				return ERR_PTR(-EINVAL);
+			mem++;
+		}
+	}
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
+void int_to_threadref(unsigned char *id, int value)
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
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+static int kgdb_softlock_reset[NR_CPUS];
+static unsigned long kgdb_softlock_time[NR_CPUS];
+static int
+kgdb_softlock_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
+{
+	/* Ultimately this can be improved, for now just check for the
+	 * condition where the touch stamp has not changed and stop the
+	 * notify because it means the original touch failed because the
+	 * HW had not yet registered a tick at the time of the resume.
+	 */
+
+	int cpu = raw_smp_processor_id();
+	unsigned long val = *(unsigned long *)ptr;
+
+	if (!kgdb_softlock_reset[cpu])
+		return NOTIFY_DONE;
+
+	if (!kgdb_softlock_time[cpu]) {
+		kgdb_softlock_time[cpu] = val;
+		return NOTIFY_STOP;
+	}
+
+	if (kgdb_softlock_time[cpu] == val)
+		return NOTIFY_STOP;
+
+	kgdb_softlock_reset[cpu] = 0;
+	return NOTIFY_STOP;
+}
+static struct notifier_block kgdb_softlock_notifier = {
+	.notifier_call	= kgdb_softlock_notify,
+};
+static void kgdb_softlock_touch(int cpu)
+{
+	kgdb_softlock_time[cpu] = 0;
+	kgdb_softlock_reset[cpu] = 1;
+	touch_softlockup_watchdog();
+}
+#else
+static inline void kgdb_softlock_touch(int cpu)
+{
+}
+#endif
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
+	atomic_set(&cpu_in_debugger[cpu], 1);
+
+	/*
+	 * The master CPU must be active to enter here, but this is
+	 * gaurd in case the master CPU had not been selected if
+	 * this was an entry via nmi.
+	 */
+	while (!kgdb_active())
+		cpu_relax();
+
+	/* Wait till master CPU goes completely into the debugger. */
+	while (!atomic_read(&cpu_in_debugger[atomic_read(&debugger_active) - 1])) {
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
+	atomic_set(&cpu_in_debugger[cpu], 0);
+	spin_unlock(&slave_cpu_locks[cpu]);
+	clocksource_touch_watchdog();
+	kgdb_softlock_touch(cpu);
+	local_irq_restore(flags);
+}
+#endif
+
+/*
+ * SW breakpoint management:
+ */
+int kgdb_activate_sw_breakpoints(void)
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
+int kgdb_deactivate_sw_breakpoints(void)
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
+		WARN_ON(1);
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
+		clocksource_touch_watchdog();
+		kgdb_softlock_touch(cpu);
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
+	atomic_set(&cpu_in_debugger[ks->cpu], 1);
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
+			if (atomic_read(&cpu_in_debugger[n]))
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
+	atomic_set(&cpu_in_debugger[ks->cpu], 0);
+
+	if (!debugger_step || !kgdb_contthread) {
+		for (i = NR_CPUS-1; i >= 0; i--)
+			spin_unlock(&slave_cpu_locks[i]);
+		/*
+		 * Wait till all the CPUs have quit
+		 * from the debugger.
+		 */
+		for (i = 0; i < NR_CPUS; i++) {
+			while (atomic_read(&cpu_in_debugger[i])) {
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
+	clocksource_touch_watchdog();
+	kgdb_softlock_touch(ks->cpu);
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
+int kgdb_nmihook(int cpu, void *regs)
+{
+#ifdef CONFIG_SMP
+	if (!atomic_read(&cpu_in_debugger[cpu]) &&
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
+ * breakpoint().
+ */
+static int
+kgdb_panic_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
+{
+	if (kgdb_active()) {
+		printk(KERN_ERR "KGDB: Cannot handle panic while"
+				"debugger active\n");
+		dump_stack();
+		return NOTIFY_DONE;
+	}
+	breakpoint();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kgdb_panic_notifier = {
+	.notifier_call	= kgdb_panic_notify,
+};
+
+#ifdef CONFIG_KGDB_CONSOLE
+void kgdb_console_write(struct console *co, const char *s, unsigned count)
+{
+	unsigned long flags;
+
+	/* If we're debugging, or KGDB has not connected, don't try
+	 * and print. */
+	if (!kgdb_connected || kgdb_active())
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
+	breakpoint();
+}
+
+static struct sysrq_key_op sysrq_gdb_op = {
+	.handler	= sysrq_handle_gdb,
+	.help_msg	= "Gdb",
+	.action_msg	= "GDB",
+};
+#endif
+
+static void kgdb_register_hooks(void)
+{
+	if (!kgdb_io_module_registered) {
+		kgdb_io_module_registered = 1;
+		kgdb_arch_init();
+		atomic_notifier_chain_register(&panic_notifier_list,
+					&kgdb_panic_notifier);
+		register_module_notifier(&kgdb_module_load_nb);
+		register_reboot_notifier(&kgdb_reboot_notifier);
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+		atomic_notifier_chain_register(&softlock_chain,
+					&kgdb_softlock_notifier);
+#endif
+#ifdef CONFIG_MAGIC_SYSRQ
+		register_sysrq_key('g', &sysrq_gdb_op);
+#endif
+#ifdef CONFIG_KGDB_CONSOLE
+		/* Initialize the console registration */
+		register_console(&kgdbcons);
+#endif
+	}
+}
+
+static void kgdb_unregister_hooks(void)
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
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+		atomic_notifier_chain_unregister(&softlock_chain,
+					&kgdb_softlock_notifier);
+#endif
+#ifdef CONFIG_MAGIC_SYSRQ
+		unregister_sysrq_key('g', &sysrq_gdb_op);
+#endif
+#ifdef CONFIG_KGDB_CONSOLE
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
+	breakpoint();
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
+	kgdb_register_hooks();
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
+	 * unregister our hooks and reset state.
+	 */
+	kgdb_unregister_hooks();
+
+	spin_lock(&kgdb_registration_lock);
+
+	WARN_ON(kgdb_io_ops != old_kgdb_io_ops);
+	kgdb_io_ops = NULL;
+
+	spin_unlock(&kgdb_registration_lock);
+
+	printk(KERN_INFO "kgdb: Unregistered I/O driver %s, debugger "
+		"disabled.\n", old_kgdb_io_ops->name);
+}
+EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
+
+/*
+ * This function will generate a breakpoint exception.  It is used at the
+ * beginning of a program to sync up with a debugger and can be used
+ * otherwise as a quick means to stop program execution and "break" into
+ * the debugger.
+ */
+void breakpoint(void)
+{
+	atomic_set(&kgdb_setting_breakpoint, 1);
+	wmb(); /* Sync point before breakpoint */
+	BREAKPOINT();
+	wmb(); /* Sync point after breakpoint */
+	atomic_set(&kgdb_setting_breakpoint, 0);
+}
+EXPORT_SYMBOL_GPL(breakpoint);
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
+	if (!kgdb_connected || kgdb_active())
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 3eedd52..093b803 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -61,6 +61,7 @@
 #include <linux/times.h>
 #include <linux/tsacct_kern.h>
 #include <linux/kprobes.h>
+#include <linux/kgdb.h>
 #include <linux/delayacct.h>
 #include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
@@ -7263,7 +7264,7 @@ void __might_sleep(char *file, int line)
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
-	if ((in_atomic() || irqs_disabled()) &&
+	if ((in_atomic() || irqs_disabled()) && !kgdb_active() &&
 	    system_state == SYSTEM_RUNNING && !oops_in_progress) {
 		if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
 			return;
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 7c2da88..d9658c0 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -15,6 +15,7 @@
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/kgdb.h>
 
 #include <asm/irq_regs.h>
 
@@ -24,6 +25,8 @@ static DEFINE_PER_CPU(unsigned long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
+ATOMIC_NOTIFIER_HEAD(softlock_chain);
+
 static int __read_mostly did_panic;
 unsigned long __read_mostly softlockup_thresh = 60;
 
@@ -52,7 +55,6 @@ static unsigned long get_timestamp(int this_cpu)
 void touch_softlockup_watchdog(void)
 {
 	int this_cpu = raw_smp_processor_id();
-
 	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
@@ -109,6 +111,9 @@ void softlockup_tick(void)
 	if (now <= (touch_timestamp + softlockup_thresh))
 		return;
 
+	if (atomic_notifier_call_chain(&softlock_chain, 0, &touch_timestamp) == NOTIFY_STOP)
+		return;
+
 	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
 	spin_lock(&print_lock);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 548c436..ace23d3 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -228,6 +228,18 @@ void clocksource_resume(void)
 }
 
 /**
+ * clocksource_touch_watchdog - Update watchdog
+ *
+ * Update the watchdog after exception contexts such as kgdb so as not
+ * to incorrectly trip the watchdog.
+ *
+ */
+void clocksource_touch_watchdog(void)
+{
+	clocksource_resume_watchdog();
+}
+
+/**
  * clocksource_get_next - Returns the selected clocksource
  *
  */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ce0bb26..9824ff6 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -632,3 +632,5 @@ config PROVIDE_OHCI1394_DMA_INIT
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
 source "samples/Kconfig"
+
+source "lib/Kconfig.kgdb"
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
new file mode 100644
index 0000000..afa61bb
--- /dev/null
+++ b/lib/Kconfig.kgdb
@@ -0,0 +1,32 @@
+
+menuconfig KGDB
+	bool "KGDB: kernel debugging with remote gdb"
+	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
+	select DEBUG_INFO
+	select FRAME_POINTER
+	depends on DEBUG_KERNEL && ADD_A_KGDB_ARCH
+	help
+	  If you say Y here, it will be possible to remotely debug the
+	  kernel using gdb.  Documentation of kernel debugger is available
+	  at http://kgdb.sourceforge.net as well as in DocBook form
+	  in Documentation/DocBook/.  If unsure, say N.
+
+config KGDB_ARCH_HAS_SHADOW_INFO
+	bool
+	depends on KGDB
+
+config KGDB_CONSOLE
+	bool "Console messages through gdb"
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
+comment "KGDB I/O drivers"
+	depends on KGDB
-- 
1.5.4

