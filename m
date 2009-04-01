Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbZDAKTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbZDAKTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbZDAKPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:15:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758592AbZDAKPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:15:13 -0400
Date: Wed, 1 Apr 2009 10:14:46 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171024.254266860@chello.nl>
References: <20090330171024.254266860@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: provide generic callchain bits
Message-ID: <tip-1254256f65ce3973462dc153e02b4f3a7e314e20@git.kernel.org>
Git-Commit-ID: 1254256f65ce3973462dc153e02b4f3a7e314e20
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:14:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1254256f65ce3973462dc153e02b4f3a7e314e20
Gitweb:     http://git.kernel.org/tip/1254256f65ce3973462dc153e02b4f3a7e314e20
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Mar 2009 19:07:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:38 +0200

perf_counter: provide generic callchain bits

Provide the generic callchain support bits. If hw_event->callchain is
set the arch specific perf_callchain() function is called upon to
provide a perf_callchain_entry structure filled with the current
callchain.

If it does so, it is added to the overflow output event.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090330171024.254266860@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   13 ++++++++++++-
 kernel/perf_counter.c        |   27 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index edf5bfb..43083af 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -140,8 +140,9 @@ struct perf_counter_hw_event {
 				include_tid    :  1, /* include the tid       */
 				mmap           :  1, /* include mmap data     */
 				munmap         :  1, /* include munmap data   */
+				callchain      :  1, /* add callchain data    */
 
-				__reserved_1   : 52;
+				__reserved_1   : 51;
 
 	__u32			extra_config_len;
 	__u32			__reserved_4;
@@ -219,6 +220,7 @@ enum perf_event_type {
 	PERF_EVENT_OVERFLOW	= 1UL << 31,
 	__PERF_EVENT_IP		= 1UL << 30,
 	__PERF_EVENT_TID	= 1UL << 29,
+	__PERF_EVENT_CALLCHAIN  = 1UL << 28,
 };
 
 #ifdef __KERNEL__
@@ -504,6 +506,15 @@ extern void perf_counter_mmap(unsigned long addr, unsigned long len,
 extern void perf_counter_munmap(unsigned long addr, unsigned long len,
 				unsigned long pgoff, struct file *file);
 
+#define MAX_STACK_DEPTH		255
+
+struct perf_callchain_entry {
+	u64	nr;
+	u64	ip[MAX_STACK_DEPTH];
+};
+
+extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
+
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d93e9dd..860cdc2 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1654,6 +1654,17 @@ void perf_counter_do_pending(void)
 }
 
 /*
+ * Callchain support -- arch specific
+ */
+
+struct perf_callchain_entry *
+__attribute__((weak))
+perf_callchain(struct pt_regs *regs)
+{
+	return NULL;
+}
+
+/*
  * Output
  */
 
@@ -1764,6 +1775,8 @@ static void perf_output_simple(struct perf_counter *counter,
 	struct {
 		u32 pid, tid;
 	} tid_entry;
+	struct perf_callchain_entry *callchain = NULL;
+	int callchain_size = 0;
 
 	header.type = PERF_EVENT_OVERFLOW;
 	header.size = sizeof(header);
@@ -1781,6 +1794,17 @@ static void perf_output_simple(struct perf_counter *counter,
 		header.size += sizeof(tid_entry);
 	}
 
+	if (counter->hw_event.callchain) {
+		callchain = perf_callchain(regs);
+
+		if (callchain) {
+			callchain_size = (1 + callchain->nr) * sizeof(u64);
+
+			header.type |= __PERF_EVENT_CALLCHAIN;
+			header.size += callchain_size;
+		}
+	}
+
 	ret = perf_output_begin(&handle, counter, header.size, nmi);
 	if (ret)
 		return;
@@ -1791,6 +1815,9 @@ static void perf_output_simple(struct perf_counter *counter,
 	if (counter->hw_event.include_tid)
 		perf_output_put(&handle, tid_entry);
 
+	if (callchain)
+		perf_output_copy(&handle, callchain, callchain_size);
+
 	perf_output_end(&handle);
 }
 
