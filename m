Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZHCSN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZHCSN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZHCSN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:13:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5476 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZHCSN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:13:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=IofCCMdNN3Inx9ZVd96NLXddoV/o0xxGxRkyleAz/tppvHoNZlPvfsX/4pOWIpn/o
	/pXJSmykvWAr2mNID+Upw==
MIME-Version: 1.0
In-Reply-To: <20090803175452.GA5481@us.ibm.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <20090803175452.GA5481@us.ibm.com>
Date: Mon, 3 Aug 2009 14:13:55 -0400
Message-ID: <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Benjamin Blum <bblum@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, lizf@cn.fujitsu.com, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 1:54 PM, Serge E. Hallyn<serue@us.ibm.com> wrote:
> Quoting Ben Blum (bblum@google.com):
> ...
>> +static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>> +                            struct task_struct *tsk, int guarantee)
>> +{
>> +     struct css_set *oldcg;
>> +     struct css_set *newcg;
>> +
>> +     /*
>> +      * get old css_set. we need to take task_lock and refcount it, because
>> +      * an exiting task can change its css_set to init_css_set and drop its
>> +      * old one without taking cgroup_mutex.
>> +      */
>> +     task_lock(tsk);
>> +     oldcg = tsk->cgroups;
>> +     get_css_set(oldcg);
>> +     task_unlock(tsk);
>> +     /*
>> +      * locate or allocate a new css_set for this task. 'guarantee' tells
>> +      * us whether or not we are sure that a new css_set already exists;
>> +      * in that case, we are not allowed to fail, as we won't need malloc.
>> +      */
>> +     if (guarantee) {
>> +             /*
>> +              * our caller promises us that the css_set we want already
>> +              * exists, so we use find_existing_css_set directly.
>> +              */
>> +             struct cgroup_subsys_state *template[CGROUP_SUBSYS_COUNT];
>> +             read_lock(&css_set_lock);
>> +             newcg = find_existing_css_set(oldcg, cgrp, template);
>> +             BUG_ON(!newcg);
>> +             get_css_set(newcg);
>> +             read_unlock(&css_set_lock);
>> +     } else {
>> +             might_sleep();
>
> So cgroup_task_migrate() might sleep, but
>
> ...
>
>
>> +     down_write(&leader->cgroup_fork_mutex);
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(tsk, &leader->thread_group, thread_group) {
>> +             /* leave current thread as it is if it's already there */
>> +             oldcgrp = task_cgroup(tsk, subsys_id);
>> +             if (cgrp == oldcgrp)
>> +                     continue;
>> +             /* we don't care whether these threads are exiting */
>> +             retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, 1);
>
> Here it is called under rcu_read_lock().

You'll notice the fourth argument, which tells cgroup_task_migrate
whether the css_set is guaranteed or not. If we say we've already got
it covered, the might_sleep section doesn't happen.

>> -void cgroup_fork(struct task_struct *child)
>> +void cgroup_fork(struct task_struct *child, int clone_flags)
>>  {
>> +     if (clone_flags & CLONE_THREAD)
>> +             down_read(&current->group_leader->cgroup_fork_mutex);
>> +     else
>> +             init_rwsem(&child->cgroup_fork_mutex);
>
> I'm also worried about the overhead here on what should be a
> fast case, CLONE_THREAD.  Have you done any benchmarking of
> one thread spawning a bunch of others?

Should be strictly better as this is making the rwsem local to the
threadgroup - at least in comparison to the previous edition of this
patch which had it as a global lock.

> What *exactly* is it we are protecting with cgroup_fork_mutex?
> 'fork' (as the name implies) is not a good answer, since we should be
> protecting data, not code.  If it is solely tsk->cgroups, then perhaps
> we should in fact try switching to (s?)rcu.  Then cgroup_fork() could
> just do rcu_read_lock, while cgroup_task_migrate() would make the change
> under a spinlock (to protect against concurrent cgroup_task_migrate()s),
> and using rcu_assign_pointer to let cgroup_fork() see consistent data
> either before or after the update...  That might mean that any checks done
> before completing the migrate which involve the # of tasks might become
> invalidated before the migration completes?  Seems acceptable (since
> it'll be a small overcharge at most and can be quickly remedied).

You'll notice where the rwsem is released - not until cgroup_post_fork
or cgroup_fork_failed. It doesn't just protect the tsk->cgroups
pointer, but rather guarantees atomicity between adjusting
tsk->cgroups and attaching it to the cgroups lists with respect to the
critical section in attach_proc. If you've a better name for the lock
for such a race condition, do suggest.
