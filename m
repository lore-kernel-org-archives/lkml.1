Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbXEJKNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbXEJKNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 06:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXEJKNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 06:13:07 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:32968 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753669AbXEJKNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 06:13:05 -0400
Message-ID: <4642F018.7020902@panasas.com>
Date: Thu, 10 May 2007 13:12:40 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>, Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Andi, you broke my laptop :-)
References: <4642E8AA.7060501@panasas.com>
In-Reply-To: <4642E8AA.7060501@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2007 10:12:42.0048 (UTC) FILETIME=[BEDD1C00:01C792EB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy, Pete, this patch also causes our test machines to hang hard during boot.
x86_64 smp kernel, single cpu Athlon 64 machine,
cpuinfo below.

Benny

$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 79
model name      : AMD Athlon(tm) 64 Processor 3800+
stepping        : 2
cpu MHz         : 2412.397
cache size      : 512 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow up pni cx16 lahf_lm svm cr8_legacy
bogomips        : 4828.89
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

Pete Zaitcev <zaitcev@redhat.com> wrote:
> 
> Hi, Andi:
> 
> The attached patch (actually, git show output) makes my Dell 1501 to hang
> on boot. Sorry, I have no clue why... The culprit is found with git bisect.
> But yes, it's an AMD MK-36. I use an x86_64 kernel. It is 100% reproducible.
> 
> Cheers,
> -- Pete
> 
> commit c5bcb5635a03da3158f121ae20ccbbf72b4fc62a
> Author: Andi Kleen <ak@suse.de>
> Date:   Wed May 2 19:27:21 2007 +0200
> 
>     [PATCH] x86: Use RDTSCP for synchronous get_cycles if possible
>     
>     RDTSCP is already synchronous and doesn't need an explicit CPUID.
>     This is a little faster and more importantly avoids VMEXITs on Hypervisors.
>     
>     Original patch from Joerg Roedel, but reworked by AK
>     Also includes miscompilation fix by Eric Biederman
>     
>     Cc: "Joerg Roedel" <joerg.roedel@amd.com>
>     
>     Signed-off-by: Andi Kleen <ak@suse.de>
> 
> diff --git a/include/asm-i386/tsc.h b/include/asm-i386/tsc.h
> index 0181f9d..3f3c1fa 100644
> --- a/include/asm-i386/tsc.h
> +++ b/include/asm-i386/tsc.h
> @@ -38,6 +38,15 @@ static __always_inline cycles_t get_cycles_sync(void)
>  	unsigned eax;
>  
>  	/*
> +  	 * Use RDTSCP if possible; it is guaranteed to be synchronous
> + 	 * and doesn't cause a VMEXIT on Hypervisors
> +	 */
> +	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
> +			 	 "=A" (ret), "0" (0ULL) : "ecx", "memory");
> +	if (ret)
> +		return ret;
> +
> +	/*
>  	 * Don't do an additional sync on CPUs where we know
>  	 * RDTSC is already synchronous:
>  	 */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

