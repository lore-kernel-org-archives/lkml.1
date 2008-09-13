Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYIMJwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYIMJwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 05:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbYIMJv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 05:51:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:14063 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbYIMJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 05:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fVJXaJa+0bwAUUOuiaxv2ynzcCwPqLcAqhlnF9Kz0v2DllljB+Ew3XeA98jd7yPWSb
         avTxO5b3Gq4OeYj1q43ShnXsMSJMaVqCjNKRoha+RuGoTN/WD7X0xM++/Ac+HoV/kqG6
         opKew4/YgEsf2ixMvdH/rziCIBP5Rjb20N2qM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/3] x86: check dsdt before find oem table for es7000 v2
Date: Sat, 13 Sep 2008 02:51:14 -0700
Message-Id: <1221299474-10038-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221299474-10038-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221299474-10038-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: use __acpi_unmap_table()

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/es7000_32.c      |   28 +++++++++++++++++++++++-----
 arch/x86/mach-generic/es7000.c   |   20 +++++++++++++++-----
 include/asm-x86/es7000/mpparse.h |    1 +
 3 files changed, 39 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/mach-generic/es7000.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/es7000.c
+++ linux-2.6/arch/x86/mach-generic/es7000.c
@@ -47,16 +47,26 @@ static __init int mps_oem_check(struct m
 /* Hook from generic ACPI tables.c */
 static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	unsigned long oem_addr;
+	unsigned long oem_addr = 0;
+	int check_dsdt;
+	int ret = 0;
+
+	/* check dsdt at first to avoid clear fix_map for oem_addr */
+	check_dsdt = es7000_check_dsdt();
+
 	if (!find_unisys_acpi_oem_table(&oem_addr)) {
-		if (es7000_check_dsdt())
-			return parse_unisys_oem((char *)oem_addr);
+		if (check_dsdt)
+			ret = parse_unisys_oem((char *)oem_addr);
 		else {
 			setup_unisys();
-			return 1;
+			ret = 1;
 		}
+		/*
+		 * we need to unmap it
+		 */
+		unmap_unisys_acpi_oem_table(oem_addr);
 	}
-	return 0;
+	return ret;
 }
 #else
 static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
Index: linux-2.6/arch/x86/kernel/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/es7000_32.c
+++ linux-2.6/arch/x86/kernel/es7000_32.c
@@ -109,6 +109,7 @@ struct oem_table {
 };
 
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
 #endif
 
 struct mip_reg {
@@ -243,21 +244,38 @@ parse_unisys_oem (char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-int __init
-find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static unsigned long oem_addrX;
+static unsigned long oem_size;
+int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	int i = 0;
-	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
+	acpi_size tbl_size;
+
+	while (ACPI_SUCCESS(acpi_get_table_with_size("OEM1", i++, &header, &tbl_size))) {
 		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
 			struct oem_table *t = (struct oem_table *)header;
-			*oem_addr = (unsigned long)__acpi_map_table(t->OEMTableAddr,
-								    t->OEMTableSize);
+
+			oem_addrX = t->OEMTableAddr;
+			oem_size = t->OEMTableSize;
+			early_acpi_os_unmap_memory(header, tbl_size);
+
+			*oem_addr = (unsigned long)__acpi_map_table(oem_addrX,
+								    oem_size);
 			return 0;
 		}
+		early_acpi_os_unmap_memory(header, tbl_size);
 	}
 	return -1;
 }
+
+void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+{
+	if (!oem_addr)
+		return;
+
+	__acpi_unmap_table((char *)oem_addr, oem_size);
+}
 #endif
 
 static void
Index: linux-2.6/include/asm-x86/es7000/mpparse.h
===================================================================
--- linux-2.6.orig/include/asm-x86/es7000/mpparse.h
+++ linux-2.6/include/asm-x86/es7000/mpparse.h
@@ -5,6 +5,7 @@
 
 extern int parse_unisys_oem (char *oemptr);
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
 extern void setup_unisys(void);
 
 #ifndef CONFIG_X86_GENERICARCH
