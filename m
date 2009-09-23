Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZIWIcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZIWIcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZIWIca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:32:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:54248 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZIWIc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:32:29 -0400
Date: Wed, 23 Sep 2009 10:32:44 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu
Subject: [patch] introduce TRACE_EVENT_ABI (was Re: TRACE_EVENT_ABI ?)
Message-ID: <20090923103244.7aa5d027@infradead.org>
In-Reply-To: <1253568031.2935.5.camel@frodo>
References: <20090921093652.0722d745@infradead.org>
	<alpine.DEB.2.00.0909210926010.7647@gandalf.stny.rr.com>
	<20090921152853.2f8c0597@infradead.org>
	<1253551567.2630.26.camel@frodo>
	<20090921200042.29f0cf49@infradead.org>
	<1253568031.2935.5.camel@frodo>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 17:20:31 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2009-09-21 at 20:00 +0200, Arjan van de Ven wrote:
> > On Mon, 21 Sep 2009 12:46:07 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Mon, 2009-09-21 at 15:28 +0200, Arjan van de Ven wrote:
> 
> > > This patch compiled for me;
> > > 
> > 
> > your magic skills exceed mine ;-)
> > 
> > mind sending me a signoff for this ?
> 
> Sure,
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


>From e2c647ae2d3ddc25b804f0419956caf40d89c606 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 21 Sep 2009 20:14:53 +0200
Subject: [PATCH] trace: introduce TRACE_EVENT_ABI

Some trace events are suitable to form a stable userspace ABI;
this patch introduces infrastructure to mark them as such,
and marks the first few tracepoints this way

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/tracepoint.h   |    4 ++++
 include/trace/events/power.h |    6 +++---
 include/trace/events/sched.h |    4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 63a3f7a..4cb454f 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -280,6 +280,10 @@ static inline void tracepoint_synchronize_unregister(void)
  * TRACE_EVENT_FN to perform any (un)registration work.
  */
 
+#define TRACE_EVENT_ABI(name, proto, args, tstruct, assign, print)	\
+	TRACE_EVENT(name, PARAMS(proto), PARAMS(args),			\
+		    PARAMS(tstruct), PARAMS(assign), PARAMS(print))
+
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define TRACE_EVENT_FN(name, proto, args, struct,		\
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index ea6d579..7f0e86e 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -18,7 +18,7 @@ enum {
 
 
 
-TRACE_EVENT(power_start,
+TRACE_EVENT_ABI(power_start,
 
 	TP_PROTO(unsigned int type, unsigned int state),
 
@@ -37,7 +37,7 @@ TRACE_EVENT(power_start,
 	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long)__entry->state)
 );
 
-TRACE_EVENT(power_end,
+TRACE_EVENT_ABI(power_end,
 
 	TP_PROTO(int dummy),
 
@@ -56,7 +56,7 @@ TRACE_EVENT(power_end,
 );
 
 
-TRACE_EVENT(power_frequency,
+TRACE_EVENT_ABI(power_frequency,
 
 	TP_PROTO(unsigned int type, unsigned int state),
 
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 4069c43..93a3e17 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -83,7 +83,7 @@ TRACE_EVENT(sched_wait_task,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-TRACE_EVENT(sched_wakeup,
+TRACE_EVENT_ABI(sched_wakeup,
 
 	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
 
@@ -149,7 +149,7 @@ TRACE_EVENT(sched_wakeup_new,
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
-TRACE_EVENT(sched_switch,
+TRACE_EVENT_ABI(sched_switch,
 
 	TP_PROTO(struct rq *rq, struct task_struct *prev,
 		 struct task_struct *next),
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
