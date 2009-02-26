Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZBZPMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZBZPMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZBZPMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:12:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60515 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbZBZPMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:12:18 -0500
Date: Thu, 26 Feb 2009 10:11:05 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>, mingo@elte.hu
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090226151105.GA3122@redhat.com>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225173412.GA14269@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 12:34:12PM -0500, Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> > On Wed, Feb 25, 2009 at 11:48:28AM -0500, Masami Hiramatsu wrote:
> > > KOSAKI Motohiro wrote:
> > > >>  /**
> > > >>   * handle_IRQ_event - irq action chain handler
> > > >>   * @irq:	the interrupt number
> > > >> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> > > >>  		local_irq_enable_in_hardirq();
> > > >>  
> > > >>  	do {
> > > >> +		trace_irq_entry(irq);
> > > >>  		ret = action->handler(irq, action->dev_id);
> > > >> +		trace_irq_exit(irq, ret);
> > > >>  		if (ret == IRQ_HANDLED)
> > > >>  			status |= action->flags;
> > > >>  		retval |= ret;
> > > > 
> > > > Nobdy want unnecessary redundant tracepoint.
> > > > Please discuss with mathieu, and merge his tracepoint.
> > > 
> > > Hmm, from the viewpoint of trouble shooting, the place of LTTng's tracepoint
> > > is enough. However, from the same viewpoint, it should pass irq-number
> > > to irq-exit event too, because we may lost some previous events by buffer-overflow
> > > etc.
> > > 
> > >          trace_irq_entry(irq, NULL);
> > >          ret = _handle_IRQ_event(irq, action);
> > >          trace_irq_exit(irq, ret);
> > >                         ^^^^
> > > 
> > 
> > the lttng tracepoints wrap the calls to _handle_IRQ_event in 3
> > different places. So the above suggested irq tracepoint provides the
> > same information with 4 less tracepoints in the code. So I believe its
> > simpler - plus we can understand which action handlers are handling the
> > interrupt.
> > 
> 
> The main thing I dislike about only tracing action->handler() calls is
> that you are not tracing an IRQ per se, but rather the invocation of a
> given handler within the interrupt. For instance, it would be difficult
> to calculate the maximum interrupt latency for a given interrupt line,
> because you don't have the "real" irq entry/exit events, just the
> individual handler() calls.
> 
> But I agree that knowing which handler is called is important.
> 
> How about this compromise :
> 
> trace_irq_entry(irq, action)
>   _handle_IRQ_event()
>     for each action  {
>       trace_irq_handler(action, ret);
>       ret = action->handler(irq, action->dev_id);
>       ...
>     }
> trace_irq_exit(action_ret);
> 
> Would that give you the information you need ?
> 
> Here trace_irq_handler would be passed the _current_ action invoked and
> the _previous_ action return value. Note that we should initialize
> irqreturn_t ret to some initial value if we do this. That should keep
> the tracing overhead minimal.
> 

maybe...although that would require re-arranging the 'while' loop in
'handle_IRQ_event' from a do..while loop to a 'while' loop, which will
require an extra branch check, and then we still have to record the last 'ret'
value. I'm not that keen on re-arranging this for trace data...

Using Steve's new 'DEFINE_TRACE_FMT', I can get function graph trace
as follows using the original two tracepoints (patch below):

 3)               |                      handle_IRQ_event() {
 3)               |                        /* (irq_handler_entry) irq=28 handler=eth0 */
 3)               |                        e1000_intr_msi() {
 3)   2.460 us    |                          __napi_schedule();
 3)   9.416 us    |                        }
 3)               |                        /* (irq_handler_exit) irq=28 handler=eth0 return=handled */
 3) + 22.935 us   |                      }

thanks,

-Jason


Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 include/trace/irq.h             |    9 +++++++++
 include/trace/irq_event_types.h |   17 +++++++++++++++++
 kernel/irq/handle.c             |    6 ++++++
 kernel/trace/events.c           |    2 ++
 4 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/irq.h
 create mode 100644 include/trace/irq_event_types.h


diff --git a/include/trace/irq.h b/include/trace/irq.h
new file mode 100644
index 0000000..ff5d449
--- /dev/null
+++ b/include/trace/irq.h
@@ -0,0 +1,9 @@
+#ifndef _TRACE_IRQ_H
+#define _TRACE_IRQ_H
+
+#include <linux/interrupt.h>
+#include <linux/tracepoint.h>
+
+#include <trace/irq_event_types.h>
+
+#endif
diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
new file mode 100644
index 0000000..5889bfd
--- /dev/null
+++ b/include/trace/irq_event_types.h
@@ -0,0 +1,17 @@
+
+/* use <trace/irq.h> instead */
+#ifndef DEFINE_TRACE_FMT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+DEFINE_TRACE_FMT(irq_handler_entry,
+	TPPROTO(int irq, struct irqaction *action),
+	TPARGS(irq, action),
+	TPFMT("irq=%d handler=%s", irq, action->name));
+
+DEFINE_TRACE_FMT(irq_handler_exit,
+	TPPROTO(int irq, struct irqaction *action, int ret),
+	TPARGS(irq, action, ret),
+	TPFMT("irq=%d handler=%s return=%s",
+		irq, action->name, ret ? "handled" : "unhandled"));
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index fdff380..bcebc2e 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -18,6 +18,7 @@
 #include <linux/rculist.h>
 #include <linux/hash.h>
 #include <linux/bootmem.h>
+#include <trace/irq.h>
 
 #include "internals.h"
 
@@ -338,6 +339,9 @@ irqreturn_t no_action(int cpl, void *dev_id)
 	return IRQ_NONE;
 }
 
+DEFINE_TRACE(irq_handler_entry);
+DEFINE_TRACE(irq_handler_exit);
+
 /**
  * handle_IRQ_event - irq action chain handler
  * @irq:	the interrupt number
@@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 		local_irq_enable_in_hardirq();
 
 	do {
+		trace_irq_handler_entry(irq, action);
 		ret = action->handler(irq, action->dev_id);
+		trace_irq_handler_exit(irq, action, ret);
 		if (ret == IRQ_HANDLED)
 			status |= action->flags;
 		retval |= ret;
diff --git a/kernel/trace/events.c b/kernel/trace/events.c
index 38c89ee..3c75623 100644
--- a/kernel/trace/events.c
+++ b/kernel/trace/events.c
@@ -6,8 +6,10 @@
 
 /* trace/<type>.h here */
 #include <trace/sched.h>
+#include <trace/irq.h>
 
 #include "trace_events.h"
 
 /* trace/<type>_event_types.h here */
 #include <trace/sched_event_types.h>
+#include <trace/irq_event_types.h>






