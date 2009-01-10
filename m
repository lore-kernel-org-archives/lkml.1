Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZAJWxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZAJWxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZAJWw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:52:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZAJWw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:52:58 -0500
Date: Sat, 10 Jan 2009 23:52:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kstat: modify kstat_irqs_legacy to be variable
	sized
Message-ID: <20090110225229.GE17917@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223819.033438000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110223819.033438000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4934]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Impact: reduce memory usage.
> 
> Allocate kstat_irqs_legacy based on nr_cpu_ids to deal with this
> memory usage bump when NR_CPUS bumped from 128 to 4096:
> 
>      8192   +253952    262144 +3100%  kstat_irqs_legacy(.bss)
> 
> This is only when CONFIG_SPARSE_IRQS=y.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  kernel/irq/handle.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> --- linux-2.6-for-ingo.orig/kernel/irq/handle.c
> +++ linux-2.6-for-ingo/kernel/irq/handle.c
> @@ -124,8 +124,7 @@ static struct irq_desc irq_desc_legacy[N
>  	}
>  };
>  
> -/* FIXME: use bootmem alloc ...*/
> -static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
> +static unsigned int *kstat_irqs_legacy;
>  
>  int __init early_irq_init(void)
>  {
> @@ -146,9 +145,13 @@ int __init early_irq_init(void)
>  	/* allocate irq_desc_ptrs array based on nr_irqs */
>  	irq_desc_ptrs = alloc_bootmem(nr_irqs * sizeof(void *));
>  
> +	/* allocate based on nr_cpu_ids */
> +	kstat_irqs_legacy = alloc_bootmem(NR_IRQS_LEGACY * nr_cpu_ids *
> +					  sizeof(int));
> +
>  	for (i = 0; i < legacy_count; i++) {
>  		desc[i].irq = i;
> -		desc[i].kstat_irqs = kstat_irqs_legacy[i];
> +		desc[i].kstat_irqs = kstat_irqs_legacy + i * NR_IRQS_LEGACY;
>  		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
>  		init_alloc_desc_masks(&desc[i], 0, true);
>  		irq_desc_ptrs[i] = desc + i;

btw., while at it - dont we want to upgrade this to a 'long' (in a 
separate commit)? Having more than 4 billion irqs after bootup is easily 
possible.

	Ingo
