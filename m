Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXGDIJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXGDIJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXGDIJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:09:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34311 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980AbXGDIJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:09:39 -0400
Date: Wed, 4 Jul 2007 13:39:38 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, rdreier@cisco.com,
       Natalie Protasevich <protasnb@gmail.com>
Subject: [PATCH] i386: es7000 build breakage fix
Message-ID: <20070704080938.GA13258@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


o Commit 1833d6bc72893265f22addd79cf52e6987496e0f broke the build if
  compiled with CONFIG_ES7000=y and CONFIG_X86_GENERICARCH=n

arch/i386/kernel/built-in.o(.init.text+0x4fa9): In function `acpi_parse_madt':
: undefined reference to `acpi_madt_oem_check'
arch/i386/kernel/built-in.o(.init.text+0x7406): In function `smp_read_mpc':
: undefined reference to `mps_oem_check'
arch/i386/kernel/built-in.o(.init.text+0x8990): In function
`connect_bsp_APIC':
: undefined reference to `enable_apic_mode'
make: *** [.tmp_vmlinux1] Error 1

o Fix the build issue. Provided the definitions of missing functions.

o Don't have ES7000 machine. Only compile tested.


 arch/i386/mach-es7000/es7000plat.c          |   48 ++++++++++++++++++++++++++++
 include/asm-i386/mach-es7000/mach_apic.h    |    4 ++
 include/asm-i386/mach-es7000/mach_mpparse.h |    6 +++
 3 files changed, 58 insertions(+)

diff -puN arch/i386/mach-es7000/es7000plat.c~i386-es7000-build-breakage-fix arch/i386/mach-es7000/es7000plat.c
--- linux-2.6.22-rc7/arch/i386/mach-es7000/es7000plat.c~i386-es7000-build-breakage-fix	2007-07-04 13:49:01.000000000 +0530
+++ linux-2.6.22-rc7-root/arch/i386/mach-es7000/es7000plat.c	2007-07-04 13:49:01.000000000 +0530
@@ -40,6 +40,7 @@
 #include <asm/smp.h>
 #include <asm/apicdef.h>
 #include "es7000.h"
+#include <mach_mpparse.h>
 
 /*
  * ES7000 Globals
@@ -174,6 +175,53 @@ find_unisys_acpi_oem_table(unsigned long
 }
 #endif
 
+/*
+ * This file also gets compiled if CONFIG_X86_GENERICARCH is set. Generic
+ * arch already has got following function definitions (asm-generic/es7000.c)
+ * hence no need to define these for that case.
+ */
+#ifndef CONFIG_X86_GENERICARCH
+void es7000_sw_apic(void);
+void __init enable_apic_mode(void)
+{
+	es7000_sw_apic();
+	return;
+}
+
+__init int mps_oem_check(struct mp_config_table *mpc, char *oem,
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
+#ifdef CONFIG_ACPI
+/* Hook from generic ACPI tables.c */
+int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
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
+int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return 0;
+}
+#endif
+#endif /* COFIG_X86_GENERICARCH */
+
 static void
 es7000_spin(int n)
 {
diff -puN include/asm-i386/mach-es7000/mach_apic.h~i386-es7000-build-breakage-fix include/asm-i386/mach-es7000/mach_apic.h
--- linux-2.6.22-rc7/include/asm-i386/mach-es7000/mach_apic.h~i386-es7000-build-breakage-fix	2007-07-04 13:49:01.000000000 +0530
+++ linux-2.6.22-rc7-root/include/asm-i386/mach-es7000/mach_apic.h	2007-07-04 13:49:01.000000000 +0530
@@ -73,6 +73,10 @@ static inline void init_apic_ldr(void)
 	apic_write_around(APIC_LDR, val);
 }
 
+#ifndef CONFIG_X86_GENERICARCH
+extern void enable_apic_mode(void);
+#endif
+
 extern int apic_version [MAX_APICS];
 static inline void setup_apic_routing(void)
 {
diff -puN include/asm-i386/mach-es7000/mach_mpparse.h~i386-es7000-build-breakage-fix include/asm-i386/mach-es7000/mach_mpparse.h
--- linux-2.6.22-rc7/include/asm-i386/mach-es7000/mach_mpparse.h~i386-es7000-build-breakage-fix	2007-07-04 13:49:01.000000000 +0530
+++ linux-2.6.22-rc7-root/include/asm-i386/mach-es7000/mach_mpparse.h	2007-07-04 13:49:01.000000000 +0530
@@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
 extern void setup_unisys(void);
 
+#ifndef CONFIG_X86_GENERICARCH
+extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
+extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
+				char *productid);
+#endif
+
 #ifdef CONFIG_ACPI
 
 static inline int es7000_check_dsdt(void)

_
