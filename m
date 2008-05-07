Return-Path: <linux-kernel-owner+w=401wt.eu-S1763715AbYEGV0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763715AbYEGV0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYEGV0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:26:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYEGV0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:26:30 -0400
Date: Wed, 7 May 2008 14:25:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       tonyb@cybernetics.com, mika.penttila@kolumbus.fi
Subject: Re: [PATCH] more ZERO_PAGE handling in follow_page()
Message-Id: <20080507142539.758d30f6.akpm@linux-foundation.org>
In-Reply-To: <20080507163643.d4da0ed0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080507163643.d4da0ed0.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 16:36:43 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Rewrote the description of patch. (no changes in the logic.)
> 
> Thank you for all help.
> -Kame
> ==
> follow_page() is called from get_user_pages(), which returns specified user page.
> follow_page() can return 1) a page or 2) NULL or 3)ZERO_PAGE.
> If NULL, handle_mm_fault() is called.
> 
> Now, follow_page() to unused pte returns NULL if page table exists. As a result
> get_user_pages() calls handle_mm_fault() and allocate new memory.
> This behavior increases memory consumption at coredump, which does
> read-once-but-never-written page fault.
> By returning ZERO_PAGE() against READ/ANON request, we can avoid it.
> 
> (Because exec's arguments copy needs to call handle_mm_fault at WRITE/ANON
>  request, we just handle READ/ANON case here.)
> 
> Change log:
>   - Rewrote patch description and Added comments.
>   - fixed to check pte_present()/pte_none() in proper way.

So... how serious is the problem which we're fixing here?

I can see that if one is core-dumping large sparse address spaces this
could improve things a lot, but please help us understand the implications
so we can decide whether we need this in 2.6.26, thanks.


> Index: linux-2.6.25/mm/memory.c
> ===================================================================
> --- linux-2.6.25.orig/mm/memory.c
> +++ linux-2.6.25/mm/memory.c
> @@ -926,15 +926,15 @@ struct page *follow_page(struct vm_area_
>  	page = NULL;
>  	pgd = pgd_offset(mm, address);
>  	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
> -		goto no_page_table;
> +		goto null_or_zeropage;
>  
>  	pud = pud_offset(pgd, address);
>  	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
> -		goto no_page_table;
> +		goto null_or_zeropage;
>  	
>  	pmd = pmd_offset(pud, address);
>  	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))

The mainline kernel does not have " || unlikely(pmd_bad(*pmd))" here. 
That got changed yesterday by

commit aeed5fce37196e09b4dac3a1c00d8b7122e040ce
Author: Hugh Dickins <hugh@veritas.com>
Date:   Tue May 6 20:49:23 2008 +0100

    x86: fix PAE pmd_bad bootup warning

So please confirm that the patch which I merged is still OK (I'd be
surprised if it isn't...)

