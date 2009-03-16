Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbZCPTkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbZCPTkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZCPTju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:39:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37369 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbZCPTju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:39:50 -0400
Date: Mon, 16 Mar 2009 15:38:40 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org,
       compudj@krystal.dyndns.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
Message-ID: <20090316193840.GC3111@redhat.com>
References: <20090312183603.GC3352@redhat.com> <20090316190047.GB3111@redhat.com> <alpine.DEB.2.00.0903161514590.27978@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903161514590.27978@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 03:17:09PM -0400, Steven Rostedt wrote:
> memcpy isn't fast ;-)
> 
> What you want is this:
> 
> 	TP_STRUCT__entry(
> 		__field(	int,	vec	)
> 	),
> 
> 	TP_fast_assign(
> 		__entry->vec = h - vec;

definitely simplifies things! ok, re-spun patch again.

use TRACE_EVENT to record the softirq vector number in the trace and then use
the new softirq_to_name array to output the softirq vector name.

Signed-off-by: Jason Baron <jbaron@redhat.com>


---

 include/trace/irq_event_types.h |   34 ++++++++++++++++++++++++++++++++++
 kernel/softirq.c                |    7 ++++++-
 2 files changed, 40 insertions(+), 1 deletions(-)


diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
index 214bb92..acb8217 100644
--- a/include/trace/irq_event_types.h
+++ b/include/trace/irq_event_types.h
@@ -40,4 +40,38 @@ TRACE_EVENT(irq_handler_exit,
 		  __entry->irq, __entry->ret ? "handled" : "unhandled")
 );
 
+TRACE_EVENT(softirq_action_entry,
+
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+
+	TP_ARGS(h, vec),
+
+	TP_STRUCT__entry(
+		__field(	int,	vec	)
+	),
+
+	TP_fast_assign(
+		__entry->vec = h - vec;
+	),
+
+	TP_printk("softirq entry: %s", softirq_to_name[__entry->vec])
+);
+
+TRACE_EVENT(softirq_action_exit,
+
+	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
+
+	TP_ARGS(h, vec),
+
+	TP_STRUCT__entry(
+		__field(	int,	vec	)
+	),
+
+	TP_fast_assign(
+		__entry->vec = h - vec;
+	),
+
+	TP_printk("softirq exit: %s", softirq_to_name[__entry->vec])
+);
+
 #undef TRACE_SYSTEM
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 8f3ae57..5e96c77 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -24,6 +24,7 @@
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <trace/irq.h>
 
 #include <asm/irq.h>
 /*
@@ -185,6 +186,9 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  */
 #define MAX_SOFTIRQ_RESTART 10
 
+DEFINE_TRACE(softirq_action_entry);
+DEFINE_TRACE(softirq_action_exit);
+
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
@@ -211,8 +215,9 @@ restart:
 		if (pending & 1) {
 			int prev_count = preempt_count();
 
+			trace_softirq_action_entry(h, softirq_vec);
 			h->action(h);
-
+			trace_softirq_action_exit(h, softirq_vec);
 			if (unlikely(prev_count != preempt_count())) {
 				printk(KERN_ERR "huh, entered softirq %td %s %p"
 				       "with preempt_count %08x,"

 
