Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbYE2PAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbYE2PAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYE2PAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:00:06 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58417 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYE2PAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:00:04 -0400
Message-ID: <483EC50E.1020103@bull.net>
Date: Thu, 29 May 2008 17:00:30 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ipc/sem.c: convert undo structures to struct list_head
References: <200805241637.m4OGb1iL006199@mail.q-ag.de>
In-Reply-To: <200805241637.m4OGb1iL006199@mail.q-ag.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> The undo structures contain two linked lists, the
> attached patch replaces them with generic struct list_head lists.

If I'm not wrong the undo list is a singly-linked list.
So here we are moving from a set of 4 pointers to a set of 8 pointers.
It's true that this makes the code much much more readable and clear, 
but I was wondering if it's worth?

+ 2 small comments embedded.


> 
> Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>
> ---
>  include/linux/sem.h |   12 ++--
>  ipc/sem.c           |  165 ++++++++++++++++++++++++++++-----------------------
>  2 files changed, 96 insertions(+), 81 deletions(-)
> 
> diff --git a/include/linux/sem.h b/include/linux/sem.h
> index c8eaad9..6a1af1b 100644
> --- a/include/linux/sem.h
> +++ b/include/linux/sem.h
> @@ -95,7 +95,7 @@ struct sem_array {
>  	struct sem		*sem_base;	/* ptr to first semaphore in array */
>  	struct sem_queue	*sem_pending;	/* pending operations to be processed */
>  	struct sem_queue	**sem_pending_last; /* last pending operation */
> -	struct sem_undo		*undo;		/* undo requests on this array */
> +	struct list_head	list_id;	/* undo requests on this array */
>  	unsigned long		sem_nsems;	/* no. of semaphores in array */
>  };
>  
> @@ -118,8 +118,8 @@ struct sem_queue {
>   * when the process exits.
>   */
>  struct sem_undo {
> -	struct sem_undo *	proc_next;	/* next entry on this process */
> -	struct sem_undo *	id_next;	/* next entry on this semaphore set */
> +	struct list_head	list_proc;	/* per-process list: all undos from one process */
> +	struct list_head	list_id;	/* per semaphore array list: all undos for one array */
>  	int			semid;		/* semaphore set identifier */
>  	short *			semadj;		/* array of adjustments, one per semaphore */
>  };
> @@ -128,9 +128,9 @@ struct sem_undo {
>   * that may be shared among all a CLONE_SYSVSEM task group.
>   */ 
>  struct sem_undo_list {
> -	atomic_t	refcnt;
> -	spinlock_t	lock;
> -	struct sem_undo	*proc_list;
> +	atomic_t		refcnt;
> +	spinlock_t		lock;
> +	struct list_head	list_proc;
>  };
>  
>  struct sysv_sem {
> diff --git a/ipc/sem.c b/ipc/sem.c
> index e9418df..211632e 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -274,7 +274,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
>  	sma->sem_base = (struct sem *) &sma[1];
>  	/* sma->sem_pending = NULL; */
>  	sma->sem_pending_last = &sma->sem_pending;
> -	/* sma->undo = NULL; */
> +	INIT_LIST_HEAD(&sma->list_id);
>  	sma->sem_nsems = nsems;
>  	sma->sem_ctime = get_seconds();
>  	sem_unlock(sma);
> @@ -536,7 +536,8 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
>  	 * (They will be freed without any further action in exit_sem()
>  	 * or during the next semop.)
>  	 */
> -	for (un = sma->undo; un; un = un->id_next)
> +	assert_spin_locked(&sma->sem_perm.lock);
> +	list_for_each_entry(un, &sma->list_id, list_id)
>  		un->semid = -1;
>  
>  	/* Wake up all pending processes and let them fail with EIDRM. */
> @@ -763,9 +764,12 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  
>  		for (i = 0; i < nsems; i++)
>  			sma->sem_base[i].semval = sem_io[i];
> -		for (un = sma->undo; un; un = un->id_next)
> +
> +		assert_spin_locked(&sma->sem_perm.lock);

This assert() comes a couple of lines after actually locking the sma: do 
you think it is really necessary to leave it here?

> +		list_for_each_entry(un, &sma->list_id, list_id) {
>  			for (i = 0; i < nsems; i++)
>  				un->semadj[i] = 0;
> +		}
>  		sma->sem_ctime = get_seconds();
>  		/* maybe some queued-up processes were waiting for this */
>  		update_queue(sma);
> @@ -797,12 +801,15 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  	{
>  		int val = arg.val;
>  		struct sem_undo *un;
> +
>  		err = -ERANGE;
>  		if (val > SEMVMX || val < 0)
>  			goto out_unlock;
>  
> -		for (un = sma->undo; un; un = un->id_next)
> +		assert_spin_locked(&sma->sem_perm.lock);
> +		list_for_each_entry(un, &sma->list_id, list_id)
>  			un->semadj[semnum] = 0;
> +
>  		curr->semval = val;
>  		curr->sempid = task_tgid_vnr(current);
>  		sma->sem_ctime = get_seconds();
> @@ -952,6 +959,8 @@ static inline int get_undo_list(struct sem_undo_list **undo_listp)
>  			return -ENOMEM;
>  		spin_lock_init(&undo_list->lock);
>  		atomic_set(&undo_list->refcnt, 1);
> +		INIT_LIST_HEAD(&undo_list->list_proc);
> +		
>  		current->sysvsem.undo_list = undo_list;
>  	}
>  	*undo_listp = undo_list;
> @@ -960,25 +969,30 @@ static inline int get_undo_list(struct sem_undo_list **undo_listp)
>  
>  static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
>  {
> -	struct sem_undo **last, *un;
> -
> -	last = &ulp->proc_list;
> -	un = *last;
> -	while(un != NULL) {
> -		if(un->semid==semid)
> -			break;
> -		if(un->semid==-1) {
> -			*last=un->proc_next;
> -			kfree(un);
> -		} else {
> -			last=&un->proc_next;
> +	struct sem_undo *walk, *tmp;
> +
> +	assert_spin_locked(&ulp->lock);
> +	list_for_each_entry_safe(walk, tmp, &ulp->list_proc, list_proc) {
> +		if(walk->semid==semid)
> +			return walk;
> +		if(walk->semid==-1) {
> +			list_del(&walk->list_proc);
> +			kfree(walk);
>  		}
> -		un=*last;
>  	}
> -	return un;
> +	return NULL;
>  }
>  
> -static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
> +/**
> + * find_alloc_undo - Lookup (and if not present create) undo array
> + * @ns: namespace
> + * @semid: semaphore array id
> + *
> + * The function looks up (and if not present creates) the undo structure.
> + * The size of the undo structure depends on the size of the semaphore
> + * array, thus the alloc path is not that straightforward.
> + */
> +static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
>  {
>  	struct sem_array *sma;
>  	struct sem_undo_list *ulp;
> @@ -997,6 +1011,7 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
>  		goto out;
>  
>  	/* no undo structure around - allocate one. */
> +	/* step 1: figure out the size of the semaphore array */
>  	sma = sem_lock_check(ns, semid);
>  	if (IS_ERR(sma))
>  		return ERR_PTR(PTR_ERR(sma));
> @@ -1004,15 +1019,19 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
>  	nsems = sma->sem_nsems;
>  	sem_getref_and_unlock(sma);
>  
> +	/* step 2: allocate new undo structure */
>  	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
>  	if (!new) {
>  		sem_putref(sma);
>  		return ERR_PTR(-ENOMEM);
>  	}
> -	new->semadj = (short *) &new[1];
> -	new->semid = semid;
>  
> +	/* step 3: Acquire the lock on the undo list pointer */
>  	spin_lock(&ulp->lock);
> +
> +	/* step 4: check for races: someone else allocated the undo struct,
> +	 *         semaphore array was destroyed.
> +	 */
>  	un = lookup_undo(ulp, semid);
>  	if (un) {
>  		spin_unlock(&ulp->lock);
> @@ -1028,13 +1047,17 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
>  		un = ERR_PTR(-EIDRM);
>  		goto out;
>  	}
> -	new->proc_next = ulp->proc_list;
> -	ulp->proc_list = new;
> -	new->id_next = sma->undo;
> -	sma->undo = new;
> +	/* step 5: initialize & link new undo structure */
> +	new->semadj = (short *) &new[1];
> +	new->semid = semid;
> +	assert_spin_locked(&ulp->lock);
> +	list_add(&new->list_proc, &ulp->list_proc);
> +	assert_spin_locked(&sma->sem_perm.lock);
> +	list_add(&new->list_id, &sma->list_id);
> +
>  	sem_unlock(sma);
> -	un = new;
>  	spin_unlock(&ulp->lock);
> +	un = new;
>  out:
>  	return un;
>  }
> @@ -1090,9 +1113,8 @@ asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
>  			alter = 1;
>  	}
>  
> -retry_undos:
>  	if (undos) {
> -		un = find_undo(ns, semid);
> +		un = find_alloc_undo(ns, semid);
>  		if (IS_ERR(un)) {
>  			error = PTR_ERR(un);
>  			goto out_free;
> @@ -1107,14 +1129,14 @@ retry_undos:
>  	}
>  
>  	/*
> -	 * semid identifiers are not unique - find_undo may have
> +	 * semid identifiers are not unique - find_alloc_undo may have
>  	 * allocated an undo structure, it was invalidated by an RMID
> -	 * and now a new array with received the same id. Check and retry.
> +	 * and now a new array with received the same id. Check and fail.
>  	 */
> -	if (un && un->semid == -1) {
> -		sem_unlock(sma);
> -		goto retry_undos;
> -	}
> +	error = -EIDRM;
> +	if (un && un->semid == -1)
> +		goto out_unlock_free;
> +
>  	error = -EFBIG;
>  	if (max >= sma->sem_nsems)
>  		goto out_unlock_free;
> @@ -1243,56 +1265,44 @@ int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
>   */
>  void exit_sem(struct task_struct *tsk)
>  {
> -	struct sem_undo_list *undo_list;
> -	struct sem_undo *u, **up;
> -	struct ipc_namespace *ns;
> +	struct sem_undo_list *ulp;
> +	struct sem_undo *un, *tmp;
>  
> -	undo_list = tsk->sysvsem.undo_list;
> -	if (!undo_list)
> +	ulp= tsk->sysvsem.undo_list;
> +	if (!ulp)
>  		return;
>  	tsk->sysvsem.undo_list = NULL;
>  
> -	if (!atomic_dec_and_test(&undo_list->refcnt))
> +	if (!atomic_dec_and_test(&ulp->refcnt))
>  		return;
>  
> -	ns = tsk->nsproxy->ipc_ns;
> -	/* There's no need to hold the semundo list lock, as current
> -         * is the last task exiting for this undo list.
> -	 */
> -	for (up = &undo_list->proc_list; (u = *up); *up = u->proc_next, kfree(u)) {
> -		struct sem_array *sma;
> -		int nsems, i;
> -		struct sem_undo *un, **unp;
> -		int semid;
> -	       
> -		semid = u->semid;
> -
> -		if(semid == -1)
> -			continue;
> -		sma = sem_lock(ns, semid);
> +	spin_lock(&ulp->lock);
> +
> +	list_for_each_entry_safe(un, tmp, &ulp->list_proc, list_proc) {
> +  		struct sem_array *sma;
> +		int i;
> +
> +		if(un->semid == -1)
> +			goto free;
> +
> +		sma = sem_lock(tsk->nsproxy->ipc_ns, un->semid);
>  		if (IS_ERR(sma))
> -			continue;
> +			goto free;
>  
> -		if (u->semid == -1)
> -			goto next_entry;
> +		if (un->semid == -1)
> +			goto unlock_free;
>  
> -		BUG_ON(sem_checkid(sma, u->semid));
> +		BUG_ON(sem_checkid(sma, un->semid));
>  
> -		/* remove u from the sma->undo list */
> -		for (unp = &sma->undo; (un = *unp); unp = &un->id_next) {
> -			if (u == un)
> -				goto found;
> -		}
> -		printk ("exit_sem undo list error id=%d\n", u->semid);
> -		goto next_entry;
> -found:
> -		*unp = un->id_next;
> -		/* perform adjustments registered in u */
> -		nsems = sma->sem_nsems;
> -		for (i = 0; i < nsems; i++) {
> +		/* remove un from sma->list_id */
> +		assert_spin_locked(&sma->sem_perm.lock);

Once the patch applied, the assert comes a couple of lines after the 
lock has actually been taken. Is it really needed here?

> +		list_del(&un->list_id);
> +
> +		/* perform adjustments registered in un */
> +		for (i = 0; i < sma->sem_nsems; i++) {
>  			struct sem * semaphore = &sma->sem_base[i];
> -			if (u->semadj[i]) {
> -				semaphore->semval += u->semadj[i];
> +			if (un->semadj[i]) {
> +				semaphore->semval += un->semadj[i];
>  				/*
>  				 * Range checks of the new semaphore value,
>  				 * not defined by sus:
> @@ -1316,10 +1326,15 @@ found:
>  		sma->sem_otime = get_seconds();
>  		/* maybe some queued-up processes were waiting for this */
>  		update_queue(sma);
> -next_entry:
> +unlock_free:
>  		sem_unlock(sma);
> +free:
> +		assert_spin_locked(&ulp->lock);
> +		list_del(&un->list_proc);
> +		kfree(un);
>  	}
> -	kfree(undo_list);
> +	spin_unlock(&ulp->lock);
> +	kfree(ulp);
>  }
>  
>  #ifdef CONFIG_PROC_FS


Regards,
Nadia
