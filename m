Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYLAOxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYLAOxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYLAOxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:53:37 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:33642 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYLAOxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:53:36 -0500
Date: Mon, 1 Dec 2008 08:47:22 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Russ Anderson <rja@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Jones <davej@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/8] badpage: simplify page_alloc flag check+clear
In-Reply-To: <Pine.LNX.4.64.0812010038220.11401@blonde.site>
Message-ID: <Pine.LNX.4.64.0812010843230.15331@quilx.com>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
 <Pine.LNX.4.64.0812010038220.11401@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Hugh Dickins wrote:

>  /*
>   * Flags checked when a page is freed.  Pages being freed should not have
>   * these flags set.  It they are, there is a problem.
>   */
> -#define PAGE_FLAGS_CHECK_AT_FREE (PAGE_FLAGS | 1 << PG_reserved)
> +#define PAGE_FLAGS_CHECK_AT_FREE \
> +	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
> +	 1 << PG_buddy | 1 << PG_writeback | 1 << PG_reserved | \
> +	 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active | \
> +	 __PG_UNEVICTABLE | __PG_MLOCKED)

Rename this to PAGE_FLAGS_CLEAR_WHEN_FREE?

> + * Pages being prepped should not have any flags set.  It they are set,
> + * there has been a kernel bug or struct page corruption.
>   */
> -#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | \
> -		1 << PG_reserved | 1 << PG_dirty | 1 << PG_swapbacked)
> +#define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)

These are all the bits. Can we get rid of this definition?

>  	/*
>  	 * For now, we report if PG_reserved was found set, but do not
>  	 * clear it, and do not free the page.  But we shall soon need
>  	 * to do more, for when the ZERO_PAGE count wraps negative.
>  	 */
> -	return PageReserved(page);
> +	if (PageReserved(page))
> +		return 1;
> +	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
> +		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +	return 0;

The name PAGE_FLAGS_CHECK_AT_PREP is strange. We clear these flags without
message. This is equal to

page->flags &=~PAGE_FLAGS_CHECK_AT_PREP;

You can drop the if...

