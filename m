Return-Path: <linux-kernel-owner+w=401wt.eu-S965959AbXEGQfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959AbXEGQfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965888AbXEGQfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:35:16 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965949AbXEGQfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:35:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Ums9h0StChUlp0JPXqGExZi5JedTZpfWQf1lxhJ17TuZFFH/3fxhX4h06MAiI7ODw
	4y4EPSlHaNxFBP8rJ73Qg==
Date: Mon, 7 May 2007 09:35:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [patch 2/4] x86_64 acpi: various cleanups
In-Reply-To: <Pine.LNX.4.64.0705070028560.1899@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705070029570.1899@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705070028560.1899@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86_64/mm/srat.c    |    6 +++---
 drivers/acpi/numa.c      |   20 ++++++++++----------
 include/acpi/acpi_numa.h |    3 ---
 include/linux/acpi.h     |    2 --
 4 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86_64/mm/srat.c b/arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -394,6 +394,9 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 {
 	int i;
 
+	if (acpi_numa <= 0)
+		return -1;
+
 	/* First clean up the node list */
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		cutoff_node(i, start, end);
@@ -403,9 +406,6 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		}
 	}
 
-	if (acpi_numa <= 0)
-		return -1;
-
 	if (!nodes_cover_memory()) {
 		disable_srat();
 		return -1;
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -40,9 +40,9 @@ static nodemask_t nodes_found_map = NODE_MASK_NONE;
 #define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
-int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
+static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
 				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
-int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
+static int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
 				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
 int __cpuinit pxm_to_node(int pxm)
@@ -83,7 +83,8 @@ void __cpuinit acpi_unmap_pxm_to_node(int node)
 	node_clear(node, nodes_found_map);
 }
 
-void __init acpi_table_print_srat_entry(struct acpi_subtable_header * header)
+static void __init
+acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 {
 
 	ACPI_FUNCTION_NAME("acpi_table_print_srat_entry");
@@ -200,7 +201,7 @@ static int __init acpi_parse_srat(struct acpi_table_header *table)
 	return 0;
 }
 
-int __init
+static int __init
 acpi_table_parse_srat(enum acpi_srat_type id,
 		      acpi_table_entry_handler handler, unsigned int max_entries)
 {
@@ -211,14 +212,13 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 
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
diff --git a/include/acpi/acpi_numa.h b/include/acpi/acpi_numa.h
--- a/include/acpi/acpi_numa.h
+++ b/include/acpi/acpi_numa.h
@@ -11,9 +11,6 @@
 #define MAX_PXM_DOMAINS (256) /* Old pxm spec is defined 8 bit */
 #endif
 
-extern int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS];
-extern int __cpuinitdata node_to_pxm_map[MAX_NUMNODES];
-
 extern int __cpuinit pxm_to_node(int);
 extern int __cpuinit node_to_pxm(int);
 extern int __cpuinit acpi_map_pxm_to_node(int);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -88,10 +88,8 @@ int acpi_table_parse (char *id, acpi_table_handler handler);
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
 	int entry_id, acpi_table_entry_handler handler, unsigned int max_entries);
 int acpi_table_parse_madt (enum acpi_madt_type id, acpi_table_entry_handler handler, unsigned int max_entries);
-int acpi_table_parse_srat (enum acpi_srat_type id, acpi_table_entry_handler handler, unsigned int max_entries);
 int acpi_parse_mcfg (struct acpi_table_header *header);
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
-void acpi_table_print_srat_entry (struct acpi_subtable_header *srat);
 
 /* the following four functions are architecture-dependent */
 #ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
