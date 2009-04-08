Return-Path: <linux-kernel-owner+w=401wt.eu-S1765204AbZDHOvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765204AbZDHOvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763968AbZDHOu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:50:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39897 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbZDHOu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:50:58 -0400
Date: Wed, 8 Apr 2009 16:50:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86,apic: Checking kernel option before
	detect_init_APIC()
Message-ID: <20090408145041.GL12931@elte.hu>
References: <b9df5fa10903271825g62b95e62p6e7006f0594e2c4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10903271825g62b95e62p6e7006f0594e2c4b@mail.gmail.com>
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> Impact: cleanup
> 
> Before calling detect_init_APIC(), check whether apic is disabled 
> from kernel option or not.
> 
> Thanks.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linus/arch/x86/kernel/apic.c	2009-03-26 06:26:31.000000000 +0600
> +++ rakib/arch/x86/kernel/apic.c	2009-03-26 20:47:50.116376200 +0600
> @@ -1429,10 +1429,6 @@ static int __init detect_init_APIC(void)
>  {
>  	u32 h, l, features;
> 
> -	/* Disabled by kernel option? */
> -	if (disable_apic)
> -		return -1;
> -
>  	switch (boot_cpu_data.x86_vendor) {
>  	case X86_VENDOR_AMD:
>  		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
> @@ -1543,8 +1539,9 @@ void __init init_apic_mappings(void)
>  	 * If no local APIC can be found then set up a fake all
>  	 * zeroes page to simulate the local APIC and another
>  	 * one for the IO-APIC.
> +	 * Check apic is disabled from kernel option or not.
>  	 */
> -	if (!smp_found_config && detect_init_APIC()) {
> +	if (!smp_found_config && (disable_apic || detect_init_APIC())) {
>  		apic_phys = (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
>  		apic_phys = __pa(apic_phys);
>  	} else

Hm, are you sure this is a cleanup only? (i.e. no side-effects)

Also, even if it's a pure cleanup, wouldnt it be even cleaner to 
propagate this check into detect_init_APIC() - and thus get rid of 
the open-coded disable_apic check altogether?

	Ingo
