Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbYJKHBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbYJKHBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYJKGk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:40:57 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:50776 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYJKGgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:54 -0400
Date: Sat, 11 Oct 2008 02:35:41 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 21/85] ACPICA: x2APIC support: changes for MADT and SRAT ACPI
 tables
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <07d9f21fce3c058f628ba264a7eedb1a84f26579.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Support for the x2APIC. There are 2 new subtables for the MADT and
one new subtable for the SRAT. Includes disassembler and acpisrc
support. Data from the Intel 64 Architecture x2APIC Specification,
June 2008.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/acdisasm.h |    4 +++
 include/acpi/actbl1.h   |   51 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/include/acpi/acdisasm.h b/include/acpi/acdisasm.h
index f53faca..0c1ed38 100644
--- a/include/acpi/acdisasm.h
+++ b/include/acpi/acdisasm.h
@@ -186,6 +186,8 @@ extern struct acpi_dmtable_info acpi_dm_table_info_madt5[];
 extern struct acpi_dmtable_info acpi_dm_table_info_madt6[];
 extern struct acpi_dmtable_info acpi_dm_table_info_madt7[];
 extern struct acpi_dmtable_info acpi_dm_table_info_madt8[];
+extern struct acpi_dmtable_info acpi_dm_table_info_madt9[];
+extern struct acpi_dmtable_info acpi_dm_table_info_madt10[];
 extern struct acpi_dmtable_info acpi_dm_table_info_madt_hdr[];
 extern struct acpi_dmtable_info acpi_dm_table_info_mcfg[];
 extern struct acpi_dmtable_info acpi_dm_table_info_mcfg0[];
@@ -197,8 +199,10 @@ extern struct acpi_dmtable_info acpi_dm_table_info_slit[];
 extern struct acpi_dmtable_info acpi_dm_table_info_spcr[];
 extern struct acpi_dmtable_info acpi_dm_table_info_spmi[];
 extern struct acpi_dmtable_info acpi_dm_table_info_srat[];
+extern struct acpi_dmtable_info acpi_dm_table_info_srat_hdr[];
 extern struct acpi_dmtable_info acpi_dm_table_info_srat0[];
 extern struct acpi_dmtable_info acpi_dm_table_info_srat1[];
+extern struct acpi_dmtable_info acpi_dm_table_info_srat2[];
 extern struct acpi_dmtable_info acpi_dm_table_info_tcpa[];
 extern struct acpi_dmtable_info acpi_dm_table_info_wdrt[];
 
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index d38f9be..63f5b4c 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -908,7 +908,9 @@ enum acpi_madt_type {
 	ACPI_MADT_TYPE_IO_SAPIC = 6,
 	ACPI_MADT_TYPE_LOCAL_SAPIC = 7,
 	ACPI_MADT_TYPE_INTERRUPT_SOURCE = 8,
-	ACPI_MADT_TYPE_RESERVED = 9	/* 9 and greater are reserved */
+	ACPI_MADT_TYPE_LOCAL_X2APIC = 9,
+	ACPI_MADT_TYPE_LOCAL_X2APIC_NMI = 10,
+	ACPI_MADT_TYPE_RESERVED = 11	/* 11 and greater are reserved */
 };
 
 /*
@@ -1009,6 +1011,26 @@ struct acpi_madt_interrupt_source {
 
 #define ACPI_MADT_CPEI_OVERRIDE     (1)
 
+/* 9: Processor Local X2_APIC (07/2008) */
+
+struct acpi_madt_local_x2apic {
+	struct acpi_subtable_header header;
+	u16 reserved;		/* Reserved - must be zero */
+	u32 local_apic_id;	/* Processor X2_APIC ID  */
+	u32 lapic_flags;
+	u32 uid;		/* Extended X2_APIC processor ID */
+};
+
+/* 10: Local X2APIC NMI (07/2008) */
+
+struct acpi_madt_local_x2apic_nmi {
+	struct acpi_subtable_header header;
+	u16 inti_flags;
+	u32 uid;		/* Processor X2_APIC ID */
+	u8 lint;		/* LINTn to which NMI is connected */
+	u8 reserved[3];
+};
+
 /*
  * Common flags fields for MADT subtables
  */
@@ -1150,10 +1172,15 @@ struct acpi_table_srat {
 enum acpi_srat_type {
 	ACPI_SRAT_TYPE_CPU_AFFINITY = 0,
 	ACPI_SRAT_TYPE_MEMORY_AFFINITY = 1,
-	ACPI_SRAT_TYPE_RESERVED = 2
+	ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY = 2,
+	ACPI_SRAT_TYPE_RESERVED = 3	/* 3 and greater are reserved */
 };
 
-/* SRAT sub-tables */
+/*
+ * SRAT Sub-tables, correspond to Type in struct acpi_subtable_header
+ */
+
+/* 0: Processor Local APIC/SAPIC Affinity */
 
 struct acpi_srat_cpu_affinity {
 	struct acpi_subtable_header header;
@@ -1165,9 +1192,7 @@ struct acpi_srat_cpu_affinity {
 	u32 reserved;		/* Reserved, must be zero */
 };
 
-/* Flags */
-
-#define ACPI_SRAT_CPU_ENABLED       (1)	/* 00: Use affinity structure */
+/* 1: Memory Affinity */
 
 struct acpi_srat_mem_affinity {
 	struct acpi_subtable_header header;
@@ -1186,6 +1211,20 @@ struct acpi_srat_mem_affinity {
 #define ACPI_SRAT_MEM_HOT_PLUGGABLE (1<<1)	/* 01: Memory region is hot pluggable */
 #define ACPI_SRAT_MEM_NON_VOLATILE  (1<<2)	/* 02: Memory region is non-volatile */
 
+/* 2: Processor Local X2_APIC Affinity (07/2008) */
+
+struct acpi_srat_x2apic_cpu_affinity {
+	struct acpi_subtable_header header;
+	u16 reserved;		/* Reserved, must be zero */
+	u32 proximity_domain;
+	u32 apic_id;
+	u32 flags;
+};
+
+/* Flags for struct acpi_srat_cpu_affinity and struct acpi_srat_x2apic_cpu_affinity */
+
+#define ACPI_SRAT_CPU_ENABLED       (1)	/* 00: Use affinity structure */
+
 /*******************************************************************************
  *
  * TCPA - Trusted Computing Platform Alliance table
-- 
1.5.5.1

