Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbZBKS6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbZBKS6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbZBKS6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:58:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52279 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019AbZBKS63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:58:29 -0500
Date: Wed, 11 Feb 2009 13:57:25 -0500
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
	optimization
Message-ID: <20090211185725.GA3112@redhat.com>
References: <20081006102640.481acd23@infradead.org> <20081027155920.GS5704@elte.hu> <20081027110522.6cb7b142@infradead.org> <y0m3aihx1kd.fsf@ton.toronto.redhat.com> <20081027140630.521f933d@infradead.org> <20090210205747.GA3114@redhat.com> <20090211093029.GC14265@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090211093029.GC14265@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 10:30:29AM +0100, Ingo Molnar wrote:
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > On Mon, Oct 27, 2008 at 02:06:30PM -0700, Arjan van de Ven wrote:
> > > > Arjan van de Ven <arjan@infradead.org> writes:
> > > > 
> > > > > [...]
> > > > > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > > [...]
> > > > > @@ -427,6 +429,8 @@ static int acpi_cpufreq_target(struct
> > > > > cpufreq_policy *policy, }
> > > > >  	}
> > > > >  
> > > > > +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
> > > > > +
> > > > >  	switch (data->cpu_feature) {
> > > > >  	case SYSTEM_INTEL_MSR_CAPABLE:
> > > > >  		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
> > > > > [...]
> > > > 
> > > > Is there some reason that this doesn't use tracepoints instead
> > > > of such a single-backend hook?
> > > 
> > > because it's a ton simpler this way? do simple things simpe and all
> > > that....
> > > 
> > 
> > hi,
> > 
> > I wrote a patch to make c/p state tracer dependent on tracepoints and
> > then realized that the discussion had already been had. However, the
> > patch to use tracepoints is fairly simple, allows for other consumers,
> > and avoids a function call in the off case. please consider.
> > 
> > thanks,
> > 
> > -Jason
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> > 
> >  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 +++
> >  arch/x86/kernel/process.c                  |    4 ++++
> >  include/linux/ftrace.h                     |   15 ---------------
> >  include/trace/power.h                      |   18 ++++++++++++++++++
> >  kernel/trace/trace_power.c                 |   28 ++++++++++++++++++++--------
> >  5 files changed, 45 insertions(+), 23 deletions(-)
> >  create mode 100644 include/trace/power.h
> 
> Looks good, but could you please base this on latest -tip? There's a number of 
> pending changes in the tracing tree that conflict:
> 

ok, re-based patch against latest -tip. Addresses Frédéric's
concerns as well.

thanks,

-Jason

Convert the c/p state "power" tracer to use tracepoints. Avoids a
function call when the tracer is disabled.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 
 arch/x86/kernel/process.c                  |    3 
 include/trace/power.h                      |   25 ++--
 kernel/trace/trace_power.c                 |  173 +++++++++++++++++-----------
 4 files changed, 119 insertions(+), 84 deletions(-)


diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 7ed925e..c5d737c 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -70,6 +70,8 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
+DEFINE_TRACE(power_mark);
+
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 0f5d420..bf91350 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -19,6 +19,9 @@ EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
 
+DEFINE_TRACE(power_start);
+DEFINE_TRACE(power_end);
+
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
diff --git a/include/trace/power.h b/include/trace/power.h
index c7cefbc..2c733e5 100644
--- a/include/trace/power.h
+++ b/include/trace/power.h
@@ -2,6 +2,7 @@
 #define _TRACE_POWER_H
 
 #include <linux/ktime.h>
+#include <linux/tracepoint.h>
 
 enum {
 	POWER_NONE = 0,
@@ -18,18 +19,16 @@ struct power_trace {
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
 
 #endif /* _TRACE_POWER_H */
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index b1d0d08..91ce672 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -21,15 +21,116 @@
 static struct trace_array *power_trace;
 static int __read_mostly trace_power_enabled;
 
+static void probe_power_start(struct power_trace *it, unsigned int type,
+				unsigned int level)
+{
+	if (!trace_power_enabled)
+		return;
+
+	memset(it, 0, sizeof(struct power_trace));
+	it->state = level;
+	it->type = type;
+	it->stamp = ktime_get();
+}
+
+
+static void probe_power_end(struct power_trace *it)
+{
+	struct ring_buffer_event *event;
+	struct trace_power *entry;
+	struct trace_array_cpu *data;
+	struct trace_array *tr = power_trace;
+
+	if (!trace_power_enabled)
+		return;
+
+	preempt_disable();
+	it->end = ktime_get();
+	data = tr->data[smp_processor_id()];
+
+	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+					  sizeof(*entry), 0, 0);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	entry->state_data = *it;
+	trace_buffer_unlock_commit(tr, event, 0, 0);
+ out:
+	preempt_enable();
+}
+
+static void probe_power_mark(struct power_trace *it, unsigned int type,
+				unsigned int level)
+{
+	struct ring_buffer_event *event;
+	struct trace_power *entry;
+	struct trace_array_cpu *data;
+	struct trace_array *tr = power_trace;
+
+	if (!trace_power_enabled)
+		return;
+
+	memset(it, 0, sizeof(struct power_trace));
+	it->state = level;
+	it->type = type;
+	it->stamp = ktime_get();
+	preempt_disable();
+	it->end = it->stamp;
+	data = tr->data[smp_processor_id()];
+
+	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
+					  sizeof(*entry), 0, 0);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	entry->state_data = *it;
+	trace_buffer_unlock_commit(tr, event, 0, 0);
+ out:
+	preempt_enable();
+}
+
+static int tracing_power_register(void)
+{
+	int ret;
+
+	ret = register_trace_power_start(probe_power_start);
+	if (ret) {
+		pr_info("power trace: Couldn't activate tracepoint"
+			" probe to trace_power_start\n");
+		return ret;
+	}
+	ret = register_trace_power_end(probe_power_end);
+	if (ret) {
+		pr_info("power trace: Couldn't activate tracepoint"
+			" probe to trace_power_end\n");
+		goto fail_start;
+	}
+	ret = register_trace_power_mark(probe_power_mark);
+	if (ret) {
+		pr_info("power trace: Couldn't activate tracepoint"
+			" probe to trace_power_mark\n");
+		goto fail_end;
+	}
+	return ret;
+fail_end:
+	unregister_trace_power_end(probe_power_end);
+fail_start:
+	unregister_trace_power_start(probe_power_start);
+	return ret;
+}
 
 static void start_power_trace(struct trace_array *tr)
 {
 	trace_power_enabled = 1;
+	tracing_power_register();
 }
 
 static void stop_power_trace(struct trace_array *tr)
 {
 	trace_power_enabled = 0;
+	unregister_trace_power_start(probe_power_start);
+	unregister_trace_power_end(probe_power_end);
+	unregister_trace_power_mark(probe_power_mark);
 }
 
 
@@ -39,6 +140,7 @@ static int power_trace_init(struct trace_array *tr)
 	power_trace = tr;
 
 	trace_power_enabled = 1;
+	tracing_power_register();
 
 	for_each_cpu(cpu, cpu_possible_mask)
 		tracing_reset(tr, cpu);
@@ -95,74 +197,3 @@ static int init_power_trace(void)
 	return register_tracer(&power_tracer);
 }
 device_initcall(init_power_trace);
-
-void trace_power_start(struct power_trace *it, unsigned int type,
-			 unsigned int level)
-{
-	if (!trace_power_enabled)
-		return;
-
-	memset(it, 0, sizeof(struct power_trace));
-	it->state = level;
-	it->type = type;
-	it->stamp = ktime_get();
-}
-EXPORT_SYMBOL_GPL(trace_power_start);
-
-
-void trace_power_end(struct power_trace *it)
-{
-	struct ring_buffer_event *event;
-	struct trace_power *entry;
-	struct trace_array_cpu *data;
-	struct trace_array *tr = power_trace;
-
-	if (!trace_power_enabled)
-		return;
-
-	preempt_disable();
-	it->end = ktime_get();
-	data = tr->data[smp_processor_id()];
-
-	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->state_data = *it;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
- out:
-	preempt_enable();
-}
-EXPORT_SYMBOL_GPL(trace_power_end);
-
-void trace_power_mark(struct power_trace *it, unsigned int type,
-			 unsigned int level)
-{
-	struct ring_buffer_event *event;
-	struct trace_power *entry;
-	struct trace_array_cpu *data;
-	struct trace_array *tr = power_trace;
-
-	if (!trace_power_enabled)
-		return;
-
-	memset(it, 0, sizeof(struct power_trace));
-	it->state = level;
-	it->type = type;
-	it->stamp = ktime_get();
-	preempt_disable();
-	it->end = it->stamp;
-	data = tr->data[smp_processor_id()];
-
-	event = trace_buffer_lock_reserve(tr, TRACE_POWER,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->state_data = *it;
-	trace_buffer_unlock_commit(tr, event, 0, 0);
- out:
-	preempt_enable();
-}
-EXPORT_SYMBOL_GPL(trace_power_mark);
