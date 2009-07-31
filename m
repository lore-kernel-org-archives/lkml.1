Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbZGaCWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbZGaCWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 22:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZGaCWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 22:22:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55762 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbZGaCWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 22:22:21 -0400
Message-ID: <4A725594.8020205@cn.fujitsu.com>
Date: Fri, 31 Jul 2009 10:23:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] cpusets: fix deadlock with cpu_down()->cpuset_lock()
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com> <20090729230043.GA28175@redhat.com> <4A70FD26.1010800@cn.fujitsu.com> <20090730175108.GC3617@redhat.com>
In-Reply-To: <20090730175108.GC3617@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 07/30, Lai Jiangshan wrote:
>> Oleg Nesterov wrote:
>>> On 07/29, Oleg Nesterov wrote:
>>>> I strongly believe the bug does exist, but this patch needs the review
>>>> from maintainers.
>>> Yes...
>>>
>>>> IOW, with this patch migration_call(CPU_DEAD) runs without callback_mutex,
>>>> but kernel/cpuset.c always takes get_online_cpus() before callback_mutex.
>>> Oh. I'm afraid this is not an option.
>>>
>>> callback_mutex should nest under cgroup_mutex, but cpu hotplu pathes
>>> take cgroup_mutex under cpu_hotplug->lock. Lockdep won't be happy.
>>>
>>> Oleg.
>>>
>> We have made great effort to remove get_online_cpus() from cgroup_mutex
>> critical region.
> 
> Agreed.
> 
>> We can migrate the owner of callback_mutex in migration_call(CPU_DEAD)
>> at first(and then take callback_mutex and migrate others).
> 
> Not sure I understand how can we do this. Even if we know the owner
> of callback_mutex, if we can migrate it safely without callback_mutex
> why we can't migrate other tasks without this lock?

Since we have migrated the owner, we can take callback_mutex to
migrate others ... 

> 
> In any case this doesn't look like a clean solution,

No, it's not a clean solution.

> imho. But I hardly understand what cpuset is,


> can't suggest something clever.

We can add cpuset_lock()/cpuset_unlock() around __stop_machine()
in _cpu_down().

cpuset_lock()
__stop_machine()
	......
	mutex_lock(&lock);
	# It's OK, because we don't require any other lock in this
	# critical region. It's will not cause any kinds of deadlock.
	......
	flush_workqueue(stop_machine_wq);
	# It's OK too. because all work functions(chill(),stop_cpu())
	# of stop_machine_wq don't require any other lock.
	......
	mutex_unlock(&lock);
cpuset_unlock()


This fixes the bug in migrate_call(). Because there is no task which
holds callback_mutex in dead cpu after we add
cpuset_lock()/cpuset_unlock() around __stop_machine() in _cpu_down().

And it helps for your "cpu_hotplug: don't play with current->cpus_allowed"
Am I right?

Lai

