Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYE3JEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYE3JEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 05:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYE3JEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 05:04:41 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54111 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYE3JEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 05:04:40 -0400
Message-ID: <483FC31B.3010601@bull.net>
Date: Fri, 30 May 2008 11:04:27 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ipc/sem.c: rewrite undo list locking
References: <200805241638.m4OGc9WR006330@mail.q-ag.de>
In-Reply-To: <200805241638.m4OGc9WR006330@mail.q-ag.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> The attached patch:
> - reverses the locking order of ulp->lock and sem_lock:
>   Previously, it was first ulp->lock, then inside sem_lock.
>   Now it's the other way around.
> - converts the undo structure to rcu.
> 
> Benefits:
> - With the old locking order, IPC_RMID could not kfree the undo structures.
>   The stale entries remained in the linked lists and were released later.
> - The patch fixes a a race in semtimedop(): if both IPC_RMID and a semget() that
>   recreates exactly the same id happen between find_alloc_undo() and sem_lock,
>   then semtimedop() would access already kfree'd memory.
> 
> Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>

Reviewed-by: Nadia Derbey <Nadia.Derbey@bull.net>

2 comments embedded.


> ---
>  include/linux/sem.h |    6 ++-
>  ipc/sem.c           |  145 ++++++++++++++++++++++++++++++++-------------------
>  2 files changed, 96 insertions(+), 55 deletions(-)
> 
> diff --git a/include/linux/sem.h b/include/linux/sem.h
> index d425993..1b191c1 100644
> --- a/include/linux/sem.h
> +++ b/include/linux/sem.h
> @@ -78,6 +78,7 @@ struct  seminfo {
>  
>  #ifdef __KERNEL__
>  #include <asm/atomic.h>
> +#include <linux/rcupdate.h>
>  
>  struct task_struct;
>  
> @@ -114,7 +115,10 @@ struct sem_queue {
>   * when the process exits.
>   */
>  struct sem_undo {
> -	struct list_head	list_proc;	/* per-process list: all undos from one process */
> +	struct list_head	list_proc;	/* per-process list: all undos from one process. */
> +						/* rcu protected */
> +	struct rcu_head		rcu;		/* rcu struct for sem_undo() */
> +	struct sem_undo_list	*ulp;		/* sem_undo_list for the process */
>  	struct list_head	list_id;	/* per semaphore array list: all undos for one array */
>  	int			semid;		/* semaphore set identifier */
>  	short *			semadj;		/* array of adjustments, one per semaphore */
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 38996c0..d0b2217 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -502,27 +502,35 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
>  	return semzcnt;
>  }
>  
> +void free_un(struct rcu_head *head)
> +{
> +	struct sem_undo *un = container_of(head, struct sem_undo, rcu);
> +	kfree(un);
> +}
> +
>  /* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
>   * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
>   * remains locked on exit.
>   */
>  static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>  {
> -	struct sem_undo *un;
> -	struct sem_queue *q, *t;
> +	struct sem_undo *un, *tu;
> +	struct sem_queue *q, *tq;
>  	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
>  
> -	/* Invalidate the existing undo structures for this semaphore set.
> -	 * (They will be freed without any further action in exit_sem()
> -	 * or during the next semop.)
> -	 */
> +	/* Free the existing undo structures for this semaphore set.  */
>  	assert_spin_locked(&sma->sem_perm.lock);
> -	list_for_each_entry(un, &sma->list_id, list_id)
> +	list_for_each_entry_safe(un, tu, &sma->list_id, list_id) {
> +		list_del(&un->list_id);
> +		spin_lock(&un->ulp->lock);
>  		un->semid = -1;
> +		list_del_rcu(&un->list_proc);
> +		spin_unlock(&un->ulp->lock);
> +		call_rcu(&un->rcu, free_un);
> +	}
>  
>  	/* Wake up all pending processes and let them fail with EIDRM. */
> -
> -	list_for_each_entry_safe(q, t, &sma->sem_pending, list) {
> +	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
>  		list_del(&q->list);
>  
>  		q->status = IN_WAKEUP;
> @@ -946,16 +954,11 @@ static inline int get_undo_list(struct sem_undo_list **undo_listp)
>  
>  static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
>  {
> -	struct sem_undo *walk, *tmp;
> +	struct sem_undo *walk;
>  
> -	assert_spin_locked(&ulp->lock);
> -	list_for_each_entry_safe(walk, tmp, &ulp->list_proc, list_proc) {
> +	list_for_each_entry_rcu(walk, &ulp->list_proc, list_proc) {
>  		if(walk->semid==semid)
>  			return walk;
> -		if(walk->semid==-1) {
> -			list_del(&walk->list_proc);
> -			kfree(walk);
> -		}
>  	}
>  	return NULL;
>  }
> @@ -968,6 +971,8 @@ static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
>   * The function looks up (and if not present creates) the undo structure.
>   * The size of the undo structure depends on the size of the semaphore
>   * array, thus the alloc path is not that straightforward.
> + * Lifetime-rules: sem_undo is rcu-protected, on success, the function
> + * performs a rcu_read_lock().
>   */
>  static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
>  {
> @@ -981,11 +986,13 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
>  	if (error)
>  		return ERR_PTR(error);
>  
> +	rcu_read_lock();
>  	spin_lock(&ulp->lock);
>  	un = lookup_undo(ulp, semid);
>  	spin_unlock(&ulp->lock);

Why are we locking the sem_undo_list: in the lookup, we are traversing 
the proc_list that is rcu_protected.

>  	if (likely(un!=NULL))
>  		goto out;
> +	rcu_read_unlock();
>  
>  	/* no undo structure around - allocate one. */
>  	/* step 1: figure out the size of the semaphore array */
> @@ -1003,38 +1010,36 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -	/* step 3: Acquire the lock on the undo list pointer */
> -	spin_lock(&ulp->lock);
> -
> -	/* step 4: check for races: someone else allocated the undo struct,
> -	 *         semaphore array was destroyed.
> -	 */
> -	un = lookup_undo(ulp, semid);
> -	if (un) {
> -		spin_unlock(&ulp->lock);
> -		kfree(new);
> -		sem_putref(sma);
> -		goto out;
> -	}
> +	/* step 3: Acquire the lock on semaphore array */
>  	sem_lock_and_putref(sma);
>  	if (sma->sem_perm.deleted) {
>  		sem_unlock(sma);
> -		spin_unlock(&ulp->lock);
>  		kfree(new);
>  		un = ERR_PTR(-EIDRM);
>  		goto out;
>  	}
> +	spin_lock(&ulp->lock);
> +
> +	/* step 4: check for races: did someone else allocate the undo struct? */
> +	un = lookup_undo(ulp, semid);
> +	if (un) {
> +		kfree(new);
> +		goto success;
> +	}
>  	/* step 5: initialize & link new undo structure */
>  	new->semadj = (short *) &new[1];
> +	new->ulp = ulp;
>  	new->semid = semid;
>  	assert_spin_locked(&ulp->lock);
> -	list_add(&new->list_proc, &ulp->list_proc);
> +	list_add_rcu(&new->list_proc, &ulp->list_proc);
>  	assert_spin_locked(&sma->sem_perm.lock);
>  	list_add(&new->list_id, &sma->list_id);
> +	un = new;
>  
> -	sem_unlock(sma);
> +success:
>  	spin_unlock(&ulp->lock);
> -	un = new;
> +	rcu_read_lock();

Oh, I'm realizing that we should leave the routine with an rcu_read_lock?
Why not adding a comment everywhere find_alloc_undo() is called?

> +	sem_unlock(sma);
>  out:
>  	return un;
>  }
> @@ -1101,6 +1106,8 @@ asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
>  
>  	sma = sem_lock_check(ns, semid);
>  	if (IS_ERR(sma)) {
> +		if (un)
> +			rcu_read_unlock();
>  		error = PTR_ERR(sma);
>  		goto out_free;
>  	}
> @@ -1109,10 +1116,26 @@ asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
>  	 * semid identifiers are not unique - find_alloc_undo may have
>  	 * allocated an undo structure, it was invalidated by an RMID
>  	 * and now a new array with received the same id. Check and fail.
> +	 * This case can be detected checking un->semid. The existance of
> +	 * "un" itself is guaranteed by rcu.
>  	 */
>  	error = -EIDRM;
> -	if (un && un->semid == -1)
> -		goto out_unlock_free;
> +	if (un) {
> +		if(un->semid == -1) {
> +			rcu_read_unlock();
> +			goto out_unlock_free;
> +		} else {
> +			/*
> +			 * rcu lock can be released, "un" cannot disappear:
> +			 * - sem_lock is acquired, thus IPC_RMID is
> +			 *   impossible.
> +			 * - exit_sem is impossible, it always operates on
> +			 *   current (or a dead task).
> +			 */
> +			
> +			rcu_read_unlock();
> +		}
> +	}
>  
>  	error = -EFBIG;
>  	if (max >= sma->sem_nsems)
> @@ -1240,7 +1263,6 @@ int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
>  void exit_sem(struct task_struct *tsk)
>  {
>  	struct sem_undo_list *ulp;
> -	struct sem_undo *un, *tmp;
>  
>  	ulp= tsk->sysvsem.undo_list;
>  	if (!ulp)
> @@ -1250,28 +1272,47 @@ void exit_sem(struct task_struct *tsk)
>  	if (!atomic_dec_and_test(&ulp->refcnt))
>  		return;
>  
> -	spin_lock(&ulp->lock);
> -
> -	list_for_each_entry_safe(un, tmp, &ulp->list_proc, list_proc) {
> +	for (;;) {
>    		struct sem_array *sma;
> +		struct sem_undo *un;
> +		int semid;
>  		int i;
>  
> -		if(un->semid == -1)
> -			goto free;
> +		rcu_read_lock();
> +		un =list_entry(rcu_dereference(ulp->list_proc.next),
> +					struct sem_undo, list_proc);
> +		if (&un->list_proc == &ulp->list_proc)
> +			semid = -1;
> +		 else
> +			semid = un->semid;
> +		rcu_read_unlock();
>  
> -		sma = sem_lock(tsk->nsproxy->ipc_ns, un->semid);
> -		if (IS_ERR(sma))
> -			goto free;
> +		if(semid == -1)
> +			break;
>  
> -		if (un->semid == -1)
> -			goto unlock_free;
> +		sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid);
>  
> -		BUG_ON(sem_checkid(sma, un->semid));
> +		/* exit_sem raced with IPC_RMID, nothing to do */
> +		if (IS_ERR(sma))
> +			continue;
> +
> +		un = lookup_undo(ulp, semid);
> +		if (un == NULL) {
> +			/* exit_sem raced with IPC_RMID+semget() that created
> +			 * exactly the same semid. Nothing to do.
> +			 */
> +			sem_unlock(sma);
> +			continue;
> +		}
>  
> -		/* remove un from sma->list_id */
> +		/* remove un from the linked lists */
>  		assert_spin_locked(&sma->sem_perm.lock);
>  		list_del(&un->list_id);
>  
> +		spin_lock(&ulp->lock);
> +		list_del_rcu(&un->list_proc);
> +		spin_unlock(&ulp->lock);
> +
>  		/* perform adjustments registered in un */
>  		for (i = 0; i < sma->sem_nsems; i++) {
>  			struct sem * semaphore = &sma->sem_base[i];
> @@ -1300,14 +1341,10 @@ void exit_sem(struct task_struct *tsk)
>  		sma->sem_otime = get_seconds();
>  		/* maybe some queued-up processes were waiting for this */
>  		update_queue(sma);
> -unlock_free:
>  		sem_unlock(sma);
> -free:
> -		assert_spin_locked(&ulp->lock);
> -		list_del(&un->list_proc);
> -		kfree(un);
> +
> +		call_rcu(&un->rcu, free_un);
>  	}
> -	spin_unlock(&ulp->lock);
>  	kfree(ulp);
>  }
>  

Regards,
Nadia

