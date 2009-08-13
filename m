Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZHMWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZHMWxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZHMWxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:53:17 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:59055 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZHMWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:53:16 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2009 18:53:15 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qElH02cSQTo3Wfn1ux2lzS/DaqNMBwSNW9Gd/EnklLA+6HqkFxfwigPfyOliY5XaQz
         3RfXy9EpLojMmfH8qRkFsU2Do46TUJqvFS3r4YP65kq8qdYDfYPstd2IHgfp/OiOopGT
         vUdrDdUemm3BaA3oNGVYY8jw/PoZE+gTVCrJs=
Message-ID: <4A8497A3.8090800@gmail.com>
Date: Thu, 13 Aug 2009 19:45:55 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, mikpe@it.uu.se, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
References: <20090813122337.GB7029@aftab>	 <1250166687-17673-2-git-send-email-borislav.petkov@amd.com>	 <73c1f2160908130721y3c14c4e7h1ff967bac867d7e6@mail.gmail.com>	 <d1af83620908130754i7db4bd33p26cd54d0c30d68a5@mail.gmail.com> <73c1f2160908130855h128c9908h486d583ee9fdcea5@mail.gmail.com>
In-Reply-To: <73c1f2160908130855h128c9908h486d583ee9fdcea5@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> On Thu, Aug 13, 2009 at 10:54 AM, Kevin
> Winchester<kjwinchester@gmail.com> wrote:
>> 2009/8/13 Brian Gerst <brgerst@gmail.com>:
>>> On Thu, Aug 13, 2009 at 8:31 AM, Borislav Petkov<borislav.petkov@amd.com> wrote:
>>>> From: Kevin Winchester <kjwinchester@gmail.com>
>>>>
>>>> Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
>>>> need to force enable the LAHF_LM capability.  Unfortunately, in at
>>>> least one case, the BIOS does this even for processors that do not
>>>> support the functionality.
>>>>
>>>> Add a specific check that will clear the feature bit for processors
>>>> known not to support the LAHF/SAHF instructions.
>>>>
>>>> Borislav: turn off cpuid bit.
>>>>
>>>> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
>>>> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>>>> ---
>>>>  arch/x86/kernel/cpu/amd.c |   16 ++++++++++++++++
>>>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>>>> index e2485b0..9cd6fc7 100644
>>>> --- a/arch/x86/kernel/cpu/amd.c
>>>> +++ b/arch/x86/kernel/cpu/amd.c
>>>> @@ -400,6 +400,22 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>>>>                level = cpuid_eax(1);
>>>>                if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>>>>                        set_cpu_cap(c, X86_FEATURE_REP_GOOD);
>>>> +
>>>> +               /*
>>>> +                * Some BIOSes incorrectly force this feature, but only K8
>>>> +                * revision D (model = 0x14) and later actually support it.
>>>> +                */
>>>> +               if (c->x86_model < 0x14) {
>>> Shouldn't you test that the flag is actually set before trying to clear it?
>>>
>> Possibly.  If there were some concern that:
>>
>> - The extra instructions would cause a performance impact, and the
>> test was significantly faster than the clear.
> 
> Testing a bit is cheap and MSR accesses are not.
> 
>> - The extra instructions might actually cause more problems if the
>> flag is not set.
> 
> These MSRs don't exist on older cpus and will cause a fault, which is
> handled at additional cost.
> 

I stand corrected.  I was unaware of this, so I guess testing the flag first
would be a good idea.

Thanks,

-- 
Kevin Winchester

