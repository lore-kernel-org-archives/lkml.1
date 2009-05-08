Return-Path: <linux-kernel-owner+w=401wt.eu-S1764242AbZEHVYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764242AbZEHVYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZEHVXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:44752 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbZEHVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:33 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 02/13] RFC ONLY - kgdb: core changes to support kdb
Date: Fri,  8 May 2009 16:23:09 -0500
Message-Id: <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:25.0638 (UTC) FILETIME=[390D5E60:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC patch.  The work to possibly merge kdb and kgdb is being
evaluated and this patch is considered only a proof of concept or
prototype.

These are the minimum changes to the kgdb core in order to enable an
API to add on a different kgdb front end instead of the gdb stub
driver.

This patch introduces the comm_passthrough which is simply an
alternate frontend that gets to talk to the kgdb I/O drivers instead
of the gdb stub.

You can switch back and forth between kdb or the gdb stub mode of
operation dynamically.  From gdb stub mode you can blindly type
"$3#33", or from the kdb mode you can enter "kgdb" to switch to the
gdb stub.

The logic in the kgdb core depends on the kdb mode to to look for the
typical gdb connection sequences and return with KGDB_PASS_EVENT.
That should allow a reasonably seemless transition without leaving the
kernel exception state.  The two gdb queries are the "?" and
"qSupported" query.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/arm/kernel/kgdb.c     |    5 +
 arch/mips/kernel/kgdb.c    |    5 +
 arch/powerpc/kernel/kgdb.c |    5 +
 arch/x86/kernel/kgdb.c     |    5 +
 include/linux/kgdb.h       |    3 +
 kernel/kgdb.c              |  202 ++++++++++++++++++++++++++++++++++++++++++--
 lib/Kconfig.kgdb           |   14 +++
 7 files changed, 233 insertions(+), 6 deletions(-)

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
index 6e152c8..54f2d40 100644
--- a/arch/mips/kernel/kgdb.c
+++ b/arch/mips/kernel/kgdb.c
@@ -179,6 +179,11 @@ void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
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
index fe8f71d..e8207a3 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -315,6 +315,11 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
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
index eedfaeb..6d2503d 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -572,6 +572,11 @@ unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
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
index 6adcc29..3e838d6 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -263,6 +263,7 @@ extern struct kgdb_arch		arch_kgdb_ops;
 
 extern unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs);
 
+extern void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc);
 extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 
@@ -271,6 +272,8 @@ extern int kgdb_mem2hex(char *mem, char *buf, int count);
 extern int kgdb_hex2mem(char *buf, char *mem, int count);
 
 extern int kgdb_isremovedbreak(unsigned long addr);
+extern int kgdb_remove_sw_break(unsigned long addr);
+extern int kgdb_set_sw_break(unsigned long addr);
 
 extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index e4dcfb2..067f2cf 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -47,6 +47,9 @@
 #include <linux/pid.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/kdebug.h>
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -94,6 +97,15 @@ static int kgdb_con_registered;
 /* determine if kgdb console output should be used */
 static int kgdb_use_con;
 
+/* Controls for using the kgdb passthrough */
+#ifdef CONFIG_KGDB_KDB_PRIMARY
+static int kgdb_use_passthrough = 1;
+#else /* ! CONFIG_KGDB_KDB_PRIMARY */
+static int kgdb_use_passthrough;
+#endif /* CONFIG_KGDB_KDB_PRIMARY */
+#define KGDB_PASS_EVENT -12345
+
+
 static int __init opt_kgdb_con(char *str)
 {
 	kgdb_use_con = 1;
@@ -239,6 +251,155 @@ void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
 }
 
 /*
+ * KDB interface to KGDB internals
+ */
+#ifdef CONFIG_KGDB_KDB
+static void gdb_cmd_status(struct kgdb_state *ks);
+static void put_packet(char *buffer);
+static int kgdb_activate_sw_breakpoints(void);
+
+static int kgdbio_get_char(void)
+{
+	int ret = kgdb_io_ops->read_char();
+	if (!kgdb_use_passthrough)
+		return ret;
+	if (ret == 127)
+		return 8;
+	return ret;
+}
+
+get_char_func kdb_poll_funcs[] = {
+	kgdbio_get_char,
+	NULL,
+};
+
+static int comm_passthrough(struct kgdb_state *ks)
+{
+	int error = 0;
+	unsigned long addr = kgdb_arch_pc(ks->ex_vector, ks->linux_regs);
+	kdb_reason_t reason = KDB_REASON_OOPS;
+	kdb_dbtrap_t db_result = KDB_DB_NOBPT;
+	int i;
+
+	ks->pass_exception = 0;
+	if (ks->err_code == DIE_OOPS)
+		KDB_FLAG_SET(CATASTROPHIC);
+	if (atomic_read(&kgdb_setting_breakpoint))
+		reason = KDB_REASON_KEYBOARD;
+
+	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
+		if ((kgdb_break[i].state == BP_SET) &&
+			(kgdb_break[i].bpt_addr == addr)) {
+			reason = KDB_REASON_BREAK;
+			db_result = KDB_DB_BPT;
+			if (addr != instruction_pointer(ks->linux_regs))
+				kgdb_arch_set_pc(ks->linux_regs, addr);
+			break;
+		}
+	}
+	if (reason == KDB_REASON_BREAK) {
+		kdb_bp_t *bp;
+		for (i = 0, bp = kdb_breakpoints; i < KDB_MAXBPT; i++, bp++) {
+			if (bp->bp_free)
+				continue;
+			if (bp->bp_addr == addr) {
+				bp->bp_delay = 1;
+				bp->bp_delayed = 1;
+			/* SSBPT is set when the kernel debugger must
+			 * single step a task in order to re-establish
+			 * an instruction breakpoint which uses the
+			 * instruction replacement mechanism.  It is
+			 * cleared by any action that removes the need
+			 * to single-step the breakpoint.
+			 */
+				KDB_STATE_SET(SSBPT);
+				break;
+			}
+		}
+	}
+
+	if (reason != KDB_REASON_BREAK && ks->ex_vector == 0 &&
+		ks->signo == SIGTRAP) {
+		reason = KDB_REASON_SSTEP;
+		db_result = KDB_DB_BPT;
+	}
+	/* Set initial kdb state variables */
+	KDB_STATE_CLEAR(KGDB_TRANS);
+	kdb_initial_cpu = ks->cpu;
+	kdb_current_task = kgdb_info[ks->cpu].task;
+	kdb_current_regs = kgdb_info[ks->cpu].debuggerinfo;
+	/* Remove any breakpoints as needed by kdb and clear single step*/
+	kdb_bp_remove_local();
+	kdb_bp_remove_global();
+	KDB_STATE_CLEAR(DOING_SS);
+	KDB_STATE_CLEAR(DOING_SSB);
+	for_each_online_cpu(i) {
+		kdb_save_running_cpu(kgdb_info[i].debuggerinfo,
+				     kgdb_info[i].task, i);
+	}
+	/* XXX FIXME XXX
+	 * Need to fix this such that it is locked to a
+	 * specific thread and address
+	 */
+	kdb_initial_cpu = ks->cpu;
+	if (KDB_STATE(SSBPT) && reason == KDB_REASON_SSTEP) {
+		KDB_STATE_CLEAR(SSBPT);
+		KDB_STATE_CLEAR(DOING_SS);
+	} else {
+		/* Start kdb main loop */
+		error = kdb_main_loop(KDB_REASON_ENTER, reason,
+				      ks->err_code, db_result, ks->linux_regs);
+	}
+	/* Upon exit from the kdb main loop setup break points and restart
+	 * the system based on the requested continue state
+	 */
+	kdb_initial_cpu = -1;
+	kdb_current_task = NULL;
+	kdb_current_regs = NULL;
+	kdbnearsym_cleanup();
+	if (error == KDB_CMD_KGDB) {
+		if (KDB_STATE(DOING_KGDB) || KDB_STATE(DOING_KGDB2)) {
+			kgdb_io_ops->write_char('+');
+			if (KDB_STATE(DOING_KGDB))
+				gdb_cmd_status(ks);
+			else
+				strcpy(remcom_out_buffer, "");
+			KDB_STATE_CLEAR(DOING_KGDB);
+			KDB_STATE_CLEAR(DOING_KGDB2);
+			put_packet(remcom_out_buffer);
+		}
+		return KGDB_PASS_EVENT;
+	}
+	kdb_bp_install_global(ks->linux_regs);
+	kdb_bp_install_local(ks->linux_regs);
+	kgdb_activate_sw_breakpoints();
+	if (KDB_STATE(DOING_SS))
+		strcpy(remcom_in_buffer, "s");
+	else
+		strcpy(remcom_in_buffer, "c");
+
+	if (KDB_FLAG(CATASTROPHIC) && ks->err_code == DIE_OOPS)
+		ks->pass_exception = 1;
+	KDB_FLAG_CLEAR(CATASTROPHIC);
+
+	error = kgdb_arch_handle_exception(ks->ex_vector,
+					   ks->signo,
+					   ks->err_code,
+					   remcom_in_buffer,
+					   remcom_out_buffer,
+					   ks->linux_regs);
+	if (ks->pass_exception)
+		error = 1;
+	return error;
+}
+#else /* ! CONFIG_KGDB_KDB */
+static int comm_passthrough(struct kgdb_state *ks)
+{
+	return KGDB_PASS_EVENT;
+}
+#endif /* CONFIG_KGDB_KDB */
+
+/*
  * GDB remote protocol parser:
  */
 
@@ -638,7 +799,7 @@ static int kgdb_activate_sw_breakpoints(void)
 	return 0;
 }
 
-static int kgdb_set_sw_break(unsigned long addr)
+int kgdb_set_sw_break(unsigned long addr)
 {
 	int err = kgdb_validate_break_address(addr);
 	int breakno = -1;
@@ -700,7 +861,7 @@ static int kgdb_deactivate_sw_breakpoints(void)
 	return 0;
 }
 
-static int kgdb_remove_sw_break(unsigned long addr)
+int kgdb_remove_sw_break(unsigned long addr)
 {
 	int i;
 
@@ -817,8 +978,14 @@ static int kgdb_io_ready(int print_wait)
 		return 1;
 	if (atomic_read(&kgdb_setting_breakpoint))
 		return 1;
-	if (print_wait)
+	if (print_wait) {
+#ifdef CONFIG_KGDB_KDB
+		if (!kgdb_use_passthrough)
+			printk(KERN_CRIT "KGDB: waiting... or $3#33 for KDB\n");
+#else
 		printk(KERN_CRIT "KGDB: Waiting for remote debugger\n");
+#endif
+	}
 	return 1;
 }
 
@@ -1293,6 +1460,13 @@ static int gdb_serial_stub(struct kgdb_state *ks)
 		case 'Z': /* Break point set */
 			gdb_cmd_break(ks);
 			break;
+#ifdef CONFIG_KGDB_KDB
+		case '3': /* Escape into the comm_passthrough */
+			if (remcom_in_buffer[1] == '\0') {
+				gdb_cmd_detachkill(ks);
+				return KGDB_PASS_EVENT;
+			}
+#endif
 		case 'C': /* Exception passing */
 			tmp = gdb_cmd_exception_pass(ks);
 			if (tmp > 0)
@@ -1499,8 +1673,18 @@ acquirelock:
 	kgdb_contthread = current;
 	exception_level = 0;
 
-	/* Talk to debugger with gdbserial protocol */
-	error = gdb_serial_stub(ks);
+	while (1) {
+		if (kgdb_use_passthrough) {
+			error = comm_passthrough(ks);
+		} else {
+			/* Talk to debugger with gdbserial protocol */
+			error = gdb_serial_stub(ks);
+		}
+		if (error == KGDB_PASS_EVENT)
+			kgdb_use_passthrough = !kgdb_use_passthrough;
+		else
+			break;
+	}
 
 	/* Call the I/O driver's post_exception routine */
 	if (kgdb_io_ops->post_exception)
@@ -1575,8 +1759,14 @@ static void sysrq_handle_gdb(int key, struct tty_struct *tty)
 		printk(KERN_CRIT "ERROR: No KGDB I/O module available\n");
 		return;
 	}
-	if (!kgdb_connected)
+	if (!kgdb_connected) {
+#ifdef CONFIG_KGDB_KDB
+		if (!kgdb_use_passthrough)
+			printk(KERN_CRIT "KGDB or $3#33 for KDB\n");
+#else
 		printk(KERN_CRIT "Entering KGDB\n");
+#endif
+	}
 
 	kgdb_breakpoint();
 }
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 9b5d1d7..59b47b9 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -57,4 +57,18 @@ config KGDB_TESTS_BOOT_STRING
 	  information about other strings you could use beyond the
 	  default of V1F100.
 
+config KGDB_KDB
+	bool "KGDB_KDB: include kdb frontend for kgdb"
+	default n
+	help
+	  KDB frontend for kernel
+
+config KGDB_KDB_PRIMARY
+	bool "KGDB_KDB: Make kdb the default debugger"
+	depends on KGDB_KDB
+	default y
+	help
+	  KDB will be the active debugger instead of the typical kgdb
+	  frontend.
+
 endif # KGDB
-- 
1.6.3.rc0.1.gf800

