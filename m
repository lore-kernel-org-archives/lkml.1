Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbZCBHHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbZCBHHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 02:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbZCBHHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 02:07:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34248 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZCBHHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 02:07:22 -0500
Date: Mon, 2 Mar 2009 16:06:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Memory controller soft limit patches (v3)
Message-Id: <20090302160602.521928a5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090302063649.GJ11421@balbir.in.ibm.com>
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
	<20090302092404.1439d2a6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302044043.GC11421@balbir.in.ibm.com>
	<20090302143250.f47758f9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302060519.GG11421@balbir.in.ibm.com>
	<20090302152128.e74f51ef.kamezawa.hiroyu@jp.fujitsu.com>
	<20090302063649.GJ11421@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 12:06:49 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 15:21:28]:
> 
> > On Mon, 2 Mar 2009 11:35:19 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 14:32:50]:
> > > 
> > > > On Mon, 2 Mar 2009 10:10:43 +0530
> > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 09:24:04]:
> > > > > 
> > > > > > On Sun, 01 Mar 2009 11:59:59 +0530
> > > > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > > > 
> > > > > > > 
> > > > > > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > > 
> > > > > > 
> > > > > > At first, it's said "When cgroup people adds something, the kernel gets slow".
> > > > > > This is my start point of reviewing. Below is comments to this version of patch.
> > > > > > 
> > > > > >  1. I think it's bad to add more hooks to res_counter. It's enough slow to give up
> > > > > >     adding more fancy things..
> > > > > 
> > > > > res_counters was desgined to be extensible, why is adding anything to
> > > > > it going to make it slow, unless we turn on soft_limits?
> > > > > 
> > > > You inserted new "if" logic in the core loop.
> > > > (What I want to say here is not that this is definitely bad but that "isn't there
> > > >  any alternatives which is less overhead.)
> > > > 
> > > > 
> > > > > > 
> > > > > >  2. please avoid to add hooks to hot-path. In your patch, especially a hook to
> > > > > >     mem_cgroup_uncharge_common() is annoying me.
> > > > > 
> > > > > If soft limits are not enabled, the function does a small check and
> > > > > leaves. 
> > > > > 
> > > > &soft_fail_res is passed always even if memory.soft_limit==ULONG_MAX
> > > > res_counter_soft_limit_excess() adds one more function call and spinlock, and irq-off.
> > > >
> > > 
> > > OK, I see that overhead.. I'll figure out a way to work around it.
> > >  
> > > > > > 
> > > > > >  3. please avoid to use global spinlock more. 
> > > > > >     no lock is best. mutex is better, maybe.
> > > > > > 
> > > > > 
> > > > > No lock to update a tree which is update concurrently?
> > > > > 
> > > > Using tree/sort itself is nonsense, I believe.
> > > > 
> > > 
> > > I tried using prio trees in the past, but they are not easy to update
> > > either. I won't mind asking for suggestions for a data structure that
> > > can scaled well, allow quick insert/delete and search.
> > > 
> > Now, because the routine is called by kswapd() not by try_to_free.....
> > 
> > It's not necessary to be very very fast. That's my point.
> >
> 
> OK, I get your point, but whay does that make RB-Tree data structure non-sense?
>  

 1. Until memory-shortage, rb-tree is kept to be updated and the users(kernel)
    has to pay its maintainace/check cost, whici is unnecessary.
    Considering trade-off, paying cost only when memory-shortage happens tend to
    be reasonable way.

 2. Current "exceed" just shows "How much we got over my soft limit" but doesn't
    tell any information per-node/zone. Considering this, this rb-tree
    information will not be able to help kswapd (on NUMA).
    But maintain per-node information uses too much resource.

 Considering above 2, it's not bad to find victim by proper logic
 from balance_pgdat() by using mem_cgroup_select_victim().
 like this:
==
 struct mem_cgroup *select_vicitim_at_soft_limit_via_balance_pgdat(int nid, int zid)
 {
     while (?) {
        vitcim = mem_cgroup_select_victim(init_mem_cgroup);  #need some modification.
        if (victim is not over soft-limit)
             continue;
        /* Ok this is candidate */
        usage = mem_cgroup_nid_zid_usage(mem, nid, zid); #get sum of active/inactive
        if (usage_is_enough_big)
              return victim;
     }
 }
 balance_pgdat()
 ...... find target zone....
 ...
 mem = select_victime_at_soft_limit_via_balance_pgdat(nid, zid)
 if (mem)
   sc->mem = mem;
 shrink_zone();
 if (mem) {
   sc->mem = NULL;
   css_put(&mem->css);
 }
==

 We have to pay scan cost but it will not be too big(if there are not thousands of memcg.)
 Under above, round-robin rotation is used rather than sort.
 Maybe I can show you sample.....(but I'm a bit busy.)
 
Thanks,
-Kame

