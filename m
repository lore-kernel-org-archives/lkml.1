Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYHACSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYHACSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 22:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYHACSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 22:18:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34934 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYHACSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 22:18:23 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5351"; a="5229341"
Message-ID: <48927260.2060302@qualcomm.com>
Date: Thu, 31 Jul 2008 19:18:08 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Peter Oruba <peter.oruba@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
References: <20080729154103.007575982@amd.com>	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com>	 <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com>	 <48909CC5.5090305@qualcomm.com> <b647ffbd0807301359w7684106cya002c5ad2940800d@mail.gmail.com>
In-Reply-To: <b647ffbd0807301359w7684106cya002c5ad2940800d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> 2008/7/30 Max Krasnyansky <maxk@qualcomm.com>:
>> Dmitry Adamushko wrote:
>>> 2008/7/30 Peter Oruba <peter.oruba@amd.com>:
>>>>> [ ... ]
>>>> Since ucode updates may fix severe issues, it is supposed to happen as early
>>>> as possible. If you re-plug your CPU into your socket, your BIOS also
>>>> applies a ucode patch, but that won't necessarily be the latest and critical
>>>> one.
>> Sure. The question is would not workqueue be soon enough ?
>> I'd say it is given the non-deterministic CPU hotplug callback sequence.
> 
> Max, cpu-hotplug callbacks might have been not the best choice in the
> first place. So a comparison with them is not that relevant :-)

The reason I thought it's relevant is "hey it has worked before" :)
I mean it looks like people were happy with updating microcode from 
hotplug. Also the original interface was driven entirely by the 
userspace which tells me that timing of the microcode update was not 
considered critical.

>>> Hum, let's say we don't do it from cpu-hotplug handlers [1] but from
>>> start_secondary() before calling cpu_idle()? [*]
>>>
>>> This way, we do it before any other task may have a chance to run on a
>>> cpu which is not a case with cpu-hotplug handlers
>>> (and we don't mess-up with cpu-hotplug events :-)
>>>
>>> [ the drawback is that 'microcode' subsystem is not local to
>>> microcode.c anymore ]
>>>
>>> [1] if we need a sync. operation in cpu-hotplug handlers and IPI is
>>> not ok (say, we need to run in a sleepablel context) then perhaps it's
>>> workqueues + wait_on_cpu_work(). But then it's not a bit later than
>>> could have been with [*].
>> Why would not IPI be ok ? From looking at the code all we have to do is to
>> factor request_firmware() out of the update path. So we'd do
>> collect_cpu_info() in the IPI, then do request_firwmare() inplace and then do
>> apply_microcode() in the IPI. ie The only thing that sleeps is request_firmware().
> 
> I think it's quite a complecated scheme. I still wonder whether e.g.
> start_secondary() - cpu_idle() would be a better place or we just move
> set_cpu(cpu, cpu_active_map) a bit :^)
Sure. I'm ok with start_secondary() or whatever I was just saying that 
IPI would work and yes maybe it's a bit more complicated.
btw I still think workqueue would work just fine.

> But you know, at least short-term, it'd be nice if whoever might come
> up with any working solution. It's already -rc1 and this thing is
> still broken ;-)
Agree. I was going to implement/test workqueue based solution but did/do 
not have spare cycles (24x7 in the lab these days).

> btw., I've greped for "set_cpus_allowed_ptr()" and the following
> scheme seems to be quite wide-spread (didn't check all of them so
> maybe someone else does call it from cpu-hotplug notifications, heh)
> 
>         cpus_allowed = current->cpus_allowed;
>         set_cpus_allowed_ptr(current, cpus);
>         // do_something
>         set_cpus_allowed_ptr(current, &cpus_allowed);
> 
> but _not_ safely used indeed. argh
Uh, that's not good. We need to fix all that. I can think of a bunch of 
interesting races. Like adding a process to a cpuset while it was doing 
that "something" above.

Max


Max


Max
