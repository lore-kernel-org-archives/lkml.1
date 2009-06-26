Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZFZUQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZFZUQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZFZUQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:16:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56538 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZFZUQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:16:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uWIWGgn3SM7UPwyWG8qgVnYJRyvaHcVFFZEzeEVR5efTwJ40Ylha05npdIgfCEAJr
	8p2v1fkmtklksg5t3QlrQ==
MIME-Version: 1.0
In-Reply-To: <20090626141020.849a081e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090623160720.36230fa2.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090626141020.849a081e.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 26 Jun 2009 13:16:23 -0700
Message-ID: <6599ad830906261316x52d6c115t720b87ba16b3617@mail.gmail.com>
Subject: Re: [PATCH] memcg: cgroup fix rmdir hang
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamezawa,

Sorry that I didn't get a chance to look at these patches before now.

On Thu, Jun 25, 2009 at 10:10 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I hope this will be a final bullet..
> I myself think this one is enough simple and good.
> I'm sorry that we need test again.
>
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> After commit: cgroup: fix frequent -EBUSY at rmdir
>              ec64f51545fffbc4cb968f0cea56341a4b07e85a
> cgroup's rmdir (especially against memcg) doesn't return -EBUSY
> by temporal ref counts. That commit expects all refs after pre_destroy()
> is temporary but...it wasn't. Then, rmdir can wait permanently.
> This patch tries to fix that and change followings.
>
>  - set CGRP_WAIT_ON_RMDIR flag before pre_destroy().
>  - clear CGRP_WAIT_ON_RMDIR flag when the subsys finds racy case.
>   if there are sleeping ones, wakes them up.
>  - rmdir() sleeps only when CGRP_WAIT_ON_RMDIR flag is set.
>
> Changelog v2->v3:
>  - removed retry_rmdir() callback.
>  - make use of CGRP_WAIT_ON_RMDIR flag more.
>
> Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/cgroup.h |   13 +++++++++++++
>  kernel/cgroup.c        |   38 ++++++++++++++++++++++----------------
>  mm/memcontrol.c        |   25 +++++++++++++++++++++++--
>  3 files changed, 58 insertions(+), 18 deletions(-)
>
> Index: mmotm-2.6.31-Jun25/include/linux/cgroup.h
> ===================================================================
> --- mmotm-2.6.31-Jun25.orig/include/linux/cgroup.h
> +++ mmotm-2.6.31-Jun25/include/linux/cgroup.h
> @@ -366,6 +366,19 @@ int cgroup_task_count(const struct cgrou
>  int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
>
>  /*
> + * Allow to use CGRP_WAIT_ON_RMDIR flag to check race with rmdir() for subsys.
> + * Subsys can call this function if it's necessary to call pre_destroy() again
> + * because it adds not-temporary refs to css after or while pre_destroy().
> + * The caller of this function should use css_tryget(), too.
> + */
> +void __cgroup_wakeup_rmdir_waiters(void);
> +static inline void cgroup_wakeup_rmdir_waiters(struct cgroup *cgrp)
> +{
> +       if (unlikely(test_and_clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
> +               __cgroup_wakeup_rmdir_waiters();
> +}
> +
> +/*
>  * Control Group subsystem type.
>  * See Documentation/cgroups/cgroups.txt for details
>  */
> Index: mmotm-2.6.31-Jun25/kernel/cgroup.c
> ===================================================================
> --- mmotm-2.6.31-Jun25.orig/kernel/cgroup.c
> +++ mmotm-2.6.31-Jun25/kernel/cgroup.c
> @@ -734,14 +734,13 @@ static void cgroup_d_remove_dir(struct d
>  * reference to css->refcnt. In general, this refcnt is expected to goes down
>  * to zero, soon.
>  *
> - * CGRP_WAIT_ON_RMDIR flag is modified under cgroup's inode->i_mutex;
> + * CGRP_WAIT_ON_RMDIR flag is set under cgroup's inode->i_mutex;
>  */
>  DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
>
> -static void cgroup_wakeup_rmdir_waiters(const struct cgroup *cgrp)
> +void __cgroup_wakeup_rmdir_waiters(void)
>  {

Maybe we should name this wakeup_rmdir_waiter() to emphasise that fact
that there will only be one waiter (the thread doing the rmdir).

> -       if (unlikely(test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
> -               wake_up_all(&cgroup_rmdir_waitq);
> +       wake_up_all(&cgroup_rmdir_waitq);
>  }
>
>  static int rebind_subsystems(struct cgroupfs_root *root,
> @@ -2696,33 +2695,40 @@ again:
>        mutex_unlock(&cgroup_mutex);
>
>        /*
> +        * css_put/get is provided for subsys to grab refcnt to css. In typical
> +        * case, subsystem has no reference after pre_destroy(). But, under
> +        * hierarchy management, some *temporal* refcnt can be hold.

This sentence needs improvement/clarification. (Yes, I know it's just
copied from later in the file, but it wasn't clear there either :-) )


> +        * To avoid returning -EBUSY to a user, waitqueue is used. If subsys
> +        * is really busy, it should return -EBUSY at pre_destroy(). wake_up
> +        * is called when css_put() is called and refcnt goes down to 0.
> +        * And this WAIT_ON_RMDIR flag is cleared when subsys detect a race
> +        * condition under pre_destroy()->rmdir.

What exactly do you mean by pre_destroy()->rmdir ?

> If flag is cleared, we need
> +        * to call pre_destroy(), again.
> +        */
> +       set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
> +
> +       /*
>         * Call pre_destroy handlers of subsys. Notify subsystems
>         * that rmdir() request comes.
>         */
>        ret = cgroup_call_pre_destroy(cgrp);
> -       if (ret)
> +       if (ret) {
> +               clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
>                return ret;
> +       }
>
>        mutex_lock(&cgroup_mutex);
>        parent = cgrp->parent;
>        if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
> +               clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
>                mutex_unlock(&cgroup_mutex);
>                return -EBUSY;
>        }
> -       /*
> -        * css_put/get is provided for subsys to grab refcnt to css. In typical
> -        * case, subsystem has no reference after pre_destroy(). But, under
> -        * hierarchy management, some *temporal* refcnt can be hold.
> -        * To avoid returning -EBUSY to a user, waitqueue is used. If subsys
> -        * is really busy, it should return -EBUSY at pre_destroy(). wake_up
> -        * is called when css_put() is called and refcnt goes down to 0.
> -        */
> -       set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
>        prepare_to_wait(&cgroup_rmdir_waitq, &wait, TASK_INTERRUPTIBLE);
> -
>        if (!cgroup_clear_css_refs(cgrp)) {
>                mutex_unlock(&cgroup_mutex);
> -               schedule();
> +               if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
> +                       schedule();

The need for this test_bit() should be commented, I think - at first
sight it doesn't seem necessary since if we've already been woken up,
then the schedule() is logically a no-op anyway. We only need it
because we are worried about the case where someone calls
wakeup_rmdir_waiters() prior to the prepare_to_wait()


> ===================================================================
> --- mmotm-2.6.31-Jun25.orig/mm/memcontrol.c
> +++ mmotm-2.6.31-Jun25/mm/memcontrol.c
> @@ -1234,6 +1234,12 @@ static int mem_cgroup_move_account(struc
>        ret = 0;
>  out:
>        unlock_page_cgroup(pc);
> +       /*
> +        * We charges against "to" which may not have any tasks. Then, "to"
> +        * can be under rmdir(). But in current implementation, caller of
> +        * this function is just force_empty() and it's garanteed that
> +        * "to" is never removed. So, we don't check rmdir status here.
> +        */
>        return ret;
>  }
>
> @@ -1455,6 +1461,7 @@ __mem_cgroup_commit_charge_swapin(struct
>                return;
>        if (!ptr)
>                return;
> +       css_get(&ptr->css);
>        pc = lookup_page_cgroup(page);
>        mem_cgroup_lru_del_before_commit_swapcache(page);
>        __mem_cgroup_commit_charge(ptr, pc, ctype);
> @@ -1484,7 +1491,13 @@ __mem_cgroup_commit_charge_swapin(struct
>                }
>                rcu_read_unlock();
>        }
> -       /* add this page(page_cgroup) to the LRU we want. */
> +       /*
> +        * At swapin, we may charge account against cgroup which has no tasks.
> +        * So, rmdir()->pre_destroy() can be called while we do this charge.
> +        * In that case, we need to call pre_destroy() again. check it here.
> +        */
> +       cgroup_wakeup_rmdir_waiters(ptr->css.cgroup);
> +       css_put(&ptr->css);
>
>  }
>
> @@ -1691,7 +1704,7 @@ void mem_cgroup_end_migration(struct mem
>
>        if (!mem)
>                return;
> -
> +       css_get(&mem->css);
>        /* at migration success, oldpage->mapping is NULL. */
>        if (oldpage->mapping) {
>                target = oldpage;
> @@ -1731,6 +1744,14 @@ void mem_cgroup_end_migration(struct mem
>         */
>        if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
>                mem_cgroup_uncharge_page(target);
> +       /*
> +        * At migration, we may charge account against cgroup which has no tasks
> +        * So, rmdir()->pre_destroy() can be called while we do this charge.
> +        * In that case, we need to call pre_destroy() again. check it here.
> +        */
> +       cgroup_wakeup_rmdir_waiters(mem->css.cgroup);
> +       css_put(&mem->css);

Having to do an extra get/put purely in order to seems unfortunate -
is that purely to force the cgroup_clear_css_refs() to fail?

Maybe we could wrap the get and the wakeup/put inside functions named
"cgroup_exclude_rmdir()" "cgroup_release_rmdir()" so that the mm
cgroup code is more self-explanatory.

Paul
