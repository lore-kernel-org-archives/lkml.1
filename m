Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbZDCOMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbZDCOMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZDCOMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:12:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZDCOMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:12:23 -0400
Date: Fri, 3 Apr 2009 10:12:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tom Zanussi <tzanussi@gmail.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only when
 not tracing
In-Reply-To: <20090403135956.GD8875@elte.hu>
Message-ID: <alpine.DEB.2.00.0904031010510.965@gandalf.stny.rr.com>
References: <1238390546.6368.65.camel@bookworm> <20090401122408.GG12966@elte.hu> <1238653371.6655.48.camel@bookworm> <20090403135956.GD8875@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Apr 2009, Ingo Molnar wrote:

> 
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > On Wed, 2009-04-01 at 14:24 +0200, Ingo Molnar wrote:
> > > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > > 
> > > > This patch adds code allowing the event filter to be set only if 
> > > > there's no active tracing going on.
> > > 
> > > > --- a/kernel/trace/trace_events.c
> > > > +++ b/kernel/trace/trace_events.c
> > > > @@ -498,6 +498,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> > > >  	struct filter_pred *pred;
> > > >  	int err;
> > > >  
> > > > +	if (tracing_is_enabled() && (!tracer_is_nop() || call->enabled))
> > > > +		return -EBUSY;
> > > 
> > > hm, but it would be the normal use-case to set filters on the fly. 
> > > To experiment around with them and shape them until the output is 
> > > just right. Having to turn the tracer on/off during that seems quite 
> > > counterproductive to that use-case.
> > > 
> > 
> > I didn't see anything that could be used to temporarily disable 
> > tracing (tracing_stop() and tracing_start() are 'quick' versions 
> > that mostly just disable recording), so did it this way to avoid 
> > adding any overhead to the filter-checking code.
> > 
> > But anyway, I'll post a new patch shortly that uses rcu and does 
> > allow the filters to be set on the fly.
> 
> that's a very intelligent way to do it!
> 
> There's a theoretical problem though: what if we put a filtered 
> tracepoint into the RCU code? Especially if that tracepoint is in 
> the common function-tracer callback affecting all kernel functions. 
> I've Cc:-ed Paul. I think the quiescent state logic should handle 
> this just fine, but i'm not 100% sure.

I commented about this too. I feel the safest way is to simply use 
preempt_disable, and instead of synchronize_rcu, we can use 
synchronize_sched, which should have the same effect.

-- Steve

