Return-Path: <linux-kernel-owner+w=401wt.eu-S965800AbXLTQiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965800AbXLTQiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935090AbXLTQhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:37:53 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34965 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934753AbXLTQhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:37:52 -0500
Date: Thu, 20 Dec 2007 16:36:37 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] memcgroup: work better with tmpfs
In-Reply-To: <4768B1C5.1000604@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0712201600330.6414@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
 <4768B1C5.1000604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, Balbir Singh wrote:
> Hugh Dickins wrote:
> 
> We always call mem_cgroup_isolate_pages() from shrink_(in)active_pages
> under spin_lock_irq of the zone's lru lock. That's the reason that we
> don't explicitly use it in the routine.

Indeed, thanks.

> 
> > 2. There's mem_cgroup_charge and mem_cgroup_cache_charge (wouldn't the
> > former be better called mem_cgroup_charge_mapped? why does the latter
> 
> Yes, it would be. After we've refactored the code, the new name makes sense.
> 
> > test MEM_CGROUP_TYPE_ALL instead of MEM_CGROUP_TYPE_CACHED? I still don't
> > understand your enums there).
> 
> We do that to ensure that we charge page cache pages only when the
> accounting type is set to MEM_CGROUP_TYPE_ALL. If the type is anything
> else, we ignore cached pages, we did not have MEM_CGROUP_TYPE_CACHED
> initially when the patches went in.

I think you've given yourself far too many degrees of freedom here.

Please explain to me how the system is supposed to behave when I
echo -n 2 >/cg/0/memory.control_type

>From the name in the enum (MEM_CGROUP_TYPE_CACHED, doesn't even have
an "= 2", yet this is a part of the API?), I think it's supposed to
account pages into and out of the page cache, but not as they're
mapped into and out of userspace.  But from the code, no references
whatever to MEM_CGROUP_TYPE_CACHED or MEM_CGROUP_TYPE_MAPPED,
it looks as if it'll behave just like MEM_CGROUP_TYPE_MAPPED
(which we hope = 1).

As you say, you didn't have MEM_CGROUP_TYPE_CACHED originally:
it looks like it got added to the straightforward case of MAPPED,
in an apparently flexible but not fully thought out way.

> 
>  But there's only mem_cgroup_uncharge.
> > So when, for example, an add_to_page_cache fails, the uncharge may not
> > balance the charge?
> > 
> 
> We use mem_cgroup_uncharge() everywhere. The reason being, we might
> switch control type, we uncharge pages that have a page_cgroup
> associated with them, hence once we;ve charged, uncharge does not
> distinguish between charge types.

Ah, so this is the meaning of that 
	/*
	 * This can handle cases when a page is not charged at all and we
	 * are switching between handling the control_type.
	 */
	if (!pc)
		return;

	if (atomic_dec_and_test(&pc->ref_cnt)) {
at the beginning of mem_cgroup_uncharge.

Sorry, that doesn't fly.  You've no locking between acquiring pc from
the page->page_cgroup, testing pc here, and decrementing its ref_cnt.
When that ref_cnt goes down to zero, clear_page_cgroup may NULLify
page->page_cgroup and kfree the pc.

So if you cannot really keep track of the ref_cnt (because of
changing control_type), that atomic_dec_and_test is in danger
of corrupting someone else's memory - isn't it?

I can just about imagine that some admins will want control_type
MAPPED and others CACHED and others MAPPED+CACHED.  But is there
actually a need for one cgroup to be controlling MAPPED while
another on the same machine is controlling MAPPED+CACHED?  And
does that make sense - there'll be weirdnesses, won't there?
And is there actually a need to change a cgroup's control_type
on the fly while it's alive?

Of course it's nice to be flexible and allow for such possibilities;
but not if that just opens windows for corruption.  My own view is
that at present you should just account mapped and cached for all,
and strip out these extra degrees of freedom: add them back in some
future when the locking is worked out.

Hugh
