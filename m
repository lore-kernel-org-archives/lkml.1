Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZKKQHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZKKQHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZKKQHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:07:19 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35857 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbZKKQHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:07:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H1QM1XCT/IZIVXV2Jkx51SKIhgPATaXv50FKzipL1ZWimQPwjoAQYUz6DwLsGnJxId
         L716PBIL/x2UAJPSST7UwfjZ8WlM8CsfVSip0N2uXON+5jRmIVFU9orzlyHS0zzzKT7l
         b6dMtHiTZqdYbvfVxhXKMESQyetlf1yOFFyoE=
MIME-Version: 1.0
In-Reply-To: <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
References: <1257192496.5941.8.camel@dimm>
	 <20091105153742.GA18592@alberich.amd.com>
	 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
	 <20091106123403.GB18592@alberich.amd.com>
	 <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
	 <20091106194626.GC18592@alberich.amd.com>
	 <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
Date: Wed, 11 Nov 2009 17:07:22 +0100
Message-ID: <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode output 
	messages
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/7 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> 2009/11/6 Andreas Herrmann <herrmann.der.user@googlemail.com>:
>> On Fri, Nov 06, 2009 at 01:56:31PM +0100, Dmitry Adamushko wrote:
>>> 2009/11/6 Andreas Herrmann <herrmann.der.user@googlemail.com>:
>>
>>   <snip>
>>
>>> >> (CPU3 belongs to both sets) unless summarize_cpu_info() is utterly
>>> >> broken.
>>> >
>>> > I didn't check that yet.
>>>
>>> Yeah, this behavior is likely due to a missing cpumask_clear() in
>>> summarize_cpu_info().
>>
>> Yeah, that fixes the wrong messages.
>> The other problem of not-updated CPU microcode after suspend/resume persists.
>>
>>> should be as follows:
>>>
>>>       if (!alloc_cpumask_var(&cpulist, GFP_KERNEL))
>>>               return;
>>>
>>> +    cpumask_clear(cpulist);
>>
>> Better use zalloc_cpumask instead of alloc/clear.
>
> ok.
>
>>
>>> >> sure, my test is somewhat limited... anyway, first of all I'd like to
>>> >> get a clear understanding of your logs. Thanks for yout test btw. :-))
>>> >
>>> > I'll send you full logs asap.
>>>
>>> Thanks. Maybe it's something about a particular sequence of actions
>>> that triggers this behavior. Or was it reproducible with the very
>>> first pm-suspend invocation after "modprobe microcode.ko"?
>>
>> The sequence is:
>>
>> 1. loading microcode.ko
>> 2. setting cpu2 offline
>> 3. setting cpu2 online
>> 4. suspend (pm-suspend)
>> 5. resume
>>
>> microcode of CPU2 is not updated:
>>
>>  # for i in `seq 0 3`; do lsmsr -c $i PATCH_LEVEL; done
>>  PATCH_LEVEL          = 0x0000000001000083
>>  PATCH_LEVEL          = 0x0000000001000083
>>  PATCH_LEVEL          = 0x0000000001000065
>>  PATCH_LEVEL          = 0x0000000001000083
>>
>> dmesg attached.
>
> It looks like the microcode of CPU2 was not updated at step (3) [ and
> not cached in uci->mc so that there was nothing to be loaded at resume
> time later on ].
>
> ...
> platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
> microcode: size 1936, total_size 960
> microcode: CPU2: patch mismatch (processor_rev_id: 1020, equiv_cpu_id: 1022)
> microcode: size 968, total_size 960
> PM: Syncing filesystems ... done.
> ...
>
> These messages are from ->request_microcode_fw() but then there is
> nothing from ->apply_microcode(). I'd expect to see "microcode: CPU%d:
> updated (new patch_level=0x%x)".
>
> So either request_fw() -> generic_load_microcode() somehow fails to
> find/cache a ucode (while it could do this at microcode-load time) or
> apply_microcode_on_target() -> smp_call_function_single() fails in
> this context. I made a test (some changes to load a cached ->mc at
> cpu-online time) to verify the latter hypothesis and it didn't reveal
> any problems or it requires some special conditions (also my kernel is
> -rc5+).

Andreas,


any progress with this issue? You mentioned that the problem is also
reproducible without my patches, right?


--Dmitry
