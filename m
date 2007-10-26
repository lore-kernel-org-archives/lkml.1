Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbXJZAF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbXJZAF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbXJZAFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:05:14 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:38978 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXJZAFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:05:12 -0400
Date: Thu, 25 Oct 2007 20:03:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 2/3] RT: Cache cpus_allowed weight for optimizing migration
In-Reply-To: <1193346777.7561.47.camel@ghaskins-t60p.haskins.net>
Message-ID: <Pine.LNX.4.58.0710251959140.8347@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net> 
 <20071025144628.19876.35583.stgit@novell1.haskins.net> 
 <Pine.LNX.4.58.0710251131060.5639@gandalf.stny.rr.com> 
 <1193338312.4021.53.camel@ghaskins-t60p.haskins.net> 
 <Pine.LNX.4.58.0710251536190.5152@gandalf.stny.rr.com>
 <1193346777.7561.47.camel@ghaskins-t60p.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Thu, 25 Oct 2007, Gregory Haskins wrote:
> > > > >  /* Will lock the rq it finds */
> > > > >  static struct rq *find_lock_lowest_rq(struct task_struct *task,
> > > > >  				      struct rq *this_rq)
> > > > > @@ -295,6 +334,28 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
> > > > >  	int cpu;
> > > > >  	int tries;
> > > > >
> > > > > + 	/*
> > > > > + 	 * We can optimize if the hamming weight of the cpus_allowed mask
> > > > > + 	 * is 1 because the task has nowhere to go but one CPU.  So don't
> > > > > + 	 * waste the time trying to find the lowest RQ in this case.
> > > > > + 	 */
> > > >
> > > > This code should be in the pick_next_highest_rt and not here.
> > >
> > > I disagree, but I admit it is not apparent at this level of the series
> > > why.  The reason has to do with optimizing the wakeup path.  Unless I am
> > > missing something, I think this placement is optimal, and that will
> > > hopefully become apparent when you see the rest of my series.
> >
> > Then move the code there then. One can't be analyzing patches when code
> > isn't apparent that determines changes.  Those changes need to be
> > together.  Especially since they may not be applied.
>
> The correctness of this particular change (IMO) is not predicated on the
> later patches, otherwise I would have done just that.  It accomplishes
> what I intended as is here in this patch.
>
> Why do you think moving the logic to pick_next_highest is a better
> design?  To be honest, I haven't really studied your new logic in
> push_rt_tasks to understand why you might feel this way.  If you can
> make the case that it is better in the other location then I agree with
> you that we should move it there in this patch, and potentially adjust
> it later.  Until then, I see no problem with it being here.

Ah, after reading the comment in your code, I might know where our
miscommunication is from.  When you hit a task that can't migrate, you
simply stop and don't bother looking for a lowest rq to place it on.

I'm saying to do one better. Put the code in the pick_next_highest_task_rt
and _skip_ rt tasks with nr_cpus_allowed == 1. So we can then look to
migrate another RT task that is lower in priority than a bounded RT task.

Does this clear up what I'm trying to say?

BTW, stop looking for a lowest_rq isn't really an optimization here. Since
we only look at cpus that are in the tasks cpu affinity mask and we skip
the cpu that it currently is on. So we don't even take a lock in that
case.

-- Steve

