Return-Path: <linux-kernel-owner+w=401wt.eu-S934334AbXEUTck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334AbXEUTck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765499AbXEUTWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:22:04 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46461 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765491AbXEUTWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:22:01 -0400
Message-Id: <20070521191708.395609000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, npiggin@suse.de,
       clameter@engr.sgi.com, ak@suse.de, mbligh@mbligh.org,
       rientjes@google.com
Subject: [patch 14/69] oom: fix constraint deadlock
Content-Disposition: inline; filename=oom-fix-constraint-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Rientjes <rientjes@google.com>

Fixes a deadlock in the OOM killer for allocations that are not
__GFP_HARDWALL.

Before the OOM killer checks for the allocation constraint, it takes
callback_mutex.

constrained_alloc() iterates through each zone in the allocation zonelist
and calls cpuset_zone_allowed_softwall() to determine whether an allocation
for gfp_mask is possible.  If a zone's node is not in the OOM-triggering
task's mems_allowed, it is not exiting, and we did not fail on a
__GFP_HARDWALL allocation, cpuset_zone_allowed_softwall() attempts to take
callback_mutex to check the nearest exclusive ancestor of current's cpuset.
 This results in deadlock.

We now take callback_mutex after iterating through the zonelist since we
don't need it yet.

Cc: Andi Kleen <ak@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Martin J. Bligh <mbligh@mbligh.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 mm/oom_kill.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.21.1.orig/mm/oom_kill.c
+++ linux-2.6.21.1/mm/oom_kill.c
@@ -397,6 +397,7 @@ void out_of_memory(struct zonelist *zone
 	struct task_struct *p;
 	unsigned long points = 0;
 	unsigned long freed = 0;
+	int constraint;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
@@ -411,14 +412,15 @@ void out_of_memory(struct zonelist *zone
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

-- 
