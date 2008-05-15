Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYEOGfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYEOGfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYEOGe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:34:56 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:42771 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYEOGez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oOBenrQaCALtt87ExDTRXyLYBffGPro1tCMlzxoh58IXad2YBo+GlREN3V8FOKPs8IaGIaJCUz/6Gk91Cannu0AxvJJCsjZ3TuGbbWfIUhuz4rCs7d2BsON6JPUwRdMFDfeHl8U5gR7J6bCje69wwvDmqlo6ZvTsdu2tHqgGdIA=
Message-ID: <28c262360805142334y4740530co36ecd5c44752f1@mail.gmail.com>
Date: Thu, 15 May 2008 15:34:51 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH -mm 09/15] add some sanity checks to get_scan_ratio
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080428181852.961869151@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428181835.502876582@redhat.com>
	 <20080428181852.961869151@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1256,7 +1285,7 @@ static unsigned long shrink_zone(int pri
>        }
>
>        while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
> -                                                nr[LRU_INACTIVE_FILE]) {
> +                                       nr[LRU_INACTIVE_FILE]) {
>                for_each_lru(l) {
>                        if (nr[l]) {
>                                nr_to_scan = min(nr[l],
> @@ -1269,6 +1298,14 @@ static unsigned long shrink_zone(int pri
>                }
>        }
>
> +       /*
> +        * Even if we did not try to evict anon pages at all, we want to
> +        * rebalance the anon lru active/inactive ratio.
> +        */
> +       if (scan_global_lru(sc) && inactive_anon_low(zone))
> +               shrink_list(NR_ACTIVE_ANON, SWAP_CLUSTER_MAX, zone, sc,
> +                                                               priority);
> +
>        throttle_vm_writeout(sc->gfp_mask);
>        return nr_reclaimed;
>  }

I think It's rather typo error.
If it is error, It will cause wrong algorithm.

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1375,7 +1375,7 @@ static unsigned long shrink_zone(int priority, struct zon
         * rebalance the anon lru active/inactive ratio.
         */
        if (scan_global_lru(sc) && inactive_anon_low(zone))
-               shrink_list(NR_ACTIVE_ANON, SWAP_CLUSTER_MAX, zone, sc,
+               shrink_list(LRU_ACTIVE_ANON, SWAP_CLUSTER_MAX, zone, sc,
                                                                priority);

        throttle_vm_writeout(sc->gfp_mask);



shrink_list called twice about LRU_ACTIVE_ANON if
(nr[LRU_INACTIVE_ANON] != 0 && inactive_anon_low(zone))
Is it your intention ? You want to put the pressure twice active anon
list on above condition ?

If your intention is right, I think following code about readability
is good than old.

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1375,8 +1375,7 @@ static unsigned long shrink_zone(int priority, struct zon
         * rebalance the anon lru active/inactive ratio.
         */
        if (scan_global_lru(sc) && inactive_anon_low(zone))
-               shrink_list(NR_ACTIVE_ANON, SWAP_CLUSTER_MAX, zone, sc,
-                                                               priority);
+               shrink_inactive_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);

        throttle_vm_writeout(sc->gfp_mask);
        return nr_reclaimed;


Gmail client will mangle my patch. This is just purpose of review.

-- 
Kinds regards,
MinChan Kim
