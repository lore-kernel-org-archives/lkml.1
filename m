Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYG3VAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYG3VAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYG3U77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:59:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:27013 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYG3U76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gkfut3Ohpb2pUf1BT8sl4yrQkNse11F07M8yCkynLqg5caYtn0Si/QPwJ8m+snI3Cd
         4vHTFrA8aPfEKiRprKW1/UX4ZRL7j707XkbftByiRcZTdDb0Y4xMeMgEHuQNYcZ6O4i8
         X91Zk8QHYRBESGy0tjmk7jOdhN/IYt15Y3B7k=
Message-ID: <b647ffbd0807301359w7684106cya002c5ad2940800d@mail.gmail.com>
Date: Wed, 30 Jul 2008 22:59:57 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Cc: "Peter Oruba" <peter.oruba@amd.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48909CC5.5090305@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729154103.007575982@amd.com>
	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>
	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com>
	 <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com>
	 <48909CC5.5090305@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/30 Max Krasnyansky <maxk@qualcomm.com>:
>
> Dmitry Adamushko wrote:
>> 2008/7/30 Peter Oruba <peter.oruba@amd.com>:
>>>> [ ... ]
>>> Since ucode updates may fix severe issues, it is supposed to happen as early
>>> as possible. If you re-plug your CPU into your socket, your BIOS also
>>> applies a ucode patch, but that won't necessarily be the latest and critical
>>> one.
> Sure. The question is would not workqueue be soon enough ?
> I'd say it is given the non-deterministic CPU hotplug callback sequence.

Max, cpu-hotplug callbacks might have been not the best choice in the
first place. So a comparison with them is not that relevant :-)

>
>> Hum, let's say we don't do it from cpu-hotplug handlers [1] but from
>> start_secondary() before calling cpu_idle()? [*]
>>
>> This way, we do it before any other task may have a chance to run on a
>> cpu which is not a case with cpu-hotplug handlers
>> (and we don't mess-up with cpu-hotplug events :-)
>>
>> [ the drawback is that 'microcode' subsystem is not local to
>> microcode.c anymore ]
>>
>> [1] if we need a sync. operation in cpu-hotplug handlers and IPI is
>> not ok (say, we need to run in a sleepablel context) then perhaps it's
>> workqueues + wait_on_cpu_work(). But then it's not a bit later than
>> could have been with [*].
> Why would not IPI be ok ? From looking at the code all we have to do is to
> factor request_firmware() out of the update path. So we'd do
> collect_cpu_info() in the IPI, then do request_firwmare() inplace and then do
> apply_microcode() in the IPI. ie The only thing that sleeps is request_firmware().

I think it's quite a complecated scheme. I still wonder whether e.g.
start_secondary() - cpu_idle() would be a better place or we just move
set_cpu(cpu, cpu_active_map) a bit :^)

But you know, at least short-term, it'd be nice if whoever might come
up with any working solution. It's already -rc1 and this thing is
still broken ;-)

btw., I've greped for "set_cpus_allowed_ptr()" and the following
scheme seems to be quite wide-spread (didn't check all of them so
maybe someone else does call it from cpu-hotplug notifications, heh)

        cpus_allowed = current->cpus_allowed;
        set_cpus_allowed_ptr(current, cpus);
        // do_something
        set_cpus_allowed_ptr(current, &cpus_allowed);

but _not_ safely used indeed. argh


>
> Max
>

-- 
Best regards,
Dmitry Adamushko
