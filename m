Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZBJU7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZBJU7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZBJU67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:58:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZBJU66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:58:58 -0500
Date: Tue, 10 Feb 2009 15:57:47 -0500
From: Jason Baron <jbaron@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
	optimization
Message-ID: <20090210205747.GA3114@redhat.com>
References: <20081006102640.481acd23@infradead.org> <20081027155920.GS5704@elte.hu> <20081027110522.6cb7b142@infradead.org> <y0m3aihx1kd.fsf@ton.toronto.redhat.com> <20081027140630.521f933d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027140630.521f933d@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 02:06:30PM -0700, Arjan van de Ven wrote:
> > Arjan van de Ven <arjan@infradead.org> writes:
> > 
> > > [...]
> > > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > [...]
> > > @@ -427,6 +429,8 @@ static int acpi_cpufreq_target(struct
> > > cpufreq_policy *policy, }
> > >  	}
> > >  
> > > +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
> > > +
> > >  	switch (data->cpu_feature) {
> > >  	case SYSTEM_INTEL_MSR_CAPABLE:
> > >  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
> > > [...]
> > 
> > Is there some reason that this doesn't use tracepoints instead
> > of such a single-backend hook?
> 
> because it's a ton simpler this way? do simple things simpe and all
> that....
> 

hi,

I wrote a patch to make c/p state tracer dependent on tracepoints and
then realized that the discussion had already been had. However, the
patch to use tracepoints is fairly simple, allows for other consumers,
and avoids a function call in the off case. please consider.

thanks,

-Jason

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 +++
 arch/x86/kernel/process.c                  |    4 ++++
 include/linux/ftrace.h                     |   15 ---------------
 include/trace/power.h                      |   18 ++++++++++++++++++
 kernel/trace/trace_power.c                 |   28 ++++++++++++++++++++--------
 5 files changed, 45 insertions(+), 23 deletions(-)
 create mode 100644 include/trace/power.h


diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4b1c319..4540ddc 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -34,6 +34,7 @@
 #include <linux/compiler.h>
 #include <linux/dmi.h>
 #include <linux/ftrace.h>
+#include <trace/power.h>
 
 #include <linux/acpi.h>
 #include <acpi/processor.h>
@@ -70,6 +71,8 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
+DEFINE_TRACE(power_mark);
+
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e68bb9e..09cfd5d 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <linux/ftrace.h>
+#include <trace/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 
@@ -19,6 +20,9 @@ EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
 
+DEFINE_TRACE(power_start);
+DEFINE_TRACE(power_end);
+
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 677432b..044e0fd 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -342,21 +342,6 @@ struct power_trace {
 #endif
 };
 
-#ifdef CONFIG_POWER_TRACER
-extern void trace_power_start(struct power_trace *it, unsigned int type,
-					unsigned int state);
-extern void trace_power_mark(struct power_trace *it, unsigned int type,
-					unsigned int state);
-extern void trace_power_end(struct power_trace *it);
-#else
-static inline void trace_power_start(struct power_trace *it, unsigned int type,
-					unsigned int state) { }
-static inline void trace_power_mark(struct power_trace *it, unsigned int type,
-					unsigned int state) { }
-static inline void trace_power_end(struct power_trace *it) { }
-#endif
-
-
 /*
  * Structure that defines an entry function trace.
  */
diff --git a/include/trace/power.h b/include/trace/power.h
new file mode 100644
index 0000000..c3225ff
--- /dev/null
+++ b/include/trace/power.h
@@ -0,0 +1,18 @@
+#ifndef _TRACE_POWER_H
+#define _TRACE_POWER_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_TRACE(power_start,
+	TPPROTO(struct power_trace *it, unsigned int type, unsigned int state),
+		TPARGS(it, type, state));
+
+DECLARE_TRACE(power_mark,
+	TPPROTO(struct power_trace *it, unsigned int type, unsigned int state),
+		TPARGS(it, type, state));
+
+DECLARE_TRACE(power_end,
+	TPPROTO(struct power_trace *it),
+		TPARGS(it));
+
+#endif
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 7bda248..18e97c9 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -14,30 +14,45 @@
 #include <linux/ftrace.h>
 #include <linux/kallsyms.h>
 #include <linux/module.h>
+#include <linux/module.h>
+#include <trace/power.h>
 
 #include "trace.h"
 
 static struct trace_array *power_trace;
 static int __read_mostly trace_power_enabled;
 
+static void trace_power_start_callback(struct power_trace *it,
+					unsigned int type, unsigned int state);
+static void trace_power_mark_callback(struct power_trace *it, unsigned int type,
+					unsigned int state);
+static void trace_power_end_callback(struct power_trace *it);
 
 static void start_power_trace(struct trace_array *tr)
 {
 	trace_power_enabled = 1;
+	register_trace_power_start(trace_power_start_callback);
+	register_trace_power_end(trace_power_end_callback);
+	register_trace_power_mark(trace_power_mark_callback);
 }
 
 static void stop_power_trace(struct trace_array *tr)
 {
 	trace_power_enabled = 0;
+	unregister_trace_power_start(trace_power_start_callback);
+	unregister_trace_power_end(trace_power_end_callback);
+	unregister_trace_power_mark(trace_power_mark_callback);
 }
 
-
 static int power_trace_init(struct trace_array *tr)
 {
 	int cpu;
 	power_trace = tr;
 
 	trace_power_enabled = 1;
+	register_trace_power_start(trace_power_start_callback);
+	register_trace_power_end(trace_power_end_callback);
+	register_trace_power_mark(trace_power_mark_callback);
 
 	for_each_cpu(cpu, cpu_possible_mask)
 		tracing_reset(tr, cpu);
@@ -95,8 +110,8 @@ static int init_power_trace(void)
 }
 device_initcall(init_power_trace);
 
-void trace_power_start(struct power_trace *it, unsigned int type,
-			 unsigned int level)
+static void trace_power_start_callback(struct power_trace *it,
+			unsigned int type, unsigned int level)
 {
 	if (!trace_power_enabled)
 		return;
@@ -106,10 +121,9 @@ void trace_power_start(struct power_trace *it, unsigned int type,
 	it->type = type;
 	it->stamp = ktime_get();
 }
-EXPORT_SYMBOL_GPL(trace_power_start);
 
 
-void trace_power_end(struct power_trace *it)
+static void trace_power_end_callback(struct power_trace *it)
 {
 	struct ring_buffer_event *event;
 	struct trace_power *entry;
@@ -139,9 +153,8 @@ void trace_power_end(struct power_trace *it)
  out:
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(trace_power_end);
 
-void trace_power_mark(struct power_trace *it, unsigned int type,
+static void trace_power_mark_callback(struct power_trace *it, unsigned int type,
 			 unsigned int level)
 {
 	struct ring_buffer_event *event;
@@ -176,4 +189,3 @@ void trace_power_mark(struct power_trace *it, unsigned int type,
  out:
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(trace_power_mark);
