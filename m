Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbYH2HVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbYH2HVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYH2HVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:21:30 -0400
Received: from gw.goop.org ([64.81.55.164]:37927 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYH2HV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:21:29 -0400
Message-ID: <48B7A377.8010205@goop.org>
Date: Fri, 29 Aug 2008 00:21:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory	corruption
References: <48B701FB.2020905@goop.org> <b170af450808282320g27dfa2a9mc0e14e27e215ce96@mail.gmail.com> <20080829064540.GA26619@elte.hu>
In-Reply-To: <20080829064540.GA26619@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rafał Miłecki <zajec5@gmail.com> wrote:
>
>   
>> 2008/8/28 Jeremy Fitzhardinge <jeremy@goop.org>:
>>     
>>> Some BIOSes have been observed to corrupt memory in the low 64k.  This
>>> patch does two things:
>>>  - Reserves all memory which does not have to be in that area, to
>>>   prevent it from being used as general memory by the kernel.  Things
>>>   like the SMP trampoline are still in the memory, however.
>>>  - Clears the reserved memory so we can observe changes to it.
>>>  - Adds a function check_for_bios_corruption() which checks and reports on
>>>   memory becoming unexpectedly non-zero.  Currently it's called in the
>>>   x86 fault handler, and the powermanagement debug output.
>>>
>>> RFC: What other places should we check for corruption in?
>>>
>>> [ Alan, Rafał: could you check you see:
>>>   1: corruption messages
>>>   2: no crashes
>>>  Thanks -J
>>> ]
>>>       
>> I was trying my best to crash system with this patch applied and failed :)
>>
>> Works great.
>>
>> Just wonder if I should expect any printk from
>> check_for_bios_corruption? I do not see any:
>>
>> zajec@sony:~> dmesg | grep -i corr
>> scanning 2 areas for BIOS corruption
>>     
>
> that's _very_ weird.
>   

No, it's expected.  Rafał only got corruption when plugging his HDMI
cable, and I didn't put any corruption checks on that path (I'm not even
sure what kernel code would get executed in that case).  Hugh's original
patch put a check in the hot path of the fault handler - and so it would
get called regularly - but I put it in the kernel-bug path, which is
fairly pointless given that we expect this patch to prevent the crashes.

It does, however, do the check in the pm state changes, so doing a
suspend should make it print some of the corruption it found.  Alan's
case would be a better test for that though.

It does raise the question of where the good places to put the check
are.  It shouldn't be too hot, given that it's scanning ~64k of memory,
but often enough to actually show something.  I was thinking of putting
some calls in the acpi code itself, but got, erm, discouraged.

Maybe hooking into a sysrq key would be useful (sysrq-m?).

> maybe the BIOS expects _zeroes_ somewhere? Do you suddenly see crashes 
> if you change this line in Jeremy's patch:
>
> +               memset(__va(addr), 0, size);
>
> to something like:
>
> +               memset(__va(addr), 0x55, size);
>
> If this does not tickle any messages either, then maybe the problem is 
> in the identity of the entities we allocate in the first 64K. Is there a 
> list of allocations that go there when Jeremy's patch is not applied?
>
> but ... i think with an earlier patch you saw corruption, right? 
> Far-fetched idea: maybe it's some CPU erratum during suspend/resume that 
> corrupts pagetables if the pagetables are allocated in the first 64K of 
> RAM? In that case we should use a bootmem allocation for pagetables that 
> give a minimum address of 64K.
>   

Rafał's corruption was definitely non-zero.  I think the corruption is
happening, but it's just not reported.

    J
