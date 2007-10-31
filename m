Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbXJaWGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbXJaWGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761588AbXJaWFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:05:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761477AbXJaWFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:05:52 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 14/16] prepare x86_64 architecture initialization for paravirt
Date: Wed, 31 Oct 2007 16:14:59 -0300
Message-Id: <11938581762150-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581713998-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com> <11938581451804-git-send-email-gcosta@redhat.com> <11938581512730-git-send-email-gcosta@redhat.com> <11938581562552-git-send-email-gcosta@redhat.com> <11938581612389-git-send-email-gcosta@redhat.com> <11938581663639-git-send-email-gcosta@redhat.com> <11938581713998-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares the x86_64 architecture initialization for
paravirt. It requires a memory initialization step, which is done
by implementing 64-bit version for machine_specific_memory_setup,
and putting an ARCH_SETUP hook, for guest-dependent initialization.
This last step is done akin to i386

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/e820_64.c  |    9 +++++++--
 arch/x86/kernel/setup_64.c |   28 +++++++++++++++++++++++++++-
 include/asm-x86/setup.h    |   11 ++++++++---
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index 04698e0..c67526c 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -593,8 +593,10 @@ void early_panic(char *msg)
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
@@ -605,7 +607,10 @@ void __init setup_memory_region(void)
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
index 238633d..44a11e3 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -39,6 +39,7 @@
 #include <linux/dmi.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
+#include <linux/uaccess.h>
 
 #include <asm/mtrr.h>
 #include <asm/uaccess.h>
@@ -60,6 +61,12 @@
 #include <asm/dmi.h>
 #include <asm/cacheflush.h>
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define ARCH_SETUP
+#endif
+
 /*
  * Machine setup..
  */
@@ -241,6 +248,16 @@ static void discover_ebda(void)
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
@@ -254,6 +271,12 @@ static void discover_ebda(void)
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
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
@@ -269,7 +292,10 @@ void __init setup_arch(char **cmdline_p)
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

