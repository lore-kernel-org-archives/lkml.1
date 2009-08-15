Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZHOOtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZHOOtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 10:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZHOOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 10:49:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:49804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZHOOtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 10:49:11 -0400
Date: Sat, 15 Aug 2009 16:49:08 +0200
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Message-ID: <20090815144908.GA30951@wotan.suse.de>
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A86ABF0.2070207@colorfullife.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 02:37:04PM +0200, Manfred Spraul wrote:
> On 08/15/2009 12:38 PM, Nick Piggin wrote:
> >Also, your can_help logic is broken.
> >
> >   
> Good point: with multi-ops, it's possible to wait for arbitrary values.
> I missed that.

Yeah multi ops aren't simple. It's easy to miss things when changing
the algorithm for them.


> >These additional tests just seem to add complexity to me. Wheras my
> >code leaves complex list processing unchanged, and just adds some
> >simpler loops, yours adds additional complexity to an already complex
> >loop. I prefer my approach.
> >   
> It depends on the complexity metric:

I mean code complexity which is most important here IMO, considering
there hasn't been a problem shown with my approach (and despite
being simpler removes all O(n^2) cases from the simple ops algorithms).


> From the .text size or the number of lines, my approach is simpler.
>             1list     2list
> lines    +67     +110 lines
> .text    +398    +678 bytes
> 
> And it needs less runtime memory, too:
> 20 bytes per semaphore instead of 36 [on 64-bit].
> 
> Anyway:
> As far as I can see, you found two performance problems:
> - the semop() scans all pending tasks from the array, not just the tasks 
> that are waiting on the semaphore that was modified.
> - when multiple decrements are waiting, then the code scans all 
> decrements, even if the first decrement reduced semval to 0 and further 
> progress is impossible
> 
> Let's stick to these two points.

I don't see how you've argued that yours is better.

If you are worried about memory consumption, we can add _rcu variants
to hlists and use them. And if you are worried about text size, then
I would bet my version actually uses less icache in the case of
simple ops being used.


> Attached is my proposal.
> 
> I'll verify the patches, but probably only tomorrow.
> 
> --
>     Manfred

>  From bff62ee2f8bc25c807095ddb8a9fc8d28140c785 Mon Sep 17 00:00:00 2001
>  From: Manfred Spraul <manfred@colorfullife.com>
> Date: Sat, 15 Aug 2009 14:29:06 +0200
> Subject: [PATCH 1/2] [PATCH 1/2] ipc/sem.c: alternative list optimization
> 
> Part 1: create per-sem list.
> ---
>  include/linux/sem.h |    5 ++-
>  ipc/sem.c           |   83 +++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 72 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/sem.h b/include/linux/sem.h
> index 1b191c1..8a4adbe 100644
> --- a/include/linux/sem.h
> +++ b/include/linux/sem.h
> @@ -86,6 +86,7 @@ struct task_struct;
>  struct sem {
>  	int	semval;		/* current value */
>  	int	sempid;		/* pid of last operation */
> +	struct list_head sem_pending; /* pending single-sop operations */
>  };
>  
>  /* One sem_array data structure for each set of semaphores in the system. */
> @@ -96,11 +97,13 @@ struct sem_array {
>  	struct sem		*sem_base;	/* ptr to first semaphore in array */
>  	struct list_head	sem_pending;	/* pending operations to be processed */
>  	struct list_head	list_id;	/* undo requests on this array */
> -	unsigned long		sem_nsems;	/* no. of semaphores in array */
> +	int			sem_nsems;	/* no. of semaphores in array */
> +	int			complex_count;	/* pending complex operations */
>  };
>  
>  /* One queue for each sleeping process in the system. */
>  struct sem_queue {
> +	struct list_head	simple_list; /* queue of pending operations */
>  	struct list_head	list;	 /* queue of pending operations */
>  	struct task_struct	*sleeper; /* this process */
>  	struct sem_undo		*undo;	 /* undo structure */
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 3629ef8..59adeda 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -240,6 +240,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
>  	key_t key = params->key;
>  	int nsems = params->u.nsems;
>  	int semflg = params->flg;
> +	int i;
>  
>  	if (!nsems)
>  		return -EINVAL;
> @@ -272,6 +273,14 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
>  	ns->used_sems += nsems;
>  
>  	sma->sem_base = (struct sem *) &sma[1];
> +
> +	for (i = 0; i < nsems; i++) {
> +		struct sem *s = &sma->sem_base[i];
> +
> +		INIT_LIST_HEAD(&s->sem_pending);
> +	}
> +
> +	sma->complex_count = 0;
>  	INIT_LIST_HEAD(&sma->sem_pending);
>  	INIT_LIST_HEAD(&sma->list_id);
>  	sma->sem_nsems = nsems;
> @@ -418,17 +427,48 @@ static void wake_up_sem_queue(struct sem_queue *q, int error)
>  	preempt_enable();
>  }
>  
> -/* Go through the pending queue for the indicated semaphore
> - * looking for tasks that can be completed.
> +static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
> +{
> +	list_del(&q->list);
> +	if (q->nsops == 1) {
> +		BUG_ON(list_empty(&q->simple_list));
> +		list_del(&q->simple_list);
> +	} else {
> +		BUG_ON(!list_empty(&q->simple_list));
> +		sma->complex_count--;
> +	}
> +}
> +
> +
> +/**
> + * update_queue(sma, semnum): Look for tasks that can be completed.
> + * @sma: semaphore array.
> + * @semnum: semaphore that was modified.
> + *
> + * update_queue must be called after a semaphore in a semaphore array
> + * was modified. If multiple semaphore were modified, then @semnum
> + * must be set to -1.
>   */
> -static void update_queue (struct sem_array * sma)
> +static void update_queue(struct sem_array *sma, int semnum)
>  {
>  	struct sem_queue *q, *tq;
> +	struct list_head *pending_list;
> +
> +	/* if there are complex operations around, then knowing the semaphore
> +	 * that was modified doesn't help us. Assume that multiple semaphores
> +	 * were modified.
> +	 */
> +	if (sma->complex_count)
> +		semnum = -1;
> +
> +	if (semnum == -1)
> +		pending_list = &sma->sem_pending;
> +	else
> +		pending_list = &sma->sem_base[semnum].sem_pending;
>  
>  again:
> -	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
> -		int error;
> -		int alter;
> +	list_for_each_entry_safe(q, tq, pending_list, list) {
> +		int error, alter;
>  
>  		error = try_atomic_semop(sma, q->sops, q->nsops,
>  					 q->undo, q->pid);
> @@ -437,7 +477,7 @@ again:
>  		if (error > 0)
>  			continue;
>  
> -		list_del(&q->list);
> +		unlink_queue(sma, q);
>  
>  		/*
>  		 * The next operation that must be checked depends on the type
> @@ -531,8 +571,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>  
>  	/* Wake up all pending processes and let them fail with EIDRM. */
>  	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
> -		list_del(&q->list);
> -
> +		unlink_queue(sma, q);
>  		wake_up_sem_queue(q, -EIDRM);
>  	}
>  
> @@ -754,7 +793,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  		}
>  		sma->sem_ctime = get_seconds();
>  		/* maybe some queued-up processes were waiting for this */
> -		update_queue(sma);
> +		update_queue(sma, -1);
>  		err = 0;
>  		goto out_unlock;
>  	}
> @@ -796,7 +835,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  		curr->sempid = task_tgid_vnr(current);
>  		sma->sem_ctime = get_seconds();
>  		/* maybe some queued-up processes were waiting for this */
> -		update_queue(sma);
> +		update_queue(sma, semnum);
>  		err = 0;
>  		goto out_unlock;
>  	}
> @@ -1172,7 +1211,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>  	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
>  	if (error <= 0) {
>  		if (alter && error == 0)
> -			update_queue (sma);
> +			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
> +
>  		goto out_unlock_free;
>  	}
>  
> @@ -1190,6 +1230,19 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>  	else
>  		list_add(&queue.list, &sma->sem_pending);
>  
> +	if (nsops == 1) {
> +		struct sem *curr;
> +		curr = &sma->sem_base[sops->sem_num];
> +
> +		if (alter)
> +			list_add_tail(&queue.list, &curr->sem_pending);
> +		else
> +			list_add(&queue.list, &curr->sem_pending);
> +	} else {
> +		INIT_LIST_HEAD(&queue.simple_list);
> +		sma->complex_count++;
> +	}
> +
>  	queue.status = -EINTR;
>  	queue.sleeper = current;
>  	current->state = TASK_INTERRUPTIBLE;
> @@ -1231,7 +1284,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>  	 */
>  	if (timeout && jiffies_left == 0)
>  		error = -EAGAIN;
> -	list_del(&queue.list);
> +	unlink_queue(sma, &queue);
>  
>  out_unlock_free:
>  	sem_unlock(sma);
> @@ -1360,7 +1413,7 @@ void exit_sem(struct task_struct *tsk)
>  		}
>  		sma->sem_otime = get_seconds();
>  		/* maybe some queued-up processes were waiting for this */
> -		update_queue(sma);
> +		update_queue(sma, -1);
>  		sem_unlock(sma);
>  
>  		call_rcu(&un->rcu, free_un);
> @@ -1374,7 +1427,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
>  	struct sem_array *sma = it;
>  
>  	return seq_printf(s,
> -			  "%10d %10d  %4o %10lu %5u %5u %5u %5u %10lu %10lu\n",
> +			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
>  			  sma->sem_perm.key,
>  			  sma->sem_perm.id,
>  			  sma->sem_perm.mode,
> -- 
> 1.6.2.5
> 

>  From db1d2efe71ddc982c96f87a65c1bed2ce6bf9944 Mon Sep 17 00:00:00 2001
>  From: Manfred Spraul <manfred@colorfullife.com>
> Date: Sat, 15 Aug 2009 14:31:12 +0200
> Subject: [PATCH 2/2] [PATCH 2/2] ipc/sem.c: optimize single-sop decrements
> 
> ---
>  ipc/sem.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 59adeda..403ca0a 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -470,6 +470,17 @@ again:
>  	list_for_each_entry_safe(q, tq, pending_list, list) {
>  		int error, alter;
>  
> +		/* If we are looking for only one semaphore and that semaphore
> +		 * is 0, then it does not make sense to scan the "alter"
> +		 * entries: simple increments that affect only one entry
> +		 * succeed immediately and cannot be in the single sop,
> +		 * per semaphore pending queue, and decrements cannot
> +		 * succeed if the value is already 0.
> +		 */
> +		if (semnum != -1 && sma->sem_base[semnum].semval == 0 &&
> +				q->alter)
> +			break;
> +
>  		error = try_atomic_semop(sma, q->sops, q->nsops,
>  					 q->undo, q->pid);
>  
> -- 
> 1.6.2.5
> 

