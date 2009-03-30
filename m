Return-Path: <linux-kernel-owner+w=401wt.eu-S1751254AbZC3RLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbZC3RLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZC3RLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:11:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZC3RLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:11:22 -0400
Message-Id: <20090330171024.254266860@chello.nl>
References: <20090330170701.856843742@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 19:07:14 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/15] perf_counter: provide generic callchain bits
Content-Disposition: inline; filename=perf_counter-callchain.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the generic callchain support bits. If hw_event->callchain is
set the arch specific perf_callchain() function is called upon to
provide a perf_callchain_entry structure filled with the current
callchain.

If it does so, it is added to the overflow output event.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   13 ++++++++++++-
 kernel/perf_counter.c        |   27 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
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
@@ -504,6 +506,15 @@ extern void perf_counter_mmap(unsigned l
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
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
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
 
@@ -1764,6 +1775,8 @@ static void perf_output_simple(struct pe
 	struct {
 		u32 pid, tid;
 	} tid_entry;
+	struct perf_callchain_entry *callchain = NULL;
+	int callchain_size = 0;
 
 	header.type = PERF_EVENT_OVERFLOW;
 	header.size = sizeof(header);
@@ -1781,6 +1794,17 @@ static void perf_output_simple(struct pe
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
@@ -1791,6 +1815,9 @@ static void perf_output_simple(struct pe
 	if (counter->hw_event.include_tid)
 		perf_output_put(&handle, tid_entry);
 
+	if (callchain)
+		perf_output_copy(&handle, callchain, callchain_size);
+
 	perf_output_end(&handle);
 }
 

-- 

