Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZLWV2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZLWV2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZLWV16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:27:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:45055 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbZLWVUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:30 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 12/37] kgdb: core changes to support kdb
Date: Wed, 23 Dec 2009 15:19:25 -0600
Message-Id: <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:10.0879 (UTC) FILETIME=[B59040F0:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the minimum changes to the kgdb core in order to enable an
API to connect a new front end (kdb) to the debug core.

This patch introduces the dbg_kdb_mode variable controls where the
user level I/O is routed.  It will be routed to the gdbstub (kgdb) or
to the kdb front end which is a simple shell available over the kgdboc
connection.

You can switch back and forth between kdb or the gdb stub mode of
operation dynamically.  From gdb stub mode you can blindly type
"$3#33", or from the kdb mode you can enter "kgdb" to switch to the
gdb stub.

The logic in the debug core depends on kdb to look for the typical gdb
connection sequences and return immediately with KGDB_PASS_EVENT if a
gdb serial command sequence is detected.  That should allow a
reasonably seamless transition between kdb -> gdb without leaving the
kernel exception state.  The two gdb serial queries that kdb is
responsible for detecting are the "?" and "qSupported" packets.

CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/arm/kernel/kgdb.c     |    5 ++
 arch/mips/kernel/kgdb.c    |    5 ++
 arch/powerpc/kernel/kgdb.c |    5 ++
 arch/x86/kernel/kgdb.c     |    5 ++
 include/linux/kgdb.h       |    1 +
 kernel/debug/debug_core.c  |   97 +++++++++++++++++++++++++++++++++++++-------
 kernel/debug/debug_core.h  |   24 +++++++++++
 kernel/debug/gdbstub.c     |   38 +++++++++++++++++-
 lib/Kconfig.kgdb           |    6 +++
 9 files changed, 170 insertions(+), 16 deletions(-)

diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index ba8ccfe..bb17e9b 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -97,6 +97,11 @@ sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *task)
 	gdb_regs[_CPSR]		= thread_regs->ARM_cpsr;
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
+{
+	regs->ARM_pc = pc;
+}
+
 static int compiled_break;
 
 int kgdb_arch_handle_exception(int exception_vector, int signo,
diff --git a/arch/mips/kernel/kgdb.c b/arch/mips/kernel/kgdb.c
index 50c9bb8..6ed4c83 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -180,6 +180,11 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
 	*(ptr++) = regs->cp0_epc;
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
+{
+	regs->cp0_epc = pc;
+}
+
 /*
  * Calls linux_debug_hook before the kernel dies. If KGDB is enabled,
  * then try to fall into the debugger
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index b6bd1ea..7aafcc5 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -309,6 +309,11 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 	       (unsigned long)(((void *)gdb_regs) + NUMREGBYTES));
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc)
+{
+	regs->nip = pc;
+}
+
 /*
  * This function does PowerPC specific procesing for interfacing to gdb.
  */
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 48384fa..135c3ec 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -659,6 +659,11 @@ unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
 	return instruction_pointer(regs);
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->ip = ip;
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: */
 	.gdb_bpt_instr		= { 0xcc },
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index cedae0b..32e8ffb 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -262,6 +262,7 @@ extern struct kgdb_arch		arch_kgdb_ops;
 
 extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
 
+extern void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc);
 extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index fe1fd41..16184c5 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -77,6 +77,11 @@ static DEFINE_SPINLOCK(kgdb_registration_lock);
 static int kgdb_con_registered;
 /* determine if kgdb console output should be used */
 static int kgdb_use_con;
+/* Next cpu to become the master debug core */
+int dbg_switch_cpu;
+
+/* Use kdb or gdbserver mode */
+static int dbg_kdb_mode = 1;
 
 static int __init opt_kgdb_con(char *str)
 {
@@ -301,7 +306,7 @@ int dbg_set_sw_break(unsigned long addr)
 	return 0;
 }
 
-static int kgdb_deactivate_sw_breakpoints(void)
+int dbg_deactivate_sw_breakpoints(void)
 {
 	unsigned long addr;
 	int error;
@@ -395,8 +400,14 @@ static int kgdb_io_ready(int print_wait)
 		return 1;
 	if (atomic_read(&kgdb_setting_breakpoint))
 		return 1;
-	if (print_wait)
+	if (print_wait) {
+#ifdef CONFIG_KGDB_KDB
+		if (!dbg_kdb_mode)
+			printk(KERN_CRIT "KGDB: waiting... or $3#33 for KDB\n");
+#else
 		printk(KERN_CRIT "KGDB: Waiting for remote debugger\n");
+#endif
+	}
 	return 1;
 }
 
@@ -410,7 +421,7 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 	/* Panic on recursive debugger calls: */
 	exception_level++;
 	addr = kgdb_arch_pc(ks->ex_vector, ks->linux_regs);
-	kgdb_deactivate_sw_breakpoints();
+	dbg_deactivate_sw_breakpoints();
 
 	/*
 	 * If the break point removed ok at the place exception
@@ -443,11 +454,24 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 	return 1;
 }
 
+static void dbg_cpu_switch(int cpu, int next_cpu)
+{
+	/* Mark the cpu we are switching away from as a slave when it
+	 * holds the kgdb_active token.  This must be done so that the
+	 * that all the cpus wait in for the debug core will not enter
+	 * again as the master. */
+	if (cpu == atomic_read(&kgdb_active)) {
+		kgdb_info[cpu].exception_state |= DCPU_IS_SLAVE;
+		kgdb_info[cpu].exception_state &= ~DCPU_WANT_MASTER;
+	}
+	kgdb_info[next_cpu].exception_state |= DCPU_NEXT_MASTER;
+}
+
 static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
 {
 	unsigned long flags;
 	int sstep_tries = 100;
-	int error = 0;
+	int error;
 	int i, cpu;
 acquirelock:
 	/*
@@ -459,6 +483,8 @@ acquirelock:
 	cpu = ks->cpu;
 	kgdb_info[cpu].debuggerinfo = regs;
 	kgdb_info[cpu].task = current;
+	kgdb_info[cpu].ret_state = 0;
+	kgdb_info[cpu].irq_depth = hardirq_count() >> HARDIRQ_SHIFT;
 	/*
 	 * Make sure the above info reaches the primary CPU before
 	 * our cpu_in_kgdb[] flag setting does:
@@ -471,7 +497,11 @@ acquirelock:
 	 * master cpu and acquire the kgdb_active lock:
 	 */
 	while (1) {
-		if (kgdb_info[cpu].exception_state & DCPU_WANT_MASTER) {
+cpu_loop:
+		if (kgdb_info[cpu].exception_state & DCPU_NEXT_MASTER) {
+			kgdb_info[cpu].exception_state &= ~DCPU_NEXT_MASTER;
+			goto cpu_master_loop;
+		} else if (kgdb_info[cpu].exception_state & DCPU_WANT_MASTER) {
 			if (atomic_cmpxchg(&kgdb_active, -1, cpu) == cpu)
 				break;
 		} else if (kgdb_info[cpu].exception_state & DCPU_IS_SLAVE) {
@@ -511,7 +541,7 @@ return_normal:
 	}
 
 	if (!kgdb_io_ready(1)) {
-		error = 1;
+		kgdb_info[cpu].ret_state = 1;
 		goto kgdb_restore; /* No I/O connection, resume the system */
 	}
 
@@ -555,13 +585,29 @@ return_normal:
 	 * in the debugger and all secondary CPUs are quiescent
 	 */
 	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
-	kgdb_deactivate_sw_breakpoints();
+	dbg_deactivate_sw_breakpoints();
 	kgdb_single_step = 0;
 	kgdb_contthread = current;
 	exception_level = 0;
 
-	/* Talk to debugger with gdbserial protocol */
-	error = gdb_serial_stub(ks);
+	while (1) {
+cpu_master_loop:
+		if (dbg_kdb_mode) {
+			error = kdb_stub(ks);
+		} else {
+			/* Talk to debugger with gdbserial protocol */
+			error = gdb_serial_stub(ks);
+		}
+		if (error == DBG_PASS_EVENT) {
+			dbg_kdb_mode = !dbg_kdb_mode;
+		} else if (error == DBG_SWITCH_CPU_EVENT) {
+			dbg_cpu_switch(cpu, dbg_switch_cpu);
+			goto cpu_loop;
+		} else {
+			kgdb_info[cpu].ret_state = error;
+			break;
+		}
+	}
 
 	/* Call the I/O driver's post_exception routine */
 	if (dbg_io_ops->post_exception)
@@ -573,11 +619,15 @@ return_normal:
 		for (i = NR_CPUS-1; i >= 0; i--)
 			atomic_set(&passive_cpu_wait[i], 0);
 		/*
-		 * Wait till all the CPUs have quit
-		 * from the debugger.
+		 * Wait till all the CPUs have quit from the debugger,
+		 * but allow a CPU that hit an exception and is
+		 * waiting to become the master to remain in the debug
+		 * core.
 		 */
 		for_each_online_cpu(i) {
-			while (atomic_read(&cpu_in_kgdb[i]))
+			while (atomic_read(&cpu_in_kgdb[i]) &&
+			       !(kgdb_info[i].exception_state &
+				 DCPU_WANT_MASTER))
 				cpu_relax();
 		}
 	}
@@ -596,7 +646,7 @@ kgdb_restore:
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
-	return error;
+	return kgdb_info[cpu].ret_state;
 }
 
 /*
@@ -625,7 +675,8 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 		return 0; /* Ouch, double exception ! */
 	kgdb_info[ks->cpu].exception_state |= DCPU_WANT_MASTER;
 	ret = kgdb_cpu_enter(ks, regs);
-	kgdb_info[ks->cpu].exception_state &= ~DCPU_WANT_MASTER;
+	kgdb_info[ks->cpu].exception_state &= ~(DCPU_WANT_MASTER |
+						DCPU_IS_SLAVE);
 	return ret;
 }
 
@@ -680,8 +731,14 @@ static void sysrq_handle_dbg(int key, struct tty_struct *tty)
 		printk(KERN_CRIT "ERROR: No KGDB I/O module available\n");
 		return;
 	}
-	if (!kgdb_connected)
+	if (!kgdb_connected) {
+#ifdef CONFIG_KGDB_KDB
+		if (!dbg_kdb_mode)
+			printk(KERN_CRIT "KGDB or $3#33 for KDB\n");
+#else
 		printk(KERN_CRIT "Entering KGDB\n");
+#endif
+	}
 
 	kgdb_breakpoint();
 }
@@ -810,6 +867,16 @@ void kgdb_unregister_io_module(struct kgdb_io *old_dbg_io_ops)
 }
 EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
 
+int dbg_io_get_char(void)
+{
+	int ret = dbg_io_ops->read_char();
+	if (!dbg_kdb_mode)
+		return ret;
+	if (ret == 127)
+		return 8;
+	return ret;
+}
+
 /**
  * kgdb_breakpoint - generate breakpoint exception
  *
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index a111cda..cf14dae 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -38,6 +38,8 @@ struct debuggerinfo_struct {
 	void			*debuggerinfo;
 	struct task_struct	*task;
 	int exception_state;
+	int ret_state;
+	int irq_depth;
 };
 
 extern struct debuggerinfo_struct kgdb_info[];
@@ -48,9 +50,31 @@ extern int dbg_remove_all_break(void);
 extern int dbg_set_sw_break(unsigned long addr);
 extern int dbg_remove_sw_break(unsigned long addr);
 extern int dbg_activate_sw_breakpoints(void);
+extern int dbg_deactivate_sw_breakpoints(void);
+
+/* polled character access to i/o module */
+extern int dbg_io_get_char(void);
+
+/* stub return value for switching between the gdbstub and kdb */
+#define DBG_PASS_EVENT -12345
+/* Switch from one cpu to another */
+#define DBG_SWITCH_CPU_EVENT -123456
+extern int dbg_switch_cpu;
 
 /* gdbstub interface functions */
 extern int gdb_serial_stub(struct kgdb_state *ks);
 extern void gdbstub_msg_write(const char *s, int len);
 
+/* gdbstub functions used for kdb <-> gdbstub transition */
+extern int gdbstub_state(struct kgdb_state *ks, char *cmd);
+
+#ifdef CONFIG_KGDB_KDB
+extern int kdb_stub(struct kgdb_state *ks);
+#else /* ! CONFIG_KGDB_KDB */
+static inline int kdb_stub(struct kgdb_state *ks)
+{
+	return DBG_PASS_EVENT;
+}
+#endif /* CONFIG_KGDB_KDB */
+
 #endif /* _DEBUG_CORE_H_ */
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index bae83cc..dfe1e3c 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -426,7 +426,7 @@ static inline int shadow_pid(int realpid)
  */
 
 /* Handle the '?' status packets */
-static void gdb_cmd_status(struct kgdb_state *ks)
+void gdb_cmd_status(struct kgdb_state *ks)
 {
 	/*
 	 * We know that this packet is only sent
@@ -892,6 +892,13 @@ int gdb_serial_stub(struct kgdb_state *ks)
 		case 'Z': /* Break point set */
 			gdb_cmd_break(ks);
 			break;
+#ifdef CONFIG_KGDB_KDB
+		case '3': /* Escape into the comm_passthrough */
+			if (remcom_in_buffer[1] == '\0') {
+				gdb_cmd_detachkill(ks);
+				return DBG_PASS_EVENT;
+			}
+#endif
 		case 'C': /* Exception passing */
 			tmp = gdb_cmd_exception_pass(ks);
 			if (tmp > 0)
@@ -937,3 +944,32 @@ kgdb_exit:
 		error = 1;
 	return error;
 }
+
+int gdbstub_state(struct kgdb_state *ks, char *cmd)
+{
+	int error;
+
+	switch (cmd[0]) {
+	case 'e':
+		error = kgdb_arch_handle_exception(ks->ex_vector,
+						   ks->signo,
+						   ks->err_code,
+						   remcom_in_buffer,
+						   remcom_out_buffer,
+						   ks->linux_regs);
+		return error;
+	case 's':
+	case 'c':
+		strcpy(remcom_in_buffer, cmd);
+		return 0;
+	case '?':
+		gdb_cmd_status(ks);
+		break;
+	case '\0':
+		strcpy(remcom_out_buffer, "");
+		break;
+	}
+	dbg_io_ops->write_char('+');
+	put_packet(remcom_out_buffer);
+	return 0;
+}
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 9b5d1d7..02b46de 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -57,4 +57,10 @@ config KGDB_TESTS_BOOT_STRING
 	  information about other strings you could use beyond the
 	  default of V1F100.
 
+config KGDB_KDB
+	bool "KGDB_KDB: include kdb frontend for kgdb"
+	default n
+	help
+	  KDB frontend for kernel
+
 endif # KGDB
-- 
1.6.4.rc1

