Return-Path: <linux-kernel-owner+w=401wt.eu-S966011AbXEGQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011AbXEGQfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966001AbXEGQfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:35:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23804 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965888AbXEGQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:35:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=BlLrLX4XFfceO/Q5phoMfO6ceHdD0kP+0ZKxYqkE+g1baHLNcmMhEpAobGEbzMktR
	WC1Cjv5GzZb8fu6LJjD8w==
Date: Mon, 7 May 2007 09:35:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [patch 4/4] x86_64 numa: fake apicid_to_node mapping for fake numa
In-Reply-To: <Pine.LNX.4.64.0705070030170.1899@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705070030380.1899@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705070028560.1899@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705070029570.1899@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705070030170.1899@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we are in the emulated NUMA case, we need to make sure that all
existing apicid_to_node mappings that point to real node ID's now point
to the equivalent fake node ID's.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86_64/mm/srat.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/mm/srat.c b/arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -472,7 +472,7 @@ static int __init find_node_by_addr(const struct bootnode *nodes,
  */
 void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 {
-	int i;
+	int i, j;
 
 	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
 			 "topology.\n");
@@ -486,6 +486,13 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		if (nid == NUMA_NO_NODE)
 			continue;
 		__acpi_map_pxm_to_node(pxm, nid);
+		/*
+		 * For each apicid-to-node mapping that exists for this real
+		 * node, it must now point to the fake node ID.
+		 */
+		for (j = 0; j < MAX_LOCAL_APIC; j++)
+			if (apicid_to_node[j] == i)
+				apicid_to_node[j] = nid;
 	}
 
 	nodes_clear(nodes_parsed);
