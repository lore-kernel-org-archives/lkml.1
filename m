Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbZDAJLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbZDAJLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760207AbZDAJL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:11:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49083 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120AbZDAJL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:11:27 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan: rename  sc.may_swap to may_unmap)
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20090401180445.80b11d90.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090401040951.GA1548@cmpxchg.org> <20090401180445.80b11d90.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090401180756.B1F1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed,  1 Apr 2009 18:11:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> memory cgroup has 2 calls to this shrink_zone.
>  1. memory usage hits the limit.
>  2. mem+swap usage hits the limit.
> 
> At "2", swap-out doesn't decrease the usage of mem+swap, then set may_swap=0.
> So, we want to kick out only file caches.
> But, we can reclaim file cache and "unmap file cache and reclaim it!" is 
> necessary even if may_swap=0.
> 
> Then, scanning only FILE LRU makes sense at may_swap=0 *if* memcg is
> the only user of may_swap=0.
> 
> Let's see others.
> 
>  - __zone_reclaim sets may_unmap to be 0 when they don't want swap-out.
>    .....can be replaced with may_swap.
> 
>  - shrink_all_memory sets may_swap to be 0. Is this called by hibernation ?
>    If you don't want to unmap file caches while hibernation, adding may_unmap
>    as *new* paramter makes sense, I think.
> 
> The change you proposed is for dropping unused SwapCache pages. Right ?
> But this will be dropped by kswapd if necessary.
> 
> As far as memcg concerns, scanning ANON LRU even when may_swap=0 is just
> a waste of cpu time.

this sentence just explain my intention.

1. memcg, zone_reclaim scanning ANON LRU is just waste of cpu.
2. kswapd and normal direct reclaim can reclaim stealed swapcache anyway.
   then above trick don't cause any system hang-up and performance degression.



