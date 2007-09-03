Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbXICUEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbXICUEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 16:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXICUEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 16:04:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44834 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbXICUEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 16:04:11 -0400
Date: Mon, 3 Sep 2007 22:04:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
Message-ID: <20070903200405.GA2943@elte.hu>
References: <20070902120154.GA23769@elte.hu> <Pine.LNX.4.64.0709032030320.1817@scrub.home> <20070903185403.GA23479@elte.hu> <Pine.LNX.4.64.0709032106070.1817@scrub.home> <20070903192050.GA29049@elte.hu> <Pine.LNX.4.64.0709032140140.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709032140140.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Mon, 3 Sep 2007, Ingo Molnar wrote:
> 
> > My next question then is about this code of yours in the wakeup path:
> > 
> >  +static void
> >  +enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >  +{
> >  +       kclock_t min_time;
> >  +
> >  +       verify_queue(cfs_rq, cfs_rq->curr != se, se);
> >  +       min_time = get_time_avg(cfs_rq) - se->req_weight_inv;
> >  +       if ((kclock_t)(se->time_norm - min_time) < 0)
> >  +               se->time_norm = min_time;
> > 
> > why do you only use the "min_time" if the pre-sleep time_norm is smaller 
> > than the min_time? Here 'min_time' is close to the current average. 
> 
> It's a variation of the sleeper bonus. [...]

hm, where are its effects described in your explanation? Seems like a 
key item.

> [...]  Let's assume two running tasks which have been running for 95ms 
> and 105ms and a time slice of 10ms, the average is thus 100ms. If the 
> new task has been sleeping for a while it starts at 90ms, if the task 
> had been running lately it doesn't get this bonus again.

what happens if there are lots of such tasks? What limits the total 
bonus?

> > Shouldnt here the woken up task be set to the average time, like i 
> > did it in the crude prototype:
> > 
> > +               se->exec_runtime = avg_exec_runtime(cfs_rq);
> 
> That would be equivalent to simply clearing wait_runtime in CFS.

so my prototype patch is not an exact map of the nice-0 special-case of 
your code? Would this be the correct thing then perhaps:

+               se->exec_runtime =
+                       max(avg_exec_runtime(cfs_rq), se->exec_runtime);

Or if not, could you suggest a code-line at that place? Thanks,

	Ingo
