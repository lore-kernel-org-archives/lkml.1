Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZKLUsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZKLUsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZKLUsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:48:42 -0500
Received: from smtp-out.google.com ([216.239.33.17]:4810 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbZKLUsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:48:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JmsUL3QjbaSwOFicp33WDlH3YHFAmUYzLTOJ58LqpsBn95q2NjgC+2B+a1louBJGo
	5+6guYrFt144RTcNMvHMg==
Date: Thu, 12 Nov 2009 12:48:33 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Mike Travis <travis@sgi.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] x86: reduce srat verbosity in the kernel log
In-Reply-To: <20091112171934.584037000@alcatraz.americas.sgi.com>
Message-ID: <alpine.DEB.2.00.0911121247420.9544@chino.kir.corp.google.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible to reduce the number of SRAT messages emitted to the kernel
log by printing each valid pxm once and then creating bitmaps to represent
the apic ids that map to the same node.

This reduces lines such as

	SRAT: PXM 0 -> APIC 0 -> Node 0
	SRAT: PXM 0 -> APIC 1 -> Node 0
	SRAT: PXM 1 -> APIC 2 -> Node 1
	SRAT: PXM 1 -> APIC 3 -> Node 1

to

	SRAT: PXM 0 -> APIC {0-1} -> Node 0
	SRAT: PXM 1 -> APIC {2-3} -> Node 1

The buffer used to store the apic id list is 128 characters in length.
If that is too small to represent all the apic id ranges that are bound
to a single pxm, a trailing "..." is added.  APICID_LIST_LEN should be
manually increased for such configurations.

Acked-by: Mike Travis <travis@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/srat_64.c |   41 +++++++++++++++++++++++++++++++++++++----
 drivers/acpi/numa.c   |    5 +++++
 include/linux/acpi.h  |    3 ++-
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -36,6 +36,9 @@ static int num_node_memblks __initdata;
 static struct bootnode node_memblk_range[NR_NODE_MEMBLKS] __initdata;
 static int memblk_nodeid[NR_NODE_MEMBLKS] __initdata;
 
+static DECLARE_BITMAP(apicid_map, MAX_LOCAL_APIC) __initdata;
+#define APICID_LIST_LEN	(128)
+
 static __init int setup_node(int pxm)
 {
 	return acpi_map_pxm_to_node(pxm);
@@ -136,8 +139,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -170,8 +171,40 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
+}
+
+void __init acpi_numa_print_srat_mapping(void)
+{
+	char apicid_list[APICID_LIST_LEN];
+	int i, j;
+
+	for (i = 0; i < MAX_PXM_DOMAINS; i++) {
+		int len;
+		int nid;
+
+		nid = pxm_to_node(i);
+		if (nid == NUMA_NO_NODE)
+			continue;
+
+		bitmap_zero(apicid_map, MAX_LOCAL_APIC);
+		for (j = 0; j < MAX_LOCAL_APIC; j++)
+			if (apicid_to_node[j] == nid)
+				set_bit(j, apicid_map);
+
+		if (bitmap_empty(apicid_map, MAX_LOCAL_APIC))
+			continue;
+
+		/*
+		 * If the bitmap cannot be listed in a buffer of length
+		 * APICID_LIST_LEN, then it is suffixed with "...".
+		 */
+		len = bitmap_scnlistprintf(apicid_list, APICID_LIST_LEN,
+					   apicid_map, MAX_LOCAL_APIC);
+		pr_info("SRAT: PXM %u -> APIC {%s%s} -> Node %u\n",
+			i, apicid_list,
+			(len == APICID_LIST_LEN - 1) ? "..." : "",
+			nid);
+	}
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -281,6 +281,10 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 					    handler, max_entries);
 }
 
+void __init __attribute__((weak)) acpi_numa_print_srat_mapping(void)
+{
+}
+
 int __init acpi_numa_init(void)
 {
 	/* SRAT: Static Resource Affinity Table */
@@ -292,6 +296,7 @@ int __init acpi_numa_init(void)
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 				      acpi_parse_memory_affinity,
 				      NR_NODE_MEMBLKS);
+		acpi_numa_print_srat_mapping();
 	}
 
 	/* SLIT: System Locality Information Table */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -92,12 +92,13 @@ int acpi_table_parse_madt (enum acpi_madt_type id, acpi_table_entry_handler hand
 int acpi_parse_mcfg (struct acpi_table_header *header);
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
 
-/* the following four functions are architecture-dependent */
+/* the following six functions are architecture-dependent */
 void acpi_numa_slit_init (struct acpi_table_slit *slit);
 void acpi_numa_processor_affinity_init (struct acpi_srat_cpu_affinity *pa);
 void acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa);
 void acpi_numa_memory_affinity_init (struct acpi_srat_mem_affinity *ma);
 void acpi_numa_arch_fixup(void);
+void acpi_numa_print_srat_mapping(void);
 
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 /* Arch dependent functions for cpu hotplug support */
