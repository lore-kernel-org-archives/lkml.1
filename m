Return-Path: <linux-kernel-owner+w=401wt.eu-S964924AbZLGSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924AbZLGSK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964859AbZLGSK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:10:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964871AbZLGSK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:10:26 -0500
Message-ID: <4B1D4513.1020206@redhat.com>
Date: Mon, 07 Dec 2009 13:10:27 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [early RFC][PATCH 8/7] vmscan: Don't deactivate many touched
 page
References: <20091204173233.5891.A69D9226@jp.fujitsu.com> <20091207203427.E955.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091207203427.E955.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 06:36 AM, KOSAKI Motohiro wrote:
>
> Andrea, Can you please try following patch on your workload?
>
>
>  From a7758c66d36a136d5fbbcf0b042839445f0ca522 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Mon, 7 Dec 2009 18:37:20 +0900
> Subject: [PATCH] [RFC] vmscan: Don't deactivate many touched page
>
> Changelog
>   o from andrea's original patch
>     - Rebase topon my patches.
>     - Use list_cut_position/list_splice_tail pair instead
>       list_del/list_add to make pte scan fairness.
>     - Only use max young threshold when soft_try is true.
>       It avoid wrong OOM sideeffect.
>     - Return SWAP_AGAIN instead successful result if max
>       young threshold exceed. It prevent the pages without clear
>       pte young bit will be deactivated wrongly.
>     - Add to treat ksm page logic

I like the concept and your changes, and really only
have a few small nitpicks :)

First, the VM uses a mix of "referenced", "accessed" and
"young".  We should probably avoid adding "active" to that
mix, and may even want to think about moving to just one
or two terms :)

> +#define MAX_YOUNG_BIT_CLEARED 64
> +/*
> + * if VM pressure is low and the page have too many active mappings, there isn't
> + * any reason to continue clear young bit of other ptes. Otherwise,
> + *  - Makes meaningless cpu wasting, many touched page sholdn't be reclaimed.
> + *  - Makes lots IPI for pte change and it might cause another sadly lock
> + *    contention.
> + */

If VM pressure is low and the page has lots of active users, we only
clear up to MAX_YOUNG_BIT_CLEARED accessed bits at a time.  Clearing
accessed bits takes CPU time, needs TLB invalidate IPIs and could
cause lock contention.  Since a heavily shared page is very likely
to be used again soon, the cost outweighs the benefit of making such
a heavily shared page a candidate for eviction.

> diff --git a/mm/rmap.c b/mm/rmap.c
> index cfda0a0..f4517f3 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -473,6 +473,21 @@ static int wipe_page_reference_anon(struct page *page,
>   		ret = wipe_page_reference_one(page, refctx, vma, address);
>   		if (ret != SWAP_SUCCESS)
>   			break;
> +		if (too_many_young_bit_found(refctx)) {
> +			LIST_HEAD(tmp_list);
> +
> +			/*
> +			 * The scanned ptes move to list tail. it help every ptes
> +			 * on this page will be tested by ptep_clear_young().
> +			 * Otherwise, this shortcut makes unfair thing.
> +			 */
> +			list_cut_position(&tmp_list,
> +					&vma->anon_vma_node,
> +					&anon_vma->head);
> +			list_splice_tail(&tmp_list,&vma->anon_vma_node);
> +			ret = SWAP_AGAIN;
> +			break;
> +		}

I do not understand the unfairness here, since all a page needs
to stay on the active list is >64 referenced PTEs.  It does not
matter which of the PTEs mapping the page were recently referenced.

However, rotating the anon vmas around may help spread out lock
pressure in the VM and help things that way, so the code looks
useful to me.

In short, you can give the next version of this patch my

Reviewed-by: Rik van Riel <riel@redhat.com>

All I have are comment nitpicks :)

-- 
All rights reversed.
