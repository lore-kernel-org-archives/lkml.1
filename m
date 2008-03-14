Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYCNLWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYCNLWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYCNLWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:22:36 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:33997 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYCNLWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:22:35 -0400
Date: Fri, 14 Mar 2008 11:16:09 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Move memory controller allocations to their own slabs
 (v3)
In-Reply-To: <20080314115645.e78b7f5c.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0803141100110.19587@blonde.site>
References: <20080313140307.20133.30405.sendpatchset@localhost.localdomain>
 <20080314115645.e78b7f5c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, KAMEZAWA Hiroyuki wrote:
> At first, in my understanding,
> - MOVABLE is for migratable pages. (so, not for kernel objects.)
> - RECLAIMABLE is for reclaimable kernel objects. (for slab etc..)
> 
> All reclaimable objects are not necessary to be always reclaimable but
> some amount of RECLAIMABLE objects (not all) should be recraimable easily.
> For example, some of dentry-cache, inode-cache is reclaimable because *unused*
> objects are cached.
> 
> When it comes to page_cgroup, *all* objects has dependency to pages which are
> assigned to.  And user pages are reclaimable.
> There is a similar object....the radix tree. radix-tree's node is allocated as
> RECLAIMABLE object.
> 
> So I think it makes sense to changing page_cgroup to be reclaimable.
> 
> But final decision should be done by how fragmentation avoidance works.
> It's good to test "how many hugepages can be allocated dynamically" when we
> make page_cgroup to be GFP_RECAIMABLE 

I agree with you on all points.  No need for it to be done in the same
patch as Balbir's, but yes, __GFP_RECLAIMABLE appears to be appropriate
for the page_cgroup kmem_cache.

(I think it's a better fit than for the radix_tree_node cache: though
the common pagecache usage of the radix_tree implies that its nodes
are reclaimable, I can't see why radix_tree nodes would intrinsically
be reclaimable.  If a significant non-reclaimable user of radix-tree
comes on the scene, I'd expect us to change that assumption.)

Hugh
