Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYDOSIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYDOSIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYDOSIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:08:18 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36367 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbYDOSIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:08:17 -0400
Date: Tue, 15 Apr 2008 21:13:59 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, menage@google.com, serue@us.ibm.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Message-ID: <20080415171359.GA352@tv-sign.ru>
References: <48036677.3010807@linux.vnet.ibm.com> <20080414170709.736819b6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414170709.736819b6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Andrew Morton wrote:
>
> On Mon, 14 Apr 2008 19:43:11 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > +void mm_update_next_owner(struct mm_struct *mm)
> > +{
> > +	struct task_struct *c, *g, *p = current;
> > +
> > +retry:
> > +	if (!mm_need_new_owner(mm, p))
> > +		return;
> > +
> > +	read_lock(&tasklist_lock);
> > +	/*
> > +	 * Search in the children
> > +	 */
> > +	list_for_each_entry(c, &p->children, sibling) {
> > +		if (c->mm == mm)
> > +			goto assign_new_owner;
> > +	}
> > +
> > +	/*
> > +	 * Search in the siblings
> > +	 */
> > +	list_for_each_entry(c, &p->parent->children, sibling) {
> > +		if (c->mm == mm)
> > +			goto assign_new_owner;
> > +	}
> > +
> > +	/*
> > +	 * Search through everything else. We should not get
> > +	 * here often
> > +	 */
> > +	do_each_thread(g, c) {
> > +		if (c->mm == mm)
> > +			goto assign_new_owner;
> > +	} while_each_thread(g, c);
> > +
> > +	read_unlock(&tasklist_lock);
> 
> Potentially-long tasklist_lock hold times are a concern.  I don't suppose
> rcu can save us?

I guess rcu can't help...

> Some additional commentary fleshing out "We should not get here often"
> might set minds at ease.  How not-often?  Under which circumstances?

Oh, I don't know what cgroup is, at all, but this looks really strange.

What about use_mm()? We can choose a kernel thread, but unuse_mm() doesn't
try to change ->owner...

Let's suppose the process with a lot of threads does exit_group() and nobody
else uses this ->mm. How many time we will re-assign mm->owner and iterate
over the all threads in system ?


Perhaps, we can add mm_struct->mm_user_list instead? In that case mm->owner
becomes first_entry()...

> > +assign_new_owner:
> > +	BUG_ON(c == p);
> > +	get_task_struct(c);
> > +	/*
> > +	 * The task_lock protects c->mm from changing.
> > +	 * We always want mm->owner->mm == mm
> > +	 */
> > +	task_lock(c);
> > +	/*
> > +	 * Delay read_unlock() till we have the task_lock()
> > +	 * to ensure that c does not slip away underneath us
> > +	 */
> > +	read_unlock(&tasklist_lock);

You can drop tasklist_lock right after get_task_struct(), the nested locks
are not preempt-friendly.

> > +	if (c->mm != mm) {
> > +		task_unlock(c);
> > +		put_task_struct(c);
> > +		goto retry;
> > +	}
> > +	cgroup_mm_owner_callbacks(mm->owner, c);

Can't we avoid calling cgroup_mm_owner_callbacks() at least when
mm->owner->cgroups == c->cgroups ?

Minor, but perhaps cgroup_mm_owner_callbacks() should check ->mm_owner_changed
!= NULL first, then play with task_cgroup()...

Oleg.

