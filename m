Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbXCaA3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbXCaA3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 20:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933165AbXCaA3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 20:29:52 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47587 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbXCaA3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 20:29:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Mar 2007 17:29:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 2/13] signal/timer/event fds v7 - signalfd core ...
In-Reply-To: <20070330123954.93993c4d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703301555160.3721@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703271506080.5424@alien.or.mcafeemobile.com>
 <20070330123954.93993c4d.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:

> General comments:
> 
> - All these patches will be considered a 100% regression by the
>   linux-on-a-cellphone people.  What do we have to do to make all of this
>   stuff Kconfigurable?

I guess we can, yes.



> - All this code is moving us toward being able to unify all asynchronous
>   event handling under epoll, yes?
> 
>   If so, it is a competitor to kevent, only it's coming from the other
>   direction.
> 
>   I personally find it an attractive competitor, because it is much more
>   incremental and is easier from a design POV.  But what are its
>   shortcomings wrt kevent?  Do we have a feel for the what the performance
>   difference will be?
> 
>   Which other kernel subsystems need to be wired up for this approach to
>   reach the same level of capability as kevent?

Those patches are not bound to an interface to be used, that's the whole 
point of it. You can use it with POSIX select/poll if you want.
Epoll was there, and was already covering the huge set of pollable 
devices. Timers, signals and event fds complement this set (and you 
don't need epoll to use them). The KAIO notification coming to an eventfd 
(last patch of the serie - like 30 lines), allows you to listen for KAIO 
readiness on an event fd (hence using either selct/poll/epoll).




> - Some poor schmuck needs to document all this stuff.  Other poor schmucks
>   need to program to it, and to develop libraries which talk to it, etc. 
>   Other schmucks need to understand and maintain it.  I judge the code and
>   the patches to be inadequately documented.

Well, many Linux man pages are smaller than the API description that comes 
with those patches ;)




>   Apart from general code commentary, which I will point out at the
>   relevant sites, I wonder about things like:
> 
>   - What are the sharing semantics?
> 
>     - Across dup(), dup2() and fork()?

They work. But you'd still be "listening" the the sighand that created the 
signalfd. Until that sighand gets detached. After that you read(2) zero 
bytes, that tells you that the "remote disconnected" ;)




>     - If two !CLONE_SIGHAND, CLONE_FS threads are sharing a signalfd and one
>       alters its signal mask?

The "mask" is private to the file*, and does not alter the sighand one.
A thread can fetch other one signals if you like.



>     - If two processes are sharing a signalfd across fork() and one
>       alters its signal mask or something?

Which signal mask? Process one or signalfd one?



>   - What are the effects upon the signalfd if the process alters its
>     signal state?

As I said, signalfd and process competes over dequeue_signal for the 
signal fetch. You get a given signal once, either on the fd or with std 
async delivery. If you want to be sure to get it always on the fd, you 
need to block it.




>   - What happens if a task has multiple signalfds open?  Does one
>     signal get delivered to all of the fds?

Signalfds compete over dequeue_signal(), so only one of them will get it.




>   IMO all combinations and permutations should be documented for
>   posterity and it should be done now so we can review this design.

Ok.



> > +static int signalfd_lock(struct signalfd_ctx *ctx, struct signalfd_lockctx *lk);
> > +static void signalfd_unlock(struct signalfd_lockctx *lk);
> > +static void signalfd_cleanup(struct signalfd_ctx *ctx);
> > +static int signalfd_close(struct inode *inode, struct file *file);
> > +static unsigned int signalfd_poll(struct file *file, poll_table *wait);
> > +static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
> > +			     siginfo_t const *kinfo);
> 
> `cosnt siginfo_t *', please.
> 
> I dunno, I find all these forward declarations to be a fugly waste of
> space, and a maintenance hassle.  I think a lot of them can be made to go
> away with some very simple code reorganisations.

Done.




> > +static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
> > +			     loff_t *ppos);
> > +
> > +
> > +
> > +static const struct file_operations signalfd_fops = {
> > +	.release	= signalfd_close,
> 
> Please rename signalfd_close to signalfd_release.

Done.



> > +static int signalfd_lock(struct signalfd_ctx *ctx, struct signalfd_lockctx *lk)
> > +{
> > +	struct sighand_struct *sighand = NULL;
> > +
> > +	rcu_read_lock();
> > +	lk->tsk = rcu_dereference(ctx->tsk);
> > +	if (likely(lk->tsk != NULL))
> > +		sighand = lock_task_sighand(lk->tsk, &lk->flags);
> > +	rcu_read_unlock();
> > +
> > +	if (sighand && !ctx->tsk) {
> > +		unlock_task_sighand(lk->tsk, &lk->flags);
> > +		sighand = NULL;
> > +	}
> > +
> > +	return sighand != NULL;
> > +}
> 
> This function needs documentation - it really is quite obscure.  What does
> its return value mean?  Why does it sometimes do lock_task_sighand() and
> sometimes does not?  I assume that it's handling exitted tasks in some
> fashion but it it is not at all clear.

Comment added.



> > +static void signalfd_unlock(struct signalfd_lockctx *lk)
> > +{
> > +	unlock_task_sighand(lk->tsk, &lk->flags);
> > +}
> 
> If lk->task can be NULL in signalfd_lock(), how come it cannot be NULL
> here?  Because tsk->sighand->siglock prevents the task from exitting?  Some
> commentary describing the synchronisation design here would be useful.

We already pinned it with a lock. If signalfd_lock() returns 1, we can 
safely call signalfd_unlock() (of course ;).



> > +void signalfd_deliver(struct task_struct *tsk, int sig)
> > +{
> > +	struct sighand_struct *sighand = tsk->sighand;
> > +	struct signalfd_ctx *ctx, *tmp;
> > +
> > +	BUG_ON(!sig);
> > +	list_for_each_entry_safe(ctx, tmp, &sighand->sfdlist, lnk) {
> > +		/*
> > +		 * We use a negative signal value as a way to broadcast that the
> > +		 * sighand has been orphaned, so that we can notify all the
> 
> Is the term "orphaned" defined anywhere?

Man, should an Italian teach you that! :)

http://www.thefreedictionary.com/orphaned




> > +/*
> > + * Create a file descriptor that is associated with our signal
> > + * state. We can pass it around to others if we want to, but
> > + * it will always be _our_ signal state.
> > + */
> 
> Who is "us" here?  The tasks which have this fd open?  The tasks which
> share the calling process's sighand_struct?

Tasks that have the fd open, will be able to listen for signals from the 
sighand that originated the fd.




> > +		if (signalfd_lock(ctx, &lk)) {
> > +			ctx->sigmask = sigmask;
> > +			signalfd_unlock(&lk);
> > +		}
> 
> For the life of me I can't work out what the above three lines are doing. 
> Please add sufficient comments to ensure my survival.

Comment added ;)



> > +		wake_up(&ctx->wqh);
> > +		fput(file);
> > +	}
> > +
> > +	return ufd;
> > +
> > +err_fdalloc:
> > +	signalfd_cleanup(ctx);
> > +	return error;
> > +}
> > +
> > +static void signalfd_cleanup(struct signalfd_ctx *ctx)
> > +{
> > +	struct signalfd_lockctx lk;
> > +
> > +	/*
> > +	 * This is tricky. If the sighand is gone, we do not need to remove
> > +	 * context from the list, the list itself won't be there anymore.
> > +	 */
> 
> What chain of circumstances would cause the sighand to be "gone"?

The process that the sighand was attached to, detaches it.




> > +static unsigned int signalfd_poll(struct file *file, poll_table *wait)
> > +{
> > +	struct signalfd_ctx *ctx = file->private_data;
> > +	unsigned int events = 0;
> > +	struct signalfd_lockctx lk;
> > +
> > +	poll_wait(file, &ctx->wqh, wait);
> > +
> > +	/*
> > +	 * Let the caller get a POLLIN in this case, ala socket recv() when
> 
> In what case?

In case the sighand has been detached.



> > +	if (signalfd_lock(ctx, &lk)) {
> > +		if (next_signal(&lk.tsk->pending, &ctx->sigmask) > 0 ||
> > +		    next_signal(&lk.tsk->signal->shared_pending,
> > +				&ctx->sigmask) > 0)
> > +			events |= POLLIN;
> > +		signalfd_unlock(&lk);
> > +	} else
> > +		events |= POLLIN;
> > +
> > +	return events;
> > +}
> > +
> > +/*
> > + * Copied from copy_siginfo_to_user() in kernel/signal.c
> > + */
> 
> Very much copied.  Can we hoist out some code and share it?

No. We use a fixed-size structure. no compat needed, that would be hell if 
we do it on sys_read().




> > +static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
> > +			     siginfo_t const *kinfo)
> > +{
> > +	long err;
> > +
> > +	/*
> > +	 * Unused memebers should be zero ...
> > +	 */
> > +	err = __clear_user(uinfo, sizeof(*uinfo));
> 
> Bug.  __clear_user() doesn't return -EFAULT.

Check at the bottom. We do not return "err" directly.




> I'm looking for an access_ok() and can't find it.  Did we just offer users
> a way of reading kernel memory?

vfs_read() does that for us.



> > +static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
> > +			     loff_t *ppos)
> 
> This function could do with some commentary describing the constraints upon
> `count', the semantics of the return value and some description of what it
> actually copies into userspace.

Comment added.



> > +	if (count < sizeof(struct signalfd_siginfo))
> > +		return -EINVAL;
> > +	if (!(locked = signalfd_lock(ctx, &lk)))
> 
> We prefer
> 
> 	locked = signalfd_lock(ctx, &lk);
> 	if (locked)
> 
> There are many instances of this in the patchset.

Fixed.



> >  extern struct group_info init_groups;
> > Index: linux-2.6.21-rc5.quilt/include/linux/sched.h
> > ===================================================================
> > --- linux-2.6.21-rc5.quilt.orig/include/linux/sched.h	2007-03-26 13:11:53.000000000 -0700
> > +++ linux-2.6.21-rc5.quilt/include/linux/sched.h	2007-03-26 13:21:42.000000000 -0700
> > @@ -379,6 +379,7 @@
> >  	atomic_t		count;
> >  	struct k_sigaction	action[_NSIG];
> >  	spinlock_t		siglock;
> > +	struct list_head        sfdlist;
> 
> "signalfd_list" would be much clearer.

Done.



> but that's such a mouthful that I think I prefer the manually-maintained
> __pad[48].
> 
> Please add a
> 
> 	BUILD_BUG_ON(sizeof(struct signalfd_info) != 128);
> 
> somewhere.
> 
> And please add a comment explaining why this structure needs to have a
> fixed size.

Done.



> > + */
> > +static inline void signalfd_notify(struct task_struct *tsk, int sig)
> > +{
> > +	if (unlikely(!list_empty(&tsk->sighand->sfdlist)))
> > +		signalfd_deliver(tsk, sig);
> > +}
> 
> Does signalfd_notify() have locking requirements?

Comment added.



> >  	/*
> > +	 * Deliver the signal to listening signalfds. This must be called
> > +	 * with the sighand lock held.
> > +	 */
> 
> oh, OK.  A funny place to document signalfd_notify() ;)

Hey, if someone drops some code in my code, I appreciate a few lines 
telling me what's going on, instead of grepping/cscoping the source ;)




- Davide


