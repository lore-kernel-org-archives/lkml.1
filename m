Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbXEXJWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbXEXJWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXEXJWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:22:32 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:32635 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbXEXJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:22:30 -0400
Date: Thu, 24 May 2007 12:22:21 +0300
From: Dan Aloni <da-x@monatomic.org>
To: kdb@oss.sgi.com, Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kexec/kdump and kdb
Message-ID: <20070524092221.GA13510@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Below is a very preliminary patch that adds kexec/kdump invocation 
functionality in kdb. It is currently based on 2.6.20.11 and 
supported only for x86_64.

The main use case is for a user who would like to make use of the
interactive debugger but wants to conserve the option whether to 
create a crash dump interactively. It also makes it possible to 
dump even if the kernel hasn't crashed by manually entering kdb 
and entering 'kdump' (yes I know sysrq also allows you to trigger 
a crash dump).

There are a few issues with this patch (mainly being incomplete), 
I'd like to check the public interest with this feature before I
develop it further.


diff --git a/arch/x86_64/kernel/crash.c b/arch/x86_64/kernel/crash.c
index 95a7a2c..b68a0f5 100644
--- a/arch/x86_64/kernel/crash.c
+++ b/arch/x86_64/kernel/crash.c
@@ -31,6 +31,18 @@ static int crashing_cpu;
 #ifdef CONFIG_SMP
 static atomic_t waiting_for_crash_ipi;
 
+static void halt_current_cpu(struct pt_regs *regs)
+{
+	local_irq_disable();
+
+	crash_save_cpu(regs, raw_smp_processor_id());
+	disable_local_APIC();
+	atomic_dec(&waiting_for_crash_ipi);
+	/* Assume hlt works */
+	for(;;)
+		halt();
+}
+
 static int crash_nmi_callback(struct notifier_block *self,
 				unsigned long val, void *data)
 {
@@ -50,15 +62,8 @@ static int crash_nmi_callback(struct notifier_block *self,
 	 */
 	if (cpu == crashing_cpu)
 		return NOTIFY_STOP;
-	local_irq_disable();
-
-	crash_save_cpu(regs, cpu);
-	disable_local_APIC();
-	atomic_dec(&waiting_for_crash_ipi);
-	/* Assume hlt works */
-	for(;;)
-		halt();
 
+	halt_current_cpu(regs);
 	return 1;
 }
 
@@ -77,11 +82,26 @@ static struct notifier_block crash_nmi_nb = {
 	.notifier_call = crash_nmi_callback,
 };
 
-static void nmi_shootdown_cpus(void)
+static void wait_other_cpus(void)
 {
 	unsigned long msecs;
 
+	msecs = 1000; /* Wait at most a second for the other cpus to stop */
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
+		mdelay(1);
+		msecs--;
+	}
+}
+
+static void nmi_shootdown_cpus_init(void)
+{
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
+}
+
+static void nmi_shootdown_cpus(void)
+{
+	nmi_shootdown_cpus_init();
+
 	if (register_die_notifier(&crash_nmi_nb))
 		return;         /* return what? */
 
@@ -93,19 +113,23 @@ static void nmi_shootdown_cpus(void)
 
 	smp_send_nmi_allbutself();
 
-	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
-		mdelay(1);
-		msecs--;
-	}
+	wait_other_cpus();
 	/* Leave the nmi callback set */
+
 	disable_local_APIC();
 }
+
 #else
+
 static void nmi_shootdown_cpus(void)
 {
 	/* There are no cpus to shootdown */
 }
+
+static void nmi_shootdown_cpus_init(void) {};
+static void wait_other_cpus() {}
+static void halt_current_cpu(struct pt_regs *regs) {};
+
 #endif
 
 void machine_crash_shutdown(struct pt_regs *regs)
@@ -133,3 +157,26 @@ void machine_crash_shutdown(struct pt_regs *regs)
 
 	crash_save_cpu(regs, smp_processor_id());
 }
+
+void machine_crash_shutdown_begin(void)
+{
+	local_irq_disable();
+	nmi_shootdown_cpus_init();
+}
+
+void machine_crash_shutdown_end(struct pt_regs *regs)
+{
+	wait_other_cpus();
+
+	local_irq_disable();
+	if(cpu_has_apic)
+		disable_local_APIC();
+
+	disable_IO_APIC();
+	crash_save_cpu(regs, smp_processor_id());
+}
+
+void machine_crash_shutdown_other_cpu(struct pt_regs *regs)
+{
+	halt_current_cpu(regs);
+}
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index e4340d3..1cf413e 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -161,4 +161,11 @@ int kdb_process_cpu(const struct task_struct *p)
 
 extern const char kdb_serial_str[];
 
+#ifdef CONFIG_KEXEC
+
+void kdb_kexec_prepare(struct pt_regs *regs);
+void kexec_from_kdb(struct pt_regs *regs, int kdump);
+
+#endif
+
 #endif	/* !_KDB_H */
diff --git a/include/linux/kdbprivate.h b/include/linux/kdbprivate.h
index 50dee9f..ca2c3db 100644
--- a/include/linux/kdbprivate.h
+++ b/include/linux/kdbprivate.h
@@ -162,6 +162,7 @@ volatile extern int kdb_state[ /*NR_CPUS*/ ];
 #define KDB_STATE_IP_ADJUSTED	0x00008000	/* Restart IP has been adjusted */
 #define KDB_STATE_GO1		0x00010000	/* go only releases one cpu */
 #define KDB_STATE_KEYBOARD	0x00020000	/* kdb entered via keyboard on this cpu */
+#define KDB_STATE_KEXEC   	0x00040000	/* kexec issued */
 #define KDB_STATE_ARCH		0xff000000	/* Reserved for arch specific use */
 
 #define KDB_STATE_CPU(flag,cpu)		(kdb_state[cpu] & KDB_STATE_##flag)
diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 1dd1c70..f4d682c 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -53,7 +53,10 @@ extern void machine_power_off(void);
 
 extern void machine_shutdown(void);
 struct pt_regs;
-extern void machine_crash_shutdown(struct pt_regs *);
+extern void machine_crash_shutdown(struct pt_regs *regs);
+extern void machine_crash_shutdown_begin(void);
+extern void machine_crash_shutdown_other_cpu(struct pt_regs *regs);
+extern void machine_crash_shutdown_end(struct pt_regs *regs);
 
 /* 
  * Architecture independent implemenations of sys_reboot commands.
diff --git a/kdb/kdbmain.c b/kdb/kdbmain.c
index 9dfa3b3..2ecacfc 100644
--- a/kdb/kdbmain.c
+++ b/kdb/kdbmain.c
@@ -1124,6 +1124,116 @@ kdb_reboot(int argc, const char **argv)
 	return 0;
 }
 
+#ifdef CONFIG_KEXEC
+
+int kdb_kexec_state = -1;
+
+static int kdb_cpu(int argc, const char **argv);
+
+void kdb_kexec_prepare(struct pt_regs *regs)
+{
+	int i;
+	struct pt_regs r;
+	if (regs == NULL)
+		regs = &r;
+
+	machine_crash_shutdown_begin();
+	
+	for (i = 1; i < NR_CPUS; ++i) {
+		if (!cpu_online(i))
+			continue;
+
+		KDB_STATE_SET_CPU(KEXEC, i);
+	}
+
+	machine_crash_shutdown_end(regs);
+}
+
+void kdb_kexec_check(struct pt_regs *regs)
+{
+	if (kdb_kexec_state != -1) {
+		kexec_from_kdb(regs, kdb_kexec_state);
+
+		/* If the call above returned then something 
+		   didn't work */
+		kdb_kexec_state = -1;
+	}
+}
+
+static int 
+kdb_switch_cpu_for_kexec(int new_state)
+{
+	const char *cpu_argv[] = {NULL, "0", NULL};
+	int ret;
+
+	kdb_kexec_state = new_state;
+	ret = kdb_cpu(1, cpu_argv);
+	if (ret != KDB_CMD_CPU) {
+		kdb_kexec_state = -1;
+	}
+
+	return ret;
+}
+
+
+/*
+ * kdb_kexec
+ *
+ *     This function implements the 'kexec' command.
+ *
+ * Inputs:
+ *     argc    argument count
+ *     argv    argument vector
+ *     envp    environment vector
+ *     regs    registers at time kdb was entered.
+ * Outputs:
+ *     None.
+ * Returns:
+ *     zero for success, a kdb diagnostic if error
+ * Locking:
+ *     none.
+ * Remarks:
+ *     Shouldn't return from this function.
+ */
+
+static int
+kdb_kexec(int argc, const char **argv)
+{
+	return kdb_switch_cpu_for_kexec(0);
+}
+
+/*
+ * kdb_kdump
+ *
+ *     This function implements the 'kdump' command.
+ *
+ * Inputs:
+ *     argc    argument count
+ *     argv    argument vector
+ *     envp    environment vector
+ *     regs    registers at time kdb was entered.
+ * Outputs:
+ *     None.
+ * Returns:
+ *     zero for success, a kdb diagnostic if error
+ * Locking:
+ *     none.
+ * Remarks:
+ *     Shouldn't return from this function.
+ */
+
+static int
+kdb_kdump(int argc, const char **argv)
+{
+	return kdb_switch_cpu_for_kexec(1);
+}
+
+#else
+
+static inline void kdb_kexec_check(struct pt_regs *regs) {};
+
+#endif
+
 static int
 kdb_quiet(int reason)
 {
@@ -1166,6 +1276,8 @@ kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs, kdb_dbtrap_t db_
 	int diag;
 	struct task_struct *kdb_current = kdb_curr_task(smp_processor_id());
 
+	kdb_kexec_check(regs);
+
 	/* If kdb has been entered for an event which has been/will be
 	 * recovered then silently return.  We have to get this far into kdb in
 	 * order to synchronize all the cpus, typically only one cpu (monarch)
@@ -1553,7 +1665,18 @@ kdb_main_loop(kdb_reason_t reason, kdb_reason_t reason2, int error,
 			if (!KDB_STATE(KDB)) {
 				KDB_STATE_SET(KDB);
 			}
+
+#ifdef CONFIG_KEXEC
+			if (KDB_STATE(KEXEC)) {
+				struct pt_regs r;
+				if (regs == NULL)
+					regs = &r;
+				machine_crash_shutdown_other_cpu(regs);
+				return 0;
+			}
+#endif
 		}
+
 		KDB_STATE_CLEAR(SUPPRESS);
 		KDB_DEBUG_STATE("kdb_main_loop 2", reason);
 		if (KDB_STATE(LEAVING))
@@ -3821,6 +3944,10 @@ kdb_inittab(void)
 	kdb_register_repeat("ps", kdb_ps, "", 		"Display active task list", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("pid", kdb_pid, "<pidnum>",	"Switch to another task", 0, KDB_REPEAT_NONE);
 	kdb_register_repeat("reboot", kdb_reboot, "",  "Reboot the machine immediately", 0, KDB_REPEAT_NONE);
+#if defined(CONFIG_KEXEC)
+	kdb_register_repeat("kexec", kdb_kexec, "",    "Calls kexec in crash mode", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("kdump", kdb_kdump, "",    "Calls kdump mode", 0, KDB_REPEAT_NONE);
+#endif
 #if defined(CONFIG_MODULES)
 	kdb_register_repeat("lsmod", kdb_lsmod, "",	"List loaded kernel modules", 0, KDB_REPEAT_NONE);
 #endif
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2a59c8a..5858db1 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -22,6 +22,8 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/module.h>
+#include <linux/device.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -29,6 +31,10 @@
 #include <asm/system.h>
 #include <asm/semaphore.h>
 
+#ifdef CONFIG_KDB
+#include <linux/kdb.h>
+#endif
+
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t* crash_notes;
 
@@ -1045,6 +1051,12 @@ asmlinkage long compat_sys_kexec_load(unsigned long entry,
 
 void crash_kexec(struct pt_regs *regs)
 {
+#if !CONFIG_KDB
+	/*
+	 * If we enabled KDB, we don't want to automatically 
+	 * perform a kdump since KDB will be responsible for 
+	 * executing kdb through a special 'kdump' command.
+	 */
 	int locked;
 
 
@@ -1067,8 +1079,38 @@ void crash_kexec(struct pt_regs *regs)
 		locked = xchg(&kexec_lock, 0);
 		BUG_ON(!locked);
 	}
+#endif
 }
 
+#ifdef CONFIG_KDB
+
+void kexec_from_kdb(struct pt_regs *regs, int kdump)
+{
+	struct kimage *image;
+	int locked;
+
+	locked = xchg(&kexec_lock, 1);
+	if (!locked) {
+		if (kdump) 
+			image = kexec_crash_image;
+		else 
+			image = kexec_image;
+
+		if (image) {
+			struct pt_regs fixed_regs;
+
+			crash_setup_regs(&fixed_regs, regs);
+			kdb_kexec_prepare(&fixed_regs);
+			machine_kexec(image);
+		}
+
+		locked = xchg(&kexec_lock, 0);
+		BUG_ON(!locked);
+	}
+}
+
+#endif
+
 static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
 			    size_t data_len)
 {


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
