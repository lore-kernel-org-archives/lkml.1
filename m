Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbXFFBiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbXFFBiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764364AbXFFBiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:38:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24270 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763383AbXFFBiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:38:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=TbgNDFAgXPAGAF0+Y1P9Bka0MFalplTvfRFIBQwyBcLmZN4kGkY8+Ab6Y6mM+3kBT
	6DW2rA9S21wsLjZdbmEmw==
Date: Tue, 5 Jun 2007 18:34:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@hpl.hp.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] 2.6.22-rc3 perfmon2 : new system calls support
In-Reply-To: <20070605211711.GD11693@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706051826330.23799@chino.kir.corp.google.com>
References: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com>
 <alpine.DEB.0.99.0706040729230.10505@chino.kir.corp.google.com>
 <20070605211711.GD11693@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Stephane Eranian wrote:

> > > +static int pfm_task_incompatible(struct pfm_context *ctx, struct task_struct *task)
> > > +{
> > > +	/*
> > > +	 * no kernel task or task not owned by caller
> > > +	 */
> > > +	if (!task->mm) {
> > > +		PFM_DBG("cannot attach to kernel thread [%d]", task->pid);
> > > +		return -EPERM;
> > > +	}
> > 
> > This isn't a sufficient check for whether a task is owned by the caller.
> > 
> 
> The comment is missing a part. The ownership test is done by ptrace_may_attahc().
> The above test is about checking for a kernel-only thread.
> 

Ok.

> > > +int pfm_get_task(struct pfm_context *ctx, pid_t pid, struct task_struct **task)
> > > +{
> > 
> > This function could be marked static even though it's exported through 
> > perfmon.h in patch 13.  It is unreferenced elsewhere.
> > 
> No because it is used in another module on IA-64 (for compatibility with older versions).
> 

Is this ia64 patch the one you mentioned that you did not post to LKML 
because it was too large in patch 0?  Is there any way you could break 
that patch up itself and post it for comments?

> > Why can't this be done with just struct task_struct *task as the third 
> > formal and change the assignment later to task = p?
> > 
> Because we need to carry the errno back: ESRCH or EPERM.
> 

Your formal is "struct task_struct **task" yet the only actual to this 
function is the memory address of a pointer to a single struct task_struct 
(i.e. it's never passed an array of struct task_struct pointers, which 
"struct task_struct **task" is).

And since you only ever use this has *task to get the pointer, you can 
change the formal to just be "struct task_struct *task" and then pass in a 
pointer to a single struct task_struct.

> > > +	if (check_mask & PFM_CMD_STOPPED) {
> > > +
> > > +		spin_unlock_irqrestore(&ctx->lock, local_flags);
> > > +
> > > +		/*
> > > +		 * check that the thread is ptraced AND STOPPED
> > > +		 */
> > > +		ret = ptrace_check_attach(task, 0);
> > > +
> > > +		spin_lock_irqsave(&ctx->lock, new_flags);
> > > +
> > > +		/*
> > > +		 * flags may be different than when we released the lock
> > > +		 */
> > > +		*flags = new_flags;
> > 
> > You can't do this, you'll need to either separate these functions out by 
> > having pfm_check_task_state() indicate by a return value that 
> > ptrace_check_attach() should be checked or that we've already failed, or 
> > come up with a non-locking solution.
> > 
> Are you worried about the the local_flags vs. new flags?
> I think your solution would be cleaner, I will see what I can do.
> 

It should be simple if this is broken down into two smaller functions, the 
latter of which is called only upon a successful return of the former.

> > > +
> > > +asmlinkage long sys_pfm_write_pmcs(int fd, struct pfarg_pmc __user *ureq, int count)
> > > +{
> > > +	struct pfm_context *ctx;
> > > +	struct file *filp;
> > > +	struct pfarg_pmc pmcs[PFM_PMC_STK_ARG];
> > > +	struct pfarg_pmc *req;
> > > +	void *fptr;
> > > +	unsigned long flags;
> > > +	size_t sz;
> > > +	int ret, fput_needed;
> > > +
> > 
> > Could this have a stack overflow on powerpc?
> > 
> The PFM_PMC_STK_ARG is per-arch,  so you could chose a very low value. 
> I think it is set to 4. pfarg_pmc s 48 bytes and pfarg_pmd is 176 bytes
> regardless of LP64 vs. ILP32.
> 

Stack overflows like that are annoying to track down and powerpc has the 
highest PFM_PMC_STK_ARG of the entire patchset.

> Thanks for your feedback.
> 

I'm looking forward to seeing the next patchset and I'll give it a 
thorough test run on x86_64.  It'd probably be best to base that patchset 
off 2.6.22 when it's released.

		David
