Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbXD2LFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbXD2LFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbXD2LBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:52090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbXD2KxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:08 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: David Rientjes <rientjes@google.com>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@engr.sgi.com>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [19/48] x86_64: split remaining fake nodes equally
Message-Id: <20070429105307.E18A915108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Rientjes <rientjes@google.com>

Extends the numa=fake x86_64 command-line option to split the remaining
system memory into equal-sized nodes.

For example:
numa=fake=2*512,4*	gives two 512M nodes and the remaining system
			memory is split into four approximately equal
			chunks.

This is beneficial for systems where the exact size of RAM is unknown or not
necessarily relevant, but the granularity with which nodes shall be allocated
is known.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    4 +++-
 arch/x86_64/mm/numa.c                 |   22 ++++++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

Index: linux/Documentation/x86_64/boot-options.txt
===================================================================
--- linux.orig/Documentation/x86_64/boot-options.txt
+++ linux/Documentation/x86_64/boot-options.txt
@@ -155,7 +155,9 @@ NUMA
 		depending on the sizes and coefficients listed.  For example:
 			numa=fake=2*512,1024,4*256
 		gives two 512M nodes, a 1024M node, and four 256M nodes.  The
-		remaining system RAM is allocated to an additional node.
+		remaining system RAM is allocated to an additional node.  If
+		the last character of CMDLINE is a *, the remaining system RAM
+		is instead divided up equally among its coefficient.
 
   numa=hotadd=percent
 		Only allow hotadd memory to preallocate page structures upto
Index: linux/arch/x86_64/mm/numa.c
===================================================================
--- linux.orig/arch/x86_64/mm/numa.c
+++ linux/arch/x86_64/mm/numa.c
@@ -418,11 +418,25 @@ static int __init numa_emulation(unsigne
 done:
 	if (!num_nodes)
 		return -1;
-	/* Fill remainder of system RAM with a final node, if appropriate. */
+	/* Fill remainder of system RAM, if appropriate. */
 	if (addr < max_addr) {
-		setup_node_range(num_nodes, nodes, &addr, max_addr - addr,
-				 max_addr);
-		num_nodes++;
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
