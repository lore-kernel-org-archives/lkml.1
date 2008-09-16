Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYIPImr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYIPImr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYIPImi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:42:38 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:42225 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYIPImh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:42:37 -0400
X-IronPort-AV: E=Sophos;i="4.32,407,1217822400"; 
   d="scan'208";a="59582416"
Subject: [PATCH] [kgdb]switch master cpu after gdb thread command for SMP
From: sonic zhang <sonic.adi@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       kgdb mailing list <kgdb-bugreport@lists.sourceforge.net>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 16:37:15 +0800
Message-Id: <1221554235.15380.16.camel@eight.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In blackfin SMP architecture, different core has its own L1 SRAM and MMR
 memory, which code running on the other core can't access. In current kgdb
 impelemntation, cpus are represented by thread with minus prefix.

If user wants gdb to switch to the thread of the other cpu, kgdb should:
1. signal current master cpu to enter kgdb_wait
2. release the specific waiting passive cpu
3. exit kgdb exception loop on current master cpu
4. trap the release cpu into kgdb exception loop

The kgdb arch implementation with SMP support should include function
kgdb_roundup_cpu().


Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
---
 include/linux/kgdb.h |   13 +++++++++++++
 kernel/kgdb.c        |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index cb8a3d6..5bbfdae 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -203,6 +203,19 @@ kgdb_arch_handle_exception(int vector, int signo, int err_code,
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
index aae578e..852370f 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -566,6 +566,7 @@ static void kgdb_wait(struct pt_regs *regs)
 {
 	unsigned long flags;
 	int cpu;
+	struct task_struct *thread;
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
@@ -585,6 +586,15 @@ static void kgdb_wait(struct pt_regs *regs)
 	kgdb_info[cpu].debuggerinfo = NULL;
 	kgdb_info[cpu].task = NULL;
 
+	/* Trap into kgdb as the active CPU if gdb asks to switch. */
+	thread = getthread(regs, -raw_smp_processor_id() - 2);
+	if (kgdb_usethread && kgdb_usethread == thread) {
+		kgdb_breakpoint();
+		clocksource_touch_watchdog();
+		local_irq_restore(flags);
+		return;
+	}
+ 
 	/* fix up hardware debug registers on local cpu */
 	if (arch_kgdb_ops.correct_hw_break)
 		arch_kgdb_ops.correct_hw_break();
@@ -1072,7 +1082,7 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 }
 
 /* Handle the 'H' task query packets */
-static void gdb_cmd_task(struct kgdb_state *ks)
+static int gdb_cmd_task(struct kgdb_state *ks)
 {
 	struct task_struct *thread;
 	char *ptr;
@@ -1089,6 +1099,13 @@ static void gdb_cmd_task(struct kgdb_state *ks)
 		kgdb_usethread = thread;
 		ks->kgdb_usethreadid = ks->threadid;
 		strcpy(remcom_out_buffer, "OK");
+#ifdef CONFIG_SMP
+		if (ks->kgdb_usethreadid < -1 &&
+			ks->kgdb_usethreadid + 2 != -raw_smp_processor_id()) {
+			kgdb_roundup_cpu(-ks->kgdb_usethreadid - 2);
+			return 1;
+		}
+#endif
 		break;
 	case 'c':
 		ptr = &remcom_in_buffer[2];
@@ -1106,6 +1123,8 @@ static void gdb_cmd_task(struct kgdb_state *ks)
 		strcpy(remcom_out_buffer, "OK");
 		break;
 	}
+
+	return 0;
 }
 
 /* Handle the 'T' thread query packets */
@@ -1284,7 +1303,8 @@ static int gdb_serial_stub(struct kgdb_state *ks)
 			gdb_cmd_query(ks);
 			break;
 		case 'H': /* task related */
-			gdb_cmd_task(ks);
+			if (gdb_cmd_task(ks))
+				goto default_handle;
 			break;
 		case 'T': /* Query thread status */
 			gdb_cmd_thread(ks);
@@ -1509,6 +1529,14 @@ acquirelock:
 	kgdb_info[ks->cpu].task = NULL;
 	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
 
+#ifdef CONFIG_SMP
+	i = -(ks->kgdb_usethreadid + 2);
+	if (ks->kgdb_usethreadid < -1 && i != cpu) {
+		atomic_set(&passive_cpu_wait[i], 0);
+		while (atomic_read(&cpu_in_kgdb[i]))
+			cpu_relax();
+	} else
+#endif
 	if (!kgdb_single_step || !kgdb_contthread) {
 		for (i = NR_CPUS-1; i >= 0; i--)
 			atomic_set(&passive_cpu_wait[i], 0);
-- 
1.6.0


