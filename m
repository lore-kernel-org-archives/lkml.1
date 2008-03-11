Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYCKSsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYCKSsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYCKSsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:48:03 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60261 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYCKSsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:48:00 -0400
Message-ID: <47D6D3CC.5070705@linux.vnet.ibm.com>
Date: Wed, 12 Mar 2008 00:17:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Move memory controller allocations to their own slabs
 (v2)
References: <20080311061836.6664.5072.sendpatchset@localhost.localdomain> <Pine.LNX.4.64.0803111230410.15328@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0803111230410.15328@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 11 Mar 2008, Balbir Singh wrote:
>> Move the memory controller data structure page_cgroup to its own slab cache.
>> It saves space on the system, allocations are not necessarily pushed to order
>> of 2 and should provide performance benefits. Users who disable the memory
>> controller can also double check that the memory controller is not allocating
>> page_cgroup's.
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> I certainly approve of giving page_cgroups their own kmem_cache
> (and agree with Kame that it was overkill for the zones).
> 

Thanks, yes, I agreed with Kame as well.

> But I don't agree with the SLAB_HWCACHE_ALIGN you've slipped into
> this version.  That'll be wasting a lot of (all? more than?) the
> space you're trying to save with a kmem_cache, won't it?  Let me
> talk about that separately, in reply to the mail where you report
> the numbers.
> 

I slipped in the SLAB_HWCACHE_ALIGN to reduce page cgroup cache contention. Yes
you are right, we do lose out on space due to the extra alignment. My test
results (lmbench) on kmalloc, slub and slab are not very conclusive about
performance. SLUB had the best results w.r.t protection faults and context switches.

> Are you proposing this page_cgroup_cache mod for 2.6.25 or for 2.6.26?

I am OK with any version as long as we can get good feedback. I suspect the
feature will be useful for 2.6.25.

> I ask because I want to build upon it to fix up some GFP_ flag issues:
> I think we end up claiming the page_cgroups are __GFP_MOVABLE when they
> should be called __GFP_RECLAIMABLE; but I don't know how seriously we
> take MOVABLE/RECLAIMABLE discrepancies at present.
> 

That's a very good question. I am not sure about the correct answer to that
myself at the moment.

> There's a patch I'd also like to build upon from Christoph in -mm
> (remove-set_migrateflags.patch), which sheds light on a similar issue
> with radix_tree_nodes).  It's importance is again dependent on how
> seriously we're taking MOVABLE/RECLAIMABLE discrepancies.
> 

I'll look at Christoph's patch and see what it addresses to understand the
MOVABLE/RECLAIMABLE discrepancy better.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
