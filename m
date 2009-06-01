Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZFAIFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZFAIFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZFAIFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:05:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53154 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZFAIF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:05:29 -0400
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [rfc][patch] swap: virtual swap readahead
From: Andi Kleen <andi@firstfloor.org>
References: <1243436746-2698-1-git-send-email-hannes@cmpxchg.org>
Date: Mon, 01 Jun 2009 10:05:22 +0200
In-Reply-To: <1243436746-2698-1-git-send-email-hannes@cmpxchg.org> (Johannes Weiner's message of "Wed, 27 May 2009 17:05:46 +0200")
Message-ID: <87zlcscrb1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> writes:
>
> This patch makes swap-in base its readaround window on the virtual
> proximity of pages in the faulting VMA, as an indicator for pages
> needed in the near future, while still taking physical locality of
> swap slots into account.

I think it's a good idea, something that needed fixing in Linux forever.

Now if we can only start swapping out in larger cluster too.

> +		if (swp_type(swp) != swp_type(entry))
> +			continue;
> +		/*
> +		 * Dont move the disk head too far away.  This also
> +		 * throttles readahead while thrashing, where virtual
> +		 * order diverges more and more from physical order.
> +		 */
> +		if (swp_offset(swp) > pmax)
> +			continue;
> +		if (swp_offset(swp) < pmin)
> +			continue;
> +		page = read_swap_cache_async(swp, gfp_mask, vma, pos);

It would be a good idea then to fix r_s_c_a() to pass down the VMA
and use alloc_page_vma() down below, so that NUMA Policy is preserved
over swapin. 

I originally tried this when I did the NUMA policy code, but then Hugh
pointed out it was useless because the prefetched pages are not
necessarily from this VMA anyways. With your virtual readahead it would
make sense again.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
