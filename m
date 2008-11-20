Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYKTTN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYKTTN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYKTTMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:12:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbYKTTMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:12:07 -0500
Date: Thu, 20 Nov 2008 20:11:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 3/8] intel-iommu: move context entry defs out from
	dma_remapping.h
Message-ID: <20081120191135.GB3955@elte.hu>
References: <1227191861.4901.24.camel@macbook.infradead.org> <1227196190-488-1-git-send-email-markmc@redhat.com> <1227196190-488-2-git-send-email-markmc@redhat.com> <1227196190-488-3-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227196190-488-3-git-send-email-markmc@redhat.com>
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


* Mark McLoughlin <markmc@redhat.com> wrote:

> Signed-off-by: Mark McLoughlin <markmc@redhat.com>
> ---
>  drivers/pci/intel-iommu.c     |   38 ++++++++++++++++++++++++++++++++++++++
>  include/linux/dma_remapping.h |   38 --------------------------------------
>  2 files changed, 38 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 2e56e5a..1c011bb 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -90,6 +90,44 @@ get_context_addr_from_root(struct root_entry *root)
>  		NULL);
>  }
>  
> +/*
> + * low 64 bits:
> + * 0: present
> + * 1: fault processing disable
> + * 2-3: translation type
> + * 12-63: address space root
> + * high 64 bits:
> + * 0-2: address width
> + * 3-6: aval
> + * 8-23: domain id
> + */
> +struct context_entry {
> +	u64 lo;
> +	u64 hi;
> +};
> +#define context_present(c) ((c).lo & 1)
> +#define context_fault_disable(c) (((c).lo >> 1) & 1)
> +#define context_translation_type(c) (((c).lo >> 2) & 3)
> +#define context_address_root(c) ((c).lo & VTD_PAGE_MASK)
> +#define context_address_width(c) ((c).hi &  7)
> +#define context_domain_id(c) (((c).hi >> 8) & ((1 << 16) - 1))
> +
> +#define context_set_present(c) do {(c).lo |= 1;} while (0)
> +#define context_set_fault_enable(c) \
> +	do {(c).lo &= (((u64)-1) << 2) | 1;} while (0)
> +#define context_set_translation_type(c, val) \
> +	do { \
> +		(c).lo &= (((u64)-1) << 4) | 3; \
> +		(c).lo |= ((val) & 3) << 2; \
> +	} while (0)
> +#define CONTEXT_TT_MULTI_LEVEL 0
> +#define context_set_address_root(c, val) \
> +	do {(c).lo |= (val) & VTD_PAGE_MASK; } while (0)
> +#define context_set_address_width(c, val) do {(c).hi |= (val) & 7;} while (0)
> +#define context_set_domain_id(c, val) \
> +	do {(c).hi |= ((val) & ((1 << 16) - 1)) << 8;} while (0)
> +#define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while (0)

Since you move this code, please also do a patch to clean it up to use 
inlines, not macros.

Thanks,

	Ingo
