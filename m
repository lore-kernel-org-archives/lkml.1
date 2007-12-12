Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbXLLPrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbXLLPrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759952AbXLLPm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:42:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759945AbXLLPm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:42:26 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 6/6] prepare x86_64 architecture initialization for paravirt
Date: Wed, 12 Dec 2007 10:57:27 -0200
Message-Id: <11974642893361-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974642813710-git-send-email-gcosta@redhat.com>
References: <11974642471600-git-send-email-gcosta@redhat.com> <11974642553841-git-send-email-gcosta@redhat.com> <11974642622800-git-send-email-gcosta@redhat.com> <11974642682229-git-send-email-gcosta@redhat.com> <11974642754014-git-send-email-gcosta@redhat.com> <11974642813710-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares the x86_64 architecture initialization for
paravirt. It requires a memory initialization step, which is done
by implementing 64-bit version for machine_specific_memory_setup,
and putting an ARCH_SETUP hook, for guest-dependent initialization.
This last step is done akin to i386

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/e820_64.c    |    9 +++++++--
 arch/x86/kernel/setup_64.c   |   28 +++++++++++++++++++++++++++-
 arch/x86/kernel/smpboot_64.c |    4 ++--
 include/asm-x86/setup.h      |   11 ++++++++---
 4 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index 8e73211..abc473b 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -638,8 +638,10 @@ static void early_panic(char *msg)
 	panic(msg);
 }
 
-void __init setup_memory_region(void)
+/* We're not void only for x86 32-bit compat */
+char * __init machine_specific_memory_setup(void)
 {
+	char *who = "BIOS-e820";
 	/*
 	 * Try to copy the BIOS-supplied E820-map.
 	 *
@@ -650,7 +652,10 @@ void __init setup_memory_region(void)
 	if (copy_e820_map(boot_params.e820_map, boot_params.e820_entries) < 0)
 		early_panic("Cannot find a valid memory map");
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
-	e820_print_map("BIOS-e820");
+	e820_print_map(who);
+
+	/* In case someone cares... */
+	return who;
 }
 
 static int __init parse_memopt(char *p)
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c654c4a..b1000dd 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -39,6 +39,7 @@
 #include <linux/dmi.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
+#include <linux/uaccess.h>
 
 #include <asm/mtrr.h>
 #include <asm/uaccess.h>
@@ -62,6 +63,12 @@
 #include <asm/mce.h>
 #include <asm/ds.h>
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define ARCH_SETUP
+#endif
+
 /*
  * Machine setup..
  */
@@ -246,6 +253,16 @@ static void discover_ebda(void)
 	 * 4K EBDA area at 0x40E
 	 */
 	ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
+	/*
+	 * There can be some situations, like paravirtualized guests,
+	 * in which there is no available ebda information. In such
+	 * case, just skip it
+	 */
+	if (!ebda_addr) {
+		ebda_size = 0;
+		return;
+	}
+
 	ebda_addr <<= 4;
 
 	ebda_size = *(unsigned short *)__va(ebda_addr);
@@ -259,6 +276,12 @@ static void discover_ebda(void)
 		ebda_size = 64*1024;
 }
 
+/* Overridden in paravirt.c if CONFIG_PARAVIRT */
+void __attribute__((weak)) memory_setup(void)
+{
+       machine_specific_memory_setup();
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	unsigned i;
@@ -276,7 +299,10 @@ void __init setup_arch(char **cmdline_p)
 	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
-	setup_memory_region();
+
+	ARCH_SETUP
+
+	memory_setup();
 	copy_edd();
 
 	if (!boot_params.hdr.root_flags)
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 0a23a30..6e42b57 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -369,7 +369,7 @@ void __cpuinit start_secondary(void)
 
 	unlock_ipi_call_lock();
 
-	setup_secondary_APIC_clock();
+	setup_secondary_clock();
 
 	cpu_idle();
 }
@@ -923,7 +923,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	 * Set up local APIC timer on boot CPU.
 	 */
 
-	setup_boot_APIC_clock();
+	setup_boot_clock();
 }
 
 /*
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index 24d786e..071e054 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -3,6 +3,13 @@
 
 #define COMMAND_LINE_SIZE 2048
 
+#ifndef __ASSEMBLY__
+char *machine_specific_memory_setup(void);
+#ifndef CONFIG_PARAVIRT
+#define paravirt_post_allocator_init()	do {} while (0)
+#endif
+#endif /* __ASSEMBLY__ */
+
 #ifdef __KERNEL__
 
 #ifdef __i386__
@@ -51,9 +58,7 @@ void __init add_memory_region(unsigned long long start,
 
 extern unsigned long init_pg_tables_end;
 
-#ifndef CONFIG_PARAVIRT
-#define paravirt_post_allocator_init()	do {} while (0)
-#endif
+
 
 #endif /* __i386__ */
 #endif /* _SETUP */
-- 
1.4.4.2

