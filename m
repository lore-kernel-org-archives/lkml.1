Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYFTUEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYFTUEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbYFTUE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:04:27 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36873 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755077AbYFTUE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:04:26 -0400
Message-ID: <485C0D48.3090008@sgi.com>
Date: Fri, 20 Jun 2008 13:04:24 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org>	<4859511E.5050605@sgi.com> <48596315.6020104@goop.org>	<48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com>	<485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com>	<485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com>	<485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>	<485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org>	<Pine.LNX.4.64.0806201148430.16227@schroedinger.engr.sgi.com>	<485BFF57.5090906@goop.org> <m1hcbnq4dw.fsf@frodo.ebiederm.org>
In-Reply-To: <m1hcbnq4dw.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
> 
>> Christoph Lameter wrote:
>>> On Fri, 20 Jun 2008, Jeremy Fitzhardinge wrote:
>>>
>>>
>>>>> The loader setup for the percpu section changes with zero basing. Maybe that
>>>>> has bad side effects
>>>>>
>>>> How does it work?  The symbols in the percpu segment are 0-based, but where
>>>> does the data for the sections which correspond to that segment go?
>>>>
>>> Its loaded at __per_cpu_load but the symbols have addresses starting at 0.
>>>
>> Yes, which leads to an odd-looking ELF file where the Phdrs aren't sorted by
>> virtual address order.  I'm wondering what would happen if a bootloader that
>> actually understood ELF files tried to load it as an actual ELF
>> file...
> 
> Well /sbin/kexec looks at the physical addresses not the virtual ones
> so that may not be a problem.
> 
>>>> So the question is what kernel virtual address is it being loaded to?
>>>> __per_cpu_load is ffffffff808d1000, so ffffffff808d6000 is what you'd
>>>> expect...
>>>>
>>> Correct.
>>>
>> Well, reading back from that address got zeros, so something is
>> amiss.
> 
> Weird.
> 
>>>> Hm, but what happens when this gets converted to bzImage?  Hm, looks OK, I
>>>> think.
>>>>
>>>> BTW, I think __per_cpu_load will cause trouble if you make a relocatable
>>>> kernel, being an absolute symbol.  But I have relocation off at the moment.
>>>>
>>> Hmmm.... we could add the relocation offset to __per_cpu_load? __per_cpu_load
>>> is used very sparingly. Basically only useful during early boot and when a new
>>> per cpu area has to be setup. In that case we want to copy from __per_cpu_load
>>> to the newly allocated percpu area.
>>>
>> Yes, it should be fairly easy to manually relocate it by applying the (load -
>> link) offset to it.
> 
> For x86_64 all kernels are built relocatable as the only cost was
> changing the physical addresses in the initial page tables.  The
> virtual address always remain the same but the physical addresses
> change. So that could be part of what is going on.
> 
> Is this a change that only got tested on x86_32?

I'm only testing this on x86_64.  The zero-based percpu/pda changes worked fine
up until just recently.  At first it was one of Ingo's "randconfig" config files
that was tripping it up, but lately it's not working on any config.

> 
> As long as we are not changing the way the kernel virtual address
> are actually being used we should be ok with a change to make the pda
> 0 based.  Still it is an area you need to be especially careful with.

The major gotcha's seem to be in referencing the per_cpu symbol directly though
I've examined them all and nothing seems amiss.

> 
> 
> Eric

Thanks,
Mike
