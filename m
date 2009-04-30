Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbZD3V77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbZD3V77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZD3V7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:59:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:40403 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbZD3V7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:59:50 -0400
Subject: Re: [BUG] 2.6.30-rc3: BUG triggered on some hugepage usages
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Michael Ellerman <michael@ellerman.id.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090430205919.GA24279@csn.ul.ie>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain>
	 <20090424095116.GB14283@csn.ul.ie> <1240586690.12551.31.camel@localhost>
	 <20090430205919.GA24279@csn.ul.ie>
Content-Type: text/plain
Date: Fri, 01 May 2009 07:48:46 +1000
Message-Id: <1241128126.29501.48.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 21:59 +0100, Mel Gorman wrote:

> This patch fixes the problem by not asseting the PTE is locked for VMAs
> backed by huge pages.

Thanks, will apply.

Cheers,
Ben.

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> --- 
>  arch/powerpc/mm/pgtable.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
> index f5c6fd4..ae1d67c 100644
> --- a/arch/powerpc/mm/pgtable.c
> +++ b/arch/powerpc/mm/pgtable.c
> @@ -219,7 +219,8 @@ int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
>  		entry = do_dcache_icache_coherency(entry);
>  	changed = !pte_same(*(ptep), entry);
>  	if (changed) {
> -		assert_pte_locked(vma->vm_mm, address);
> +		if (!(vma->vm_flags & VM_HUGETLB))
> +			assert_pte_locked(vma->vm_mm, address);
>  		__ptep_set_access_flags(ptep, entry);
>  		flush_tlb_page_nohash(vma, address);
>  	}

