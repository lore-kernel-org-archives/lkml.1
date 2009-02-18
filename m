Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbZBRRVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbZBRRVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZBRRVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:21:34 -0500
Received: from cmpxchg.org ([85.214.51.133]:56590 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbZBRRVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:21:34 -0500
Date: Wed, 18 Feb 2009 18:23:37 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Patch] mm: fix null pointer dereference in vm_normal_page()
Message-ID: <20090218172337.GA1767@cmpxchg.org>
References: <20090218125649.GU7272@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090218125649.GU7272@hack.private>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 08:56:49PM +0800, Américo Wang wrote:
> 
> One usage of vm_normal_page() is:
> 
>     struct page *page = vm_normal_page(gate_vma, start, *pte);
> 
> where gate_vma is returned by get_gate_vma() which can be NULL.
> So let vm_normal_page return NULL when vma is NULL.

I assume you refer to __get_user_pages()...?

This function checks whether the address is in the gate area and only
iff so requests the VMA representing it.

If you really did see an oops that is worked-around by your patch,
then the in_gate_area()/get_gate_vma() in question are broken.

> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>

  Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

> ---
> diff --git a/mm/memory.c b/mm/memory.c
> index baa999e..e428aa6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -493,6 +493,9 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>  {
>  	unsigned long pfn = pte_pfn(pte);
>  
> +	if (!vma)
> +		return NULL;
> +
>  	if (HAVE_PTE_SPECIAL) {
>  		if (likely(!pte_special(pte)))
>  			goto check_pfn;
> 
> 
