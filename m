Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYF2EtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYF2EtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 00:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYF2Esx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 00:48:53 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:53765 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYF2Esw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 00:48:52 -0400
Message-ID: <48671433.1060409@linux.vnet.ibm.com>
Date: Sun, 29 Jun 2008 10:18:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 5/5] Memory controller soft limit reclaim on contention
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop> <20080627151906.31664.7247.sendpatchset@balbir-laptop> <6599ad830806270909w6a2c26d8mcf406856c06c5da@mail.gmail.com>
In-Reply-To: <6599ad830806270909w6a2c26d8mcf406856c06c5da@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Jun 27, 2008 at 8:19 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> +/*
>> + * Create a heap of memory controller structures. The heap is reverse
>> + * sorted by size. This heap is used for implementing soft limits. Our
>> + * current heap implementation does not allow dynamic heap updates, but
>> + * eventually, the costliest controller (over it's soft limit should
> 
> it's -> its
> 
>> +                       old_mem = heap_insert(&mem_cgroup_heap, mem,
>> +                                               HEAP_REP_LEAF);
>> +                       mem->on_heap = 1;
>> +                       if (old_mem)
>> +                               old_mem->on_heap = 0;
> 
> Maybe a comment here that mem might == old_mem?
> 
>> + * When the soft limit is exceeded, look through the heap and start
>> + * reclaiming from all groups over thier soft limit
> 
> thier -> their
> 
>> +               if (!res_counter_check_under_soft_limit(&mem->res)) {
>> +                       /*
>> +                        * The current task might already be over it's soft
>> +                        * limit and trying to aggressively grow. We check to
>> +                        * see if it the memory group associated with the
>> +                        * current task is on the heap when the current group
>> +                        * is over it's soft limit. If not, we add it
>> +                        */
>> +                       if (!mem->on_heap) {
>> +                               struct mem_cgroup *old_mem;
>> +
>> +                               old_mem = heap_insert(&mem_cgroup_heap, mem,
>> +                                                       HEAP_REP_LEAF);
>> +                               mem->on_heap = 1;
>> +                               if (old_mem)
>> +                                       old_mem->on_heap = 0;
>> +                       }
>> +               }
> 
> This and the other similar code for adding to the heap should be
> refactored into a separate function.
> 
>> +static int mem_cgroup_compare_soft_limits(void *p1, void *p2)
>> +{
>> +       struct mem_cgroup *mem1 = (struct mem_cgroup *)p1;
>> +       struct mem_cgroup *mem2 = (struct mem_cgroup *)p2;
>> +       unsigned long long delta1, delta2;
>> +
>> +       delta1 = res_counter_soft_limit_delta(&mem1->res);
>> +       delta2 = res_counter_soft_limit_delta(&mem2->res);
>> +
>> +       return delta1 > delta2;
>> +}
> 
> This isn't a valid comparator, since it isn't a constant function of
> its two input pointers - calling mem_cgroup_compare_soft_limits(m1,
> m2) can give different results at different times. So your heap
> invariant will become invalid over time.
> 
> I think if you want to do this, you're going to need to periodically
> take a snapshot of each cgroup's excess and use that snapshot in the
> comparator; whenever you update the snapshots, you'll need to restore
> the heap invariant.

I see your point. Keeping snapshots sounds OK, but updating the heap each time
is expensive, since it's hard to find a node in the heap. If we could, then we
could call heap_adjust frequently (whenever the delta changes) and keep the heap
correctly formed. I wonder if keeping two snapshots will help. One for use by
the ->gt callback (called old_snapshot) and then we switch over to the new
snapshot when we reinsert the element after it has been deleted from the heap.

Thinking further, snapshotting might work, provided we take snapshots at the
time of insertion only. When an element is deleted and re-inserted we update the
snapshot. That way the invariant is not broken.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
