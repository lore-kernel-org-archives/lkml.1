Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYKJMkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYKJMkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYKJMj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:39:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbYKJMjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:39:55 -0500
Subject: Re: [PATCH 2/4] Hypervisor detection and get tsc_freq from
	hypervisor
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: akataria@vmware.com
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <1225129306.28018.9.camel@alok-dev1>
References: <1224894104.28224.72.camel@alok-dev1>
	 <20081027110134.GC13641@elte.hu>  <1225129306.28018.9.camel@alok-dev1>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 12:38:40 +0000
Message-Id: <1226320720.4068.54.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alok,

On Mon, 2008-10-27 at 10:41 -0700, Alok Kataria wrote:

> x86: Get TSC frequency from VMware hypervisor.
> 
> From: Alok N Kataria <akataria@vmware.com>
> 
> v3->v2 : Abstract the hypervisor detection and feature (tsc_freq) request
> 	 behind a hypervisor.c file
> v2->v1 : Add a x86_hyper_vendor field to the cpuinfo_x86 structure.
> 	 This avoids multiple calls to the hypervisor detection function.
> 
> This patch adds function to detect if we are running under VMware.
> The current way to check if we are on VMware is following,
> #  check if "hypervisor present bit" is set, if so read the 0x40000000
>    cpuid leaf and check for "VMwareVMware" signature.
> #  if the above fails, check the DMI vendors name for "VMware" string
>    if we find one we query the VMware hypervisor port to check if we are
>    under VMware.
> 
> The DMI + "VMware hypervisor port check" is needed for older VMware products,
> which don't implement the hypervisor signature cpuid leaf.
> Also note that since we are checking for the DMI signature the hypervisor
> port should never be accessed on native hardware.
> 
> This patch also adds a hypervisor_get_tsc_freq function, instead of
> calibrating the frequency which can be error prone in virtualized
> environment, we ask the hypervisor for it. We get the frequency from
> the hypervisor by accessing the hypervisor port if we are running on VMware.
> Other hypervisors too can add code to the generic routine to get frequency on
> their platform.
> 
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> Signed-off-by: Dan Hecht <dhecht@vmware.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
> 
>  arch/x86/include/asm/cpufeature.h |    2 +
>  arch/x86/include/asm/hypervisor.h |   26 +++++++++++
>  arch/x86/include/asm/processor.h  |    4 ++
>  arch/x86/include/asm/vmware.h     |   26 +++++++++++
>  arch/x86/kernel/cpu/Makefile      |    1 
>  arch/x86/kernel/cpu/common.c      |    2 +
>  arch/x86/kernel/cpu/hypervisor.c  |   48 ++++++++++++++++++++
>  arch/x86/kernel/cpu/vmware.c      |   88 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/setup.c           |    7 +++
>  arch/x86/kernel/tsc.c             |    9 +++-
>  10 files changed, 212 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/hypervisor.h
>  create mode 100644 arch/x86/include/asm/vmware.h
>  create mode 100644 arch/x86/kernel/cpu/hypervisor.c
>  create mode 100644 arch/x86/kernel/cpu/vmware.c
> 
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index f73e95d..78478f2 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -117,6 +117,7 @@
>  #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
>  #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
>  #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
> +#define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */

I don't see you set this anywhere.

>  /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
>  #define X86_FEATURE_XSTORE	(5*32+ 2) /* "rng" RNG present (xstore) */
> @@ -237,6 +238,7 @@ extern const char * const x86_power_flags[32];
>  #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
>  #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
>  #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
> +#define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)

...

> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> new file mode 100644
> index 0000000..d5d1b75
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -0,0 +1,88 @@

...

> +int vmware_platform(void)
> +{
> +	if (cpu_has_hypervisor) {
> +		unsigned int eax, ebx, ecx, edx;
> +		char hyper_vendor_id[13];
> +
> +		cpuid(CPUID_VMWARE_INFO_LEAF, &eax, &ebx, &ecx, &edx);
> +		memcpy(hyper_vendor_id + 0, &ebx, 4);
> +		memcpy(hyper_vendor_id + 4, &ecx, 4);
> +		memcpy(hyper_vendor_id + 8, &edx, 4);
> +		hyper_vendor_id[12] = '\0';
> +		if (!strcmp(hyper_vendor_id, "VMwareVMware"))
> +			return 1;

This seems to be the only use of cpu_has_hypervisor, but this is the
hypervisor detection code, so it's not clear how you intended
X86_FEATURE_HYPERVISOR be set before here?

Cheers,
Mark.

