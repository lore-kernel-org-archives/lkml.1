Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYGXRQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYGXRQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 13:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYGXRQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 13:16:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64870 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYGXRP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 13:15:59 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5345"; a="4853894"
Message-ID: <4888B8C4.20905@qualcomm.com>
Date: Thu, 24 Jul 2008 10:15:48 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>, pj@sgi.com,
       Ingo Molnar <mingo@elte.hu>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: latest -git: kernel BUG at arch/x86/kernel/microcode.c:142!
References: <19f34abd0807240348n4c31e6el7358d3fc4d10e392@mail.gmail.com>	 <19f34abd0807240702i349777e5y6f57c19c51dff60f@mail.gmail.com>	 <b647ffbd0807240752r6edc73c1m6bf63a6124504365@mail.gmail.com> <b647ffbd0807240918n78b32f63j5c54af1dca026dac@mail.gmail.com>
In-Reply-To: <b647ffbd0807240918n78b32f63j5c54af1dca026dac@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> 2008/7/24 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>> 2008/7/24 Vegard Nossum <vegard.nossum@gmail.com>:
>>>> It's this one:
>>>>
>>>>        /* We should bind the task to the CPU */
>>>>        BUG_ON(raw_smp_processor_id() != cpu_num);
>>>>
>>>> Maybe related to recently merged per-cpu changes? (Yesterday's tests ran fine.)
>>>>
>>>> It seems 100% reproducible, so I'll start bisecting it.
>>> Ahha, after many hours of hitting various unrelated crashes,
>>> miscompiles, etc. I finally arrive at this commit:
>>>
>>> commit e761b7725234276a802322549cee5255305a0930
>>> Author: Max Krasnyansky <maxk@qualcomm.com>
>>> Date:   Tue Jul 15 04:43:49 2008 -0700
>> Yeah, there seems to be a funny situation here :-) I'd expect it to be
>> 100% reproduceable with CONFIG_MICROCODE=y.
>>
>> cpu_up() -> raw_notifier_call_chain(CPU_ONLINE, ...) ->
>>
>> (microcode's part)
>>
>> mc_cpu_callback() -> mc_sysdev_add() -> microcode_init_cpu()
>>
>> and here we have:
>>
>>        set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> 
> btw., this is obviously bad behavior. This code plays with
> "cpus_allowed" (changes and then restores it) of pretty arbitrary
> tasks in context of which it happens to run. So it may race with
> sched_setaffinity() and negate its effect.

Agree. I came to the similar conclusion.
The solution is to either convert it to schedule_delayed_work_on() or if it's
important to update the microcode synchronously we can the whole thing to do
something like
	smp_call_function_single(cpu, collect_cpu_info);
	if (needs_update) {
		request_firmware(...);
		smp_call_function_single(cpu, update_cpu_microcode);
	}

Tigran, do we need sync update inside the hotplug handler or async update via
workqueue is fine ?

Max


Max







