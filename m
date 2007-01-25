Return-Path: <linux-kernel-owner+w=401wt.eu-S1030598AbXAYVhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030598AbXAYVhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030597AbXAYVha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:37:30 -0500
Received: from mx1.cs.washington.edu ([128.208.5.52]:33911 "EHLO
	mx1.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030595AbXAYVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:37:28 -0500
Date: Thu, 25 Jan 2007 13:37:15 -0800 (PST)
From: David Rientjes <rientjes@cs.washington.edu>
To: Andrew Morton <akpm@osdl.org>
cc: Andi Kleen <ak@suse.de>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 2/5] x86_64: split remaining fake nodes equally
In-Reply-To: <Pine.LNX.4.64N.0701251332280.13206@attu4.cs.washington.edu>
Message-ID: <Pine.LNX.4.64N.0701251333470.13206@attu4.cs.washington.edu>
References: <Pine.LNX.4.64N.0701251332280.13206@attu4.cs.washington.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Extends the numa=fake x86_64 command-line option to split the remaining
system memory into equal-sized nodes.

For example:
numa=fake=2*512,4*	gives two 512M nodes and the remaining system
			memory is split into four approximately equal
			chunks.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@cs.washington.edu>
---
 Documentation/x86_64/boot-options.txt |    4 +++-
 arch/x86_64/mm/numa.c                 |   24 +++++++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/Documentation/x86_64/boot-options.txt b/Documentation/x86_64/boot-options.txt
index 6ccdb5e..0721416 100644
--- a/Documentation/x86_64/boot-options.txt
+++ b/Documentation/x86_64/boot-options.txt
@@ -155,7 +155,9 @@ NUMA
 		depending on the sizes and coefficients listed.  For example:
 			numa=fake=2*512,1024,4*256
 		gives two 512M nodes, a 1024M node, and four 256M nodes.  If
-		the last character of CMDLINE is a comma, the remaining system
+		the last character of CMDLINE is a *, the remaining system
+		memory is divided up equally among its previous coefficient.
+		If the last character is a comma, the remaining system
 		memory is not allocated to an additional node.
 
   numa=hotadd=percent
diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
index 0417921..3344d60 100644
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -415,11 +415,25 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
 done:
 	if (!num_nodes)
 		return -1;
-	/* Fill remainder of system RAM with a final node, if appropriate. */
-	if (addr < max_addr && *(cmdline - 1) != ',') {
-		setup_node_range(num_nodes, nodes, &addr, max_addr - addr,
-				 max_addr);
-		num_nodes++;
+	/* Fill remainder of system RAM, if appropriate. */
+	if (addr < max_addr) {
+		switch (*(cmdline - 1)) {
+		case '*':
+			/* Split remaining nodes into coeff chunks */
+			if (coeff <= 0)
+				break;
+			num_nodes += split_nodes_equally(nodes, &addr, max_addr,
+							 num_nodes, coeff);
+			break;
+		case ',':
+			/* Do not allocate remaining system RAM */
+			break;
+		default:
+			/* Give one final node */
+			setup_node_range(num_nodes, nodes, &addr,
+					 max_addr - addr, max_addr);
+			num_nodes++;
+		}
 	}
 out:
 	memnode_shift = compute_hash_shift(nodes, num_nodes);
