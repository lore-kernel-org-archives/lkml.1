Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbZHDAf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbZHDAf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 20:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZHDAfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 20:35:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbZHDAfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 20:35:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oM1AJ54j1y8wItkmXFdREwzUIKxisDljQC+SCi6YkNFPGjTVibg3CvSyUQD+ifgPt
	c7vM62Xa9I66Ie8jLLJYg==
MIME-Version: 1.0
In-Reply-To: <4A7649E1.4000200@cn.fujitsu.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015149.27908.25403.stgit@hastromil.mtv.corp.google.com>
	 <4A7649E1.4000200@cn.fujitsu.com>
Date: Mon, 3 Aug 2009 17:35:16 -0700
Message-ID: <2f86c2480908031735m7dbee753wf63724959ee135eb@mail.gmail.com>
Subject: Re: [PATCH 5/6] Lets ss->can_attach and ss->attach do whole 
	threadgroups at a time
From: Benjamin Blum <bblum@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 7:22 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> 09:51, Ben Blum wrote:
>> Lets ss->can_attach and ss->attach do whole threadgroups at a time
>>
>> This patch alters the ss->can_attach and ss->attach functions to be able to
>> deal with a whole threadgroup at a time, for use in cgroup_attach_proc. (This
>> is a pre-patch to cgroup-procs-writable.patch.)
>>
>> Currently, new mode of the attach function can only tell the subsystem about
>> the old cgroup of the threadgroup leader. No subsystem currently needs that
>> information for each thread that's being moved, but if one were to be added
>> (for example, one that counts tasks within a group) this bit would need to be
>> reworked a bit to tell the subsystem the right information.
>>
>> Signed-off-by: Ben Blum <bblum@google.com>
>>
>> ---
>>
>>  include/linux/cgroup.h   |    7 +++--
>>  kernel/cgroup.c          |    4 +--
>>  kernel/cgroup_freezer.c  |   15 +++++++++--
>>  kernel/cpuset.c          |   65 ++++++++++++++++++++++++++++++++++++----------
>>  kernel/ns_cgroup.c       |   16 ++++++++++-
>>  kernel/sched.c           |   37 ++++++++++++++++++++++++--
>>  mm/memcontrol.c          |    3 +-
>>  security/device_cgroup.c |    3 +-
>>  8 files changed, 122 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>> index 24e3f1a..8286758 100644
>> --- a/include/linux/cgroup.h
>> +++ b/include/linux/cgroup.h
>> @@ -408,10 +408,11 @@ struct cgroup_subsys {
>>                                                 struct cgroup *cgrp);
>>       int (*pre_destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
>>       void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
>> -     int (*can_attach)(struct cgroup_subsys *ss,
>> -                       struct cgroup *cgrp, struct task_struct *tsk);
>> +     int (*can_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
>> +                       struct task_struct *tsk, bool threadgroup);
>>       void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
>> -                     struct cgroup *old_cgrp, struct task_struct *tsk);
>> +                     struct cgroup *old_cgrp, struct task_struct *tsk,
>> +                     bool threadgroup);
>
> Could you also update Documentation/cgroups/cgroups.txt?
>
>>       void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
>>       void (*exit)(struct cgroup_subsys *ss, struct task_struct *task);
>>       int (*populate)(struct cgroup_subsys *ss,
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index a12bc8e..ea05d6b 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1324,7 +1324,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>>
>>       for_each_subsys(root, ss) {
>>               if (ss->can_attach) {
>> -                     retval = ss->can_attach(ss, cgrp, tsk);
>> +                     retval = ss->can_attach(ss, cgrp, tsk, false);
>>                       if (retval)
>>                               return retval;
>>               }
>> @@ -1362,7 +1362,7 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>>
>>       for_each_subsys(root, ss) {
>>               if (ss->attach)
>> -                     ss->attach(ss, cgrp, oldcgrp, tsk);
>> +                     ss->attach(ss, cgrp, oldcgrp, tsk, false);
>>       }
>>       set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
>>       synchronize_rcu();
>> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
>> index fb249e2..4e352ab 100644
>> --- a/kernel/cgroup_freezer.c
>> +++ b/kernel/cgroup_freezer.c
>> @@ -159,10 +159,9 @@ static bool is_task_frozen_enough(struct task_struct *task)
>>   */
>>  static int freezer_can_attach(struct cgroup_subsys *ss,
>>                             struct cgroup *new_cgroup,
>> -                           struct task_struct *task)
>> +                           struct task_struct *task, bool threadgroup)
>>  {
>>       struct freezer *freezer;
>> -
>
> Please reserve this blank line.
>
>>       /*
>>        * Anything frozen can't move or be moved to/from.
>>        *
>> @@ -177,6 +176,18 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
>>       if (freezer->state == CGROUP_FROZEN)
>>               return -EBUSY;
>>
>> +     if (threadgroup) {
>> +             struct task_struct *c;
>
> And better have a blank line here. ;)
>
>> +             rcu_read_lock();
>> +             list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
>> +                     if (is_task_frozen_enough(c)) {
>> +                             rcu_read_unlock();
>> +                             return -EBUSY;
>> +                     }
>> +             }
>> +             rcu_read_unlock();
>> +     }
>> +
>>       return 0;
>>  }
>>
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index 7e75a41..86397f4 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -1324,9 +1324,10 @@ static int fmeter_getrate(struct fmeter *fmp)
>>  static cpumask_var_t cpus_attach;
>>
>>  /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
>> -static int cpuset_can_attach(struct cgroup_subsys *ss,
>> -                          struct cgroup *cont, struct task_struct *tsk)
>> +static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>> +                          struct task_struct *tsk, bool threadgroup)
>>  {
>> +     int ret;
>>       struct cpuset *cs = cgroup_cs(cont);
>>
>>       if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
>> @@ -1343,18 +1344,50 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
>>       if (tsk->flags & PF_THREAD_BOUND)
>>               return -EINVAL;
>>
>> -     return security_task_setscheduler(tsk, 0, NULL);
>> +     ret = security_task_setscheduler(tsk, 0, NULL);
>> +     if (ret)
>> +             return ret;
>> +     if (threadgroup) {
>> +             struct task_struct *c;
>
> ditto
>
>> +             rcu_read_lock();
>> +             list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
>> +                     ret = security_task_setscheduler(c, 0, NULL);
>> +                     if (ret) {
>> +                             rcu_read_unlock();
>> +                             return ret;
>> +                     }
>> +             }
>> +             rcu_read_unlock();
>> +     }
>> +     return 0;
>> +}
>
>

All taken care of. Thanks.
