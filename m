Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXDISpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXDISpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXDISpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:45:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55036 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbXDISpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:45:54 -0400
Date: Mon, 9 Apr 2007 11:45:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
Message-Id: <20070409114545.3858d8f1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704091105550.8331@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
	<20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
	<20070406222336.4dcdd663.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
	<20070407155148.94da92e8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
	<20070407182506.4386dc13.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071825510.32544@schroedinger.engr.sgi.com>
	<20070407184801.b6f3f549.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704091105550.8331@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 11:09:40 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> Add PageTail / PageHead in order to avoid multiple branches when compound 
> pages are checked.
> 
> The patch adds PageTail(page) and PageHead(page) to check if a page is the
> head or the tail of a compound page. This is done by masking the two
> bits describing the state of a compound page and then comparing them. So 
> one comparision and a branch instead of two bit checks and two branches.
> 

OK.  I'm still a bit concerned about bypassing the bitops synchronisation:
barriers, volatile, etc.  We had lengthy ruminations on that a few years
ago, I think when working on free_pages_check().


> @@ -221,12 +215,24 @@ static inline void SetPageUptodate(struc
>  #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
>  
>  /*
> - * Note: PG_tail is an alias of another page flag. The result of PageTail()
> - * is only valid if PageCompound(page) is true.
> + * PG_reclaim is used in combination with PG_compound to mark the
> + * head and tail of a compound page
> + *
> + * PG_compound & PG_reclaim	=> Tail page
> + * PG_compound & ~PG_reclaim	=> Head page
>   */
> -#define PageTail(page)	test_bit(PG_tail, &(page)->flags)
> -#define __SetPageTail(page)	__set_bit(PG_tail, &(page)->flags)
> -#define __ClearPageTail(page)	__clear_bit(PG_tail, &(page)->flags)
> +
> +#define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
> +
> +#define PageTail(page)	((page->flags & PG_head_tail_mask) \
> +				== PG_head_tail_mask)
> +#define __SetPageTail(page)	page->flags |= PG_head_tail_mask
> +#define __ClearPageTail(page)	page->flags ~= PG_head_tail_mask

hm.  The lack of parenthesisation here _might_ be OK, but I haven't
thought it through.

And I'd prefer not to have to, because I know that the do { } while (0)
thing works.  As do static inline functions.

> +#define PageHead(page)	((page->flags & PG_head_tail_mask) \
> +				== (1L << PG_compound))
> +#define __SetPageHead(page)	__SetCompoundPage(page)
> +#define __ClearPageHead(page)	__ClearCompoundPage(page)

You meant __SetPageCompound and __ClearPageCompound.


