Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYKQQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYKQQw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYKQQws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:52:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32822 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYKQQwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:52:47 -0500
Date: Mon, 17 Nov 2008 17:52:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
Message-ID: <20081117165224.GH12081@elte.hu>
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49200031.2040701@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: fix wakeup path with numaq and es7000

applied	to tip/x86/quirks, thanks Yinghai!

A couple of comments:

> +static inline void inquire_remote_apic(int apicid)
> +{
> +	if (apic_verbosity >= APIC_DEBUG)
> +		__inquire_remote_apic(apicid);
> +}

could you please make this a non-include-file function and only 
install the function vector if the platform necessiates it?

I.e.:

> +	void (*wait_for_init_deassert)(atomic_t *deassert);
> +	void (*smp_callin_clear_local_apic)(void);
> +	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
> +	void (*restore_NMI_vector)(unsigned short *high, unsigned short *low);
> +	void (*inquire_remote_apic)(int apicid);

should have NULL in the 'default' case - and only have some exception 
(quick) function installed in the non-default case.

That way the 3 separate wait_for_init_deassert() and 
inquire_remote_apic() inline functions can be removed and the 
exception be moved to es7000_32.c and numaq_32.c.

like you did it here properly to install the MIP-init sequence in the 
es7000 case:

> Index: linux-2.6/arch/x86/kernel/es7000_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/es7000_32.c
> +++ linux-2.6/arch/x86/kernel/es7000_32.c
> @@ -40,6 +40,7 @@
>  #include <asm/smp.h>
>  #include <asm/apicdef.h>
>  #include <mach_mpparse.h>
> +#include <asm/setup.h>
>  
>  /*
>   * ES7000 chipsets
> @@ -161,6 +162,26 @@ es7000_rename_gsi(int ioapic, int gsi)
>  	return gsi;
>  }
>  
> +#ifdef CONFIG_ES7000_CLUSTERED_APIC
> +static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
> +{
> +	unsigned long vect = 0, psaival = 0;
> +
> +	if (psai == NULL)
> +		return -1;
> +
> +	vect = ((unsigned long)__pa(eip)/0x1000) << 16;
> +	psaival = (0x1000000 | vect | cpu);
> +
> +	while (*psai & 0x1000000)
> +		;
> +
> +	*psai = psaival;
> +
> +	return 0;
> +}
> +#endif
> +
>  void __init
>  setup_unisys(void)
>  {
> @@ -176,6 +197,9 @@ setup_unisys(void)
>  	else
>  		es7000_plat = ES7000_CLASSIC;
>  	ioapic_renumber_irq = es7000_rename_gsi;
> +#ifdef CONFIG_ES7000_CLUSTERED_APIC
> +	x86_quirks->wakeup_secondary_cpu = wakeup_secondary_cpu_via_mip;
> +#endif
>  }

btw:

shouldnt CONFIG_ES7000_CLUSTERED_APIC be converted to a proper genapic 
variant (like we have in apic.c), instead of this #ifdef driven 
mechanism?

	Ingo
