Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbXFDOnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbXFDOnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbXFDOnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:43:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:7392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbXFDOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:43:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=hwrKb768W+LlRORRThhGgFfT0A7Z+fvVd0svJkk08NCf+t0ZOxTotfGzbaipzV5wx
	0RtANqYx3RhuqojPLfsiw==
Date: Mon, 4 Jun 2007 07:38:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 03/22] 2.6.22-rc3 perfmon2 : new system calls support
In-Reply-To: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706040729230.10505@chino.kir.corp.google.com>
References: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Stephane Eranian wrote:

> --- linux-2.6.22.base/perfmon/perfmon_syscalls.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.22/perfmon/perfmon_syscalls.c	2007-05-29 03:24:14.000000000 -0700
> @@ -0,0 +1,991 @@
> +/*
> + * perfmon_syscalls.c: perfmon2 system call interface
> + *
> + * This file implements the perfmon2 interface which
> + * provides access to the hardware performance counters
> + * of the host processor.
> + *
> + * The initial version of perfmon.c was written by
> + * Ganesh Venkitachalam, IBM Corp.
> + *
> + * Then it was modified for perfmon-1.x by Stephane Eranian and
> + * David Mosberger, Hewlett Packard Co.
> + *
> + * Version Perfmon-2.x is a complete rewrite of perfmon-1.x
> + * by Stephane Eranian, Hewlett Packard Co.
> + *
> + * Copyright (c) 1999-2006 Hewlett-Packard Development Company, L.P.
> + * Contributed by Stephane Eranian <eranian@hpl.hp.com>
> + *                David Mosberger-Tang <davidm@hpl.hp.com>
> + *
> + * More information about perfmon available at:
> + * 	http://perfmon2.sf.net
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of version 2 of the GNU General Public
> + * License as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
> + * 02111-1307 USA
> +  */
> +#include <linux/kernel.h>
> +#include <linux/perfmon.h>
> +#include <linux/fs.h>
> +#include <linux/ptrace.h>
> +#include <asm/uaccess.h>
> +
> +/*
> + * Context locking rules:
> + * ---------------------
> + * 	- any thread with access to the file descriptor of a context can
> + * 	  potentially issue perfmon calls
> + *
> + * 	- calls must be serialized to guarantee correctness
> + *
> + * 	- as soon as a context is attached to a thread or CPU, it may be
> + * 	  actively monitoring. On some architectures, such as IA-64, this
> + * 	  is true even though the pfm_start() call has not been made. This
> + * 	  comes from the fact that on some architectures, it is possible to
> + * 	  start/stop monitoring from userland.
> + *
> + *	- If monitoring is active, then there can PMU interrupts. Because
> + *	  context accesses must be serialized, the perfmon system calls
> + *	  must mask interrupts as soon as the context is attached.
> + *
> + *	- perfmon system calls that operate with the context unloaded cannot
> + *	  assume it is actually unloaded when they are called. They first need
> + *	  to check and for that they need interrupts masked. Then if the context
> + *	  is actually unloaded, they can unmask interrupts.
> + *
> + *	- interrupt masking holds true for other internal perfmon functions as
> + *	  well. Except for PMU interrupt handler because those interrupts cannot
> + *	  be nested.
> + *
> + * 	- we mask ALL interrupts instead of just the PMU interrupt because we
> + * 	  also need to protect against timer interrupts which could trigger
> + * 	  a set switch.
> + */
> +
> +/*
> + * cannot attach if :
> + * 	- kernel task
> + * 	- task not owned by caller
> + * 	- task is dead or zombie
> + * 	- cannot use blocking notification when self-monitoring
> + */
> +static int pfm_task_incompatible(struct pfm_context *ctx, struct task_struct *task)
> +{
> +	/*
> +	 * no kernel task or task not owned by caller
> +	 */
> +	if (!task->mm) {
> +		PFM_DBG("cannot attach to kernel thread [%d]", task->pid);
> +		return -EPERM;
> +	}

This isn't a sufficient check for whether a task is owned by the caller.

> +
> +	/*
> +	 * cannot block in self-monitoring mode
> +	 */
> +	if (ctx->flags.block && task == current) {
> +		PFM_DBG("cannot load a in blocking mode on self for [%d]",
> +			task->pid);
> +		return -EINVAL;
> +	}

Poor description of trying block notification on self.

> +
> +	if (task->exit_state == EXIT_ZOMBIE || task->exit_state == EXIT_DEAD) {
> +		PFM_DBG("cannot attach to zombie/dead task [%d]", task->pid);
> +		return -EBUSY;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * This function  is used in per-thread mode only AND when not
> + * self-monitoring. It finds the task to monitor and checks
> + * that the caller has persmissions to attach. It also checks
> + * that the task is stopped via ptrace so that we can safely
> + * modify its state.
> + *
> + * task refcount is increment when succesful.
> + */
> +int pfm_get_task(struct pfm_context *ctx, pid_t pid, struct task_struct **task)
> +{

This function could be marked static even though it's exported through 
perfmon.h in patch 13.  It is unreferenced elsewhere.

Why can't this be done with just struct task_struct *task as the third 
formal and change the assignment later to task = p?

> +	struct task_struct *p;
> +	int ret = 0, ret1 = 0;
> +
> +	/*
> +	 * When attaching to another thread we must ensure
> +	 * that the thread is actually stopped. Just like with
> +	 * perfmon system calls, we enforce that the thread
> +	 * be ptraced and STOPPED by using ptrace_check_attach().
> +	 *
> +	 * As a consequence, only the ptracing parent can actually
> +	 * attach a context to a thread. Obviously, this constraint
> +	 * does not exist for self-monitoring threads.
> +	 *
> +	 * We use ptrace_may_attach() to check for permission.
> +	 * No permission checking is needed for self monitoring.
> +	 */
> +	read_lock(&tasklist_lock);
> +
> +	p = find_task_by_pid(pid);
> +	if (p)
> +		get_task_struct(p);
> +
> +	read_unlock(&tasklist_lock);
> +
> +	if (p == NULL)
> +		return -ESRCH;
> +
> +	ret = -EPERM;
> +
> +	/*
> +	 * returns 0 if cannot attach
> +	 */
> +	ret1 = ptrace_may_attach(p);
> +	if (ret1)
> +		ret = ptrace_check_attach(p, 0);
> +
> +	PFM_DBG("may_attach=%d check_attach=%d", ret1, ret);
> +
> +	if (ret || !ret1)
> +		goto error;
> +
> +	ret = pfm_task_incompatible(ctx, p);
> +	if (ret)
> +		goto error;
> +
> +	*task = p;
> +
> +	return 0;
> +error:
> +	if (!(ret1 || ret))
> +		ret = -EPERM;
> +
> +	put_task_struct(p);
> +
> +	return ret;
> +}
> +
> +int pfm_check_task_state(struct pfm_context *ctx, int check_mask,
> +			 unsigned long *flags)
> +{

Another function that can be static.

You need to mention the fact that ctx->lock needs to be locked before 
calling this function.

No need to send a pointer to flags, just send the unsigned long value 
itself, if necessary.  All callers currently send the address of an 
automatic anyway.  Unlocking and then relocking ctx->lock by returning the 
new flags is inappropriate.

> +	struct task_struct *task;
> +	unsigned long local_flags, new_flags;
> +	int state, ret;
> +
> +recheck:
> +	/*
> +	 * task is NULL for system-wide context
> +	 */
> +	task = ctx->task;
> +	state = ctx->state;
> +	local_flags = *flags;
> +
> +	PFM_DBG("state=%d check_mask=0x%x", state, check_mask);
> +	/*
> +	 * if the context is detached, then we do not touch
> +	 * hardware, therefore there is not restriction on when we can
> +	 * access it.
> +	 */
> +	if (state == PFM_CTX_UNLOADED)
> +		return 0;
> +	/*
> +	 * no command can operate on a zombie context.
> +	 * A context becomes zombie when the file that identifies
> +	 * it is closed while the context is still attached to the
> +	 * thread it monitors.
> +	 */
> +	if (state == PFM_CTX_ZOMBIE)
> +		return -EINVAL;
> +
> +	/*
> +	 * at this point, state is PFM_CTX_LOADED or PFM_CTX_MASKED
> +	 */
> +
> +	/*
> +	 * some commands require the context to be unloaded to operate
> +	 */
> +	if (check_mask & PFM_CMD_UNLOADED)  {
> +		PFM_DBG("state=%d, cmd needs context unloaded", state);
> +		return -EBUSY;
> +	}
> +
> +	/*
> +	 * self-monitoring always ok.
> +	 */
> +	if (task == current)
> +		return 0;
> +
> +	/*
> +	 * for syswide, the calling thread must be running on the cpu
> +	 * the context is bound to. There cannot be preemption as we
> +	 * check with interrupts disabled.
> +	 */
> +	if (ctx->flags.system) {
> +		if (ctx->cpu != smp_processor_id())
> +			return -EBUSY;
> +		return 0;
> +	}
> +
> +	/*
> +	 * at this point, monitoring another thread
> +	 */
> +
> +	/*
> +	 * the pfm_unload_context() command is allowed on masked context
> +	 */
> +	if (state == PFM_CTX_MASKED && !(check_mask & PFM_CMD_UNLOAD))
> +		return 0;
> +
> +	/*
> +	 * When we operate on another thread, we must wait for it to be
> +	 * stopped and completely off any CPU as we need to access the
> +	 * PMU state (or machine state).
> +	 *
> +	 * A thread can be put in the STOPPED state in various ways
> +	 * including PTRACE_ATTACH, or when it receives a SIGSTOP signal.
> +	 * We enforce that the thread must be ptraced, so it is stopped
> +	 * AND it CANNOT Wake up while we operate on it because this
> +	 * would require an action for the ptracing parent which is the
> +	 * thread that is calling this function.
> +	 *
> +	 * The dependency on ptrace, imposes that only the ptracing
> +	 * parent can issue command on a thread. This is unfortunate
> +	 * but we do not know of a better way of doing this.
> +	 */
> +	if (check_mask & PFM_CMD_STOPPED) {
> +
> +		spin_unlock_irqrestore(&ctx->lock, local_flags);
> +
> +		/*
> +		 * check that the thread is ptraced AND STOPPED
> +		 */
> +		ret = ptrace_check_attach(task, 0);
> +
> +		spin_lock_irqsave(&ctx->lock, new_flags);
> +
> +		/*
> +		 * flags may be different than when we released the lock
> +		 */
> +		*flags = new_flags;

You can't do this, you'll need to either separate these functions out by 
having pfm_check_task_state() indicate by a return value that 
ptrace_check_attach() should be checked or that we've already failed, or 
come up with a non-locking solution.

> +
> +		if (ret)
> +			return ret;
> +		/*
> +		 * we must recheck to verify if state has changed
> +		 */
> +		if (ctx->state != state) {
> +			PFM_DBG("old_state=%d new_state=%d",
> +				state,
> +				ctx->state);
> +			goto recheck;

This should be unnecessary when you no longer drop the ctx->lock in this 
function.

> +		}
> +	}
> +	return 0;
> +}
> +
> +int pfm_get_args(void __user *ureq, size_t sz, size_t lsz, void *laddr,
> +		 void **req, void **ptr_free)
> +{

Another function that can be static.

Needs a comment to say that *req and *ptr_free get kmalloc'd and requires 
a free() of at least one of them upon return.

> +	void *addr;
> +
> +	/*
> +	 * check if we can get by with stack buffer
> +	 */
> +	if (sz <= lsz) {
> +		*req = laddr;
> +		*ptr_free = NULL;
> +		return copy_from_user(laddr, ureq, sz) ? -EFAULT : 0;
> +	}
> +
> +	if (unlikely(sz > pfm_controls.arg_mem_max)) {
> +		PFM_DBG("argument too big %zu max=%zu",
> +			sz,
> +			pfm_controls.arg_mem_max);
> +		return -E2BIG;
> +	}
> +
> +	addr = kmalloc(sz, GFP_KERNEL);
> +	if (unlikely(addr == NULL))
> +		return -ENOMEM;
> +
> +	if (copy_from_user(addr, ureq, sz)) {
> +		kfree(addr);
> +		return -EFAULT;
> +	}
> +	*req = *ptr_free = addr;
> +
> +	return 0;
> +}
> +
> +int pfm_get_smpl_arg(char __user *fmt_uname, void __user *fmt_uarg, size_t usize, void **arg,
> +		     struct pfm_smpl_fmt **fmt)
> +{

Another function that can be static.

Needs a comment to say that *arg gets kmalloc'd and requires a free() 
afterwards.

> +	struct pfm_smpl_fmt *f;
> +	char *fmt_name;
> +	void *addr = NULL;
> +	size_t sz;
> +	int ret;
> +
> +	fmt_name = getname(fmt_uname);
> +	if (!fmt_name) {
> +		PFM_DBG("getname failed");
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * find fmt and increase refcount
> +	 */
> +	f = pfm_smpl_fmt_get(fmt_name);
> +
> +	putname(fmt_name);
> +
> +	if (f == NULL) {
> +		PFM_DBG("buffer format not found");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * expected format argument size
> +	 */
> +	sz = f->fmt_arg_size;
> +
> +	/*
> +	 * check user size matches expected size
> +	 * usize = -1 is for IA-64 backward compatibility
> +	 */
> +	ret = -EINVAL;
> +	if (sz != usize && usize != -1) {
> +		PFM_DBG("invalid arg size %zu, format expects %zu",
> +			usize, sz);
> +		goto error;
> +	}
> +	
> +	if (sz) {
> +		ret = -ENOMEM;
> +		addr = kmalloc(sz, GFP_KERNEL);
> +		if (addr == NULL)
> +			goto error;
> +
> +		ret = -EFAULT;
> +		if (copy_from_user(addr, fmt_uarg, sz))
> +			goto error;
> +	}
> +	*arg = addr;
> +	*fmt = f;
> +	return 0;
> +
> +error:
> +	kfree(addr);
> +	pfm_smpl_fmt_put(f);
> +	return ret;
> +}

In the non-error case where we return 0, is pfm_smpl_fmt_put(f) taken care 
of in pfm_context_free()?

> +
> +/*
> + * unlike the other perfmon system calls, this one return a file descriptor
> + * or a value < 0 in case of error, very much like open() or socket()
> + */
> +asmlinkage long sys_pfm_create_context(struct pfarg_ctx __user *ureq,
> +				       char __user *fmt_name,
> +				       void __user *fmt_uarg, size_t fmt_size)
> +{
> +	struct pfarg_ctx req;
> +	struct pfm_context *new_ctx;
> +	struct pfm_smpl_fmt *fmt = NULL;
> +	void *fmt_arg = NULL;
> +	int ret;
> +
> +	if (atomic_read(&perfmon_disabled))
> +		return -ENOSYS;

Not really necessary for perfmon_disabled to be an atomic_t since it's 
only set in pfm_init() and we would have returned 0 in that function when 
we've initialized correctly.  A simple unsigned char will work fine.

> +
> +	if (copy_from_user(&req, ureq, sizeof(req)))
> +		return -EFAULT;
> +
> +	if (fmt_name) {
> +		ret = pfm_get_smpl_arg(fmt_name, fmt_uarg, fmt_size, &fmt_arg, &fmt);
> +		if (ret)
> +			goto abort;
> +	}
> +
> +	ret = __pfm_create_context(&req, fmt, fmt_arg, PFM_NORMAL, &new_ctx);
> +
> +	kfree(fmt_arg);
> +abort:
> +	return ret;
> +}
> +
> +asmlinkage long sys_pfm_write_pmcs(int fd, struct pfarg_pmc __user *ureq, int count)
> +{
> +	struct pfm_context *ctx;
> +	struct file *filp;
> +	struct pfarg_pmc pmcs[PFM_PMC_STK_ARG];
> +	struct pfarg_pmc *req;
> +	void *fptr;
> +	unsigned long flags;
> +	size_t sz;
> +	int ret, fput_needed;
> +

Could this have a stack overflow on powerpc?

> +	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
> +		return -EINVAL;
> +
> +	sz = count*sizeof(*ureq);
> +
> +	filp = fget_light(fd, &fput_needed);
> +	if (unlikely(filp == NULL)) {
> +		PFM_DBG("invalid fd %d", fd);
> +		return -EBADF;
> +	}
> +
> +	ctx = filp->private_data;
> +	ret = -EBADF;
> +
> +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> +		PFM_DBG("fd %d not related to perfmon", fd);
> +		goto error;
> +	}
> +
> +	ret = pfm_get_args(ureq, sz, sizeof(pmcs), pmcs, (void **)&req, &fptr);
> +	if (ret)
> +		goto error;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +
> +	ret = pfm_check_task_state(ctx, PFM_CMD_STOPPED, &flags);
> +	if (!ret)
> +		ret = __pfm_write_pmcs(ctx, req, count);
> +
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +	if (copy_to_user(ureq, req, sz))
> +		ret = -EFAULT;
> +
> +	/*
> +	 * This function may be on the critical path.
> +	 * We want to avoid the branch if unecessary.
> +	 */
> +	if (fptr)
> +		kfree(fptr);

This comment doesn't make a lot of sense, you have to kfree(fptr) because 
it could have been set in pfm_get_args() and kfree() can take a NULL 
value, so why do you need a branch here at all?  In fact, this branch 
looks like it will always be true since this is our ptr_free from a 
successful return of pfm_get_args() and this is on the success path.

> +error:
> +	fput_light(filp, fput_needed);
> +
> +	return ret;
> +}
> +
> +asmlinkage long sys_pfm_write_pmds(int fd, struct pfarg_pmd __user *ureq, int count)
> +{
> +	struct pfm_context *ctx;
> +	struct file *filp;
> +	struct pfarg_pmd pmds[PFM_PMD_STK_ARG];
> +	struct pfarg_pmd *req;
> +	void *fptr;
> +	unsigned long flags;
> +	size_t sz;
> +	int ret, fput_needed;
> +
> +	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
> +		return -EINVAL;
> +
> +	sz = count*sizeof(*ureq);
> +
> +	filp = fget_light(fd, &fput_needed);
> +	if (unlikely(filp == NULL)) {
> +		PFM_DBG("invalid fd %d", fd);
> +		return -EBADF;
> +	}
> +
> +	ctx = filp->private_data;
> +	ret = -EBADF;
> +
> +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> +		PFM_DBG("fd %d not related to perfmon", fd);
> +		goto error;
> +	}
> +
> +	ret = pfm_get_args(ureq, sz, sizeof(pmds), pmds, (void **)&req, &fptr);
> +	if (ret)
> +		goto error;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +
> +	ret = pfm_check_task_state(ctx, PFM_CMD_STOPPED, &flags);
> +	if (!ret)
> +		ret = __pfm_write_pmds(ctx, req, count, 0);
> +
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +	if (copy_to_user(ureq, req, sz))
> +		ret = -EFAULT;
> +
> +	if (fptr)
> +		kfree(fptr);
> +error:
> +	fput_light(filp, fput_needed);
> +
> +	return ret;
> +}
> +
> +asmlinkage long sys_pfm_read_pmds(int fd, struct pfarg_pmd __user *ureq, int count)
> +{
> +	struct pfm_context *ctx;
> +	struct file *filp;
> +	struct pfarg_pmd pmds[PFM_PMD_STK_ARG];
> +	struct pfarg_pmd *req;
> +	void *fptr;
> +	unsigned long flags;
> +	size_t sz;
> +	int ret, fput_needed;
> +
> +	if (count < 0 || count >= PFM_MAX_ARG_COUNT(ureq))
> +		return -EINVAL;
> +
> +	sz = count*sizeof(*ureq);
> +
> +	filp = fget_light(fd, &fput_needed);
> +	if (unlikely(filp == NULL)) {
> +		PFM_DBG("invalid fd %d", fd);
> +		return -EBADF;
> +	}
> +
> +	ctx = filp->private_data;
> +	ret = -EBADF;
> +
> +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> +		PFM_DBG("fd %d not related to perfmon", fd);
> +		goto error;
> +	}
> +
> +	ret = pfm_get_args(ureq, sz, sizeof(pmds), pmds, (void **)&req, &fptr);
> +	if (ret)
> +		goto error;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +
> +	ret = pfm_check_task_state(ctx, PFM_CMD_STOPPED, &flags);
> +	if (!ret)
> +		ret = __pfm_read_pmds(ctx, req, count);
> +
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +	if (copy_to_user(ureq, req, sz))
> +		ret = -EFAULT;
> +
> +	if (fptr)
> +		kfree(req);
> +error:
> +	fput_light(filp, fput_needed);
> +	return ret;
> +}
> +
> +asmlinkage long sys_pfm_restart(int fd)
> +{
> +	struct pfm_context *ctx;
> +	struct file *filp;
> +	unsigned long flags;
> +	int ret, fput_needed, complete_needed;
> +
> +	filp = fget_light(fd, &fput_needed);
> +	if (unlikely(filp == NULL)) {
> +		PFM_DBG("invalid fd %d", fd);
> +		return -EBADF;
> +	}
> +
> +	ctx = filp->private_data;
> +	ret = -EBADF;
> +
> +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> +		PFM_DBG("fd %d not related to perfmon", fd);
> +		goto error;
> +	}
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +
> +	ret = pfm_check_task_state(ctx, 0, &flags);
> +	if (!ret)
> +		ret = __pfm_restart(ctx, &complete_needed);
> +
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +	/*
> +	 * In per-thread mode with blocking notification, i.e.
> +	 * ctx->flags.blocking=1, we need to defer issuing the
> +	 * complete to unblock the blocked monitored thread.
> +	 * Otherwise we have a potential deadlock due to a lock
> +	 * inversion between the context lock and the task_rq_lock()
> +	 * which can happen if one thread is in this call and the other
> +	 * (the monitored thread) is in the context switch code.
> +	 *
> +	 * It is safe to access the context outside the critical section
> +	 * because:
> +	 * 	- we are protected by the fget_light(), so the context cannot
> +	 * 	  disappear.
> +	 * 	- we are protected against another thread issuing a extraneous
> +	 * 	  pfm_restart() because the ctx->flags.can-restart flag has
> +	 * 	  already been cleared
> +	 * 	- the restart_complete field is only touched by the context init
> +	 * 	  code (happens only once) or by wait_for_completion_interruptible
> +	 * 	  in __pfm_handle_work(), so this is already serialized
> +	 */
> +	if (complete_needed)
> +		complete(&ctx->restart_complete);
> +
> +error:
> +	fput_light(filp, fput_needed);
> +	return ret;
> +}
> +
> +asmlinkage long sys_pfm_stop(int fd)
> +{
> +	struct pfm_context *ctx;
> +	struct file *filp;
> +	unsigned long flags;
> +	int ret, fput_needed;
> +
> +	filp = fget_light(fd, &fput_needed);
> +	if (unlikely(filp == NULL)) {
> +		PFM_DBG("invalid fd %d", fd);
> +		return -EBADF;
> +	}
> +
> +	ctx = filp->private_data;
> +	ret = -EBADF;
> +
> +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> +		PFM_DBG("fd %d not related to perfmon", fd);
> +		goto error;
> +	}
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +
> +	ret = pfm_check_task_state(ctx, PFM_CMD_STOPPED, &flags);
> +	if (!ret)
> +		ret = __pfm_stop(ctx);
> +
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +error:
> +	fput_light(filp, fput_needed);
> +	return ret;
> +}
> +
> +asmlinkage long sys_pfm_start(int fd, struct pfarg_start __user *ureq)
> +{
> +	struct pfm_context *ctx;
> +	struct file *filp;
> +	struct pfarg_start req;
> +	unsigned long flags;
> +	int ret, fput_needed;
> +
> +	filp = fget_light(fd, &fput_needed);
> +	if (unlikely(filp == NULL)) {
> +		PFM_DBG("invalid fd %d", fd);
> +		return -EBADF;
> +	}
> +
> +	ctx = filp->private_data;
> +	ret = -EBADF;
> +
> +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> +		PFM_DBG("fd %d not related to perfmon", fd);
> +		goto error;
> +	}
> +
> +	/*
> +	 * the one argument is actually optional
> +	 */
> +	if (ureq && copy_from_user(&req, ureq, sizeof(req)))
> +		return -EFAULT;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +
> +	ret = pfm_check_task_state(ctx, PFM_CMD_STOPPED, &flags);
> +	if (!ret)
> +		ret = __pfm_start(ctx, ureq ? &req : NULL);
> +
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +error:
> +	fput_light(filp, fput_needed);
> +	return ret;
> +}
> +
> +asmlinkage long sys_pfm_load_context(int fd, struct pfarg_load __user *ureq)
> +{
> +	struct pfm_context *ctx;
> +	struct task_struct *task;
> +	struct file *filp;
> +	unsigned long flags;
> +	struct pfarg_load req;
> +	int ret, fput_needed;
> +
> +	if (copy_from_user(&req, ureq, sizeof(req)))
> +		return -EFAULT;
> +
> +	filp = fget_light(fd, &fput_needed);
> +	if (unlikely(filp == NULL)) {
> +		PFM_DBG("invalid fd %d", fd);
> +		return -EBADF;
> +	}
> +
> +	task = NULL;
> +	ctx = filp->private_data;
> +	ret = -EBADF;
> +
> +	if (unlikely(!ctx || filp->f_op != &pfm_file_ops)) {
> +		PFM_DBG("fd %d not related to perfmon", fd);
> +		goto error;
> +	}
> +
> +	/*
> +	 * in per-thread mode (not self-monitoring), get a reference
> +	 * on task to monitor. This must be done with interrupts enabled
> +	 * Upon succesful return, refcount on task is increased.
> +	 *
> +	 * fget_light() is protecting the context.
> +	 */
> +	if (!ctx->flags.system) {
> +		if (req.load_pid != current->pid) {
> +			ret = pfm_get_task(ctx, req.load_pid, &task);
> +			if (ret)
> +				goto error;
> +		} else
> +			task = current;
> +	}

This is the only call to pfm_get_task(), so it could be done by passing 
"task" as the third actual instead.

		David
