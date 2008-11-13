Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYKMNLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYKMNLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYKMNLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:11:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYKMNLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:11:08 -0500
Date: Thu, 13 Nov 2008 08:11:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/1] ftrace: do not update max buffer with no users
In-Reply-To: <20081113084040.GD25479@elte.hu>
Message-ID: <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com>
References: <20081113043449.751885305@goodmis.org> <20081113043751.796120007@goodmis.org> <20081113084040.GD25479@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Nov 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Impact: only use max latency buffer when a user is configured
> > 
> > Pekka reported a bug with the resizing of the buffers when only the 
> > MMIO tracer was configured. The issue was, to save memory, the max 
> > latency trace buffer was only initialized if a tracer that uses it 
> > is configured in.
> > 
> > What happened was that the max latency buffer was never initialized 
> > when only the MMIO tracer was configurued. The MMIO tracer does not 
> > use the max tracer, which kept it from being initialized. But the 
> > resize code still tried to resize the max latency buffers, but 
> > because they were never allocated, the resize code was passed a NULL 
> > pointer.
> > 
> > This patch checks if the max tracer is NULL before resizing it. It 
> > also hides the modification functions of the max tracer behind the 
> > TRACER_MAX_TRACE config.
> > 
> > Reported-by: Pekka Paalanen <pq@iki.fi>
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  kernel/trace/trace.c |  171 ++++++++++++++++++++++++++------------------------
> >  1 files changed, 88 insertions(+), 83 deletions(-)
> 
> This is _way_ too much churn for .28, we need a much simpler solution.

The line count is very misleading. The 83 insertions and deletions where 
moved code or indentation:

-/*
- * The max_tr is used to snapshot the global_trace when a maximum
- * latency is reached. Some tracers will use this to store a maximum
- * trace while it continues examining live traces.
- *
- * The buffers for the max_tr are set up the same as the global_trace.
- * When a snapshot is taken, the link list of the max_tr is swapped
- * with the link list of the global_trace and the buffers are reset for
- * the global_trace so the tracing can continue.
- */
-static struct trace_array      max_tr;
-
-static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
-
+ * The max_tr is used to snapshot the global_trace when a maximum
+ * latency is reached. Some tracers will use this to store a maximum
+ * trace while it continues examining live traces.
+ *
+ * The buffers for the max_tr are set up the same as the global_trace.
+ * When a snapshot is taken, the link list of the max_tr is swapped
+ * with the link list of the global_trace and the buffers are reset for
+ * the global_trace so the tracing can continue.
+ */
+static struct trace_array      max_tr;
+
+static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
+
+#ifdef CONFIG_TRACER_MAX_TRACE   <--- Added line
+/*

+ * update_max_tr - snapshot all trace buffers from global_trace to max_tr
+ * @tr: tracer
+ * @tsk: the task with the latency
+ * @cpu: The cpu that initiated the trace.
+ *
+ * Flip the buffers between the @tr and the max_tr and record information
+ * about which task was the cause of this latency.
+ */
+void
+update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
+{
+       struct ring_buffer *buf = tr->buffer;
+
+       WARN_ON_ONCE(!irqs_disabled());
+       __raw_spin_lock(&ftrace_max_lock);
+
+       tr->buffer = max_tr.buffer;
+       max_tr.buffer = buf;
+
+       ftrace_disable_cpu();
+       ring_buffer_reset(tr->buffer);
+       ftrace_enable_cpu();
+
+       __update_max_tr(tr, tsk, cpu);
+       __raw_spin_unlock(&ftrace_max_lock);
+}
+
+/**
- * update_max_tr - snapshot all trace buffers from global_trace to max_tr
- * @tr: tracer
- * @tsk: the task with the latency
- * @cpu: The cpu that initiated the trace.
- *
- * Flip the buffers between the @tr and the max_tr and record information
- * about which task was the cause of this latency.
- */
-void
-update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
-{
-       struct ring_buffer *buf = tr->buffer;
-
-       WARN_ON_ONCE(!irqs_disabled());
-       __raw_spin_lock(&ftrace_max_lock);
-
-       tr->buffer = max_tr.buffer;
-       max_tr.buffer = buf;
-
-       ftrace_disable_cpu();
-       ring_buffer_reset(tr->buffer);
-       ftrace_enable_cpu();
-
-       __update_max_tr(tr, tsk, cpu);
-       __raw_spin_unlock(&ftrace_max_lock);
-}
-
-/**


+ * update_max_tr_single - only copy one trace over, and reset the rest
+ * @tr - tracer
+ * @tsk - task with the latency
+ * @cpu - the cpu of the buffer to copy.
+ *
+ * Flip the trace of a single CPU buffer between the @tr and the max_tr.
+ */
+void
+update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int 
cpu)
+{
+       int ret;
+
+       WARN_ON_ONCE(!irqs_disabled());
+       __raw_spin_lock(&ftrace_max_lock);
+
+       ftrace_disable_cpu();
+
+       ring_buffer_reset(max_tr.buffer);
+       ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
+
+       ftrace_enable_cpu();
+
+       WARN_ON_ONCE(ret);
+
+       __update_max_tr(tr, tsk, cpu);
+       __raw_spin_unlock(&ftrace_max_lock);
+}
+
+#endif /* CONFIG_TRACER_MAX_TRACE */  <---- Added line
+                                      <---- Added line
+/**
- * update_max_tr_single - only copy one trace over, and reset the rest
- * @tr - tracer
- * @tsk - task with the latency
- * @cpu - the cpu of the buffer to copy.
- *
- * Flip the trace of a single CPU buffer between the @tr and the max_tr.
- */
-void
-update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int 
cpu)
-{
-       int ret;
-
-       WARN_ON_ONCE(!irqs_disabled());
-       __raw_spin_lock(&ftrace_max_lock);
-
-       ftrace_disable_cpu();
-
-       ring_buffer_reset(max_tr.buffer);
-       ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
-
-       ftrace_enable_cpu();
-
-       WARN_ON_ONCE(ret);
-
-       __update_max_tr(tr, tsk, cpu);
-       __raw_spin_unlock(&ftrace_max_lock);
-}
-
-/**

-               ret = ring_buffer_resize(max_tr.buffer, val);
-               if (ret < 0) {
-                       int r;
-                       cnt = ret;
-                       r = ring_buffer_resize(global_trace.buffer,
-                                              global_trace.entries);
-                       if (r < 0) {
-                               /* AARGH! We are left with different
-                                * size max buffer!!!! */
-                               WARN_ON(1);
-                               tracing_disabled = 1;
+               if (max_tr.buffer) {       <---- Added line
+                       ret = ring_buffer_resize(max_tr.buffer, val);
+                       if (ret < 0) {
+                               int r;
+                               cnt = ret;
+                               r = ring_buffer_resize(global_trace.buffer,
+                                                      global_trace.entries);
+                               if (r < 0) {
+                                       /* AARGH! We are left with 
different
+                                        * size max buffer!!!! */
+                                       WARN_ON(1);
+                                       tracing_disabled = 1;
+                               }  <---- Added line
+                               goto out;
                        }
-                       goto out;


I annotated the 5 added lines.

The above which is the most confusing diff, because the diff did it funny,
is the one part of the patch that _is_ needed. Here's the before and after 
of that part:

-               ret = ring_buffer_resize(max_tr.buffer, val);
-               if (ret < 0) {
-                       int r;
-                       cnt = ret;
-                       r = ring_buffer_resize(global_trace.buffer,
-                                              global_trace.entries);
-                       if (r < 0) {
-                               /* AARGH! We are left with different
-                                * size max buffer!!!! */
-                               WARN_ON(1);
-                               tracing_disabled = 1;
                        }
-                       goto out;
                }


+               if (max_tr.buffer) {
+                       ret = ring_buffer_resize(max_tr.buffer, val);
+                       if (ret < 0) {
+                               int r;
+                               cnt = ret;
+                               r = ring_buffer_resize(global_trace.buffer,
+                                                      global_trace.entries);
+                               if (r < 0) {
+                                       /* AARGH! We are left with different
+                                        * size max buffer!!!! */
+                                       WARN_ON(1);
+                                       tracing_disabled = 1;
+                               }
+                               goto out;
                        }
                }

As you can easily see, the change only added the test for max_tr.buffer
exists, and indented the rest.

The other parts you can easily see that they are not changed.
But, we could separate out the moved code and ifdef protection for 29, 
even though I feel nervous that some config might use them, and break at 
runtime. This change will break the compile if it happens. Without the 
change, we find out at runtime :-(

-- Steve

