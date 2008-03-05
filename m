Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYCEWT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYCEWT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764267AbYCEWRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:17:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:25706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764240AbYCEWRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:17:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=B6slzhDIMQSJuSaVgYve8u63YrdOYvEgKeywjlf+qQ9bbsRFtJVcdberOr/p1MhKL
	xBbj7vyns3Z6M09BQWyIw==
Date: Wed, 5 Mar 2008 14:16:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch -mm 6/6] mempolicy: update NUMA memory policy documentation
In-Reply-To: <alpine.DEB.1.00.0803051343410.29841@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0803051344050.29841@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803051340540.29841@chino.kir.corp.google.com> <alpine.DEB.1.00.0803051342010.29841@chino.kir.corp.google.com> <alpine.DEB.1.00.0803051342260.29841@chino.kir.corp.google.com> <alpine.DEB.1.00.0803051342490.29841@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0803051343410.29841@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates Documentation/vm/numa_memory_policy.txt and
Documentation/filesystems/tmpfs.txt to describe optional mempolicy mode
flags.

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Paul Jackson <pj@sgi.com>
---
 Documentation/filesystems/tmpfs.txt     |   12 +++
 Documentation/vm/numa_memory_policy.txt |  131 +++++++++++++++++++++++-------
 2 files changed, 112 insertions(+), 31 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.txt b/Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt
+++ b/Documentation/filesystems/tmpfs.txt
@@ -92,6 +92,18 @@ NodeList format is a comma-separated list of decimal numbers and ranges,
 a range being two hyphen-separated decimal numbers, the smallest and
 largest node numbers in the range.  For example, mpol=bind:0-3,5,7,9-15
 
+NUMA memory allocation policies have optional flags that can be used in
+conjunction with their modes.  These optional flags can be specified
+when tmpfs is mounted by appending them to the mode before the NodeList.
+See Documentation/vm/numa_memory_policy.txt for a list of all available
+memory allocation policy mode flags.
+
+	=static		is equivalent to	MPOL_F_STATIC_NODES
+	=relative	is equivalent to	MPOL_F_RELATIVE_NODES
+
+For example, mpol=bind=static:NodeList, is the equivalent of an
+allocation policy of MPOL_BIND | MPOL_F_STATIC_NODES.
+
 Note that trying to mount a tmpfs with an mpol option will fail if the
 running kernel does not support NUMA; and will fail if its nodelist
 specifies a node which is not online.  If your system relies on that
diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt
+++ b/Documentation/vm/numa_memory_policy.txt
@@ -135,9 +135,11 @@ most general to most specific:
 
 Components of Memory Policies
 
-    A Linux memory policy is a tuple consisting of a "mode" and an optional set
-    of nodes.  The mode determine the behavior of the policy, while the
-    optional set of nodes can be viewed as the arguments to the behavior.
+    A Linux memory policy consists of a "mode", optional mode flags, and an
+    optional set of nodes.  The mode determines the behavior of the policy,
+    the optional mode flags determine the behavior of the mode, and the
+    optional set of nodes can be viewed as the arguments to the policy
+    behavior.
 
    Internally, memory policies are implemented by a reference counted
    structure, struct mempolicy.  Details of this structure will be discussed
@@ -179,7 +181,8 @@ Components of Memory Policies
 	    on a non-shared region of the address space.  However, see
 	    MPOL_PREFERRED below.
 
-	    The Default mode does not use the optional set of nodes.
+	    It is an error for the set of nodes specified for this policy to
+	    be non-empty.
 
 	MPOL_BIND:  This mode specifies that memory must come from the
 	set of nodes specified by the policy.
@@ -231,6 +234,80 @@ Components of Memory Policies
 	    the temporary interleaved system default policy works in this
 	    mode.
 
+   Linux memory policy supports the following optional mode flags:
+
+	MPOL_F_STATIC_NODES:  This flag specifies that the nodemask passed by
+	the user should not be remapped if the task or VMA's set of allowed
+	nodes changes after the memory policy has been defined.
+
+	    Without this flag, anytime a mempolicy is rebound because of a
+	    change in the set of allowed nodes, the node (Preferred) or
+	    nodemask (Bind, Interleave) is remapped to the new set of
+	    allowed nodes.  This may result in nodes being used that were
+	    previously undesired.
+
+	    With this flag, if the user-specified nodes overlap with the
+	    nodes allowed by the task's cpuset, then the memory policy is
+	    applied to their intersection.  If the two sets of nodes do not
+	    overlap, the Default policy is used.
+
+	    For example, consider a task that is attached to a cpuset with
+	    mems 1-3 that sets an Interleave policy over the same set.  If
+	    the cpuset's mems change to 3-5, the Interleave will now occur
+	    over nodes 3, 4, and 5.  With this flag, however, since only node
+	    3 is allowed from the user's nodemask, the "interleave" only
+	    occurs over that node.  If no nodes from the user's nodemask are
+	    now allowed, the Default behavior is used.
+
+	    MPOL_F_STATIC_NODES cannot be used with MPOL_F_RELATIVE_NODES.
+
+	MPOL_F_RELATIVE_NODES:  This flag specifies that the nodemask passed
+	by the user will be mapped relative to the set of the task or VMA's
+	set of allowed nodes.  The kernel stores the user-passed nodemask,
+	and if the allowed nodes changes, then that original nodemask will
+	be remapped relative to the new set of allowed nodes.
+
+	    Without this flag (and without MPOL_F_STATIC_NODES), anytime a
+	    mempolicy is rebound because of a change in the set of allowed
+	    nodes, the node (Preferred) or nodemask (Bind, Interleave) is
+	    remapped to the new set of allowed nodes.  That remap may not
+	    preserve the relative nature of the user's passed nodemask to its
+	    set of allowed nodes upon successive rebinds: a nodemask of
+	    1,3,5 may be remapped to 7-9 and then to 1-3 if the set of
+	    allowed nodes is restored to its original state.
+
+	    With this flag, the remap is done so that the node numbers from
+	    the user's passed nodemask are relative to the set of allowed
+	    nodes.  In other words, if nodes 0, 2, and 4 are set in the user's
+	    nodemask, the policy will be effected over the first (and in the
+	    Bind or Interleave case, the third and fifth) nodes in the set of
+	    allowed nodes.  The nodemask passed by the user represents nodes
+	    relative to task or VMA's set of allowed nodes.
+
+	    If the user's nodemask includes nodes that are outside the range
+	    of the new set of allowed nodes (for example, node 5 is set in
+	    the user's nodemask when the set of allowed nodes is only 0-3),
+	    then the remap wraps around to the beginning of the nodemask and,
+	    if not already set, sets the node in the mempolicy nodemask.
+
+	    For example, consider a task that is attached to a cpuset with
+	    mems 2-5 that sets an Interleave policy over the same set with
+	    MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
+	    interleave now occurs over nodes 3,5-6.  If the cpuset's mems
+	    then change to 0,2-3,5, then the interleave occurs over nodes
+	    0,3,5.
+
+	    Thanks to the consistent remapping, applications preparing
+	    nodemasks to specify memory policies using this flag should
+	    disregard their current, actual cpuset imposed memory placement
+	    and prepare the nodemask as if they were always located on
+	    memory nodes 0 to N-1, where N is the number of memory nodes the
+	    policy is intended to manage.  Let the kernel then remap to the
+	    set of memory nodes allowed by the task's cpuset, as that may
+	    change over time.
+
+	    MPOL_F_RELATIVE_NODES cannot be used with MPOL_F_STATIC_NODES.
+
 MEMORY POLICY APIs
 
 Linux supports 3 system calls for controlling memory policy.  These APIS
@@ -251,7 +328,9 @@ Set [Task] Memory Policy:
 	Set's the calling task's "task/process memory policy" to mode
 	specified by the 'mode' argument and the set of nodes defined
 	by 'nmask'.  'nmask' points to a bit mask of node ids containing
-	at least 'maxnode' ids.
+	at least 'maxnode' ids.  Optional mode flags may be passed by
+	combining the 'mode' argument with the flag (for example:
+	MPOL_INTERLEAVE | MPOL_F_STATIC_NODES).
 
 	See the set_mempolicy(2) man page for more details
 
@@ -303,29 +382,19 @@ MEMORY POLICIES AND CPUSETS
 Memory policies work within cpusets as described above.  For memory policies
 that require a node or set of nodes, the nodes are restricted to the set of
 nodes whose memories are allowed by the cpuset constraints.  If the nodemask
-specified for the policy contains nodes that are not allowed by the cpuset, or
-the intersection of the set of nodes specified for the policy and the set of
-nodes with memory is the empty set, the policy is considered invalid
-and cannot be installed.
-
-The interaction of memory policies and cpusets can be problematic for a
-couple of reasons:
-
-1) the memory policy APIs take physical node id's as arguments.  As mentioned
-   above, it is illegal to specify nodes that are not allowed in the cpuset.
-   The application must query the allowed nodes using the get_mempolicy()
-   API with the MPOL_F_MEMS_ALLOWED flag to determine the allowed nodes and
-   restrict itself to those nodes.  However, the resources available to a
-   cpuset can be changed by the system administrator, or a workload manager
-   application, at any time.  So, a task may still get errors attempting to
-   specify policy nodes, and must query the allowed memories again.
-
-2) when tasks in two cpusets share access to a memory region, such as shared
-   memory segments created by shmget() of mmap() with the MAP_ANONYMOUS and
-   MAP_SHARED flags, and any of the tasks install shared policy on the region,
-   only nodes whose memories are allowed in both cpusets may be used in the
-   policies.  Obtaining this information requires "stepping outside" the
-   memory policy APIs to use the cpuset information and requires that one
-   know in what cpusets other task might be attaching to the shared region.
-   Furthermore, if the cpusets' allowed memory sets are disjoint, "local"
-   allocation is the only valid policy.
+specified for the policy contains nodes that are not allowed by the cpuset and
+MPOL_F_RELATIVE_NODES is not used, the intersection of the set of nodes
+specified for the policy and the set of nodes with memory is used.  If the
+result is the empty set, the policy is considered invalid and cannot be
+installed.  If MPOL_F_RELATIVE_NODES is used, the policy's nodes are mapped
+onto and folded into the task's set of allowed nodes as previously described.
+
+The interaction of memory policies and cpusets can be problematic when tasks
+in two cpusets share access to a memory region, such as shared memory segments
+created by shmget() of mmap() with the MAP_ANONYMOUS and MAP_SHARED flags, and
+any of the tasks install shared policy on the region, only nodes whose
+memories are allowed in both cpusets may be used in the policies.  Obtaining
+this information requires "stepping outside" the memory policy APIs to use the
+cpuset information and requires that one know in what cpusets other task might
+be attaching to the shared region.  Furthermore, if the cpusets' allowed
+memory sets are disjoint, "local" allocation is the only valid policy.
