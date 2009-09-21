Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZIUEFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZIUEFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 00:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZIUEFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 00:05:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58228 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbZIUEFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 00:05:42 -0400
Message-ID: <4AB6FB62.3000605@cn.fujitsu.com>
Date: Mon, 21 Sep 2009 12:04:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>	 <1252696132.3756.21.camel@sbs-t61.sc.intel.com>	 <4AADEF2F.5080504@cn.fujitsu.com>	 <1252973802.2899.88.camel@sbs-t61.sc.intel.com>	 <4AAEF5DC.4070308@cn.fujitsu.com>	 <1253067602.2667.13.camel@sbs-t61.sc.intel.com>	 <4AB1A652.1010000@cn.fujitsu.com>	 <1253326599.3948.732.camel@sbs-t61.sc.intel.com>	 <4AB6EB1C.5090106@cn.fujitsu.com> <1253502682.2528.4.camel@sbs-t61>
In-Reply-To: <1253502682.2528.4.camel@sbs-t61>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Suresh Siddha wrote:
> On Sun, 2009-09-20 at 19:55 -0700, Xiao Guangrong wrote:
>> Suresh Siddha wrote:
>>> On Wed, 2009-09-16 at 20:00 -0700, Xiao Guangrong wrote: 
>>>> How about manual check/handle pending IPI interruption in the CPU context?
>>>> like this:
>>>> --- a/kernel/cpu.c
>>>> +++ b/kernel/cpu.c
>>>> @@ -173,6 +173,9 @@ static int __ref take_cpu_down(void *_param)
>>>>  	struct take_cpu_down_param *param = _param;
>>>>  	int err;
>>>>  
>>>> +	generic_smp_call_function_interrupt();
>>>> +	generic_smp_call_function_single_interrupt();
>>>> +
>>> At this place, how will you ensure that the smp_call_function initiated
>>> by this dying cpu has reached and got serviced at its destination?
>>>
>> Suresh, sorry for my poor English, Do you mean that how we ensure it has
>> pending IPI request in the dying cpu?
>>
>> generic_smp_call_function_*() will check it, if the cpu has pending request,
>> then handle it, else directly return.
>>
> 
> I am referring to the missing csd_lock_wait() here that you had in the
> first version of your patch. Let's say, if cpu X is going offline, we
> need to ensure that the smp_call_function() initiated by cpu X (i.e.,
> smp_call_function IPI sent to some other cpu's from cpu X) got serviced
> before cpu X goes offline. We can't do csd_lock_wait() here, as that
> might deadlock (as all the other cpu's are already in stop machine with
> interrupts disabled).
> 

It not happen because the preemption is disabled while send IPI request and
can't schedule to stop machine path, it also stop cpu down.

Thanks,
Xiao
