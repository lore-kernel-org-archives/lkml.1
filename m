Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZCHWDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZCHWDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZCHWDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:03:25 -0400
Received: from 1wt.eu ([62.212.114.60]:1187 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZCHWDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:03:24 -0400
Date: Sun, 8 Mar 2009 23:03:19 +0100
From: Willy Tarreau <w@1wt.eu>
To: Balazs Scheidler <bazsi@balabit.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: scheduler oddity [bug?]
Message-ID: <20090308220319.GA570@1wt.eu>
References: <1236448069.16726.21.camel@bzorp.balabit> <1236451624.16726.32.camel@bzorp.balabit> <1236541524.19045.6.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236541524.19045.6.camel@bzorp.balabit>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balazs,

On Sun, Mar 08, 2009 at 08:45:24PM +0100, Balazs Scheidler wrote:
> On Sat, 2009-03-07 at 19:47 +0100, Balazs Scheidler wrote:
> > On Sat, 2009-03-07 at 18:47 +0100, Balazs Scheidler wrote:
> > > Hi,
> > > 
> > > I've tested this on 3 computers and each showed the same symptoms:
> > >  * quad core Opteron, running Ubuntu kernel 2.6.27-13.29
> > >  * Core 2 Duo, running Ubuntu kernel 2.6.27-11.27
> > >  * Dual Core Opteron, Debian backports.org kernel 2.6.26-13~bpo40+1
> > > 
> > > Is this a bug, or a feature?
> > > 
> > 
> > One new interesting information: I've retested with a 2.6.22 based
> > kernel, and it still works there, setting the CPU affinity does not
> > change the performance of the test program and mpstat nicely shows that
> > 2 cores are working, not just one.
> > 
> > Maybe this is CFS related? That was merged for 2.6.23 IIRC.
> > 
> > Also, I tried changing various scheduler knobs
> > in /proc/sys/kernel/sched_* but they didn't help. I've tried to change
> > these:
> > 
> >  * sched_migration_cost: changed from the default 500000 to 100000 and
> > then 10000 but neither helped.
> >  * sched_nr_migrate: increased it to 64, but again nothing
> > 
> > I'm starting to think that this is a regression that may or may not be
> > related to CFS. 
> > 
> > I don't have a box where I could bisect on, but the test program makes
> > the problem quite obvious.
> 
> Some more test results:
> 
> Latest tree from Linus seems to work, at least the program runs on both
> cores as it should. I bisected the patch that changed behaviour, and
> I've found this:
> 
> commit 38736f475071b80b66be28af7b44c854073699cc
> Author: Gautham R Shenoy <ego@in.ibm.com>
> Date:   Sat Sep 6 14:50:23 2008 +0530
> 
>     sched: fix __load_balance_iterator() for cfq with only one task
>     
>     The __load_balance_iterator() returns a NULL when there's only one
>     sched_entity which is a task. It is caused by the following code-path.
>     
>     	/* Skip over entities that are not tasks */
>     	do {
>     		se = list_entry(next, struct sched_entity, group_node);
>     		next = next->next;
>     	} while (next != &cfs_rq->tasks && !entity_is_task(se));
>     
>     	if (next == &cfs_rq->tasks)
>     		return NULL;
>     	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>           This will return NULL even when se is a task.
>     
>     As a side-effect, there was a regression in sched_mc behavior since 2.6.25,
>     since iter_move_one_task() when it calls load_balance_start_fair(),
>     would not get any tasks to move!
>     
>     Fix this by checking if the last entity was a task or not.
>     
>     Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
>     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> This patch was integrated for 2.6.28. With the above patch, my test program uses 
> two cores as it should. I could only test this in a virtual machine so I don't 
> know exact performance metrics, but I'll test 2.6.27 + plus this patch on a real 
> box tomorrow to see if this was the culprit.

Just tested right here and I can confirm it is the culprit. I can reliably
reproduce the issue here on my core2 duo, and this patch fixes it. With your
memset() loop at 20k iterations, I saw exactly 50% CPU usage, and a final
sum of 794. With the patch, I see 53% CPU and 909. Changing the loop to 80k
iterations shows 53% CPU usage and 541 loops without the patch, versus
639 loops and 63% CPU usage with the patch.

So there's clearly a big win.

On a related note, I've often noticed that my kernel builds with -j 2 often
only use once CPU. I'm wondering whether this could be related to the same
issue. Just testing, I don't notice this with the patch. I'll have to retry
without later.

> I'm not sure if this is related to the avg_overlap discussion (which I honestly 
> don't really understand :)

neither do I :-)

Regards,
Willy

