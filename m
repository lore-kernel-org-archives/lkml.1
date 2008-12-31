Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYLaEy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYLaEy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 23:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYLaEyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 23:54:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:28092 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYLaEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 23:54:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=N6kbvSlMrqJwQ8vdz62OGIzZNZtK1kbMqN7At4Mf5fNmPLu73FUZ/nrBp0fVXr4F+M
         13gaVAwMQc3pwANUDvQ/dJMORcksjVCbDHGRHPfk44HaatlC9910UORqK/gy6zKow7Wj
         XWmepapSw+dJocfUBRtdVVWgnYqZ7d9AcxM9g=
Message-ID: <2f11576a0812302054rd26d8bcw6a113b3abefe8965@mail.gmail.com>
Date: Wed, 31 Dec 2008 13:54:17 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: stop kswapd's infinite loop at high order allocation
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "wassim dagash" <wassim.dagash@gmail.com>
In-Reply-To: <20081230185919.GA17725@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081230195006.1286.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081230185919.GA17725@csn.ul.ie>
X-Google-Sender-Auth: 3652fe99e6725d32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

thank you for reviewing.

>> ==
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Subject: [PATCH] mm: kswapd stop infinite loop at high order allocation
>>
>> Wassim Dagash reported following kswapd infinite loop problem.
>>
>>   kswapd runs in some infinite loop trying to swap until order 10 of zone
>>   highmem is OK, While zone higmem (as I understand) has nothing to do
>>   with contiguous memory (cause there is no 1-1 mapping) which means
>>   kswapd will continue to try to balance order 10 of zone highmem
>>   forever (or until someone release a very large chunk of highmem).
>>
>> He proposed remove contenious checking on highmem at all.
>> However hugepage on highmem need contenious highmem page.
>>
>
> I'm lacking the original problem report, but contiguous order-10 pages are
> indeed required for hugepages in highmem and reclaiming for them should not
> be totally disabled at any point. While no 1-1 mapping exists for the kernel,
> contiguity is still required.

correct.
but that's ok.

my patch only change corner case bahavior and only disable high-order
when priority==0. typical hugepage reclaim don't need and don't reach
priority==0.

and sorry. I agree with my "2nd loop"  word of the patch comment is a
bit misleading.


> kswapd gets a sc.order when it is known there is a process trying to get
> high-order pages so it can reclaim at that order in an attempt to prevent
> future direct reclaim at a high-order. Your patch does not appear to depend on
> GFP_KERNEL at all so I found the comment misleading. Furthermore, asking it to
> loop again at order-0 means it may scan and reclaim more memory unnecessarily
> seeing as all_zones_ok was calculated based on a high-order value, not order-0.

Yup. my patch doesn't depend on GFP_KERNEL.

but, Why order-0 means it may scan more memory unnecessary?
all_zones_ok() is calculated by zone_watermark_ok() and zone_watermark_ok()
depend on order argument. and my patch set order variable to 0 too.


> While constantly looping trying to balance for high-orders is indeed bad,
> I'm unconvinced this is the correct change. As we have already gone through
> a priorities and scanned everything at the high-order, would it not make
> more sense to do just give up with something like the following?
>
>       /*
>        * If zones are still not balanced, loop again and continue attempting
>        * to rebalance the system. For high-order allocations, fragmentation
>        * can prevent the zones being rebalanced no matter how hard kswapd
>        * works, particularly on systems with little or no swap. For costly
>        * orders, just give up and assume interested processes will either
>        * direct reclaim or wake up kswapd as necessary.
>        */
>        if (!all_zones_ok && sc.order <= PAGE_ALLOC_COSTLY_ORDER) {
>                cond_resched();
>
>                try_to_freeze();
>
>                goto loop_again;
>        }
>
> I used PAGE_ALLOC_COSTLY_ORDER instead of sc.order == 0 because we are
> expected to support allocations up to that order in a fairly reliable fashion.

my comment is bellow.


> =============
> From: Mel Gorman <mel@csn.ul.ie>
> Subject: [PATCH] mm: stop kswapd's infinite loop at high order allocation
>
>  kswapd runs in some infinite loop trying to swap until order 10 of zone
>  highmem is OK.... kswapd will continue to try to balance order 10 of zone
>  highmem forever (or until someone release a very large chunk of highmem).
>
> For costly high-order allocations, the system may never be balanced due to
> fragmentation but kswapd should not infinitely loop as a result. The
> following patch lets kswapd stop reclaiming in the event it cannot
> balance zones and the order is high-order.
>
> Reported-by: wassim dagash <wassim.dagash@gmail.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 62e7f62..03ed9a0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1867,7 +1867,16 @@ out:
>
>                zone->prev_priority = temp_priority[i];
>        }
> -       if (!all_zones_ok) {
> +
> +       /*
> +        * If zones are still not balanced, loop again and continue attempting
> +        * to rebalance the system. For high-order allocations, fragmentation
> +        * can prevent the zones being rebalanced no matter how hard kswapd
> +        * works, particularly on systems with little or no swap. For costly
> +        * orders, just give up and assume interested processes will either
> +        * direct reclaim or wake up kswapd as necessary.
> +        */
> +       if (!all_zones_ok && sc.order <= PAGE_ALLOC_COSTLY_ORDER) {
>                cond_resched();
>
>                try_to_freeze();

this patch seems no good.
kswapd come this point every SWAP_CLUSTER_MAX reclaimed because to avoid
unnecessary priority variable decreasing.
then "nr_reclaimed >= SWAP_CLUSTER_MAX" indicate kswapd need reclaim more.

kswapd purpose is "reclaim until pages_high", not reclaim
SWAP_CLUSTER_MAX pages.

if your patch applied and kswapd start to reclaim for hugepage, kswapd
exit balance_pgdat() function after to reclaim only 32 pages
(SWAP_CLUSTER_MAX).

In the other hand, "nr_reclaimed < SWAP_CLUSTER_MAX" mean kswapd can't
reclaim enough
page although priority == 0.
in this case, retry is worthless.

sorting out again.
"goto loop_again" reaching happend by two case.

1. kswapd reclaimed SWAP_CLUSTER_MAX pages.
    at that time, kswapd reset priority variable to prevent
unnecessary priority decreasing.
    I don't hope this behavior change.
2. kswapd scanned until priority==0.
    this case is debatable. my patch reset any order to 0. but
following code is also considerable to me. (sorry for tab corrupted,
current my mail environment is very poor)


code-A:
       if (!all_zones_ok) {
              if ((nr_reclaimed >= SWAP_CLUSTER_MAX) ||
                 (sc.order <= PAGE_ALLOC_COSTLY_ORDER)) {
                          cond_resched();
                           try_to_freeze();
                           goto loop_again;
                }
       }

or

code-B:
       if (!all_zones_ok) {
              cond_resched();
               try_to_freeze();

              if (nr_reclaimed >= SWAP_CLUSTER_MAX)
                           goto loop_again;

              if (sc.order <= PAGE_ALLOC_COSTLY_ORDER)) {
                           order = sc.order = 0;
                           goto loop_again;
              }
       }


However, I still like my original proposal because ..
  - code-A forget to order-1 (for stack) allocation also can cause
infinite loop.
  - code-B doesn't simpler than my original proposal.

What do you think it?
