Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbZDAOnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbZDAOnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765631AbZDAOn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:43:29 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47260 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763440AbZDAOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:43:27 -0400
Date: Wed, 1 Apr 2009 20:12:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
Message-ID: <20090401144252.GE4210@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27 13:59:33]:

> Hi,
> 
> Memory cgroup's soft limit feature is a feature to tell global LRU 
> "please reclaim from this memcg at memory shortage".
> 
> And Balbir's one and my one was proposed.
> This is new one. (so restart from v1), this is very new-born.
> 
> While testing soft limit, my dilemma was following.
> 
>  - needs additional cost of can if implementation is naive (unavoidable?)
> 
>  - Inactive/Active rotation scheme of global LRU will be broken.
> 
>  - File/Anon reclaim ratio scheme of global LRU will be broken.
>     - vm.swappiness will be ignored.
> 
>  - If using memcg's memory reclaim routine, 
>     - shrink_slab() will be never called.
>     - stale SwapCache has no chance to be reclaimed (stale SwapCache means
>       readed but not used one.)
>     - memcg can have no memory in a zone.
>     - memcg can have no Anon memory
>     - lumpty_reclaim() is not called.
> 
> 
> This patch tries to avoid to use existing memcg's reclaim routine and
> just tell "Hints" to global LRU. This patch is briefly tested and shows
> good result to me. (But may not to you. plz brame me.)
> 
> Major characteristic is.
>  - memcg will be inserted to softlimit-queue at charge() if usage excess
>    soft limit.
>  - softlimit-queue is a queue with priority. priority is detemined by size
>    of excessing usage.
>  - memcg's soft limit hooks is called by shrink_xxx_list() to show hints.
>  - Behavior is affected by vm.swappiness and LRU scan rate is determined by
>    global LRU's status.
> 
> I'm sorry that I'm tend not to tell enough explanation.  plz ask me.
> There will be much discussion points, anyway. As usual, I'm not in hurry.
> 
> 
> ==brief test result==
> On 2CPU/1.6GB bytes machine. create group A and B
>   A.  soft limit=300M
>   B.  no soft limit
> 
>   Run a malloc() program on B and allcoate 1G of memory. The program just
>   sleeps after allocating memory and no memory refernce after it.
>   Run make -j 6 and compile the kernel.
> 
>   When vm.swappiness = 60  => 60MB of memory are swapped out from B.
>   When vm.swappiness = 10  => 1MB of memory are swapped out from B    
> 
>   If no soft limit, 350MB of swap out will happen from B.(swapiness=60)
>

I did some brief functionality tests and the results are far better
than the previous versions of the patch. Both my v7 (with some minor
changes) and this patchset seem to do well functionally. Time to do
some more exhaustive tests. Any results from your end? 

-- 
	Balbir
