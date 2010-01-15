Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab0AOHmP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 02:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899Ab0AOHmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 02:42:10 -0500
Received: from mga10.intel.com ([192.55.52.92]:47425 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751962Ab0AOHmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 02:42:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,281,1262592000"; 
   d="scan'208";a="764453149"
Message-ID: <4B501C4D.4080907@linux.intel.com>
Date: Fri, 15 Jan 2010 15:42:05 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/mm/srat_64.c: nodes_parsed should include all nodes detected
 by ACPI.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to fix the bug discussed in email thread: http://patchwork.kernel.org/patch/69499/.

Currently node_possible_map won't include the offlined node that has neither CPU onlined nor MEM 
onlined at booting time. As a result, nr_node_ids won't be equal to possible nodes.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
  arch/x86/mm/srat_64.c |   10 ++--------
  1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a271241..a5bc297 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -238,7 +238,7 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
  void __init
  acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
  {
-	struct bootnode *nd, oldnode;
+	struct bootnode *nd;
  	unsigned long start, end;
  	int node, pxm;
  	int i;
@@ -277,7 +277,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
  		return;
  	}
  	nd = &nodes[node];
-	oldnode = *nd;
  	if (!node_test_and_set(node, nodes_parsed)) {
  		nd->start = start;
  		nd->end = end;
@@ -291,13 +290,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
  	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
  	       start, end);

-	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
+	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)
  		update_nodes_add(node, start, end);
-		/* restore nodes[node] */
-		*nd = oldnode;
-		if ((nd->start | nd->end) == 0)
-			node_clear(node, nodes_parsed);
-	}

  	node_memblk_range[num_node_memblks].start = start;
  	node_memblk_range[num_node_memblks].end = end;
