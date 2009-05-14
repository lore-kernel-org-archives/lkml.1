Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbZENO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbZENO1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZENO1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:27:00 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:13091 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZENO1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qBUyxHAFEzgC1OUz8iOLb2PAwM4xXYH/XgFFzmKhzygGrpiH4zb4HB0iGIrIk+t7V7
         dRs+2OD/suZLuF6Yfw2XJ/Swlwc7lDGmSbCewBKL259cK/CgiY8kMzfBBZYf73kBroBK
         CdMvwuKZtDWdU6wpZssrk1a9MXz7/vUXpye0w=
MIME-Version: 1.0
In-Reply-To: <20090514231555.f52c81eb.minchan.kim@gmail.com>
References: <20090514231555.f52c81eb.minchan.kim@gmail.com>
Date: Thu, 14 May 2009 23:27:00 +0900
X-Google-Sender-Auth: 3b6441b5c0269e1b
Message-ID: <2f11576a0905140727j5ba02b07t94826f57dd99839c@mail.gmail.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case 
	of no swap space V3
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  mm/vmscan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2f9d555..621708f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1577,7 +1577,7 @@ static void shrink_zone(int priority, struct zone *zone,
>         * Even if we did not try to evict anon pages at all, we want to
>         * rebalance the anon lru active/inactive ratio.
>         */
> -       if (inactive_anon_is_low(zone, sc))
> +       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
>                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);


       if (nr_swap_pages > 0 && inactive_anon_is_low(zone, sc))

is better?
compiler can't swap evaluate order around &&.

then,

    if ( 0 && inactive_anon_is_low(zone, sc))

and

    if (inactive_anon_is_low(zone, sc) && 0)

are different.
