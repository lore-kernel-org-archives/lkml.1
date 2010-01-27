Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347Ab0A0Wc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0A0Wc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864Ab0A0Wc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:32:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:55869 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab0A0Wc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:32:26 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/3] perf,hw_breakpoint,kgdb: No mutex taken for kernel debugger
Date: Wed, 27 Jan 2010 16:25:24 -0600
Message-Id: <1264631124-4837-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com>
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 27 Jan 2010 22:26:27.0782 (UTC) FILETIME=[C470BE60:01CA9F9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel debugger cannot use any mutex_lock() calls because it can
start the kernel running from an invalid context.

The possibility for a breakpoint reservation to be concurrently
processed at the time that kgdb interrupts the system is improbable.
As a safety check against this condition the kernel debugger will
prohibit updating the hardware breakpoint reservations and an error
will be returned to the end user.

Any time the kernel debugger reserves a hardware breakpoint it will be
a system wide reservation.

CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: K.Prasad <prasad@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c        |   49 +++++++++++++++++++++++++++++++++++++-
 include/linux/hw_breakpoint.h |    2 +
 kernel/hw_breakpoint.c        |   52 +++++++++++++++++++++++++++++++++--------
 3 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 9f47cd3..7c3e929 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -239,6 +239,45 @@ static void kgdb_correct_hw_break(void)
 	hw_breakpoint_restore();
 }
 
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
+	}
+	return -1;
+}
+
+static int hw_break_release_slot(int breakno)
+{
+	struct perf_event **pevent;
+	int ret;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
+		ret = dbg_release_bp_slot(*pevent);
+	}
+	return ret;
+}
+
 static int
 kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 {
@@ -250,6 +289,10 @@ kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 	if (i == 4)
 		return -1;
 
+	if (hw_break_release_slot(i)) {
+		printk(KERN_ERR "Cannot remove hw breakpoint at %lx\n", addr);
+		return -1;
+	}
 	breakinfo[i].enabled = 0;
 
 	return 0;
@@ -313,9 +356,13 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 		break;
 #endif
 	default:
-	return -1;
+		return -1;
 	}
 	breakinfo[i].addr = addr;
+	if (hw_break_reserve_slot(i)) {
+		breakinfo[i].addr = 0;
+		return -1;
+	}
 	breakinfo[i].enabled = 1;
 
 	return 0;
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
index 50dbd59..e5aa380 100644
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
-- 
1.6.4.rc1

