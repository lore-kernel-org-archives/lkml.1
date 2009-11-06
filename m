Return-Path: <linux-kernel-owner+w=401wt.eu-S1760331AbZKFW7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbZKFW7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760238AbZKFW7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:59:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:54385 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760223AbZKFW7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:59:09 -0500
Subject: Re: [patch 09/16] powerpc: Replace old style lock initializer
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <20091106223806.762624109@linutronix.de>
References: <20091106223547.784916750@linutronix.de>
	 <20091106223806.762624109@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 09:55:44 +1100
Message-ID: <1257548144.13611.267.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 22:41 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (power-replace-old-style-lock-init.patch)
> SPIN_LOCK_UNLOCKED is deprecated. Init the lock array at runtime
> instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: linuxppc-dev@ozlabs.org
> ---

Looks reasonable. But iseries can be a bitch, so we do need to test it
on monday.

Cheers,
Ben.

>  arch/powerpc/platforms/iseries/htab.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/powerpc/platforms/iseries/htab.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/platforms/iseries/htab.c
> +++ linux-2.6/arch/powerpc/platforms/iseries/htab.c
> @@ -19,8 +19,7 @@
>  
>  #include "call_hpt.h"
>  
> -static spinlock_t iSeries_hlocks[64] __cacheline_aligned_in_smp =
> -	{ [0 ... 63] = SPIN_LOCK_UNLOCKED};
> +static spinlock_t iSeries_hlocks[64] __cacheline_aligned_in_smp;
>  
>  /*
>   * Very primitive algorithm for picking up a lock
> @@ -245,6 +244,11 @@ static void iSeries_hpte_invalidate(unsi
>  
>  void __init hpte_init_iSeries(void)
>  {
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(iSeries_hlocks); i++)
> +		spin_lock_init(&iSeries_hlocks[i]);
> +
>  	ppc_md.hpte_invalidate	= iSeries_hpte_invalidate;
>  	ppc_md.hpte_updatepp	= iSeries_hpte_updatepp;
>  	ppc_md.hpte_updateboltedpp = iSeries_hpte_updateboltedpp;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


