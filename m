Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZBWQXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZBWQXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZBWQXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:23:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:8550 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZBWQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IxCJOFtMzAZgYbfCVe/kmQ3PUTx5ycqckWFJ8TlQfjGEkCMVsMq3L4alvLWwV+yaLH
         edmRrdp35IjUwuzAno4YuwRXkkOg3soKJSakXU+JWgWO62460qoOBz8H9/i0TeP60dqb
         rGzzT9R60la10ip+wC+wdF8IsbxGjDpcSxUxY=
Date: Mon, 23 Feb 2009 17:22:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] tracing/ftrace: add missing wake-up on some callsites
Message-ID: <20090223162257.GF5961@nowhere>
References: <49a1cc8f.2283420a.54d2.ffff8461@mx.google.com> <alpine.DEB.2.00.0902231034570.18221@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902231034570.18221@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 10:37:52AM -0500, Steven Rostedt wrote:
> 
> 
> On Sun, 22 Feb 2009, Frederic Weisbecker wrote:
> 
> > Impact: fix unwaken pipe
> > 
> > Now that we use a common wakeup infrastructure, we must append a wakeup
> > on few callsites which lack it or tasks reading trace_pipe will not be
> > awaken when events come on few tracers.
> > 
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace.c             |    2 ++
> >  kernel/trace/trace_branch.c      |    2 ++
> >  kernel/trace/trace_hw_branches.c |    2 ++
> >  3 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index e1f3b99..7f450b6 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -3055,6 +3055,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
> >   out:
> >  	preempt_enable_notrace();
> >  
> > +	trace_wake_up();
> > +
> >  	return len;
> >  }
> >  EXPORT_SYMBOL_GPL(trace_vprintk);
> > diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> > index c2e68d4..8c8f8c0 100644
> > --- a/kernel/trace/trace_branch.c
> > +++ b/kernel/trace/trace_branch.c
> > @@ -78,6 +78,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
> >   out:
> >  	atomic_dec(&tr->data[cpu]->disabled);
> >  	local_irq_restore(flags);
> > +
> > +	trace_wake_up();
> >  }
> >  
> >  static inline
> > diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> > index 3561aac..ddd87fd 100644
> > --- a/kernel/trace/trace_hw_branches.c
> > +++ b/kernel/trace/trace_hw_branches.c
> > @@ -202,6 +202,8 @@ void trace_hw_branch(u64 from, u64 to)
> >   out:
> >  	atomic_dec(&tr->data[cpu]->disabled);
> >  	local_irq_restore(irq1);
> > +
> > +	trace_wake_up();
> >  }
> >  
> >  static void trace_bts_at(const struct bts_trace *trace, void *at)
> 
> Ah, we don't wake up purposely on these three places. ftrace_printk is 
> meant to be called anywhere (including the scheduler). And the branch 
> tracers are also allowed to be called anywhere (they usually are).
> 
> Calling "wake_up" from any of these can easily cause a dead lock with the 
> run queue lock, because all three can be called from with in the 
> scheduler.
> 
> Sorry, but I have to NACK this change.


And fortunately you NACK, I didn't realized how dangerous it can be.
I will send a patch to make these branch tracers use the old polling wake up.

But another solution should be found for ftrace_printk() since it doesn't necessarily
rely on any tracer.

 
> -- Steve

