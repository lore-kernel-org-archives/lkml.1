Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbYETQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbYETQ3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYETQ3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:29:03 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43919 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbYETQ3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:29:01 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, dean@arctic.org, apw@shadowen.org,
       linux-kernel@vger.kernel.org, wli@holomorphy.com, dwg@au1.ibm.com,
       andi@firstfloor.org, kenchen@google.com, agl@us.ibm.com, abh@cray.com
Message-Id: <20080520162858.8338.22460.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 0/3] Guarantee faults for processes that call mmap(MAP_PRIVATE) on hugetlbfs v3
Date: Tue, 20 May 2008 17:28:58 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This release is mainly a rebase. Ideally, this would be reviewed from
the perspective of "is this desirable and useful behaviour for hugepage
applications" as well as general correctness. If reactions are positive
or there are no objections, I'll attempt a push towards -mm for wider
testing. As it is, they are passing basic tests as well as a slightly-modified
libhugetlbfs regression test.

Changelog since V2
 o Rebase to 2.6.26-rc2-mm1
 o Document when hugetlb_lock is held for reserve counter updates
 o Add vma_has_private_reserves() helper for clarity

MAP_SHARED mappings on hugetlbfs reserve huge pages at mmap() time.
This guarantees all future faults against the mapping will succeed.
This allows local allocations at first use improving NUMA locality whilst
retaining reliability.

MAP_PRIVATE mappings do not reserve pages. This can result in an application
being SIGKILLed later if a huge page is not available at fault time. This
makes huge pages usage very ill-advised in some cases as the unexpected
application failure cannot be detected and handled as it is immediately fatal.
Although an application may force instantiation of the pages using mlock(),
this may lead to poor memory placement and the process may still be killed
when performing COW.

This patchset introduces a reliability guarantee for the process which creates
a private mapping, i.e. the process that calls mmap() on a hugetlbfs file
successfully.  The first patch of the set is purely mechanical code move to
make later diffs easier to read. The second patch will guarantee faults up
until the process calls fork(). After patch two, as long as the child keeps
the mappings, the parent is no longer guaranteed to be reliable. Patch
3 guarantees that the parent will always successfully COW by unmapping
the pages from the child in the event there are insufficient pages in the
hugepage pool in allocate a new page, be it via a static or dynamic pool.

Existing hugepage-aware applications are unlikely to be affected by this
change. For much of hugetlbfs's history, pages were pre-faulted at mmap()
time or mmap() failed which acts in a reserve-like manner. If the pool
is sized correctly already so that parent and child can fault reliably,
the application will not even notice the reserves. It's only when the pool
is too small for the application to function perfectly reliably that the
reserves come into play.

Credit goes to Andy Whitcroft for cleaning up a number of mistakes during
review before the patches were released.
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
