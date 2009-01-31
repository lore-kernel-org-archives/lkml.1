Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZAaTXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZAaTXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZAaTWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:22:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZAaTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:22:52 -0500
Subject: Re: [PATCH 2/2] softlockup: check all tasks in hung_task
From: Peter Zijlstra <peterz@infradead.org>
To: Mandeep Singh Baines <msb@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090130204904.GA11207@google.com>
References: <20090130204904.GA11207@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jan 2009 20:22:37 +0100
Message-Id: <1233429757.4787.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 12:49 -0800, Mandeep Singh Baines wrote:
> Instead of checking only hung_task_check_count tasks, all tasks are checked.
> hung_task_check_count is still used to put an upper bound on the critical
> section. Every hung_task_check_count checks, the critical section is
> refreshed. Keeping the critical section small minimizes time preemption is
> disabled and keeps rcu grace periods small.
> 
> To prevent following a stale pointer, get_task_struct is called on g and t.
> To verify that g and t have not been unhashed while outside the critical
> section, the task states are checked.
> 
> The design was proposed by Frédéric Weisbecker.
> 
> Frédéric Weisbecker (fweisbec@gmail.com) wrote:
> >
> > Instead of having this arbitrary limit of tasks, why not just
> > lurk the need_resched() and then schedule if it needs too.
> >
> > I know that sounds a bit racy, because you will have to release the
> > tasklist_lock and
> > a lot of things can happen in the task list until you become resched.
> > But you can do a get_task_struct() on g and t before your thread is
> > going to sleep and then put them
> > when it is awaken.
> > Perhaps some tasks will disappear or be appended in the list before g
> > and t, but that doesn't really matter:
> > if they disappear, they didn't lockup, and if they were appended, they
> > are not enough cold to be analyzed :-)
> >
> > This way you can drop the arbitrary limit of task number given by the user....
> >
> > Frederic.
> >
> 
> Signed-off-by: Mandeep Singh Baines <msb@google.com>
> ---
>  kernel/hung_task.c |   28 ++++++++++++++++++++++++++--
>  1 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index a841db3..1c8c9f9 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -109,6 +109,25 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
>  		panic("hung_task: blocked tasks");
>  }
>  
> + /*
> +  * To avoid extending the RCU grace period for an unbounded amount of time,
> +  * periodically exit the critical section and enter a new one.
> +  *
> +  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
> +  * exit the grace period. For classic RCU, a reschedule is required.
> +  */
> +static void check_hung_rcu_refresh(struct task_struct *g, struct task_struct *t)
> +{
> +	get_task_struct(g);
> +	get_task_struct(t);
> +	rcu_read_unlock();
> +	if (need_resched())
> +		schedule();

won't a simple cond_resched(), do?

> +	rcu_read_lock();
> +	put_task_struct(t);
> +	put_task_struct(g);
> +}
> +
>  /*
>   * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
>   * a really long time (120 seconds). If that happens, print out
> @@ -129,8 +148,13 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  
>  	rcu_read_lock();
>  	do_each_thread(g, t) {
> -		if (!--max_count)
> -			goto unlock;
> +		if (sysctl_hung_task_check_count && !(max_count--)) {
> +			max_count = sysctl_hung_task_check_count;
> +			check_hung_rcu_refresh(g, t);
> +			/* Exit if t or g was unhashed during refresh. */
> +			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> +				goto unlock;
> +		}

Its all a bit ugly, but I suppose there's no way around that.

>  		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
>  		if (t->state == TASK_UNINTERRUPTIBLE)
>  			check_hung_task(t, now, timeout);

