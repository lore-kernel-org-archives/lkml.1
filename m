Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbYGRV22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbYGRV22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYGRV2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:28:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47053 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753003AbYGRV2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:28:21 -0400
Date: Fri, 18 Jul 2008 16:28:18 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] - Earlier detection of system type (UV or non-UV)
Message-ID: <20080718212818.GA13514@sgi.com>
References: <20080709163602.GA12543@sgi.com> <20080718171331.GK6875@elte.hu> <20080718174929.GA981@elte.hu> <20080718183800.GA26109@sgi.com> <20080718201324.GA18198@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718201324.GA18198@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch is coming that requires earlier detection of system type (UV or non-UV)
Move the logic that detects whether running on UV to acpi_boot_table_init().

Signed-off-by: Jack Steiner <steiner@sgi.com>

---

Argggg. The previous was clearly wrong (but it does compile on the version of
gcc that I'm using).

This patch should be ok.



 arch/x86/kernel/acpi/boot.c  |    1 +
 arch/x86/kernel/genapic_64.c |   17 ++++++++++++-----
 arch/x86/mm/srat_64.c        |    2 +-
 include/asm-x86/genapic_32.h |    2 +-
 include/asm-x86/genapic_64.h |    3 +++
 5 files changed, 18 insertions(+), 7 deletions(-)

Index: linux/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/x86/kernel/acpi/boot.c	2008-07-18 15:33:00.000000000 -0500
+++ linux/arch/x86/kernel/acpi/boot.c	2008-07-18 15:33:04.000000000 -0500
@@ -1653,6 +1653,7 @@ int __init acpi_boot_table_init(void)
 		return error;
 	}
 
+	acpi_table_parse(ACPI_SIG_MADT, acpi_early_madt_oem_check);
 	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
 
 	/*
Index: linux/arch/x86/kernel/genapic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/genapic_64.c	2008-07-18 15:33:00.000000000 -0500
+++ linux/arch/x86/kernel/genapic_64.c	2008-07-18 15:33:04.000000000 -0500
@@ -66,16 +66,23 @@ void send_IPI_self(int vector)
 	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
 
-int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+int __init acpi_early_madt_oem_check(struct acpi_table_header *table)
 {
-	if (!strcmp(oem_id, "SGI")) {
-		if (!strcmp(oem_table_id, "UVL"))
+#ifdef CONFIG_ACPI
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
+#endif
+	return 0;
+}
+
+int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
 	return 0;
 }
 
Index: linux/arch/x86/mm/srat_64.c
===================================================================
--- linux.orig/arch/x86/mm/srat_64.c	2008-07-18 15:33:00.000000000 -0500
+++ linux/arch/x86/mm/srat_64.c	2008-07-18 15:33:04.000000000 -0500
@@ -138,7 +138,7 @@ acpi_numa_processor_affinity_init(struct
 		return;
 	}
 
-	if (is_uv_system())
+	if (get_uv_system_type() >= UV_X2APIC)
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
Index: linux/include/asm-x86/genapic_32.h
===================================================================
--- linux.orig/include/asm-x86/genapic_32.h	2008-07-18 15:33:00.000000000 -0500
+++ linux/include/asm-x86/genapic_32.h	2008-07-18 16:22:55.000000000 -0500
@@ -118,6 +118,6 @@ enum uv_system_type {UV_NONE, UV_LEGACY_
 #define get_uv_system_type()		UV_NONE
 #define is_uv_system()			0
 #define uv_wakeup_secondary(a, b)	1
-
+static inline int __init acpi_early_madt_oem_check(struct acpi_table_header *table) { return 0; }
 
 #endif
Index: linux/include/asm-x86/genapic_64.h
===================================================================
--- linux.orig/include/asm-x86/genapic_64.h	2008-07-18 15:33:00.000000000 -0500
+++ linux/include/asm-x86/genapic_64.h	2008-07-18 15:33:04.000000000 -0500
@@ -39,6 +39,9 @@ enum uv_system_type {UV_NONE, UV_LEGACY_
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 
+struct acpi_table_header;
+extern int acpi_early_madt_oem_check(struct acpi_table_header *);
+
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 extern void uv_cpu_init(void);
