Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbYCXQY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbYCXQY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYCXQYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:24:50 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:32881 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYCXQYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:24:49 -0400
Message-ID: <47E7D51E.4050304@linux.vnet.ibm.com>
Date: Mon, 24 Mar 2008 21:51:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Memory controller add mm->owner
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain> <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com>
In-Reply-To: <6599ad830803240803s5160101bi2bf68b36085f777f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 24, 2008 at 7:01 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  --- linux-2.6.25-rc5/include/linux/mm_types.h~memory-controller-add-mm-owner    2008-03-20 13:35:09.000000000 +0530
>>  +++ linux-2.6.25-rc5-balbir/include/linux/mm_types.h    2008-03-20 15:11:05.000000000 +0530
>>  @@ -228,7 +228,10 @@ struct mm_struct {
>>         rwlock_t                ioctx_list_lock;
>>         struct kioctx           *ioctx_list;
>>   #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>>  -       struct mem_cgroup *mem_cgroup;
>>  +       struct task_struct *owner;      /* The thread group leader that */
>>  +                                       /* owns the mm_struct. This     */
>>  +                                       /* might be useful even outside */
>>  +                                       /* of the config option         */
>>   #endif
> 
> This should probably be controlled by something like a CONFIG_MM_OWNER
> that's selected by any Kconfig option (mem cgroup, etc) that needs
> mm->owner to be maintained.
> 

OK, will do

>>  @@ -248,12 +248,40 @@ void mm_init_cgroup(struct mm_struct *mm
>>
>>         mem = mem_cgroup_from_task(p);
>>         css_get(&mem->css);
>>  -       mm->mem_cgroup = mem;
>>  +       mm->owner = p;
>>  +}
>>  +
>>  +void mem_cgroup_fork_init(struct task_struct *p)
>>  +{
>>  +       struct mm_struct *mm = get_task_mm(p);
>>  +       struct mem_cgroup *mem, *oldmem;
>>  +       if (!mm)
>>  +               return;
>>  +
>>  +       /*
>>  +        * Initial owner at mm_init_cgroup() time is the task itself.
>>  +        * The thread group leader had not been setup then
>>  +        */
>>  +       oldmem = mem_cgroup_from_task(mm->owner);
>>  +       /*
>>  +        * Override the mm->owner after we know the thread group later
>>  +        */
>>  +       mm->owner = p->group_leader;
>>  +       mem = mem_cgroup_from_task(mm->owner);
>>  +       css_get(&mem->css);
>>  +       css_put(&oldmem->css);
>>  +       mmput(mm);
>>   }
>>
>>   void mm_free_cgroup(struct mm_struct *mm)
>>   {
>>  -       css_put(&mm->mem_cgroup->css);
>>  +       struct mem_cgroup *mem;
>>  +
>>  +       /*
>>  +        * TODO: Should we assign mm->owner to NULL here?
>>  +        */
>>  +       mem = mem_cgroup_from_task(mm->owner);
>>  +       css_put(&mem->css);
>>   }
> 
> It seems to me that the code to setup/maintain mm->owner should be
> independent of the control groups, but should be part of the generic
> fork/exit code.
> 

Hmm.. Yes, we will need to do that if we decide to go with the MM_OWNER approach.

> Also, if mm->owner exits but mm is still alive (unlikely, but could
> happen with weird custom threading libraries?) then we need to
> reassign mm->owner to one of the other users of the mm (by looking
> first in the thread group, then among the parents/siblings/children,
> and then among all processes as a last resort?)
> 

The comment in __exit_signal states that

"The group leader stays around as a zombie as long
 as there are other threads.  When it gets reaped,
 the exit.c code will add its counts into these totals."

Given that the thread group leader stays around, do we need to reassign
mm->owner? Do you do anything special in cgroups like cleanup the
task_struct->css->subsys_state on exit?

>>  -       rcu_read_lock();
>>  -       mem = rcu_dereference(mm->mem_cgroup);
>>  +       mem = mem_cgroup_from_task(mm->owner);
> 
> I think we still need the rcu_read_lock(), since mm->owner can move
> cgroups any time.
> 

OK, so cgroup task movement is protected by RCU, right? I'll check for all
mm->owner uses.

>>  @@ -1069,7 +1096,6 @@ static void mem_cgroup_move_task(struct
>>                 goto out;
>>
>>         css_get(&mem->css);
>>  -       rcu_assign_pointer(mm->mem_cgroup, mem);
>>         css_put(&old_mem->css);
>>
> 
> We shouldn't need reference counting on this pointer, since the
> cgroups framework won't allow a subsystem to be freed while it has any
> tasks in it.
> 

This reference earlier indicated that there were active mm->mem_cgroup users of
the cgroup. With mm->owner changes, we might not require this. Let me double
confirm that.

Thanks for the review.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
