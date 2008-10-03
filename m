Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYJCVSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYJCVSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYJCVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:17:44 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:22718 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYJCVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:17:43 -0400
Date: Fri, 3 Oct 2008 23:17:11 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Resend: [PATCH 7/9] traps: x86: various noop-changes preparing for unification of traps_xx.c
Message-ID: <20081003211711.GB1690@mailshack.com>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Fri, 03 Oct 2008 23:17:31 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - reordering include files
 - whitespace changes
 - comment changes
 - removed unused bad_intr()
 - make default_do_nmi static

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   30 ++++++++++---------
 arch/x86/kernel/traps_64.c |   66 ++++++++++++++++++++++++++++----------------
 include/asm-x86/nmi.h      |    4 --
 3 files changed, 58 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index adc70ee..d994e92 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -7,13 +7,11 @@
  */
 
 /*
- * 'Traps.c' handles hardware traps and faults after we have saved some
- * state in 'asm.s'.
+ * Handle hardware traps and faults.
  */
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 #include <linux/spinlock.h>
-#include <linux/highmem.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/utsname.h>
@@ -32,6 +30,8 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/io.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -46,23 +46,25 @@
 #include <linux/edac.h>
 #endif
 
-#include <asm/processor-flags.h>
-#include <asm/arch_hooks.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
+#include <asm/kmemcheck.h>
 #include <asm/debugreg.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/unwind.h>
+#include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
+
+#include <mach_traps.h>
+
+#include <asm/processor-flags.h>
+#include <asm/arch_hooks.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/io.h>
-#include <asm/traps.h>
-#include <asm/kmemcheck.h>
 
-#include "mach_traps.h"
 #include "cpu/mcheck/mce.h"
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
@@ -341,7 +343,8 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
+	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
+			NOTIFY_STOP)
 		return;
 #ifdef CONFIG_MCA
 	/*
@@ -447,13 +450,9 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
-	int cpu;
-
 	nmi_enter();
 
-	cpu = smp_processor_id();
-
-	++nmi_count(cpu);
+	{ int cpu; cpu = smp_processor_id(); ++nmi_count(cpu); }
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
@@ -473,6 +472,7 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
+/* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_KPROBES
@@ -511,6 +511,8 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
  * about restoring all the debug state, and ptrace doesn't have to
  * find every occurrence of the TF bit that could be saved away even
  * by user code)
+ *
+ * May run on IST stack.
  */
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 59dcee1..334a3df 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -7,10 +7,8 @@
  */
 
 /*
- * 'Traps.c' handles hardware traps and faults after we have saved some
- * state in 'entry.S'.
+ * Handle hardware traps and faults.
  */
-#include <linux/moduleparam.h>
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 #include <linux/spinlock.h>
@@ -41,19 +39,21 @@
 
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
+#include <asm/kmemcheck.h>
 #include <asm/debugreg.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/unwind.h>
+#include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
-#include <asm/kmemcheck.h>
+
+#include <mach_traps.h>
+
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pda.h>
-#include <asm/traps.h>
 
-#include <mach_traps.h>
 
 static int ignore_nmis;
 
@@ -74,8 +74,6 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_disable();
-	/* Make sure to not schedule here because we could be running
-	   on an exception stack. */
 	dec_preempt_count();
 }
 
@@ -229,9 +227,12 @@ gp_in_kernel:
 static notrace __kprobes void
 mem_parity_error(unsigned char reason, struct pt_regs *regs)
 {
-	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
-		reason);
-	printk(KERN_EMERG "You have some hardware problem, likely on the PCI bus.\n");
+	printk(KERN_EMERG
+		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
+			reason, smp_processor_id());
+
+	printk(KERN_EMERG
+		"You have some hardware problem, likely on the PCI bus.\n");
 
 #if defined(CONFIG_EDAC)
 	if (edac_handler_set()) {
@@ -276,19 +277,18 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
 			NOTIFY_STOP)
 		return;
-	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
-		reason);
-	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
+	printk(KERN_EMERG
+		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
+			reason, smp_processor_id());
 
+	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
 	if (panic_on_unrecovered_nmi)
 		panic("NMI: Not continuing");
 
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
 
-/* Runs on IST stack. This code must keep interrupts off all the time.
-   Nested NMIs are prevented by the CPU. */
-asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int cpu;
@@ -349,7 +349,7 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
-/* runs on IST stack. */
+/* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
@@ -382,7 +382,30 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 	return regs;
 }
 
-/* runs on IST stack. */
+/*
+ * Our handling of the processor debug registers is non-trivial.
+ * We do not clear them on entry and exit from the kernel. Therefore
+ * it is possible to get a watchpoint trap here from inside the kernel.
+ * However, the code in ./ptrace.c has ensured that the user can
+ * only set watchpoints on userspace addresses. Therefore the in-kernel
+ * watchpoint trap can only occur in code which is reading/writing
+ * from user space. Such code must not hold kernel locks (since it
+ * can equally take a page fault), therefore it is safe to call
+ * force_sig_info even though that claims and releases locks.
+ *
+ * Code in ./signal.c ensures that the debug control register
+ * is restored before we deliver any signal, and therefore that
+ * user code runs with the correct debug control register even though
+ * we clear it here.
+ *
+ * Being careful here means that we don't have to be as careful in a
+ * lot of more complicated places (task switching can be a bit lazy
+ * about restoring all the debug state, and ptrace doesn't have to
+ * find every occurrence of the TF bit that could be saved away even
+ * by user code)
+ *
+ * May run on IST stack.
+ */
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
@@ -530,11 +553,6 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 	math_error((void __user *)regs->ip);
 }
 
-asmlinkage void bad_intr(void)
-{
-	printk("bad interrupt");
-}
-
 static void simd_math_error(void __user *ip)
 {
 	struct task_struct *task;
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index d5e715f..a53f829 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -15,10 +15,6 @@
  */
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
-#ifdef CONFIG_X86_64
-extern void default_do_nmi(struct pt_regs *);
-#endif
-
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
-- 
1.5.4.3

