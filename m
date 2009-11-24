Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZKXFig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZKXFig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZKXFif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:38:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41914 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZKXFie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:38:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0B714C.9080607@jp.fujitsu.com>
Date: Tue, 24 Nov 2009 14:38:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH tip/sched/core] introduce task_times() to replace	task_[us]time()
 pair
References: <4B061E9A.8040100@jp.fujitsu.com> <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> On Fri, Nov 20, 2009 at 01:44:10PM +0900, Hidetoshi Seto wrote:
>> Function task_[us]times() are called consecutively in almost all
>> cases.  However task_stime() is implemented to call task_utime()
>> from its inside, so such paired calls run task_utime() twice.
>>
>> It means we do heavy divisions (div_u64 + do_div) twice to get
>> stime and utime which can be obtained at same time by one set
>> of divisions.
>>
>> This patch introduces task_times(*tsk, *utime, *stime) to get
>> stime and utime at once, in better, optimized way.
>>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> [snip]
> 
>> @@ -5155,6 +5155,14 @@ cputime_t task_stime(struct task_struct *p)
>>  {
>>  	return p->stime;
>>  }
>> +
>> +void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
>> +{
>> +	if (ut)
>> +		*ut = task_utime(p);
>> +	if (st)
>> +		*st = task_stime(p);
>> +}
>>  #else
> 
> I think task_{u,s}time are not needed anymore. Can we just fully get
> rid of them and only use task_times() ?

Yes, we can :-)

I was just afraid that there were other task_{u,s}time users I could
not find.  So I separated it in another patch to remove the API, to be
posted later.  But if it is OK, I can put them together in one patch.
(Or it is still better to be separated and incremental one?) 

>>  #ifndef nsecs_to_cputime
>> @@ -5162,41 +5170,48 @@ cputime_t task_stime(struct task_struct *p)
>>  	msecs_to_cputime(div_u64((__nsecs), NSEC_PER_MSEC))
>>  #endif
> 
> Could we furhter optimize this? Perhaps we can use below code
> (taken from timespec_to_jiffies()):
> 
> 	cputime = (nsec * NSEC_CONVERSION) >>
>                  (NSEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;

I hope there were nsecs_to_jiffies().
It will be complex than:

  cputime = (nsec * NSEC_CONVERSION) >> NSEC_JIFFIE_SC;

In timespec_to_jiffies(), nsec is never greater than NSEC_PER_SEC.
So above will work without any overflow (I confirmed it becomes wrong
if nsec > (LLONG_MAX / NSEC_CONVERSION) = about 8190ms).

But here in task_timers() the nsec can be greater than hours (or days), 
we must be careful...

And just now I noticed that using msecs_to_cputime() is problematic,
since the type of its return value is "unsigned long" so not 64bit.
I'll make and post a patch to fix this asap.


...BTW, could anyone explain what the following (line 661) is doing?:

[kernel/time.c]
    649 u64 nsec_to_clock_t(u64 x)
    650 {
    651 #if (NSEC_PER_SEC % USER_HZ) == 0
    652         return div_u64(x, NSEC_PER_SEC / USER_HZ);
    653 #elif (USER_HZ % 512) == 0
    654         return div_u64(x * USER_HZ / 512, NSEC_PER_SEC / 512);
    655 #else
    656         /*
    657          * max relative error 5.7e-8 (1.8s per year) for USER_HZ <= 1024,
    658          * overflow after 64.99 years.
    659          * exact for HZ=60, 72, 90, 120, 144, 180, 300, 600, 900, ...
    660          */
    661         return div_u64(x * 9, (9ull * NSEC_PER_SEC + (USER_HZ / 2)) / USER_HZ);
    662 #endif
    663 }


Thanks,
H.Seto

