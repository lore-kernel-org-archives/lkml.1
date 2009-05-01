Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZEABXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZEABXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZEABXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:23:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:16065 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbZEABXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:23:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,276,1239001200"; 
   d="scan'208";a="137984564"
Date: Fri, 1 May 2009 09:22:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 20/22] vmscan: avoid multiplication overflow in
	shrink_zone()
Message-ID: <20090501012212.GA5848@localhost>
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 06:08:55AM +0800, Andrew Morton wrote:
> 
> Local variable `scan' can overflow on zones which are larger than
> 
> 	(2G * 4k) / 100 = 80GB.
> 
> Making it 64-bit on 64-bit will fix that up.

A side note about the "one HUGE scan inside shrink_zone":

Isn't this low level scan granularity way tooooo large?

It makes things a lot worse on memory pressure:
- the over reclaim, somehow workarounded by Rik's early bail out patch
- the throttle_vm_writeout()/congestion_wait() guards could work in a
  very sparse manner and hence is useless: imagine to stop and wait
  after shooting away every 1GB memory.

The long term fix could be to move the granularity control up to the
shrink_zones() level: there it can bail out early without hurting the
balanced zone aging.

Thanks,
Fengguang

> --- a/mm/vmscan.c~vmscan-avoid-multiplication-overflow-in-shrink_zone
> +++ a/mm/vmscan.c
> @@ -1471,7 +1471,7 @@ static void shrink_zone(int priority, st
>  
>  	for_each_evictable_lru(l) {
>  		int file = is_file_lru(l);
> -		int scan;
> +		unsigned long scan;
>  
>  		scan = zone_nr_pages(zone, sc, l);
>  		if (priority) {
> _
