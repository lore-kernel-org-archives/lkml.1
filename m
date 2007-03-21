Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbXCUESi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbXCUESi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 00:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933917AbXCUESi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 00:18:38 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:48692 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933901AbXCUESh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 00:18:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=4ecsWWOHHIN1Gc1rHmjm3BprQOgUEtH1EckRjShvYrZJJ56uH7ZFYGSSyagBcu/OUTtEgpssl3Pg6ylS/+1yVMwlUrqjh1jt6sgTLTAs4slreCurUMiyr1x2dUcp7fPBmmp0BJVq/0c0WvRtAP96pH3Ghf3/CwyrYsUCz2XTFOU=  ;
X-YMail-OSG: d49Q7XgVM1k4Tk5jkBaz.SvN_CallbOtJ5F5buZEMLWOS.ejc4BtII8pn_Nu2reFWk94ojr1f0yMGvdG5I_NY79nfdm_zcMsng00ZVxsj8KqyC1B.6c.EKppQP3ej9Y7LukC2q2fmnsOKxcy9X9u5RrE3w--
Message-ID: <4600B216.3010505@yahoo.com.au>
Date: Wed, 21 Mar 2007 15:18:30 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Adam Litke <agl@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated
 helper macros.
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <20070319200513.17168.52238.stgit@localhost.localdomain>
In-Reply-To: <20070319200513.17168.52238.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Litke wrote:
> Signed-off-by: Adam Litke <agl@us.ibm.com>
> ---
> 
>  include/linux/mm.h |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 60e0e4a..7089323 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -98,6 +98,7 @@ struct vm_area_struct {
>  
>  	/* Function pointers to deal with this struct. */
>  	struct vm_operations_struct * vm_ops;
> +	const struct pagetable_operations_struct * pagetable_ops;
>  
>  	/* Information about our backing store: */
>  	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE

Can you remind me why this isn't in vm_ops?

Also, it is going to be hugepage-only, isn't it? So should the naming be
changed to reflect that? And #ifdef it...

> @@ -218,6 +219,30 @@ struct vm_operations_struct {
>  };
>  
>  struct mmu_gather;
> +
> +struct pagetable_operations_struct {
> +	int (*fault)(struct mm_struct *mm,
> +		struct vm_area_struct *vma,
> +		unsigned long address, int write_access);

I got dibs on fault ;)

My callback is a sanitised one that basically abstracts the details of the
virtual memory mapping away, so it is usable by drivers and filesystems.

You actually want to bypass the normal fault handling because it doesn't
know how to deal with your virtual memory mapping. Hmm, the best suggestion
I can come up with is handle_mm_fault... unless you can think of a better
name for me to use.

> +	int (*copy_vma)(struct mm_struct *dst, struct mm_struct *src,
> +		struct vm_area_struct *vma);
> +	int (*pin_pages)(struct mm_struct *mm, struct vm_area_struct *vma,
> +		struct page **pages, struct vm_area_struct **vmas,
> +		unsigned long *position, int *length, int i);
> +	void (*change_protection)(struct vm_area_struct *vma,
> +		unsigned long address, unsigned long end, pgprot_t newprot);
> +	unsigned long (*unmap_page_range)(struct vm_area_struct *vma,
> +		unsigned long address, unsigned long end, long *zap_work);
> +	void (*free_pgtable_range)(struct mmu_gather **tlb,
> +		unsigned long addr, unsigned long end,
> +		unsigned long floor, unsigned long ceiling);
> +};
> +
> +#define has_pt_op(vma, op) \
> +	((vma)->pagetable_ops && (vma)->pagetable_ops->op)
> +#define pt_op(vma, call) \
> +	((vma)->pagetable_ops->call)
> +
>  struct inode;
>  
>  #define page_private(page)		((page)->private)
> 
> --

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
