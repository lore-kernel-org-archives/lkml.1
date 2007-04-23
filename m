Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbXDWUz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbXDWUz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXDWUz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:55:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5062 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbXDWUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:55:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=mIGB1WQl1BgZA8ewVy+hJ3dzjiT4UphaOXLlUbegbrfEq7B2ZRpOVEm/oaNKTUzX7
	1EUNEJMQt7Ko5Ltu1AchQ==
Date: Mon, 23 Apr 2007 13:55:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@engr.sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch -mm v2] cpusets: allow TIF_MEMDIE threads to allocate anywhere
In-Reply-To: <200704232203.13659.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704231354190.19878@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704231235280.18240@chino.kir.corp.google.com>
 <200704232203.13659.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OOM killed tasks have access to memory reserves as specified by the
TIF_MEMDIE flag in the hopes that it will quickly exit.  If such a task
has memory allocations constrained by cpusets, we may encounter a
deadlock if a blocking task cannot exit because it cannot allocate the
necessary memory.

We allow tasks that have the TIF_MEMDIE flag to allocate memory anywhere,
including outside its cpuset restriction, so that it can quickly die
regardless of whether it is __GFP_HARDWALL.

Cc: Andi Kleen <ak@suse.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/cpuset.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2351,6 +2351,8 @@ static const struct cpuset *nearest_exclusive_ancestor(const struct cpuset *cs)
  * z's node is in our tasks mems_allowed, yes.  If it's not a
  * __GFP_HARDWALL request and this zone's nodes is in the nearest
  * mem_exclusive cpuset ancestor to this tasks cpuset, yes.
+ * If the task has been OOM killed and has access to memory reserves
+ * as specified by the TIF_MEMDIE flag, yes.
  * Otherwise, no.
  *
  * If __GFP_HARDWALL is set, cpuset_zone_allowed_softwall()
@@ -2368,7 +2370,8 @@ static const struct cpuset *nearest_exclusive_ancestor(const struct cpuset *cs)
  * calls get to this routine, we should just shut up and say 'yes'.
  *
  * GFP_USER allocations are marked with the __GFP_HARDWALL bit,
- * and do not allow allocations outside the current tasks cpuset.
+ * and do not allow allocations outside the current tasks cpuset
+ * unless the task has been OOM killed as is marked TIF_MEMDIE.
  * GFP_KERNEL allocations are not so marked, so can escape to the
  * nearest enclosing mem_exclusive ancestor cpuset.
  *
@@ -2392,6 +2395,7 @@ static const struct cpuset *nearest_exclusive_ancestor(const struct cpuset *cs)
  * affect that:
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
+ *	TIF_MEMDIE   - any node ok
  *	GFP_KERNEL   - any node in enclosing mem_exclusive cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  *
@@ -2413,6 +2417,12 @@ int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
 	might_sleep_if(!(gfp_mask & __GFP_HARDWALL));
 	if (node_isset(node, current->mems_allowed))
 		return 1;
+	/*
+	 * Allow tasks that have access to memory reserves because they have
+	 * been OOM killed to get memory anywhere.
+	 */
+	if (unlikely(test_thread_flag(TIF_MEMDIE)))
+		return 1;
 	if (gfp_mask & __GFP_HARDWALL)	/* If hardwall request, stop here */
 		return 0;
 
@@ -2438,7 +2448,9 @@ int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask)
  *
  * If we're in interrupt, yes, we can always allocate.
  * If __GFP_THISNODE is set, yes, we can always allocate.  If zone
- * z's node is in our tasks mems_allowed, yes.   Otherwise, no.
+ * z's node is in our tasks mems_allowed, yes.   If the task has been
+ * OOM killed and has access to memory reserves as specified by the
+ * TIF_MEMDIE flag, yes.  Otherwise, no.
  *
  * The __GFP_THISNODE placement logic is really handled elsewhere,
  * by forcibly using a zonelist starting at a specified node, and by
@@ -2462,6 +2474,12 @@ int __cpuset_zone_allowed_hardwall(struct zone *z, gfp_t gfp_mask)
 	node = zone_to_nid(z);
 	if (node_isset(node, current->mems_allowed))
 		return 1;
+        /*
+         * Allow tasks that have access to memory reserves because they have
+         * been OOM killed to get memory anywhere.
+         */
+        if (unlikely(test_thread_flag(TIF_MEMDIE)))
+                return 1;
 	return 0;
 }
 
