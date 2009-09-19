Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZISHeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZISHeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZISHeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:34:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZISHeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:34:11 -0400
Date: Sat, 19 Sep 2009 09:34:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 0/2 v3] tracing: Tracing event profiling updates
Message-ID: <20090919073400.GE15292@elte.hu>
References: <1253247854-5496-1-git-send-email-fweisbec@gmail.com> <1253252178-5315-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253252178-5315-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 
> Ingo,
> 
> Hopefully this is my last attempt.
> This new iteration fixes the syscalls events to correctly handle
> the buffer. In the previous version, they did not care about interrupts.
> 
> I only resend the second patch as only this one has changed since the v2.
> 
> The new branch is in:
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core-v3
> 
> Thanks,
> 	Frederic.
> 
> Frederic Weisbecker (2):
>       tracing: Factorize the events profile accounting
>       tracing: Allocate the ftrace event profile buffer dynamically
> 
>  include/linux/ftrace_event.h       |   10 +++-
>  include/linux/syscalls.h           |   24 +++-----
>  include/trace/ftrace.h             |  111 ++++++++++++++++++++---------------
>  kernel/trace/trace_event_profile.c |   79 +++++++++++++++++++++++++-
>  kernel/trace/trace_syscalls.c      |   97 +++++++++++++++++++++++++------
>  5 files changed, 234 insertions(+), 87 deletions(-)

Hm, the naming is quite confusing here i think:

  -132,8 +133,12 @@ struct ftrace_event_call {
         atomic_t                profile_count;
         int                     (*profile_enable)(void);
         void                    (*profile_disable)(void);
 +       char                    *profile_buf;
 +       char                    *profile_buf_nmi;

These are generic events, not just 'profiling' histograms.

Generic events can have _many_ output modi:

 - SVGs                   (perf timeline)
 - histograms             (perf report)
 - traces                 (perf trace)
 - summaries / maximums   (perf sched lat)
 - maps                   (perf sched map)
 - graphs                 (perf report --call-graph)

So it's quite a misnomer to talk just about profiling here. This is an 
event record buffer.

Also, what is the currently maximum possible size of ->profile_buf? The 
max size of an event record? The new codepath looks a bit heavy with 
rcu-lock/unlock and other bits put inbetween - and this is now in the 
event sending critical path. Cannot we do a permanent buffer that needs 
no extra locking/reference protection?

Is the whole thing even justified? I mean, we keep the size of records 
low anyway. It's a _lot_ easier to handle on-stack records, they are the 
ideal (and very fast) dynamic allocator which is NMI and IRQ safe, etc.

	Ingo
