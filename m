Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbXH3NMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbXH3NMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXH3NME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:12:04 -0400
Received: from pat.uio.no ([129.240.10.15]:48076 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXH3NMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:12:01 -0400
Subject: Re: [RFC] TASK_KILLED
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070829204048.GQ14130@parisc-linux.org>
References: <20070829204048.GQ14130@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 09:11:37 -0400
Message-Id: <1188479497.6755.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.042)
X-UiO-Scanned: C0120AA51EDDCD6B232304C96F4AF95C192DD6E8
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 342 total 3564609 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 14:40 -0600, Matthew Wilcox wrote:
> I've long hated the non-killability of tasks accessing a dead
> NFS server.  Linus had an idea for fixing this way back in 2002:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0208.0/0167.html which
> I've prototyped in this patch.
> 
> Splitting up TASK_* into separate bits is going to need a lot more
> auditing, I think.  It was easier back in 2002, but since then we've added
> TASK_STOPPED and TASK_TRACED which also need to be gingerly checked for.
> 
> There's some debug code left in here to discourage Linus from just
> applying it.
> 
> I've only added one real user of the killable concept to this patch --
> try_lock_page().  However, this is enough for 'cat */*/*' to be killable
> with a ^C when I unplug the ethernet cord between it and the nfs server.
> 
> I have another version of this patch which makes TASK_KILLABLE a separate
> state on par with TASK_INTERRUPTIBLE and TASK_UNINTERRUPTIBLE, but I
> don't like it as much as this one.  I'll post it if there's demand.
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index ee4814d..6a3c876 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -140,13 +140,8 @@ static const char *task_state_array[] = {
>  
>  static inline const char *get_task_state(struct task_struct *tsk)
>  {
> -	unsigned int state = (tsk->state & (TASK_RUNNING |
> -					    TASK_INTERRUPTIBLE |
> -					    TASK_UNINTERRUPTIBLE |
> -					    TASK_STOPPED |
> -					    TASK_TRACED)) |
> -			(tsk->exit_state & (EXIT_ZOMBIE |
> -					    EXIT_DEAD));
> +	unsigned int state = (tsk->state & TASK_REPORT) |
> +			(tsk->exit_state & (EXIT_ZOMBIE | EXIT_DEAD));
>  	const char **p = &task_state_array[0];
>  
>  	while (state) {
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 507ddff..29e3f21 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -220,7 +220,7 @@ Einval:
>  
>  static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
>  {
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> +	set_current_state(TASK_KILLABLE);
>  	if (!kiocbIsKicked(iocb))
>  		schedule();
>  	else

Won't this change just cause functions like do_sync_read() and
do_sync_write() to loop forever when you kill the process?

> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 8a83537..56675e4 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -154,6 +154,7 @@ static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
>  }
>  
>  extern void FASTCALL(__lock_page(struct page *page));
> +extern int FASTCALL(__try_lock_page(struct page *page));
>  extern void FASTCALL(__lock_page_nosync(struct page *page));
>  extern void FASTCALL(unlock_page(struct page *page));
>  
> @@ -168,6 +169,18 @@ static inline void lock_page(struct page *page)
>  }
>  
>  /*
> + * try_lock_page is like lock_page but sleeps killably.  It returns
> + * 1 if it locked the page and 0 if it was killed while waiting.
> + */
> +static inline int try_lock_page(struct page *page)
> +{
> +	might_sleep();
> +	if (TestSetPageLocked(page))
> +		return __try_lock_page(page);
> +	return 1;
> +}
> +
> +/*
>   * lock_page_nosync should only be used if we can't pin the page's inode.
>   * Doesn't play quite so well with block device plugging.
>   */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index bd6a032..c0c7d7c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -165,16 +165,35 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>   * mistake.
>   */
>  #define TASK_RUNNING		0
> -#define TASK_INTERRUPTIBLE	1
> -#define TASK_UNINTERRUPTIBLE	2
> -#define TASK_STOPPED		4
> -#define TASK_TRACED		8
> +#define __TASK_INTERRUPTIBLE	1
> +#define __TASK_UNINTERRUPTIBLE	2
> +#define __TASK_STOPPED		4
> +#define __TASK_TRACED		8
>  /* in tsk->exit_state */
>  #define EXIT_ZOMBIE		16
>  #define EXIT_DEAD		32
>  /* in tsk->state again */
>  #define TASK_NONINTERACTIVE	64
>  #define TASK_DEAD		128
> +#define TASK_WAKEKILL		256
> +#define TASK_WAKESIGNAL		512
> +#define TASK_LOADAVG		1024
> +
> +/* Convenience macros for the sake of set_task_state */
> +#define TASK_INTERRUPTIBLE	(TASK_WAKESIGNAL | __TASK_INTERRUPTIBLE)
> +#define TASK_UNINTERRUPTIBLE	(TASK_LOADAVG | __TASK_UNINTERRUPTIBLE)
> +#define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
> +#define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
> +#define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
> +
> +/* Convenience macros for the sake of wake_up */
> +#define TASK_NORMAL		(__TASK_INTERRUPTIBLE | __TASK_UNINTERRUPTIBLE)
> +#define TASK_ALL		(TASK_WAKESIGNAL | TASK_WAKEKILL | TASK_LOADAVG)
> +
> +/* get_task_state() */
> +#define TASK_REPORT		(TASK_RUNNING | __TASK_INTERRUPTIBLE | \
> +				__TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
> +				__TASK_TRACED)
>  
>  #define __set_task_state(tsk, state_value)		\
>  	do { (tsk)->state = (state_value); } while (0)
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 0e68628..282efc3 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -155,11 +155,17 @@ wait_queue_head_t *FASTCALL(bit_waitqueue(void *, int));
>  #define wake_up(x)			__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, 1, NULL)
>  #define wake_up_nr(x, nr)		__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, nr, NULL)
>  #define wake_up_all(x)			__wake_up(x, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE, 0, NULL)
> -#define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
> -#define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
> -#define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
> -#define	wake_up_locked(x)		__wake_up_locked((x), TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE)
> -#define wake_up_interruptible_sync(x)   __wake_up_sync((x),TASK_INTERRUPTIBLE, 1)
> +#define wake_up_locked(x)		__wake_up_locked((x), TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE)
> +
> +#define wake_up_interruptible(x)	__wake_up(x, TASK_WAKESIGNAL, 1, NULL)
> +#define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_WAKESIGNAL, nr, NULL)
> +#define wake_up_interruptible_all(x)	__wake_up(x, TASK_WAKESIGNAL, 0, NULL)
> +#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_WAKESIGNAL, 1)
> +
> +#define wake_up_killable(x)		__wake_up(x, TASK_WAKESIGNAL | TASK_WAKEKILL, 1, NULL)
> +#define wake_up_killable_nr(x, nr)	__wake_up(x, TASK_WAKESIGNAL | TASK_WAKEKILL, nr, NULL)
> +#define wake_up_killable_all(x)		__wake_up(x, TASK_WAKESIGNAL | TASK_WAKEKILL, 0, NULL)
> +#define wake_up_killable_sync(x)	__wake_up_sync((x), TASK_WAKESIGNAL | TASK_WAKEKILL, 1)
>  
>  #define __wait_event(wq, condition) 					\
>  do {									\
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9fe473a..6901784 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -944,7 +944,7 @@ static int effective_prio(struct task_struct *p)
>   */
>  static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
>  {
> -	if (p->state == TASK_UNINTERRUPTIBLE)
> +	if (p->state & TASK_LOADAVG)
>  		rq->nr_uninterruptible--;
>  
>  	enqueue_task(rq, p, wakeup);
> @@ -958,7 +958,7 @@ static inline void activate_idle_task(struct task_struct *p, struct rq *rq)
>  {
>  	update_rq_clock(rq);
>  
> -	if (p->state == TASK_UNINTERRUPTIBLE)
> +	if (p->state & TASK_LOADAVG)
>  		rq->nr_uninterruptible--;
>  
>  	enqueue_task(rq, p, 0);
> @@ -970,7 +970,7 @@ static inline void activate_idle_task(struct task_struct *p, struct rq *rq)
>   */
>  static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
>  {
> -	if (p->state == TASK_UNINTERRUPTIBLE)
> +	if (p->state & TASK_LOADAVG)
>  		rq->nr_uninterruptible++;
>  
>  	dequeue_task(rq, p, sleep);
> @@ -1566,8 +1566,7 @@ out:
>  
>  int fastcall wake_up_process(struct task_struct *p)
>  {
> -	return try_to_wake_up(p, TASK_STOPPED | TASK_TRACED |
> -				 TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE, 0);
> +	return try_to_wake_up(p, TASK_ALL, 0);
>  }
>  EXPORT_SYMBOL(wake_up_process);
>  
> @@ -3489,7 +3488,7 @@ need_resched_nonpreemptible:
>  	__update_rq_clock(rq);
>  
>  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> -		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
> +		if (unlikely((prev->state & __TASK_INTERRUPTIBLE) &&
>  				unlikely(signal_pending(prev)))) {
>  			prev->state = TASK_RUNNING;
>  		} else {
> @@ -3707,8 +3706,7 @@ void fastcall complete(struct completion *x)
>  
>  	spin_lock_irqsave(&x->wait.lock, flags);
>  	x->done++;
> -	__wake_up_common(&x->wait, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE,
> -			 1, 0, NULL);
> +	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
>  	spin_unlock_irqrestore(&x->wait.lock, flags);
>  }
>  EXPORT_SYMBOL(complete);
> @@ -3719,8 +3717,7 @@ void fastcall complete_all(struct completion *x)
>  
>  	spin_lock_irqsave(&x->wait.lock, flags);
>  	x->done += UINT_MAX/2;
> -	__wake_up_common(&x->wait, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE,
> -			 0, 0, NULL);
> +	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
>  	spin_unlock_irqrestore(&x->wait.lock, flags);
>  }
>  EXPORT_SYMBOL(complete_all);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index ad63109..ce76369 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -459,15 +459,15 @@ void signal_wake_up(struct task_struct *t, int resume)
>  	set_tsk_thread_flag(t, TIF_SIGPENDING);
>  
>  	/*
> -	 * For SIGKILL, we want to wake it up in the stopped/traced case.
> -	 * We don't check t->state here because there is a race with it
> +	 * For SIGKILL, we want to wake it up in the stopped/traced/killable
> +	 * case. We don't check t->state here because there is a race with it
>  	 * executing another processor and just now entering stopped state.
>  	 * By using wake_up_state, we ensure the process will wake up and
>  	 * handle its death signal.
>  	 */
>  	mask = TASK_INTERRUPTIBLE;
>  	if (resume)
> -		mask |= TASK_STOPPED | TASK_TRACED;
> +		mask |= TASK_WAKEKILL;
>  	if (!wake_up_state(t, mask))
>  		kick_process(t);
>  }
> @@ -626,7 +626,7 @@ static void handle_stop_signal(int sig, struct task_struct *p)
>  			state = TASK_STOPPED;
>  			if (sig_user_defined(t, SIGCONT) && !sigismember(&t->blocked, SIGCONT)) {
>  				set_tsk_thread_flag(t, TIF_SIGPENDING);
> -				state |= TASK_INTERRUPTIBLE;
> +				state |= TASK_WAKESIGNAL;
>  			}
>  			wake_up_state(t, state);
>  
> @@ -841,7 +841,7 @@ static inline int wants_signal(int sig, struct task_struct *p)
>  		return 0;
>  	if (sig == SIGKILL)
>  		return 1;
> -	if (p->state & (TASK_STOPPED | TASK_TRACED))
> +	if (p->state & (__TASK_STOPPED | __TASK_TRACED))
>  		return 0;
>  	return task_curr(p) || !signal_pending(p);
>  }
> @@ -1446,7 +1446,7 @@ void do_notify_parent(struct task_struct *tsk, int sig)
>  	BUG_ON(sig == -1);
>  
>   	/* do_notify_parent_cldstop should have been called instead.  */
> - 	BUG_ON(tsk->state & (TASK_STOPPED|TASK_TRACED));
> + 	BUG_ON(tsk->state & (__TASK_STOPPED|__TASK_TRACED));
>  
>  	BUG_ON(!tsk->ptrace &&
>  	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
> @@ -1713,7 +1713,7 @@ static int do_signal_stop(int signr)
>  			 * so this check has no races.
>  			 */
>  			if (!t->exit_state &&
> -			    !(t->state & (TASK_STOPPED|TASK_TRACED))) {
> +			    !(t->state & (__TASK_STOPPED|__TASK_TRACED))) {
>  				stop_count++;
>  				signal_wake_up(t, 0);
>  			}
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 90b657b..3cb88ff 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -170,6 +170,12 @@ static int sync_page(void *word)
>  	return 0;
>  }
>  
> +static int sync_page_killable(void *word)
> +{
> +	sync_page(word);
> +	return signal_pending(current);
> +}
> +
>  /**
>   * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
>   * @mapping:	address space structure to write
> @@ -574,6 +580,14 @@ void fastcall __lock_page(struct page *page)
>  }
>  EXPORT_SYMBOL(__lock_page);
>  
> +int fastcall __try_lock_page(struct page *page)
> +{
> +	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
> +
> +	return !__wait_on_bit_lock(page_waitqueue(page), &wait,
> +					sync_page_killable, TASK_KILLABLE);
> +}
> +
>  /*
>   * Variant of lock_page that does not require the caller to hold a reference
>   * on the page's mapping.
> @@ -975,7 +989,10 @@ page_ok:
>  
>  page_not_up_to_date:
>  		/* Get exclusive access to the page ... */
> -		lock_page(page);
> +		if (!try_lock_page(page)) {
> +			printk(KERN_EMERG "Taking first path to killed\n");
> +			goto readpage_eio;
> +		}
>  
>  		/* Did it get truncated before we got the lock? */
>  		if (!page->mapping) {
> @@ -1003,7 +1020,10 @@ readpage:
>  		}
>  
>  		if (!PageUptodate(page)) {
> -			lock_page(page);
> +			if (!try_lock_page(page)) {
> +				printk(KERN_EMERG "Taking second path to killed\n");
> +				goto readpage_eio;
> +			}
>  			if (!PageUptodate(page)) {
>  				if (page->mapping == NULL) {
>  					/*
> @@ -1014,15 +1034,16 @@ readpage:
>  					goto find_page;
>  				}
>  				unlock_page(page);
> -				error = -EIO;
>  				shrink_readahead_size_eio(filp, &ra);
> -				goto readpage_error;
> +				goto readpage_eio;
>  			}
>  			unlock_page(page);
>  		}
>  
>  		goto page_ok;
>  
> +readpage_eio:
> +		error = -EIO;
>  readpage_error:
>  		/* UHHUH! A synchronous read error occurred. Report it */
>  		desc->error = error;
> 

