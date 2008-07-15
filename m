Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYGOCZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYGOCZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGOCZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:25:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51788 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYGOCZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:25:07 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5338"; a="4710116"
Message-ID: <487C0A76.8060401@qualcomm.com>
Date: Mon, 14 Jul 2008 19:24:54 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
References: <487B05CE.1050508@jp.fujitsu.com> <200807141351.25092.borntraeger@de.ibm.com> <200807142234.40700.rusty@rustcorp.com.au> <487BA152.1070102@goop.org> <20080714212026.GA6705@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080714212026.GA6705@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Heiko Carstens wrote:
> On Mon, Jul 14, 2008 at 11:56:18AM -0700, Jeremy Fitzhardinge wrote:
>> Rusty Russell wrote:
>>> On Monday 14 July 2008 21:51:25 Christian Borntraeger wrote:
>>>> Am Montag, 14. Juli 2008 schrieb Hidetoshi Seto:
>>>>     
>>>>> +	/* Wait all others come to life */
>>>>> +	while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
>>>>> +		if (time_is_before_jiffies(limit))
>>>>> +			goto timeout;
>>>>> +		cpu_relax();
>>>>> +	}
>>>>> +
>>>>>       
>>>> Hmm. I think this could become interesting on virtual machines. The
>>>> hypervisor might be to busy to schedule a specific cpu at certain load
>>>> scenarios. This would cause a failure even if the cpu is not really locked
>>>> up. We had similar problems with the soft lockup daemon on s390.
>>> 5 seconds is a fairly long time.  If all else fails we could have a config 
>>> option to simply disable this code.
> 
> Hmm.. probably a stupid question: but what could happen that a real cpu
> (not virtual) becomes unresponsive so that it won't schedule a MAX_RT_PRIO-1
> prioritized task for 5 seconds?
I have a workload where MAX_PRIO RT thread runs and never yeilds. That's what
my cpu isolation patches/tree addresses. Stopmachine is the only (that I know
of) thing that really brakes in that case. btw In case you're wondering yes
we've discussed workqueue threads starvation and stuff in the other threads.
So yet it can happen.

>>>> It would be good to not-use wall-clock time, but really used cpu time
>>>> instead. Unfortunately I have no idea, if that is possible in a generic
>>>> way. Heiko, any ideas?
>>> Ah, cpu time comes up again.  Perhaps we should actually dig that up again; 
>>> Zach and Jeremy CC'd.
>> Hm, yeah. But in this case, it's tricky. CPU time is an inherently
>> per-cpu quantity. If cpu A is waiting for cpu B, and wants to do the
>> timeout in cpu-seconds, then it has to be in *B*s cpu-seconds (and if A
>> is waiting on B,C,D,E,F... it needs to measure separate timeouts with
>> separate timebases for each other CPU). It also means that if B is
>> unresponsive but also not consuming any time (blocked in IO,
>> administratively paused, etc), then the timeout will never trigger.
>>
>> So I think monotonic wallclock time actually makes the most sense here.
> 
> This is asking for trouble... a config option to disable this would be
> nice. But as I don't know which problem this patch originally addresses
> it might be that this is needed anyway. So lets see why we need it first.
How about this. We'll make this a sysctl, as Rusty already did, and set the
default to 0 which means "never timeout". That way crazy people like me who
care about this scenario can enable this feature.

btw Rusty, I just had this "why didn't I think of that" moments. This is
actually another way of handling my workload. I mean it certainly does not fix
the root case of the problems and we still need other things that we talked
about (non-blocking module delete, lock-free module insertion, etc) but at
least in the mean time it avoids wedging the machines for good.
btw I'd like that timeout in milliseconds. I think 5 seconds is way tooooo
long :).

Max
