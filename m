Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbXD2LFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbXD2LFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXD2LAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:00:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:51281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbXD2KxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:10 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: David Rientjes <rientjes@google.com>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@engr.sgi.com>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [20/48] x86_64: fixed size remaining fake nodes
Message-Id: <20070429105309.0307515108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Rientjes <rientjes@google.com>

Extends the numa=fake x86_64 command-line option to split the remaining system
memory into nodes of fixed size.  Any leftover memory is allocated to a final
node unless the command-line ends with a comma.

For example:
  numa=fake=2*512,*128	gives two 512M nodes and the remaining system
			memory is split into nodes of 128M each.

This is beneficial for systems where the exact size of RAM is unknown or not
necessarily relevant, but the size of the remaining nodes to be allocated is
known based on their capacity for resource management.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |   14 ++++++----
 arch/x86_64/mm/numa.c                 |   47 ++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 15 deletions(-)

Index: linux/Documentation/x86_64/boot-options.txt
===================================================================
--- linux.orig/Documentation/x86_64/boot-options.txt
+++ linux/Documentation/x86_64/boot-options.txt
@@ -153,11 +153,15 @@ NUMA
 		If a number, fakes CMDLINE nodes and ignores NUMA setup of the
 		actual machine.  Otherwise, system memory is configured
 		depending on the sizes and coefficients listed.  For example:
-			numa=fake=2*512,1024,4*256
-		gives two 512M nodes, a 1024M node, and four 256M nodes.  The
-		remaining system RAM is allocated to an additional node.  If
-		the last character of CMDLINE is a *, the remaining system RAM
-		is instead divided up equally among its coefficient.
+			numa=fake=2*512,1024,4*256,*128
+		gives two 512M nodes, a 1024M node, four 256M nodes, and the
+		rest split into 128M chunks.  If the last character of CMDLINE
+		is a *, the remaining memory is divided up equally among its
+		coefficient:
+			numa=fake=2*512,2*
+		gives two 512M nodes and the rest split into two nodes.
+		Otherwise, the remaining system RAM is allocated to an
+		additional node.
 
   numa=hotadd=percent
 		Only allow hotadd memory to preallocate page structures upto
Index: linux/arch/x86_64/mm/numa.c
===================================================================
--- linux.orig/arch/x86_64/mm/numa.c
+++ linux/arch/x86_64/mm/numa.c
@@ -362,6 +362,21 @@ static int __init split_nodes_equally(st
 }
 
 /*
+ * Splits the remaining system RAM into chunks of size.  The remaining memory is
+ * always assigned to a final node and can be asymmetric.  Returns the number of
+ * nodes split.
+ */
+static int __init split_nodes_by_size(struct bootnode *nodes, u64 *addr,
+				      u64 max_addr, int node_start, u64 size)
+{
+	int i = node_start;
+	size = (size << 20) & FAKE_NODE_MIN_HASH_MASK;
+	while (!setup_node_range(i++, nodes, addr, size, max_addr))
+		;
+	return i - node_start;
+}
+
+/*
  * Sets up the system RAM area from start_pfn to end_pfn according to the
  * numa=fake command-line option.
  */
@@ -370,9 +385,10 @@ static int __init numa_emulation(unsigne
 	struct bootnode nodes[MAX_NUMNODES];
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = end_pfn << PAGE_SHIFT;
-	unsigned int coeff;
-	unsigned int num = 0;
 	int num_nodes = 0;
+	int coeff_flag;
+	int coeff = -1;
+	int num = 0;
 	u64 size;
 	int i;
 
@@ -390,29 +406,34 @@ static int __init numa_emulation(unsigne
 	}
 
 	/* Parse the command line. */
-	for (coeff = 1; ; cmdline++) {
+	for (coeff_flag = 0; ; cmdline++) {
 		if (*cmdline && isdigit(*cmdline)) {
 			num = num * 10 + *cmdline - '0';
 			continue;
 		}
-		if (*cmdline == '*')
-			coeff = num;
+		if (*cmdline == '*') {
+			if (num > 0)
+				coeff = num;
+			coeff_flag = 1;
+		}
 		if (!*cmdline || *cmdline == ',') {
+			if (!coeff_flag)
+				coeff = 1;
 			/*
 			 * Round down to the nearest FAKE_NODE_MIN_SIZE.
 			 * Command-line coefficients are in megabytes.
 			 */
 			size = ((u64)num << 20) & FAKE_NODE_MIN_HASH_MASK;
-			if (size) {
+			if (size)
 				for (i = 0; i < coeff; i++, num_nodes++)
 					if (setup_node_range(num_nodes, nodes,
 						&addr, size, max_addr) < 0)
 						goto done;
-				coeff = 1;
-			}
+			if (!*cmdline)
+				break;
+			coeff_flag = 0;
+			coeff = -1;
 		}
-		if (!*cmdline)
-			break;
 		num = 0;
 	}
 done:
@@ -420,6 +441,12 @@ done:
 		return -1;
 	/* Fill remainder of system RAM, if appropriate. */
 	if (addr < max_addr) {
+		if (coeff_flag && coeff < 0) {
+			/* Split remaining nodes into num-sized chunks */
+			num_nodes += split_nodes_by_size(nodes, &addr, max_addr,
+							 num_nodes, num);
+			goto out;
+		}
 		switch (*(cmdline - 1)) {
 		case '*':
 			/* Split remaining nodes into coeff chunks */
