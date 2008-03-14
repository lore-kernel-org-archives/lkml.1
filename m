Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYCNCwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYCNCwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYCNCw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:52:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38173 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYCNCw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:52:26 -0400
Date: Fri, 14 Mar 2008 11:56:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Move memory controller allocations to their own slabs
 (v3)
Message-Id: <20080314115645.e78b7f5c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080313140307.20133.30405.sendpatchset@localhost.localdomain>
References: <20080313140307.20133.30405.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 19:33:07 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> Changelog v3
> 
> 1. Remove HWCACHE_ALIGN
> 
> Changelog v2
> 
> 1. Remove extra slab for mem_cgroup_per_zone
> 
> Move the memory controller data structure page_cgroup to its own slab cache.
> It saves space on the system, allocations are not necessarily pushed to order
> of 2 and should provide performance benefits. Users who disable the memory
> controller can also double check that the memory controller is not allocating
> page_cgroup's.
> 
> NOTE: Hugh Dickins brought up the issue of whether we want to mark page_cgroup
> as __GFP_MOVABLE or __GFP_RECLAIMABLE. I don't think there is an easy
> answer at the moment. page_cgroup's are associated with user pages,
> they can be reclaimed once the user page has been reclaimed, so it might
> make sense to mark them as __GFP_RECLAIMABLE. For now, I am leaving the
> marking to default values that the slab allocator uses.
> 
> Comments?
> 
At first, in my understanding,
- MOVABLE is for migratable pages. (so, not for kernel objects.)
- RECLAIMABLE is for reclaimable kernel objects. (for slab etc..)

All reclaimable objects are not necessary to be always reclaimable but
some amount of RECLAIMABLE objects (not all) should be recraimable easily.
For example, some of dentry-cache, inode-cache is reclaimable because *unused*
objects are cached.

When it comes to page_cgroup, *all* objects has dependency to pages which are
assigned to.  And user pages are reclaimable.
There is a similar object....the radix tree. radix-tree's node is allocated as
RECLAIMABLE object.

So I think it makes sense to changing page_cgroup to be reclaimable.

But final decision should be done by how fragmentation avoidance works.
It's good to test "how many hugepages can be allocated dynamically" when we
make page_cgroup to be GFP_RECAIMABLE 

Thanks,
-Kame


