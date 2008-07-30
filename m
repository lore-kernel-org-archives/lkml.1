Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbYG3Sim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbYG3Sim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbYG3Sic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:38:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:61161 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908AbYG3Sia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GPjA9Nf0aGkOjYnZXdBCYmnz0hIgLlJ6sut9SFRQd6DwIIA8w/NctDRvg0GMN2gu+c
         c06FWSo3b7hwevlLv/WRkz+BgSOANBGOFr/E6N8fqZDi6KVCszTN699tUXxeGZKSW526
         V4nwtUxq4S0OLJQ7kmxvm2+Ko24lJknYscvG8=
Message-ID: <b647ffbd0807301138i5f721a39p9b20e4e918aa07b7@mail.gmail.com>
Date: Wed, 30 Jul 2008 20:38:28 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Cc: "Peter Oruba" <peter.oruba@amd.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48909854.2040201@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729154103.007575982@amd.com>
	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>
	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com>
	 <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com>
	 <b647ffbd0807300334q57cdca6fu474cc7b6bed36102@mail.gmail.com>
	 <48909854.2040201@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/30 Max Krasnyansky <maxk@qualcomm.com>:
>
>
> Dmitry Adamushko wrote:
>> 2008/7/30 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>>> 2008/7/30 Peter Oruba <peter.oruba@amd.com>:
>>>>> [ ... ]
>>>> Since ucode updates may fix severe issues, it is supposed to happen as early
>>>> as possible. If you re-plug your CPU into your socket, your BIOS also
>>>> applies a ucode patch, but that won't necessarily be the latest and critical
>>>> one.
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
>>>
>>> heh, this issue has already popped up in another thread so it should
>>> be fixed asap, imho.
>>>
>>> Ingo, Peter? What would be the best way from your pov?
>>
>> or let's just use smth like a patch below so far:
>>
>> (non-white-space-damaged version is enclosed)
>>
>> --- kernel/cpu.c-old    2008-07-30 12:31:15.000000000 +0200
>> +++ kernel/cpu.c        2008-07-30 12:32:02.000000000 +0200
>> @@ -349,6 +349,8 @@ static int __cpuinit _cpu_up(unsigned in
>>                 goto out_notify;
>>         BUG_ON(!cpu_online(cpu));
>>
>> +       cpu_set(cpu, cpu_active_map);
>> +
>>         /* Now call notifier in preparation. */
>>         raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
>>
>> @@ -383,9 +385,6 @@ int __cpuinit cpu_up(unsigned int cpu)
>>
>>         err = _cpu_up(cpu, 0);
>>
>> -       if (cpu_online(cpu))
>> -               cpu_set(cpu, cpu_active_map);
>> -
>>  out:
>>         cpu_maps_update_done();
>>         return err;
>
> That was the first thing I thought of when you pointed out what the problem is
> (ie when original bug report showed up).
> But I immediately rejected the idea because it changes the rules of the game.
>  active bit is set even before the cpu is "truly" online.

hm, it depends on what is "truly" in this context :-) Tasks (kernel
threads) may start running on this 'cpu' as a result of some
CPU_ONLINE notifications (CPU_ONLINE notification kind of says "hey,
this 'cpu' is online :-)

Sure, If we imagine that some CPU_ONLINE callbacks do additional
initialization (e.g. load-balancer related) for 'cpu' and only after
their completion the 'cpu' is "really" online (e.g. tasks can be
migrated onto it).

I don't have a strong feeling here. I think it's just a matter of
specifying the rules/interface.

>
> I'd say we fix the microcode instead.
>

Yeah, not that this use of set_cpus_allowed_ptr() in hotplug callbacks
looks pretty to me (not that I'm saying I have a good taste though :-)

I've even suggested to consider doing microcode update somewhere
earlier in start_secondary() (say, right before cpu_idle()). So it'd
be done as ealry as possible + we don't mess up with cpu-hotplug
events.


>
> Max
>

-- 
Best regards,
Dmitry Adamushko
