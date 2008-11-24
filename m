Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbYKXTMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbYKXTMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYKXTMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:12:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:28536 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYKXTMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:12:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=FPGK2ACtvgDQp0DFU2HJDEcyHOtKDmJ+C3GxK99DIdOHBzgXSalWYqlLzy2snIgju4
         Hmms9xl/LSuixSig7mBiFuHkQ4WHpk6ChEkbwYaKu9VW0mTOU7Sg6pTzFE7zzjeqfltF
         ue0rX36S79aZRy+7pFFXVHdLyFimtkz0IFgk8=
Message-ID: <2f11576a0811241112p494b28a6p720da1d60ac3438c@mail.gmail.com>
Date: Tue, 25 Nov 2008 04:12:12 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <49283A05.1060009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081116163915.F208.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081115235410.2d2c76de.akpm@linux-foundation.org>
	 <20081122191258.26B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <49283A05.1060009@redhat.com>
X-Google-Sender-Auth: 996de2a86a553aa2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Rik, sorry, I nak current your patch. because it don't fix old akpm issue.
>
> You are right.  We do need to keep pressure between zones
> equivalent to the size of the zones (or more precisely, to
> the number of pages the zones have on their LRU lists).

Oh, sorry.
you are right. but I talked about reverse thing.

1. shrink_zones() doesn't have any shortcut exiting way.
    it always call all zone's shrink_zone()
2. balance_pgdat also doesn't have shortcut.

simple shrink_zone() shortcut and lite memory pressure cause following
bad scenario.

1. reclaim 32 page from ZONE_HIGHMEM
2. reclaim 32 page from ZONE_NORMAL
3. reclaim 32 page from ZONE_DMA
4. exit reclaim
5. another task call page alloc and it cause try_to_free_pages()
6. reclaim 32 page from ZONE_HIGHMEM
7. reclaim 32 page from ZONE_NORMAL
8. reclaim 32 page from ZONE_DMA

oops, all zone reclaimed the same pages although ZONE_HIGHMEM have
much memory than ZONE_DMA.
IOW, ZONE_DMA's reclaim scanning rate is much than ZONE_HIGHMEM largely.

it isn't intentionally.



Actually, try_to_free_pages don't need pressure fairness. it is the
role of the balance_pgdat().


> However, having dozens of direct reclaim tasks all getting
> to the lower priority levels can be disastrous, causing
> extraordinarily large amounts of memory to be swapped out
> and minutes-long stalls to applications.

agreed.

>
> I think we can come up with a middle ground here:
> - always let kswapd continue its rounds

agreed.

> - have direct reclaim tasks continue when priority == DEF_PRIORITY

disagreed.
it cause above bad scenario, I think.

> - break out of the loop for direct reclaim tasks, when
>  priority < DEF_PRIORITY and enough pages have been freed
>
> Does that sound like it would mostly preserve memory pressure
> between zones, while avoiding the worst of the worst when it
> comes to excessive page eviction?
