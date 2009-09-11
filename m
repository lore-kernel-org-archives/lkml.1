Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZIKHQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZIKHQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZIKHQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:16:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50669 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZIKHQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:16:03 -0400
Message-ID: <4AA9F902.4030306@cn.fujitsu.com>
Date: Fri, 11 Sep 2009 15:15:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Gautham Shenoy <ego@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
References: <20090910192153.GA584@redhat.com> <1252615996.7205.99.camel@laptop>
In-Reply-To: <1252615996.7205.99.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-09-10 at 21:21 +0200, Oleg Nesterov wrote:
>> (my apologies to those who see this twice).
>>
>>
>> The 1st patch is preparation. 2-3 fix different problems, the 3rd one
>> depends on 2nd.
>>
>> These patches change the code which I don't really understand, please
>> review.
>>
>>
>> As for the 3rd patch, it replaces
>>
>> 	cpu_hotplug-dont-affect-current-tasks-affinity.patch
>>
>> in -mm tree. Imho the new patch is more simple and clean, but of course
>> this is subjective and I am biased.
> 
> Look good to me.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Ingo, will you stick them in -tip?
> 
>

Sorry. I was taken ill for weeks and forgot to follow these discussions.
Especially I should say sorry to Oleg.

I have different concept. cpuset_cpus_allowed() is not called at atomic
context nor non-preemptable context nor other critical context.
So it should be allowed to use mutexs. That's what I think.

There is a bug when migration_call() requires a mutex
before migration has been finished when cpu offline as Oleg described.

Bug this bug is only happened when cpu offline. cpu offline is rare and
is slowpath. I think we should fix cpu offline and ensure it requires
the mutex safely.

Oleg's patch moves all dirty things into CPUSET subsystem and makes
cpuset_cpus_allowed() does not require any mutex and increases CPUSET's
coupling. I don't feel it's good.

Anyway, Oleg's patch works good.

> > cpuset_cpus_allowed() is not only  used for CPU offline.
> > >
> > > sched_setaffinity() also uses it.
> 
> Sure. And it must take get_online_cpus() to avoid the races with hotplug.

Oleg hasn't answered that
"is it safe when pdflush() calls cpuset_cpus_allowed()?".
A patch may be needed to ensure pdflush() calls cpuset_cpus_allowed() safely.

One other minor thing:
Oleg's patch may introduce a trouble in PREEEMPT_RT tree, because
spinlock in RT is also mutex. Likely I'm wrong.

- Lai





