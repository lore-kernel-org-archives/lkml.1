Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbXIDCuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbXIDCuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 22:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXIDCud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 22:50:33 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2615 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXIDCud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 22:50:33 -0400
Date: Tue, 4 Sep 2007 04:50:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
In-Reply-To: <20070903200405.GA2943@elte.hu>
Message-ID: <Pine.LNX.4.64.0709040130360.1817@scrub.home>
References: <20070902120154.GA23769@elte.hu> <Pine.LNX.4.64.0709032030320.1817@scrub.home>
 <20070903185403.GA23479@elte.hu> <Pine.LNX.4.64.0709032106070.1817@scrub.home>
 <20070903192050.GA29049@elte.hu> <Pine.LNX.4.64.0709032140140.1817@scrub.home>
 <20070903200405.GA2943@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 3 Sep 2007, Ingo Molnar wrote:

> > It's a variation of the sleeper bonus. [...]
> 
> hm, where are its effects described in your explanation? Seems like a 
> key item.

It has no direct effect on the correctness of the mathematical model, the 
time is initialized before the time is added to the model.
What you're after is the effect on the behaviour, which wasn't my focus, 
so sorry, I didn't mention it.

> > [...]  Let's assume two running tasks which have been running for 95ms 
> > and 105ms and a time slice of 10ms, the average is thus 100ms. If the 
> > new task has been sleeping for a while it starts at 90ms, if the task 
> > had been running lately it doesn't get this bonus again.
> 
> what happens if there are lots of such tasks? What limits the total 
> bonus?

Every task gets a little more bonus, but it grows quite slowly, every task 
gets time_slice/task_cnt more than the previous one (assuming all tasks 
are started at the same time), so the 10th gets 2.82*time_slice, the 100th 
gets 5.18*time_slice, the 1000th gets 7.48*time_slice...

I thought about it already and I didn't consider it a serious problem, 
however it's solvable if needed by keeping the bonus separate:

	avg = avg_exec_runtime(cfs_rq);
	se->time_norm = kclock_max(avg - time_slice, se->time_norm);
	se->bonus = avg - se->time_norm;
	cfs_rq->time_sum += avg;

But the bonus also had to be undone when unqueueing the task:

	cfs_rq->time_sum -= se->time_norm + bonus;

> > That would be equivalent to simply clearing wait_runtime in CFS.
> 
> so my prototype patch is not an exact map of the nice-0 special-case of 
> your code? Would this be the correct thing then perhaps:
> 
> +               se->exec_runtime =
> +                       max(avg_exec_runtime(cfs_rq), se->exec_runtime);

You should substract the desired bonus here from the average as above and 
evtl. also store the given bonus separately.

bye, Roman
