Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYE2X0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYE2X0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYE2X0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:26:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:14129 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbYE2X0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LKIFBtLwedDJfHff7btJtjE7DAA95j/mjaZuheinkdnEaK7xXtWgs63XDdE7pd2lFl2rxOM7fCaDMjQX7M4qXs3OwKcc9fc6Pv2kDiDltgmgHRkbBnehowRaaCHxWKCj4rR6SUKE94juKvjU6CCFlE6siL4Vku+7xLlLvwCRdZM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: 32bit numa srat fix early_ioremap leak
Date: Thu, 29 May 2008 16:25:56 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com>
In-Reply-To: <200805251000.10205.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291625.56942.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


on two node system (16g RAM) with numa config got

get_memcfg_from_srat: assigning address to rsdp
RSD PTR  v0 [ACPIAM]
ACPI: Too big length in RSDT: 92
failed to get NUMA memory information from SRAT table
NUMA - single node, flat memory mode
Node: 0, start_pfn: 0, end_pfn: 153
 Setting physnode_map array to node 0 for pfns:
 0
...
Pid: 0, comm: swapper Not tainted 2.6.26-rc4 #4
 [<80b41289>] hlt_loop+0x0/0x3
 [<8011efa0>] ? alloc_remap+0x50/0x70
 [<8079e32e>] alloc_node_mem_map+0x5e/0xa0
 [<8012e77b>] ? printk+0x1b/0x20
 [<80b590f6>] free_area_init_node+0xc6/0x470
 [<80b588fc>] ? __alloc_bootmem_node+0x2c/0x50
 [<80b58ad8>] ? find_min_pfn_for_node+0x38/0x70
 [<8012e77b>] ? printk+0x1b/0x20
 [<80b597c4>] free_area_init_nodes+0x254/0x2d0
 [<80b544d7>] zone_sizes_init+0x97/0xa0
 [<80b48a03>] setup_arch+0x383/0x530
 [<8012e77b>] ? printk+0x1b/0x20
 [<80b41aa4>] start_kernel+0x64/0x350
 [<80b412d8>] i386_start_kernel+0x8/0x10
 =======================

this patch increase the acpi table limit to 32
match early_ioremap with early_iounmap

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/srat_32.c b/arch/x86/kernel/srat_32.c
index 70e4a37..88971ee 100644
--- a/arch/x86/kernel/srat_32.c
+++ b/arch/x86/kernel/srat_32.c
@@ -261,7 +261,7 @@ out_fail:
 
 struct acpi_static_rsdt {
 	struct acpi_table_rsdt table;
-	u32 padding[7]; /* Allow for 7 more table entries */
+	u32 padding[32]; /* Allow for 32 more table entries */
 };
 
 int __init get_memcfg_from_srat(void)
@@ -297,7 +297,7 @@ int __init get_memcfg_from_srat(void)
 	}
 
 	rsdt = (struct acpi_table_rsdt *)
-	    early_ioremap(rsdp->rsdt_physical_address, sizeof(struct acpi_table_rsdt));
+	    early_ioremap(rsdp->rsdt_physical_address, sizeof(saved_rsdt));
 
 	if (!rsdt) {
 		printk(KERN_WARNING
@@ -310,6 +310,7 @@ int __init get_memcfg_from_srat(void)
 
 	if (strncmp(header->signature, ACPI_SIG_RSDT, strlen(ACPI_SIG_RSDT))) {
 		printk(KERN_WARNING "ACPI: RSDT signature incorrect\n");
+		early_iounmap(rsdt, sizeof(saved_rsdt));
 		goto out_err;
 	}
 
@@ -319,37 +320,51 @@ int __init get_memcfg_from_srat(void)
 	 * size of RSDT) divided by the size of each entry
 	 * (4-byte table pointers).
 	 */
-	tables = (header->length - sizeof(struct acpi_table_header)) / 4;
+	tables = (header->length - sizeof(struct acpi_table_header)) / sizeof(u32);
 
 	if (!tables)
 		goto out_err;
 
 	memcpy(&saved_rsdt, rsdt, sizeof(saved_rsdt));
-
+	early_iounmap(rsdt, sizeof(saved_rsdt));
 	if (saved_rsdt.table.header.length > sizeof(saved_rsdt)) {
 		printk(KERN_WARNING "ACPI: Too big length in RSDT: %d\n",
 		       saved_rsdt.table.header.length);
 		goto out_err;
 	}
 
-	printk("Begin SRAT table scan....\n");
+	printk("Begin SRAT table scan....%d\n", tables);
 
-	for (i = 0; i < tables; i++) {
+	for (i = 0; i < tables; i++){
+		int result;
+		u32 length;
 		/* Map in header, then map in full table length. */
 		header = (struct acpi_table_header *)
 			early_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
 		if (!header)
 			break;
+
+                printk(KERN_INFO "ACPI: %4.4s %08lX, %04X\n",
+                           header->signature,
+		   (unsigned long)saved_rsdt.table.table_offset_entry[i],
+                           header->length);
+
+		if (strncmp((char *) &header->signature, ACPI_SIG_SRAT, 4)) {
+			early_iounmap(header, sizeof(struct acpi_table_header));
+			continue;
+		}
+
+		length = header->length;
+		early_iounmap(header, sizeof(struct acpi_table_header));
 		header = (struct acpi_table_header *)
-			early_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
+			early_ioremap(saved_rsdt.table.table_offset_entry[i], length);
 		if (!header)
 			break;
 
-		if (strncmp((char *) &header->signature, ACPI_SIG_SRAT, 4))
-			continue;
-
 		/* we've found the srat table. don't need to look at any more tables */
-		return acpi20_parse_srat((struct acpi_table_srat *)header);
+		result = acpi20_parse_srat((struct acpi_table_srat *)header);
+		early_iounmap(header, length);
+		return result;
 	}
 out_err:
 	remove_all_active_ranges();
