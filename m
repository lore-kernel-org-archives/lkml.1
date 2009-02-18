Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZBRJik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZBRJik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZBRJia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:38:30 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:32359 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZBRJi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:38:29 -0500
X-IronPort-AV: E=Sophos;i="4.38,228,1233550800"; 
   d="scan'208";a="83053571"
Subject: [PATCH] [kgdb] Switch master cpu after gdb thread command for SMP
	(v4)
From: sonic zhang <sonic.adi@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       kgdb mailing list <kgdb-bugreport@lists.sourceforge.net>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 17:37:54 +0800
Message-Id: <1234949874.17467.6.camel@eight.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

This is the updated kgdb SMP patch, which is tested on blackfin bf561 dual core
system. A new bug is fixed, which causes debugging halt in SMP kernel if a
breakpoint is hit and cpu is switched in gdb before continue running kernel.

   In blackfin SMP architecture, different core has its own L1 SRAM and MMR
   memory, which code running on the other core can't access. In current kgdb
   impelemntation, cpus are represented by thread with minus prefix.

If user run thread command in gdb to switch to the thread of the other cpu,
kgdb should:
1. send IPI signal to master cpu
2. release the specific passive cpu waiting in IPI handler
3. exit kgdb exception loop on master cpu and trap into kgdb wait in IPI handler
4. trap the released passive cpu into kgdb exception in IPI handler

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
---
 include/linux/kgdb.h
 kernel/kgdb.c

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6adcc29..664e396 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -203,6 +204,19 @@ kgdb_arch_handle_exception(int vector, int signo, int err_code,
  */
 extern void kgdb_roundup_cpus(unsigned long flags);
 
+/**
+ *	kgdb_roundup_cpu - Get spcific CPU into a holding pattern
+ *	@cpu: Specific cpu id
+ *	@flags: Current IRQ state
+ *
+ *	On SMP systems, we need to switch cpu from current active one to
+ *	the other passive one. This get current active CPU into a known state
+ *	in kgdb_wait(). 
+ *
+ *	On non-SMP systems, this is not called.
+ */
+extern void kgdb_roundup_cpu(int cpu, unsigned long flags);
+
 /* Optional functions. */
 extern int kgdb_validate_break_address(unsigned long addr);
 extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index e4dcfb2..277986d 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -565,6 +565,7 @@
 {
 	unsigned long flags;
 	int cpu;
+	struct task_struct *thread;
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
@@ -577,10 +578,26 @@
 	smp_wmb();
 	atomic_set(&cpu_in_kgdb[cpu], 1);
 
+	kgdb_disable_hw_debug(regs);
+
 	/* Wait till primary CPU is done with debugging */
 	while (atomic_read(&passive_cpu_wait[cpu]))
 		cpu_relax();
 
+	/* Trap into kgdb as the active CPU if gdb asks to switch. */
+	thread = getthread(regs, -raw_smp_processor_id() - 2);
+	if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) &&
+		kgdb_contthread && kgdb_contthread == current) {
+		kgdb_breakpoint();
+
+		kgdb_info[cpu].debuggerinfo = NULL;
+		kgdb_info[cpu].task = NULL;
+
+		clocksource_touch_watchdog();
+		local_irq_restore(flags);
+		return;
+	}
+ 
 	kgdb_info[cpu].debuggerinfo = NULL;
 	kgdb_info[cpu].task = NULL;
 
@@ -1066,13 +1083,16 @@
 			sprintf(tmpstr, "shadowCPU%d",
 					(int)(-ks->threadid - 2));
 			kgdb_mem2hex(tmpstr, remcom_out_buffer, strlen(tmpstr));
+
+			if (arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP)
+				ks->thr_query = 1;
 		}
 		break;
 	}
 }
 
 /* Handle the 'H' task query packets */
-static void gdb_cmd_task(struct kgdb_state *ks)
+static int gdb_cmd_task(struct kgdb_state *ks)
 {
 	struct task_struct *thread;
 	char *ptr;
@@ -1089,6 +1109,15 @@
 		kgdb_usethread = thread;
 		ks->kgdb_usethreadid = ks->threadid;
 		strcpy(remcom_out_buffer, "OK");
+#ifdef CONFIG_SMP
+		if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) &&
+			!ks->thr_query && ks->kgdb_usethreadid < -1 &&
+			- ks->kgdb_usethreadid - 2 != raw_smp_processor_id()) {
+			kgdb_roundup_cpu(raw_smp_processor_id(), 0);
+			kgdb_contthread = kgdb_usethread;
+			return 1;
+		}
+#endif
 		break;
 	case 'c':
 		ptr = &remcom_in_buffer[2];
@@ -1102,10 +1131,27 @@
 				break;
 			}
 			kgdb_contthread = thread;
+#ifdef CONFIG_SMP
+			if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) &&
+				thread != current) {
+				int cpu;
+				for_each_online_cpu(cpu) {
+					if (thread == kgdb_info[cpu].task) {
+						kgdb_roundup_cpu(
+							raw_smp_processor_id(),
+							0);
+						ks->kgdb_usethreadid = -cpu-2;
+						return 1;
+					}
+				}
+			}
+#endif
 		}
 		strcpy(remcom_out_buffer, "OK");
 		break;
 	}
+
+	return 0;
 }
 
 /* Handle the 'T' thread query packets */
@@ -1114,6 +1160,9 @@
 	char *ptr = &remcom_in_buffer[1];
 	struct task_struct *thread;
 
+	if (arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP)
+		ks->thr_query = 0;
+
 	kgdb_hex2long(&ptr, &ks->threadid);
 	thread = getthread(ks->linux_regs, ks->threadid);
 	if (thread)
@@ -1223,7 +1272,12 @@
 	/* Clear the out buffer. */
 	memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
 
-	if (kgdb_connected) {
+	if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) && kgdb_contthread) {
+		remcom_out_buffer[0] = 'O';
+		remcom_out_buffer[1] = 'K';
+		remcom_out_buffer[2] = 0;
+		put_packet(remcom_out_buffer);
+	} else if (kgdb_connected) {
 		unsigned char thref[8];
 		char *ptr;
 
@@ -1238,6 +1292,7 @@
 		put_packet(remcom_out_buffer);
 	}
 
+	kgdb_contthread = current;
 	kgdb_usethread = kgdb_info[ks->cpu].task;
 	ks->kgdb_usethreadid = shadow_pid(kgdb_info[ks->cpu].task->pid);
 	ks->pass_exception = 0;
@@ -1284,7 +1339,8 @@
 			gdb_cmd_query(ks);
 			break;
 		case 'H': /* task related */
-			gdb_cmd_task(ks);
+			if (gdb_cmd_task(ks))
+				goto kgdb_exit;
 			break;
 		case 'T': /* Query thread status */
 			gdb_cmd_thread(ks);
@@ -1324,6 +1380,7 @@
 			if (error >= 0 || remcom_in_buffer[0] == 'D' ||
 			    remcom_in_buffer[0] == 'k') {
 				error = 0;
+				kgdb_contthread = NULL;
 				goto kgdb_exit;
 			}
 
@@ -1464,11 +1521,15 @@
 	 * Get the passive CPU lock which will hold all the non-primary
 	 * CPU in a spin state while the debugger is active
 	 */
-	if (!kgdb_single_step) {
+	if (!kgdb_single_step && !kgdb_contthread) {
 		for (i = 0; i < NR_CPUS; i++)
 			atomic_set(&passive_cpu_wait[i], 1);
 	}
 
+	if (kgdb_contthread)
+		atomic_set(&passive_cpu_wait[raw_smp_processor_id()], 1);
+ 
+
 	/*
 	 * spin_lock code is good enough as a barrier so we don't
 	 * need one here:
@@ -1477,7 +1538,7 @@
 
 #ifdef CONFIG_SMP
 	/* Signal the other CPUs to enter kgdb_wait() */
-	if ((!kgdb_single_step) && kgdb_do_roundup)
+	if ((!kgdb_single_step && !kgdb_contthread) && kgdb_do_roundup)
 		kgdb_roundup_cpus(flags);
 #endif
 
@@ -1496,7 +1557,6 @@
 	kgdb_post_primary_code(ks->linux_regs, ks->ex_vector, ks->err_code);
 	kgdb_deactivate_sw_breakpoints();
 	kgdb_single_step = 0;
-	kgdb_contthread = current;
 	exception_level = 0;
 
 	/* Talk to debugger with gdbserial protocol */
@@ -1510,7 +1570,14 @@
 	kgdb_info[ks->cpu].task = NULL;
 	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
 
-	if (!kgdb_single_step) {
+#ifdef CONFIG_SMP
+	i = -(ks->kgdb_usethreadid + 2);
+	if ((arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP) &&
+		kgdb_contthread && i != cpu) {
+		atomic_set(&passive_cpu_wait[i], 0);
+	}
+#endif
+	if (!kgdb_single_step && !kgdb_contthread) {
 		for (i = NR_CPUS-1; i >= 0; i--)
 			atomic_set(&passive_cpu_wait[i], 0);
 		/*
@@ -1536,9 +1603,9 @@
 int kgdb_nmicallback(int cpu, void *regs)
 {
 #ifdef CONFIG_SMP
-	if (!atomic_read(&cpu_in_kgdb[cpu]) &&
+	if (!atomic_read(&cpu_in_kgdb[cpu]) && (kgdb_contthread ||
 			atomic_read(&kgdb_active) != cpu &&
-			atomic_read(&cpu_in_kgdb[atomic_read(&kgdb_active)])) {
+			atomic_read(&cpu_in_kgdb[atomic_read(&kgdb_active)]))) {
 		kgdb_wait((struct pt_regs *)regs);
 		return 0;
 	}
-- 
1.6.0


