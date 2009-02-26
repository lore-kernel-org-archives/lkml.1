Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZBZIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZBZIf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZBZIfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:35:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54563 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbZBZIfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:35:19 -0500
Message-ID: <49A65455.4030204@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 16:35:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
References: <49A6475F.4000502@cn.fujitsu.com>	<20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>	<49A6501B.7040604@cn.fujitsu.com> <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 26 Feb 2009 16:17:31 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> On Thu, 26 Feb 2009 15:40:15 +0800
>>> Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>
>>>> cpuacct_charge() is in fast-path, and checking of !cpuacct_susys.active
>>>> always returns false after cpuacct has been initialized at system boot.
>>>>
>>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>>> ---
>>>>  kernel/sched.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/kernel/sched.c b/kernel/sched.c
>>>> index 410eec4..fd2f7fc 100644
>>>> --- a/kernel/sched.c
>>>> +++ b/kernel/sched.c
>>>> @@ -9589,7 +9589,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>>>>  	struct cpuacct *ca;
>>>>  	int cpu;
>>>>  
>>>> -	if (!cpuacct_subsys.active)
>>>> +	if (unlikely(!cpuacct_subsys.active))
>>>>  		return;
>>>>  
>>> (Just curious)
>>> I wonder "ca = task_ca(tsk)" will return NULL if cpuacct subsys is not initalized.
>> Yes, it will be NULL, and that's why we need this check.
>>
>>> Then, can we just remove this check ?
>>>
>> cpuacct_charge() can be called before cpuacct is initialized, so we have to check this
>> case here.
>>
> My point is, 
> 

Ah, I see.

> ca = task_ca(tsk)
> for (; ca; ca->parent) {
>    ...
> }
> 

ca is not checked before hierarchy support, and it's a side-effect.

Before cpuacct is initialized, css == task->cgroups->subsys[cpuacct_subsys] == NULL,
but ca = task_ca(tsk) is not necessarily NULL, unless struct cgroup_subsys_state is the
first member of struct cpuacct.

And the above code actually should be:

do {
	...
} while (ca->parent);

> What is problem even if ca is NULL.
> 
