Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXEaWcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXEaWcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXEaWcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:32:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:53524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbXEaWcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:32:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,370,1175497200"; 
   d="scan'208";a="234276679"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: [RFC] trim memory not covered by MTRR WB type
Date: Thu, 31 May 2007 15:32:31 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705311532.31905.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen a few machines lately that don't map all their memory WB via
the MTRRs.  It tends to happen at large memory configurations (at least
for desktops, >3G or so), and is really a BIOS bug.  But it would be
nice if the kernel could warn the user and continue, rather than just
run horribly slowly.

This patch assumes that the unmapped memory occurs at the end of the
memory configuration, and adjusts end_pfn accordingly.  It works ok on
my machine (correctly detects the condition, adjusts end_pfn, and keeps
the machine fast), aside from the fact that X won't start.  So I
obviously broke something by making the MTRR system init so much
earlier.

Comments?

Thanks,
Jesse

diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 1cf466d..b4b3ea8 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -38,8 +38,8 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 
+#include <asm/e820.h>
 #include <asm/mtrr.h>
-
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -47,7 +47,8 @@
 
 u32 num_var_ranges = 0;
 
-unsigned int *usage_table;
+#define MAX_MTRR_RANGES 255
+unsigned int usage_table[MAX_MTRR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
@@ -121,11 +122,6 @@ static void __init init_table(void)
 	int i, max;
 
 	max = num_var_ranges;
-	if ((usage_table = kmalloc(max * sizeof *usage_table, GFP_KERNEL))
-	    == NULL) {
-		printk(KERN_ERR "mtrr: could not allocate\n");
-		return;
-	}
 	for (i = 0; i < max; i++)
 		usage_table[i] = 1;
 }
@@ -631,6 +627,29 @@ static struct sysdev_driver mtrr_sysdev_driver = {
 	.resume		= mtrr_restore,
 };
 
+void __init mtrr_trim_uncached_memory(void)
+{
+	unsigned long i, base, size, highest_addr = 0;
+	mtrr_type type;
+
+	/* Find highest cached pfn */
+	for (i = 0; i < num_var_ranges; i++) {
+		mtrr_if->get(i, &base, &size, &type);
+		if (type != MTRR_TYPE_WRBACK)
+			continue;
+		base <<= PAGE_SHIFT;
+		size <<= PAGE_SHIFT;
+		if (highest_addr < base + size)
+			highest_addr = base + size;
+	}
+
+	if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
+		printk(KERN_WARNING "Warning:  MTRRs don't cover all of "
+		       "memory, trimmed %ld pages\n", end_pfn -
+		       (highest_addr >> PAGE_SHIFT));
+		end_pfn = highest_addr >> PAGE_SHIFT;
+	}
+}
 
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
diff --git a/arch/x86_64/kernel/bugs.c b/arch/x86_64/kernel/bugs.c
index c3c6b91..c138eac 100644
--- a/arch/x86_64/kernel/bugs.c
+++ b/arch/x86_64/kernel/bugs.c
@@ -14,7 +14,6 @@
 void __init check_bugs(void)
 {
 	identify_cpu(&boot_cpu_data);
-	mtrr_bp_init();
 #if !defined(CONFIG_SMP)
 	printk("CPU: ");
 	print_cpu_info(&boot_cpu_data);
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index eb6524f..409b63c 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -266,6 +266,10 @@ void __init setup_arch(char **cmdline_p)
 	 * we are rounding upwards:
 	 */
 	end_pfn = e820_end_of_ram();
+	/* Trim memory not covered by WB MTRRs */
+	mtrr_bp_init();
+	mtrr_trim_uncached_memory();
+
 	num_physpages = end_pfn;
 
 	check_efer();
diff --git a/include/asm-i386/mtrr.h b/include/asm-i386/mtrr.h
diff --git a/include/asm-x86_64/mtrr.h b/include/asm-x86_64/mtrr.h
index b557c48..cc62bd8 100644
--- a/include/asm-x86_64/mtrr.h
+++ b/include/asm-x86_64/mtrr.h
@@ -78,6 +78,7 @@ extern int mtrr_add_page (unsigned long base, unsigned long size,
 		     unsigned int type, char increment);
 extern int mtrr_del (int reg, unsigned long base, unsigned long size);
 extern int mtrr_del_page (int reg, unsigned long base, unsigned long size);
+extern void mtrr_trim_uncached_memory(void);
 #  else
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
 				unsigned int type, char increment)
