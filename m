Return-Path: <linux-kernel-owner+w=401wt.eu-S2992754AbXDDI5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992754AbXDDI5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992770AbXDDI5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:57:36 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:51093 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992754AbXDDI5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:57:35 -0400
Subject: [PATCH 2/4] Use the APIC to determine the hardware processor id -
	i386
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ak@suse.de, ebiederm@xmission.com,
       horms@verge.net.au, tony.luck@intel.com, vgoyal@in.ibm.com
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 04 Apr 2007 17:57:34 +0900
Message-Id: <1175677054.26920.137.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hard_smp_processor_id used to be just a macro that hard-coded
hard_smp_processor_id to 0 in the non SMP case.  When booting non SMP
kernels on hardware where the boot ioapic id is not 0 this turns out to
be a problem.  This is happens frequently in the case of kdump and once
in a great while in the case of real hardware.

Use the APIC to determine the hardware processor id in both UP and SMP
kernels to fix this issue.

Notice that hard_smp_processor_id is only used by SMP code or by code
that works with apics so we do not need to handle the case when apics
are not present and hard_smp_processor_id should never be called there.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc5-orig/arch/i386/mach-generic/probe.c linux-2.6.21-rc5/arch/i386/mach-generic/probe.c
--- linux-2.6.21-rc5-orig/arch/i386/mach-generic/probe.c	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc5/arch/i386/mach-generic/probe.c	2007-04-04 16:19:53.000000000 +0900
@@ -119,9 +119,7 @@ int __init acpi_madt_oem_check(char *oem
 	return 0;	
 }
 
-#ifdef CONFIG_SMP
 int hard_smp_processor_id(void)
 {
 	return genapic->get_apic_id(*(unsigned long *)(APIC_BASE+APIC_ID));
 }
-#endif
diff -urNp linux-2.6.21-rc5-orig/include/asm-i386/smp.h linux-2.6.21-rc5/include/asm-i386/smp.h
--- linux-2.6.21-rc5-orig/include/asm-i386/smp.h	2007-04-04 15:57:31.000000000 +0900
+++ linux-2.6.21-rc5/include/asm-i386/smp.h	2007-04-04 16:14:54.000000000 +0900
@@ -74,20 +74,6 @@ static inline int num_booting_cpus(void)
 	return cpus_weight(cpu_callout_map);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-
-#ifdef APIC_DEFINITION
-extern int hard_smp_processor_id(void);
-#else
-#include <mach_apicdef.h>
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
-}
-#endif
-#endif
-
 extern int safe_smp_processor_id(void);
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
@@ -97,7 +83,6 @@ extern unsigned int num_processors;
 
 #else /* CONFIG_SMP */
 
-#define hard_smp_processor_id()		0
 #define safe_smp_processor_id()		0
 #define cpu_physical_id(cpu)		boot_cpu_physical_apicid
 
@@ -107,6 +92,27 @@ extern unsigned int num_processors;
 
 #ifndef __ASSEMBLY__
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
+#ifdef APIC_DEFINITION
+extern int hard_smp_processor_id(void);
+#else
+#include <mach_apicdef.h>
+static inline int hard_smp_processor_id(void)
+{
+	/* we don't want to mark this access volatile - bad code generation */
+	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
+}
+#endif /* APIC_DEFINITION */
+
+#else /* CONFIG_X86_LOCAL_APIC */
+
+#ifndef CONFIG_SMP
+#define hard_smp_processor_id()		0
+#endif
+
+#endif /* CONFIG_X86_LOCAL_APIC */
+
 extern u8 apicid_2_node[];
 
 #ifdef CONFIG_X86_LOCAL_APIC


