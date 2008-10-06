Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbYJFFYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbYJFFYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYJFFXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:23:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56206 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYJFFXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:23:52 -0400
Date: Mon, 6 Oct 2008 07:23:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006052337.GE2186@elte.hu>
References: <20081005180154.7cc12486@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005180154.7cc12486@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 5 Oct 2008 18:00:15 -0700
> Subject: [PATCH] resource: don't allow /dev/mem access reserved resources
> 
> Device drivers that use pci_request_regions() (and similar APIs) have a
> reasonable expectation that they are the only ones accessing their device.
> As part of the e1000e hunt, we were afraid that some userland (X or some
> bootsplash stuff) was mapping the MMIO region, that the driver thought it
> had exclusively, via /dev/mem.
> 
> This patch adds, to the existing config option to restrict /dev/mem, the
> reserved regions to the "banned from /dev/mem use" list, so now
> both kernel memory and device-exclusive MMIO regions are banned.
> 
> The introduced iomem_is_reserved() function is also planned to be used
> for other patches in 2.6.28 (pci_ioremap) so is exported here as part
> of being introduced.
> 
> Signed-of-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/mm/init_32.c  |    2 ++
>  arch/x86/mm/init_64.c  |    2 ++
>  include/linux/ioport.h |    1 +
>  kernel/resource.c      |   32 ++++++++++++++++++++++++++++++++
>  4 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 63b71d3..c98f5e8 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -329,6 +329,8 @@ int devmem_is_allowed(unsigned long pagenr)
>  {
>  	if (pagenr <= 256)
>  		return 1;
> +	if (iomem_is_reserved(pagenr << PAGE_SHIFT))
> +		return 0;

looks good and useful to me. One small request: could you please stick a 
big fat WARN_ONCE() into this codepath as well?

and it's properly dependent on CONFIG_STRICT_DEVMEM=y [which is 
default-off], so it's not a legacy ABI breaker either.

another small detail:

> +int iomem_is_reserved(u64 addr)
> +{
> +     struct resource *p = &iomem_resource;
> +     int err = 0;
> +     loff_t l;
> +     int size= PAGE_SIZE;
> +
> +     read_lock(&resource_lock);
> +     for (p = p->child; p ; p = r_next(NULL, p, &l)) {
> +             /*
> +              * We can probably skip the resources without
> +              * IORESOURCE_IO attribute?
> +              */
> +             if (p->start >= addr + size)
> +                     continue;

do we want to skip all resources that are not IORESOURCE_MEM? Same holds 
for iomem_map_sanity_check(), introduced in tip/core/resources:

 379daf6: IO resources, x86: ioremap sanity check to catch mapping requests exceeding the BAR sizes

on which you seem to have based iomem_is_reserved().

Perhaps even base both iomem_map_sanity_check() and iomem_is_reserved() 
on a single helper function, and unify the iterator and the overlap 
check? The two have a very similar purpose.

	Ingo
