Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYIMB4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYIMB4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 21:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYIMB4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 21:56:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:8341 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYIMB4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 21:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SHNTlDFsVd+EfStVJLcPPFwTuKpxTuuw8vV54X4p9Q3at61BEeiGNYh7vEXqTUvWBE
         mqrWkAwsG7OLK6HGCoNioHMC45XvBmX+7ju+L6n3d6DcA0iGwVbSz6TjSePNQYkvtgRs
         Vs1SMp/eGxxFYm/e3SReUE7G/jXeeXhprcr/M=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/2] acpi/x86: introduce __apci_map_table
Date: Fri, 12 Sep 2008 18:55:29 -0700
Message-Id: <1221270930-13057-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to prevent wrongly overwriting fixmap that still want to use.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
---
 arch/ia64/kernel/acpi.c        |    4 ++++
 arch/x86/kernel/acpi/boot.c    |   22 ++++++++++++++++++++--
 arch/x86/kernel/early-quirks.c |    4 +++-
 drivers/acpi/osl.c             |    9 +++++++--
 drivers/acpi/tables.c          |   20 ++++++++++++++------
 drivers/acpi/tables/tbfadt.c   |    1 +
 drivers/acpi/tables/tbutils.c  |    7 +++++++
 drivers/acpi/tables/tbxface.c  |   20 +++++++++++++++++---
 drivers/acpi/tables/tbxfroot.c |    3 +++
 include/acpi/acpiosxf.h        |    1 +
 include/acpi/acpixf.h          |    4 ++++
 include/linux/acpi.h           |    1 +
 12 files changed, 82 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/ia64/kernel/acpi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6/arch/ia64/kernel/acpi.c
@@ -176,6 +176,10 @@ char *__init __acpi_map_table(unsigned l
 	return __va(phys_addr);
 }
 
+char *__init __acpi_unmap_table(unsigned long virt_addr, unsigned long size)
+{
+}
+
 /* --------------------------------------------------------------------------
                             Boot-time Table Parsing
    -------------------------------------------------------------------------- */
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -119,12 +119,15 @@ enum acpi_irq_model_id acpi_irq_model =
  * from the fixed base.  That's why we start at FIX_IO_APIC_BASE_END and
  * count idx down while incrementing the phys address.
  */
+static char *prev_map __initdata;
+static unsigned long prev_size __initdata;
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
-	static char *prev_map;
-	static unsigned long prev_size;
 
 	if (prev_map) {
+		printk(KERN_WARNING "prev_map is not unmaped yet! %p, %lx\n",
+			 prev_map, prev_size);
+		WARN_ON(1);
 		early_iounmap(prev_map, prev_size);
 		prev_map = NULL;
 	}
@@ -137,6 +140,21 @@ char *__init __acpi_map_table(unsigned l
 
 	return prev_map;
 }
+void __init __acpi_unmap_table(char *map, unsigned long size)
+{
+	if (!map || !size)
+		return;
+
+	if (map != prev_map || size != prev_size) {
+		printk(KERN_WARNING "not consistent: prev %p, %lx to %p, %lx\n",
+			prev_map, prev_size, map, size);
+		WARN_ON(1);
+	}
+
+	early_iounmap(map, size);
+	prev_map = NULL;
+	prev_size = 0;
+}
 
 #ifdef CONFIG_PCI_MMCONFIG
 /* The physical address of the MMCONFIG aperture.  Set from ACPI tables. */
Index: linux-2.6/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early-quirks.c
+++ linux-2.6/arch/x86/kernel/early-quirks.c
@@ -100,11 +100,13 @@ static void __init intel_g33_dmar(int nu
 {
 	struct acpi_table_header *dmar_tbl;
 	acpi_status status;
+	acpi_size *tbl_size;
 
-	status = acpi_get_table(ACPI_SIG_DMAR, 0, &dmar_tbl);
+	status = acpi_get_table_with_size(ACPI_SIG_DMAR, 0, &dmar_tbl, &tbl_size);
 	if (ACPI_SUCCESS(status)) {
 		printk(KERN_INFO "BIOS BUG: DMAR advertised on Intel G31/G33 chipset -- ignoring\n");
 		dmar_disabled = 1;
+		early_acpi_os_unmap_memory(dmar_tbl, tbl_size);
 	}
 }
 #endif
Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -285,12 +285,17 @@ EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
 void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
 {
-	if (acpi_gbl_permanent_mmap) {
+	if (acpi_gbl_permanent_mmap)
 		iounmap(virt);
-	}
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
 
+void early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
+{
+	if (!acpi_gbl_permanent_mmap)
+		__acpi_unmap_table(virt, size);
+}
+
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
 acpi_os_get_physical_address(void *virt, acpi_physical_address * phys)
Index: linux-2.6/drivers/acpi/tables.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables.c
+++ linux-2.6/drivers/acpi/tables.c
@@ -181,14 +181,15 @@ acpi_table_parse_entries(char *id,
 	struct acpi_subtable_header *entry;
 	unsigned int count = 0;
 	unsigned long table_end;
+	acpi_size tbl_size;
 
 	if (!handler)
 		return -EINVAL;
 
 	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
-		acpi_get_table(id, acpi_apic_instance, &table_header);
+		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
 	else
-		acpi_get_table(id, 0, &table_header);
+		acpi_get_table_with_size(id, 0, &table_header, &tbl_size);
 
 	if (!table_header) {
 		printk(KERN_WARNING PREFIX "%4.4s not present\n", id);
@@ -206,8 +207,10 @@ acpi_table_parse_entries(char *id,
 	       table_end) {
 		if (entry->type == entry_id
 		    && (!max_entries || count++ < max_entries))
-			if (handler(entry, table_end))
+			if (handler(entry, table_end)) {
+				early_acpi_os_unmap_memory((char *)table_header, tbl_size);
 				return -EINVAL;
+			}
 
 		entry = (struct acpi_subtable_header *)
 		    ((unsigned long)entry + entry->length);
@@ -217,6 +220,7 @@ acpi_table_parse_entries(char *id,
 		       "%i found\n", id, entry_id, count - max_entries, count);
 	}
 
+	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
 	return count;
 }
 
@@ -241,17 +245,19 @@ acpi_table_parse_madt(enum acpi_madt_typ
 int __init acpi_table_parse(char *id, acpi_table_handler handler)
 {
 	struct acpi_table_header *table = NULL;
+	acpi_size tbl_size;
 
 	if (!handler)
 		return -EINVAL;
 
 	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
-		acpi_get_table(id, acpi_apic_instance, &table);
+		acpi_get_table_with_size(id, acpi_apic_instance, &table, &tbl_size);
 	else
-		acpi_get_table(id, 0, &table);
+		acpi_get_table_with_size(id, 0, &table, &tbl_size);
 
 	if (table) {
 		handler(table);
+		early_acpi_os_unmap_memory(table, tbl_size);
 		return 0;
 	} else
 		return 1;
@@ -265,8 +271,9 @@ int __init acpi_table_parse(char *id, ac
 static void __init check_multiple_madt(void)
 {
 	struct acpi_table_header *table = NULL;
+	acpi_size tbl_size;
 
-	acpi_get_table(ACPI_SIG_MADT, 2, &table);
+	acpi_get_table_with_size(ACPI_SIG_MADT, 2, &table, &tbl_size);
 	if (table) {
 		printk(KERN_WARNING PREFIX
 		       "BIOS bug: multiple APIC/MADT found,"
@@ -275,6 +282,7 @@ static void __init check_multiple_madt(v
 		       "If \"acpi_apic_instance=%d\" works better, "
 		       "notify linux-acpi@vger.kernel.org\n",
 		       acpi_apic_instance ? 0 : 2);
+		early_acpi_os_unmap_memory(table, tbl_size);
 
 	} else
 		acpi_apic_instance = 0;
Index: linux-2.6/drivers/acpi/tables/tbfadt.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables/tbfadt.c
+++ linux-2.6/drivers/acpi/tables/tbfadt.c
@@ -189,6 +189,7 @@ void acpi_tb_parse_fadt(u32 table_index,
 	/* All done with the real FADT, unmap it */
 
 	acpi_os_unmap_memory(table, length);
+	early_acpi_os_unmap_memory(table, length);
 
 	/* Obtain the DSDT and FACS tables via their addresses within the FADT */
 
Index: linux-2.6/drivers/acpi/tables/tbutils.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables/tbutils.c
+++ linux-2.6/drivers/acpi/tables/tbutils.c
@@ -82,6 +82,7 @@ acpi_tb_check_xsdt(acpi_physical_address
 
 	length = table->length;
 	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
+	early_acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
 	if (length < sizeof(struct acpi_table_header))
 		return AE_INVALID_TABLE_LENGTH;
 
@@ -104,6 +105,7 @@ acpi_tb_check_xsdt(acpi_physical_address
 		table_entry += sizeof(u64);
 	}
 	acpi_os_unmap_memory(table, length);
+	early_acpi_os_unmap_memory(table, length);
 
 	if (i < table_count)
 		return AE_NULL_ENTRY;
@@ -316,6 +318,7 @@ acpi_tb_install_table(acpi_physical_addr
 
       unmap_and_exit:
 	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
+	early_acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
 }
 
 /*******************************************************************************
@@ -442,6 +445,7 @@ acpi_tb_parse_root_table(acpi_physical_a
 	 * so unmap the RSDP here before mapping other tables
 	 */
 	acpi_os_unmap_memory(rsdp, sizeof(struct acpi_table_rsdp));
+	early_acpi_os_unmap_memory(rsdp, sizeof(struct acpi_table_rsdp));
 
 	if (table_entry_size == sizeof(u64)) {
 		if (acpi_tb_check_xsdt(address) == AE_NULL_ENTRY) {
@@ -465,6 +469,7 @@ acpi_tb_parse_root_table(acpi_physical_a
 
 	length = table->length;
 	acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
+	early_acpi_os_unmap_memory(table, sizeof(struct acpi_table_header));
 
 	if (length < sizeof(struct acpi_table_header)) {
 		ACPI_ERROR((AE_INFO, "Invalid length 0x%X in RSDT/XSDT",
@@ -482,6 +487,7 @@ acpi_tb_parse_root_table(acpi_physical_a
 	status = acpi_tb_verify_checksum(table, length);
 	if (ACPI_FAILURE(status)) {
 		acpi_os_unmap_memory(table, length);
+		early_acpi_os_unmap_memory(table, length);
 		return_ACPI_STATUS(status);
 	}
 
@@ -535,6 +541,7 @@ acpi_tb_parse_root_table(acpi_physical_a
 	 * so unmap the root table here before mapping other tables
 	 */
 	acpi_os_unmap_memory(table, length);
+	early_acpi_os_unmap_memory(table, length);
 
 	/*
 	 * Complete the initialization of the root table array by examining
Index: linux-2.6/drivers/acpi/tables/tbxface.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables/tbxface.c
+++ linux-2.6/drivers/acpi/tables/tbxface.c
@@ -307,6 +307,9 @@ acpi_get_table_header(char *signature,
 				acpi_os_unmap_memory(header,
 						     sizeof(struct
 							    acpi_table_header));
+				early_acpi_os_unmap_memory(header,
+						     sizeof(struct
+							    acpi_table_header));
 			} else {
 				return AE_NOT_FOUND;
 			}
@@ -364,7 +367,7 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_get_table
+ * FUNCTION:    acpi_get_table_with_size
  *
  * PARAMETERS:  Signature           - ACPI signature of needed table
  *              Instance            - Which instance (for SSDTs)
@@ -376,8 +379,9 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
  *
  *****************************************************************************/
 acpi_status
-acpi_get_table(char *signature,
-	       u32 instance, struct acpi_table_header **out_table)
+acpi_get_table_with_size(char *signature,
+	       u32 instance, struct acpi_table_header **out_table,
+	       acpi_size *tbl_size)
 {
        u32 i;
        u32 j;
@@ -407,6 +411,7 @@ acpi_get_table(char *signature,
 		    acpi_tb_verify_table(&acpi_gbl_root_table_list.tables[i]);
 		if (ACPI_SUCCESS(status)) {
 			*out_table = acpi_gbl_root_table_list.tables[i].pointer;
+			*tbl_size = acpi_gbl_root_table_list.tables[i].length;
 		}
 
 		if (!acpi_gbl_permanent_mmap) {
@@ -419,6 +424,15 @@ acpi_get_table(char *signature,
 	return (AE_NOT_FOUND);
 }
 
+acpi_status
+acpi_get_table(char *signature,
+	       u32 instance, struct acpi_table_header **out_table)
+{
+	acpi_size tbl_size;
+
+	return acpi_get_table_with_size(signature,
+		       instance, out_table, &tbl_size);
+}
 ACPI_EXPORT_SYMBOL(acpi_get_table)
 
 /*******************************************************************************
Index: linux-2.6/drivers/acpi/tables/tbxfroot.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables/tbxfroot.c
+++ linux-2.6/drivers/acpi/tables/tbxfroot.c
@@ -145,6 +145,7 @@ acpi_status acpi_find_root_pointer(acpi_
 
 	physical_address <<= 4;
 	acpi_os_unmap_memory(table_ptr, ACPI_EBDA_PTR_LENGTH);
+	early_acpi_os_unmap_memory(table_ptr, ACPI_EBDA_PTR_LENGTH);
 
 	/* EBDA present? */
 
@@ -168,6 +169,7 @@ acpi_status acpi_find_root_pointer(acpi_
 		    acpi_tb_scan_memory_for_rsdp(table_ptr,
 						 ACPI_EBDA_WINDOW_SIZE);
 		acpi_os_unmap_memory(table_ptr, ACPI_EBDA_WINDOW_SIZE);
+		early_acpi_os_unmap_memory(table_ptr, ACPI_EBDA_WINDOW_SIZE);
 
 		if (mem_rover) {
 
@@ -200,6 +202,7 @@ acpi_status acpi_find_root_pointer(acpi_
 	mem_rover =
 	    acpi_tb_scan_memory_for_rsdp(table_ptr, ACPI_HI_RSDP_WINDOW_SIZE);
 	acpi_os_unmap_memory(table_ptr, ACPI_HI_RSDP_WINDOW_SIZE);
+	early_acpi_os_unmap_memory(table_ptr, ACPI_HI_RSDP_WINDOW_SIZE);
 
 	if (mem_rover) {
 
Index: linux-2.6/include/acpi/acpiosxf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpiosxf.h
+++ linux-2.6/include/acpi/acpiosxf.h
@@ -147,6 +147,7 @@ void __iomem *acpi_os_map_memory(acpi_ph
 				acpi_size length);
 
 void acpi_os_unmap_memory(void __iomem * logical_address, acpi_size size);
+void early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size);
 
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
Index: linux-2.6/include/acpi/acpixf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpixf.h
+++ linux-2.6/include/acpi/acpixf.h
@@ -112,6 +112,10 @@ acpi_get_table_header(acpi_string signat
 		      struct acpi_table_header *out_table_header);
 
 acpi_status
+acpi_get_table_with_size(acpi_string signature,
+	       u32 instance, struct acpi_table_header **out_table,
+	       acpi_size *tbl_size);
+acpi_status
 acpi_get_table(acpi_string signature,
 	       u32 instance, struct acpi_table_header **out_table);
 
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -79,6 +79,7 @@ typedef int (*acpi_table_handler) (struc
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+void __init __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
