Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbXJSTga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbXJSTga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbXJSTgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:36:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49182 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbXJSTgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:36:20 -0400
Subject: Re: [patch 6/8] pull RT tasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Paul Jackson <pj@sgi.com>
In-Reply-To: <1192821893.9471.17.camel@lappy>
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.983272715@goodmis.org>  <1192821893.9471.17.camel@lappy>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 21:35:30 +0200
Message-Id: <1192822530.9471.22.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 21:24 +0200, Peter Zijlstra wrote:
> On Fri, 2007-10-19 at 14:43 -0400, Steven Rostedt wrote:
> > plain text document attachment (rt-balance-pull-tasks.patch)
> 
> > +static int pull_rt_task(struct rq *this_rq)
> > +{
> > +	struct task_struct *next;
> > +	struct task_struct *p;
> > +	struct rq *src_rq;
> > +	int this_cpu = this_rq->cpu;
> > +	int cpu;
> > +	int ret = 0;
> > +
> > +	assert_spin_locked(&this_rq->lock);
> > +
> > +	if (likely(!atomic_read(&rt_overload)))
> > +		return 0;
> 
> This seems to be the only usage of rt_overload. I'm not sure its worth
> keeping it around for this.

Ingo just brought up a good point. With large smp (where large is >64)
this will all suck chunks.

rt_overload will bounce around the system, and the rto_cpumask updates
might already hurt.

The idea would be to do this per cpuset, these naturally limit the
migraiton posibilities of tasks and would thus be the natural locality
to break this data structure.

> > +	next = pick_next_task_rt(this_rq);
> > +
> > +	for_each_cpu_mask(cpu, rto_cpumask) {
> > +		if (this_cpu == cpu)
> > +			continue;
> 
> ...
> 
> > +	}
> > +
> > +	return ret;
> > +}
> 

