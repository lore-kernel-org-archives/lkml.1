Return-Path: <linux-kernel-owner+w=401wt.eu-S1765261AbYBOU63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765261AbYBOU63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763598AbYBOUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:55:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:55919 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763483AbYBOUzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:53 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 7/7] kgdb-light-v10: build core and arch pieces as a kernel module
Date: Fri, 15 Feb 2008 14:55:58 -0600
Message-Id: <1203108958-1818-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203108958-1818-7-git-send-email-jason.wessel@windriver.com>
References: <1203108958-1818-1-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-2-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-3-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-4-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-5-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-6-git-send-email-jason.wessel@windriver.com>
 <1203108958-1818-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 Feb 2008 20:55:40.0797 (UTC) FILETIME=[1FAACAD0:01C87015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

The patch nicely demonstrates what deeper dependencies on kernel
services currently exist in kgdb-light. The following symbols were
unresolvable:

 o send_IPI_allbutself(APIC_DM_NMI)
    This required a new exported function so as not to
    export really low level APIC functions and variables
    The new one is: smp_debugger_sync
 o machine_emergency_restart - for implementing "R0" gdb packet
 o idle_task - kgdb tells the per-cpu idle tasks apart
 o clocksource_touch_watchdog - obvious as to what it does

For simplicity reasons I just gpl-exported all of them. The result is
a fully modular kgdb that may help to reduce concerns regarding its
intrusiveness.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb-x86.c |   11 ++---------
 arch/x86/kernel/reboot.c   |    1 +
 arch/x86/kernel/smp_32.c   |    6 ++++++
 arch/x86/kernel/smp_64.c   |    5 +++++
 include/asm-x86/smp_32.h   |    5 +++++
 include/asm-x86/smp_64.h   |    4 ++++
 kernel/sched.c             |    1 +
 kernel/time/clocksource.c  |    1 +
 lib/Kconfig.kgdb           |    2 +-
 lib/kgdb.c                 |    8 ++++++--
 10 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/kgdb-x86.c b/arch/x86/kernel/kgdb-x86.c
index 88bfa45..c36740c 100644
--- a/arch/x86/kernel/kgdb-x86.c
+++ b/arch/x86/kernel/kgdb-x86.c
@@ -46,12 +46,6 @@
 #include <asm/apicdef.h>
 #include <asm/system.h>
 
-#ifdef CONFIG_X86_32
-# include <mach_ipi.h>
-#else
-# include <asm/mach_apic.h>
-#endif
-
 /*
  * Put the error code here just in case the user cares:
  */
@@ -315,7 +309,6 @@ void kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
 	gdb_x86errcode = err_code;
 }
 
-#ifdef CONFIG_SMP
 /**
  *	kgdb_roundup_cpus - Get other CPUs into a holding pattern
  *	@flags: Current IRQ state
@@ -334,9 +327,8 @@ void kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
  */
 void kgdb_roundup_cpus(unsigned long flags)
 {
-	send_IPI_allbutself(APIC_DM_NMI);
+	smp_debugger_sync();
 }
-#endif
 
 /**
  *	kgdb_arch_handle_exception - Handle architecture specific GDB packets.
@@ -565,3 +557,4 @@ struct kgdb_arch arch_kgdb_ops = {
 	.remove_all_hw_break	= kgdb_remove_all_hw_break,
 	.correct_hw_break	= kgdb_correct_hw_break,
 };
+
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 5818dc2..66d7c27 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -375,6 +375,7 @@ void machine_emergency_restart(void)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(machine_emergency_restart);
 
 void machine_shutdown(void)
 {
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index dc0cde9..2f35238 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -710,3 +710,9 @@ struct smp_ops smp_ops = {
 	.smp_call_function_mask = native_smp_call_function_mask,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
+
+void smp_debugger_sync(void)
+{
+	send_IPI_allbutself(APIC_DM_NMI);
+}
+EXPORT_SYMBOL_GPL(smp_debugger_sync);
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 2fd74b0..f5f419f 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -528,3 +528,8 @@ asmlinkage void smp_call_function_interrupt(void)
 	}
 }
 
+void smp_debugger_sync(void)
+{
+	send_IPI_allbutself(APIC_DM_NMI);
+}
+EXPORT_SYMBOL_GPL(smp_debugger_sync);
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 56152e3..19a1aa7 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -127,11 +127,16 @@ static inline int num_booting_cpus(void)
 	return cpus_weight(cpu_callout_map);
 }
 
+extern void smp_debugger_sync(void);
+
 #else /* CONFIG_SMP */
 
 #define safe_smp_processor_id()		0
 #define cpu_physical_id(cpu)		boot_cpu_physical_apicid
 
+static inline void smp_debugger_sync(void)
+{}
+
 #endif /* !CONFIG_SMP */
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index e0a7551..c52f46a 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -74,6 +74,7 @@ static inline int num_booting_cpus(void)
 }
 
 extern void smp_send_reschedule(int cpu);
+extern void smp_debugger_sync(void);
 
 #else /* CONFIG_SMP */
 
@@ -81,6 +82,9 @@ extern unsigned int boot_cpu_id;
 #define cpu_physical_id(cpu)	boot_cpu_id
 #define stack_smp_processor_id() 0
 
+static inline void smp_debugger_sync(void)
+{}
+
 #endif /* !CONFIG_SMP */
 
 #define safe_smp_processor_id()		smp_processor_id()
diff --git a/kernel/sched.c b/kernel/sched.c
index 3eedd52..e2ffff4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4463,6 +4463,7 @@ struct task_struct *idle_task(int cpu)
 {
 	return cpu_rq(cpu)->idle;
 }
+EXPORT_SYMBOL_GPL(idle_task);
 
 /**
  * find_process_by_pid - find a process with a matching PID value.
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ace23d3..e83dc5d 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -238,6 +238,7 @@ void clocksource_touch_watchdog(void)
 {
 	clocksource_resume_watchdog();
 }
+EXPORT_SYMBOL_GPL(clocksource_touch_watchdog);
 
 /**
  * clocksource_get_next - Returns the selected clocksource
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 9631ba3..413e3b8 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -1,6 +1,6 @@
 
 menuconfig KGDB
-	bool "KGDB: kernel debugging with remote gdb"
+	tristate "KGDB: kernel debugging with remote gdb"
 	select FRAME_POINTER
 	depends on HAVE_ARCH_KGDB
 	depends on DEBUG_KERNEL && EXPERIMENTAL
diff --git a/lib/kgdb.c b/lib/kgdb.c
index a453764..7a39853 100644
--- a/lib/kgdb.c
+++ b/lib/kgdb.c
@@ -91,13 +91,14 @@ static int kgdb_con_registered;
 /* determine if kgdb console output should be used */
 static int kgdb_use_con;
 
+#ifdef CONFIG_KGDB
 static int __init opt_kgdb_con(char *str)
 {
 	kgdb_use_con = 1;
 	return 0;
 }
-
 early_param("kgdbcon", opt_kgdb_con);
+#endif
 
 module_param(kgdb_use_con, int, 0644);
 
@@ -1667,6 +1668,7 @@ void kgdb_breakpoint(void)
 }
 EXPORT_SYMBOL_GPL(kgdb_breakpoint);
 
+#ifdef CONFIG_KGDB
 static int __init opt_kgdb_wait(char *str)
 {
 	kgdb_break_asap = 1;
@@ -1676,5 +1678,7 @@ static int __init opt_kgdb_wait(char *str)
 
 	return 0;
 }
-
 early_param("kgdbwait", opt_kgdb_wait);
+#endif
+
+MODULE_LICENSE("GPL");
-- 
1.5.4

