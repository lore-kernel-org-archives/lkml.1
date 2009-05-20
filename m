Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZETH6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZETH6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZETH6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:58:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41339 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZETH6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:58:45 -0400
Date: Wed, 20 May 2009 09:58:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: don't map io_apic two times.
Message-ID: <20090520075829.GD23959@elte.hu>
References: <4A1393CD.7080604@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1393CD.7080604@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> mp_register_ioapic() already map it.
> 
> [ Impact: don't map io apic address again ]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/apic/io_apic.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -4162,7 +4162,12 @@ fake_ioapic_page:
>  				alloc_bootmem_pages(PAGE_SIZE);
>  			ioapic_phys = __pa(ioapic_phys);
>  		}
> -		set_fixmap_nocache(idx, ioapic_phys);
> +		/*
> +		 * when acpi ioapic is used, mp_register_ioapic() map
> +		 * ioapic_phys already
> +		 */
> +		if (!acpi_ioapic)
> +			set_fixmap_nocache(idx, ioapic_phys);

The change is correct, but i'm not sure we want to do this - the 
acpi_ioapic flag might change its meaning (and then break this code 
subtly) and this is bootup code so doing the mapping twice should be 
no issue.

If it were some expensive initialization i'd agree, but here it's 
really just a couple of instructions and an INVLPG.

Hm?

	Ingo
