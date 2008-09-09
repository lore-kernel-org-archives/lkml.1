Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYIIHwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYIIHwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYIIHw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:52:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:2950 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYIIHw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N32cZfWzcKVSMBsQUv1kuTi/JZyYP1dElfeUjFv8nZSn+GxWQuL3zKdiV0LnNYpxlK
         oMP6Uu1BpeHJtMUUQZvwBXwaB+Ch+Mntat5MSVehgnAbS8EtOr5yp/cS2C9KUqlmVt+q
         DJGsvkNpPTyid0cnWcqNr7o6syTbjKXkbBR60=
Message-ID: <86802c440809090052t2e626ce8h4fda865b8cbce00b@mail.gmail.com>
Date: Tue, 9 Sep 2008 00:52:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Sheng Yang" <sheng.yang@intel.com>
Subject: Re: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW features
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Avi Kivity" <avi@qumranet.com>, "Andi Kleen" <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1220943294312-git-send-email-sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12209432941440-git-send-email-sheng.yang@intel.com>
	 <1220943294312-git-send-email-sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 11:54 PM, Sheng Yang <sheng.yang@intel.com> wrote:
> The hardware virtualization technology evolves very fast. But currently
> it's hard to tell if your CPU support a certain kind of HW technology
> without digging into the source code.
>
> The patch add a new catagory in "flags" under /proc/cpuinfo. Now "flags"
> can indicate the (important) HW virtulization features the CPU supported
> as well.
>
> Current implementation just cover Intel VMX side.
>
> Signed-off-by: Sheng Yang <sheng.yang@intel.com>
> ---
>  arch/x86/kernel/cpu/common.c |   45 ++++++++++++++++++++++++++++++++++++++++++
>  include/asm-x86/cpufeature.h |    9 +++++++-
>  2 files changed, 53 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index f7c1964..01432e2 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -581,6 +581,50 @@ static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
>        }
>  }
>
> +static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
> +{
> +       /* Intel VMX MSR indicated features */
> +#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW   0x00200000
> +#define X86_VMX_FEATURE_PROC_CTLS_VNMI         0x00400000
> +#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS     0x80000000
> +#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC   0x00000001
> +#define X86_VMX_FEATURE_PROC_CTLS2_EPT         0x00000002
> +#define X86_VMX_FEATURE_PROC_CTLS2_VPID                0x00000020
> +
> +       u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
> +
> +       clear_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
> +       clear_cpu_cap(c, X86_FEATURE_VNMI);
> +       clear_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
> +       clear_cpu_cap(c, X86_FEATURE_EPT);
> +       clear_cpu_cap(c, X86_FEATURE_VPID);
> +
> +       rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
> +       msr_ctl = vmx_msr_high | vmx_msr_low;
> +       if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW)
> +               set_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
> +       if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_VNMI)
> +               set_cpu_cap(c, X86_FEATURE_VNMI);
> +       if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS) {
> +               rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
> +                     vmx_msr_low, vmx_msr_high);
> +               msr_ctl2 = vmx_msr_high | vmx_msr_low;
> +               if ((msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC) &&
> +                   (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW))
> +                       set_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
> +               if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_EPT)
> +                       set_cpu_cap(c, X86_FEATURE_EPT);
> +               if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VPID)
> +                       set_cpu_cap(c, X86_FEATURE_VPID);
> +       }
> +}
> +
> +static void __cpuinit detect_virtcap(struct cpuinfo_x86 *c)
> +{
> +       if (cpu_has(c, X86_FEATURE_VMX))
> +               detect_vmx_virtcap(c);
> +}
> +
>  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>  {
>        if (!have_cpuid_p())
> @@ -613,6 +657,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>
>        init_scattered_cpuid_features(c);
>        detect_nopl(c);
> +       detect_virtcap(c);

it should go into intel_64.c and intel.c

YH
