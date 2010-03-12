Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0CLUf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:35:59 -0500
Received: from claw.goop.org ([74.207.240.146]:42357 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab0CLUf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:35:58 -0500
Message-ID: <4B9AA5A9.20609@goop.org>
Date: Fri, 12 Mar 2010 12:35:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH][v9 4/6] xen/hvm: Xen PV extension of HVM
 initialization
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com> <1268362647-5317-5-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1268362647-5317-5-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 06:57 PM, Sheng Yang wrote:
> The PV extended HVM(once known as Hybrid) is started from real mode like
> HVM guest, but also with a component based PV feature selection(e.g. PV halt,
> PV timer, event channel, then PV drivers). So guest can takes the advantages
> of both H/W virtualization and Para-Virtualization.
>
> This patch introduced the PV extension of HVM guest initialization.
>
> Guest would detect the capability using CPUID 0x40000002.edx, then call
> HVMOP_enable_pv hypercall to enable pv support in hypervisor.
>
> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> Signed-off-by: Yaozu (Eddie) Dong<eddie.dong@intel.com>
> ---
>   arch/x86/include/asm/xen/cpuid.h      |    5 +
>   arch/x86/include/asm/xen/hypervisor.h |   12 +++
>   arch/x86/xen/Kconfig                  |    4 +
>   arch/x86/xen/Makefile                 |    1 +
>   arch/x86/xen/hvmpv.c                  |  135 +++++++++++++++++++++++++++++++++
>   include/xen/interface/hvm/hvm_op.h    |    8 ++
>   6 files changed, 165 insertions(+), 0 deletions(-)
>   create mode 100644 arch/x86/xen/hvmpv.c
>
> diff --git a/arch/x86/include/asm/xen/cpuid.h b/arch/x86/include/asm/xen/cpuid.h
> index 8787f03..b3a0b3a 100644
> --- a/arch/x86/include/asm/xen/cpuid.h
> +++ b/arch/x86/include/asm/xen/cpuid.h
> @@ -65,4 +65,9 @@
>   #define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
>   #define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
>
> +#define _XEN_CPUID_FEAT2_HVM_PV 0
> +#define XEN_CPUID_FEAT2_HVM_PV (1u<<0)
> +#define _XEN_CPUID_FEAT2_HVM_PV_CLOCK 1
> +#define XEN_CPUID_FEAT2_HVM_PV_CLOCK (1u<<1)
> +
>   #endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
> diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
> index d5b7e90..7569f64 100644
> --- a/arch/x86/include/asm/xen/hypervisor.h
> +++ b/arch/x86/include/asm/xen/hypervisor.h
> @@ -55,6 +55,18 @@ extern enum xen_domain_type xen_domain_type;
>   #define xen_hvm_domain()	(xen_domain()&&			\
>   				 xen_domain_type == XEN_HVM_DOMAIN)
>
> +#ifdef CONFIG_XEN_HVM_PV
> +
> +#define XEN_HVM_PV_CLOCK_ENABLED   (1u<<  0)
>    

Why is this flag needed?  As far as I understand it, there's no real 
underlying hypervisor change needed to make HVM access to pv clock 
possible; its just a field in the shared_info's vcpu struct after all.  
Even if you enable this feature unconditionally, the user can still 
control whether the Xen clocksource is used with the "clocksource=" 
kernel command-line parameter.

Also, there's nothing about this which is 64-bit specific is there?

Thanks,
     J
