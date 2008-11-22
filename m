Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbYKVCCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbYKVCCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYKVCCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:02:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53789 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYKVCCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:02:43 -0500
Message-ID: <49276835.4000502@cn.fujitsu.com>
Date: Sat, 22 Nov 2008 10:02:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroups: enhance task_cgroup()
References: <4926762A.7000602@cn.fujitsu.com> <6599ad830811211058q3fe12e5coa62436e777b60f1a@mail.gmail.com>
In-Reply-To: <6599ad830811211058q3fe12e5coa62436e777b60f1a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> task_cgroup() calls cgroup_subsys_state().
> 
> No, it calls task_subsys_state()
> 
>> and we must use rcu_read_lock() to protect cgroup_subsys_state().
>> so we must use rcu_read_lock() to protect task_cgroup().
>>
>> but it'll not so friendly to caller: the callers of task_cgroup() have
>> held cgroup_lock(). it means that struct cgroup will not be freed.
>>
>> So this patch add rcu_read_lock() in task_cgroup() to enhance task_cgroup().
>> And we do NOT NEED FIX task_cgroup()'s callers, and cgroup_lock()
>> can protect task_cgroup().
> 
> Is there a reason to add an implicit rcu_read_lock() in task_cgroup()
> and not directly in task_subsys_state() ?
> 

I don't think it's a good idea to add rcu_read_lock() in task_cgroup() or
task_subsys_state(). The returned pointer of the 2 functions should be
protected by rcu_read_lock or cgroup_lock, so the caller should still
hold the lock by itself.

An example of this is:

static int mem_cgroup_charge_common(...)
{
	...
		rcu_read_lock();
		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
		if (unlikely(!mem)) {
			rcu_read_unlock();
			return 0;
		}
		/*
		 * For every charge from the cgroup, increment reference count
		 */
		css_get(&mem->css);
		rcu_read_unlock();
	...
}

> Paul
> 
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>> index 1164963..22901ff 100644
>> --- a/include/linux/cgroup.h
>> +++ b/include/linux/cgroup.h
>> @@ -359,6 +360,10 @@
>>  static inline struct cgroup* task_cgroup(struct task_struct *task,
>>                                               int subsys_id)
>>  {
>> -       return task_subsys_state(task, subsys_id)->cgroup;
>> +       struct cgroup *ret;
>> +       rcu_read_lock();
>> +       ret = task_subsys_state(task, subsys_id)->cgroup;
>> +       rcu_read_unlock();
>> +       return ret;
>>  }
>>
>>  int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *ss,
>>
>>
>>
