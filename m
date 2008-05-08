Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbYEHOzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbYEHOzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYEHOzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:55:10 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:46738 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbYEHOzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:55:07 -0400
Message-ID: <48231438.9030803@linux.vnet.ibm.com>
Date: Thu, 08 May 2008 20:24:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 3/4] Add rlimit controller accounting and control
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213814.3140.66080.sendpatchset@localhost.localdomain> <6599ad830805062017n67d67f19w1469050d45e46ad6@mail.gmail.com>
In-Reply-To: <6599ad830805062017n67d67f19w1469050d45e46ad6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sat, May 3, 2008 at 2:38 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  +
>>  +int rlimit_cgroup_charge_as(struct mm_struct *mm, unsigned long nr_pages)
>>  +{
>>  +       int ret;
>>  +       struct rlimit_cgroup *rcg;
>>  +
>>  +       rcu_read_lock();
>>  +       rcg = rlimit_cgroup_from_task(rcu_dereference(mm->owner));
>>  +       css_get(&rcg->css);
>>  +       rcu_read_unlock();
>>  +
>>  +       ret = res_counter_charge(&rcg->as_res, (nr_pages << PAGE_SHIFT));
>>  +       css_put(&rcg->css);
>>  +       return ret;
>>  +}
> 
> You need to synchronize against mm->owner changing, or
> mm->owner->cgroups changing. How about:
> 
> int rlimit_cgroup_charge_as(struct mm_struct *mm, unsigned long nr_pages)
> {
>   int ret;
>   struct rlimit_cgroup *rcg;
>   struct task_struct *owner;
> 
>   rcu_read_lock();
>  again:
> 
>   /* Find and lock the owner of the mm */
>   owner = rcu_dereference(mm->owner);
>   task_lock(owner);
>   if (mm->owner != owner) {
>     task_unlock(owner);
>     goto again;
>   }
> 
>   /* Charge the owner's cgroup with the new memory */
>   rcg = rlimit_cgroup_from_task(owner);
>   ret = res_counter_charge(&rcg->as_res, (nr_pages << PAGE_SHIFT));
>   task_unlock(owner);
>   rcu_read_unlock();
>   return ret;
> }
> 

My mind goes blank at times, so forgive me asking, what happens if we don't use
task_lock(). mm->owner cannot be freed, even if it changes, we get the callback
in mm_owner_changed(). The locations from where we call _charge and _uncharge,
we know that the mm is not going to change either.

>>  +
>>  +void rlimit_cgroup_uncharge_as(struct mm_struct *mm, unsigned long nr_pages)
>>  +{
>>  +       struct rlimit_cgroup *rcg;
>>  +
>>  +       rcu_read_lock();
>>  +       rcg = rlimit_cgroup_from_task(rcu_dereference(mm->owner));
>>  +       css_get(&rcg->css);
>>  +       rcu_read_unlock();
>>  +
>>  +       res_counter_uncharge(&rcg->as_res, (nr_pages << PAGE_SHIFT));
>>  +       css_put(&rcg->css);
>>  +}
> 
> Can't this be implemented as just a call to charge() with a negative
> value? (Possibly fixing res_counter_charge() to handle negative values
> if necessary) Seems simpler.
> 

I did that earlier, but then Pavel suggested splitting it up as charge/uncharge.
I found that his suggestion helped make the code more readable.

>>  +/*
>>  + * TODO: get the attach callbacks to fail and disallow task movement.
>>  + */
> 
> You mean disallow all movement within a hierarchy that has this cgroup
> mounted? Doesn't that make it rather hard to use?
> 

Consider the following scenario

We try to move task "t1" from cgroup "A" to cgroup "B".
Doing so, causes "B" to go over it's limit, what do we do?
Ideally, we would like to be able to go back to cgroups and say, please fail
attach, since that causes "B" to go over it's specified limit.

>>  +static void rlimit_cgroup_move_task(struct cgroup_subsys *ss,
>>  +                                       struct cgroup *cgrp,
>>  +                                       struct cgroup *old_cgrp,
>>  +                                       struct task_struct *p)
>>  +{
>>  +       struct mm_struct *mm;
>>  +       struct rlimit_cgroup *rcg, *old_rcg;
>>  +
>>  +       mm = get_task_mm(p);
>>  +       if (mm == NULL)
>>  +               return;
>>  +
>>  +       rcu_read_lock();
>>  +       if (p != rcu_dereference(mm->owner))
>>  +               goto out;
>>  +
>>  +       rcg = rlimit_cgroup_from_cgrp(cgrp);
>>  +       old_rcg = rlimit_cgroup_from_cgrp(old_cgrp);
>>  +
>>  +       if (rcg == old_rcg)
>>  +               goto out;
>>  +
>>  +       if (res_counter_charge(&rcg->as_res, (mm->total_vm << PAGE_SHIFT)))
>>  +               goto out;
>>  +       res_counter_uncharge(&old_rcg->as_res, (mm->total_vm << PAGE_SHIFT));
>>  +out:
>>  +       rcu_read_unlock();
>>  +       mmput(mm);
>>  +}
>>  +
> 
> Since you need to protect against concurrent charges, and against
> concurrent mm ownership changes, I think you should just do this under
> task_lock(p).

Please see my comment above on task_lock(). I'll draw some diagrams on the
whiteboard and check the sanity of my argument.

> 
>>  +static void rlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
>>  +                                               struct cgroup *cgrp,
>>  +                                               struct cgroup *old_cgrp,
>>  +                                               struct task_struct *p)
>>  +{
>>  +       struct rlimit_cgroup *rcg, *old_rcg;
>>  +       struct mm_struct *mm = get_task_mm(p);
>>  +
>>  +       BUG_ON(!mm);
>>  +       rcg = rlimit_cgroup_from_cgrp(cgrp);
>>  +       old_rcg = rlimit_cgroup_from_cgrp(old_cgrp);
>>  +       if (res_counter_charge(&rcg->as_res, (mm->total_vm << PAGE_SHIFT)))
>>  +               goto out;
>>  +       res_counter_uncharge(&old_rcg->as_res, (mm->total_vm << PAGE_SHIFT));
>>  +out:
>>  +       mmput(mm);
>>  +}
>>  +
> 
> Also needs to task_lock(p) to prevent concurrent charges or cgroup
> reassignments?
> 

The callbacks are called with task_lock() held. Please see
mm_update_next_owner->cgroup_mm_owner_callbacks() in kernel/exit.c

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
