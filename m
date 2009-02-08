Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZBHFys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZBHFys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 00:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZBHFxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 00:53:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49229 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZBHFxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 00:53:42 -0500
Message-Id: <20090208055340.560398185@goodmis.org>
References: <20090208054955.777429253@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sun, 08 Feb 2009 00:49:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/8] trace: remove deprecated entry->cpu
Content-Disposition: inline; filename=0001-trace-remove-deprecated-entry-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to prevent developers from using entry->cpu

With the new ring buffer infrastructure, the cpu for the entry is
implicit with which CPU buffer it is on.

The original code use to record the current cpu into the generic
entry header, which can be retrieved by entry->cpu. When the
ring buffer was introduced, the users were convert to use the
the cpu number of which cpu ring buffer was in use (this was passed
to the tracers by the iterator: iter->cpu).

Unfortunately, the cpu item in the entry structure was never removed.
This allowed for developers to use it instead of the proper iter->cpu,
unknowingly, using an uninitialized variable. This was not the fault
of the developers, since it would seem like the logical place to
retrieve the cpu identifier.

This patch removes the cpu item from the entry structure and fixes
all the users that should have been using iter->cpu.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c             |    2 +-
 kernel/trace/trace.h             |    1 -
 kernel/trace/trace_hw_branches.c |    3 +--
 kernel/trace/trace_output.c      |    6 +++---
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fd51cf0..bd4d9f8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1531,7 +1531,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
 		SEQ_PUT_FIELD_RET(s, entry->pid);
-		SEQ_PUT_FIELD_RET(s, entry->cpu);
+		SEQ_PUT_FIELD_RET(s, iter->cpu);
 		SEQ_PUT_FIELD_RET(s, iter->ts);
 	}
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f0c7a0f..5efc4c7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -45,7 +45,6 @@ enum trace_type {
  */
 struct trace_entry {
 	unsigned char		type;
-	unsigned char		cpu;
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index fff3545..549238a 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -159,7 +159,7 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 	trace_assign_type(it, entry);
 
 	if (entry->type == TRACE_HW_BRANCHES) {
-		if (trace_seq_printf(seq, "%4d  ", entry->cpu) &&
+		if (trace_seq_printf(seq, "%4d  ", iter->cpu) &&
 		    seq_print_ip_sym(seq, it->to, symflags) &&
 		    trace_seq_printf(seq, "\t  <-  ") &&
 		    seq_print_ip_sym(seq, it->from, symflags) &&
@@ -195,7 +195,6 @@ void trace_hw_branch(u64 from, u64 to)
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, from);
 	entry->ent.type = TRACE_HW_BRANCHES;
-	entry->ent.cpu = cpu;
 	entry->from = from;
 	entry->to   = to;
 	ring_buffer_unlock_commit(tr->buffer, event, irq2);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b7380ee..463a310 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -333,7 +333,7 @@ int trace_print_context(struct trace_iterator *iter)
 	unsigned long secs = (unsigned long)t;
 
 	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
-				comm, entry->pid, entry->cpu, secs, usec_rem);
+				comm, entry->pid, iter->cpu, secs, usec_rem);
 }
 
 int trace_print_lat_context(struct trace_iterator *iter)
@@ -356,7 +356,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 		char *comm = trace_find_cmdline(entry->pid);
 		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08lx]"
 				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
-				       entry->pid, entry->cpu, entry->flags,
+				       entry->pid, iter->cpu, entry->flags,
 				       entry->preempt_count, iter->idx,
 				       ns2usecs(iter->ts),
 				       abs_usecs / USEC_PER_MSEC,
@@ -364,7 +364,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 				       rel_usecs / USEC_PER_MSEC,
 				       rel_usecs % USEC_PER_MSEC);
 	} else {
-		ret = lat_print_generic(s, entry, entry->cpu);
+		ret = lat_print_generic(s, entry, iter->cpu);
 		if (ret)
 			ret = lat_print_timestamp(s, abs_usecs, rel_usecs);
 	}
-- 
1.5.6.5

-- 
