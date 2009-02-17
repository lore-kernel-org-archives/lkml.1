Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZBQEla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZBQEla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 23:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbZBQElU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 23:41:20 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37484 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZBQElU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 23:41:20 -0500
Date: Tue, 17 Feb 2009 10:11:10 +0530
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
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches (v2)
Message-ID: <20090217044110.GD20958@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090216110844.29795.17804.sendpatchset@localhost.localdomain> <20090217090523.975bbec2.kamezawa.hiroyu@jp.fujitsu.com> <20090217030526.GA20958@balbir.in.ibm.com> <20090217130352.4ba7f91c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090217130352.4ba7f91c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-17 13:03:52]:

> On Tue, 17 Feb 2009 08:35:26 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-17 09:05:23]:
> > 
> > > On Mon, 16 Feb 2009 16:38:44 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > 
> > > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > > 
> > > > Changelog v2...v1
> > > > 1. Soft limits now support hierarchies
> > > > 2. Use spinlocks instead of mutexes for synchronization of the RB tree
> > > > 
> > > > Here is v2 of the new soft limit implementation. Soft limits is a new feature
> > > > for the memory resource controller, something similar has existed in the
> > > > group scheduler in the form of shares. The CPU controllers interpretation
> > > > of shares is very different though. We'll compare shares and soft limits
> > > > below.
> > > > 
> > > > Soft limits are the most useful feature to have for environments where
> > > > the administrator wants to overcommit the system, such that only on memory
> > > > contention do the limits become active. The current soft limits implementation
> > > > provides a soft_limit_in_bytes interface for the memory controller and not
> > > > for memory+swap controller. The implementation maintains an RB-Tree of groups
> > > > that exceed their soft limit and starts reclaiming from the group that
> > > > exceeds this limit by the maximum amount.
> > > > 
> > > > This is an RFC implementation and is not meant for inclusion
> > > > 
> > > 
> > > some thoughts after reading patch.
> > > 
> > > 1. As I pointed out, cpuset/mempolicy case is not handled yet.
> > 
> > That should be esy to do with zonelists passed from reclaim path
> >
> plz do.
> 
> > 
> > > 2. I don't like to change usual direct-memory-reclaim path. It will be obstacles
> > >    for VM-maintaners to improve memory reclaim. memcg's LRU is designed for
> > >    shrinking memory usage and not for avoiding memory shortage. IOW, it's slow routine
> > >    for reclaiming memory for memory shortage.
> > 
> > I don't think I agree here. Direct reclaim is the first indication of
> > shortage and if order 0 pages are short, memcg's above their soft
> > limit can be targetted first.
> > 
> My "slow" means "the overhead seems to be big". The latency will increase.
> 
> About 0-order
> In patch 4/4
> +	did_some_progress = mem_cgroup_soft_limit_reclaim(gfp_mask);
> +	/*
> should be
>         if (!order)
>             did_some_progress = mem....
> 

OK, will do

> 
> I don't want to add any new big burden to kernel hackers of memory management,
> they work hard to improve memory reclaim. This patch will change the behavior.
> 

I don't think I agree, this approach suggests that before doing global
reclaim, there are several groups that are using more than their
share of memory, so it makes sense to reclaim from them first.


> BTW, in typical bad case, several threads on cpus goes into memory recalim at once and
> all thread will visit this memcg's soft-limit tree at once and soft-limit will
> not work as desired anyway.
> You can't avoid this problem at alloc_page() hot-path.

Even if all threads go into soft-reclaim at once, the tree will become
empty after a point and we will just return saying there are no more
memcg's to reclaim from (we remove the memcg from the tree when
reclaiming), then those threads will go into regular reclaim if there
is still memory pressure.

> 
> > > 3. After this patch, res_counter is no longer for general purpose res_counter...
> > >    It seems to have too many unnecessary accessories for general purpose.  
> > 
> > Why not? Soft limits are a feature of any controller. The return of
> > highest ancestor might be the only policy we impose right now. But as
> > new controllers start using res_counter, we can clearly add a policy
> > callback.
> > 
> I think you forget that memroy cgroups is an only controller in which the kernel
> can reduce the usage of resource without any harmful to users.
> soft-limit is nonsense for general resources, I think.
> 

Really? Even for CPUs? soft-limit is a form of shares (please don't
confuse with cpu.shares). Soft limits is used as a way of implementing
work conserving controllers.

-- 
	Balbir
