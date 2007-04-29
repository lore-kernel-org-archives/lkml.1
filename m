Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbXD2LCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbXD2LCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbXD2LB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:01:29 -0400
Received: from mail.suse.de ([195.135.220.2]:52036 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbXD2Kw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:52:57 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [8/48] i386: modpost apic related warning fixes
Message-Id: <20070429105256.27825151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:52:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>

o Modpost generates warnings for i386 if compiled with CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.text:find_unisys_acpi_oem_table from .text between 'acpi_madt_oem_check' (at offset 0xc0101eda) and 'enable_apic_mode'
WARNING: vmlinux - Section mismatch: reference to .init.text:acpi_get_table_header_early from .text between 'acpi_madt_oem_check' (at offset 0xc0101ef0) and 'enable_apic_mode'
WARNING: vmlinux - Section mismatch: reference to .init.text:parse_unisys_oem from .text between 'acpi_madt_oem_check' (at offset 0xc0101f2e) and 'enable_apic_mode'
WARNING: vmlinux - Section mismatch: reference to .init.text:setup_unisys from .text between 'acpi_madt_oem_check' (at offset 0xc0101f37) and 'enable_apic_mode'WARNING: vmlinux - Section mismatch: reference to .init.text:parse_unisys_oem from .text between 'mps_oem_check' (at offset 0xc0101ec7) and 'acpi_madt_oem_check'
WARNING: vmlinux - Section mismatch: reference to .init.text:es7000_sw_apic from .text between 'enable_apic_mode' (at offset 0xc0101f48) and 'check_apicid_present'

o Some functions which are inline (acpi_madt_oem_check) are not inlined by
  compiler as these functions are accessed using function pointer. These
  functions are put in .text section and they in-turn access __init type
  functions hence modpost generates warnings.

o Do not iniline acpi_madt_oem_check, instead make it __init.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-generic/es7000.c             |   41 ++++++++++++++++++++++++++++
 include/asm-i386/mach-es7000/mach_apic.h    |    7 ----
 include/asm-i386/mach-es7000/mach_mpparse.h |   32 ---------------------
 scripts/mod/modpost.c                       |    1 
 4 files changed, 42 insertions(+), 39 deletions(-)

Index: linux/arch/i386/mach-generic/es7000.c
===================================================================
--- linux.orig/arch/i386/mach-generic/es7000.c
+++ linux/arch/i386/mach-generic/es7000.c
@@ -25,4 +25,45 @@ static int probe_es7000(void)
 	return 0;
 }
 
+extern void es7000_sw_apic(void);
+static void __init enable_apic_mode(void)
+{
+	es7000_sw_apic();
+	return;
+}
+
+static __init int mps_oem_check(struct mp_config_table *mpc, char *oem,
+		char *productid)
+{
+	if (mpc->mpc_oemptr) {
+		struct mp_config_oemtable *oem_table =
+			(struct mp_config_oemtable *)mpc->mpc_oemptr;
+		if (!strncmp(oem, "UNISYS", 6))
+			return parse_unisys_oem((char *)oem_table);
+	}
+	return 0;
+}
+
+#ifdef CONFIG_ACPI
+/* Hook from generic ACPI tables.c */
+static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	unsigned long oem_addr;
+	if (!find_unisys_acpi_oem_table(&oem_addr)) {
+		if (es7000_check_dsdt())
+			return parse_unisys_oem((char *)oem_addr);
+		else {
+			setup_unisys();
+			return 1;
+		}
+	}
+	return 0;
+}
+#else
+static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return 0;
+}
+#endif
+
 struct genapic apic_es7000 = APIC_INIT("es7000", probe_es7000);
Index: linux/include/asm-i386/mach-es7000/mach_apic.h
===================================================================
--- linux.orig/include/asm-i386/mach-es7000/mach_apic.h
+++ linux/include/asm-i386/mach-es7000/mach_apic.h
@@ -73,13 +73,6 @@ static inline void init_apic_ldr(void)
 	apic_write_around(APIC_LDR, val);
 }
 
-extern void es7000_sw_apic(void);
-static inline void enable_apic_mode(void)
-{
-	es7000_sw_apic();
-	return;
-}
-
 extern int apic_version [MAX_APICS];
 static inline void setup_apic_routing(void)
 {
Index: linux/include/asm-i386/mach-es7000/mach_mpparse.h
===================================================================
--- linux.orig/include/asm-i386/mach-es7000/mach_mpparse.h
+++ linux/include/asm-i386/mach-es7000/mach_mpparse.h
@@ -18,18 +18,6 @@ extern int parse_unisys_oem (char *oempt
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
 extern void setup_unisys(void);
 
-static inline int mps_oem_check(struct mp_config_table *mpc, char *oem,
-		char *productid)
-{
-	if (mpc->mpc_oemptr) {
-		struct mp_config_oemtable *oem_table =
-			(struct mp_config_oemtable *)mpc->mpc_oemptr;
-		if (!strncmp(oem, "UNISYS", 6))
-			return parse_unisys_oem((char *)oem_table);
-	}
-	return 0;
-}
-
 #ifdef CONFIG_ACPI
 
 static inline int es7000_check_dsdt(void)
@@ -41,26 +29,6 @@ static inline int es7000_check_dsdt(void
 		return 1;
 	return 0;
 }
-
-/* Hook from generic ACPI tables.c */
-static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	unsigned long oem_addr;
-	if (!find_unisys_acpi_oem_table(&oem_addr)) {
-		if (es7000_check_dsdt())
-			return parse_unisys_oem((char *)oem_addr);
-		else {
-			setup_unisys();
-			return 1;
-		}
-	}
-	return 0;
-}
-#else
-static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	return 0;
-}
 #endif
 
 #endif /* __ASM_MACH_MPPARSE_H */
Index: linux/scripts/mod/modpost.c
===================================================================
--- linux.orig/scripts/mod/modpost.c
+++ linux/scripts/mod/modpost.c
@@ -606,6 +606,7 @@ static int secref_whitelist(const char *
 		"_probe",
 		"_probe_one",
 		"_console",
+		"apic_es7000",
 		NULL
 	};
 
