Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZBYA7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZBYA7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 19:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBYA7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 19:59:09 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:34727 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753320AbZBYA7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 19:59:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQFAAQhpElMQWXi/2dsb2JhbACBb9YKhBEG
Date: Tue, 24 Feb 2009 19:59:04 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 0/4][RFC] event tracer
Message-ID: <20090225005903.GA16396@Krystal>
References: <20090224193344.638329210@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090224193344.638329210@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:58:26 up 3 days, 16:32,  3 users,  load average: 0.40, 0.40,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> This is still RFC, do not pull.
> 
> This patch set gives the ability to add a format string and args to
> a trace point declaration. Then it gives a tracer an opportunity to
> override the header macro and use the default trace format to trace
> the object.
> 
> For example (and used in this patch series), the sched tracepoint
> declarations are moved from include/trace/sched.h to
> include/trace/sched_event_types.h, and instead of using the macro
> DECLARE_TRACE we use DECLARE_TRACE_FMT. The first three arguments
> are the same, but it adds 2 more arguments. A printf format and
> arguments.
> 
> The new trace/sched.h file contains:
> 
>   #include <linux/sched.h>
>   #include <linux/tracepoint.h>
> 
>   #include <trace/sched_event_types.h>
> 
> The sched_event_types.h file has:
> 
>  DECLARE_TRACE_FMT(sched_kthread_stop,
>         TPPROTO(struct task_struct *t),
>                   TPARGS(t),
>                    "task %s:%d", TPARGS(t->comm, t->pid));
> 
> The tracepoint.h defines DECLARE_TRACE_FMT as:
> 
>  #define DECLARE_TRACE_FMT(name, proto, args, fmt, fmt_args) \
>         DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
> 
> 
> But in kernel/trace/events.c we have:
> 
>  /* trace/<type>.h here */
>  #include <trace/sched.h>
> 
>  #include "trace_events.h"
> 
>  /* trace/<type>_event_types.h here */
>  #include <trace/sched_event_types.h>
> 
> The trace_events.h redefines the DECLARE_TRACE_FMT and makes a hook
> for to automate adding event points.
> 
> To add event points, convert to the DECLARE_TRACE_FMT, add your default
> printf format, and then add to events.c, the <type>.h and <type>_event_types.h
> as described. Then your trace points will appear in the event tracer.
> 
> Next I'll convert the rest of the tracepoints that are already defined
> to this format.
> 

Hi Steve,

The approach sounds great : an hybrid between markers and tracepoints.
I'll dig into it. That would be useful for LTTng.

Mathieu

> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: rfc/event_tracer
> 
> 
> Steven Rostedt (4):
>       tracing: add event trace infrastructure
>       tracing: add DECLARE_TRACE_FMT to tracepoint.h
>       tracing: add schedule events to event trace
>       tracing: make event directory structure
> 
> ----
>  include/asm-generic/vmlinux.lds.h |   11 +-
>  include/linux/tracepoint.h        |    3 +
>  include/trace/sched.h             |   49 +-----
>  include/trace/sched_event_types.h |   74 +++++++
>  kernel/trace/Kconfig              |    9 +
>  kernel/trace/Makefile             |    2 +
>  kernel/trace/events.c             |   13 ++
>  kernel/trace/trace_events.c       |  407 +++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_events.h       |   52 +++++
>  9 files changed, 571 insertions(+), 49 deletions(-)
> -- 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
