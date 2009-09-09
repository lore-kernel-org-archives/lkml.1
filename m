Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZIIQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZIIQQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZIIQQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:16:53 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:21369
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753581AbZIIQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:16:52 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN4015L655Na594izz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KPPP7W-01-46K-02
X-M-MSG: 
Date: Wed, 9 Sep 2009 18:16:43 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Print amd virtualization features in /proc/cpuinfo
Message-ID: <20090909161643.GB15711@amd.com>
References: <1249996732-13794-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1249996732-13794-1-git-send-email-joerg.roedel@amd.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Sep 2009 16:16:44.0110 (UTC) FILETIME=[EC1C06E0:01CA3168]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

do you have any objections against this patch? Please let me know so I
can fix them.

Thanks,

	Joerg

On Tue, Aug 11, 2009 at 03:18:52PM +0200, Joerg Roedel wrote:
> This patch adds code to cpu initialization path to detect the extended
> virtualization features of AMD cpus and shows them in /proc/cpuinfo.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/include/asm/cpufeature.h |    5 +++++
>  arch/x86/kernel/cpu/amd.c         |   25 +++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 4a28d22..d3218e3 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -165,6 +165,11 @@
>  #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
>  #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
>  #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
> +#define X86_FEATURE_NPT		(8*32+5)  /* AMD Nested Page Table support */
> +#define X86_FEATURE_LBRV	(8*32+6)  /* LBR Virtualization support */
> +#define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" SVM locking MSR */
> +#define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" svm next_rip save */
> +
>  
>  #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
>  
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index ec6c7a8..ac567d4 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -367,6 +367,28 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
>  #endif
>  }
>  
> +static void __cpuinit detect_amd_virt_flags(struct cpuinfo_x86 *c)
> +{
> +
> +#define SVM_FEATURE_NPT_MASK   0x00000001
> +#define SVM_FEATURE_LBRV_MASK  0x00000002
> +#define SVM_FEATURE_SVML_MASK  0x00000004
> +#define SVM_FEATURE_NRIPS_MASK 0x00000008
> +
> +	u32 virt_flags;
> +
> +	virt_flags = cpuid_edx(0x8000000A);
> +
> +	if (virt_flags & SVM_FEATURE_NPT_MASK)
> +		set_cpu_cap(c,  X86_FEATURE_NPT);
> +	if (virt_flags & SVM_FEATURE_LBRV_MASK)
> +		set_cpu_cap(c,  X86_FEATURE_LBRV);
> +	if (virt_flags & SVM_FEATURE_SVML_MASK)
> +		set_cpu_cap(c,  X86_FEATURE_SVML);
> +	if (virt_flags & SVM_FEATURE_NRIPS_MASK)
> +		set_cpu_cap(c,  X86_FEATURE_NRIPS);
> +}
> +
>  static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  {
>  #ifdef CONFIG_SMP
> @@ -499,6 +521,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  		}
>  	}
>  #endif
> +
> +	if (cpu_has(c, X86_FEATURE_SVM))
> +		detect_amd_virt_flags(c);
>  }
>  
>  #ifdef CONFIG_X86_32
> -- 
> 1.6.3.3
> 

-- 

