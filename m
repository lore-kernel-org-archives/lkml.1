Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYK1JSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYK1JSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYK1JSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:18:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYK1JSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:18:09 -0500
Date: Fri, 28 Nov 2008 10:18:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the
	trace informations
Message-ID: <20081128091800.GA1725@elte.hu>
References: <492F3076.7050104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492F3076.7050104@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: increase visibility of the output
> 
> This patch applies various changes.
> 
> _CPU is now a decimal number, followed by a parenthesis.
> 
> _Overhead is now on the second column (gives a good visibility)
> 
> _Cost is now on the third column, can't exceed 9999.99 us. It is followed
>  by a virtual line based on a "|" character.
> 
> _Functions calls are now the last column on the right. This way, we haven't
>  dynamic column (which flow is harder to follow) on its right.
> 
> _CPU and Overhead have their own option flag. They are default-on but you can
>  disable them easily:
> 
>  echo nofuncgraph-cpu > trace_options
>  echo nofuncgraph-overhead > trace_options
> 
> TODO:
> 
> _ Refactoring of the thread switch output.
> _ Give a default-off option to output the thread and its pid on each row.
> _ Provide headers
> _ ....
> 
> Here is an example of the new trace style (a wider one is provided in attachment):
> 
> 0)           |             mutex_unlock() {
> 0)      0.639 us |           __mutex_unlock_slowpath();
> 0)      1.607 us |         }
> 0)           |             remove_wait_queue() {
> 0)      0.616 us |           _spin_lock_irqsave();
> 0)      0.616 us |           _spin_unlock_irqrestore();
> 0)      2.779 us |         }
> 0)      0.495 us |         n_tty_set_room();
> 0) ! 9999.999 us |       }
> 0)           |           tty_ldisc_deref() {
> 0)      0.615 us |         _spin_lock_irqsave();
> 0)      0.616 us |         _spin_unlock_irqrestore();
> 0)      2.793 us |       }
> 0)           |           current_fs_time() {
> 0)      0.488 us |         current_kernel_time();
> 0)      0.495 us |         timespec_trunc();
> 0)      2.486 us |       }
> 0) ! 9999.999 us |     }
> 0) ! 9999.999 us |   }
> 0) ! 9999.999 us | }
> 0)           |     sys_read() {
> 0)      0.796 us |   fget_light();
> 0)           |       vfs_read() {
> 0)           |         rw_verify_area() {
> 0)           |           security_file_permission() {
> 0)      0.488 us |         cap_file_permission();
> 0)      1.720 us |       }
> 0)      3.  4 us |     }
> 0)           |         tty_read() {
> 0)      0.488 us |       tty_paranoia_check();
> 0)           |           tty_ldisc_ref_wait() {
> 0)           |             tty_ldisc_try() {
> 0)      0.615 us |           _spin_lock_irqsave();
> 0)      0.615 us |           _spin_unlock_irqrestore();
> 0)      5.436 us |         }
> 0)      6.427 us |       }

very nice! Applied to tip/tracing/function-graph-tracer

a few comments. 

Firstly, what do you think about the additional tweaks i did - see the 
patch below?

Before:

0)           |     sys_read() {
0)      0.796 us |   fget_light();
0)           |       vfs_read() {
0)           |         rw_verify_area() {
0)           |           security_file_permission() {
------------8<---------- thread sshd-1755 ------------8<----------

After:

 0)               |  sys_read() {
 0)      0.796 us |    fget_light();
 0)               |    vfs_read() {
 0)               |      rw_verify_area() {
 0)               |        security_file_permission() {
 ------------------------------------------
 | 1)  migration/0--1  =>  sshd-1755
 ------------------------------------------

Secondly:

> +	/* Must not exceed 8 characters: xxxx.yyy us */
> +	if (duration > 10000000ULL)
> +		duration = 9999999ULL;

10 milliseconds isnt much or full system calls, etc.- so i believe the 
rule should be what i outlined in an earlier mail. The relevant 
transition points go like this:

     0.000 
  xxxx.yyy
  9999.999
  10000.00
  xxxxx.yy
  99999.99
  100000.0
  xxxxxx.y
  999999.9
   1000000
   9999999
  10000000
  xxxxxxxx
  99999999 [ 100 seconds ]
  100000000 ... up to infinity

this way we can get up to 99999999 usecs with the same fixed width - 
or 100 seconds. _That_ is enough in practice.

But even beyond that we should print it all out: we should still not 
clip actual information but instead shift the line to the right. The 
slightly inconsistent line is not a big problem - we want a 100 
seconds delay to stand out anyway ;-)

The moving decimal point above 10 milliseconds is not a big problem 
with the '+' and '!' marker. Maybe add a '!!' marker to these lines?

	Ingo

------------------->
>From d51090b34602a20984ab0312ef04e47069c0aec6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 28 Nov 2008 09:55:16 +0100
Subject: [PATCH] tracing/function-graph-tracer: more output tweaks

Impact: prettify the output some more

Before:

0)           |     sys_read() {
0)      0.796 us |   fget_light();
0)           |       vfs_read() {
0)           |         rw_verify_area() {
0)           |           security_file_permission() {
------------8<---------- thread sshd-1755 ------------8<----------

After:

 0)               |  sys_read() {
 0)      0.796 us |    fget_light();
 0)               |    vfs_read() {
 0)               |      rw_verify_area() {
 0)               |        security_file_permission() {
 ------------------------------------------
 | 1)  migration/0--1  =>  sshd-1755
 ------------------------------------------

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_functions_graph.c |   45 ++++++++++++++++++++++++++++-----
 1 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 596a3ee..894b50b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -79,6 +79,19 @@ print_graph_cpu(struct trace_seq *s, int cpu)
 	int log10_all = log10_cpu(cpus_weight_nr(cpu_online_map));
 
 
+	/*
+	 * Start with a space character - to make it stand out
+	 * to the right a bit when trace output is pasted into
+	 * email:
+	 */
+	ret = trace_seq_printf(s, " ");
+
+	/*
+	 * Tricky - we space the CPU field according to the max
+	 * number of online CPUs. On a 2-cpu system it would take
+	 * a maximum of 1 digit - on a 128 cpu system it would
+	 * take up to 3 digits:
+	 */
 	for (i = 0; i < log10_all - log10_this; i++) {
 		ret = trace_seq_printf(s, " ");
 		if (!ret)
@@ -86,7 +99,8 @@ print_graph_cpu(struct trace_seq *s, int cpu)
 	}
 	ret = trace_seq_printf(s, "%d) ", cpu);
 	if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_PARTIAL_LINE;
+
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -94,17 +108,34 @@ print_graph_cpu(struct trace_seq *s, int cpu)
 /* If the pid changed since the last trace, output this event */
 static int verif_pid(struct trace_seq *s, pid_t pid, int cpu)
 {
-	char *comm;
+	char *comm, *prev_comm;
+	pid_t prev_pid;
+	int ret;
 
 	if (last_pid[cpu] != -1 && last_pid[cpu] == pid)
 		return 1;
 
+	prev_pid = last_pid[cpu];
 	last_pid[cpu] = pid;
+
 	comm = trace_find_cmdline(pid);
+	prev_comm = trace_find_cmdline(prev_pid);
 
-	return trace_seq_printf(s, "\n------------8<---------- thread %s-%d"
-				    " ------------8<----------\n\n",
-				    cpu, comm, pid);
+/*
+ * Context-switch trace line:
+
+ ------------------------------------------
+ | 1)  migration/0--1  =>  sshd-1755
+ ------------------------------------------
+
+ */
+	ret = trace_seq_printf(s,
+		" ------------------------------------------\n");
+	ret += trace_seq_printf(s, " | %d)  %s-%d  =>  %s-%d\n",
+				  cpu, prev_comm, prev_pid, comm, pid);
+	ret += trace_seq_printf(s,
+		" ------------------------------------------\n\n");
+	return ret;
 }
 
 static bool
@@ -142,7 +173,7 @@ static inline int
 print_graph_duration(unsigned long long duration, struct trace_seq *s)
 {
 	unsigned long nsecs_rem = do_div(duration, 1000);
-	return trace_seq_printf(s, "%4llu.%3lu us | ", duration, nsecs_rem);
+	return trace_seq_printf(s, "%4llu.%3lu us |  ", duration, nsecs_rem);
 }
 
 /* Signal a overhead of time execution to the output */
@@ -229,7 +260,7 @@ print_graph_entry_nested(struct ftrace_graph_ent_entry *entry,
 	}
 
 	/* No time */
-	ret = trace_seq_printf(s, "        |     ");
+	ret = trace_seq_printf(s, "            |  ");
 
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
