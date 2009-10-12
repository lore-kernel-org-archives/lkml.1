Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZJLAhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZJLAhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 20:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZJLAhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 20:37:38 -0400
Received: from nskntmtas04p.mx.bigpond.com ([61.9.168.146]:52536 "EHLO
	nskntmtas04p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbZJLAhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 20:37:37 -0400
Message-ID: <4AD27A25.8030802@bigpond.net.au>
Date: Mon, 12 Oct 2009 10:36:53 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Make sure task has correct sched_class after policy
 change
References: <e286470be617e07797b7.1253672517@mudlark.pw.nest> <1253687579.7695.89.camel@twins> <4ABA173B.4040106@bigpond.net.au>
In-Reply-To: <4ABA173B.4040106@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nskntotgx02p.mx.bigpond.com from [121.222.41.232] using ID pwil3058@bigpond.net.au at Mon, 12 Oct 2009 00:36:53 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150204.4AD27A26.00AC,ss=1,fgs=0
X-SIH-MSG-ID: rRw1FtX9TECznTh522DtQVUtlUy7/yU1v8pWRYIhuRsaTVjBu8PAR8u9caBD0fO5ii4zZV6VP2MwY6zuXonbt92gI7xRU4o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/09 22:40, Peter Williams wrote:
> On 23/09/09 16:32, Peter Zijlstra wrote:
>> On Wed, 2009-09-23 at 02:21 +0000, Peter Williams wrote:
>>> From the code in rt_mutex_setprio(), it is evident that the intention
>>> is that task's with a RT 'prio' value as a consequence of receiving a PI
>>> boost also have their 'sched_class' field set to '&rt_sched_class'.
>>> However, the code in __setscheduler() could result in this intention
>>> being frustrated.
>>>
>>> This patch fixes this problem.
>>>
>>> Signed-off-by: Peter Williams<pwil3058@bigpond.net.au>
>>
>> I think you're right, but the problem seems to be that it sets
>> sched_class based on policy, which seems fragile in the face of PI.
>>
>> How about the alternative below?
>
> Yes, that's what I meant to do i.e. use p->prio in the if condition. I
> sent a second patch with a fix but your solution is neater :-).
>
>>
>> ---
>> kernel/sched.c | 17 ++++-------------
>> 1 files changed, 4 insertions(+), 13 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 91843ba..753a52c 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -6129,23 +6129,14 @@ __setscheduler(struct rq *rq, struct
>> task_struct *p, int policy, int prio)
>> {
>> BUG_ON(p->se.on_rq);
>>
>> - p->policy = policy;
>> - switch (p->policy) {
>> - case SCHED_NORMAL:
>> - case SCHED_BATCH:
>> - case SCHED_IDLE:
>> - p->sched_class =&fair_sched_class;
>> - break;
>> - case SCHED_FIFO:
>> - case SCHED_RR:
>> - p->sched_class =&rt_sched_class;
>> - break;
>> - }
>> -
>> p->rt_priority = prio;
>> p->normal_prio = normal_prio(p);
>> /* we are holding p->pi_lock already */
>> p->prio = rt_mutex_getprio(p);
>> + if (rt_prio(p->prio))
>> + p->sched_class =&rt_sched_class;
>> + else
>> + p->sched_class =&fair_sched_class;
>> set_load_weight(p);
>> }
>
> Peter

What ever happened to this patch?  It doesn't seem to have made it into 
the main line yet.

Cheers
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
