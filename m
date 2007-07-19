Return-Path: <linux-kernel-owner+w=401wt.eu-S1765151AbXGSJ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765151AbXGSJ6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXGSJyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:33039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXGSJyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:53 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: rientjes@google.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/58] x86_64: various cleanups in NUMA scan node
Message-Id: <20070719095451.3578E14E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Rientjes <rientjes@google.com>
In acpi_scan_nodes(), we immediately return -1 if acpi_numa <= 0, meaning
we haven't detected any underlying ACPI topology or we have explicitly
disabled its use from the command-line with numa=noacpi.

acpi_table_print_srat_entry() and acpi_table_parse_srat() are only
referenced within drivers/acpi/numa.c, so we can mark them as static and
remove their prototypes from the header file.

Likewise, pxm_to_node_map[] and node_to_pxm_map[] are only used within
drivers/acpi/numa.c, so we mark them as static and remove their externs
from the header file.

The automatic 'result' variable is unused in acpi_numa_init(), so it's
removed.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/mm/srat.c |    6 +++---
 drivers/acpi/numa.c   |   20 ++++++++++----------
 include/linux/acpi.h  |    2 --
 3 files changed, 13 insertions(+), 15 deletions(-)

Index: linux/arch/x86_64/mm/srat.c
===================================================================
--- linux.orig/arch/x86_64/mm/srat.c
+++ linux/arch/x86_64/mm/srat.c
@@ -394,6 +394,9 @@ int __init acpi_scan_nodes(unsigned long
 {
 	int i;
 
+	if (acpi_numa <= 0)
+		return -1;
+
 	/* First clean up the node list */
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		cutoff_node(i, start, end);
@@ -403,9 +406,6 @@ int __init acpi_scan_nodes(unsigned long
 		}
 	}
 
-	if (acpi_numa <= 0)
-		return -1;
-
 	if (!nodes_cover_memory()) {
 		bad_srat();
 		return -1;
Index: linux/drivers/acpi/numa.c
===================================================================
--- linux.orig/drivers/acpi/numa.c
+++ linux/drivers/acpi/numa.c
@@ -40,9 +40,9 @@ static nodemask_t nodes_found_map = NODE
 #define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
-static int pxm_to_node_map[MAX_PXM_DOMAINS]
+static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
 				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
-static int node_to_pxm_map[MAX_NUMNODES]
+static int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
 				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
 int pxm_to_node(int pxm)
@@ -83,7 +83,8 @@ void __cpuinit acpi_unmap_pxm_to_node(in
 	node_clear(node, nodes_found_map);
 }
 
-void __init acpi_table_print_srat_entry(struct acpi_subtable_header * header)
+static void __init
+acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 {
 
 	ACPI_FUNCTION_NAME("acpi_table_print_srat_entry");
@@ -200,7 +201,7 @@ static int __init acpi_parse_srat(struct
 	return 0;
 }
 
-int __init
+static int __init
 acpi_table_parse_srat(enum acpi_srat_type id,
 		      acpi_table_entry_handler handler, unsigned int max_entries)
 {
@@ -211,14 +212,13 @@ acpi_table_parse_srat(enum acpi_srat_typ
 
 int __init acpi_numa_init(void)
 {
-	int result;
-
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
-		result = acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-					       acpi_parse_processor_affinity,
-					       NR_CPUS);
-		result = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY, acpi_parse_memory_affinity, NR_NODE_MEMBLKS);	// IA64 specific
+		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
+				      acpi_parse_processor_affinity, NR_CPUS);
+		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+				      acpi_parse_memory_affinity,
+				      NR_NODE_MEMBLKS);
 	}
 
 	/* SLIT: System Locality Information Table */
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -88,10 +88,8 @@ int acpi_table_parse (char *id, acpi_tab
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
 	int entry_id, acpi_table_entry_handler handler, unsigned int max_entries);
 int acpi_table_parse_madt (enum acpi_madt_type id, acpi_table_entry_handler handler, unsigned int max_entries);
-int acpi_table_parse_srat (enum acpi_srat_type id, acpi_table_entry_handler handler, unsigned int max_entries);
 int acpi_parse_mcfg (struct acpi_table_header *header);
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
-void acpi_table_print_srat_entry (struct acpi_subtable_header *srat);
 
 /* the following four functions are architecture-dependent */
 #ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
