Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYAXHa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYAXHa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYAXHaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:30:18 -0500
Received: from brick.kernel.dk ([87.55.233.238]:25972 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYAXHaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:30:17 -0500
Date: Thu, 24 Jan 2008 08:30:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, knikanth@novell.com
Subject: Re: [PATCH 1/6] ioprio: move io priority from task_struct to  io_context
Message-ID: <20080124073012.GM6258@kernel.dk>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com> <1200995361-24001-2-git-send-email-jens.axboe@oracle.com> <20080123140747.39bb13d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123140747.39bb13d8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23 2008, Andrew Morton wrote:
> > On Tue, 22 Jan 2008 10:49:16 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> > This is where it belongs and then it doesn't take up space for a
> > process that doesn't do IO.
> > 
> > ...
> >
> >  struct io_context *get_io_context(gfp_t gfp_flags, int node)
> >  {
> > -	struct io_context *ret;
> > -	ret = current_io_context(gfp_flags, node);
> > -	if (likely(ret))
> > -		atomic_inc(&ret->refcount);
> > +	struct io_context *ret = NULL;
> > +
> > +	do {
> > +		ret = current_io_context(gfp_flags, node);
> > +		if (unlikely(!ret))
> > +			break;
> > +	} while (!atomic_inc_not_zero(&ret->refcount));
> 
> Looks weird.  Could do with a comment.  Or unweirding ;)
> 
> What's going on here?

In the unlikely event that we find a task that is on its way to exiting.
This hunk should actually be a part of the cfq lockless stuff...

> >  	return ret;
> >  }
> >  EXPORT_SYMBOL(get_io_context);
> > diff --git a/fs/ioprio.c b/fs/ioprio.c
> > index e4e01bc..a760040 100644
> > --- a/fs/ioprio.c
> > +++ b/fs/ioprio.c
> > @@ -41,18 +41,29 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
> >  		return err;
> >  
> >  	task_lock(task);
> > +	do {
> > +		ioc = task->io_context;
> > +		/* see wmb() in current_io_context() */
> > +		smp_read_barrier_depends();
> > +		if (ioc)
> > +			break;
> >  
> > -	task->ioprio = ioprio;
> > -
> > -	ioc = task->io_context;
> > -	/* see wmb() in current_io_context() */
> > -	smp_read_barrier_depends();
> > +		ioc = alloc_io_context(GFP_ATOMIC, -1);
> > +		if (!ioc) {
> > +			err = -ENOMEM;
> > +			break;
> > +		}
> > +		task->io_context = ioc;
> > +		ioc->task = task;
> > +	} while (1);
> 
> argh.  Can't sit there in a loop retrying GFP_ATOMIC!

It's not, read the loop again!

> > -	if (ioc)
> > +	if (!err) {
> > +		ioc->ioprio = ioprio;
> >  		ioc->ioprio_changed = 1;
> > +	}
> >  
> >  	task_unlock(task);
> > -	return 0;
> > +	return err;
> >  }
> >  
> >  asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
> >
> > ...
> >
> >  void put_io_context(struct io_context *ioc);
> >  void exit_io_context(void);
> >  struct io_context *get_io_context(gfp_t gfp_flags, int node);
> > +struct io_context *alloc_io_context(gfp_t, int);
> >  void copy_io_context(struct io_context **pdst, struct io_context **psrc);
> >  void swap_io_context(struct io_context **ioc1, struct io_context **ioc2);
> 
> The rest of the declarations around here nicely name their args.

A clear sign I didn't put those declarations there, but the inconsistent
style is surely not a good thing. Will fix that up.

> > +static int copy_io(struct task_struct *tsk)
> > +{
> > +	struct io_context *ioc = current->io_context;
> > +
> > +	if (!ioc)
> > +		return 0;
> > +
> > +	if (ioprio_valid(ioc->ioprio)) {
> > +		tsk->io_context = alloc_io_context(GFP_KERNEL, -1);
> > +		if (unlikely(!tsk->io_context))
> > +			return -ENOMEM;
> > +
> > +		tsk->io_context->task = tsk;
> > +		tsk->io_context->ioprio = ioc->ioprio;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Should this depend on CONFIG_BLOCK?

Good questions, checks... Looks like it would break, I'll do a
!CONFIG_BLOCK fixup round.

-- 
Jens Axboe

