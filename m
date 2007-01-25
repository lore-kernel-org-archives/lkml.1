Return-Path: <linux-kernel-owner+w=401wt.eu-S1030592AbXAYVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030592AbXAYVh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030596AbXAYVh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:37:29 -0500
Received: from mx1.cs.washington.edu ([128.208.5.52]:33910 "EHLO
	mx1.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030592AbXAYVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:37:28 -0500
Date: Thu, 25 Jan 2007 13:37:19 -0800 (PST)
From: David Rientjes <rientjes@cs.washington.edu>
To: Andrew Morton <akpm@osdl.org>
cc: Andi Kleen <ak@suse.de>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 3/5] x86_64: fixed-size remaining fake nodes
In-Reply-To: <Pine.LNX.4.64N.0701251333470.13206@attu4.cs.washington.edu>
Message-ID: <Pine.LNX.4.64N.0701251334280.13206@attu4.cs.washington.edu>
References: <Pine.LNX.4.64N.0701251332280.13206@attu4.cs.washington.edu>
 <Pine.LNX.4.64N.0701251333470.13206@attu4.cs.washington.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extends the numa=fake x86_64 command-line option to split the remaining
system memory into nodes of fixed size.  Any leftover memory is allocated
to a final node unless the command-line ends with a comma.

For example:
  numa=fake=2*512,*128	gives two 512M nodes and the remaining system
			memory is split into nodes of 128M each.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@cs.washington.edu>
---
 Documentation/x86_64/boot-options.txt |   15 ++++++----
 arch/x86_64/mm/numa.c                 |   47 ++++++++++++++++++++++++++-------
 2 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/Documentation/x86_64/boot-options.txt b/Documentation/x86_64/boot-options.txt
index 0721416..9917b9f 100644
--- a/Documentation/x86_64/boot-options.txt
+++ b/Documentation/x86_64/boot-options.txt
@@ -153,12 +153,15 @@ NUMA
 		If a number, fakes CMDLINE nodes and ignores NUMA setup of the
 		actual machine.  Otherwise, system memory is configured
 		depending on the sizes and coefficients listed.  For example:
-			numa=fake=2*512,1024,4*256
-		gives two 512M nodes, a 1024M node, and four 256M nodes.  If
-		the last character of CMDLINE is a *, the remaining system
-		memory is divided up equally among its previous coefficient.
-		If the last character is a comma, the remaining system
-		memory is not allocated to an additional node.
+			numa=fake=2*512,1024,4*256,*128
+		gives two 512M nodes, a 1024M node, four 256M nodes, and the
+		rest split into 128M chunks.  If the last character of CMDLINE
+		is a *, the remaining memory is divided up equally among its
+		coefficient:
+			numa=fake=2*512,2*
+		gives two 512M nodes and the rest split into two nodes.  If
+		the last character is a comma, the remaining system memory is
+		not allocated to an additional node.
 
   numa=hotadd=percent
 		Only allow hotadd memory to preallocate page structures upto
diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
index 3344d60..2ee228b 100644
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -359,6 +359,21 @@ static int split_nodes_equally(struct bootnode *nodes, u64 *addr, u64 max_addr,
 }
 
 /*
+ * Splits the remaining system RAM into chunks of size.  The remaining memory is
+ * always assigned to a final node and can be asymmetric.  Returns the number of
+ * nodes split.
+ */
+static int split_nodes_by_size(struct bootnode *nodes, u64 *addr, u64 max_addr,
+			       int node_start, u64 size)
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
@@ -367,9 +382,10 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
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
 
@@ -387,29 +403,34 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
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
 			size = (num << 20) & FAKE_NODE_MIN_HASH_MASK;
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
@@ -417,6 +438,12 @@ done:
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
