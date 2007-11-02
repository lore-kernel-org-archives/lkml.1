Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXKBL32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXKBL32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 07:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbXKBL3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 07:29:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40567 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbXKBL3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:29:19 -0400
Subject: [git pull] lockdep for v2.6.24-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 12:29:12 +0100
Message-Id: <1194002952.27652.356.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2a397e82c7db18019e408f953dd58dc1963a328c:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../bart/ide-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.24-rc1-lockdep

Gautham R Shenoy (1):
      lockdep: fix a typo in the __lock_acquire comment

Peter Zijlstra (2):
      lockdep: fixup irq tracing
      sched: fix unconditional irq lock

 arch/x86/kernel/kprobes_32.c  |    7 +------
 arch/x86/kernel/kprobes_64.c  |    7 +------
 arch/x86/kernel/traps_32.c    |    2 ++
 arch/x86/kernel/traps_64.c    |    2 ++
 arch/x86/mm/fault_32.c        |    5 +++++
 arch/x86/mm/fault_64.c        |    5 +++++
 include/asm-x86/irqflags_32.h |   21 +++++++++++++++++++++
 include/asm-x86/irqflags_64.h |   20 ++++++++++++++++++++
 kernel/lockdep.c              |    2 +-
 kernel/sched_debug.c          |    5 +++--
 10 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 90f778c..d87a523 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -564,12 +564,7 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 
 	resume_execution(cur, regs, kcb);
 	regs->eflags |= kcb->kprobe_saved_eflags;
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
-	if (raw_irqs_disabled_flags(regs->eflags))
-		trace_hardirqs_off();
-	else
-		trace_hardirqs_on();
-#endif
+	trace_hardirqs_fixup_flags(regs->eflags);
 
 	/*Restore back the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 681b801..3db3611 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -551,12 +551,7 @@ int __kprobes post_kprobe_handler(struct pt_regs *regs)
 
 	resume_execution(cur, regs, kcb);
 	regs->eflags |= kcb->kprobe_saved_rflags;
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
-	if (raw_irqs_disabled_flags(regs->eflags))
-		trace_hardirqs_off();
-	else
-		trace_hardirqs_on();
-#endif
+	trace_hardirqs_fixup_flags(regs->eflags);
 
 	/* Restore the original saved kprobes variables and continue. */
 	if (kcb->kprobe_status == KPROBE_REENTER) {
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index cc9acac..298d13e 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -789,6 +789,8 @@ void restart_nmi(void)
 #ifdef CONFIG_KPROBES
 fastcall void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
+	trace_hardirqs_fixup();
+
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index d0c2bc7..4a6bd49 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -807,6 +807,8 @@ asmlinkage __kprobes void default_do_nmi(struct pt_regs *regs)
 /* runs on IST stack. */
 asmlinkage void __kprobes do_int3(struct pt_regs * regs, long error_code)
 {
+	trace_hardirqs_fixup();
+
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP) == NOTIFY_STOP) {
 		return;
 	}
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 503dfc0..2e542e8 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -303,6 +303,11 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 	int write, si_code;
 	int fault;
 
+	/*
+	 * We can fault from pretty much anywhere, with unknown IRQ state.
+	 */
+	trace_hardirqs_fixup();
+
 	/* get the address */
         address = read_cr2();
 
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 644b4f7..0e26230 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -304,6 +304,11 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	unsigned long flags;
 	siginfo_t info;
 
+	/*
+	 * We can fault from pretty much anywhere, with unknown IRQ state.
+	 */
+	trace_hardirqs_fixup();
+
 	tsk = current;
 	mm = tsk->mm;
 	prefetchw(&mm->mmap_sem);
diff --git a/include/asm-x86/irqflags_32.h b/include/asm-x86/irqflags_32.h
index d058b04..4c77200 100644
--- a/include/asm-x86/irqflags_32.h
+++ b/include/asm-x86/irqflags_32.h
@@ -129,6 +129,27 @@ static inline int raw_irqs_disabled(void)
 
 	return raw_irqs_disabled_flags(flags);
 }
+
+/*
+ * makes the traced hardirq state match with the machine state
+ *
+ * should be a rarely used function, only in places where its
+ * otherwise impossible to know the irq state, like in traps.
+ */
+static inline void trace_hardirqs_fixup_flags(unsigned long flags)
+{
+	if (raw_irqs_disabled_flags(flags))
+		trace_hardirqs_off();
+	else
+		trace_hardirqs_on();
+}
+
+static inline void trace_hardirqs_fixup(void)
+{
+	unsigned long flags = __raw_local_save_flags();
+
+	trace_hardirqs_fixup_flags(flags);
+}
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-x86/irqflags_64.h b/include/asm-x86/irqflags_64.h
index 5341ea1..bb9163b 100644
--- a/include/asm-x86/irqflags_64.h
+++ b/include/asm-x86/irqflags_64.h
@@ -112,6 +112,26 @@ static inline int raw_irqs_disabled(void)
 }
 
 /*
+ * makes the traced hardirq state match with the machine state
+ *
+ * should be a rarely used function, only in places where its
+ * otherwise impossible to know the irq state, like in traps.
+ */
+static inline void trace_hardirqs_fixup_flags(unsigned long flags)
+{
+	if (raw_irqs_disabled_flags(flags))
+		trace_hardirqs_off();
+	else
+		trace_hardirqs_on();
+}
+
+static inline void trace_hardirqs_fixup(void)
+{
+	unsigned long flags = __raw_local_save_flags();
+
+	trace_hardirqs_fixup_flags(flags);
+}
+/*
  * Used in the idle loop; sti takes one instruction cycle
  * to complete:
  */
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 55fe0c7..ed38bbf 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2424,7 +2424,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		return 0;
 
 	/*
-	 * Calculate the chain hash: it's the combined has of all the
+	 * Calculate the chain hash: it's the combined hash of all the
 	 * lock keys along the dependency chain. We save the hash value
 	 * at every step so that we can get the current hash easily
 	 * after unlock. The chain hash is then used to cache dependency
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index e6fb392..415e5c3 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -80,6 +80,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 {
 	struct task_struct *g, *p;
+	unsigned long flags;
 
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
@@ -88,7 +89,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	"------------------------------------------------------"
 	"----------------------------------------------------\n");
 
-	read_lock_irq(&tasklist_lock);
+	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, p) {
 		if (!p->se.on_rq || task_cpu(p) != rq_cpu)
@@ -97,7 +98,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 		print_task(m, rq, p);
 	} while_each_thread(g, p);
 
-	read_unlock_irq(&tasklist_lock);
+	read_unlock_irqrestore(&tasklist_lock, flags);
 }
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)


