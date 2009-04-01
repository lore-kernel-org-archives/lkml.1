Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbZDAOx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbZDAOx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764028AbZDAOxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:53:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58543 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763455AbZDAOxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:53:45 -0400
Date: Wed, 1 Apr 2009 16:53:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 4/6] x86: irqinit - merge native_init_IRQ
Message-ID: <20090401145328.GB6196@elte.hu>
References: <20090329201545.470255691@openvz.org> <20090329202208.155551990@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329202208.155551990@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> For this purpose init_ISA_irqs is called indirectly
> by x86_quirk_pre_intr_init.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/irqinit_32.c |    4 +++-
>  arch/x86/kernel/irqinit_64.c |   22 +++++++++++++++++++++-
>  arch/x86/kernel/setup.c      |    8 ++++++++
>  3 files changed, 32 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c
> +++ linux-2.6.git/arch/x86/kernel/irqinit_32.c
> @@ -215,7 +215,7 @@ void __init native_init_IRQ(void)
>  	 */
>  	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
>  		int vector = FIRST_EXTERNAL_VECTOR + i;
> -		/* SYSCALL_VECTOR was reserved in trap_init. */
> +		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
>  		if (!test_bit(vector, used_vectors))
>  			set_intr_gate(vector, interrupt[i]);
>  	}
> @@ -229,6 +229,7 @@ void __init native_init_IRQ(void)
>  	 */
>  	x86_quirk_intr_init();
>  
> +#ifdef CONFIG_X86_32
>  	/*
>  	 * External FPU? Set up irq13 if so, for
>  	 * original braindamaged IBM FERR coupling.
> @@ -237,4 +238,5 @@ void __init native_init_IRQ(void)
>  		setup_irq(FPU_IRQ, &fpu_irq);
>  
>  	irq_ctx_init(smp_processor_id());
> +#endif
>  }
> Index: linux-2.6.git/arch/x86/kernel/irqinit_64.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/irqinit_64.c
> +++ linux-2.6.git/arch/x86/kernel/irqinit_64.c
> @@ -21,6 +21,7 @@
>  #include <asm/pgtable.h>
>  #include <asm/desc.h>
>  #include <asm/apic.h>
> +#include <asm/setup.h>
>  #include <asm/i8259.h>
>  
>  /*
> @@ -174,7 +175,8 @@ void __init native_init_IRQ(void)
>  {
>  	int i;
>  
> -	init_ISA_irqs();
> +	/* Execute any quirks before the call gates are initialised: */
> +	x86_quirk_pre_intr_init();
>  
>  	apic_intr_init();
>  
> @@ -185,10 +187,28 @@ void __init native_init_IRQ(void)
>  	 */
>  	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
>  		int vector = FIRST_EXTERNAL_VECTOR + i;
> +		/* X86-32: SYSCALL_VECTOR was reserved in trap_init. */
>  		if (!test_bit(vector, used_vectors))
>  			set_intr_gate(vector, interrupt[i]);
>  	}
>  
>  	if (!acpi_ioapic)
>  		setup_irq(2, &irq2);
> +
> +	/*
> +	 * Call quirks after call gates are initialised (usually add in
> +	 * the architecture specific gates):
> +	 */
> +	x86_quirk_intr_init();
> +
> +#ifdef CONFIG_X86_32
> +	/*
> +	 * External FPU? Set up irq13 if so, for
> +	 * original braindamaged IBM FERR coupling.
> +	 */
> +	if (boot_cpu_data.hard_math && !cpu_has_fpu)
> +		setup_irq(FPU_IRQ, &fpu_irq);
> +
> +	irq_ctx_init(smp_processor_id());
> +#endif
>  }
> Index: linux-2.6.git/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/setup.c
> +++ linux-2.6.git/arch/x86/kernel/setup.c
> @@ -1087,3 +1087,11 @@ void __init x86_quirk_time_init(void)
>  	setup_irq(0, &irq0);
>  }
>  #endif /* CONFIG_X86_32 */
> +
> +#ifdef CONFIG_X86_64
> +void x86_quirk_pre_intr_init(void)
> +{
> +	init_ISA_irqs();
> +}
> +void x86_quirk_intr_init(void) { }
> +#endif

Hm, wouldnt it be cleaner to add it as a new quirk function vector 
in struct x86_quirks? See arch/x86/include/asm/setup.h.

	Ingo
