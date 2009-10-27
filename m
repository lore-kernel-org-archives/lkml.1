Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbZJ0TpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbZJ0TpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZJ0TpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:45:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbZJ0TpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:45:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=p3ZEgjQSaut8BLM1caM4RBJ+vRGLyKLUIP8uiW8gCVJ9VDfIfmPrlbHWP87CzNZ1+
	5EDiD9TGDgijBckCNwwtw==
Date: Tue, 27 Oct 2009 12:45:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/8] SGI x86_64 UV: Limit the number of number of SRAT
 messages
In-Reply-To: <4AE710C9.2070307@sgi.com>
Message-ID: <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Mike Travis wrote:

> --- linux.orig/arch/x86/mm/srat_64.c
> +++ linux/arch/x86/mm/srat_64.c
> @@ -115,6 +115,7 @@
> {
> 	int pxm, node;
> 	int apic_id;
> +	static int last_node = -1;
> 
> 	if (srat_disabled())
> 		return;
> @@ -136,8 +137,11 @@
> 	apicid_to_node[apic_id] = node;
> 	node_set(node, cpu_nodes_parsed);
> 	acpi_numa = 1;
> -	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
> -	       pxm, apic_id, node);
> +	if (node > last_node) {
> +		printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
> +		       pxm, apic_id, node);
> +		last_node = node;
> +	}
> }
> 
> /* Callback for Proximity Domain -> LAPIC mapping */
> @@ -146,6 +150,7 @@
> {
> 	int pxm, node;
> 	int apic_id;
> +	static int last_node = -1;
> 
> 	if (srat_disabled())
> 		return;
> @@ -170,8 +175,11 @@
> 	apicid_to_node[apic_id] = node;
> 	node_set(node, cpu_nodes_parsed);
> 	acpi_numa = 1;
> -	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
> -	       pxm, apic_id, node);
> +	if (node > last_node) {
> +		printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
> +		       pxm, apic_id, node);
> +		last_node = node;
> +	}
> }
> 
> #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
> 

So on my Opteron I'll be getting this:

	SRAT: PXM 0 -> APIC 0 -> Node 0
	SRAT: PXM 1 -> APIC 2 -> Node 1

instead of this:

	SRAT: PXM 0 -> APIC 0 -> Node 0
	SRAT: PXM 0 -> APIC 1 -> Node 0
	SRAT: PXM 1 -> APIC 2 -> Node 1
	SRAT: PXM 1 -> APIC 3 -> Node 1

Do I need to infer what apic 1 or 3 map to with your patch (or whether 
they are even valid)?

It would seem much better to print this information once the SRAT parsing 
in acpi_numa_init() is complete and apicid_to_node[] is populated.  This 
leads to the ideal beheavior, which is:

	SRAT: PXM 0 -> APIC {0-1} -> Node 0
	SRAT: PXM 1 -> APIC {2-3} -> Node 1

Something like the following patch?  (Regardless, we need to cc 
linux-acpi@vger.kernel.org.  I've added it.)



x86: reduce srat verbosity in the kernel log

It's possible to reduce the number of SRAT messages emitted to the kernel
log by printing each valid pxm once and then creating bitmaps to represent
the apicids that map to the same node.

This reduces lines such as

	SRAT: PXM 0 -> APIC 0 -> Node 0
	SRAT: PXM 0 -> APIC 1 -> Node 0
	SRAT: PXM 1 -> APIC 2 -> Node 1
	SRAT: PXM 1 -> APIC 3 -> Node 1

to

	SRAT: PXM 0 -> APIC {0-1} -> Node 0
	SRAT: PXM 1 -> APIC {2-3} -> Node 1

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/srat_64.c |   31 +++++++++++++++++++++++++++----
 drivers/acpi/numa.c   |    5 +++++
 include/linux/acpi.h  |    3 ++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -136,8 +136,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -170,8 +168,33 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
+}
+
+void __init acpi_numa_print_srat_mapping(void)
+{
+	DECLARE_BITMAP(apicid_map, MAX_LOCAL_APIC);
+	char apicid_list[MAX_LOCAL_APIC];
+	int i, j;
+
+	for (i = 0; i < MAX_PXM_DOMAINS; i++) {
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
+		bitmap_scnlistprintf(apicid_list, MAX_LOCAL_APIC,
+				     apicid_map, MAX_LOCAL_APIC);
+		pr_info("SRAT: PXM %u -> APIC {%s} -> Node %u\n",
+			i, apicid_list, nid);
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
