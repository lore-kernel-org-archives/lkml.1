Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbYJJLFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbYJJLFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYJJLFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:05:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48920 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYJJLFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:05:03 -0400
Date: Fri, 10 Oct 2008 13:04:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] Tracing/fastboot: Enable boot tracing only during
	initcalls
Message-ID: <20081010110445.GA12519@elte.hu>
References: <20081010103615.EFB18D1BB8F@perso1.free.fr> <20081010105819.GA4699@elte.hu> <c62985530810100402of7e1b48n4aac01d69433c1f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810100402of7e1b48n4aac01d69433c1f5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/10/10 Ingo Molnar <mingo@elte.hu>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> We used to disable the initcall tracing at a specified time (IE: end
> >> of builtin initcalls). But we don\'t need it anymore. It will be
> >> stopped when initcalls are finished. However we want two things:
> >>
> >> _Start this tracing only after pre-smp initcalls are finished. _Since
> >> we are planning to trace sched_switches at the same time, we want to
> >> enable them only during the initcall execution. For this purpose, this
> >> patch introduce two functions to enable/disable the sched_switch
> >> tracing during boot.
> >>
> >> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> >
> > applied to tip/tracing/fastboot, thanks Frederic!
> >
> >        Ingo
> >
> 
> Oops, sorry Ingo there are some backslashes that taint this patch.
> I will resend a V2....

dont worry, i fixed them already when i applied your patch (and that's 
all in latest tip/master).

See the commit below - i sanitize most commit entries to make subject 
lines more consistent (note the capitalization difference between your 
submission and the end result), to improve paragraphing and general 
structure.

	Ingo

----------->
>From d1b6be5c1bb11dfd23b000a9342b9f8c3750e143 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 10 Oct 2008 12:36:15 +0200
Subject: [PATCH] tracing/fastboot: enable boot tracing only during initcalls

We used to disable the initcall tracing at a specified time
(IE: end of builtin initcalls). But we don't need it anymore.
It will be stopped when initcalls are finished.

However we want two things:

_Start this tracing only after pre-smp initcalls are finished.

_Since we are planning to trace sched_switches at the same time, we want
to enable them only during the initcall execution.

For this purpose, this patch introduces two functions to enable/disable
the sched_switch tracing during boot.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace.h    |   24 ++++++++++++++++++++++--
 init/main.c               |    4 +++-
 kernel/trace/trace_boot.c |   28 ++++++++++++++++------------
 3 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index a3d4615..bc9a75a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -213,6 +213,11 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
 #endif
 
 
+/*
+ * Structure which defines the trace of an initcall.
+ * You don\'t have to fill the func field since it is
+ * only used internally by the tracer.
+ */
 struct boot_trace {
 	pid_t			caller;
 	char			func[KSYM_NAME_LEN];
@@ -223,13 +228,28 @@ struct boot_trace {
 };
 
 #ifdef CONFIG_BOOT_TRACER
+/* Append the trace on the ring-buffer */
 extern void trace_boot(struct boot_trace *it, initcall_t fn);
+
+/* Tells the tracer that smp_pre_initcall is finished.
+ * So we can start the tracing
+ */
 extern void start_boot_trace(void);
-extern void stop_boot_trace(void);
+
+/* Resume the tracing of other necessary events
+ * such as sched switches
+ */
+extern void enable_boot_trace(void);
+
+/* Suspend this tracing. Actually, only sched_switches tracing have
+ * to be suspended. Initcalls doesn\'t need it.)
+ */
+extern void disable_boot_trace(void);
 #else
 static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
 static inline void start_boot_trace(void) { }
-static inline void stop_boot_trace(void) { }
+static inline void enable_boot_trace(void) { }
+static inline void disable_boot_trace(void) { }
 #endif
 
 
diff --git a/init/main.c b/init/main.c
index 8d58855..df48ed1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -714,6 +714,7 @@ int do_one_initcall(initcall_t fn)
 		it.caller = task_pid_nr(current);
 		printk("calling  %pF @ %i\n", fn, it.caller);
 		it.calltime = ktime_get();
+		enable_boot_trace();
 	}
 
 	it.result = fn();
@@ -725,6 +726,7 @@ int do_one_initcall(initcall_t fn)
 		printk("initcall %pF returned %d after %Ld usecs\n", fn,
 			it.result, it.duration);
 		trace_boot(&it, fn);
+		disable_boot_trace();
 	}
 
 	msgbuf[0] = 0;
@@ -957,7 +959,7 @@ static int __init kernel_init(void * unused)
 	 * we're essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
 	 */
-	stop_boot_trace();
+
 	init_post();
 	return 0;
 }
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index d0a5e50..52c3743 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -13,23 +13,29 @@
 #include "trace.h"
 
 static struct trace_array *boot_trace;
-static int trace_boot_enabled;
+static bool pre_initcalls_finished;
 
-
-/* Should be started after do_pre_smp_initcalls() in init/main.c */
+/* Tells the boot tracer that the pre_smp_initcalls are finished.
+ * So we are ready .
+ * It doesn\'t enable sched events tracing however.
+ * You have to call enable_boot_trace to do so.
+ */
 void start_boot_trace(void)
 {
-	trace_boot_enabled = 1;
+	pre_initcalls_finished = true;
+}
+
+void enable_boot_trace(void)
+{
 }
 
-void stop_boot_trace(void)
+void disable_boot_trace(void)
 {
-	trace_boot_enabled = 0;
 }
 
 void reset_boot_trace(struct trace_array *tr)
 {
-	stop_boot_trace();
+	disable_boot_trace();
 }
 
 static void boot_trace_init(struct trace_array *tr)
@@ -37,8 +43,6 @@ static void boot_trace_init(struct trace_array *tr)
 	int cpu;
 	boot_trace = tr;
 
-	trace_boot_enabled = 0;
-
 	for_each_cpu_mask(cpu, cpu_possible_map)
 		tracing_reset(tr, cpu);
 }
@@ -46,9 +50,9 @@ static void boot_trace_init(struct trace_array *tr)
 static void boot_trace_ctrl_update(struct trace_array *tr)
 {
 	if (tr->ctrl)
-		start_boot_trace();
+		enable_boot_trace();
 	else
-		stop_boot_trace();
+		disable_boot_trace();
 }
 
 static enum print_line_t initcall_print_line(struct trace_iterator *iter)
@@ -99,7 +103,7 @@ void trace_boot(struct boot_trace *it, initcall_t fn)
 	unsigned long irq_flags;
 	struct trace_array *tr = boot_trace;
 
-	if (!trace_boot_enabled)
+	if (!pre_initcalls_finished)
 		return;
 
 	/* Get its name now since this function could
