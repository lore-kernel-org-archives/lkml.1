Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbYETFyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbYETFyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 01:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYETFyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 01:54:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:42013 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYETFyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 01:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X0R5qyxnbnR06FUegiopTvlZCmFZhuLT7ve178thNNBVRRzkUaQ8ybzYCIpmLWSY3pZ/GLxkJrnosetrV1xfQV5EUjBY9AmLa2sL5xY6XZKsBNy0284dgUBXPPZdW8+t52Q1BUfMoGpuAw4IrYqGhFH8gsciFYd29atD+fweNtA=
Message-ID: <86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com>
Date: Mon, 19 May 2008 22:53:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Dave Jones" <davej@redhat.com>
Subject: Re: [X86] Add a boot parameter to force-enable PAT
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       hpa@zytor.com
In-Reply-To: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 9:09 PM, Dave Jones <davej@redhat.com> wrote:
> * Add an enablepat boot parameter, useful for testing CPUs not yet
>  added to the whitelist.
> * Don't try to enable PAT if it was never enabled in the first place.
>
> Signed-off-by: Dave Jones <davej@redhat.com>
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 72c07a0..e179c22 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -236,6 +236,10 @@ and is between 256 and 4096 characters. It is defined in the file
>                        try_unsupported: try to drive unsupported chipsets
>                                (may crash computer or cause data corruption)
>
> +       enablepat       [i386,x86-64]
> +                       Force the CPU's PAT feature to be used even if it
> +                       isn't in the kernels whitelist.
> +
>        enable_timer_pin_1 [i386,x86-64]
>                        Enable PIN 1 of APIC timer
>                        Can be useful to work around chipset bugs
> diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
> index c2e1ce3..6ce3202 100644
> --- a/arch/x86/kernel/cpu/addon_cpuid_features.c
> +++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
> @@ -50,9 +50,28 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
>        }
>  }
>
> +static int forcepat;
> +
> +static int __init x86_forcepat_setup(char *s)
> +{
> +       forcepat = 1;
> +       return 1;
> +}
> +__setup("enablepat", x86_forcepat_setup);
> +
> +
>  #ifdef CONFIG_X86_PAT
>  void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
>  {
> +       if (!test_cpu_cap(c, X86_FEATURE_PAT))
> +               return;
> +
> +       if (forcepat == 1) {
> +               printk(KERN_INFO "Force enabling PAT\n");
> +               set_cpu_cap(c, X86_FEATURE_PAT);

you don't need to set that bit again...

prevoious !test_cpu_cap(..) already get out.


> +               return;
> +       }
> +
>        switch (c->x86_vendor) {
>        case X86_VENDOR_AMD:
>                if (c->x86 >= 0xf && c->x86 <= 0x11)
>

YH
