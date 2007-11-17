Return-Path: <linux-kernel-owner+w=401wt.eu-S1765606AbXKQSxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765606AbXKQSxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbXKQSxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:53:13 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63867 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbXKQSxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:53:13 -0500
Date: Sat, 17 Nov 2007 13:52:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH v3 16/17] Fix schedstat handling
In-Reply-To: <473EE151.BA47.005A.0@novell.com>
Message-ID: <Pine.LNX.4.58.0711171351320.12054@gandalf.stny.rr.com>
References: <20071117062104.177779113@goodmis.org> <20071117062405.634159013@goodmis.org>
 <473EE151.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 17 Nov 2007, Gregory Haskins wrote:

> >>> On Sat, Nov 17, 2007 at  1:21 AM, in message
> <20071117062405.634159013@goodmis.org>, Steven Rostedt <rostedt@goodmis.org>
> wrote:
> > Gregory Haskins RT balancing broke sched domains.
>
> Doh! (though you mean s/domains/stats ;)

Heh, indeed.

>
> > This is a fix to allow it to still work.
> >
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> >
> > ---
> >  include/linux/sched.h   |    3 ++-
> >  kernel/sched.c          |   17 ++++++++++++++---
> >  kernel/sched_fair.c     |   19 ++++++++++++++-----
> >  kernel/sched_idletask.c |    3 ++-
> >  kernel/sched_rt.c       |    3 ++-
> >  5 files changed, 34 insertions(+), 11 deletions(-)
> >
> > Index: linux-compile.git/kernel/sched.c
> > ===================================================================
> > --- linux-compile.git.orig/kernel/sched.c	2007-11-17 00:15:57.000000000 -0500
> > +++ linux-compile.git/kernel/sched.c	2007-11-17 00:15:57.000000000 -0500
> > @@ -1453,6 +1453,7 @@ static int try_to_wake_up(struct task_st
> >  	unsigned long flags;
> >  	long old_state;
> >  	struct rq *rq;
> > +	struct sched_domain *this_sd = NULL;
> >  #ifdef CONFIG_SMP
> >  	int new_cpu;
> >  #endif
> > @@ -1476,10 +1477,20 @@ static int try_to_wake_up(struct task_st
> >  	schedstat_inc(rq, ttwu_count);
> >  	if (cpu == this_cpu)
> >  		schedstat_inc(rq, ttwu_local);
> > -	else
> > -		schedstat_inc(rq->sd, ttwu_wake_remote);
> > +	else {
> > +#ifdef CONFIG_SCHEDSTATS
> > +		struct sched_domain *sd;
> > +		for_each_domain(this_cpu, sd) {
> > +			if (cpu_isset(cpu, sd->span)) {
> > +				schedstat_inc(sd, ttwu_wake_remote);
> > +				this_sd = sd;
> > +				break;
> > +			}
> > +		}
> > +#endif /* CONFIG_SCHEDSTATES */
> > +	}
> >
> > -	new_cpu = p->sched_class->select_task_rq(p, sync);
> > +	new_cpu = p->sched_class->select_task_rq(p, this_sd, sync);
>
> I like this optimization, but I am thinking that the location of the stat update is now no longer relevant.  It should potentially go *after* the select_task_rq() so that we pick the sched_domain of the actual wake target, not the historical affinity.  If that is accurate, I'm sure you can finagle this optimization to work in that scenario too, but it will take a little re-work.

Yeah, I can take a deep look. This was written late at night, so I need to
spend more "awake" hours on it.

-- Steve

