Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995Ab0AaRcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0AaRcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619Ab0AaRci
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:32:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0AaRcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:32:36 -0500
Date: Sun, 31 Jan 2010 18:32:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100131173221.GA6220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Amerigo Wang (1):
      perf: Ignore perf.data.old

Jason Wessel (2):
      x86, hw_breakpoints, kgdb: Fix kgdb to use hw_breakpoint API
      perf, hw_breakpoint, kgdb: Do not take mutex for kernel debugger

Mahesh Salgaonkar (1):
      hw_breakpoints: Release the bp slot if arch_validate_hwbkpt_settings() fails.

Yong Wang (1):
      perf report: Fix segmentation fault when running with '-g none'


 arch/x86/kernel/kgdb.c        |  222 ++++++++++++++++++++++++++++++-----------
 include/linux/hw_breakpoint.h |    2 +
 kernel/hw_breakpoint.c        |   56 +++++++++--
 kernel/kgdb.c                 |    3 +
 tools/perf/.gitignore         |    1 +
 tools/perf/builtin-report.c   |    2 +-
 6 files changed, 218 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index dd74fe7..bfba601 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -42,6 +42,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
+#include <linux/hw_breakpoint.h>
 
 #include <asm/debugreg.h>
 #include <asm/apicdef.h>
@@ -204,40 +205,81 @@ void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 
 static struct hw_breakpoint {
 	unsigned		enabled;
-	unsigned		type;
-	unsigned		len;
 	unsigned long		addr;
+	int			len;
+	int			type;
+	struct perf_event	**pev;
 } breakinfo[4];
 
 static void kgdb_correct_hw_break(void)
 {
-	unsigned long dr7;
-	int correctit = 0;
-	int breakbit;
 	int breakno;
 
-	get_debugreg(dr7, 7);
 	for (breakno = 0; breakno < 4; breakno++) {
-		breakbit = 2 << (breakno << 1);
-		if (!(dr7 & breakbit) && breakinfo[breakno].enabled) {
-			correctit = 1;
-			dr7 |= breakbit;
-			dr7 &= ~(0xf0000 << (breakno << 2));
-			dr7 |= ((breakinfo[breakno].len << 2) |
-				 breakinfo[breakno].type) <<
-			       ((breakno << 2) + 16);
-			set_debugreg(breakinfo[breakno].addr, breakno);
-
-		} else {
-			if ((dr7 & breakbit) && !breakinfo[breakno].enabled) {
-				correctit = 1;
-				dr7 &= ~breakbit;
-				dr7 &= ~(0xf0000 << (breakno << 2));
-			}
-		}
+		struct perf_event *bp;
+		struct arch_hw_breakpoint *info;
+		int val;
+		int cpu = raw_smp_processor_id();
+		if (!breakinfo[breakno].enabled)
+			continue;
+		bp = *per_cpu_ptr(breakinfo[breakno].pev, cpu);
+		info = counter_arch_bp(bp);
+		if (bp->attr.disabled != 1)
+			continue;
+		bp->attr.bp_addr = breakinfo[breakno].addr;
+		bp->attr.bp_len = breakinfo[breakno].len;
+		bp->attr.bp_type = breakinfo[breakno].type;
+		info->address = breakinfo[breakno].addr;
+		info->len = breakinfo[breakno].len;
+		info->type = breakinfo[breakno].type;
+		val = arch_install_hw_breakpoint(bp);
+		if (!val)
+			bp->attr.disabled = 0;
+	}
+	hw_breakpoint_restore();
+}
+
+static int hw_break_reserve_slot(int breakno)
+{
+	int cpu;
+	int cnt = 0;
+	struct perf_event **pevent;
+
+	for_each_online_cpu(cpu) {
+		cnt++;
+		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
+		if (dbg_reserve_bp_slot(*pevent))
+			goto fail;
+	}
+
+	return 0;
+
+fail:
+	for_each_online_cpu(cpu) {
+		cnt--;
+		if (!cnt)
+			break;
+		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
+		dbg_release_bp_slot(*pevent);
 	}
-	if (correctit)
-		set_debugreg(dr7, 7);
+	return -1;
+}
+
+static int hw_break_release_slot(int breakno)
+{
+	struct perf_event **pevent;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
+		if (dbg_release_bp_slot(*pevent))
+			/*
+			 * The debugger is responisble for handing the retry on
+			 * remove failure.
+			 */
+			return -1;
+	}
+	return 0;
 }
 
 static int
@@ -251,6 +293,10 @@ kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 	if (i == 4)
 		return -1;
 
+	if (hw_break_release_slot(i)) {
+		printk(KERN_ERR "Cannot remove hw breakpoint at %lx\n", addr);
+		return -1;
+	}
 	breakinfo[i].enabled = 0;
 
 	return 0;
@@ -259,15 +305,23 @@ kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 static void kgdb_remove_all_hw_break(void)
 {
 	int i;
+	int cpu = raw_smp_processor_id();
+	struct perf_event *bp;
 
-	for (i = 0; i < 4; i++)
-		memset(&breakinfo[i], 0, sizeof(struct hw_breakpoint));
+	for (i = 0; i < 4; i++) {
+		if (!breakinfo[i].enabled)
+			continue;
+		bp = *per_cpu_ptr(breakinfo[i].pev, cpu);
+		if (bp->attr.disabled == 1)
+			continue;
+		arch_uninstall_hw_breakpoint(bp);
+		bp->attr.disabled = 1;
+	}
 }
 
 static int
 kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 {
-	unsigned type;
 	int i;
 
 	for (i = 0; i < 4; i++)
@@ -278,27 +332,42 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 
 	switch (bptype) {
 	case BP_HARDWARE_BREAKPOINT:
-		type = 0;
-		len  = 1;
+		len = 1;
+		breakinfo[i].type = X86_BREAKPOINT_EXECUTE;
 		break;
 	case BP_WRITE_WATCHPOINT:
-		type = 1;
+		breakinfo[i].type = X86_BREAKPOINT_WRITE;
 		break;
 	case BP_ACCESS_WATCHPOINT:
-		type = 3;
+		breakinfo[i].type = X86_BREAKPOINT_RW;
 		break;
 	default:
 		return -1;
 	}
-
-	if (len == 1 || len == 2 || len == 4)
-		breakinfo[i].len  = len - 1;
-	else
+	switch (len) {
+	case 1:
+		breakinfo[i].len = X86_BREAKPOINT_LEN_1;
+		break;
+	case 2:
+		breakinfo[i].len = X86_BREAKPOINT_LEN_2;
+		break;
+	case 4:
+		breakinfo[i].len = X86_BREAKPOINT_LEN_4;
+		break;
+#ifdef CONFIG_X86_64
+	case 8:
+		breakinfo[i].len = X86_BREAKPOINT_LEN_8;
+		break;
+#endif
+	default:
 		return -1;
-
-	breakinfo[i].enabled = 1;
+	}
 	breakinfo[i].addr = addr;
-	breakinfo[i].type = type;
+	if (hw_break_reserve_slot(i)) {
+		breakinfo[i].addr = 0;
+		return -1;
+	}
+	breakinfo[i].enabled = 1;
 
 	return 0;
 }
@@ -313,8 +382,21 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
  */
 void kgdb_disable_hw_debug(struct pt_regs *regs)
 {
+	int i;
+	int cpu = raw_smp_processor_id();
+	struct perf_event *bp;
+
 	/* Disable hardware debugging while we are in kgdb: */
 	set_debugreg(0UL, 7);
+	for (i = 0; i < 4; i++) {
+		if (!breakinfo[i].enabled)
+			continue;
+		bp = *per_cpu_ptr(breakinfo[i].pev, cpu);
+		if (bp->attr.disabled == 1)
+			continue;
+		arch_uninstall_hw_breakpoint(bp);
+		bp->attr.disabled = 1;
+	}
 }
 
 /**
@@ -378,7 +460,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 			       struct pt_regs *linux_regs)
 {
 	unsigned long addr;
-	unsigned long dr6;
 	char *ptr;
 	int newPC;
 
@@ -404,20 +485,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 				   raw_smp_processor_id());
 		}
 
-		get_debugreg(dr6, 6);
-		if (!(dr6 & 0x4000)) {
-			int breakno;
-
-			for (breakno = 0; breakno < 4; breakno++) {
-				if (dr6 & (1 << breakno) &&
-				    breakinfo[breakno].type == 0) {
-					/* Set restore flag: */
-					linux_regs->flags |= X86_EFLAGS_RF;
-					break;
-				}
-			}
-		}
-		set_debugreg(0UL, 6);
 		kgdb_correct_hw_break();
 
 		return 0;
@@ -485,8 +552,7 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 		break;
 
 	case DIE_DEBUG:
-		if (atomic_read(&kgdb_cpu_doing_single_step) ==
-		    raw_smp_processor_id()) {
+		if (atomic_read(&kgdb_cpu_doing_single_step) != -1) {
 			if (user_mode(regs))
 				return single_step_cont(regs, args);
 			break;
@@ -539,7 +605,42 @@ static struct notifier_block kgdb_notifier = {
  */
 int kgdb_arch_init(void)
 {
-	return register_die_notifier(&kgdb_notifier);
+	int i, cpu;
+	int ret;
+	struct perf_event_attr attr;
+	struct perf_event **pevent;
+
+	ret = register_die_notifier(&kgdb_notifier);
+	if (ret != 0)
+		return ret;
+	/*
+	 * Pre-allocate the hw breakpoint structions in the non-atomic
+	 * portion of kgdb because this operation requires mutexs to
+	 * complete.
+	 */
+	attr.bp_addr = (unsigned long)kgdb_arch_init;
+	attr.type = PERF_TYPE_BREAKPOINT;
+	attr.bp_len = HW_BREAKPOINT_LEN_1;
+	attr.bp_type = HW_BREAKPOINT_W;
+	attr.disabled = 1;
+	for (i = 0; i < 4; i++) {
+		breakinfo[i].pev = register_wide_hw_breakpoint(&attr, NULL);
+		if (IS_ERR(breakinfo[i].pev)) {
+			printk(KERN_ERR "kgdb: Could not allocate hw breakpoints\n");
+			breakinfo[i].pev = NULL;
+			kgdb_arch_exit();
+			return -1;
+		}
+		for_each_online_cpu(cpu) {
+			pevent = per_cpu_ptr(breakinfo[i].pev, cpu);
+			pevent[0]->hw.sample_period = 1;
+			if (pevent[0]->destroy != NULL) {
+				pevent[0]->destroy = NULL;
+				release_bp_slot(*pevent);
+			}
+		}
+	}
+	return ret;
 }
 
 /**
@@ -550,6 +651,13 @@ int kgdb_arch_init(void)
  */
 void kgdb_arch_exit(void)
 {
+	int i;
+	for (i = 0; i < 4; i++) {
+		if (breakinfo[i].pev) {
+			unregister_wide_hw_breakpoint(breakinfo[i].pev);
+			breakinfo[i].pev = NULL;
+		}
+	}
 	unregister_die_notifier(&kgdb_notifier);
 }
 
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 41235c9..070ba06 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -75,6 +75,8 @@ extern int __register_perf_hw_breakpoint(struct perf_event *bp);
 extern void unregister_hw_breakpoint(struct perf_event *bp);
 extern void unregister_wide_hw_breakpoint(struct perf_event **cpu_events);
 
+extern int dbg_reserve_bp_slot(struct perf_event *bp);
+extern int dbg_release_bp_slot(struct perf_event *bp);
 extern int reserve_bp_slot(struct perf_event *bp);
 extern void release_bp_slot(struct perf_event *bp);
 
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 50dbd59..8a5c7d5 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -243,38 +243,70 @@ static void toggle_bp_slot(struct perf_event *bp, bool enable)
  *       ((per_cpu(nr_bp_flexible, *) > 1) + max(per_cpu(nr_cpu_bp_pinned, *))
  *            + max(per_cpu(nr_task_bp_pinned, *))) < HBP_NUM
  */
-int reserve_bp_slot(struct perf_event *bp)
+static int __reserve_bp_slot(struct perf_event *bp)
 {
 	struct bp_busy_slots slots = {0};
-	int ret = 0;
-
-	mutex_lock(&nr_bp_mutex);
 
 	fetch_bp_busy_slots(&slots, bp);
 
 	/* Flexible counters need to keep at least one slot */
-	if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
-		ret = -ENOSPC;
-		goto end;
-	}
+	if (slots.pinned + (!!slots.flexible) == HBP_NUM)
+		return -ENOSPC;
 
 	toggle_bp_slot(bp, true);
 
-end:
+	return 0;
+}
+
+int reserve_bp_slot(struct perf_event *bp)
+{
+	int ret;
+
+	mutex_lock(&nr_bp_mutex);
+
+	ret = __reserve_bp_slot(bp);
+
 	mutex_unlock(&nr_bp_mutex);
 
 	return ret;
 }
 
+static void __release_bp_slot(struct perf_event *bp)
+{
+	toggle_bp_slot(bp, false);
+}
+
 void release_bp_slot(struct perf_event *bp)
 {
 	mutex_lock(&nr_bp_mutex);
 
-	toggle_bp_slot(bp, false);
+	__release_bp_slot(bp);
 
 	mutex_unlock(&nr_bp_mutex);
 }
 
+/*
+ * Allow the kernel debugger to reserve breakpoint slots without
+ * taking a lock using the dbg_* variant of for the reserve and
+ * release breakpoint slots.
+ */
+int dbg_reserve_bp_slot(struct perf_event *bp)
+{
+	if (mutex_is_locked(&nr_bp_mutex))
+		return -1;
+
+	return __reserve_bp_slot(bp);
+}
+
+int dbg_release_bp_slot(struct perf_event *bp)
+{
+	if (mutex_is_locked(&nr_bp_mutex))
+		return -1;
+
+	__release_bp_slot(bp);
+
+	return 0;
+}
 
 int register_perf_hw_breakpoint(struct perf_event *bp)
 {
@@ -296,6 +328,10 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
 	if (!bp->attr.disabled || !bp->overflow_handler)
 		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
 
+	/* if arch_validate_hwbkpt_settings() fails then release bp slot */
+	if (ret)
+		release_bp_slot(bp);
+
 	return ret;
 }
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 2eb517e..c7ade62 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -583,6 +583,9 @@ static void kgdb_wait(struct pt_regs *regs)
 	smp_wmb();
 	atomic_set(&cpu_in_kgdb[cpu], 1);
 
+	/* Disable any cpu specific hw breakpoints */
+	kgdb_disable_hw_debug(regs);
+
 	/* Wait till primary CPU is done with debugging */
 	while (atomic_read(&passive_cpu_wait[cpu]))
 		cpu_relax();
diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index fe08660..124760b 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -13,6 +13,7 @@ perf*.xml
 perf*.html
 common-cmds.h
 perf.data
+perf.data.old
 tags
 TAGS
 cscope*
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index db10c0e..860f1ee 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -269,7 +269,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 
 	else if (!strncmp(tok, "none", strlen(arg))) {
 		callchain_param.mode = CHAIN_NONE;
-		symbol_conf.use_callchain = true;
+		symbol_conf.use_callchain = false;
 
 		return 0;
 	}
