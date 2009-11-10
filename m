Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZKJBam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZKJBam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 20:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZKJBal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 20:30:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59052 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZKJBak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 20:30:40 -0500
Message-ID: <4AF8C20C.1070003@cn.fujitsu.com>
Date: Tue, 10 Nov 2009 09:29:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@free.fr>
CC: Ben Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, menage@google.com
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by
 tgid at	once
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com> <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com> <4AF84C68.7010803@free.fr>
In-Reply-To: <4AF84C68.7010803@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano wrote:
> Ben Blum wrote:
>> Makes procs file writable to move all threads by tgid at once
>>
>> This patch adds functionality that enables users to move all threads in a
>> threadgroup at once to a cgroup by writing the tgid to the 'cgroup.procs'
>> file. This current implementation makes use of a rwsem that's taken for
>> reading in the fork() path to prevent newly forking threads within the
>> threadgroup from "escaping" while moving is in progress.
>>
>> Signed-off-by: Ben Blum <bblum@google.com>
>>   
> [ cut ]
>>  /**
>> + * cgroup_fork_failed - undo operations for fork failure
>> + * @tsk: pointer to  task_struct of exiting process
>> + * @run_callback: run exit callbacks?
>> + *
>> + * Description: Undo cgroup operations after cgroup_fork in fork
>> failure.
>> + *
>> + * We release the read lock that was taken in cgroup_fork(), since it is
>> + * supposed to be dropped in cgroup_post_fork in the success case.
>> The other
>> + * thing that wants to be done is detaching the failed child task
>> from the
>> + * cgroup, so we wrap cgroup_exit.
>> + */
>> +void cgroup_fork_failed(struct task_struct *tsk, int run_callbacks)
>> +{
>> +    up_read(&cgroup_fork_mutex);
>> +    cgroup_exit(tsk, run_callbacks);
>> +}
>> +
>> +/**
>>   * cgroup_clone - clone the cgroup the given subsystem is attached to
>>   * @tsk: the task to be moved
>>   * @subsys: the given subsystem
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 926c117..027ec16 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -1300,7 +1300,7 @@ bad_fork_cleanup_policy:
>>      mpol_put(p->mempolicy);
>>  bad_fork_cleanup_cgroup:
>>  #endif
>> -    cgroup_exit(p, cgroup_callbacks_done);
>> +    cgroup_fork_failed(p, cgroup_callbacks_done);
>>      delayacct_tsk_free(p);
>>      if (p->binfmt)
>>          module_put(p->binfmt->module);
>>   
> Hi Ben,
> 
> The current code (with or without your patch) may lead to an error
> because the fork hook can fail and the exit hook is called in all the
> cases making the fork / exit asymmetric.
> 

The _current_ code won't lead to this error, because the fork hook
can't fail.

> I will take the usual example with a cgroup with a counter of tasks, in
> the fork hook it increments the counter, in the exit hook it decrements
> the counter. There is one process in the cgroup, hence the counter value
> is 1. Now this process forks and the fork hook fails before the task
> counter is incremented to 2, this is not detected in copy process
> function because the cgroup_fork_callbacks does not return an error, so
> the process will be forked without error and when the process will exits
> the counter will be decremented reaching 0 instead of 1.
> 
> IMO, the correct fix should be to make the fork hook to return an error
> and have the cgroup to call the exit method of the subsystem where the
> fork hook was called. For example, there are 10 subsystems using the
> fork / exit hooks, when the a process forks, the fork callbacks is
> called for these subsystems but, let's say, the 3rd fails. So we undo,
> by calling the exit hooks of the first two.
> 
> I wrote a patchset to consolidate the hooks called in the cgroup for
> fork and exit, and one of them does a rollback for the fork hook when an
> error occurs. I added an attachment the patch as an example.
> 

I'd like to see this patch sent with another patch that needs this
fail-able fork() hook.

Note this patch is not doing a _fix_, but does an extension. And
for now, this extension is not needed.
