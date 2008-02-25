Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYBYPhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYBYPhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbYBYPf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:35:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:37121 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbYBYPfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:35:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=EUzOa0f1zUxDf+DgSXPZBoyxzjaBlZjeP3l62yLA4WrUxgZvmBd9EkVinqb3/50dx
	J0gviFbaie/TO/ongQ+NQ==
Date: Mon, 25 Feb 2008 07:35:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch 6/6] mempolicy: update NUMA memory policy documentation
In-Reply-To: <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802250016380.12368@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates Documentation/vm/numa_memory_policy.txt and
Documentation/filesystems/tmpfs.txt to describe optional mempolicy mode
flags.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/filesystems/tmpfs.txt     |   19 +++++++++++
 Documentation/vm/numa_memory_policy.txt |   54 ++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.txt b/Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt
+++ b/Documentation/filesystems/tmpfs.txt
@@ -92,6 +92,25 @@ NodeList format is a comma-separated list of decimal numbers and ranges,
 a range being two hyphen-separated decimal numbers, the smallest and
 largest node numbers in the range.  For example, mpol=bind:0-3,5,7,9-15
 
+It is possible to specify a static NodeList by appending '=static' to
+the memory policy mode in the mpol= argument.  This will require that
+tasks or VMA's restricted to a subset of allowed nodes are only allowed
+to effect the memory policy over those nodes.  No remapping of the
+NodeList when the policy is rebound, which is the default behavior, is
+allowed when '=static' is specified.  For example:
+
+mpol=bind=static:NodeList	will only allocate from each node in
+				the NodeList without remapping the
+				NodeList if the policy is rebound
+
+It is also possible is to specify a relative NodeList by appending
+'=relative' to the memory policy mode in the mpol= argument.  When the
+allowed nodes of a task or VMA changes, the mempolicy nodemask is
+rebound to maintain the same context as the previously bound nodemask.
+For example, consider a relative mempolicy nodemask of 1-3 for a task
+that is allowed access to nodes 0-4.  If those permissions change to
+allow access to 3-7 instead, the mempolicy nodemask becomes 4-6.
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
@@ -231,6 +233,48 @@ Components of Memory Policies
 	    the temporary interleaved system default policy works in this
 	    mode.
 
+   Linux memory policy supports the following optional mode flag:
+
+	MPOL_F_STATIC_NODES:  This flag specifies that the nodemask passed by
+	the user should not be remapped if the task or VMA's set of accessible
+	nodes changes after the memory policy has been defined.
+
+	    Without this flag, anytime a mempolicy is rebound because of a
+	    change in the set of accessible nodes, the node (Preferred) or
+	    nodemask (Bind, Interleave) is remapped to the new set of
+	    accessible nodes.  This may result in nodes being used that were
+	    previously undesired.  With this flag, the policy is either
+	    effected over the user's specified nodemask or the Default
+	    behavior is used.
+
+	    For example, consider a task that is attached to a cpuset with
+	    mems 1-3 that sets an Interleave policy over the same set.  If
+	    the cpuset's mems change to 3-5, the Interleave will now occur
+	    over nodes 3, 4, and 5.  With this flag, however, since only
+	    node 3 is accessible from the user's nodemask, the "interleave"
+	    only occurs over that node.  If no nodes from the user's
+	    nodemask are now accessible, the Default behavior is used.
+
+	MPOL_F_RELATIVE_NODES:  This flag specifies that the nodemask passed
+	by the user should remain in the same context as it is for the
+	current task or VMA's set of accessible nodes after the memory
+	policy has been defined.
+
+	    Without this flag (and without MPOL_F_STATIC_NODES), anytime a
+	    mempolicy is rebound because of a change in the set of
+	    accessible nodes, the node (Preferred) or nodemask (Bind,
+	    Interleave) is remapped to the new set of accessible nodes.
+	    With this flag, the remap is done to ensure the context of the
+	    previous nodemask with its set of allowed mems is preserved.
+
+	    For example, consider a task that is attached to a cpuset with
+	    mems 1-3 that sets an Interleave policy over the same set.  If
+	    the cpuset's mems change to 3-7, the Interleave will now occur
+	    over nodes 3, 4, and 5.  With this flag, however, since a
+	    nodemask of 1-3 represents the contextually second, third, and
+	    fourth nodes of the allowed mems, the Interleave now occurs
+	    over nodes 4-6.
+
 MEMORY POLICY APIs
 
 Linux supports 3 system calls for controlling memory policy.  These APIS
@@ -251,7 +295,9 @@ Set [Task] Memory Policy:
 	Set's the calling task's "task/process memory policy" to mode
 	specified by the 'mode' argument and the set of nodes defined
 	by 'nmask'.  'nmask' points to a bit mask of node ids containing
-	at least 'maxnode' ids.
+	at least 'maxnode' ids.  Optional mode flags may be passed by
+	combining the 'mode' argument with the flag (for example:
+	MPOL_INTERLEAVE | MPOL_F_STATIC_NODES).
 
 	See the set_mempolicy(2) man page for more details
 
