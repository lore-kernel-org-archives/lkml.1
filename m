Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581Ab0AZE2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0AZE2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513Ab0AZE1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:27:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:64466 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab0AZE1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:27:23 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/4] perf,hw_breakpoint: add lockless reservation for hw_breaks
Date: Mon, 25 Jan 2010 22:26:38 -0600
Message-Id: <1264480000-6997-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 26 Jan 2010 04:26:46.0427 (UTC) FILETIME=[C554AEB0:01CA9E3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel debugger cannot take any locks at the risk of deadlocking
the system.  This patch implements a simple reservation system using
an atomic variable initialized to the maximum number of system wide
breakpoints.  Any time the variable is negative, there are no
remaining unreserved hw breakpoint slots.

The perf hw breakpoint API needs to keep the account correct for the
number of system wide breakpoints available at any given time.  The
kernel debugger will use the same reservation semantics, but use the
low level API calls to install and remove breakpoints while general
kernel execution is paused.

CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: K.Prasad <prasad@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c     |   12 +++++++++---
 include/linux/perf_event.h |    1 +
 kernel/hw_breakpoint.c     |   16 ++++++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 3cb2828..2a31f35 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -251,6 +251,7 @@ kgdb_remove_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 		return -1;
 
 	breakinfo[i].enabled = 0;
+	atomic_inc(&dbg_slots_pinned);
 
 	return 0;
 }
@@ -277,11 +278,13 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 {
 	int i;
 
+	if (atomic_add_negative(-1, &dbg_slots_pinned))
+		goto err_out;
 	for (i = 0; i < 4; i++)
 		if (!breakinfo[i].enabled)
 			break;
 	if (i == 4)
-		return -1;
+		goto err_out;
 
 	switch (bptype) {
 	case BP_HARDWARE_BREAKPOINT:
@@ -295,7 +298,7 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 		breakinfo[i].type = X86_BREAKPOINT_RW;
 		break;
 	default:
-		return -1;
+		goto err_out;
 	}
 	switch (len) {
 	case 1:
@@ -313,12 +316,15 @@ kgdb_set_hw_break(unsigned long addr, int len, enum kgdb_bptype bptype)
 		break;
 #endif
 	default:
-	return -1;
+		goto err_out;
 	}
 	breakinfo[i].addr = addr;
 	breakinfo[i].enabled = 1;
 
 	return 0;
+err_out:
+	atomic_inc(&dbg_slots_pinned);
+	return -1;
 }
 
 /**
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8fa7187..71f3f05 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -825,6 +825,7 @@ static inline int is_software_event(struct perf_event *event)
 }
 
 extern atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
+extern atomic_t dbg_slots_pinned;
 
 extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 50dbd59..ddf7951 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -55,6 +55,9 @@ static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned);
 /* Number of pinned task breakpoints in a cpu */
 static DEFINE_PER_CPU(unsigned int, nr_task_bp_pinned[HBP_NUM]);
 
+/* Slots pinned atomically by the debugger */
+atomic_t dbg_slots_pinned = ATOMIC_INIT(HBP_NUM);
+
 /* Number of non-pinned cpu/task breakpoints in a cpu */
 static DEFINE_PER_CPU(unsigned int, nr_bp_flexible);
 
@@ -249,12 +252,24 @@ int reserve_bp_slot(struct perf_event *bp)
 	int ret = 0;
 
 	mutex_lock(&nr_bp_mutex);
+	/*
+	 * Grab a dbg_slots_pinned allocation.  This atomic variable
+	 * allows lockless sharing between the kernel debugger and the
+	 * perf hw breakpoints.  It represents the total number of
+	 * available system wide breakpoints.
+	 */
+	if (atomic_add_negative(-1, &dbg_slots_pinned)) {
+		atomic_inc(&dbg_slots_pinned);
+		ret = -ENOSPC;
+		goto end;
+	}
 
 	fetch_bp_busy_slots(&slots, bp);
 
 	/* Flexible counters need to keep at least one slot */
 	if (slots.pinned + (!!slots.flexible) == HBP_NUM) {
 		ret = -ENOSPC;
+		atomic_inc(&dbg_slots_pinned);
 		goto end;
 	}
 
@@ -271,6 +286,7 @@ void release_bp_slot(struct perf_event *bp)
 	mutex_lock(&nr_bp_mutex);
 
 	toggle_bp_slot(bp, false);
+	atomic_inc(&dbg_slots_pinned);
 
 	mutex_unlock(&nr_bp_mutex);
 }
-- 
1.6.3.3

