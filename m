Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYFTNhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYFTNhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYFTNhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:37:48 -0400
Received: from mail.suse.de ([195.135.220.2]:56779 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYFTNhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:37:47 -0400
From: Bernhard Walle <bwalle@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Unify crashkernel reservation for 32 and 64 bit
Date: Fri, 20 Jun 2008 15:38:22 +0200
Message-Id: <1213969102-17400-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the reserve_crashkernel() to setup.c and removes the
architecture-specific version. Both versions were more or less the same.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/setup.c    |   61 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_32.c |   53 --------------------------------------
 arch/x86/kernel/setup_64.c |   40 ----------------------------
 include/asm-x86/setup.h    |    3 ++
 4 files changed, 64 insertions(+), 93 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 542ff3c..915aa13 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -3,6 +3,7 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/percpu.h>
+#include <linux/kexec.h>
 #include <asm/smp.h>
 #include <asm/percpu.h>
 #include <asm/sections.h>
@@ -11,6 +12,7 @@
 #include <asm/topology.h>
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
+#include <asm/highmem.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
@@ -404,3 +406,62 @@ EXPORT_SYMBOL(node_to_cpumask);
 #endif /* CONFIG_DEBUG_PER_CPU_MAPS */
 
 #endif /* X86_64_NUMA */
+
+
+/*
+ * --------- Crashkernel reservation ------------------------------
+ */
+
+static inline unsigned long long get_total_mem(void)
+{
+	unsigned long long total;
+
+	total = max_low_pfn - min_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	total += highend_pfn - highstart_pfn;
+#endif
+
+	return total << PAGE_SHIFT;
+}
+
+#ifdef CONFIG_KEXEC
+void __init reserve_crashkernel(void)
+{
+	unsigned long long total_mem;
+	unsigned long long crash_size, crash_base;
+	int ret;
+
+	total_mem = get_total_mem();
+
+	ret = parse_crashkernel(boot_command_line, total_mem,
+			&crash_size, &crash_base);
+	if (ret == 0 && crash_size > 0) {
+		if (crash_base <= 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"you have to specify a base address\n");
+			return;
+		}
+
+		if (reserve_bootmem_generic(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
+		insert_resource(&iomem_resource, &crashk_res);
+	}
+}
+#else
+void __init reserve_crashkernel(void)
+{}
+#endif
+
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 348dc8a..a00b71b 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -429,59 +429,6 @@ extern unsigned long __init setup_memory(void);
 extern void zone_sizes_init(void);
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-static inline unsigned long long get_total_mem(void)
-{
-	unsigned long long total;
-
-	total = max_low_pfn - min_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	total += highend_pfn - highstart_pfn;
-#endif
-
-	return total << PAGE_SHIFT;
-}
-
-#ifdef CONFIG_KEXEC
-static void __init reserve_crashkernel(void)
-{
-	unsigned long long total_mem;
-	unsigned long long crash_size, crash_base;
-	int ret;
-
-	total_mem = get_total_mem();
-
-	ret = parse_crashkernel(boot_command_line, total_mem,
-			&crash_size, &crash_base);
-	if (ret == 0 && crash_size > 0) {
-		if (crash_base <= 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"you have to specify a base address\n");
-			return;
-		}
-
-		if (reserve_bootmem_generic(crash_base, crash_size,
-					BOOTMEM_EXCLUSIVE) < 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"memory is in use\n");
-			return;
-		}
-
-		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-				"for crashkernel (System RAM: %ldMB)\n",
-				(unsigned long)(crash_size >> 20),
-				(unsigned long)(crash_base >> 20),
-				(unsigned long)(total_mem >> 20));
-
-		crashk_res.start = crash_base;
-		crashk_res.end   = crash_base + crash_size - 1;
-		insert_resource(&iomem_resource, &crashk_res);
-	}
-}
-#else
-static inline void __init reserve_crashkernel(void)
-{}
-#endif
-
 #ifdef CONFIG_BLK_DEV_INITRD
 
 static bool do_relocate_initrd = false;
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 6ad0fe4..076d61b 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -244,46 +244,6 @@ static inline void copy_edd(void)
 }
 #endif
 
-#ifdef CONFIG_KEXEC
-static void __init reserve_crashkernel(void)
-{
-	unsigned long long total_mem;
-	unsigned long long crash_size, crash_base;
-	int ret;
-
-	total_mem = ((unsigned long long)max_low_pfn - min_low_pfn) << PAGE_SHIFT;
-
-	ret = parse_crashkernel(boot_command_line, total_mem,
-			&crash_size, &crash_base);
-	if (ret == 0 && crash_size) {
-		if (crash_base <= 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"you have to specify a base address\n");
-			return;
-		}
-
-		if (reserve_bootmem_generic(crash_base, crash_size,
-					BOOTMEM_EXCLUSIVE) < 0) {
-			printk(KERN_INFO "crashkernel reservation failed - "
-					"memory is in use\n");
-			return;
-		}
-
-		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-				"for crashkernel (System RAM: %ldMB)\n",
-				(unsigned long)(crash_size >> 20),
-				(unsigned long)(crash_base >> 20),
-				(unsigned long)(total_mem >> 20));
-		crashk_res.start = crash_base;
-		crashk_res.end   = crash_base + crash_size - 1;
-		insert_resource(&iomem_resource, &crashk_res);
-	}
-}
-#else
-static inline void __init reserve_crashkernel(void)
-{}
-#endif
-
 /* Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one. */
 void switch_to_new_gdt(void)
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index e14b6e7..b434bdd 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -8,6 +8,9 @@
 /* Interrupt control for vSMPowered x86_64 systems */
 void vsmp_init(void);
 
+/* Crashkernel reservation */
+void reserve_crashkernel(void);
+
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
-- 
1.5.4.5

