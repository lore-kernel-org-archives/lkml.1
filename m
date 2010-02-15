Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0BOVnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 16:43:49 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30095 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0BOVnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:43:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tTOSiDyPvJ2ltbKsOgGhZ8pMRgOVWce16m5ZMnO+M4D4zsSWftwJHJOfC3rsMgX7C
	MMJ7CMGnu0R2kTrQNxMSg==
Date: Mon, 15 Feb 2010 13:43:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/3] x86: remove configurable node size support for numa
 emulation
In-Reply-To: <alpine.DEB.2.00.1002151342230.26927@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1002151343080.26927@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151342230.26927@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that numa=fake=<size>[MG] is implemented, it is possible to remove 
configurable node size support.  The command-line parsing was already
broken (numa=fake=*128, for example, would not work) and since fake nodes
are now interleaved over physical nodes, this support is no longer
required.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/x86/x86_64/boot-options.txt |   16 +---
 arch/x86/mm/numa_64.c                     |  160 +++--------------------------
 2 files changed, 16 insertions(+), 160 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -170,19 +170,9 @@ NUMA
 		If given as a memory unit, fills all system RAM with nodes of
 		size interleaved over physical nodes.
 
-  numa=fake=CMDLINE
-		If a number, fakes CMDLINE nodes and ignores NUMA setup of the
-		actual machine.  Otherwise, system memory is configured
-		depending on the sizes and coefficients listed.  For example:
-			numa=fake=2*512,1024,4*256,*128
-		gives two 512M nodes, a 1024M node, four 256M nodes, and the
-		rest split into 128M chunks.  If the last character of CMDLINE
-		is a *, the remaining memory is divided up equally among its
-		coefficient:
-			numa=fake=2*512,2*
-		gives two 512M nodes and the rest split into two nodes.
-		Otherwise, the remaining system RAM is allocated to an
-		additional node.
+  numa=fake=<N>
+		If given as an integer, fills all system RAM with N fake nodes
+		interleaved over physical nodes.
 
 ACPI
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -598,172 +598,38 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 }
 
 /*
- * Splits num_nodes nodes up equally starting at node_start.  The return value
- * is the number of nodes split up and addr is adjusted to be at the end of the
- * last node allocated.
- */
-static int __init split_nodes_equally(u64 *addr, u64 max_addr, int node_start,
-				      int num_nodes)
-{
-	unsigned int big;
-	u64 size;
-	int i;
-
-	if (num_nodes <= 0)
-		return -1;
-	if (num_nodes > MAX_NUMNODES)
-		num_nodes = MAX_NUMNODES;
-	size = (max_addr - *addr - e820_hole_size(*addr, max_addr)) /
-	       num_nodes;
-	/*
-	 * Calculate the number of big nodes that can be allocated as a result
-	 * of consolidating the leftovers.
-	 */
-	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * num_nodes) /
-	      FAKE_NODE_MIN_SIZE;
-
-	/* Round down to nearest FAKE_NODE_MIN_SIZE. */
-	size &= FAKE_NODE_MIN_HASH_MASK;
-	if (!size) {
-		printk(KERN_ERR "Not enough memory for each node.  "
-		       "NUMA emulation disabled.\n");
-		return -1;
-	}
-
-	for (i = node_start; i < num_nodes + node_start; i++) {
-		u64 end = *addr + size;
-
-		if (i < big)
-			end += FAKE_NODE_MIN_SIZE;
-		/*
-		 * The final node can have the remaining system RAM.  Other
-		 * nodes receive roughly the same amount of available pages.
-		 */
-		if (i == num_nodes + node_start - 1)
-			end = max_addr;
-		else
-			end = find_end_of_node(*addr, max_addr, size);
-		if (setup_node_range(i, addr, end - *addr, max_addr) < 0)
-			break;
-	}
-	return i - node_start + 1;
-}
-
-/*
- * Splits the remaining system RAM into chunks of size.  The remaining memory is
- * always assigned to a final node and can be asymmetric.  Returns the number of
- * nodes split.
- */
-static int __init split_nodes_by_size(u64 *addr, u64 max_addr, int node_start,
-				      u64 size)
-{
-	int i = node_start;
-	size = (size << 20) & FAKE_NODE_MIN_HASH_MASK;
-	while (!setup_node_range(i++, addr, size, max_addr))
-		;
-	return i - node_start;
-}
-
-/*
  * Sets up the system RAM area from start_pfn to last_pfn according to the
  * numa=fake command-line option.
  */
 static int __init numa_emulation(unsigned long start_pfn,
 			unsigned long last_pfn, int acpi, int k8)
 {
-	u64 size, addr = start_pfn << PAGE_SHIFT;
+	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
-	int num_nodes = 0, num = 0, coeff_flag, coeff = -1, i;
 	int num_phys_nodes;
+	int num_nodes;
+	int i;
 
 	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, k8);
 	/*
 	 * If the numa=fake command-line contains a 'M' or 'G', it represents
-	 * the fixed node size.
+	 * the fixed node size.  Otherwise, if it is just a single number N,
+	 * split the system RAM into N fake nodes.
 	 */
 	if (strchr(cmdline, 'M') || strchr(cmdline, 'G')) {
+		u64 size;
+
 		size = memparse(cmdline, &cmdline);
 		num_nodes = split_nodes_size_interleave(addr, max_addr, size);
-		if (num_nodes < 0)
-			return num_nodes;
-		goto out;
-	}
+	} else {
+		unsigned long n;
 
-	/*
-	 * If the numa=fake command-line is just a single number N, split the
-	 * system RAM into N fake nodes.
-	 */
-	if (!strchr(cmdline, '*') && !strchr(cmdline, ',')) {
-		long n = simple_strtol(cmdline, NULL, 0);
-
-		num_nodes = split_nodes_interleave(addr, max_addr,
-							num_phys_nodes, n);
-		if (num_nodes < 0)
-			return num_nodes;
-		goto out;
+		n = simple_strtoul(cmdline, NULL, 0);
+		num_nodes = split_nodes_interleave(addr, max_addr, num_phys_nodes, n);
 	}
 
-	/* Parse the command line. */
-	for (coeff_flag = 0; ; cmdline++) {
-		if (*cmdline && isdigit(*cmdline)) {
-			num = num * 10 + *cmdline - '0';
-			continue;
-		}
-		if (*cmdline == '*') {
-			if (num > 0)
-				coeff = num;
-			coeff_flag = 1;
-		}
-		if (!*cmdline || *cmdline == ',') {
-			if (!coeff_flag)
-				coeff = 1;
-			/*
-			 * Round down to the nearest FAKE_NODE_MIN_SIZE.
-			 * Command-line coefficients are in megabytes.
-			 */
-			size = ((u64)num << 20) & FAKE_NODE_MIN_HASH_MASK;
-			if (size)
-				for (i = 0; i < coeff; i++, num_nodes++)
-					if (setup_node_range(num_nodes, &addr,
-						size, max_addr) < 0)
-						goto done;
-			if (!*cmdline)
-				break;
-			coeff_flag = 0;
-			coeff = -1;
-		}
-		num = 0;
-	}
-done:
-	if (!num_nodes)
-		return -1;
-	/* Fill remainder of system RAM, if appropriate. */
-	if (addr < max_addr) {
-		if (coeff_flag && coeff < 0) {
-			/* Split remaining nodes into num-sized chunks */
-			num_nodes += split_nodes_by_size(&addr, max_addr,
-							 num_nodes, num);
-			goto out;
-		}
-		switch (*(cmdline - 1)) {
-		case '*':
-			/* Split remaining nodes into coeff chunks */
-			if (coeff <= 0)
-				break;
-			num_nodes += split_nodes_equally(&addr, max_addr,
-							 num_nodes, coeff);
-			break;
-		case ',':
-			/* Do not allocate remaining system RAM */
-			break;
-		default:
-			/* Give one final node */
-			setup_node_range(num_nodes, &addr, max_addr - addr,
-					 max_addr);
-			num_nodes++;
-		}
-	}
-out:
+	if (num_nodes < 0)
+		return num_nodes;
 	memnode_shift = compute_hash_shift(nodes, num_nodes, NULL);
 	if (memnode_shift < 0) {
 		memnode_shift = 0;
