Return-Path: <linux-kernel-owner+w=401wt.eu-S933506AbXCZFyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbXCZFyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 01:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXCZFyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 01:54:07 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:63842 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbXCZFyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 01:54:04 -0400
X-AuditID: d80ac287-976cabb000000c42-09-46075ff93611 
Date: Mon, 26 Mar 2007 06:53:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Zachary Amsden <zach@vmware.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 1/2] i386: add ptep_test_and_clear_{dirty,young}
In-Reply-To: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0703260631150.15998@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 26 Mar 2007 05:54:01.0260 (UTC) FILETIME=[272A0EC0:01C76F6B]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007, David Rientjes wrote:
> Add ptep_test_and_clear_{dirty,young} to i386.  They advertise that they
> have it and there is at least one place where it needs to be called
> without the page table lock: to clear the accessed bit on write to

Without the page table lock??

> /proc/pid/clear_refs.
> 
> ptep_clear_flush_{dirty,young} are updated to use the new functions.  The
> overall net effect to current users of ptep_clear_flush_{dirty,young} is
> that we introduce an additional branch.

We need to Cc Zach on this: git blame indicates it was he who replaced
i386's ptep_test_and_clear_{dirty,young} by that "We don't actually
have these" comment - it looks a bit as if what you want to do might
violate the assumptions he wants to make, but I don't grasp it.

Hugh

> 
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/asm-i386/pgtable.h |   25 +++++++++++++++++--------
>  1 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/include/asm-i386/pgtable.h b/include/asm-i386/pgtable.h
> --- a/include/asm-i386/pgtable.h
> +++ b/include/asm-i386/pgtable.h
> @@ -283,12 +283,23 @@ do {									\
>  	}								\
>  } while (0)
>  
> -/*
> - * We don't actually have these, but we want to advertise them so that
> - * we can encompass the flush here.
> - */
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
> +static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
> +					    unsigned long addr, pte_t *ptep)
> +{
> +	if (!pte_dirty(*ptep))
> +		return 0;
> +	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
> +}
> +
>  #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
> +static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
> +					    unsigned long addr, pte_t *ptep)
> +{
> +	if (!pte_young(*ptep))
> +		return 0;
> +	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
> +}
>  
>  /*
>   * Rules for using ptep_establish: the pte MUST be a user pte, and
> @@ -305,9 +316,8 @@ do {									\
>  #define ptep_clear_flush_dirty(vma, address, ptep)			\
>  ({									\
>  	int __dirty;							\
> -	__dirty = pte_dirty(*(ptep));					\
> +	__dirty = ptep_test_and_clear_dirty((vma), (address), (ptep));	\
>  	if (__dirty) {							\
> -		clear_bit(_PAGE_BIT_DIRTY, &(ptep)->pte_low);		\
>  		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
>  		flush_tlb_page(vma, address);				\
>  	}								\
> @@ -318,9 +328,8 @@ do {									\
>  #define ptep_clear_flush_young(vma, address, ptep)			\
>  ({									\
>  	int __young;							\
> -	__young = pte_young(*(ptep));					\
> +	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
>  	if (__young) {							\
> -		clear_bit(_PAGE_BIT_ACCESSED, &(ptep)->pte_low);	\
>  		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
>  		flush_tlb_page(vma, address);				\
>  	}								\
