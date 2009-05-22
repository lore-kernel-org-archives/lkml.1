Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZEVJ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZEVJ2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZEVJ2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:28:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:52434 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZEVJ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:28:01 -0400
Subject: Re: can't flush tlb on e500
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Saito Hideo <hsaito.ppc@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Kumar Gala <galak@gate.crashing.org>
In-Reply-To: <d50492d40905200312r729608a3nf244b153892ac257@mail.gmail.com>
References: <d50492d40905200312r729608a3nf244b153892ac257@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 22 May 2009 19:27:50 +1000
Message-Id: <1242984470.26104.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 19:12 +0900, Saito Hideo wrote:

> I think that the tlb should be cleared before mm->context.id is set
> MMU_NO_CONTEXT.

You are right, this definitely looks like a bug on platforms that have
HW support for the tlbil instruction (and thus care about the PID for
flushing) which afaik is only the case of recent freescale chips.

Have you verified that this change fixes your problem ?

Can you re-submit to linuxppc-dev@ozlabs.org mailing list, along with
proper changeset comment and signed-off-by: line ?

Cheers,
Ben.

> --- arch/powerpc/mm/mmu_context_nohash.c.orig	2009-03-24
> 08:12:14.000000000 +0900
> +++ arch/powerpc/mm/mmu_context_nohash.c	2009-05-20 18:33:53.000000000 +0900
> @@ -122,22 +122,22 @@ static unsigned int steal_context_up(uns
>  	struct mm_struct *mm;
>  	int cpu = smp_processor_id();
> 
>  	/* Pick up the victim mm */
>  	mm = context_mm[id];
> 
>  	pr_debug("[%d] steal context %d from mm @%p\n", cpu, id, mm);
> 
> -	/* Mark this mm has having no context anymore */
> -	mm->context.id = MMU_NO_CONTEXT;
> -
>  	/* Flush the TLB for that context */
>  	local_flush_tlb_mm(mm);
> 
> +	/* Mark this mm has having no context anymore */
> +	mm->context.id = MMU_NO_CONTEXT;
> +
>  	/* XXX This clear should ultimately be part of local_flush_tlb_mm */
>  	__clear_bit(id, stale_map[cpu]);
> 
>  	return id;
>  }
> 
>  #ifdef DEBUG_MAP_CONSISTENCY
>  static void context_check_map(void)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

