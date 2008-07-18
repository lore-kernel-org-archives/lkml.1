Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYGROw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYGROw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYGROwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:52:18 -0400
Received: from gw.goop.org ([64.81.55.164]:50745 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbYGROwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:52:18 -0400
Message-ID: <4880AE15.5060101@goop.org>
Date: Fri, 18 Jul 2008 07:52:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: clean up pgd_{c,d}tor
References: <4880AD11.76E4.0078.0@novell.com>
In-Reply-To: <4880AD11.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Giving pgd_ctor() a properly typed parameter allows eliminating a local
> variable. Adjust pgd_dtor() to match.
>
> Also, pgd_ctor()'s clearing of the memory is redundant with the
> GFP_ZERO used for allocating it.
>   

Ack to the parameter type change.  But there's already a patch in git to 
remove the redundant clear.

    J

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> ---
>  arch/x86/mm/pgtable.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> --- linux-2.6.26/arch/x86/mm/pgtable.c	2008-07-13 23:51:29.000000000 +0200
> +++ 2.6.26-x86-pgd-alloc-cleanup/arch/x86/mm/pgtable.c	2008-06-25 14:35:40.000000000 +0200
> @@ -62,14 +62,10 @@ static inline void pgd_list_del(pgd_t *p
>  #define UNSHARED_PTRS_PER_PGD				\
>  	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
>  
> -static void pgd_ctor(void *p)
> +static void pgd_ctor(pgd_t *pgd)
>  {
> -	pgd_t *pgd = p;
>  	unsigned long flags;
>  
> -	/* Clear usermode parts of PGD */
> -	memset(pgd, 0, KERNEL_PGD_BOUNDARY*sizeof(pgd_t));
> -
>  	spin_lock_irqsave(&pgd_lock, flags);
>  
>  	/* If the pgd points to a shared pagetable level (either the
> @@ -94,7 +90,7 @@ static void pgd_ctor(void *p)
>  	spin_unlock_irqrestore(&pgd_lock, flags);
>  }
>  
> -static void pgd_dtor(void *pgd)
> +static void pgd_dtor(pgd_t *pgd)
>  {
>  	unsigned long flags; /* can be called from interrupt context */
>  
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

