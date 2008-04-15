Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbYDOAHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbYDOAHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 20:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYDOAHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 20:07:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbYDOAHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 20:07:39 -0400
Date: Mon, 14 Apr 2008 17:07:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: menage@google.com, serue@us.ibm.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Message-Id: <20080414170709.736819b6.akpm@linux-foundation.org>
In-Reply-To: <48036677.3010807@linux.vnet.ibm.com>
References: <48036677.3010807@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 19:43:11 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 1. Add mm->owner change callbacks using cgroups
> 
> This patch removes the mem_cgroup member from mm_struct and instead adds
> an owner. This approach was suggested by Paul Menage. The advantage of
> this approach is that, once the mm->owner is known, using the subsystem
> id, the cgroup can be determined. It also allows several control groups
> that are virtually grouped by mm_struct, to exist independent of the memory
> controller i.e., without adding mem_cgroup's for each controller,
> to mm_struct.
> 
> A new config option CONFIG_MM_OWNER is added and the memory resource
> controller selects this config option.
> 
> This patch also adds cgroup callbacks to notify subsystems when mm->owner
> changes. The mm_cgroup_changed callback is called with the task_lock()
> of the new task held and is called just prior to changing the mm->owner.
> 
> I am indebted to Paul Menage for the several reviews of this patchset
> and helping me make it lighter and simpler.
> 
> This patch was tested on a powerpc box, it was compiled with both the
> MM_OWNER config turned on and off.
> 
> After the thread group leader exits, it's moved to init_css_state by
> cgroup_exit(), thus all future charges from runnings threads would
> be redirected to the init_css_set's subsystem.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  fs/exec.c                  |    1
>  include/linux/cgroup.h     |   15 ++++++++
>  include/linux/memcontrol.h |   16 +-------
>  include/linux/mm_types.h   |    5 +-
>  include/linux/sched.h      |   13 +++++++
>  init/Kconfig               |    7 +++
>  init/main.c                |    1
>  kernel/cgroup.c            |   30 ++++++++++++++++
>  kernel/exit.c              |   83 +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/fork.c              |   11 ++++-
>  mm/memcontrol.c            |   24 +------------
>  11 files changed, 167 insertions(+), 39 deletions(-)
> 
> diff -puN fs/exec.c~memory-controller-add-mm-owner fs/exec.c
> --- linux-2.6.25-rc8/fs/exec.c~memory-controller-add-mm-owner	2008-04-08
> 17:23:20.000000000 +0530
> +++ linux-2.6.25-rc8-balbir/fs/exec.c	2008-04-08 17:23:20.000000000 +0530

Rather a lot of wordwrapping here, but the patch applied OK nonetheless. 
This means that all the code was within 80 columns ;)

> diff -puN kernel/cgroup.c~memory-controller-add-mm-owner kernel/cgroup.c
> --- linux-2.6.25-rc8/kernel/cgroup.c~memory-controller-add-mm-owner	2008-04-08
> 17:23:20.000000000 +0530
> +++ linux-2.6.25-rc8-balbir/kernel/cgroup.c	2008-04-08 17:29:45.000000000 +0530
> @@ -118,6 +118,7 @@ static int root_count;
>   * be called.
>   */
>  static int need_forkexit_callback;
> +static int need_mm_owner_callback __read_mostly;
> 
>  /* convenient tests for these bits */
>  inline int cgroup_is_removed(const struct cgroup *cgrp)
> @@ -2485,6 +2486,7 @@ static void __init cgroup_init_subsys(st
>  	}
> 
>  	need_forkexit_callback |= ss->fork || ss->exit;
> +	need_mm_owner_callback |= !!ss->mm_owner_changed;

I assume this trick is here to minimise runtime overhead on systems which
never use cgroups?

It'd be nice if the changelog were to describe what that overhead is.

Then I'd know whether to ask whether we should look at clearing
need_mm_owner_callback when the system stops using cgroups.  Somehow.

> 
> +#ifdef CONFIG_MM_OWNER
> +/*
> + * Task p is exiting and it owned mm, lets find a new owner for it

"let's"

> + */
> +static inline int
> +mm_need_new_owner(struct mm_struct *mm, struct task_struct *p)
> +{
> +	/*
> +	 * If there are other users of the mm and the owner (us) is exiting
> +	 * we need to find a new owner to take on the responsibility.
> +	 */

But this comment rather duplicates the above one.

> +	if (!mm)
> +		return 0;
> +	if (atomic_read(&mm->mm_users) <= 1)
> +		return 0;
> +	if (mm->owner != p)
> +		return 0;
> +	return 1;
> +}
> +
> +void mm_update_next_owner(struct mm_struct *mm)
> +{
> +	struct task_struct *c, *g, *p = current;
> +
> +retry:
> +	if (!mm_need_new_owner(mm, p))
> +		return;
> +
> +	read_lock(&tasklist_lock);
> +	/*
> +	 * Search in the children
> +	 */
> +	list_for_each_entry(c, &p->children, sibling) {
> +		if (c->mm == mm)
> +			goto assign_new_owner;
> +	}
> +
> +	/*
> +	 * Search in the siblings
> +	 */
> +	list_for_each_entry(c, &p->parent->children, sibling) {
> +		if (c->mm == mm)
> +			goto assign_new_owner;
> +	}
> +
> +	/*
> +	 * Search through everything else. We should not get
> +	 * here often
> +	 */
> +	do_each_thread(g, c) {
> +		if (c->mm == mm)
> +			goto assign_new_owner;
> +	} while_each_thread(g, c);
> +
> +	read_unlock(&tasklist_lock);

Potentially-long tasklist_lock hold times are a concern.  I don't suppose
rcu can save us?

Some additional commentary fleshing out "We should not get here often"
might set minds at ease.  How not-often?  Under which circumstances?

> +	return;
> +
> +assign_new_owner:
> +	BUG_ON(c == p);
> +	get_task_struct(c);
> +	/*
> +	 * The task_lock protects c->mm from changing.
> +	 * We always want mm->owner->mm == mm
> +	 */
> +	task_lock(c);
> +	/*
> +	 * Delay read_unlock() till we have the task_lock()
> +	 * to ensure that c does not slip away underneath us
> +	 */
> +	read_unlock(&tasklist_lock);
> +	if (c->mm != mm) {
> +		task_unlock(c);
> +		put_task_struct(c);
> +		goto retry;
> +	}
> +	cgroup_mm_owner_callbacks(mm->owner, c);

afaict no callbacks are implemented in this patch?  What's the plan here? 
Should be covered in the changelog, please.

> +	mm->owner = c;
> +	task_unlock(c);
> +	put_task_struct(c);
> +}
> +#endif /* CONFIG_MM_OWNER */
> +
>
> ...
>
>  static inline int page_cgroup_locked(struct page *page)
>  {
>  	return bit_spin_is_locked(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
> @@ -478,6 +464,7 @@ unsigned long mem_cgroup_isolate_pages(u
>  	int zid = zone_idx(z);
>  	struct mem_cgroup_per_zone *mz;
> 
> +	BUG_ON(!mem_cont);
>  	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);

The mem_cgroup_zoneinfo() will immediately and reliably oops if mem_cont is
NULL, won't it?  If so, the BUG_ON() is redundant?


