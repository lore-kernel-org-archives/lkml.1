Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYCHWPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYCHWPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 17:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYCHWPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 17:15:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:19428 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYCHWPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 17:15:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	user-agent:mime-version:content-type;
	b=Xx20v+F0UTgsP7i/1lYYy3uWHtuyKjpa9joLBoYIb/rnFocGWj8lFI9f5hczy2PuD
	CTvNUP/e2F3vLUSn5HRpA==
Date: Sat, 8 Mar 2008 14:14:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch -mm v2] mempolicy: disallow static or relative flags for
 local preferred mode
Message-ID: <alpine.DEB.1.00.0803081409260.12095@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES don't mean anything for
MPOL_PREFERRED policies that were created with an empty nodemask (for
purely local allocations).  They'll never be invalidated because the
allowed mems of a task changes or need to be rebound relative to a
cpuset's placement.

Also fixes a bug identified by Lee Schermerhorn that disallowed empty
nodemasks to be passed to MPOL_PREFERRED to specify local allocations.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/vm/numa_memory_policy.txt |   16 ++++++++++++++--
 mm/mempolicy.c                          |   24 +++++++++++++++++-------
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt
+++ b/Documentation/vm/numa_memory_policy.txt
@@ -210,6 +210,12 @@ Components of Memory Policies
 	    local allocation for a specific range of addresses--i.e. for
 	    VMA policies.
 
+	    It is possible for the user to specify that local allocation is
+	    always preferred by passing an empty nodemask with this mode.
+	    If an empty nodemask is passed, the policy cannot use the
+	    MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES flags described
+	    below.
+
 	MPOL_INTERLEAVED:  This mode specifies that page allocations be
 	interleaved, on a page granularity, across the nodes specified in
 	the policy.  This mode also behaves slightly differently, based on
@@ -259,7 +265,10 @@ Components of Memory Policies
 	    occurs over that node.  If no nodes from the user's nodemask are
 	    now allowed, the Default behavior is used.
 
-	    MPOL_F_STATIC_NODES cannot be used with MPOL_F_RELATIVE_NODES.
+	    MPOL_F_STATIC_NODES cannot be combined with the
+	    MPOL_F_RELATIVE_NODES flag.  It also cannot be used for
+	    MPOL_PREFERRED policies that were created with an empty nodemask
+	    (local allocation).
 
 	MPOL_F_RELATIVE_NODES:  This flag specifies that the nodemask passed
 	by the user will be mapped relative to the set of the task or VMA's
@@ -306,7 +315,10 @@ Components of Memory Policies
 	    set of memory nodes allowed by the task's cpuset, as that may
 	    change over time.
 
-	    MPOL_F_RELATIVE_NODES cannot be used with MPOL_F_STATIC_NODES.
+	    MPOL_F_RELATIVE_NODES cannot be combined with the
+	    MPOL_F_STATIC_NODES flag.  It also cannot be used for
+	    MPOL_PREFERRED policies that were created with an empty nodemask
+	    (local allocation).
 
 MEMORY POLICY APIs
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -151,9 +151,7 @@ static int mpol_new_interleave(struct mempolicy *pol, const nodemask_t *nodes)
 
 static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	if (nodes_empty(*nodes))
-		return -EINVAL;
-	pol->v.preferred_node = first_node(*nodes);
+	pol->v.preferred_node = !nodes_empty(*nodes) ? first_node(*nodes) : -1;
 	return 0;
 }
 
@@ -176,10 +174,22 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
-	if (nodes && nodes_empty(*nodes) && mode != MPOL_PREFERRED)
-		return ERR_PTR(-EINVAL);
-	if (mode == MPOL_DEFAULT)
+	if (mode == MPOL_DEFAULT) {
+		if (nodes && !nodes_empty(*nodes))
+			return ERR_PTR(-EINVAL);
 		return NULL;
+	}
+	/*
+	 * MPOL_PREFERRED cannot be used with MPOL_F_STATIC_NODES or
+	 * MPOL_F_RELATIVE_NODES if the nodemask is empty (local allocation).
+	 * All other modes require a valid pointer to a non-empty nodemask.
+	 */
+	if (mode == MPOL_PREFERRED) {
+		if (nodes_empty(*nodes) && ((flags & MPOL_F_STATIC_NODES) ||
+					    (flags & MPOL_F_RELATIVE_NODES)))
+			return ERR_PTR(-EINVAL);
+	} else if (nodes_empty(*nodes))
+		return ERR_PTR(-EINVAL);
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
@@ -250,7 +260,7 @@ static void mpol_rebind_preferred(struct mempolicy *pol,
 	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 		pol->v.preferred_node = first_node(tmp);
-	} else {
+	} else if (pol->v.preferred_node != -1) {
 		pol->v.preferred_node = node_remap(pol->v.preferred_node,
 						   pol->w.cpuset_mems_allowed,
 						   *nodes);
