Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbYBKUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbYBKUJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbYBKUJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:09:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3619 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYBKUJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:09:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=dzkzHyox//XcuxJryWOyW5LjiWiQ625bvTaiUvkunD7PPsdkuHURXMu1kCPnC12Jr
	YF1zkjJu8H4PCaQnwU1gw==
Date: Mon, 11 Feb 2008 12:06:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [patch 4/4 v2] mempolicy: update NUMA memory policy documentation
In-Reply-To: <20080211081053.446a4152.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.00.0802111205040.19986@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507560.11145@chino.kir.corp.google.com>
 <20080211081053.446a4152.randy.dunlap@oracle.com>
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
 Includes fixes to problems identified by Randy Dunlap.

 Documentation/filesystems/tmpfs.txt     |   11 ++++++++
 Documentation/vm/numa_memory_policy.txt |   41 +++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.txt b/Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt
+++ b/Documentation/filesystems/tmpfs.txt
@@ -92,6 +92,17 @@ NodeList format is a comma-separated list of decimal numbers and ranges,
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
@@ -145,7 +147,12 @@ Components of Memory Policies
 
 	Note:  in some functions AND in the struct mempolicy itself, the mode
 	is called "policy".  However, to avoid confusion with the policy tuple,
-	this document will continue to use the term "mode".
+	this document will continue to use the term "mode".  Since the mode and
+	optional mode flags are stored in the same struct mempolicy member
+	(specifically, pol->policy), you must use mpol_mode(pol->policy) to
+	access only the mode and mpol_flags(pol->policy) to access only the
+	flags.  Any function with a formal of type enum mempolicy_mode only
+	refers to the mode.
 
    Linux memory policy supports the following 4 behavioral modes:
 
@@ -231,6 +238,28 @@ Components of Memory Policies
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
 MEMORY POLICY APIs
 
 Linux supports 3 system calls for controlling memory policy.  These APIS
@@ -251,7 +280,9 @@ Set [Task] Memory Policy:
 	Set's the calling task's "task/process memory policy" to mode
 	specified by the 'mode' argument and the set of nodes defined
 	by 'nmask'.  'nmask' points to a bit mask of node ids containing
-	at least 'maxnode' ids.
+	at least 'maxnode' ids.  Optional mode flags may be passed by
+	combining the 'mode' argument with the flag (for example:
+	MPOL_INTERLEAVE | MPOL_F_STATIC_NODES).
 
 	See the set_mempolicy(2) man page for more details
 
