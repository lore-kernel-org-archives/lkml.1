Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYJFVNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYJFVNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 17:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYJFVNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 17:13:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYJFVNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 17:13:37 -0400
Date: Mon, 6 Oct 2008 23:19:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power optimization
Message-ID: <20081006211939.GL3180@one.firstfloor.org>
References: <20081006102640.481acd23@infradead.org> <87y711moz2.fsf@basil.nowhere.org> <20081006135715.6a52e954@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006135715.6a52e954@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 01:57:15PM -0700, Arjan van de Ven wrote:
> 
> the problem is that higher up the actual P state isn't known.

My main worry is that every architecture is going to implement
their own version of this plugin if there isn't some abstraction.
 
> > Also I suspect some higher level format would be good here too.
> > Just put the frequency in? 
> 
> the link between P states and frequency is... rather lose.
> Especially with Turbo Mode it no longer is really relevant to list
> frequencies.

It would probably be less confusing for everyone if the higher level
cpufreq layers reported the correct frequency for turbo mode too.
I haven't checked how complicated this would be.

> 
> > > +			ret = trace_seq_printf(s, "[%5ld.%09ld]
> > > CSTATE: Going to C%i on cpu %i for %ld.%09ld\n",
> > > +					  stamp.tv_sec,
> > > +					  stamp.tv_nsec,
> > > +					  it->state, iter->cpu,
> > > +					  duration.tv_sec,
> > > +					  duration.tv_nsec);
> > > +		if (it->type == POWER_PSTATE)
> > > +			ret = trace_seq_printf(s, "[%5ld.%09ld]
> > > PSTATE: Going to P%i on cpu %i\n",
> > > +					  stamp.tv_sec,
> > > +					  stamp.tv_nsec,
> > > +					  it->state, iter->cpu);
> > 
> > I suspect a less verbose output format would be better.
> why?

to shuffle less data around

> It's fine as it is, and it's actually human readable as well.

I suspect humans could well do with something more compact too

e.g.

CPU %d -> P%d

> 
> > 
> > > +{
> > > +	if (!trace_power_enabled)
> > > +		return;
> > > +
> > > +	memset(it, 0, sizeof(struct power_trace));
> > 
> > The memset seems redundant.
> 
> it's free and it initializes the datastructure cleanly; and only when

AFAIK all data fields are init'ed anyways.

How is it free? I'm not sure gcc will optimize it away completely.

I thought the point of ftrace tracers was to be reasonably efficient
when they are enabled?  If efficiency doesn't matter you could
as well use printk.

> > Hmm, that does a unconditional wake_up() in idle. Doesn't this cause
> > a loop on UP?
> > 
> > idle -> wakeup -> idle -> wakeup -> ... etc.
> > 
> > Am I missing something?
> 
> yes you're missing something ;-)
> this code is called when going out of idle, not when going into idle.

Ok.

That means that when a CPU is idle forever there won't be any output?

-Andi

-- 
ak@linux.intel.com
