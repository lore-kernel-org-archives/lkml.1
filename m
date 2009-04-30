Return-Path: <linux-kernel-owner+w=401wt.eu-S1764049AbZD3SNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764049AbZD3SNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbZD3SMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:12:51 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60377 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763443AbZD3SMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:12:50 -0400
Date: Thu, 30 Apr 2009 23:42:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [PATCH] memcg: fix stale swap cache leak v5
Message-ID: <20090430181246.GM4430@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090430161627.0ccce565.kamezawa.hiroyu@jp.fujitsu.com> <20090430163539.7a882cef.kamezawa.hiroyu@jp.fujitsu.com> <20090430180426.25ae2fa6.kamezawa.hiroyu@jp.fujitsu.com> <20090430094252.GG4430@balbir.in.ibm.com> <20090430184738.752858ea.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090430184738.752858ea.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-30 18:47:38]:

> On Thu, 30 Apr 2009 15:12:52 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-30 18:04:26]:
> > 
> > > On Thu, 30 Apr 2009 16:35:39 +0900
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > 
> > > > On Thu, 30 Apr 2009 16:16:27 +0900
> > > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > 
> > > > > This is v5 but all codes are rewritten.
> > > > > 
> > > > > After this patch, when memcg is used,
> > > > >  1. page's swapcount is checked after I/O (without locks). If the page is
> > > > >     stale swap cache, freeing routine will be scheduled.
> > > > >  2. vmscan.c calls try_to_free_swap() when __remove_mapping() fails.
> > > > > 
> > > > > Works well for me. no extra resources and no races.
> > > > > 
> > > > > Because my office will be closed until May/7, I'll not be able to make a
> > > > > response. Posting this for showing what I think of now.
> > > > > 
> > > > I found a hole immediately after posted this...sorry. plz ignore this patch/
> > > > see you again in the next month.
> > > > 
> > > I'm now wondering to disable "swapin readahed" completely when memcg is used...
> > > Then, half of the problems will go away immediately.
> > > And it's not so bad to try to free swapcache if swap writeback ends. Then, another
> > > half will go away...
> > >
> > 
> > Could you clarify? Will memcg not account for swapin readahead pages?
> >  
> swapin-readahead pages are _not_ accounted now. (And I think _never_)
> But has race and leak swp_entry account until global LRU runs.
> 
> "Don't do swapin-readahead, at all" will remove following race completely.
> ==
>          CPU0                  CPU1
>  free_swap_and_cache()
>                         read_swapcache_async()
> ==
> swp_entry to be freed will not be read-in.
> 
> I think there will no performance regression in _usual_ case even if no readahead.
> But has no number yet.
>

Kamezawa, Daisuke,

Can't we just correct the accounting and leave the page on the global
LRU?

Daisuke in the race conditions mentioned is (2) significant? Since the
accounting is already fixed during mem_cgroup_uncharge_page()?

 

-- 
	Balbir
