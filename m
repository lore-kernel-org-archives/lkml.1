Return-Path: <linux-kernel-owner+w=401wt.eu-S1030683AbXAZAhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683AbXAZAhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030686AbXAZAhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:37:05 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:54382 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030683AbXAZAhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:37:04 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Message-Id: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between movable and non-movable pages
Date: Thu, 25 Jan 2007 23:44:58 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following 8 patches against 2.6.20-rc4-mm1 create a zone called
ZONE_MOVABLE that is only usable by allocations that specify both __GFP_HIGHMEM
and __GFP_MOVABLE. This has the effect of keeping all non-movable pages
within a single memory partition while allowing movable allocations to be
satisified from either partition.

The size of the zone is determined by a kernelcore= parameter specified at
boot-time. This specifies how much memory is usable by non-movable allocations
and the remainder is used for ZONE_MOVABLE. Any range of pages within
ZONE_MOVABLE can be released by migrating the pages or by reclaiming.

When selecting a zone to take pages from for ZONE_MOVABLE, there are two
things to consider. First, only memory from the highest populated zone is
used for ZONE_MOVABLE. On the x86, this is probably going to be ZONE_HIGHMEM
but it would be ZONE_DMA on ppc64 or possibly ZONE_DMA32 on x86_64. Second,
the amount of memory usable by the kernel will be spreadly evenly throughout
NUMA nodes where possible. If the nodes are not of equal size, the amount
of memory usable by the kernel on some nodes may be greater than others.

By default, the zone is not as useful for hugetlb allocations because they
are pinned and non-migratable (currently at least). A sysctl is provided that
allows huge pages to be allocated from that zone. This means that the huge
page pool can be resized to the size of ZONE_MOVABLE during the lifetime of
the system assuming that pages are not mlocked. Despite huge pages being
non-movable, we do not introduce additional external fragmentation of note
as huge pages are always the largest contiguous block we care about.

A lot of credit goes to Andy Whitcroft for catching a large variety of
problems during review of the patches.
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
