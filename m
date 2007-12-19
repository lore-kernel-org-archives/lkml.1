Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXLSFxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXLSFxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbXLSFxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:53:25 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49262 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXLSFxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:53:24 -0500
Message-ID: <4768B1C5.1000604@linux.vnet.ibm.com>
Date: Wed, 19 Dec 2007 11:23:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] memcgroup: work better with tmpfs
References: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Here's a couple of patches to get memcgroups working better with tmpfs
> and shmem, in conjunction with the tmpfs patches I just posted.  There
> will be another to come later on, but I shouldn't wait any longer to get
> these out to you.
> 

Hi, Hugh,

Thank you so much for the review, some comments below

> (The missing patch will want to leave a mem_cgroup associated with a tmpfs
> file or shm object, so that if its pages get brought back from swap by
> swapoff, they can be associated with that mem_cgroup rather than the one
> which happens to be running swapoff.)
> 
>  mm/memcontrol.c |   81 ++++++++++++++++++++--------------------------
>  mm/shmem.c      |   28 +++++++++++++++
>  2 files changed, 63 insertions(+), 46 deletions(-)
> 
> But on the way I've noticed a number of issues with memcgroups not dealt
> with in these patches.
> 
> 1. Why is spin_lock_irqsave rather than spin_lock needed on mz->lru_lock?
> If it is needed, doesn't mem_cgroup_isolate_pages need to use it too?
> 

We always call mem_cgroup_isolate_pages() from shrink_(in)active_pages
under spin_lock_irq of the zone's lru lock. That's the reason that we
don't explicitly use it in the routine.

> 2. There's mem_cgroup_charge and mem_cgroup_cache_charge (wouldn't the
> former be better called mem_cgroup_charge_mapped? why does the latter

Yes, it would be. After we've refactored the code, the new name makes sense.

> test MEM_CGROUP_TYPE_ALL instead of MEM_CGROUP_TYPE_CACHED? I still don't
> understand your enums there).

We do that to ensure that we charge page cache pages only when the
accounting type is set to MEM_CGROUP_TYPE_ALL. If the type is anything
else, we ignore cached pages, we did not have MEM_CGROUP_TYPE_CACHED
initially when the patches went in.

 But there's only mem_cgroup_uncharge.
> So when, for example, an add_to_page_cache fails, the uncharge may not
> balance the charge?
> 

We use mem_cgroup_uncharge() everywhere. The reason being, we might
switch control type, we uncharge pages that have a page_cgroup
associated with them, hence once we;ve charged, uncharge does not
distinguish between charge types.

> 3. mem_cgroup_charge_common has rcu_read_lock/unlock around its
> rcu_dereference; mem_cgroup_cache_charge does not: is that right?
> 

Very good catch! Will fix it.

> 4. That page_assign_page_cgroup in free_hot_cold_page, what case is that
> handling?  Wouldn't there be a leak if it ever happens?  I've been running
> with a BUG_ON(page->page_cgroup) there and not hit it - should it perhaps
> be a "Bad page state" case?
> 

Our cleanup in page_cache_uncharge() does take care of cleaning up the
page_cgroup. I think you've got it right, it should be a BUG_ON in
free_hot_cold_page()

> Hugh

Thanks for the detailed review and fixes.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
