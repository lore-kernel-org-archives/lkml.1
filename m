Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYDUGvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYDUGvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYDUGvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:51:11 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:42831 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYDUGvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:51:11 -0400
Date: Mon, 21 Apr 2008 12:17:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, shiwh@cn.fujitsu.com,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
Message-ID: <20080421064725.GA32214@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	hugh@veritas.com, menage@google.com, xemul@openvz.org,
	shiwh@cn.fujitsu.com, mel@csn.ul.ie, linux-kernel@vger.kernel.org
References: <20080420072053.6bcb7884.akpm@linux-foundation.org> <Pine.LNX.4.64.0804210004470.1630@blonde.site> <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com> <20080420232427.1b399104.akpm@linux-foundation.org> <480C347C.6060702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <480C347C.6060702@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2008-04-21 12:14:28]:

> Andrew Morton wrote:
> >> On Mon, 21 Apr 2008 09:30:59 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> On Mon, 21 Apr 2008 00:51:30 +0100 (BST)
> >> Hugh Dickins <hugh@veritas.com> wrote:
> >>>>  disable-the-memory-controller-by-default-v3.patch
> >>>>  disable-the-memory-controller-by-default-v3-fix.patch
> >>> If those are to go in, then the sooner the better, yes.
> >>>
> >>> But though I argued for cgroup_disable=memory (or some such),
> >>> I think myself that taking it even further now (requiring an
> >>> additional cgroup_enable=memory at boottime to get the memcg
> >>> stuff you chose with CGROUP_MEM_RES_CTLR=y at build time) is
> >>> confusing overkill, just messing around.
> > 
> > Yes, it does sound a bit silly.  I'd say just enable it, and provide a
> > cgroup_disable.
> > 
> 
OK, fair enough. Andi Kleen spoke about the overhead and how distros would
be impacted if they enabled CONFIG_MEM_RES_CTLR and it was not disabled by
default. I think the enable/disable is good. I just need to turn on/off
mem_cgroup_subsys.disabled. The patch is as simple as
 
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-dont-disable-by-default mm/memcontrol.c
--- linux-2.6.25/mm/memcontrol.c~memcg-dont-disable-by-default	2008-04-21 12:11:31.000000000 +0530
+++ linux-2.6.25-balbir/mm/memcontrol.c	2008-04-21 12:11:40.000000000 +0530
@@ -1108,5 +1108,4 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.populate = mem_cgroup_populate,
 	.attach = mem_cgroup_move_task,
 	.early_init = 0,
-	.disabled = 1,
 };
_

This would enable the memory controller by default, it can be disabled
using cgroup_disable=memory at boot time.
 
 
> >>> Others think differently.  A compromise would be to improve the
> >>> helptext for CGROUP_MEM_RES_CTLR (some of it is presently nonsense,
> >>> isn't it?  Certainly there's a significant overhead, but it's the
> >>> 32-bit struct page not the 64-bit which then suffers from crossing
> >>> cacheline boundaries).  Not much point in mentioning
> >>> cgroup_disable=memory if those patches go in, but needs to say
> >>> cgroup_enable=memory bootoption also needed.
> >>>
> >> My concern around this is "default" action of cgroups may be different
> >> from each otther. It's confusing...
> >>
> >>
> >>>>  memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone.patch
> >>> No, it was a good find from Shi, but you were right to think the patch
> >>> fishy, and Kame put in lots of work (thank you!) to identify the actual
> >>> culprit: he and Mel are discussing what the actual fix should be; and
> >>> we might want to choose a different fix for stable than for 2.6.26.
> >>>
> >>> I think you should drop that memmap_init_zone patch: the cgroup
> >>> pointer is not the only field we assume is zeroed, both flags and
> >>> mapping can cause trouble if they were not originally zeroed.
> >>> Re-zero the whole struct page?  No, far better to fix the
> >>> root of the corruption, that Kame and Mel are working on.
> >>>
> >> I'll test and repodt Mel's patch later. I think Shi's patch will be
> >> unnecessary.
> > 
> > OK, I'll drop that one.
> > 
> > Thanks - it helps.
> >

Thanks. I've not been able to reproduce Shi's problem. I should find
an IA64 box and try and reproduce it. Since KAME is well on top of it,
I've been just listening in and reading the code.
 
> 
> 
> -- 
> 	Warm Regards,
> 	Balbir Singh
> 	Linux Technology Center
> 	IBM, ISTL
> 
-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
