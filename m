Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046Ab0AZTZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0AZTZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709Ab0AZTZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:25:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:40512 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab0AZTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:25:48 -0500
Message-ID: <4B5F419F.2090901@windriver.com>
Date: Tue, 26 Jan 2010 13:25:19 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/4] perf,hw_breakpoint: add lockless reservation for
 hw_breaks
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-3-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1264480000-6997-3-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2010 19:25:13.0748 (UTC) FILETIME=[48991540:01CA9EBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> The kernel debugger cannot take any locks at the risk of deadlocking

[clip]

The previous version of this patch was wrong for 2 reasons:

1) The reserve_slot_bp() can operate on a single cpu or all the cpus.
   The previous version of this patch only worked properly if
   reserve_slot_bp() was operating on all the cpus.

2) If you do not have kgdb in the kernel there is no reason to incur
   any penalty.  If you have CONFIG_KGDB turned off now there is zero
   impact or risk to the current hw_breakpoint code.

Below is the new patch, which now passes all the various regression
combinations.

Thanks,
Jason.

---

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] perf,hw_breakpoint: add lockless reservation for hw_breaks

The kernel debugger cannot take any locks at the risk of deadlocking
the system.  This patch implements a simple reservation system using
a per cpu atomic variable initialized to the maximum number of system
wide breakpoints.  Any time the variable is negative, there are no
remaining unreserved hw breakpoint slots for that cpu.

The availability of a system wide breakpoint that kgdb can make use of
will be determined by calling _dbg_hw_breakpoint_all_alloc().  All the
slot reservation code lives in kernel/hw_breakpoint.c.

The kernel debugger uses common reservation logic, but for activating
and deactivating breakpoints, it will directly but use the low level
API calls provided in the hw_breakpoint API.  This is required in
order perform breakpoint activities without scheduling prior to
resuming general kernel execution.

CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: K.Prasad <prasad@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/x86/kernel/kgdb.c        |    3 +
 include/linux/hw_breakpoint.h |    2 +
 kernel/hw_breakpoint.c        |   82 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -251,6 +251,7 @@ kgdb_remove_hw_break(unsigned long addr,
 		return -1;
 
 	breakinfo[i].enabled = 0;
+	_dbg_hw_breakpoint_all_free();
 
 	return 0;
 }
@@ -277,6 +278,8 @@ kgdb_set_hw_break(unsigned long addr, in
 {
 	int i;
 
+	if (_dbg_hw_breakpoint_all_alloc())
+		return -1;
 	for (i = 0; i < 4; i++)
 		if (!breakinfo[i].enabled)
 			break;
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -202,6 +202,82 @@ static void toggle_bp_slot(struct perf_e
 		per_cpu(nr_cpu_bp_pinned, bp->cpu)--;
 }
 
+#ifdef CONFIG_KGDB
+/* Slots pinned atomically by the debugger */
+static DEFINE_PER_CPU(atomic_t, dbg_slots_pinned) = ATOMIC_INIT(HBP_NUM);
+
+void _dbg_hw_breakpoint_all_free(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		atomic_inc(&per_cpu(dbg_slots_pinned, cpu));
+}
+
+int _dbg_hw_breakpoint_all_alloc(void)
+{
+	int cnt = 0;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		cnt++;
+		if (atomic_add_negative(-1, &per_cpu(dbg_slots_pinned, cpu))) {
+			for_each_online_cpu(cpu) {
+				cnt--;
+				atomic_inc(&per_cpu(dbg_slots_pinned, cpu));
+				if (!cnt)
+					break;
+			}
+			return -ENOSPC;
+		}
+	}
+
+	return 0;
+}
+
+static int dbg_hw_breakpoint_alloc(int cpu)
+{
+	int ret = 0;
+	/*
+	 * Grab a dbg_slots_pinned allocation.  This atomic variable
+	 * allows lockless sharing between the kernel debugger and the
+	 * perf hw breakpoints.  It represents the total number of
+	 * available system wide breakpoints.
+	 */
+	if (cpu >= 0) {
+		if (atomic_add_negative(-1, &per_cpu(dbg_slots_pinned, cpu))) {
+			atomic_inc(&per_cpu(dbg_slots_pinned, cpu));
+			ret = -ENOSPC;
+		}
+	} else {
+		get_online_cpus();
+		ret = _dbg_hw_breakpoint_all_alloc();
+		put_online_cpus();
+	}
+
+	return ret;
+}
+
+static void dbg_hw_breakpoint_free(int cpu)
+{
+	if (cpu >= 0) {
+		atomic_inc(&per_cpu(dbg_slots_pinned, cpu));
+	} else {
+		get_online_cpus();
+		_dbg_hw_breakpoint_all_free();
+		put_online_cpus();
+	}
+}
+#else /* !CONFIG_KGDB */
+static int inline dbg_hw_breakpoint_alloc(int cpu)
+{
+	return 0;
+}
+static void inline dbg_hw_breakpoint_free(int cpu)
+{
+}
+#endif /* !CONFIG_KGDB */
+
 /*
  * Contraints to check before allowing this new breakpoint counter:
  *
@@ -250,11 +326,16 @@ int reserve_bp_slot(struct perf_event *b
 
 	mutex_lock(&nr_bp_mutex);
 
+	ret = dbg_hw_breakpoint_alloc(bp->cpu);
+	if (ret)
+		goto end;
+
 	fetch_bp_busy_slots(&slots, bp);
 
 	/* Flexible counters need to keep at least one slot */
 	if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
 		ret = -ENOSPC;
+		dbg_hw_breakpoint_free(bp->cpu);
 		goto end;
 	}
 
@@ -271,6 +352,7 @@ void release_bp_slot(struct perf_event *
 	mutex_lock(&nr_bp_mutex);
 
 	toggle_bp_slot(bp, false);
+	dbg_hw_breakpoint_free(bp->cpu);
 
 	mutex_unlock(&nr_bp_mutex);
 }
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -77,6 +77,8 @@ extern void unregister_wide_hw_breakpoin
 
 extern int reserve_bp_slot(struct perf_event *bp);
 extern void release_bp_slot(struct perf_event *bp);
+extern int _dbg_hw_breakpoint_all_alloc(void);
+extern void _dbg_hw_breakpoint_all_free(void);
 
 extern void flush_ptrace_hw_breakpoint(struct task_struct *tsk);
 
