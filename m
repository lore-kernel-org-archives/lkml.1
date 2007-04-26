Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbXDZHyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbXDZHyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXDZHyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:54:04 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:27417 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933340AbXDZHyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:54:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=SPnju7ZbS+IFOdT7FQZXG5uejrtUrOOlOmyecOmY5V1s0kvUzn56fJ823IlxKm/1BFALyckpSmxpixxVXSQCdy0QY+jeEuN+5hrU5/Hj63M1I6qem31MpysSfMCpl1KpqtM2JGsk8jrRkb8aQRkABBy29l4hNLAnxaTR+96uJro=  ;
X-YMail-OSG: 73C_B6sVM1ldlNT_U5UQ8I17KvGEXGUIzCQ5neWiGUZWLfMLvFotxE17WvVPDsyynjiwE33uEg--
Message-ID: <46305A8D.2080003@yahoo.com.au>
Date: Thu, 26 Apr 2007 17:53:49 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>, Mike Stroyan <mike.stroyan@hp.com>,
       "Luck, Tony" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <20070425205548.fd51b301.akpm@linux-foundation.org>
In-Reply-To: <20070425205548.fd51b301.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had a couple of questions which I'm hoping someone would be kind
enough to explain :)

Andrew Morton wrote:
> guys, aplication crashes on million-dollar machines aren't nice.  Please review carefully
> and urgently?
> 
> 
> Begin forwarded message:
> 
> Date: Wed, 25 Apr 2007 18:16:15 -0600
> From: Mike Stroyan <mike.stroyan@hp.com>
> To: "Luck, Tony" <tony.luck@intel.com>
> Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: [PATCH] ia64: race flushing icache in do_no_page path
> 
> 
>   This is a very similar problem to a copy-on-write cache flushing problem
> that Tony Luck fixed in July 2006.  In this case the do_no_page function
> handles a fault in an executable or library that is mmapped from an
> NFS file system.  The code is copied into a newly reallocated page.
> The lazy_mmu_prot_update() function should be used to flush old entries
> from the icache for that page on ia64 processors.  But that call is made
> after a set_pte_at call that makes the page accessible to other threads
> executing the same code.  This was seen to cause application crashes
> when an OpenMP application ran many threads calling same functions at
> the same time.  The first thread to reach a page starts to fault in the
> new code.  One of the other threads overtakes the first and executes old
> data from the icache.  That could result in bad instructions.  It is more
> obvious when an old cache line contains prefetched non-instruction bits
> that result in an illegal instruction trap.

I wonder how this is different to all the other code which calls
lazy_mmu_prot_update() after set_pte_at(). do_swap_page, for example,
_could_ fault in executable code, couldn't it?

It is because do_swap_page uses flush_icache_page()? So why doesn't
the flush_icache_page() work in do_no_page as well? (It seems to look
like a superset of lazy_mmu_prot_update on ia64?!?).

And while we're looking at flush_icache_page, why is there none in
do_wp_page (I admit, I'm not really up to scratch on d/i cache aliasing
handling, but cachetlb.txt seems to suggest that cow_user_page fits the
description). That is, if we're already trying to cover our butts wrt
SMC, then do_wp_page _could_ be cow'ing executable code, couldn't it?

And for that matter, I admit I don't understand how the icache flushing
can be done lazily, only at change-protection time. Why is any
flush_dcache_page() site not a problem for an _existing_ executable pte
wrt d/i cache aliases?

BTW. while I'm ranting, I hope all this stuff has gone so complex for a
reason, and that being that the alternative simpler approach of more
flushes, less lazy, less complex, less buggy was tested and found to be
noticably slower... :)



> 
>   The problem has only been seen on montecito processors which have
> separate level 2 icache and dcache.  This dcache to icache coherency
> problem is more likely to occur there because of the much larger level
> 2 icache.  I suspect that the non-NFS case is working because direct
> DMA into the new page is making the instruction cache coherent.  Any
> file system that uses a non-DMA copy into the text page could show the
> same problem.
> 
> Signed-off-by: Mike Stroyan <mike.stroyan@hp.com>
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index e7066e7..50c8848 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2291,6 +2291,7 @@ retry:
>  		entry = mk_pte(new_page, vma->vm_page_prot);
>  		if (write_access)
>  			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> +		lazy_mmu_prot_update(entry);
>  		set_pte_at(mm, address, page_table, entry);
>  		if (anon) {
>  			inc_mm_counter(mm, anon_rss);
> @@ -2312,7 +2313,6 @@ retry:
>  
>  	/* no need to invalidate: a not-present page shouldn't be cached */
>  	update_mmu_cache(vma, address, entry);
> -	lazy_mmu_prot_update(entry);
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
>  	if (dirty_page) {
> 


-- 
SUSE Labs, Novell Inc.
