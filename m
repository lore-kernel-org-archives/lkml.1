Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZJGX0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZJGX0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZJGX0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:26:50 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39229 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756178AbZJGX0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:26:49 -0400
Date: Wed, 7 Oct 2009 19:17:45 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [Patch vs. percpu next] Use this_cpu_xx for ftrace
Message-ID: <alpine.DEB.1.10.0910071916040.21638@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>
Subject: tracing: Use this_cpu_xx for ftrace

this_cpu_xx can reduce the instruction count here and also
avoid address arithmetic.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>


---
 kernel/trace/trace.c |    8 ++++----
 kernel/trace/trace.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/trace/trace.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace.c	2009-10-07 18:07:48.000000000 -0500
+++ linux-2.6/kernel/trace/trace.c	2009-10-07 18:09:42.000000000 -0500
@@ -86,17 +86,17 @@ static int dummy_set_flag(u32 old_flags,
  */
 static int tracing_disabled = 1;

-DEFINE_PER_CPU(local_t, ftrace_cpu_disabled);
+DEFINE_PER_CPU(int, ftrace_cpu_disabled);

 static inline void ftrace_disable_cpu(void)
 {
 	preempt_disable();
-	local_inc(&__get_cpu_var(ftrace_cpu_disabled));
+	__this_cpu_inc(per_cpu_var(ftrace_cpu_disabled));
 }

 static inline void ftrace_enable_cpu(void)
 {
-	local_dec(&__get_cpu_var(ftrace_cpu_disabled));
+	__this_cpu_dec(per_cpu_var(ftrace_cpu_disabled));
 	preempt_enable();
 }

@@ -1085,7 +1085,7 @@ trace_function(struct trace_array *tr,
 	struct ftrace_entry *entry;

 	/* If we are reading the ring buffer, don't trace */
-	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
 		return;

 	event = trace_buffer_lock_reserve(buffer, TRACE_FN, sizeof(*entry),
Index: linux-2.6/kernel/trace/trace.h
===================================================================
--- linux-2.6.orig/kernel/trace/trace.h	2009-10-07 18:08:59.000000000 -0500
+++ linux-2.6/kernel/trace/trace.h	2009-10-07 18:09:19.000000000 -0500
@@ -413,7 +413,7 @@ extern int DYN_FTRACE_TEST_NAME(void);

 extern int ring_buffer_expanded;
 extern bool tracing_selftest_disabled;
-DECLARE_PER_CPU(local_t, ftrace_cpu_disabled);
+DECLARE_PER_CPU(int, ftrace_cpu_disabled);

 #ifdef CONFIG_FTRACE_STARTUP_TEST
 extern int trace_selftest_startup_function(struct tracer *trace,
