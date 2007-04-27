Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbXD0GUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbXD0GUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbXD0GUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:20:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38439 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbXD0GUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:20:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=PZ2KUNIkwJn52kkPQdOiEwG8C6g943iI2fXxvadsP4rGjxhO+50BHBjenEOEc0DSB
	iuHKECgT5YJ3GKC/ro1Iw==
Date: Thu, 26 Apr 2007 23:18:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-kernel@vger.kernel.org
Subject: [patch -mm] oom: fix constraint deadlock
Message-ID: <Pine.LNX.4.64.0704262243370.3461@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a deadlock in the OOM killer for allocations that are not
__GFP_HARDWALL.

Before the OOM killer checks for the allocation constraint, it takes
callback_mutex.

constrained_alloc() iterates through each zone in the allocation zonelist
and calls cpuset_zone_allowed_softwall() to determine whether an
allocation for gfp_mask is possible.  If a zone's node is not in the
OOM-triggering task's mems_allowed, it is not exiting, and we did not
fail on a __GFP_HARDWALL allocation, cpuset_zone_allowed_softwall()
attempts to take callback_mutex to check the nearest exclusive ancestor
of current's cpuset.  This results in deadlock.

We now take callback_mutex after iterating through the zonelist since we
don't need it yet.

Cc: Andi Kleen <ak@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Martin J. Bligh <mbligh@mbligh.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -397,6 +397,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 	struct task_struct *p;
 	unsigned long points = 0;
 	unsigned long freed = 0;
+	int constraint;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
@@ -411,14 +412,15 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
 		show_mem();
 	}
 
-	cpuset_lock();
-	read_lock(&tasklist_lock);
-
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
-	switch (constrained_alloc(zonelist, gfp_mask)) {
+	constraint = constrained_alloc(zonelist, gfp_mask);
+	cpuset_lock();
+	read_lock(&tasklist_lock);
+
+	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
 		oom_kill_process(current, points,
 				"No available memory (MPOL_BIND)");
