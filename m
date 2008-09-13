Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYIMT31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYIMT31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYIMT3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:29:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:35400 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYIMT26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:28:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K/hYzxcCQaShb0kpRvP0DbwS3gErJRaiFZbxzIv14RQFL3YWw1uAhiYnc5gsFwOiwS
         IpbvZHBJdDo1rWZ0+gHkwOAVJYXBA34ypHfJd+0MBTmtjF23NGbNjIY0mpjKHbVY6Jqe
         Bmu91w/t7p6eb7AnLE8SVSMJ/HnET49AnaX50=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/3] acpi/x86: introduce __apci_map_table v3
Date: Sat, 13 Sep 2008 12:28:19 -0700
Message-Id: <1221334101-6464-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221334101-6464-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221334101-6464-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to prevent wrongly overwriting fixmap that still want to use.
v2: remove prev_map and prev_size in __apci_map_table
v3: let acpi_os_unmap_memory() call early_iounmap too, so remove extral calling to
	early_acpi_os_unmap_memory

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
---
 arch/ia64/kernel/acpi.c        |    4 ++++
 arch/x86/kernel/acpi/boot.c    |   17 +++++++----------
 arch/x86/kernel/early-quirks.c |    4 +++-
 drivers/acpi/bus.c             |    6 ------
 drivers/acpi/osl.c             |   11 +++++++++--
 drivers/acpi/tables.c          |   20 ++++++++++++++------
 drivers/acpi/tables/tbxface.c  |   17 ++++++++++++++---
 include/acpi/acpiosxf.h        |    1 +
 include/acpi/acpixf.h          |    4 ++++
 include/linux/acpi.h           |    1 +
 10 files changed, 57 insertions(+), 28 deletions(-)

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
@@ -121,21 +121,18 @@ enum acpi_irq_model_id acpi_irq_model =
  */
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
-	static char *prev_map;
-	static unsigned long prev_size;
-
-	if (prev_map) {
-		early_iounmap(prev_map, prev_size);
-		prev_map = NULL;
-	}
 
 	if (!phys || !size)
 		return NULL;
 
-	prev_size = size;
-	prev_map = early_ioremap(phys, size);
+	return early_ioremap(phys, size);
+}
+void __init __acpi_unmap_table(char *map, unsigned long size)
+{
+	if (!map || !size)
+		return;
 
-	return prev_map;
+	early_iounmap(map, size);
 }
 
 #ifdef CONFIG_PCI_MMCONFIG
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
+		acpi_os_unmap_memory(dmar_tbl, tbl_size);
 	}
 }
 #endif
Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -285,12 +285,19 @@ EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
 void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
 {
-	if (acpi_gbl_permanent_mmap) {
+	if (acpi_gbl_permanent_mmap)
 		iounmap(virt);
-	}
+	else
+		__acpi_unmap_table(virt, size);
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
Index: linux-2.6/drivers/acpi/tables/tbxface.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables/tbxface.c
+++ linux-2.6/drivers/acpi/tables/tbxface.c
@@ -364,7 +364,7 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_get_table
+ * FUNCTION:    acpi_get_table_with_size
  *
  * PARAMETERS:  Signature           - ACPI signature of needed table
  *              Instance            - Which instance (for SSDTs)
@@ -376,8 +376,9 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
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
@@ -407,6 +408,7 @@ acpi_get_table(char *signature,
 		    acpi_tb_verify_table(&acpi_gbl_root_table_list.tables[i]);
 		if (ACPI_SUCCESS(status)) {
 			*out_table = acpi_gbl_root_table_list.tables[i].pointer;
+			*tbl_size = acpi_gbl_root_table_list.tables[i].length;
 		}
 
 		if (!acpi_gbl_permanent_mmap) {
@@ -419,6 +421,15 @@ acpi_get_table(char *signature,
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
Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -650,12 +650,6 @@ void __init acpi_early_init(void)
 	if (!acpi_strict)
 		acpi_gbl_enable_interpreter_slack = TRUE;
 
-	/*
-	 * Doing a zero-sized mapping will clear out the previous
-	 * __acpi_map_table() mapping, if any.
-	 */
-	__acpi_map_table(0, 0);
-
 	acpi_gbl_permanent_mmap = 1;
 
 	status = acpi_reallocate_root_table();
