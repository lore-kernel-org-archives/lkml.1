Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZISIDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZISIDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZISIDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:03:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:18312 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZISIDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A008nO98k0U1KZSnZkC5QcmlHzy3D0qCIpLTiqBKDgV8q3IRf4xyD3wYANKAnHBrbt
         utBLDT34MZjO0SN6slJZmRQ6i/WZUjE6s3gxgNdQ7S+8WbBMHmHl6K3CXQMLzrxoYxAL
         QxH8py8UvB16UVEEMZyv5FoqZxGMRBURklnbc=
Date: Sat, 19 Sep 2009 10:03:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 0/2 v3] tracing: Tracing event profiling updates
Message-ID: <20090919080320.GC5226@nowhere>
References: <1253247854-5496-1-git-send-email-fweisbec@gmail.com> <1253252178-5315-1-git-send-email-fweisbec@gmail.com> <20090919073400.GE15292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919073400.GE15292@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 09:34:00AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 
> > Ingo,
> > 
> > Hopefully this is my last attempt.
> > This new iteration fixes the syscalls events to correctly handle
> > the buffer. In the previous version, they did not care about interrupts.
> > 
> > I only resend the second patch as only this one has changed since the v2.
> > 
> > The new branch is in:
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	tracing/core-v3
> > 
> > Thanks,
> > 	Frederic.
> > 
> > Frederic Weisbecker (2):
> >       tracing: Factorize the events profile accounting
> >       tracing: Allocate the ftrace event profile buffer dynamically
> > 
> >  include/linux/ftrace_event.h       |   10 +++-
> >  include/linux/syscalls.h           |   24 +++-----
> >  include/trace/ftrace.h             |  111 ++++++++++++++++++++---------------
> >  kernel/trace/trace_event_profile.c |   79 +++++++++++++++++++++++++-
> >  kernel/trace/trace_syscalls.c      |   97 +++++++++++++++++++++++++------
> >  5 files changed, 234 insertions(+), 87 deletions(-)
> 
> Hm, the naming is quite confusing here i think:
> 
>   -132,8 +133,12 @@ struct ftrace_event_call {
>          atomic_t                profile_count;
>          int                     (*profile_enable)(void);
>          void                    (*profile_disable)(void);
>  +       char                    *profile_buf;
>  +       char                    *profile_buf_nmi;
> 
> These are generic events, not just 'profiling' histograms.
> 
> Generic events can have _many_ output modi:
> 
>  - SVGs                   (perf timeline)
>  - histograms             (perf report)
>  - traces                 (perf trace)
>  - summaries / maximums   (perf sched lat)
>  - maps                   (perf sched map)
>  - graphs                 (perf report --call-graph)
> 
> So it's quite a misnomer to talk just about profiling here. This is an 
> event record buffer.



Agreed, I guess we can call the perf_event_buf/perf_event_nmi.
Also may be the profile_enable/profile_disable should follow the
renaming logic.



> Also, what is the currently maximum possible size of ->profile_buf? The 
> max size of an event record? The new codepath looks a bit heavy with 
> rcu-lock/unlock and other bits put inbetween - and this is now in the 
> event sending critical path. Cannot we do a permanent buffer that needs 
> no extra locking/reference protection?
> 
> Is the whole thing even justified? I mean, we keep the size of records 
> low anyway. It's a _lot_ easier to handle on-stack records, they are the 
> ideal (and very fast) dynamic allocator which is NMI and IRQ safe, etc.
> 
> 	Ingo


The max size of an event is undefined once it uses either
a __dynamic_array() or __string() field. (The latter is a subset
of the former anyway).

Those are very special fields that can handle dynamic size arrays.
That makes such events having an unpredictable size each time they
are triggered.

That said, we are currently using a stack based buffer. That coupled
with the unpredicatble event size must really be fixed. I mean, we don't
want to run out of the stack boundaries once an event get a long string,
once a new large event is added, or once an event is randomly triggered
in a path where the stack is already deeply dug.

I've done this easy stack based as a first shot to support ftrace raw
events by perf, but now this becomes something that needs to be fixed
IMO.

I've made this rcu based thing to avoid wasting the buffer in memory
(for each cpu) while we are not profiling the raw events.

I could drop that and keep these buffers static, but this seems
wasteful wrt memory footprint while profiling/tracing is inactive.

