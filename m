Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZHMOyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZHMOyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbZHMOyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:54:09 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:47465 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZHMOyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dY38lmlIvyjNRMtO5VDCoWQcAPu4fHIHKnJbH+UiOORvUezXFEv3GyGRhvZORXDdvj
         nBsDamrbaXfikIwIOVJWEjsH4gSOghQBrJWnrX6I4b6qF+MpF0MfUB812zvpelGyn8gb
         dTotklLIZ/ElK5AzWSSqXOxXHoE+OnKkpT+q4=
MIME-Version: 1.0
In-Reply-To: <73c1f2160908130721y3c14c4e7h1ff967bac867d7e6@mail.gmail.com>
References: <20090813122337.GB7029@aftab>
	 <1250166687-17673-2-git-send-email-borislav.petkov@amd.com>
	 <73c1f2160908130721y3c14c4e7h1ff967bac867d7e6@mail.gmail.com>
Date: Thu, 13 Aug 2009 11:54:05 -0300
Message-ID: <d1af83620908130754i7db4bd33p26cd54d0c30d68a5@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Clear incorrectly forced X86_FEATURE_LAHF_LM 
	flag
From: Kevin Winchester <kjwinchester@gmail.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>, mikpe@it.uu.se, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/13 Brian Gerst <brgerst@gmail.com>:
> On Thu, Aug 13, 2009 at 8:31 AM, Borislav Petkov<borislav.petkov@amd.com> wrote:
>> From: Kevin Winchester <kjwinchester@gmail.com>
>>
>> Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
>> need to force enable the LAHF_LM capability.  Unfortunately, in at
>> least one case, the BIOS does this even for processors that do not
>> support the functionality.
>>
>> Add a specific check that will clear the feature bit for processors
>> known not to support the LAHF/SAHF instructions.
>>
>> Borislav: turn off cpuid bit.
>>
>> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
>> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>> ---
>>  arch/x86/kernel/cpu/amd.c |   16 ++++++++++++++++
>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index e2485b0..9cd6fc7 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -400,6 +400,22 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>>                level = cpuid_eax(1);
>>                if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>>                        set_cpu_cap(c, X86_FEATURE_REP_GOOD);
>> +
>> +               /*
>> +                * Some BIOSes incorrectly force this feature, but only K8
>> +                * revision D (model = 0x14) and later actually support it.
>> +                */
>> +               if (c->x86_model < 0x14) {
>
> Shouldn't you test that the flag is actually set before trying to clear it?
>

Possibly.  If there were some concern that:

- The extra instructions would cause a performance impact, and the
test was significantly faster than the clear.
- The extra instructions might actually cause more problems if the
flag is not set.

Then we would certainly want to test it first.  In my opinion, a few
simple instructions to clear the flag and the CPUID bit will not
affect performance, and clearing a flag that is already cleared should
not cause any additional problems, so I would not bother testing the
flag first.  That results in fewer lines of code to change.

-- 
Kevin Winchester
