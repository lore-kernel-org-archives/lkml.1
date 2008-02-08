Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbYBHXMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbYBHXMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYBHXL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:11:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYBHXL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:11:56 -0500
Date: Sat, 9 Feb 2008 00:11:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some
	processors
Message-ID: <20080208231130.GA10511@elte.hu>
References: <200802082347.25364.michael-lists@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802082347.25364.michael-lists@free-electrons.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


looks good to me, but the patch needs a serious #ifdef removal pass:

* Michael Opdenacker <michael-lists@free-electrons.com> wrote:

>  	switch (c->x86_vendor) {
> +#ifdef CONFIG_CPU_SUP_AMD
>  	case X86_VENDOR_AMD:
>  		early_init_amd(c);
>  		break;
> +#endif
> +#ifdef CONFIG_CPU_SUP_INTEL
>  	case X86_VENDOR_INTEL:
>  		early_init_intel(c);
>  		break;
> +#endif

would be nice to hide these #ifdefs into include files. (define 
early_init_intel()/etc. as an empty inline in an include file)

> +#ifdef CONFIG_CPU_SUP_INTEL
>  	intel_cpu_init();
> +#endif
> +#ifdef CONFIG_CPU_SUP_CYRIX
>  	cyrix_init_cpu();
> +#endif
> +#ifdef CONFIG_CPU_SUP_NSC
>  	nsc_init_cpu();
> +#endif
> +#ifdef CONFIG_CPU_SUP_AMD
>  	amd_init_cpu();
> +#endif
> +#ifdef CONFIG_CPU_SUP_CENTAUR
>  	centaur_init_cpu();
> +#endif
> +#ifdef CONFIG_CPU_SUP_TRANSMETA
>  	transmeta_init_cpu();
> +#endif
> +#ifdef CONFIG_CPU_SUP_NEXGEN
>  	nexgen_init_cpu();
> +#endif
> +#ifdef CONFIG_CPU_SUP_UMC
>  	umc_init_cpu();
> +#endif

ditto - hide this into cpu.h.

>  static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
>  {
> +#ifdef CONFIG_CPU_SUP_AMD
>  	if (force_mwait)
>  		return 1;
> +#endif

same - use cpu.h to define force_mwait to 0 if !CPU_SUP_AMD.

> +#ifdef CONFIG_CPU_SUP_INTEL
>  static inline int page_kills_ppro(unsigned long pagenr)
>  {
>  	if (pagenr >= 0x70000 && pagenr <= 0x7003F)
>  		return 1;
>  	return 0;
>  }
> +#endif

put the #ifdef _inside_ the inline, thus:

> -	if (page_is_ram(pfn) && !(bad_ppro && page_kills_ppro(pfn))) {
> +	if (page_is_ram(pfn)
> +#ifdef CONFIG_CPU_SUP_INTEL
> +	    && !(bad_ppro && page_kills_ppro(pfn))
> +#endif

you can avoid this #ifdef. [handle bad_ppro too]

	Ingo
