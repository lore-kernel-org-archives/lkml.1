Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYBGIcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYBGIcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYBGIcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:32:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45597 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbYBGIcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:32:13 -0500
Date: Thu, 07 Feb 2008 17:31:37 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [2.6.24 regression][BUGFIX] numactl --interleave=all doesn't works on memoryless node.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       torvalds@linux-foundation.org, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <1202319495.5453.64.camel@localhost>
References: <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1202319495.5453.64.camel@localhost>
Message-Id: <20080207172045.4AED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee-san

Unfortunately, 2.6.24-mm1 can't boot on fujitsu machine.
(hmm, origin.patch cause regression to pci initialization ;-)

instead, I tested 2.6.24 + your patch.
it seem work good :)

Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

and, I have a bit comment.


>  /* Do sanity checking on a policy */
> -static int mpol_check_policy(int mode, nodemask_t *nodes)
> +static int mpol_check_policy(int mode, nodemask_t *nodes, int was_empty)

was_empty argument is a bit ugly.
Could we unify mpol_check_policy and contextualize_policy?
mpol_check_policy only called from contextualize_policy.

> - 	return nodes_subset(*nodes, node_states[N_HIGH_MEMORY]) ? 0 : -EINVAL;
> + 	return 0;

Could we N_POSSIBLE check?

I attached the patch for my idea explain.
on my test environment, your patch and mine works good both.

- kosaki


---
 mm/mempolicy.c |   47 +++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

Index: b/mm/mempolicy.c
===================================================================
--- a/mm/mempolicy.c	2008-02-07 17:19:09.000000000 +0900
+++ b/mm/mempolicy.c	2008-02-07 17:24:28.000000000 +0900
@@ -114,9 +114,25 @@ static void mpol_rebind_policy(struct me
                                const nodemask_t *newmask);
 
 /* Do sanity checking on a policy */
-static int mpol_check_policy(int mode, nodemask_t *nodes, int was_empty)
+static int mpol_check_policy(int mode, nodemask_t *nodes)
 {
-	int is_empty = nodes_empty(*nodes);
+	int was_empty;
+	int is_empty;
+
+	if (!nodes)
+		return 0;
+
+	/*
+	 * Remember whether in coming nodemask was empty,  If not,
+	 * restrict the nodes to the allowed nodes in the cpuset.
+	 * This is guaranteed to be a subset of nodes with memory.
+	 */
+	cpuset_update_task_memory_state();
+	was_empty = nodes_empty(*nodes);
+	if (!was_empty)
+		nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
+
+	is_empty = nodes_empty(*nodes);
 
 	switch (mode) {
 	case MPOL_DEFAULT:
@@ -144,7 +160,7 @@ static int mpol_check_policy(int mode, n
 			return -EINVAL;
 		break;
 	}
- 	return 0;
+ 	return nodes_subset(*nodes, node_states[N_POSSIBLE]) ? 0 : -EINVAL;
 }
 
 /* Generate a custom zonelist for the BIND policy. */
@@ -432,27 +448,6 @@ static int mbind_range(struct vm_area_st
 	return err;
 }
 
-static int contextualize_policy(int mode, nodemask_t *nodes)
-{
-	int was_empty;
-
-	if (!nodes)
-		return 0;
-
-	/*
-	 * Remember whether in coming nodemask was empty,  If not,
-	 * restrict the nodes to the allowed nodes in the cpuset.
-	 * This is guaranteed to be a subset of nodes with memory.
-	 */
-	cpuset_update_task_memory_state();
-	was_empty = nodes_empty(*nodes);
-	if (!was_empty)
-		nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
-
-	return mpol_check_policy(mode, nodes, was_empty);
-}
-
-
 /*
  * Update task->flags PF_MEMPOLICY bit: set iff non-default
  * mempolicy.  Allows more rapid checking of this (combined perhaps
@@ -488,7 +483,7 @@ static long do_set_mempolicy(int mode, n
 {
 	struct mempolicy *new;
 
-	if (contextualize_policy(mode, nodes))
+	if (mpol_check_policy(mode, nodes))
 		return -EINVAL;
 	new = mpol_new(mode, nodes);
 	if (IS_ERR(new))
@@ -817,7 +812,7 @@ static long do_mbind(unsigned long start
 	if (end == start)
 		return 0;
 
-	if (contextualize_policy(mode, nmask))
+	if (mpol_check_policy(mode, nmask))
 		return -EINVAL;
 
 	new = mpol_new(mode, nmask);


