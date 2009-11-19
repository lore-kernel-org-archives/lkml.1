Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZKSWl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZKSWl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 17:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZKSWl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 17:41:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:45889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbZKSWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 17:41:27 -0500
Subject: Re: [PATCH 3/7 v6] perf/core: Add a callback to perf events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20091119154349.GA4967@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
	 <1257694141-5670-4-git-send-email-fweisbec@gmail.com>
	 <1258457333.7816.186.camel@laptop> <20091118001815.GA8187@nowhere>
	 <1258536669.3918.99.camel@laptop>  <20091119154349.GA4967@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 23:40:53 +0100
Message-ID: <1258670453.11284.278.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 16:43 +0100, Frederic Weisbecker wrote:
> On Wed, Nov 18, 2009 at 10:31:09AM +0100, Peter Zijlstra wrote:
> > On Wed, 2009-11-18 at 01:18 +0100, Frederic Weisbecker wrote:
> > > On Tue, Nov 17, 2009 at 12:28:53PM +0100, Peter Zijlstra wrote:
> > > > On Sun, 2009-11-08 at 16:28 +0100, Frederic Weisbecker wrote:
> > > > > A simple callback in a perf event can be used for multiple purposes.
> > > > > For example it is useful for triggered based events like hardware
> > > > > breakpoints that need a callback to dispatch a triggered breakpoint
> > > > > event.
> > > > > 
> > > > > v2: Simplify a bit the callback attribution as suggested by Paul
> > > > >     Mackerras
> > > > 
> > > > Yuck! So we add an opaque callback without semantics nor usage.
> > > 
> > > 
> > > Yeah, this is intended for events that need to be able to trigger
> > > events to different channels. In the case of hw-breakpoints, it's
> > > either perf buffer, ptrace, etc...
> > > 
> > > Should I add some comments about it?
> > 
> > At the very least.. describe its semantics and preferably rename the
> > thing.
> 
> 
> May be "event_triggered"?

What event? There is no caller.

> > Currently I've no clue what it does and why, your description above
> > about multiple channels does not at all help me understand how this
> > function pointer is used to make that happen.
> > 
> 
> 
> We need it for hardware breakpoints because if we register a breakpoint
> for perf syscall use, we need to dispatch the event to perf. But if we
> register it for ptrace, or any in-kernel uses, we need to dispatch the
> event somewhere else and then we need another callback.

So you simply want to have a different overflow/sample handler?

Doesn't something like the below work? We need that anyway for kernel
based consumers that want to do anything with the sampling event.

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -567,6 +567,8 @@ struct perf_pending_entry {
 
 typedef void (*perf_callback_t)(struct perf_event *, void *);
 
+struct perf_sample_data;
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -658,6 +660,10 @@ struct perf_event {
 	struct pid_namespace		*ns;
 	u64				id;
 
+	void (*overflow_handler)(struct perf_event *event,
+			int nmi, struct perf_sample_data *data,
+			struct pt_regs *regs);
+
 #ifdef CONFIG_EVENT_PROFILE
 	struct event_filter		*filter;
 #endif
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3710,7 +3710,11 @@ static int __perf_event_overflow(struct 
 			perf_event_disable(event);
 	}
 
-	perf_event_output(event, nmi, data, regs);
+	if (event->overflow_handler)
+		event->overflow_handler(event, nmi, data, regs);
+	else
+		perf_event_output(event, nmi, data, regs);
+
 	return ret;
 }
 
@@ -4836,6 +4849,8 @@ inherit_event(struct perf_event *parent_
 	if (parent_event->attr.freq)
 		child_event->hw.sample_period = parent_event->hw.sample_period;
 
+	child_event->overflow_handler = parent->overflow_handler;
+
 	/*
 	 * Link it up in the child's context:
 	 */


