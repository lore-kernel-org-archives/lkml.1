Return-Path: <linux-kernel-owner+w=401wt.eu-S965463AbXAXDM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463AbXAXDM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 22:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965634AbXAXDM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 22:12:29 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:21555 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965463AbXAXDM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 22:12:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=dwDk7G1nH/gSs5DbMjzqTxpuO457JhulUjM9JvlN9gQ1t2NnfJgpMHpqB+/NkTrYK62mMGlta38XG0tnM5S+C8K4kNRj6l0O6fBJXiCAKL+h416J+YrWKQJscXJnW2hjI5jOQq7FMkSMGnghxOHGp2Bx7tTjSP8Bl3XVoPT1Nng=  ;
X-YMail-OSG: iACuhogVM1kTPCzG7M9y9ZQL6gEvb1H6pylWLOzbYVKDUsRySKwKd.jFAeZnnMXzJZwvK2ktmg--
Message-ID: <45B6CE8C.8010807@yahoo.com.au>
Date: Wed, 24 Jan 2007 14:12:12 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Paul Davies <pauld@cse.unsw.edu.au>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Page Table cleanup patch
References: <20070124023828.11302.51100.sendpatchset@weill.orchestra.cse.unsw.EDU.AU>
In-Reply-To: <20070124023828.11302.51100.sendpatchset@weill.orchestra.cse.unsw.EDU.AU>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Davies wrote:
> This patch is a proposed cleanup of the current page table organisation.
> Such a cleanup would be a logical first step towards introducing at least
> a partial clean page table interface, geared towards providing enhanced 
> virtualization oportunities for x86.  It is also a common sense cleanup 
> in its own right.
> 
>  * Creates mlpt.c to hold the page table implementation currently held 
>    in memory.c.
>  * Adjust Makefile 
>  * Move implementation dependent page table code out of 
>    include/linux/mm.h into include/linux/mlpt-mm.h
>  * Move implementation dependent page table code out of 
>    include/asm-generic/pgtable.h to include/asm-generic/pgtable-mlpt.h
> 
> mlpt stands from multi level page table.

Hi Paul,

I'm not sure that I see the point of this patch alone, as there is still
all the mlpt implementation details in all the page table walkers. Or
did you have a scheme to change implementations somehow just using the
p*d_addr_next?

> -#ifndef __PAGETABLE_PUD_FOLDED
> -/*
> - * Allocate page upper directory.
> - * We've already handled the fast-path in-line.
> - */
> -int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
> -{
> -	pud_t *new = pud_alloc_one(mm, address);
> -	if (!new)
> -		return -ENOMEM;
> -
> -	spin_lock(&mm->page_table_lock);
> -	if (pgd_present(*pgd))		/* Another has populated it */
> -		pud_free(new);
> -	else
> -		pgd_populate(mm, pgd, new);
> -	spin_unlock(&mm->page_table_lock);
> -	return 0;
> -}
> -#else
> -/* Workaround for gcc 2.96 */
> -int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
> -{
> -	return 0;
> -}
> -#endif /* __PAGETABLE_PUD_FOLDED */

...

> -/* Workaround for gcc 2.96 */
> -int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
> -{
> -	return 0;
> -}
> -#endif /* __PAGETABLE_PMD_FOLDED */

Hmm, we're gcc-3.2 minimum now -- let's get rid of that crud?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
