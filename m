Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbZD3Iq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbZD3Iq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZD3IqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:46:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbZD3IqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:46:16 -0400
Date: Thu, 30 Apr 2009 10:45:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 00/19] tracing/workqueue: events support/enhancements,
	worklets tracing, fixes
Message-ID: <20090430084529.GA27479@elte.hu>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
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

> Hi,
> 
> This patchset brings various features for the workqueue tracer.
> 
> The support of events tracing (tracepoint expanding):
> 	- workqueue_creation
> 	- workqueue_flush
> 	- workqueue_destruction
> 
>     Also for the worklets:
> 	- worklet_enqueue
> 	- worklet_enqueue_delayed
> 	- worklet_execute
> 	- worklet_complete
> 	- worklet_cancel
> 
> Now, most of the lifecycle of worklets and workqueues is available.
> 
> The histogram tracing now also supports the worklets. You can
> measure the max and average execution time of a worklet.
> 
> A good bunch of Oleg's comments have been addressed, at least the
> critical ones (races which can cause freed pointer dereferences, memory
> leak, etc...). The rest is more about the design itself, such as using
> the workqueue as the identifier instead of the thread and other things
> that are in discussion.
> 
> Thanks!
> 
> Frederic.
> 
> The following changes since commit a0e39ed378fb6ba916522764cd508fa7d42ad495:
>   Heiko Carstens (1):
>         tracing: fix build failure on s390
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/workqueue
> 
> Frederic Weisbecker (6):
>       tracing/workqueue: turn cpu_workqueue_stats::inserted into unsigned int
>       tracing/workqueue: add execution time average column
>       tracing/workqueue: add open/release file handlers
>       tracing/workqueue: defer workqueue stat release if needed
>       tracing/workqueue: use the original cpu affinity on probe_workqueue_destruction
>       tracing/workqueue: provide documentation for the workqueue tracer
> 
> KOSAKI Motohiro (2):
>       workqueue_tracepoint: introduce workqueue_handler_exit tracepoint and rename workqueue_execution to workqueue_handler_entry
>       tracing/workqueue: add max execution time mesurement for per worklet
> 
> Zhaolei (11):
>       ftrace, workqueuetrace: make workqueue tracepoints use TRACE_EVENT macro
>       trace_workqueue: use list_for_each_entry() instead of list_for_each_entry_safe()
>       trace_workqueue: remove cpu_workqueue_stats->first_entry
>       trace_workqueue: remove blank line between each cpu
>       trace_workqueue: add worklet information
>       workqueue_tracepoint: add workqueue_flush and worklet_cancel tracepoint
>       workqueue_tracepoint: change tracepoint name to fit worklet and workqueue lifecycle
>       workqueue_trace: separate worklet_insertion into worklet_enqueue and worklet_enqueue_delayed
>       tracing/workqueue: turn workfunc_stats::inserted into unsigned int
>       tracing/workqueue: avoid accessing task_struct's member variable in stat file read
>       tracing/workqueue: use list_for_each_entry instead of list_for_each_entry_safe in probe_workqueue_destruction()
> 
>  Documentation/trace/workqueue.txt |  114 ++++++++++
>  include/trace/events/workqueue.h  |  200 +++++++++++++++++
>  include/trace/workqueue.h         |   25 --
>  kernel/trace/trace_stat.c         |    8 +
>  kernel/trace/trace_stat.h         |    3 +
>  kernel/trace/trace_workqueue.c    |  444 +++++++++++++++++++++++++++++--------
>  kernel/workqueue.c                |   45 +++--
>  7 files changed, 697 insertions(+), 142 deletions(-)
>  create mode 100644 Documentation/trace/workqueue.txt
>  create mode 100644 include/trace/events/workqueue.h
>  delete mode 100644 include/trace/workqueue.h

I think one worry here - and this mirrors some of Andrew's concerns 
- is the debug code to instrumented code ratio. There's 500 lines of 
instrumentation for 1000 lines of code.

Is there a chance we can reduce that ratio, by factoring out bits of 
kernel/trace/trace_workqueue.c and perhaps compressing 
include/trace/events/workqueue.h some more?

Also, it would be nice to check how intuitive it is to visualize 
workqueue related details using the user-space ftrace-analyzer tool. 

Kernel developers are one thing - but most of the Linux developers 
are user-space developers so any workqueue tracing details have to 
be intuitive (and useful) to them. (even though workqueues are a 
fundamentally in-kernel abstraction)

	Ingo
