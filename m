Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185Ab0AaGkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab0AaGkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 01:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912Ab0AaGko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 01:40:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:52301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab0AaGkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 01:40:43 -0500
Date: Sun, 31 Jan 2010 06:39:55 GMT
From: tip-bot for Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, jason.wessel@windriver.com,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, jason.wessel@windriver.com,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1264719883-7285-3-git-send-email-jason.wessel@windriver.com>
References: <1264719883-7285-3-git-send-email-jason.wessel@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, hw_breakpoint, kgdb: Do not take mutex for kernel debugger
Message-ID: <tip-5352ae638e2d7d5c9b2e4d528676bbf2af6fd6f3@git.kernel.org>
Git-Commit-ID: 5352ae638e2d7d5c9b2e4d528676bbf2af6fd6f3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Jan 2010 06:39:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5352ae638e2d7d5c9b2e4d528676bbf2af6fd6f3
Gitweb:     http://git.kernel.org/tip/5352ae638e2d7d5c9b2e4d528676bbf2af6fd6f3
Author:     Jason Wessel <jason.wessel@windriver.com>
AuthorDate: Thu, 28 Jan 2010 17:04:43 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 30 Jan 2010 08:42:21 +0100

perf, hw_breakpoint, kgdb: Do not take mutex for kernel debugger

This patch fixes the regression in functionality where the
kernel debugger and the perf API do not nicely share hw
breakpoint reservations.

The kernel debugger cannot use any mutex_lock() calls because it
can start the kernel running from an invalid context.

A mutex free version of the reservation API needed to get
created for the kernel debugger to safely update hw breakpoint
reservations.

The possibility for a breakpoint reservation to be concurrently
processed at the time that kgdb interrupts the system is
improbable. Should this corner case occur the end user is
warned, and the kernel debugger will prohibit updating the
hardware breakpoint reservations.

Any time the kernel debugger reserves a hardware breakpoint it
will be a system wide reservation.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: kgdb-bugreport@lists.sourceforge.net
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: torvalds@linux-foundation.org
LKML-Reference: <1264719883-7285-3-git-send-email-jason.wessel@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kgdb.c        |   51 ++++++++++++++++++++++++++++++++++++++++
 include/linux/hw_breakpoint.h |    2 +
 kernel/hw_breakpoint.c        |   52 +++++++++++++++++++++++++++++++++--------
 3 files changed, 95 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 62bea73..bfba601 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -239,6 +239,49 @@ static void kgdb_correct_hw_break(void)
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
+}
+
 static int
 kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 {
@@ -250,6 +293,10 @@ kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 	if (i == 4)
 		return -1;
 
+	if (hw_break_release_slot(i)) {
+		printk(KERN_ERR "Cannot remove hw breakpoint at %lx\n", addr);
+		return -1;
+	}
 	breakinfo[i].enabled = 0;
 
 	return 0;
@@ -316,6 +363,10 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 		return -1;
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
index c030ae6..8a5c7d5 100644
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
