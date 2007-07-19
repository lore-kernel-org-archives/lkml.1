Return-Path: <linux-kernel-owner+w=401wt.eu-S938334AbXGSN7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938334AbXGSN7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbXGSNs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:48631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764146AbXGSNsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:54 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: rientjes@google.com, ak@suse.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH for review] [23/48] x86_64: disable srat when numa emulation succeeds
Message-Id: <20070719134853.0E45114E71@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Rientjes <rientjes@google.com>

When NUMA emulation succeeds, acpi_numa needs to be set to -1 so that
srat_disabled() will always return true.  We won't be calling
acpi_scan_nodes() or registering the true nodes we've found.

[hugh@veritas.com: Fix x86_64 CONFIG_NUMA_EMU build: acpi_numa needs CONFIG_ACPI_NUMA]
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/arch/x86_64/mm/numa.c
===================================================================
--- linux.orig/arch/x86_64/mm/numa.c
+++ linux/arch/x86_64/mm/numa.c
@@ -473,9 +473,13 @@ out:
 
 	/*
 	 * We need to vacate all active ranges that may have been registered by
-	 * SRAT.
+	 * SRAT and set acpi_numa to -1 so that srat_disabled() always returns
+	 * true.  NUMA emulation has succeeded so we will not scan ACPI nodes.
 	 */
 	remove_all_active_ranges();
+#ifdef CONFIG_ACPI_NUMA
+	acpi_numa = -1;
+#endif
 	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
