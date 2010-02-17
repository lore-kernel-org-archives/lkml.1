Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab0BQCIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:08:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:53311 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933968Ab0BQCIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:08:22 -0500
Message-ID: <4B7B5169.50502@kernel.org>
Date: Wed, 17 Feb 2010 11:16:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH perf/core] percpu: add __percpu sparse annotations to trace
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 02:07:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __percpu sparse annotations to trace.

These annotations are to make sparse consider percpu variables to be
in a different address space and warn if accessed without going
through percpu accessors.  This patch doesn't affect normal builds.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
Trace part of __percpu sparce patches.  This patch needs the following
commit from mainline to define __percpu.

 2938429501b73f6aeb312236eac7ed0416a07cd5

Thanks.

 include/trace/ftrace.h               |    2 +-
 kernel/trace/trace_event_profile.c   |   15 ++++++++-------
 kernel/trace/trace_functions_graph.c |    2 +-
 kernel/trace/trace_ksym.c            |   10 +++++-----
 4 files changed, 15 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/include/trace/ftrace.h
===================================================================
--- linux-2.6-tip.orig/include/trace/ftrace.h
+++ linux-2.6-tip/include/trace/ftrace.h
@@ -773,7 +773,7 @@ __attribute__((section("_ftrace_events")
  *	struct ftrace_event_call *event_call = &event_<call>;
  *	extern void perf_tp_event(int, u64, u64, void *, int);
  *	struct ftrace_raw_##call *entry;
- *	struct perf_trace_buf *trace_buf;
+ *	struct perf_trace_buf __percpu *trace_buf;
  *	u64 __addr = 0, __count = 1;
  *	unsigned long irq_flags;
  *	struct trace_entry *ent;
Index: linux-2.6-tip/kernel/trace/trace_event_profile.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_event_profile.c
+++ linux-2.6-tip/kernel/trace/trace_event_profile.c
@@ -10,8 +10,8 @@
 #include "trace.h"
 
 
-static char *perf_trace_buf;
-static char *perf_trace_buf_nmi;
+static char __percpu *perf_trace_buf;
+static char __percpu *perf_trace_buf_nmi;
 
 typedef typeof(char [FTRACE_MAX_PROFILE_SIZE]) perf_trace_t ;
 
@@ -20,20 +20,20 @@ static int	total_profile_count;
 
 static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 {
-	char *buf;
+	char __percpu *buf;
 	int ret = -ENOMEM;
 
 	if (event->profile_count++ > 0)
 		return 0;
 
 	if (!total_profile_count) {
-		buf = (char *)alloc_percpu(perf_trace_t);
+		buf = (char __percpu *)alloc_percpu(perf_trace_t);
 		if (!buf)
 			goto fail_buf;
 
 		rcu_assign_pointer(perf_trace_buf, buf);
 
-		buf = (char *)alloc_percpu(perf_trace_t);
+		buf = (char __percpu *)alloc_percpu(perf_trace_t);
 		if (!buf)
 			goto fail_buf_nmi;
 
@@ -79,7 +79,7 @@ int ftrace_profile_enable(int event_id)
 
 static void ftrace_profile_disable_event(struct ftrace_event_call *event)
 {
-	char *buf, *nmi_buf;
+	char __percpu *buf, *nmi_buf;
 
 	if (--event->profile_count > 0)
 		return;
@@ -123,7 +123,8 @@ __kprobes void *ftrace_perf_buf_prepare(
 					int *rctxp, unsigned long *irq_flags)
 {
 	struct trace_entry *entry;
-	char *trace_buf, *raw_data;
+	char __percpu *trace_buf;
+	char *raw_data;
 	int pc, cpu;
 
 	pc = preempt_count();
Index: linux-2.6-tip/kernel/trace/trace_functions_graph.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_functions_graph.c
+++ linux-2.6-tip/kernel/trace/trace_functions_graph.c
@@ -21,7 +21,7 @@ struct fgraph_cpu_data {
 };
 
 struct fgraph_data {
-	struct fgraph_cpu_data		*cpu_data;
+	struct fgraph_cpu_data __percpu *cpu_data;
 
 	/* Place to preserve last processed entry. */
 	struct ftrace_graph_ent_entry	ent;
Index: linux-2.6-tip/kernel/trace/trace_ksym.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_ksym.c
+++ linux-2.6-tip/kernel/trace/trace_ksym.c
@@ -42,7 +42,7 @@
 #define KSYM_TRACER_OP_LEN 3 /* rw- */
 
 struct trace_ksym {
-	struct perf_event	**ksym_hbp;
+	struct perf_event	* __percpu *ksym_hbp;
 	struct perf_event_attr	attr;
 #ifdef CONFIG_PROFILE_KSYM_TRACER
 	atomic64_t		counter;
@@ -200,8 +200,8 @@ int process_new_ksym_entry(char *ksymnam
 	entry->ksym_hbp = register_wide_hw_breakpoint(&entry->attr,
 					ksym_hbp_handler);
 
-	if (IS_ERR(entry->ksym_hbp)) {
-		ret = PTR_ERR(entry->ksym_hbp);
+	if (IS_ERR((void __force *)entry->ksym_hbp)) {
+		ret = PTR_ERR((void __force *)entry->ksym_hbp);
 		printk(KERN_INFO "ksym_tracer request failed. Try again"
 					" later!!\n");
 		goto err;
@@ -331,8 +331,8 @@ static ssize_t ksym_trace_filter_write(s
 			entry->ksym_hbp =
 				register_wide_hw_breakpoint(&entry->attr,
 					ksym_hbp_handler);
-			if (IS_ERR(entry->ksym_hbp))
-				ret = PTR_ERR(entry->ksym_hbp);
+			if (IS_ERR((void __force *)entry->ksym_hbp))
+				ret = PTR_ERR((void __force *)entry->ksym_hbp);
 			else
 				goto out_unlock;
 		}
