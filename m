Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371Ab0A0Wjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab0A0Wjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325Ab0A0Wjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:39:39 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:23846 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756130Ab0A0Wji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:39:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscAAFNPYEtLd/sX/2dsb2JhbAAIgzHFR49egSqCN1gE
X-IronPort-AV: E=Sophos;i="4.49,356,1262581200"; 
   d="scan'208";a="54710300"
Message-ID: <4B60C0A7.7090501@teksavvy.com>
Date: Wed, 27 Jan 2010 17:39:35 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1,
References: <4B5FA147.5040802@teksavvy.com> <20100127120820.GB25750@csn.ul.ie>
In-Reply-To: <20100127120820.GB25750@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Tue, Jan 26, 2010 at 09:13:27PM -0500, Mark Lord wrote:
>> I recently upgraded our 24/7 server from 2.6.31.5 to 2.6.32.5.
>>
>> Now, suddenly the logs are full of "page allocation failure. order:1",
>> and the odd "page allocation failure. order:4" failures.
>>
>> Wow.  WTF happened in 2.6.32 ???
>>
> 
> There was one bug related to MIGRATE_RESERVE that might be affecting
> you. It reported as impacting swap-orientated workloads but it could
> easily affect drivers that depend on high-order atomic allocations.
> Unfortunately, the fix is not signed-off yet but I expect it to make its
> way towards mainline when it is.
> 
> Here is the patch with a slightly-altered changelog. Can you test if it
> makes a difference please?
..

We don't like to reboot our 24/7 server very often,
and certainly not for debugging buggy kernels.

It's rock solid again with 2.6.31.12 on it now.

The defining characteristic of that machine, is that it has only 512MB
of physical RAM.  So perhaps I'll try booting a different machine here
with mem=512M and see how that behaves.  If the problem shows up on that,
then I'll try the patch.

Thanks.


> --- 2.6.33-rc1/mm/page_alloc.c	2009-12-18 11:42:54.000000000 +0000
> +++ linux/mm/page_alloc.c	2009-12-20 19:10:50.000000000 +0000
> @@ -555,8 +555,9 @@ static void free_pcppages_bulk(struct zo
>  			page = list_entry(list->prev, struct page, lru);
>  			/* must delete as __free_one_page list manipulates */
>  			list_del(&page->lru);
> -			__free_one_page(page, zone, 0, migratetype);
> -			trace_mm_page_pcpu_drain(page, 0, migratetype);
> +			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
> +			__free_one_page(page, zone, 0, page_private(page));
> +			trace_mm_page_pcpu_drain(page, 0, page_private(page));
>  		} while (--count && --batch_free && !list_empty(list));
>  	}
>  	spin_unlock(&zone->lock);

