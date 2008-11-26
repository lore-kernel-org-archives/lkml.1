Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYKZPpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYKZPpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYKZPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:45:27 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:64460 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbYKZPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:45:25 -0500
X-Greylist: delayed 65357 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2008 10:45:24 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=kFHEbVwwP51zz7TbxKwlDEFzacA+OwxZnPJ++ZclJikvb4GsM86dujYNUnlh9dHh8t
         FrawzBy/oBP/ybatkwb7TS+i61Zb6KAEO3oNIGfJlnAcUnQvN41E9cCXH9k5w4hLIYtV
         j5g1mHPBOMw6Ot3kXQVJChq4wMa9oZBr5visE=
Message-ID: <7c86c4470811260745s293ae0bbw1cf53642d4f88416@mail.gmail.com>
Date: Wed, 26 Nov 2008 16:45:21 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 21/24] perfmon: Intel architectural PMU support (x86)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811261446070.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c0e.06e2660a.1583.ffffcc0a@mx.google.com>
	 <alpine.LFD.2.00.0811261446070.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,


On Wed, Nov 26, 2008 at 3:55 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 26 Nov 2008, eranian@googlemail.com wrote:
>
>> +static u64 enable_mask[PFM_MAX_PMCS];
>
> Why do we need enable_mask twice for AMD and Intel ?
>
Ok, some explanations are needed here.

Both perfmon_intel_arch.c and perfmon_amd64.c are supposed to be kernel modules.
They are hardcoded right now to make the patch simpler. Have PMU description be
modules is a key features because it allows adding new processor support without
necessarily patch the core kernel or rebooting. This has been working
nicely on Itanium.
With the introduction of Intel architectural Perfmon (IA32 SDM chapter
18), this becomes
possible on Intel X86 as well. on AMD64 processor, this is not really
an issue as they
all use the same architected PMU, except for family 10h which has nice
extensions.

In anycase, the idea is to encapsulate as much as possible code
related into a PMU model
into each module. That is why you are seing some redundancy.

There is a difference between enable_mask and used_pmcs. The used_pmcs
bitmasks shows
all the config registers in use. Whereas enable_mask shows the all
config registers which have
start/stop capabilities. For the basic AMD64 PMU (4 counters)
used_pmcs and enable_mask
are equivalent, but that is not the case on Barcelona once we support
IBS and sampling. So
for now, I could clean this up and drop enable_mask to use plain used_pmcs.


>> +static u16 max_enable;
>> +static int pfm_intel_arch_version;
>> +
>> +DEFINE_PER_CPU(u64, saved_global_ctrl);
>
> static
>
>> +/*
>> + * layout of EAX for CPUID.0xa leaf function
>> + */
>> +struct pmu_eax {
>> +     unsigned int version:8;         /* architectural perfmon version */
>> +     unsigned int num_cnt:8;         /* number of generic counters */
>> +     unsigned int cnt_width:8;       /* width of generic counters */
>> +     unsigned int ebx_length:8;      /* number of architected events */
>> +};
>
> in arch/x86/include/asm/intel_arch_perfmon.h we have already:
>
> union cpuid10_eax {
>        struct {
>                unsigned int version_id:8;
>                unsigned int num_counters:8;
>                unsigned int bit_width:8;
>                unsigned int mask_length:8;
>        } split;
>        unsigned int full;
> };
>
> Can we either use this or remove it ?
>
>> +/*
>> + * layout of EDX for CPUID.0xa leaf function when perfmon v2 is detected
>> + */
>> +struct pmu_edx {
>> +     unsigned int num_cnt:5;         /* number of fixed counters */
>> +     unsigned int cnt_width:8;       /* width of fixed counters */
>> +     unsigned int reserved:19;
>> +};
>
>> +static void pfm_intel_arch_acquire_pmu_percpu(void);
>> +static void pfm_intel_arch_release_pmu_percpu(void);
>> +static int pfm_intel_arch_stop_save(struct pfm_context *ctx,
>> +                                 struct pfm_event_set *set);
>> +static int pfm_intel_arch_has_ovfls(struct pfm_context *ctx);
>> +static void __kprobes pfm_intel_arch_quiesce(void);
>> +
>> +/*
>> + * physical addresses of MSR controlling the perfevtsel and counter registers
>> + */
>> +struct pfm_arch_pmu_info pfm_intel_arch_pmu_info = {
>> +     .stop_save = pfm_intel_arch_stop_save,
>> +     .has_ovfls = pfm_intel_arch_has_ovfls,
>> +     .quiesce = pfm_intel_arch_quiesce,
>> +     .acquire_pmu_percpu = pfm_intel_arch_acquire_pmu_percpu,
>> +     .release_pmu_percpu = pfm_intel_arch_release_pmu_percpu
>> +};
>
> A) static
> B) Please move it to the bottom to avoid all the forward declarations.
>
>> +static void pfm_intel_arch_check_errata(void)
>
>  __init ?
>
>> +static void pfm_intel_arch_setup_generic(unsigned int version,
>
>  Ditto.
>
>> +static void pfm_intel_arch_setup_fixed(unsigned int version,
>
>  Ditto.
>
>> +static int pfm_intel_arch_probe_pmu(void)
>
>  Ditto.
>
>> +     /*
>> +      * handle version new anythread bit (bit 2)
>> +      */
>
>  -ENOPARSE
>
>> +     if (version == 3)
>> +             rsvd = 1ULL << 3;
>
>  This sets bit 3
>
>> +     else
>> +             rsvd = 3ULL << 2;
>
>  And this sets bit 2 and 3.
>
>> +static int pfm_intel_arch_stop_save(struct pfm_context *ctx,
>> +                                 struct pfm_event_set *set)
>> +{
>> +     u64 used_mask[PFM_PMC_BV];
>> +     u64 val, wmask, ovfl_mask;
>> +     u32 i, count;
>> +
>> +     wmask = 1ULL << pfm_pmu_conf->counter_width;
>> +
>> +     pfm_arch_bv_and(used_mask,
>> +                     set->used_pmcs,
>> +                     enable_mask,
>> +                     max_enable);
>> +
>> +     count = pfm_arch_bv_weight(used_mask, max_enable);
>
> So we have:
>
>   set->used_pmcs and enable_mask and max_enable.
>
> Why can set->used_pmcs contain bits which are not in the enable_mask
> in the first place ? Why does the arch code not tell the generic code
> which pmcs are available so we can avoid all this mask, weight
> whatever magic ?
>

Because used_pmcs is part of generic code and enable_mask is a x86 construct.
As I said above, for now, I could drop enable_mask.
The arch code already export the list of available pmcs and pmds in
impl_pmcs and impl_pmds.

There is a difference between impl_pmcs and used_pmcs. The former list
everything that is
available. The latter shows what we are currently using. We may be
using fewer registers than
what is available, and we use this information to avoid
saving/restoring MSR on context switch
for instance.

> We store the same information in slightly different incarnations in
> various places and then we need to mingle them all together to get to
> the real data. That makes no sense at all.
>
>> +     /*
>> +      * stop monitoring
>> +      * Unfortunately, this is very expensive!
>> +      * wrmsrl() is serializing.
>> +      */
>> +     for (i = 0; count; i++) {
>> +             if (pfm_arch_bv_test_bit(i, used_mask)) {
>> +                     wrmsrl(pfm_pmu_conf->pmc_desc[i].hw_addr, 0);
>> +                     count--;
>> +             }
>> +     }
>> +
>> +     /*
>> +      * if we already having a pending overflow condition, we simply
>> +      * return to take care of this first.
>> +      */
>> +     if (set->npend_ovfls)
>> +             return 1;
>
> Why are the counters enabled at all when an overflow is pending, which
> stopped the counters anyway ?
>
Because on Intel and AMD64, counters are not automatically frozen on interrupt.
On Intel X86, they can be configured to do so, but it is an all or
nothing setting.
I am not using this option because we would then have a problem with the NMI
watchdog given that it is also using a counter.
