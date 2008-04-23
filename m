Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYDWNLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYDWNLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 09:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbYDWNLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 09:11:39 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:16351 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbYDWNLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 09:11:37 -0400
Date: Wed, 23 Apr 2008 15:09:05 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: move i386 memory setup code to e820_32.c
Message-ID: <20080423130905.GA7347@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 23 Apr 2008 15:11:12 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.8; VDF: 7.0.3.202; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86_64 code has centralized the memory setup code in
e820_64.c. This patch copies that approach to i386:

- early_param("mem", ...) parsing is moved from
setup_32.c to e820_32.c.

- setup_memory_map() and finish_e820_parsing() are
factored out from setup_arch(), and declarations
are added to e820_32.h.

- print_memory_map() is made static and removed from
e820_32.h.

- user_defined_memmap is marked as __initdata.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

 arch/x86/kernel/e820_32.c  |   59 +++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/setup_32.c |   50 +-----------------------------------
 include/asm-x86/e820_32.h  |    4 ++-
 3 files changed, 63 insertions(+), 50 deletions(-)

Hi Ingo,

I observed this needlessly(tm) different approach between i386
and x86_64. It's just moving code from one place to another.
Compiles and runs fine for i386 and x86_64.

Greetings,
	Alexander

diff --git a/arch/x86/kernel/e820_32.c b/arch/x86/kernel/e820_32.c
index ed733e7..31ea2bb 100644
--- a/arch/x86/kernel/e820_32.c
+++ b/arch/x86/kernel/e820_32.c
@@ -30,7 +30,6 @@ unsigned long pci_mem_start = 0x10000000;
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL(pci_mem_start);
 #endif
-extern int user_defined_memmap;
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
@@ -584,7 +583,7 @@ void __init e820_register_memory(void)
 		pci_mem_start, gapstart, gapsize);
 }
 
-void __init print_memory_map(char *who)
+static void __init print_memory_map(char *who)
 {
 	int i;
 
@@ -692,6 +691,54 @@ e820_all_mapped(unsigned long s, unsigned long e, unsigned type)
 	return 0;
 }
 
+/* Overridden in paravirt.c if CONFIG_PARAVIRT */
+char * __init __attribute__((weak)) memory_setup(void)
+{
+	return machine_specific_memory_setup();
+}
+
+void __init setup_memory_map(void)
+{
+	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
+	print_memory_map(memory_setup());
+}
+
+static int __initdata user_defined_memmap;
+
+/*
+ * "mem=nopentium" disables the 4MB page tables.
+ * "mem=XXX[kKmM]" defines a memory region from HIGH_MEM
+ * to <mem>, overriding the bios size.
+ * "memmap=XXX[KkmM]@XXX[KkmM]" defines a memory region from
+ * <start> to <start>+<mem>, overriding the bios size.
+ *
+ * HPA tells me bootloaders need to parse mem=, so no new
+ * option should be mem=  [also see Documentation/i386/boot.txt]
+ */
+static int __init parse_mem(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp(arg, "nopentium") == 0) {
+		setup_clear_cpu_cap(X86_FEATURE_PSE);
+	} else {
+		/* If the user specifies memory size, we
+		 * limit the BIOS-provided memory map to
+		 * that size. exactmap can be used to specify
+		 * the exact map. mem=number can be used to
+		 * trim the existing memory map.
+		 */
+		unsigned long long mem_size;
+
+		mem_size = memparse(arg, &arg);
+		limit_regions(mem_size);
+		user_defined_memmap = 1;
+	}
+	return 0;
+}
+early_param("mem", parse_mem);
+
 static int __init parse_memmap(char *arg)
 {
 	if (!arg)
@@ -762,6 +809,15 @@ void __init update_memory_range(u64 start, u64 size, unsigned old_type,
 					 new_type);
 	}
 }
+
+void __init finish_e820_parsing(void)
+{
+	if (user_defined_memmap) {
+		printk(KERN_INFO "user-defined physical RAM map:\n");
+		print_memory_map("user");
+	}
+}
+
 void __init update_e820(void)
 {
 	u8 nr_map;
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index a9613ff..33ab3ec 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -231,42 +231,6 @@ static inline void copy_edd(void)
 }
 #endif
 
-int __initdata user_defined_memmap;
-
-/*
- * "mem=nopentium" disables the 4MB page tables.
- * "mem=XXX[kKmM]" defines a memory region from HIGH_MEM
- * to <mem>, overriding the bios size.
- * "memmap=XXX[KkmM]@XXX[KkmM]" defines a memory region from
- * <start> to <start>+<mem>, overriding the bios size.
- *
- * HPA tells me bootloaders need to parse mem=, so no new
- * option should be mem=  [also see Documentation/i386/boot.txt]
- */
-static int __init parse_mem(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (strcmp(arg, "nopentium") == 0) {
-		setup_clear_cpu_cap(X86_FEATURE_PSE);
-	} else {
-		/* If the user specifies memory size, we
-		 * limit the BIOS-provided memory map to
-		 * that size. exactmap can be used to specify
-		 * the exact map. mem=number can be used to
-		 * trim the existing memory map.
-		 */
-		unsigned long long mem_size;
-
-		mem_size = memparse(arg, &arg);
-		limit_regions(mem_size);
-		user_defined_memmap = 1;
-	}
-	return 0;
-}
-early_param("mem", parse_mem);
-
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
  * stored by the crashed kernel.
@@ -719,12 +683,6 @@ static void set_mca_bus(int x)
 static void set_mca_bus(int x) { }
 #endif
 
-/* Overridden in paravirt.c if CONFIG_PARAVIRT */
-char * __init __attribute__((weak)) memory_setup(void)
-{
-	return machine_specific_memory_setup();
-}
-
 #ifdef CONFIG_NUMA
 /*
  * In the golden day, when everything among i386 and x86_64 will be
@@ -780,8 +738,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	ARCH_SETUP
 
-	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
-	print_memory_map(memory_setup());
+	setup_memory_map();
 
 	copy_edd();
 
@@ -801,10 +758,7 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
-	if (user_defined_memmap) {
-		printk(KERN_INFO "user-defined physical RAM map:\n");
-		print_memory_map("user");
-	}
+	finish_e820_parsing();
 
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
diff --git a/include/asm-x86/e820_32.h b/include/asm-x86/e820_32.h
index a9f7c6e..e1f10c6 100644
--- a/include/asm-x86/e820_32.h
+++ b/include/asm-x86/e820_32.h
@@ -18,6 +18,9 @@
 
 #ifndef __ASSEMBLY__
 
+extern void setup_memory_map(void);
+extern void finish_e820_parsing(void);
+
 extern struct e820map e820;
 extern void update_e820(void);
 
@@ -32,7 +35,6 @@ extern void update_memory_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type);
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
-extern void print_memory_map(char *who);
 extern void init_iomem_resources(struct resource *code_resource,
 				 struct resource *data_resource,
 				 struct resource *bss_resource);
