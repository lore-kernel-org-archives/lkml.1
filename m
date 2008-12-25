Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbYLYWqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbYLYWqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 17:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYLYWqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 17:46:15 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:19643 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYLYWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 17:46:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lxtBLRq7/czeejMQi0rQrHF0RjKNJFTlKIDg5YnQs867uqw8EzC653PdHdICuiyrVH
         M8blzqTo4hJ//4G6zNRhZJVhoAlbXw1aieFr5CxoHvfXvAxFBQ6y5x94p+hUcMZHWEMF
         qLWyweC5o7j4Jn51tq5U8597XxMf+dF7aCI5I=
Message-ID: <86802c440812251446x29a73794oaa91e8c46ce6cff9@mail.gmail.com>
Date: Thu, 25 Dec 2008 14:46:12 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: linux-next: parsing mem=700M broken
Cc: "Ingo Molnar" <mingo@elte.hu>, "Hugh Dickins" <hugh@veritas.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200812252210.36367.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils>
	 <200812241808.16195.rusty@rustcorp.com.au>
	 <4951EE20.5080004@kernel.org>
	 <200812252210.36367.rusty@rustcorp.com.au>
X-Google-Sender-Auth: 409429e1b9636408
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 3:40 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wednesday 24 December 2008 18:39:04 Yinghai Lu wrote:
>> for cpu caps on boot cpu setup still need
>
> OK, how about these?  I cleaned up description a little, and put
> it in own function.

looks good.

YH

>
> Subject: [PATCH] x86: clean up setup_clear/force_cpu_cap handling
> From: Yinghai Lu <yinghai.lu@kernel.org>
>
> Impact: fix and cleanup
>
> setup_force_cpu_cap() only has one user (xen) but it should not reuse
> cleared_cpu_cpus.  It will have problems for smp.
>
> Need to have cpu_cpus_set array too, and need to combine it before
> we AND into boot_cpu_data.x86_capability.
>
> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/include/asm/cpufeature.h |    4 ++--
>  arch/x86/include/asm/processor.h  |    3 ++-
>  arch/x86/kernel/cpu/common.c      |   17 ++++++++++++-----
>  3 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -188,11 +188,11 @@ extern const char * const x86_power_flag
>  #define clear_cpu_cap(c, bit)  clear_bit(bit, (unsigned long *)((c)->x86_capability))
>  #define setup_clear_cpu_cap(bit) do { \
>        clear_cpu_cap(&boot_cpu_data, bit);     \
> -       set_bit(bit, (unsigned long *)cleared_cpu_caps); \
> +       set_bit(bit, (unsigned long *)cpu_caps_cleared); \
>  } while (0)
>  #define setup_force_cpu_cap(bit) do { \
>        set_cpu_cap(&boot_cpu_data, bit);       \
> -       clear_bit(bit, (unsigned long *)cleared_cpu_caps);      \
> +       set_bit(bit, (unsigned long *)cpu_caps_set);    \
>  } while (0)
>
>  #define cpu_has_fpu            boot_cpu_has(X86_FEATURE_FPU)
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -130,7 +130,8 @@ extern struct cpuinfo_x86   new_cpu_data;
>  extern struct cpuinfo_x86      new_cpu_data;
>
>  extern struct tss_struct       doublefault_tss;
> -extern __u32                   cleared_cpu_caps[NCAPINTS];
> +extern __u32                   cpu_caps_cleared[NCAPINTS];
> +extern __u32                   cpu_caps_set[NCAPINTS];
>
>  #ifdef CONFIG_SMP
>  DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -219,7 +219,8 @@ static char __cpuinit *table_lookup_mode
>        return NULL;            /* Not found */
>  }
>
> -__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
> +__u32 cpu_caps_cleared[NCAPINTS] __cpuinitdata;
> +__u32 cpu_caps_set[NCAPINTS] __cpuinitdata;
>
>  /* Current gdt points %fs at the "master" per-cpu area: after this,
>  * it's on the real one. */
> @@ -512,6 +513,16 @@ static void __cpuinit identify_cpu_witho
>  #endif
>  }
>
> +static void __cpuinit override_capabilities(u32 x86_capability[])
> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < NCAPINTS; i++) {
> +               x86_capability[i] &= ~cpu_caps_cleared[i];
> +               x86_capability[i] |= cpu_caps_set[i];
> +       }
> +}
> +
>  /*
>  * Do minimum CPU detection early.
>  * Fields really needed: vendor, cpuid_level, family, model, mask,
> @@ -703,6 +714,9 @@ static void __cpuinit identify_cpu(struc
>        detect_ht(c);
>  #endif
>
> +       /* Command-line override before we AND into smp all cpus cap. */
> +       override_capabilities(c->x86_capability);
> +
>        /*
>         * On SMP, boot_cpu_data holds the common feature set between
>         * all CPUs; so make sure that we indicate which features are
> @@ -714,10 +728,6 @@ static void __cpuinit identify_cpu(struc
>                for (i = 0; i < NCAPINTS; i++)
>                        boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
>        }
> -
> -       /* Clear all flags overriden by options */
> -       for (i = 0; i < NCAPINTS; i++)
> -               c->x86_capability[i] &= ~cleared_cpu_caps[i];
>
>  #ifdef CONFIG_X86_MCE
>        /* Init Machine Check Exception if available. */
>
>
> Subject: x86: override_capabilities in early_identify_cpu
> From: Rusty Russell <rusty@rustcorp.com.au>
>
> Impact: future-proof
>
> This does nothing at the moment, but once early_param() are parsed before
> setup_arch, it will ensure we respect commandline overrides on the boot
> cpu's capabilities.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Yinghai Lu <yinghai.lu@kernel.org>
>
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -559,6 +559,8 @@ static void __init early_identify_cpu(st
>
>        if (this_cpu->c_early_init)
>                this_cpu->c_early_init(c);
> +
> +       override_capabilities(c->x86_capability);
>
>        validate_pat_support(c);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
