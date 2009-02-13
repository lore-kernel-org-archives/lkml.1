Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbZBMA4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbZBMA4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZBMA4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:56:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbZBMA4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:56:35 -0500
Date: Thu, 12 Feb 2009 16:55:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org
Subject: Re: [PATCH] mm: disable preemption in apply_to_pte_range
Message-Id: <20090212165539.5ce51468.akpm@linux-foundation.org>
In-Reply-To: <4994C052.9060907@goop.org>
References: <4994BCF0.30005@goop.org>
	<4994C052.9060907@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 16:35:30 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Jeremy Fitzhardinge wrote:
> > commit 79d9c90453a7bc9e7613ae889a97ff6b44ab8380
> 
> Scratch that.

Whew.  Version 1 did an obvious GFP_KERNEL allocation inside
preempt_disable().

>  This instead.
>     J
> 
>     mm: disable preemption in apply_to_pte_range
>     
>     Lazy mmu mode needs preemption disabled, so if we're apply to
>     init_mm (which doesn't require any pte locks), then explicitly
>     disable preemption.  (Do it unconditionally after checking we've
>     successfully done the allocation to simplify the error handling.)
>     
>     Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index baa999e..b80cc31 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1718,6 +1718,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  
>  	BUG_ON(pmd_huge(*pmd));
>  
> +	preempt_disable();
>  	arch_enter_lazy_mmu_mode();
>  
>  	token = pmd_pgtable(*pmd);
> @@ -1729,6 +1730,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  	} while (pte++, addr += PAGE_SIZE, addr != end);
>  
>  	arch_leave_lazy_mmu_mode();
> +	preempt_enable();
>  
>  	if (mm != &init_mm)
>  		pte_unmap_unlock(pte-1, ptl);
> 

This weakens the apply_to_page_range() utility by newly requiring that
the callback function be callable under preempt_disable() if the target
mm is init_mm.  I guess we can live with that.

It's OK for the two present in-tree callers.  There might of course be
out-of-tree callers which break, but it is unlikely.

The patch should include a comment explaining why there is a random
preempt_disable() in this function.


Why is apply_to_page_range() exported to modules, btw?  I can find no
modules which need it.  Unexporting that function would make the
proposed weakening even less serious.


The patch assumes that
arch_enter_lazy_mmu_mode()/arch_leave_lazy_mmu_mode() must have
preemption disabled for all architectures.  Is this a sensible
assumption?

If so, should we do the preempt_disable/enable within those functions? 
Probably not worth the cost, I guess..

