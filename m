Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZCNOAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZCNOAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 10:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZCNOA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 10:00:29 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:46776 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbZCNOA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 10:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pKviLPOXZtrws0LKUpwDdiBrm/L1HD2EgkRoa4IdyRfCa1CxjFL/+HuK+xmISDL4UC
         Aek0HKm5GAWCwYmhJuPzXevVEth/OFAMqTFSeMZJRnx7GW/KMljY8DQC3qhGmXxHmLHi
         3hM5wMG3kYQlrR7rvv2dWz/JHotGr3XbNCxZc=
MIME-Version: 1.0
In-Reply-To: <1237037822.4546.8.camel@ht.satnam>
References: <1237034492.4546.1.camel@ht.satnam>
	 <20090314131142.GA29582@uranus.ravnborg.org>
	 <20090314132004.GD17727@elte.hu> <1237037822.4546.8.camel@ht.satnam>
Date: Sat, 14 Mar 2009 15:00:25 +0100
Message-ID: <19f34abd0903140700r6c23da9aq6747fbcce7bcc4b2@mail.gmail.com>
Subject: Re: [PATCH -tip] x86: cpu/intel.c cleanup
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/14 Jaswinder Singh Rajput <jaswinder@kernel.org>:
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Sat, 14 Mar 2009 17:47:38 +0530
> Subject: [PATCH] x86: cpu/intel.c cleanup
>
> - fix various style problems
>  - fix header files issues
>

[...]

>  static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  {
> +       u64 misc_enable;
> +
>        /* Unmask CPUID levels if masked: */
>        if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
> -               u64 misc_enable;
>
>                rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
>
> @@ -44,16 +45,16 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>        }
>
>        if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
> -               (c->x86 == 0x6 && c->x86_model >= 0x0e))
> +           (c->x86 == 0x6 && c->x86_model >= 0x0e))
>                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>
>  #ifdef CONFIG_X86_64
>        set_cpu_cap(c, X86_FEATURE_SYSENTER32);
> -#else
> +#else /* CONFIG_X86_64 */
>        /* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
>        if (c->x86 == 15 && c->x86_cache_alignment == 64)
>                c->x86_cache_alignment = 128;
> -#endif
> +#endif /* CONFIG_X86_64 */
>
>        /* CPUID workaround for 0F33/0F34 CPU */
>        if (c->x86 == 0xF && c->x86_model == 0x3
> @@ -96,19 +97,18 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>         * Ingo Molnar reported a Pentium D (model 6) and a Xeon
>         * (model 2) with the same problem.
>         */
> -       if (c->x86 == 15) {
> -               u64 misc_enable;
> +       if (c->x86 != 15)
> +               return;
>
> -               rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +       rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
>
> -               if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
> -                       printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
> +       if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
> +               pr_info("kmemcheck: Disabling fast string operations\n");
>
> -                       misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> -                       wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> -               }
> +               misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> +               wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
>        }
> -#endif
> +#endif /* CONFIG_KMEMCHECK */
>  }

I don't really like this change (last hunk). Doesn't it seem a bit
pointless? It breaks the symmetry with the masked CPUID levels at the
beginning of the function. If somebody wants to add something else to
this function, it might have to be reindented again. Or is there a
problem with too long lines here?

But it's just a question of taste -- if this is the preferred style,
then it's fine.


Vegard
