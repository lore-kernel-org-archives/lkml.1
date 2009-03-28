Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZC1JIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZC1JIF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbZC1JHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:07:52 -0400
Received: from ozlabs.org ([203.10.76.45]:44506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbZC1JHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:07:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] irq: remove wrong ifdef
Date: Sat, 28 Mar 2009 19:37:47 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <49CDAB27.7050602@kernel.org> <49CDAB6E.90006@kernel.org>
In-Reply-To: <49CDAB6E.90006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281937.48755.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 March 2009 15:15:34 Yinghai Lu wrote:
> Impact: fix smp_affinity copying
> 
> CPUMASKS_OFFSTACK is not defined anywhere.
> and init_allocate_desc_masks called before it set affinity to all cpus...
> 
> just remove those #idef to make them get copied
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  include/linux/irq.h |    4 ----
>  1 file changed, 4 deletions(-)
> 
> Index: linux-2.6/include/linux/irq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/irq.h
> +++ linux-2.6/include/linux/irq.h
> @@ -468,20 +468,16 @@ static inline bool init_alloc_desc_masks
>   * @new_desc:	pointer to new irq_desc struct
>   *
>   * Insures affinity and pending_masks are copied to new irq_desc.
> - * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
> - * irq_desc struct so the copy is redundant.
>   */
>  
>  static inline void init_copy_desc_masks(struct irq_desc *old_desc,
>  					struct irq_desc *new_desc)
>  {
> -#ifdef CONFIG_CPUMASKS_OFFSTACK
>  	cpumask_copy(new_desc->affinity, old_desc->affinity);
>  
>  #ifdef CONFIG_GENERIC_PENDING_IRQ
>  	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
>  #endif
> -#endif
>  }
>  
>  #else /* !CONFIG_SMP */

Wow, that is supposed to be CONFIG_CPUMASK_OFFSTACK.

The reason it is there is that we already do the memcpy of old_desc: this
extra copy is only needed if the cpumasks are external.  But perhaps it's
an over-optimization.

Thanks,
Rusty.
