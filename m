Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZAJWuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZAJWuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 17:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZAJWub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 17:50:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZAJWua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 17:50:30 -0500
Date: Sat, 10 Jan 2009 23:50:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] irq: initialize nr_irqs based on nr_cpu_ids
Message-ID: <20090110225010.GD17917@elte.hu>
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.900264000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110223818.900264000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Impact: Reduce memory usage.
> 
> This is the second half of the changes to make the irq_desc_ptrs be
> variable sized based on nr_cpu_ids.  The algorithm is the same as the
> setting of NR_IRQS except use nr_cpu_ids instead of NR_CPUS.  This is
> only when CONFIG_SPARSE_IRQS=y.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  kernel/irq/handle.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Files linux-2.6-for-ingo.orig/kernel/irq/.handle.c.swp and linux-2.6-for-ingo/kernel/irq/.handle.c.swp differ
> --- linux-2.6-for-ingo.orig/kernel/irq/handle.c
> +++ linux-2.6-for-ingo/kernel/irq/handle.c
> @@ -133,6 +133,11 @@ int __init early_irq_init(void)
>  	int legacy_count;
>  	int i;
>  
> +	/* initialize nr_irqs based on nr_cpu_ids */
> + 	nr_irqs =  (8 * nr_cpu_ids) > (32 * MAX_IO_APICS) ?
> + 			NR_VECTORS + (8 * nr_cpu_ids) :
> + 			NR_VECTORS + (32 * MAX_IO_APICS);
> +

this will break non-x86. Please move this to the x86 early-irq-init 
function instead, and also sync it up with the current NR_IRQS sizing 
macro.

I.e. do not duplicate the numbers but introduce some sort of 
max_nr_irqs(nr_cpus) define that is used to initialize NR_IRQS and also 
used later on to narrow down nr_irqs later on.

	Ingo
