Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYGIQgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYGIQgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYGIQgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:36:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35110 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751455AbYGIQgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:36:10 -0400
Date: Wed, 9 Jul 2008 11:36:02 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Earlier detection of system type (UV or non-UV)
Message-ID: <20080709163602.GA12543@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch is coming that requires earlier detection of system type (UV or non-UV)
Move the logic that detects whether running on UV to acpi_boot_table_init().

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/acpi/boot.c  |    4 ++++
 arch/x86/kernel/genapic_64.c |   15 ++++++++++-----
 arch/x86/mm/srat_64.c        |    2 +-
 include/asm-x86/genapic_64.h |    3 +++
 4 files changed, 18 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/x86/kernel/acpi/boot.c	2008-07-09 11:14:03.000000000 -0500
+++ linux/arch/x86/kernel/acpi/boot.c	2008-07-09 11:14:33.000000000 -0500
@@ -1712,6 +1712,10 @@ int __init acpi_boot_table_init(void)
 		return error;
 	}
 
+#ifdef CONFIG_X86_64
+	acpi_table_parse(ACPI_SIG_MADT, acpi_early_madt_oem_check);
+#endif
+
 	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
 
 	/*
Index: linux/arch/x86/kernel/genapic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/genapic_64.c	2008-07-09 11:14:03.000000000 -0500
+++ linux/arch/x86/kernel/genapic_64.c	2008-07-09 11:14:33.000000000 -0500
@@ -66,19 +66,24 @@ void send_IPI_self(int vector)
 	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
 
-int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+int __init acpi_early_madt_oem_check(struct acpi_table_header *table)
 {
-	if (!strcmp(oem_id, "SGI")) {
-		if (!strcmp(oem_table_id, "UVL"))
+	if (!strcmp(table->oem_id, "SGI")) {
+		if (!strcmp(table->oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
-		else if (!strcmp(oem_table_id, "UVX"))
+		else if (!strcmp(table->oem_table_id, "UVX"))
 			uv_system_type = UV_X2APIC;
-		else if (!strcmp(oem_table_id, "UVH"))
+		else if (!strcmp(table->oem_table_id, "UVH"))
 			uv_system_type = UV_NON_UNIQUE_APIC;
 	}
 	return 0;
 }
 
+int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return 0;
+}
+
 unsigned int read_apic_id(void)
 {
 	unsigned int id;
Index: linux/include/asm-x86/genapic_64.h
===================================================================
--- linux.orig/include/asm-x86/genapic_64.h	2008-07-09 11:14:03.000000000 -0500
+++ linux/include/asm-x86/genapic_64.h	2008-07-09 11:14:33.000000000 -0500
@@ -39,6 +39,9 @@ enum uv_system_type {UV_NONE, UV_LEGACY_
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 
+struct acpi_table_header;
+extern int acpi_early_madt_oem_check(struct acpi_table_header *);
+
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 extern void uv_cpu_init(void);
Index: linux/arch/x86/mm/srat_64.c
===================================================================
--- linux.orig/arch/x86/mm/srat_64.c	2008-07-09 11:14:02.000000000 -0500
+++ linux/arch/x86/mm/srat_64.c	2008-07-09 11:14:33.000000000 -0500
@@ -126,7 +126,7 @@ acpi_numa_processor_affinity_init(struct
 		return;
 	}
 
-	if (is_uv_system())
+	if (get_uv_system_type() >= UV_X2APIC)
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
