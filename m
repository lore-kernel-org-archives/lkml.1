Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYLCAsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYLCAsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYLCAsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:48:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255AbYLCAsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:48:09 -0500
Date: Tue, 2 Dec 2008 16:47:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: dwmw2@infradead.org, jens.axboe@oracle.com, matthew@wil.cx,
       joern@logfs.org, James.Bottomley@HansenPartnership.com,
       djshin90@gmail.com, teheo@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/9] swapfile: change discard pgoff_t to sector_t
Message-Id: <20081202164732.1d6d0997.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0812010028040.10131@blonde.site>
References: <Pine.LNX.4.64.0811252132580.17555@blonde.site>
	<Pine.LNX.4.64.0811252140230.17555@blonde.site>
	<Pine.LNX.4.64.0811252145190.20455@blonde.site>
	<Pine.LNX.4.64.0812010028040.10131@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 00:29:41 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> Change pgoff_t nr_blocks in discard_swap() and discard_swap_cluster() to
> sector_t: given the constraints on swap offsets (in particular, the 5 bits
> of swap type accommodated in the same unsigned long), pgoff_t was actually
> safe as is, but it certainly looked worrying when shifted left.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> To follow 9/9 swapfile-swap-allocation-cycle-if-nonrot.patch
> 
>  mm/swapfile.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- swapfile9/mm/swapfile.c	2008-11-26 12:19:00.000000000 +0000
> +++ swapfile10/mm/swapfile.c	2008-11-28 20:36:44.000000000 +0000
> @@ -96,7 +96,7 @@ static int discard_swap(struct swap_info
>  
>  	list_for_each_entry(se, &si->extent_list, list) {
>  		sector_t start_block = se->start_block << (PAGE_SHIFT - 9);
> -		pgoff_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);
> +		sector_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);

but, but, that didn't change anything?  se->nr_pages must be cast to
sector_t?

>  		if (se->start_page == 0) {
>  			/* Do not discard the swap header page! */
> @@ -133,7 +133,7 @@ static void discard_swap_cluster(struct 
>  		    start_page < se->start_page + se->nr_pages) {
>  			pgoff_t offset = start_page - se->start_page;
>  			sector_t start_block = se->start_block + offset;
> -			pgoff_t nr_blocks = se->nr_pages - offset;
> +			sector_t nr_blocks = se->nr_pages - offset;
>  
>  			if (nr_blocks > nr_pages)
>  				nr_blocks = nr_pages;
