Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbZFWKEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbZFWKEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZFWKEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:04:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:33661 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbZFWKES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:04:18 -0400
Date: Tue, 23 Jun 2009 10:03:47 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: acme@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulus@samba.org, acme@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Optimize perf_swcounter_event()
Message-ID: <tip-f29ac756a40d0f1bb07d682ea521e7b666ff06d5@git.kernel.org>
Git-Commit-ID: f29ac756a40d0f1bb07d682ea521e7b666ff06d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 10:03:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f29ac756a40d0f1bb07d682ea521e7b666ff06d5
Gitweb:     http://git.kernel.org/tip/f29ac756a40d0f1bb07d682ea521e7b666ff06d5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 19 Jun 2009 18:27:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 11:42:44 +0200

perf_counter: Optimize perf_swcounter_event()

Similar to tracepoints, use an enable variable to reduce
overhead when unused.

Only look for a counter of a particular event type when we know
there is at least one in the system.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   11 ++++++++++-
 kernel/perf_counter.c        |   18 +++++++++++++++---
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 89698d8..e7213e4 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -669,7 +669,16 @@ static inline int is_software_counter(struct perf_counter *counter)
 		(counter->attr.type != PERF_TYPE_HW_CACHE);
 }
 
-extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
+extern atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
+
+extern void __perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
+
+static inline void
+perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+{
+	if (atomic_read(&perf_swcounter_enabled[event]))
+		__perf_swcounter_event(event, nr, nmi, regs, addr);
+}
 
 extern void __perf_counter_mmap(struct vm_area_struct *vma);
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 1a933a2..7515c76 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3317,8 +3317,8 @@ out:
 	put_cpu_var(perf_cpu_context);
 }
 
-void
-perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+void __perf_swcounter_event(u32 event, u64 nr, int nmi,
+			    struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data = {
 		.regs = regs,
@@ -3509,9 +3509,19 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 }
 #endif
 
+atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
+
+static void sw_perf_counter_destroy(struct perf_counter *counter)
+{
+	u64 event = counter->attr.config;
+
+	atomic_dec(&perf_swcounter_enabled[event]);
+}
+
 static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 {
 	const struct pmu *pmu = NULL;
+	u64 event = counter->attr.config;
 
 	/*
 	 * Software counters (currently) can't in general distinguish
@@ -3520,7 +3530,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (counter->attr.config) {
+	switch (event) {
 	case PERF_COUNT_SW_CPU_CLOCK:
 		pmu = &perf_ops_cpu_clock;
 
@@ -3541,6 +3551,8 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
+		atomic_inc(&perf_swcounter_enabled[event]);
+		counter->destroy = sw_perf_counter_destroy;
 		pmu = &perf_ops_generic;
 		break;
 	}
