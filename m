Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXFNMfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXFNMfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXFNMe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:34:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42971 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXFNMez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:34:55 -0400
Date: Thu, 14 Jun 2007 18:13:24 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: dmitry.adamushko@gmail.com
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v15
Message-ID: <20070614124324.GB30965@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070531150908.GA23538@elte.hu> <20070606064228.GA22443@in.ibm.com> <20070606070143.GA7375@elte.hu> <20070606074317.GB3274@in.ibm.com> <b647ffbd0706060208i5666f57eoe96215b636617622@mail.gmail.com> <46668E4D.8060206@linux.vnet.ibm.com> <20070606105950.GA32729@in.ibm.com> <b647ffbd0706060419v1ed81e15w312f44aad8975d5b@mail.gmail.com> <20070606113733.GD3274@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606113733.GD3274@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:07:33PM +0530, Srivatsa Vaddagiri wrote:
> > I don't think that rt_sched_class :: dequeue_task_rt() is in any of
> > such "fast pathes" that we should really care about an additional
> > math. operation.
> > 
> > If this approach is ok, logically-wise (no side effects from a short
> > 'delta_exec', esp. on RT -> NORMAL).. I think it's better as it keeps
> > the 'sched_class' interface simpler.
> 
> I can see your point, given that we just update exec_start in
> dequeue_task_rt(). However the situation is slightly more complex in my
> patch stack, as I need to update other things during group change. Perhaps
> we can postpone this discussion until I post that patch stack.

Now that I have posted the group scheduling patch stack, we can come
back to this point.

Basically I am maintaining a ->curr field in 'struct lrq' (when
CONFIG_FAIR_GROUP_SCHED is on). It is NULL if the lrq is "inactive" [ none of 
its entities are currently running ], otherwise it points to the currentive 
active entity. This helps me optimize some functions like update_curr() - when 
lrq->curr is NULL, we don't have to update fair_clock etc upon enqueue/dequeue 
to the lrq.

pick_next_entity() sets lrq->curr while put_prev_entity resets lrq->curr
to NULL.

Also these lrqs could form a hierarchy. At the top could be a lrq which
holds user-level sched entities on each cpu. Next, each user's lrq could
hold task-level entities.

So when a task moves from RT class to NORMAL class, it will get added to
one of the lrqs (say root user's lrq on CPU0). At that time, I need to:

	root_user_lrq[cpu0]->curr = &task_moving->se;
	top_lrq[cpu0]->curr = &root_user->se;

I have added a special callback set_curr_task() in fair_sched_class to
accomplish this.

Similarly when a task moves from NORMAL class to RT class, I need to:

	root_user_cpu0_lrq->curr = NULL;
	top_lrq_cpu0->curr = NULL;

For this I am reusing the put_prev_task() callback.

I have to accomplish the same steps when a task moves from one group to
other also.

Let me know what you think about set_curr_task() callback [in Patch #6]. The 
other option was to tackle this requirement in enqueue/dequeue_task (if
current task is being enqueue/dequeued then set/reset lrq->curr), which I felt
add unnecessary overhead in normal path (a current task for ex gets
dequeued when it goes to sleep).

-- 
Regards,
vatsa
