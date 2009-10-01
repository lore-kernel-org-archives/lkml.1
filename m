Return-Path: <linux-kernel-owner+w=401wt.eu-S932540AbZJAOLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbZJAOLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZJAOL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:11:29 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47988 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbZJAOFG (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Thu, 1 Oct 2009 10:05:06 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [09/31] mm: system wide ALLOC_NO_WATERMARK
Date: Thu,  1 Oct 2009 19:36:20 +0530
Message-Id: <1254405980-15976-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl> 

The reserve is proportionally distributed over all (!highmem) zones in the
system. So we need to allow an emergency allocation access to all zones. In
order to do that we need to break out of any mempolicy boundaries we might
have.

In my opinion that does not break mempolicies as those are user oriented
and not system oriented. That is, system allocations are not guaranteed to be
within mempolicy boundaries. For instance IRQs don't even have a mempolicy.

So breaking out of mempolicy boundaries for 'rare' emergency allocations,
which are always system allocations (as opposed to user) is ok.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: mmotm/mm/page_alloc.c
===================================================================
--- mmotm.orig/mm/page_alloc.c
+++ mmotm/mm/page_alloc.c
@@ -1775,6 +1775,11 @@ restart:
 rebalance:
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
+		/*
+		 * break out mempolicy boundaries
+		 */
+		zonelist = node_zonelist(numa_node_id(), gfp_mask);
+
 		page = __alloc_pages_high_priority(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
