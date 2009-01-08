Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZAHEWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZAHEWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZAHEWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:22:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48846 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZAHEWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:22:45 -0500
Date: Thu, 8 Jan 2009 13:21:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>, riel@redhat.com,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches
Message-Id: <20090108132141.30bc3ce2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090108035930.GB7294@balbir.in.ibm.com>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
	<20090108093040.22d5f281.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108035930.GB7294@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 09:29:30 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-08 09:30:40]:
> 
> > On Thu, 08 Jan 2009 00:11:10 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > 
> > > Here is v1 of the new soft limit implementation. Soft limits is a new feature
> > > for the memory resource controller, something similar has existed in the
> > > group scheduler in the form of shares. We'll compare shares and soft limits
> > > below. I've had soft limit implementations earlier, but I've discarded those
> > > approaches in favour of this one.
> > > 
> > > Soft limits are the most useful feature to have for environments where
> > > the administrator wants to overcommit the system, such that only on memory
> > > contention do the limits become active. The current soft limits implementation
> > > provides a soft_limit_in_bytes interface for the memory controller and not
> > > for memory+swap controller. The implementation maintains an RB-Tree of groups
> > > that exceed their soft limit and starts reclaiming from the group that
> > > exceeds this limit by the maximum amount.
> > > 
> > > This is an RFC implementation and is not meant for inclusion
> > > 
> > Core implemantation seems simple and the feature sounds good.
> 
> Thanks!
> 
> > But, before reviewing into details, 3 points.
> > 
> >   1. please fix current bugs on hierarchy management, before new feature.
> >      AFAIK, OOM-Kill under hierarchy is broken. (I have patches but waits for
> >      merge window close.)
> 
> I've not hit the OOM-kill issue under hierarchy so far, is the OOM
> killer selecting a bad task to kill? I'll debug/reproduce the issue.
> I am not posting these patches for inclusion, fixing bugs is
> definitely the highest priority.
> 
Assume follwoing hierarchy.

   group_A/    limit=100M   usage=1M
	group_01/ no limit  usage=1M
	group_02/ no limit  usage=98M (does memory leak.)

   Q. What happens a task on group_02 causes oom ?
   A. A task in group_A dies.
   

is my problem. (As I said, I'll post a patch .) This is my homework for a month.
(I'll use CSS_ID to fix this.)
Any this will allow to skip my logic to check "Is this OOM is from memcg?"
And makes system panic if vm.panic_on_oom==1.





> >      I wonder there will be some others. Lockdep error which Nishimura reported
> >      are all fixed now ?
> 
> I run all my kernels and tests with lockdep enabled, I did not see any
> lockdep errors showing up.
> 
ok.

> > 
> >   2. You inserts reclaim-by-soft-limit into alloc_pages(). But, to do this,
> >      you have to pass zonelist to try_to_free_mem_cgroup_pages() and have to modify
> >      try_to_free_mem_cgroup_pages().
> >      2-a) If not, when the memory request is for gfp_mask==GFP_DMA or allocation
> >           is under a cpuset, memory reclaim will not work correctlly.
> 
> The idea behind adding the code in alloc_pages() is to detect
> contention and trim mem cgroups down, if they have grown beyond their
> soft limit
> 
Allowing usual direct reclaim go on and just waking up "balance_soft_limit_daemon()"
will be enough.

> >      2-b) try_to_free_mem_cgroup_pages() cannot do good work for order > 1 allocation.
> >   
> >      Please try fake-numa (or real NUMA machine) and cpuset.
> 
> Yes, order > 1 is documented in the patch and you can see the code as
> well. Your suggestion is to look at the gfp_mask as well, I'll do
> that.
> 
and zonelist/nodemask.

generic try_to_free_pages() doesn't have nodemask as its argument but it checks cpuset.

In shrink_zones().
==
1504                 /*
1505                  * Take care memory controller reclaiming has small influence
1506                  * to global LRU.
1507                  */
1508                 if (scan_global_lru(sc)) {
1509                         if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
1510                                 continue;
1511                         note_zone_scanning_priority(zone, priority);
1512 
1513                         if (zone_is_all_unreclaimable(zone) &&
1514                                                 priority != DEF_PRIORITY)
1515                                 continue;       /* Let kswapd poll it */
1516                         sc->all_unreclaimable = 0;
1517                 } else {
1518                         /*
1519                          * Ignore cpuset limitation here. We just want to reduce
1520                          * # of used pages by us regardless of memory shortage.
1521                          */
1522                         sc->all_unreclaimable = 0;
1523                         mem_cgroup_note_reclaim_priority(sc->mem_cgroup,
1524                                                         priority);
1525                 }
==
This is because "reclaim by memcg" can happen even if there are enough memory.
try_to_free_mem_cgroup_pages() is called when "hit limit".

So, there will be some issues to be improved if you want to use
try_to_free_mem_cgroup_pages() for recovering "memory shortage". 
I think above is one of issue. Some more assumption will corrupt.

-Kame

