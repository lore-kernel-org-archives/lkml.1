Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYJUJ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYJUJ3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYJUJ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:29:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYJUJ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:29:30 -0400
Message-ID: <48FDA0F3.2070306@cn.fujitsu.com>
Date: Tue, 21 Oct 2008 17:29:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] freezer_cg: remove redundant check in freezer_can_attach()
References: <48FD26F5.1070809@cn.fujitsu.com> <48FD273F.3040505@cn.fujitsu.com> <48FD85A2.8090605@fr.ibm.com>
In-Reply-To: <48FD85A2.8090605@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> Li Zefan wrote:
>> It is sufficient to check if @task is frozen, and no need to check if
>> the original freezer is frozen.
> 
> hmm, a task being frozen does not mean that its freezer cgroup is 
> frozen.

If a task has being frozen, then can_attach() returns -EBUSY at once.
If a task isn't frozen, then we have orig_freezer->state == THAWED.

So we need to check the state of the task only.

> So the extra check seems valid but looking at the comment :
> 
> 	/*
> 	 * The call to cgroup_lock() in the freezer.state write method prevents
> 	 * a write to that file racing against an attach, and hence the
> 	 * can_attach() result will remain valid until the attach completes.
> 	 */
> 	static int freezer_can_attach(struct cgroup_subsys *ss,
> 
> how do we know that the task_freezer(task), which is not protected by
> the cgroup_lock(), is not going to change its state to CGROUP_FROZEN 
> it looks racy.
> 

Since freezer_can_attach() is called by cgroup core with cgroup_lock held, there is
no race with task attaching and state changing.

> C.
> 
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/cgroup_freezer.c |   16 +++++++---------
>>  1 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
>> index 7f54d1c..6fadafe 100644
>> --- a/kernel/cgroup_freezer.c
>> +++ b/kernel/cgroup_freezer.c
>> @@ -162,9 +162,13 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
>>  			      struct task_struct *task)
>>  {
>>  	struct freezer *freezer;
>> -	int retval;
>>  
>> -	/* Anything frozen can't move or be moved to/from */
>> +	/*
>> +	 * Anything frozen can't move or be moved to/from.
>> +	 *
>> +	 * Since orig_freezer->state == FROZEN means that @task has been
>> +	 * frozen, so it's sufficient to check the latter condition.
>> +	 */
>>  
>>  	if (is_task_frozen_enough(task))
>>  		return -EBUSY;
>> @@ -173,13 +177,7 @@ static int freezer_can_attach(struct cgroup_subsys *ss,
>>  	if (freezer->state == CGROUP_FROZEN)
>>  		return -EBUSY;
>>  
>> -	retval = 0;
>> -	task_lock(task);
>> -	freezer = task_freezer(task);
>> -	if (freezer->state == CGROUP_FROZEN)
>> -		retval = -EBUSY;
>> -	task_unlock(task);
>> -	return retval;
>> +	return 0;
>>  }
>>  
>>  static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
> 
> 
