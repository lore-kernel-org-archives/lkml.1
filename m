Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbYFQWpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbYFQWpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbYFQWpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:45:25 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:58033 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439AbYFQWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=C4xJhcRv+V2TiiDOUwG6hQTZPQA12fwT5/+kRdQ30+k8eZ57zBIKfWsdVfm6O0pPT+
         qhsLXL2a6e2OmbEnqedY+9z+JISESRYNjr2IvHd7awylgmS+vRH+fHmoSCCO93P/ukR2
         ndmfk16vYXg7wwyxsAbf2DA/JZeUaB/vSz4ww=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: use acpi_numa_init to parse on 32bit numa
Date: Tue, 17 Jun 2008 15:41:45 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806171002.45836.yhlu.kernel@gmail.com>
In-Reply-To: <200806171002.45836.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806171541.45739.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


seperate that srat finding and parsing from get_memcfg_from_srat.
and let getmemcfg_from_srat only handle array from previous step.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -60,6 +60,7 @@
 #include <asm/setup.h>
 #include <asm/arch_hooks.h>
 #include <asm/sections.h>
+#include <asm/dmi.h>
 #include <asm/io_apic.h>
 #include <asm/ist.h>
 #include <asm/io.h>
@@ -186,6 +187,12 @@ int bootloader_type;
 static unsigned int highmem_pages = -1;
 
 /*
+ * Early DMI memory
+ */
+int dmi_alloc_index;
+char dmi_alloc_data[DMI_MAX_DATA];
+
+/*
  * Setup options
  */
 struct screen_info screen_info;
@@ -787,6 +794,24 @@ void __init setup_arch(char **cmdline_p)
 		max_pfn = e820_end_of_ram();
 	}
 
+	dmi_scan_machine();
+
+	io_delay_init();
+
+#ifdef CONFIG_ACPI
+	/*
+	 * Parse the ACPI tables for possible boot-time SMP configuration.
+	 */
+	acpi_boot_table_init();
+#endif
+
+#ifdef CONFIG_ACPI_NUMA
+        /*
+         * Parse SRAT to discover nodes.
+         */
+        acpi_numa_init();
+#endif
+
 	max_low_pfn = setup_memory();
 
 #ifdef CONFIG_ACPI_SLEEP
@@ -853,21 +878,10 @@ void __init setup_arch(char **cmdline_p)
 
 	paravirt_post_allocator_init();
 
-	dmi_scan_machine();
-
-	io_delay_init();
-
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif
 
-#ifdef CONFIG_ACPI
-	/*
-	 * Parse the ACPI tables for possible boot-time SMP configuration.
-	 */
-	acpi_boot_table_init();
-#endif
-
 	early_quirks();
 
 #ifdef CONFIG_ACPI
Index: linux-2.6/arch/x86/kernel/srat_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/srat_32.c
+++ linux-2.6/arch/x86/kernel/srat_32.c
@@ -42,7 +42,7 @@
 #define BMAP_TEST(bmap, bit)	((bmap)[NODE_ARRAY_INDEX(bit)] & (1 << NODE_ARRAY_OFFSET(bit)))
 /* bitmap length; _PXM is at most 255 */
 #define PXM_BITMAP_LEN (MAX_PXM_DOMAINS / 8) 
-static u8 pxm_bitmap[PXM_BITMAP_LEN];	/* bitmap of proximity domains */
+static u8 __initdata pxm_bitmap[PXM_BITMAP_LEN];	/* bitmap of proximity domains */
 
 #define MAX_CHUNKS_PER_NODE	3
 #define MAXCHUNKS		(MAX_CHUNKS_PER_NODE * MAX_NUMNODES)
@@ -53,16 +53,37 @@ struct node_memory_chunk_s {
 	u8	nid;		// which cnode contains this chunk?
 	u8	bank;		// which mem bank on this node
 };
-static struct node_memory_chunk_s node_memory_chunk[MAXCHUNKS];
+static struct node_memory_chunk_s __initdata node_memory_chunk[MAXCHUNKS];
 
-static int num_memory_chunks;		/* total number of memory chunks */
+static int __initdata num_memory_chunks; /* total number of memory chunks */
 static u8 __initdata apicid_to_pxm[MAX_APICID];
 
+int numa_off __initdata;
+int acpi_numa __initdata;
+
+static __init void bad_srat(void)
+{
+        printk(KERN_ERR "SRAT: SRAT not used.\n");
+        acpi_numa = -1;
+	num_memory_chunks = 0;
+}
+
+static __init inline int srat_disabled(void)
+{
+	return numa_off || acpi_numa < 0;
+}
+
 /* Identify CPU proximity domains */
-static void __init parse_cpu_affinity_structure(char *p)
+void __init
+acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *cpu_affinity)
 {
-	struct acpi_srat_cpu_affinity *cpu_affinity =
-				(struct acpi_srat_cpu_affinity *) p;
+	if (srat_disabled())
+		return;
+	if (cpu_affinity->header.length !=
+	     sizeof(struct acpi_srat_cpu_affinity)) {
+		bad_srat();
+		return;
+	}
 
 	if ((cpu_affinity->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;		/* empty entry */
@@ -80,14 +101,21 @@ static void __init parse_cpu_affinity_st
  * Identify memory proximity domains and hot-remove capabilities.
  * Fill node memory chunk list structure.
  */
-static void __init parse_memory_affinity_structure (char *sratp)
+void __init
+acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *memory_affinity)
 {
 	unsigned long long paddr, size;
 	unsigned long start_pfn, end_pfn;
 	u8 pxm;
 	struct node_memory_chunk_s *p, *q, *pend;
-	struct acpi_srat_mem_affinity *memory_affinity =
-			(struct acpi_srat_mem_affinity *) sratp;
+
+	if (srat_disabled())
+		return;
+	if (memory_affinity->header.length !=
+	     sizeof(struct acpi_srat_mem_affinity)) {
+		bad_srat();
+		return;
+	}
 
 	if ((memory_affinity->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		return;		/* empty entry */
@@ -135,6 +163,14 @@ static void __init parse_memory_affinity
 		 "enabled and removable" : "enabled" ) );
 }
 
+/* Callback for SLIT parsing */
+void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
+{
+}
+
+void acpi_numa_arch_fixup(void)
+{
+}
 /*
  * The SRAT table always lists ascending addresses, so can always
  * assume that the first "start" address that you see is the real
@@ -167,39 +203,13 @@ static __init void node_read_chunk(int n
 		node_end_pfn[nid] = memory_chunk->end_pfn;
 }
 
-/* Parse the ACPI Static Resource Affinity Table */
-static int __init acpi20_parse_srat(struct acpi_table_srat *sratp)
+int __init get_memcfg_from_srat(void)
 {
-	u8 *start, *end, *p;
 	int i, j, nid;
 
-	start = (u8 *)(&(sratp->reserved) + 1);	/* skip header */
-	p = start;
-	end = (u8 *)sratp + sratp->header.length;
-
-	memset(pxm_bitmap, 0, sizeof(pxm_bitmap));	/* init proximity domain bitmap */
-	memset(node_memory_chunk, 0, sizeof(node_memory_chunk));
 
-	num_memory_chunks = 0;
-	while (p < end) {
-		switch (*p) {
-		case ACPI_SRAT_TYPE_CPU_AFFINITY:
-			parse_cpu_affinity_structure(p);
-			break;
-		case ACPI_SRAT_TYPE_MEMORY_AFFINITY:
-			parse_memory_affinity_structure(p);
-			break;
-		default:
-			printk("ACPI 2.0 SRAT: unknown entry skipped: type=0x%02X, len=%d\n", p[0], p[1]);
-			break;
-		}
-		p += p[1];
-		if (p[1] == 0) {
-			printk("acpi20_parse_srat: Entry length value is zero;"
-				" can't parse any further!\n");
-			break;
-		}
-	}
+	if (srat_disabled())
+		goto out_fail;
 
 	if (num_memory_chunks == 0) {
 		printk("could not finy any ACPI SRAT memory areas.\n");
@@ -248,7 +258,7 @@ static int __init acpi20_parse_srat(stru
 		e820_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
- 
+
 	for_each_online_node(nid) {
 		unsigned long start = node_start_pfn[nid];
 		unsigned long end = min(node_end_pfn[nid], max_pfn);
@@ -258,118 +268,6 @@ static int __init acpi20_parse_srat(stru
 	}
 	return 1;
 out_fail:
-	return 0;
-}
-
-struct acpi_static_rsdt {
-	struct acpi_table_rsdt table;
-	u32 padding[32]; /* Allow for 32 more table entries */
-};
-
-int __init get_memcfg_from_srat(void)
-{
-	struct acpi_table_header *header = NULL;
-	struct acpi_table_rsdp *rsdp = NULL;
-	struct acpi_table_rsdt *rsdt = NULL;
-	acpi_native_uint rsdp_address = 0;
-	struct acpi_static_rsdt saved_rsdt;
-	int tables = 0;
-	int i = 0;
-
-	rsdp_address = acpi_os_get_root_pointer();
-	if (!rsdp_address) {
-		printk("%s: System description tables not found\n",
-		       __func__);
-		goto out_err;
-	}
-
-	printk("%s: assigning address to rsdp\n", __func__);
-	rsdp = (struct acpi_table_rsdp *)(u32)rsdp_address;
-	if (!rsdp) {
-		printk("%s: Didn't find ACPI root!\n", __func__);
-		goto out_err;
-	}
-
-	printk(KERN_INFO "%.8s v%d [%.6s]\n", rsdp->signature, rsdp->revision,
-		rsdp->oem_id);
-
-	if (strncmp(rsdp->signature, ACPI_SIG_RSDP,strlen(ACPI_SIG_RSDP))) {
-		printk(KERN_WARNING "%s: RSDP table signature incorrect\n", __func__);
-		goto out_err;
-	}
-
-	rsdt = (struct acpi_table_rsdt *)
-	    early_ioremap(rsdp->rsdt_physical_address, sizeof(saved_rsdt));
-
-	if (!rsdt) {
-		printk(KERN_WARNING
-		       "%s: ACPI: Invalid root system description tables (RSDT)\n",
-		       __func__);
-		goto out_err;
-	}
-
-	header = &rsdt->header;
-
-	if (strncmp(header->signature, ACPI_SIG_RSDT, strlen(ACPI_SIG_RSDT))) {
-		printk(KERN_WARNING "ACPI: RSDT signature incorrect\n");
-		early_iounmap(rsdt, sizeof(saved_rsdt));
-		goto out_err;
-	}
-
-	/* 
-	 * The number of tables is computed by taking the 
-	 * size of all entries (header size minus total 
-	 * size of RSDT) divided by the size of each entry
-	 * (4-byte table pointers).
-	 */
-	tables = (header->length - sizeof(struct acpi_table_header)) / sizeof(u32);
-
-	if (!tables)
-		goto out_err;
-
-	memcpy(&saved_rsdt, rsdt, sizeof(saved_rsdt));
-	early_iounmap(rsdt, sizeof(saved_rsdt));
-	if (saved_rsdt.table.header.length > sizeof(saved_rsdt)) {
-		printk(KERN_WARNING "ACPI: Too big length in RSDT: %d\n",
-		       saved_rsdt.table.header.length);
-		goto out_err;
-	}
-
-	printk("Begin SRAT table scan....%d\n", tables);
-
-	for (i = 0; i < tables; i++){
-		int result;
-		u32 length;
-		/* Map in header, then map in full table length. */
-		header = (struct acpi_table_header *)
-			early_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
-		if (!header)
-			break;
-
-                printk(KERN_INFO "ACPI: %4.4s %08lX, %04X\n",
-                           header->signature,
-		   (unsigned long)saved_rsdt.table.table_offset_entry[i],
-                           header->length);
-
-		if (strncmp((char *) &header->signature, ACPI_SIG_SRAT, 4)) {
-			early_iounmap(header, sizeof(struct acpi_table_header));
-			continue;
-		}
-
-		length = header->length;
-		early_iounmap(header, sizeof(struct acpi_table_header));
-		header = (struct acpi_table_header *)
-			early_ioremap(saved_rsdt.table.table_offset_entry[i], length);
-		if (!header)
-			break;
-
-		/* we've found the srat table. don't need to look at any more tables */
-		result = acpi20_parse_srat((struct acpi_table_srat *)header);
-		early_iounmap(header, length);
-		return result;
-	}
-out_err:
-	remove_all_active_ranges();
 	printk("failed to get NUMA memory information from SRAT table\n");
 	return 0;
 }
Index: linux-2.6/include/asm-x86/acpi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/acpi.h
+++ linux-2.6/include/asm-x86/acpi.h
@@ -161,9 +161,7 @@ struct bootnode;
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
 extern int acpi_scan_nodes(unsigned long start, unsigned long end);
-#ifdef CONFIG_X86_64
-# define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
-#endif
+#define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
 				   int num_nodes);
 #else
Index: linux-2.6/include/asm-x86/dmi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/dmi.h
+++ linux-2.6/include/asm-x86/dmi.h
@@ -3,12 +3,6 @@
 
 #include <asm/io.h>
 
-#ifdef CONFIG_X86_32
-
-#define dmi_alloc alloc_bootmem
-
-#else /* CONFIG_X86_32 */
-
 #define DMI_MAX_DATA 2048
 
 extern int dmi_alloc_index;
@@ -25,8 +19,6 @@ static inline void *dmi_alloc(unsigned l
 	return dmi_alloc_data + idx;
 }
 
-#endif
-
 /* Use early IO mappings for DMI because it's initialized early */
 #define dmi_ioremap early_ioremap
 #define dmi_iounmap early_iounmap
