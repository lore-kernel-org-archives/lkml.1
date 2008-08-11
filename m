Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYHKWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYHKWOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYHKWOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:14:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45801 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYHKWOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:14:04 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5358"; a="5591877"
Message-ID: <48A0B9AC.6020901@qualcomm.com>
Date: Mon, 11 Aug 2008 15:14:04 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com> <200808082303.41068.rjw@sisk.pl> <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com> <20080811123020.GB10082@elte.hu> <alpine.LFD.1.10.0808111500330.3462@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808111500330.3462@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Linus Torvalds wrote:
> 
> On Mon, 11 Aug 2008, Ingo Molnar wrote:
>> i've queued up the fix below in tip/sched/urgent.
>>
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index e202a68..c977c33 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -349,6 +349,8 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
>>  		goto out_notify;
>>  	BUG_ON(!cpu_online(cpu));
>>  
>> +	cpu_set(cpu, cpu_active_map);
>> +
>>  	/* Now call notifier in preparation. */
>>  	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
>>  
>> @@ -383,9 +385,6 @@ int __cpuinit cpu_up(unsigned int cpu)
>>  
>>  	err = _cpu_up(cpu, 0);
>>  
>> -	if (cpu_online(cpu))
>> -		cpu_set(cpu, cpu_active_map);
>> -
> 
> Ok, not only does that fix the bug, but it simplifies the code and looks 
> obviously ok. However, I don't have it in my tree yet, and I'd like to do 
> an -rc3 that has this fixes (so that along with the PCI MSI thing, we 
> hopefully have most of the suspend/resume regressions fixed).
I actually thought it's somewhat against the original idea. It seems that we'd
be setting 'active' be a little too early. ie before all the hotplug handlers
had a chance to realize that cpu is now online.
I don't have a strong objection though.

> And I was hoping to do -rc3 today. Can I please have pull-requests for the 
> appropriate urgent scheduler/x86 fixes? Or should I just take these as 
> patches?
It'd be nice if -rc3 included my cpuset patch so that we could put circular
locking issues in the cpu hotplug path to the rest.
Ingo, I'm talking about this:
	[PATCH] cpuset: Rework sched domains and CPU hotplug handling (take 4)

Max


Max

