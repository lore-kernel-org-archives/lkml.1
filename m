Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbXLZDsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbXLZDsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 22:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXLZDsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 22:48:41 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43824 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXLZDsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 22:48:39 -0500
Date: Wed, 26 Dec 2007 03:47:53 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] xip: fix get_zeroed_page with __GFP_HIGHMEM
In-Reply-To: <20071225132126.GA4800@APFDCB5C>
Message-ID: <Pine.LNX.4.64.0712260316140.6684@blonde.wat.veritas.com>
References: <20071225132126.GA4800@APFDCB5C>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Dec 2007, Akinobu Mita wrote:
> The use of get_zeroed_page() with __GFP_HIGHMEM is invalid.
> Use alloc_page() with __GFP_ZERO instead of invalid get_zeroed_page().
> 
> (This patch is only compile tested)
> 
> Cc: Carsten Otte <cotte@de.ibm.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Good find!  You got me very worried, how this escaped testing before.
Presumed explanation: it hasn't been needed beyond s390, which has no
CONFIG_HIGHMEM; and it has never been tested with CONFIG_DEBUG_VM on.

Acked-by: Hugh Dickins <hugh@veritas.com>

But I haven't tested it either: let's wait for Carsten to report.
I believe Nick has changes on the way which will make it possible for
ordinary mortals to test XIP: here's a good argument to bring them on.

May I cross-reference my "prep_zero_page: remove bogus BUG_ON"
09f345da758fca1222b0971b65b2fddbdf78bb83 in 2.6.24-rc: that bogus
(actually VM_)BUG_ON would have stood in the way too, so there's
no point in backporting this without that.  But if only non-HIGHMEM
architectures can have been using XIP, a backport is not essential.

Hugh

p.s. Nick's ZERO_PAGE changes, in 2.6.24-rc, actually cancel the need
for a special xip_sparse_page distinct from ZERO_PAGE.  But let's not
become dependent on those: keep this doing it the way it does now.

> 
> ---
>  mm/filemap_xip.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: 2.6-git/mm/filemap_xip.c
> ===================================================================
> --- 2.6-git.orig/mm/filemap_xip.c
> +++ 2.6-git/mm/filemap_xip.c
> @@ -25,14 +25,15 @@ static struct page *__xip_sparse_page;
>  static struct page *xip_sparse_page(void)
>  {
>  	if (!__xip_sparse_page) {
> -		unsigned long zeroes = get_zeroed_page(GFP_HIGHUSER);
> -		if (zeroes) {
> +		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
> +
> +		if (page) {
>  			static DEFINE_SPINLOCK(xip_alloc_lock);
>  			spin_lock(&xip_alloc_lock);
>  			if (!__xip_sparse_page)
> -				__xip_sparse_page = virt_to_page(zeroes);
> +				__xip_sparse_page = page;
>  			else
> -				free_page(zeroes);
> +				__free_page(page);
>  			spin_unlock(&xip_alloc_lock);
>  		}
>  	}
