Return-Path: <linux-kernel-owner+w=401wt.eu-S933364AbXFEVRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364AbXFEVRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbXFEVR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:17:27 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:61311 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616AbXFEVR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:17:26 -0400
Date: Tue, 5 Jun 2007 14:17:11 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] 2.6.22-rc3 perfmon2 : new system calls support
Message-ID: <20070605211711.GD11693@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com> <alpine.DEB.0.99.0706040729230.10505@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706040729230.10505@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Mon, Jun 04, 2007 at 07:38:23AM -0700, David Rientjes wrote:
> On Tue, 29 May 2007, Stephane Eranian wrote:
> > +static int pfm_task_incompatible(struct pfm_context *ctx, struct task_struct *task)
> > +{
> > +	/*
> > +	 * no kernel task or task not owned by caller
> > +	 */
> > +	if (!task->mm) {
> > +		PFM_DBG("cannot attach to kernel thread [%d]", task->pid);
> > +		return -EPERM;
> > +	}
> 
> This isn't a sufficient check for whether a task is owned by the caller.
> 

The comment is missing a part. The ownership test is done by ptrace_may_attahc().
The above test is about checking for a kernel-only thread.

> > +
> > +	/*
> > +	 * cannot block in self-monitoring mode
> > +	 */
> > +	if (ctx->flags.block && task == current) {
> > +		PFM_DBG("cannot load a in blocking mode on self for [%d]",
> > +			task->pid);
> > +		return -EINVAL;
> > +	}
> 
> Poor description of trying block notification on self.
> 

Fixed.

> > +
> > +	if (task->exit_state == EXIT_ZOMBIE || task->exit_state == EXIT_DEAD) {
> > +		PFM_DBG("cannot attach to zombie/dead task [%d]", task->pid);
> > +		return -EBUSY;
> > +	}
> > +	return 0;
> > +}
> > +
> > +/*
> > + * This function  is used in per-thread mode only AND when not
> > + * self-monitoring. It finds the task to monitor and checks
> > + * that the caller has persmissions to attach. It also checks
> > + * that the task is stopped via ptrace so that we can safely
> > + * modify its state.
> > + *
> > + * task refcount is increment when succesful.
> > + */
> > +int pfm_get_task(struct pfm_context *ctx, pid_t pid, struct task_struct **task)
> > +{
> 
> This function could be marked static even though it's exported through 
> perfmon.h in patch 13.  It is unreferenced elsewhere.
> 
No because it is used in another module on IA-64 (for compatibility with older versions).

> Why can't this be done with just struct task_struct *task as the third 
> formal and change the assignment later to task = p?
> 
Because we need to carry the errno back: ESRCH or EPERM.

> > +
> > +int pfm_check_task_state(struct pfm_context *ctx, int check_mask,
> > +			 unsigned long *flags)
> > +{
> 
> Another function that can be static.
> 
It cannot for the same reason described above.

> You need to mention the fact that ctx->lock needs to be locked before 
> calling this function.
> 
Fixed.

> No need to send a pointer to flags, just send the unsigned long value 
> itself, if necessary.  All callers currently send the address of an 
> automatic anyway.  Unlocking and then relocking ctx->lock by returning the 
> new flags is inappropriate.
> 
How can you guarantee that when you grab the spin_lock_irqsave() you'll
get the same flags as when you entered the syscall? I did tha tbecause I ran into
an issue at some point (I think it was on Itanium).

> > +	if (check_mask & PFM_CMD_STOPPED) {
> > +
> > +		spin_unlock_irqrestore(&ctx->lock, local_flags);
> > +
> > +		/*
> > +		 * check that the thread is ptraced AND STOPPED
> > +		 */
> > +		ret = ptrace_check_attach(task, 0);
> > +
> > +		spin_lock_irqsave(&ctx->lock, new_flags);
> > +
> > +		/*
> > +		 * flags may be different than when we released the lock
> > +		 */
> > +		*flags = new_flags;
> 
> You can't do this, you'll need to either separate these functions out by 
> having pfm_check_task_state() indicate by a return value that 
> ptrace_check_attach() should be checked or that we've already failed, or 
> come up with a non-locking solution.
> 
Are you worried about the the local_flags vs. new flags?
I think your solution would be cleaner, I will see what I can do.


> > +
> > +		if (ret)
> > +			return ret;
> > +		/*
> > +		 * we must recheck to verify if state has changed
> > +		 */
> > +		if (ctx->state != state) {
> > +			PFM_DBG("old_state=%d new_state=%d",
> > +				state,
> > +				ctx->state);
> > +			goto recheck;
> 
> This should be unnecessary when you no longer drop the ctx->lock in this 
> function.
> 
I cannot keep ctx->lock help and unmask interrupts because there is a race
condition when a PMU interrupt (which grabs ctx->lock) or a timer tick
which may cause an event set switch (which grabs ctx->lock). Yet, ptrace_check_attach()
needs to be called with interrupt unmasked, thus I have to drop everything.

> > +int pfm_get_args(void __user *ureq, size_t sz, size_t lsz, void *laddr,
> > +		 void **req, void **ptr_free)
> > +{
> 
> Another function that can be static.
> 
Cannot for the same reaons described above.

> Needs a comment to say that *req and *ptr_free get kmalloc'd and requires 
> a free() of at least one of them upon return.
> 
Done.

> > +int pfm_get_smpl_arg(char __user *fmt_uname, void __user *fmt_uarg, size_t usize, void **arg,
> > +		     struct pfm_smpl_fmt **fmt)
> > +{
> 
> Another function that can be static.
> 
Nope.

> Needs a comment to say that *arg gets kmalloc'd and requires a free() 
> afterwards.
> 
Done.

> > +	*arg = addr;
> > +	*fmt = f;
> > +	return 0;
> > +
> > +error:
> > +	kfree(addr);
> > +	pfm_smpl_fmt_put(f);
> > +	return ret;
> > +}
> 
> In the non-error case where we return 0, is pfm_smpl_fmt_put(f) taken care 
> of in pfm_context_free()?
> 
Yes.

> > +asmlinkage long sys_pfm_create_context(struct pfarg_ctx __user *ureq,
> > +				       char __user *fmt_name,
> > +				       void __user *fmt_uarg, size_t fmt_size)
> > +{
> > +	struct pfarg_ctx req;
> > +	struct pfm_context *new_ctx;
> > +	struct pfm_smpl_fmt *fmt = NULL;
> > +	void *fmt_arg = NULL;
> > +	int ret;
> > +
> > +	if (atomic_read(&perfmon_disabled))
> > +		return -ENOSYS;
> 
> Not really necessary for perfmon_disabled to be an atomic_t since it's 
> only set in pfm_init() and we would have returned 0 in that function when 
> we've initialized correctly.  A simple unsigned char will work fine.
> 
Andi had the same comment. I fixed that now.

> > +
> > +asmlinkage long sys_pfm_write_pmcs(int fd, struct pfarg_pmc __user *ureq, int count)
> > +{
> > +	struct pfm_context *ctx;
> > +	struct file *filp;
> > +	struct pfarg_pmc pmcs[PFM_PMC_STK_ARG];
> > +	struct pfarg_pmc *req;
> > +	void *fptr;
> > +	unsigned long flags;
> > +	size_t sz;
> > +	int ret, fput_needed;
> > +
> 
> Could this have a stack overflow on powerpc?
> 
The PFM_PMC_STK_ARG is per-arch,  so you could chose a very low value. 
I think it is set to 4. pfarg_pmc s 48 bytes and pfarg_pmd is 176 bytes
regardless of LP64 vs. ILP32.

> > +	if (unlikely(filp == NULL)) {
> > +		PFM_DBG("invalid fd %d", fd);
> > +		return -EBADF;
> > +	}
> > +
> > +	ctx = filp->private_data;
> > +	ret = -EBADF;
> > +
> > +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> > +		PFM_DBG("fd %d not related to perfmon", fd);
> > +		goto error;
> > +	}
> > +
> > +	ret = pfm_get_args(ureq, sz, sizeof(pmcs), pmcs, (void **)&req, &fptr);
> > +	if (ret)
> > +		goto error;
> > +
> > +	spin_lock_irqsave(&ctx->lock, flags);
> > +
> > +	ret = pfm_check_task_state(ctx, PFM_CMD_STOPPED, &flags);
> > +	if (!ret)
> > +		ret = __pfm_write_pmcs(ctx, req, count);
> > +
> > +	spin_unlock_irqrestore(&ctx->lock, flags);
> > +
> > +	if (copy_to_user(ureq, req, sz))
> > +		ret = -EFAULT;
> > +
> > +	/*
> > +	 * This function may be on the critical path.
> > +	 * We want to avoid the branch if unecessary.
> > +	 */
> > +	if (fptr)
> > +		kfree(fptr);
> 
> This comment doesn't make a lot of sense, you have to kfree(fptr) because 
> it could have been set in pfm_get_args() and kfree() can take a NULL 
> value, so why do you need a branch here at all?  In fact, this branch 
> looks like it will always be true since this is our ptr_free from a 
> successful return of pfm_get_args() and this is on the success path.
> 
No, the logic is slightly different here. If the size of the vector
argument passed to the syscall is < PFM_PM*_STK_ARG, then we copy_from_user
to it *otherwise* we kmalloc() a buffer to copy user data into. 
fptr may be NULL if we used the short stack array, thus  we may not need
kfree() all the time. It is the case that on some arch it is quite expensive
to make a function call just to return immediately. This is small optimization
for the calls that are likely to be used a lot.


> > +asmlinkage long sys_pfm_load_context(int fd, struct pfarg_load __user *ureq)
> > +{
> > +	struct pfm_context *ctx;
> > +	struct task_struct *task;
> > +	struct file *filp;
> > +	unsigned long flags;
> > +	struct pfarg_load req;
> > +	int ret, fput_needed;
> > +
> > +	if (copy_from_user(&req, ureq, sizeof(req)))
> > +		return -EFAULT;
> > +
> > +	filp = fget_light(fd, &fput_needed);
> > +	if (unlikely(filp == NULL)) {
> > +		PFM_DBG("invalid fd %d", fd);
> > +		return -EBADF;
> > +	}
> > +
> > +	task = NULL;
> > +	ctx = filp->private_data;
> > +	ret = -EBADF;
> > +
> > +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> > +		PFM_DBG("fd %d not related to perfmon", fd);
> > +		goto error;
> > +	}
> > +
> > +	/*
> > +	 * in per-thread mode (not self-monitoring), get a reference
> > +	 * on task to monitor. This must be done with interrupts enabled
> > +	 * Upon succesful return, refcount on task is increased.
> > +	 *
> > +	 * fget_light() is protecting the context.
> > +	 */
> > +	if (!ctx->flags.system) {
> > +		if (req.load_pid != current->pid) {
> > +			ret = pfm_get_task(ctx, req.load_pid, &task);
> > +			if (ret)
> > +				goto error;
> > +		} else
> > +			task = current;
> > +	}
> 
> This is the only call to pfm_get_task(), so it could be done by passing 
> "task" as the third actual instead.
> 
No there is another module (on IA-64) which invokes pfm_get_task().
I am not sure I understand your point about "task". We need to return
errno, so task cannot just be the return value.

Thanks for your feedback.

-- 

-Stephane
