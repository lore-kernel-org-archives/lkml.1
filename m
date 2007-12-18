Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbXLRWWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbXLRWWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbXLRWV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:21:59 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55652 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXLRWV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:21:58 -0500
Date: Tue, 18 Dec 2007 22:19:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] memcgroup: work better with tmpfs
Message-ID: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a couple of patches to get memcgroups working better with tmpfs
and shmem, in conjunction with the tmpfs patches I just posted.  There
will be another to come later on, but I shouldn't wait any longer to get
these out to you.

(The missing patch will want to leave a mem_cgroup associated with a tmpfs
file or shm object, so that if its pages get brought back from swap by
swapoff, they can be associated with that mem_cgroup rather than the one
which happens to be running swapoff.)

 mm/memcontrol.c |   81 ++++++++++++++++++++--------------------------
 mm/shmem.c      |   28 +++++++++++++++
 2 files changed, 63 insertions(+), 46 deletions(-)

But on the way I've noticed a number of issues with memcgroups not dealt
with in these patches.

1. Why is spin_lock_irqsave rather than spin_lock needed on mz->lru_lock?
If it is needed, doesn't mem_cgroup_isolate_pages need to use it too?

2. There's mem_cgroup_charge and mem_cgroup_cache_charge (wouldn't the
former be better called mem_cgroup_charge_mapped? why does the latter
test MEM_CGROUP_TYPE_ALL instead of MEM_CGROUP_TYPE_CACHED? I still don't
understand your enums there).  But there's only mem_cgroup_uncharge.
So when, for example, an add_to_page_cache fails, the uncharge may not
balance the charge?

3. mem_cgroup_charge_common has rcu_read_lock/unlock around its
rcu_dereference; mem_cgroup_cache_charge does not: is that right?

4. That page_assign_page_cgroup in free_hot_cold_page, what case is that
handling?  Wouldn't there be a leak if it ever happens?  I've been running
with a BUG_ON(page->page_cgroup) there and not hit it - should it perhaps
be a "Bad page state" case?

Hugh
