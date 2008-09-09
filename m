Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYIIICl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYIIICl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYIIIC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:02:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:30620 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbYIIIC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,364,1217833200"; 
   d="scan'208";a="378258316"
From: "Yang, Sheng" <sheng.yang@intel.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW features
Date: Tue, 9 Sep 2008 16:05:41 +0800
User-Agent: KMail/1.9.9
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Avi Kivity" <avi@qumranet.com>, "Andi Kleen" <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <12209432941440-git-send-email-sheng.yang@intel.com> <1220943294312-git-send-email-sheng.yang@intel.com> <86802c440809090052t2e626ce8h4fda865b8cbce00b@mail.gmail.com>
In-Reply-To: <86802c440809090052t2e626ce8h4fda865b8cbce00b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091605.42121.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 15:52:26 Yinghai Lu wrote:
> On Mon, Sep 8, 2008 at 11:54 PM, Sheng Yang <sheng.yang@intel.com> wrote:
> > The hardware virtualization technology evolves very fast. But currently
> > it's hard to tell if your CPU support a certain kind of HW technology
> > without digging into the source code.
> >
> > The patch add a new catagory in "flags" under /proc/cpuinfo. Now "flags"
> > can indicate the (important) HW virtulization features the CPU supported
> > as well.
> >
> > Current implementation just cover Intel VMX side.
> >
> > Signed-off-by: Sheng Yang <sheng.yang@intel.com>
> > ---
> >  arch/x86/kernel/cpu/common.c |   45
> > ++++++++++++++++++++++++++++++++++++++++++ include/asm-x86/cpufeature.h |
> >    9 +++++++-
> >  2 files changed, 53 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index f7c1964..01432e2 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -581,6 +581,50 @@ static void __cpuinit detect_nopl(struct cpuinfo_x86
> > *c) }
> >  }
> >
> > +static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
> > +{
> > +       /* Intel VMX MSR indicated features */
> > +#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW   0x00200000
> > +#define X86_VMX_FEATURE_PROC_CTLS_VNMI         0x00400000
> > +#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS     0x80000000
> > +#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC   0x00000001
> > +#define X86_VMX_FEATURE_PROC_CTLS2_EPT         0x00000002
> > +#define X86_VMX_FEATURE_PROC_CTLS2_VPID                0x00000020
> > +
> > +       u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
> > +
> > +       clear_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
> > +       clear_cpu_cap(c, X86_FEATURE_VNMI);
> > +       clear_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
> > +       clear_cpu_cap(c, X86_FEATURE_EPT);
> > +       clear_cpu_cap(c, X86_FEATURE_VPID);
> > +
> > +       rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
> > +       msr_ctl = vmx_msr_high | vmx_msr_low;
> > +       if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW)
> > +               set_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
> > +       if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_VNMI)
> > +               set_cpu_cap(c, X86_FEATURE_VNMI);
> > +       if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS) {
> > +               rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
> > +                     vmx_msr_low, vmx_msr_high);
> > +               msr_ctl2 = vmx_msr_high | vmx_msr_low;
> > +               if ((msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC) &&
> > +                   (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW))
> > +                       set_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
> > +               if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_EPT)
> > +                       set_cpu_cap(c, X86_FEATURE_EPT);
> > +               if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VPID)
> > +                       set_cpu_cap(c, X86_FEATURE_VPID);
> > +       }
> > +}
> > +
> > +static void __cpuinit detect_virtcap(struct cpuinfo_x86 *c)
> > +{
> > +       if (cpu_has(c, X86_FEATURE_VMX))
> > +               detect_vmx_virtcap(c);
> > +}
> > +
> >  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
> >  {
> >        if (!have_cpuid_p())
> > @@ -613,6 +657,7 @@ static void __cpuinit generic_identify(struct
> > cpuinfo_x86 *c)
> >
> >        init_scattered_cpuid_features(c);
> >        detect_nopl(c);
> > +       detect_virtcap(c);
>
> it should go into intel_64.c and intel.c
>
> YH

Yeah, I've considered that, but seems duplicate for both files? The feature 
detection code is the same. Any way to merge them? 

Thanks!
-- 
regards
Yang, Sheng
