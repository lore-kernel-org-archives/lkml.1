Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZDDHc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZDDHc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 03:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDDHcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 03:32:46 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:20871 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZDDHcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 03:32:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oIVF+aLfeMD3GiQWz59gk+A3XZZ7RpmkvsqPp2+EZEh0LnhRjotWyv1BxgL14WDKA+
         r7abSj/Ez4wuOyQC3G99EhU3k+dCpaDzedRWm5Iluxz0iaPj8T5sUjc6e7PoGFZGzmWO
         fiScrIL0TlQM5wIInRoHVAa6JC1ts9Fkr9fHE=
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
 when not tracing
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Paul E. McKenney" <paulmck@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
In-Reply-To: <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com>
References: <1238390546.6368.65.camel@bookworm>
	 <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm>
	 <20090403135956.GD8875@elte.hu>
	 <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 02:32:35 -0500
Message-Id: <1238830355.22495.55.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 10:12 -0400, Steven Rostedt wrote:
> On Fri, 3 Apr 2009, Ingo Molnar wrote:
> 
> > 
> > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > 
> > > On Wed, 2009-04-01 at 14:24 +0200, Ingo Molnar wrote:
> > > > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > > > 
> > > > > This patch adds code allowing the event filter to be set only if 
> > > > > there's no active tracing going on.
> > > > 
> > > > > --- a/kernel/trace/trace_events.c
> > > > > +++ b/kernel/trace/trace_events.c
> > > > > @@ -498,6 +498,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > > > >  	struct filter_pred *pred;
> > > > >  	int err;
> > > > >  
> > > > > +	if (tracing_is_enabled() && (!tracer_is_nop() || call->enabled))
> > > > > +		return -EBUSY;
> > > > 
> > > > hm, but it would be the normal use-case to set filters on the fly. 
> > > > To experiment around with them and shape them until the output is 
> > > > just right. Having to turn the tracer on/off during that seems quite 
> > > > counterproductive to that use-case.
> > > > 
> > > 
> > > I didn't see anything that could be used to temporarily disable 
> > > tracing (tracing_stop() and tracing_start() are 'quick' versions 
> > > that mostly just disable recording), so did it this way to avoid 
> > > adding any overhead to the filter-checking code.
> > > 
> > > But anyway, I'll post a new patch shortly that uses rcu and does 
> > > allow the filters to be set on the fly.
> > 
> > that's a very intelligent way to do it!
> > 
> > There's a theoretical problem though: what if we put a filtered 
> > tracepoint into the RCU code? Especially if that tracepoint is in 
> > the common function-tracer callback affecting all kernel functions. 
> > I've Cc:-ed Paul. I think the quiescent state logic should handle 
> > this just fine, but i'm not 100% sure.
> 
> I commented about this too. I feel the safest way is to simply use 
> preempt_disable, and instead of synchronize_rcu, we can use 
> synchronize_sched, which should have the same effect.
> 

Hmm, after reading Paul's replies, it sounds like this approach might be
more trouble than it's worth.  Maybe going back to the idea of
temporarily stopping/starting tracing would be a better idea, but with a
little more heavyweight version of the current 'quick' tracing
start/stop (that would prevent entering the tracing functions (and ththe
filter_check_discard()).

I was thinking it would be something like:

stop_tracing();
current_tracer->stop(); /* unregister tracepoints, etc */

remove filter

current_tracer->start(); /* reregister tracepoints, etc */
start_tracing();

The struct tracer comments suggest that the stop()/start()
ops are meant for pausing, I'd guess for things like this, but some of
the tracers don't implement them.

For the events in the event tracer, it would be something like:

stop_tracing();
call->unregfunc(); /* unregister tracepoint */

remove filter

call->regfunc(); /* reregister tracepoint */
start_tracing();

If that makes sense, I can try it that way instead.

Tom




