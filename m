Return-Path: <linux-kernel-owner+w=401wt.eu-S937832AbXLTSOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937832AbXLTSOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765337AbXLTSOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:14:10 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38820 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763417AbXLTSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:14:08 -0500
Message-ID: <476AB0DA.80804@linux.vnet.ibm.com>
Date: Thu, 20 Dec 2007 23:43:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] memcgroup: work better with tmpfs
References: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com> <4768B1C5.1000604@linux.vnet.ibm.com> <Pine.LNX.4.64.0712201600330.6414@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0712201600330.6414@blonde.wat.veritas.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 19 Dec 2007, Balbir Singh wrote:
>> Hugh Dickins wrote:
>>
>> We always call mem_cgroup_isolate_pages() from shrink_(in)active_pages
>> under spin_lock_irq of the zone's lru lock. That's the reason that we
>> don't explicitly use it in the routine.
> 
> Indeed, thanks.
> 
>>> 2. There's mem_cgroup_charge and mem_cgroup_cache_charge (wouldn't the
>>> former be better called mem_cgroup_charge_mapped? why does the latter
>> Yes, it would be. After we've refactored the code, the new name makes sense.
>>
>>> test MEM_CGROUP_TYPE_ALL instead of MEM_CGROUP_TYPE_CACHED? I still don't
>>> understand your enums there).
>> We do that to ensure that we charge page cache pages only when the
>> accounting type is set to MEM_CGROUP_TYPE_ALL. If the type is anything
>> else, we ignore cached pages, we did not have MEM_CGROUP_TYPE_CACHED
>> initially when the patches went in.
> 
> I think you've given yourself far too many degrees of freedom here.
> 
> Please explain to me how the system is supposed to behave when I
> echo -n 2 >/cg/0/memory.control_type
> 
> From the name in the enum (MEM_CGROUP_TYPE_CACHED, doesn't even have
> an "= 2", yet this is a part of the API?), I think it's supposed to
> account pages into and out of the page cache, but not as they're
> mapped into and out of userspace.  But from the code, no references
> whatever to MEM_CGROUP_TYPE_CACHED or MEM_CGROUP_TYPE_MAPPED,
> it looks as if it'll behave just like MEM_CGROUP_TYPE_MAPPED
> (which we hope = 1).
> 
> As you say, you didn't have MEM_CGROUP_TYPE_CACHED originally:
> it looks like it got added to the straightforward case of MAPPED,
> in an apparently flexible but not fully thought out way.
> 

Yes, I think your argument makes sense. I had initially thought of
making the enums a mask

MEM_CGROUP_TYPE_MAPPED = 0x1,
MEM_CGROUP_TYPE_CACHED = 0x2,
MEM_CGROUP_TYPE_ALL = 0x3

and check for control_type & MEM_CGROUP_TYPE_CACHED


>>  But there's only mem_cgroup_uncharge.
>>> So when, for example, an add_to_page_cache fails, the uncharge may not
>>> balance the charge?
>>>
>> We use mem_cgroup_uncharge() everywhere. The reason being, we might
>> switch control type, we uncharge pages that have a page_cgroup
>> associated with them, hence once we;ve charged, uncharge does not
>> distinguish between charge types.
> 
> Ah, so this is the meaning of that 
> 	/*
> 	 * This can handle cases when a page is not charged at all and we
> 	 * are switching between handling the control_type.
> 	 */
> 	if (!pc)
> 		return;
> 
> 	if (atomic_dec_and_test(&pc->ref_cnt)) {
> at the beginning of mem_cgroup_uncharge.
> 
> Sorry, that doesn't fly.  You've no locking between acquiring pc from
> the page->page_cgroup, testing pc here, and decrementing its ref_cnt.
> When that ref_cnt goes down to zero, clear_page_cgroup may NULLify
> page->page_cgroup and kfree the pc.
> 

Yes, we need to lock the page group.


> So if you cannot really keep track of the ref_cnt (because of
> changing control_type), that atomic_dec_and_test is in danger
> of corrupting someone else's memory - isn't it?
>

Yes, my bad :(

> I can just about imagine that some admins will want control_type
> MAPPED and others CACHED and others MAPPED+CACHED.  But is there
> actually a need for one cgroup to be controlling MAPPED while
> another on the same machine is controlling MAPPED+CACHED?  And
> does that make sense - there'll be weirdnesses, won't there?
> And is there actually a need to change a cgroup's control_type
> on the fly while it's alive?
> 
> Of course it's nice to be flexible and allow for such possibilities;
> but not if that just opens windows for corruption.  My own view is
> that at present you should just account mapped and cached for all,
> and strip out these extra degrees of freedom: add them back in some
> future when the locking is worked out.
> 


I am going to rip out the control_type interface for now. The locking
needs fixing irrespective of control_type. I am sending out a patch to
rip out control_type.

> Hugh

Thanks for your detailed comments,

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
