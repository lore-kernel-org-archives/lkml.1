Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZBGXVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZBGXVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZBGXVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:21:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:21589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbZBGXVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:21:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:to:cc:subject;
        b=Q1okdB4tawt8YMP9D7dpXkZ8FeYxROW14wx6sp/wiZMkJwequ1winc68m8fP1TG6Oa
         FdRMAFpSOINB+zsFosMrhXi/r5yRCt3nvzaPYTxAvtEOxtaqJ/lw4ajSSsuoSyajlIPG
         uFHa2p3o6tzsClG/JfOw4Yx6E6CB9flcLnQDE=
Message-ID: <498e176a.0637560a.3cea.3ff8@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 7 Feb 2009 23:32:51 +0100
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] tracing/core: drop the cpu field from trace_entry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a bug on cpu output

While looking on the function tracer traces, I first cheered up:

            TASK-PID    CPU#    TIMESTAMP  FUNCTION
               | |       |          |         |
         firefox-4622  [081]  1315.790405: lapic_next_event <-clockevents_program_event
         firefox-4622  [178]  1315.790405: native_apic_mem_write <-lapic_next_event
         firefox-4622  [020]  1315.790406: perf_counter_unthrottle <-smp_apic_timer_interrupt

But no, actually I don't have so many cpus...

This is a small bug: the cpu field on trace entry is never set up. Lots of tracers use it
on their context info to display the cpu number. But the cpu number on which a trace occured
is already known elsewhere: the ring-buffer is per cpu and we know
which cpu was used to store an event on the ring buffer, this information is on the
struct trace_iterator.

So both are overlaping. The cpu field on trace_entry is useless.
Unfortunatly we are not gaining any bytes, because the cpu is an unsigned char, the structure
will be padded to stay well memory aligned.

After this patch:

          <idle>-0     [001]    67.452518: __rcu_read_unlock <-input_pass_event
          <idle>-0     [000]    67.452518: ktime_get <-tick_nohz_stop_idle
          <idle>-0     [000]    67.452518: ktime_get_ts <-ktime_get
          <idle>-0     [001]    67.452518: _spin_unlock_irqrestore <-input_event

Sadly I've retrieved my two cpus....

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c        |    2 +-
 kernel/trace/trace.h        |    1 -
 kernel/trace/trace_output.c |    6 +++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ef4dbac..03fbd4c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1519,7 +1519,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
 	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
 		SEQ_PUT_FIELD_RET(s, entry->pid);
-		SEQ_PUT_FIELD_RET(s, entry->cpu);
+		SEQ_PUT_FIELD_RET(s, iter->cpu);
 		SEQ_PUT_FIELD_RET(s, iter->ts);
 	}
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 95dff7d..1cd7f7f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -46,7 +46,6 @@ enum trace_type {
  */
 struct trace_entry {
 	unsigned char		type;
-	unsigned char		cpu;
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b6e99af..9fc8150 100644
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
1.6.1


