Return-Path: <linux-kernel-owner+w=401wt.eu-S965320AbXAaPSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320AbXAaPSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965273AbXAaPSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:18:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56086 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344AbXAaPSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:18:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=dFQ1wV5c0ENSwZtF6xSBIndMzMOaamEa/Gi27wMlAiH3Q7HYKttKU/hbLqRuwvmQr
	n1Eg3iwTiUG7bB1d0ZFVQ==
Date: Wed, 31 Jan 2007 07:17:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@osdl.org>
cc: Andi Kleen <ak@suse.de>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 2/7] x86_64: split remaining fake nodes equally
In-Reply-To: <Pine.LNX.4.64.0701302223230.23653@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0701302224300.23658@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0701302223230.23653@chino.kir.corp.google.com>
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

This is beneficial for systems where the exact size of RAM is unknown or
not necessarily relevant, but the granularity with which nodes shall be
allocated is known.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/x86_64/boot-options.txt |    4 +++-
 arch/x86_64/mm/numa.c                 |   22 ++++++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/Documentation/x86_64/boot-options.txt b/Documentation/x86_64/boot-options.txt
index 87f4279..01dfec9 100644
--- a/Documentation/x86_64/boot-options.txt
+++ b/Documentation/x86_64/boot-options.txt
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
diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
index a5bda07..6c4b45f 100644
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -421,11 +421,25 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
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
