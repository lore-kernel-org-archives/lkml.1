Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYIWS2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYIWS2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYIWS2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:28:21 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44280 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751205AbYIWS2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:28:20 -0400
Date: Tue, 23 Sep 2008 13:28:17 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Add early detection of UV system types
Message-ID: <20080923182817.GA6335@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Portions of system boot needs to know if a system is a UV system prior
to genapic initialization. This patch adds a call from acpi_boot_table_init()
to the UV code to parse the MADT to determine if the system is a UV system.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/acpi/boot.c      |    4 ++++
 arch/x86/kernel/genx2apic_uv_x.c |   21 ++++++++++++---------
 arch/x86/mm/srat_64.c            |    2 +-
 include/asm-x86/genapic_64.h     |    2 ++
 4 files changed, 19 insertions(+), 10 deletions(-)

Index: linux/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/x86/kernel/acpi/boot.c	2008-09-23 12:55:15.000000000 -0500
+++ linux/arch/x86/kernel/acpi/boot.c	2008-09-23 12:55:19.000000000 -0500
@@ -1667,6 +1667,10 @@ int __init acpi_boot_table_init(void)
 
 	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
 
+#ifdef CONFIG_X86_64
+	acpi_table_parse(ACPI_SIG_MADT, uv_early_madt_oem_check);
+#endif
+
 	/*
 	 * blacklist may disable ACPI entirely
 	 */
Index: linux/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-09-23 12:55:19.000000000 -0500
+++ linux/arch/x86/kernel/genx2apic_uv_x.c	2008-09-23 12:56:15.000000000 -0500
@@ -18,6 +18,7 @@
 #include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
+#include <linux/acpi.h>
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
@@ -25,26 +26,28 @@
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
-
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
 
-static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+int __init uv_early_madt_oem_check(struct acpi_table_header *table)
 {
-	if (!strcmp(oem_id, "SGI")) {
-		if (!strcmp(oem_table_id, "UVL"))
+	if (!strcmp(table->oem_id, "SGI")) {
+		if (!strcmp(table->oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
-		else if (!strcmp(oem_table_id, "UVX"))
+		else if (!strcmp(table->oem_table_id, "UVX"))
 			uv_system_type = UV_X2APIC;
-		else if (!strcmp(oem_table_id, "UVH")) {
+		else if (!strcmp(table->oem_table_id, "UVH"))
 			uv_system_type = UV_NON_UNIQUE_APIC;
-			return 1;
-		}
 	}
 	return 0;
 }
 
+static int is_uv_apic(char *oem_id, char *oem_table_id)
+{
+	return uv_system_type == UV_NON_UNIQUE_APIC;
+}
+
 enum uv_system_type get_uv_system_type(void)
 {
 	return uv_system_type;
@@ -211,7 +214,7 @@ static void uv_send_IPI_self(int vector)
 
 struct genapic apic_x2apic_uv_x = {
 	.name = "UV large system",
-	.acpi_madt_oem_check = uv_acpi_madt_oem_check,
+	.acpi_madt_oem_check = is_uv_apic,
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = uv_target_cpus,
Index: linux/arch/x86/mm/srat_64.c
===================================================================
--- linux.orig/arch/x86/mm/srat_64.c	2008-09-23 12:55:15.000000000 -0500
+++ linux/arch/x86/mm/srat_64.c	2008-09-23 12:55:19.000000000 -0500
@@ -138,7 +138,7 @@ acpi_numa_processor_affinity_init(struct
 		return;
 	}
 
-	if (is_uv_system())
+	if (get_uv_system_type() >= UV_X2APIC)
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
Index: linux/include/asm-x86/genapic_64.h
===================================================================
--- linux.orig/include/asm-x86/genapic_64.h	2008-09-23 12:55:15.000000000 -0500
+++ linux/include/asm-x86/genapic_64.h	2008-09-23 12:55:19.000000000 -0500
@@ -46,6 +46,8 @@ extern void apic_send_IPI_self(int vecto
 enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
+struct acpi_table_header;
+extern int uv_early_madt_oem_check(struct acpi_table_header *table);
 
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
