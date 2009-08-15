Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZHOORi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZHOORi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 10:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZHOORh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 10:17:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbZHOORg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 10:17:36 -0400
Date: Sat, 15 Aug 2009 16:17:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: Ignore the aperture memory hole on x86_64
Message-ID: <20090815141716.GA15941@elte.hu>
References: <20090812205215.GA21451@elte.hu> <1250289913.5085.17.camel@pc1117.cambridge.arm.com> <1250290118.5085.21.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250290118.5085.21.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> This block is allocated with alloc_bootmem() and scanned by 
> kmemleak but the kernel direct mapping may no longer exist. This 
> patch tells kmemleak to ignore this memory hole.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/aperture_64.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 676debf..cb690b3 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -94,6 +94,11 @@ static u32 __init allocate_aperture(void)
>  	 * code for safe
>  	 */
>  	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
> +	/*
> +	 * Kmemleak should not scan this block as it may not be mapped via the
> +	 * kernel direct mapping.
> +	 */
> +	kmemleak_ignore(p);

More importantly, kmemleak should _never_ do the garbage collection 
scan for device memory (such as the agp aperture above). All the 
aperture areas are in that category - PCI aperture, IOMMU areas, 
etc. etc.

Please double check that kmemleak does not check those - there are 
devices where pure reading of that address space can have 
side-effects.

	Ingo
