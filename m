Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYEGOIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYEGOIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYEGOIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:08:10 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:51446 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYEGOIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:08:07 -0400
Message-ID: <4821B801.5030508@keyaccess.nl>
Date: Wed, 07 May 2008 16:09:05 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl>	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>	<4821A7E2.6080101@keyaccess.nl> <20080507064259.36deb978@infradead.org>
In-Reply-To: <20080507064259.36deb978@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-05-08 15:42, Arjan van de Ven wrote:
> On Wed, 07 May 2008 15:00:18 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 07-05-08 04:39, Yinghai Lu wrote:
>>
>>> On Tue, May 6, 2008 at 6:48 PM, Rene Herman
>>> <rene.herman@keyaccess.nl> wrote:
>>>>  On 2.6.25 and below, my /proc/cpuinfo looks like:
>>>>
>>>>  processor       : 0
>>>>  vendor_id       : AuthenticAMD
>>>>  cpu family      : 6
>>>>  model           : 7
>>>>  model name      : AMD Duron(tm) Processor
>> [ ... ]
>>
>>>>  flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge
>>>> mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow ts
>>>>  while on current mainline PAT and TS (Temperature Sensor) drop
>>>> from the feature flags:
>>>>
>>>>  flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge
>>>> mca cmov pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
>>>>
>>>>  With respect to PAT, I guess it's
>>>> 9307cacad0dfe3749f00303125c6f7f0523e5616, "x86: pat cpu feature
>>>> bit setting for known cpus" but what's this about?
>>>>
>>>> Did my cpuinfo lie upto this point or shouldn't the flag be
>>>> cleared? The commit message for that change is completely and
>>>> totally unhelpful.
>>> others like to to whitebox methods, ..., please try attach patch to
>>> see if duron support PAT.
>>> diff --git a/arch/x86/kernel/cpu/common.c
>>> b/arch/x86/kernel/cpu/common.c index a428ffc..81483ec 100644
>>> --- a/arch/x86/kernel/cpu/common.c
>>> +++ b/arch/x86/kernel/cpu/common.c
>>> @@ -314,6 +314,8 @@ static void __cpuinit early_get_cap(struct
>>> cpuinfo_x86 *c) case X86_VENDOR_AMD:
>>>  		if (c->x86 >= 0xf && c->x86 <= 0x11)
>>>  			set_cpu_cap(c, X86_FEATURE_PAT);
>>> +		if (c->x86 == 6 && c->x86_modes == 7)
>>> +			set_cpu_cap(c, X86_FEATURE_PAT);
>>>  		break;
>>>  	case X86_VENDOR_INTEL:
>>>  		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model
>>>> = 15))
>> s/modes/model/ but, as far as I'm aware, works fine other than that.
>> When I boot with CONFIG_X86_PAT after applying that, I see:
>>
>> 	x86 PAT enabled: cpu 0, old 0x7040600070406, new
>> 0x7010600070106
>>
>> and PAT is retained in the feature flags. However, this I do not
>> consider very surprising. Why is this code doing what it is doing in
>> the first place?
>>
>> These feature flags are read from hardware in the CPUID instruction.
>> Why is this code then going "ah, this CPU may _claim_ PAT but we
>> won't actually believe it unless it's model foo, bar or baz". Is that
>> feature flag buggy?
>>
> 
> older cpus had various issues with PAT, some blatently obvious, some
> more subtle.

And I suppose you have a list of these older CPUs or is this going to be
one of these things where in 5 years time I say to yet another person "ah
yes, I remember someone once telling me that old CPUs apparently had some
issues, some blatantly obvious, some more subtle" and the saga continues
on from there again?

> Since for old systems the mtrrs clearly work fine... the idea was to
> not take the risk (since there's no reward) and just leave them as
> is, in a working state.

With CONFIG_X86_PAT, you now see "CPU and/or kernel does not support PAT."
at the top of your dmesg which is going to make people wonder. I did a
cat /proc/cpuinfo, saw no PAT flag and was just suspicious enough that I
didn't trust it.

A blacklist would be a better idea I feel, but in ANY case I think it's
really bad form to clear the feature flag. They are provided by hardware;
if arch/x86/mm/pat.c won't risk running except on a select few tested
models, whatever, but my /proc/cpuinfo shouldn't be lying to me.

Rene.
