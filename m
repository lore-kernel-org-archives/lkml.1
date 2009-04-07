Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbZDGGjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbZDGGjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZDGGiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:38:03 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59381 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262AbZDGGiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:38:01 -0400
Date: Tue, 7 Apr 2009 12:07:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Rik van Riel <riel@surriel.com>, Bharata B Rao <bharata.rao@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFI] Shared accounting for memory resource controller
Message-ID: <20090407063722.GQ7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

This is a request for input for the design of shared page accounting for
the memory resource controller, here is what I have so far

Motivation for shared page accounting
-------------------------------------
1. Memory cgroup administrators will benefit from the knowledge of how
   much of the data is shared, it helps size the groups correctly.
2. We currently report only the pages brought in by the cgroup, knowledge
   of shared data will give a complete picture of the actual usage.

Use rmap to account sharing/unsharing through mapcount
-------------------------------------------------------

The current page has links to

	+-------+
	|       |
	|	+--->pc->mem_cgroup (first mem_cgroup to touch the page)
	|	|
	| page	|
	|	+--->mapping (used for rmap)
	|	|
	+-------+

While accounting shared pages works well, as pages get unshared, I've hit a
problem. Here is the current flow for shared accounting

Flow for sharing
----------------
1. Page not yet mapped anywhere (_mapcount is -1 and mem_cgroup,mapping is NULL)
2. Page gets mapped for the first time (_mapcount is 0, mem_cgroup points
   to the memory resource group that brought in the page, mapping is set)
3. Page gets shared (_mapcount is 1, mem_cgroup points to the cgroup that
   brought in the page, mapping is set and now has rmap information)

When a page is being shared at step 3, we detect we are sharing the page and

1. For page->pc->mem_cgroup, we note that the page is being shared
2. For any vma that maps this page, we get to vma->vm_mm and then to the
   other mem_cgroup that is sharing this page and note this page is being
   shared.

So far so good

When a page is being uncharged

1. We note that we need to deduct the shared accounting from the mem_cgroup
2. When the _mapcount reaches 0, we have no way of knowing which of the
   mm's or mem_cgroup's is left behind. The original page->pc->mem_cgroup
   could have unmapped this page long time back. At this point we want
   to note the only mm that has this page mapped and the mem_cgroup is not
   sharing the page, but that the page is private to it.

Figuring out the mem_cgroup/mm for the last uncharge, requires a rmap
lookup, which we cannot do with PTE lock held (I have all my hooks in
page_add.*rmap() and page_remove_rmap()).

Questions, suggestions

1. Does it make sense to use the rmap routines for shared accounting?
2. How do we solve the problem of the last unshare causing the pages
   becoming private
	a. Can we use rmap?
	b. Can we live with leaving the page being marked as shared, even
           though it is no longer shared?


-- 
	Balbir
