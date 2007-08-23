Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbXHWKEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbXHWKEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbXHWKEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:04:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbXHWKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:04:43 -0400
Subject: Re: [RFC]  : mm : / Patch / Suggestion : Add 1 order or
	agressiveness to wakeup_kswapd() : 1 line / 1 arg change
From: Peter Zijlstra <peterz@infradead.org>
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "\"Ingo Molnar\"" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <000501c7e569$023fa240$6501a8c0@earthlink.net>
References: <000501c7e569$023fa240$6501a8c0@earthlink.net>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 12:04:38 +0200
Message-Id: <1187863478.6114.364.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 02:35 -0700, Mitchell Erblich wrote:
> Group,
> 
>     On the infrequent condition of failing to recieve a page from the
>     freelists, one of the things you do is call wakeup_kswapd()(exception of
>     NUMA or GFP_THISNODE).
> 
>     Asuming that wakeup_kswapd() does what we want, this call is
>     such a high overhead call that you want to make sure that the
>     call is infrequent.

It just wakes up a thread, it doesn't actually wait for anything.
So the function is actually rather cheap.

>     My initial guess is that it REALLY needs to re-populate the
>     freelists just before they/it is used up. However, the simple change
>     is being suggested NOW.

kswapd will only stop once it has reached the high watermarks

>     Assuming that on avg that the order value will be used, you should
>     increase the order to cover two allocs of that same level of order,
>     thus the +1. If on the chance that later page_alloc() calls need
>     fewer pages (smaller order) then the extra pages will be available
>     for more page_allocs(). If later calls have larger orders, hopefully
>     the latency between the calls is great enough that other parts of
>     the system will respond to the low memory / on the freelist(s).

by virtue of kswapd only stopping reclaim when it reaches the high
watermark you already have that it will free more than one page (its
started when we're below the low watermark, so it'll free at least
high-min pages).

Changing the order has quite a different impact, esp now that we have
lumpy reclaim.

>     Line 1265 within function __alloc_pages(), mm/page_alloc.c
> 
> wakeup_kswapd(*z, order);
>       to
> wakeup_kswapd(*z, order + 1);
> 
> In addition, isn't a call needed to determine that the
> freelist(s) are almost empty, but are still returning a page?

didn't we just do that by finding out that ALLOC_WMARK_LOW fails to
return a page?


