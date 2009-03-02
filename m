Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZCBGhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZCBGhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZCBGhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:37:07 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54468 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbZCBGhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:37:05 -0500
Date: Mon, 2 Mar 2009 12:06:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
Message-ID: <20090302063649.GJ11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain> <20090302092404.1439d2a6.kamezawa.hiroyu@jp.fujitsu.com> <20090302044043.GC11421@balbir.in.ibm.com> <20090302143250.f47758f9.kamezawa.hiroyu@jp.fujitsu.com> <20090302060519.GG11421@balbir.in.ibm.com> <20090302152128.e74f51ef.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090302152128.e74f51ef.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 15:21:28]:

> On Mon, 2 Mar 2009 11:35:19 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 14:32:50]:
> > 
> > > On Mon, 2 Mar 2009 10:10:43 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 09:24:04]:
> > > > 
> > > > > On Sun, 01 Mar 2009 11:59:59 +0530
> > > > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > 
> > > > > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > 
> > > > > 
> > > > > At first, it's said "When cgroup people adds something, the kernel gets slow".
> > > > > This is my start point of reviewing. Below is comments to this version of patch.
> > > > > 
> > > > >  1. I think it's bad to add more hooks to res_counter. It's enough slow to give up
> > > > >     adding more fancy things..
> > > > 
> > > > res_counters was desgined to be extensible, why is adding anything to
> > > > it going to make it slow, unless we turn on soft_limits?
> > > > 
> > > You inserted new "if" logic in the core loop.
> > > (What I want to say here is not that this is definitely bad but that "isn't there
> > >  any alternatives which is less overhead.)
> > > 
> > > 
> > > > > 
> > > > >  2. please avoid to add hooks to hot-path. In your patch, especially a hook to
> > > > >     mem_cgroup_uncharge_common() is annoying me.
> > > > 
> > > > If soft limits are not enabled, the function does a small check and
> > > > leaves. 
> > > > 
> > > &soft_fail_res is passed always even if memory.soft_limit==ULONG_MAX
> > > res_counter_soft_limit_excess() adds one more function call and spinlock, and irq-off.
> > >
> > 
> > OK, I see that overhead.. I'll figure out a way to work around it.
> >  
> > > > > 
> > > > >  3. please avoid to use global spinlock more. 
> > > > >     no lock is best. mutex is better, maybe.
> > > > > 
> > > > 
> > > > No lock to update a tree which is update concurrently?
> > > > 
> > > Using tree/sort itself is nonsense, I believe.
> > > 
> > 
> > I tried using prio trees in the past, but they are not easy to update
> > either. I won't mind asking for suggestions for a data structure that
> > can scaled well, allow quick insert/delete and search.
> > 
> Now, because the routine is called by kswapd() not by try_to_free.....
> 
> It's not necessary to be very very fast. That's my point.
>

OK, I get your point, but whay does that make RB-Tree data structure non-sense?
 
-- 
	Balbir
