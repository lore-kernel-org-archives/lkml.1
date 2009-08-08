Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbZHHWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbZHHWGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 18:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZHHWGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 18:06:34 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:33930 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZHHWGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 18:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sRkczgOp+64Rg6HncEe8rkA5VVVSJWP1DEQ5fqVTUsorGYkQFhVKQCml3GwtTAh8Xi
         xyTcqgzNOp/wjUbUwFS55AQtozWz2xL1aEweWNm1fXu2JJFVs+qt8UYY2GLLjbdXLZPT
         9e10547Y/8nW2QmLC2Yw3SqET4BbBO5GAjlhc=
Message-ID: <4A7DF6E6.2030509@gmail.com>
Date: Sat, 08 Aug 2009 19:06:30 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>,
       Kevin Winchester <kjwinchester@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
Subject: Re: [PATCH] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
References: <4A7D673A.1090401@gmail.com> <20090808152016.GB25374@liondog.tnic>
In-Reply-To: <20090808152016.GB25374@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Hi,
> 
> On Sat, Aug 08, 2009 at 08:53:30AM -0300, Kevin Winchester wrote:
>> Due to an erratum with certain AMD Athlon 64 processors, the BIOS may
>> need to force enable the LAHF_LM capability.  Unfortunately, in at
>> least one case, the BIOS does this even for processors that do not
>> support the functionality.
>>
>> Add a specific check that will clear the feature bit for processors
>> known not to support the LAHF/SAHF instructions.
>>
>> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
>> ---
>>
>> While making this change, I noticed the clause above my code:
>>
>>     if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>>
>> It does not seem concerned with the possibility that some of the
>> upper 16 bits of level will be non-zero.  Is this intentional, or
>> should the upper 16 bits be masked off before the comparisons?
> 
> This should be ok because the upper 16 bits are 0x0000 for those
> revisions and therefore the whole u32 matches. Later revisions have the
> extended model bumped and they also match.
> 
>>  arch/x86/kernel/cpu/amd.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index e2485b0..a2f0fe4 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -400,6 +400,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>>  		level = cpuid_eax(1);
>>  		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
>>  			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
>> +
>> +		/*
>> +		 * Some BIOSes incorrectly set this feature, but only
>> +		 * Revision E (with Extended Model = 2) actually supports
>> +		 * it.
>> +		 */
>> +		if (!(level & 0x00020000))
>> +			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
> 
> let me check this internally next week because
> it seems that according to the Fam 0xf RevGuide
> (http://support.amd.com/us/Processor_TechDocs/25759.pdf) erratum 110
> applies to atleast 3 CPU revisions with extended model 0x1 too.

You are quite right, I will redo the patch.

> 
> By the way, what does /proc/cpuinfo say on your machine?
> 

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 4
model name	: AMD Athlon(tm) 64 Processor 2800+
stepping	: 10
cpu MHz		: 1800.000
cache size	: 512 KB
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm 3dnowext 3dnow rep_good
bogomips	: 3599.75
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp


-- 
Kevin Winchester

