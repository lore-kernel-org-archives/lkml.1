Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYFJVxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYFJVxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbYFJVwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:52:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbYFJVwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:52:50 -0400
Date: Tue, 10 Jun 2008 23:53:25 +0200
To: kexec@lists.infradead.org, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Limit E820 map and /proc/iomem for mem parameter on x86-64
Message-ID: <20080610215325.GA20673@suse.de>
Mail-Followup-To: kexec@lists.infradead.org, vgoyal@redhat.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.17 (2007-11-01)
From: bwalle@suse.de (Bernhard Walle)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to unify the behaviour of i386 and x86-64 when parsing
the memory (mem/memmap) parameter of the kernel command line:

On i386, the view was limited (i.e. the actual view was presented).
On x86-64, the view was full (i.e. the BIOS view was presented).

This patch moves the limit_regions() function and the print_memory_map()
function to a new file e820.c, shared between the two x86 flavours. Then
it adds calls to limit_regions() in 64 bit code.

I gave the patch a bit testing. However, it's not for merging, it's just
to get early feedback to see if that goes into the right direction.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/Makefile   |    2 -
 arch/x86/kernel/e820.c     |   75 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/e820_32.c  |   60 +-----------------------------------
 arch/x86/kernel/e820_64.c  |    4 ++
 arch/x86/kernel/setup_32.c |    4 +-
 include/asm-x86/e820.h     |    4 ++
 6 files changed, 88 insertions(+), 61 deletions(-)

--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -22,7 +22,7 @@ obj-y			+= setup_$(BITS).o i8259_$(BITS)
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
-obj-y			+= bootflag.o e820_$(BITS).o
+obj-y			+= bootflag.o e820_$(BITS).o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
--- /dev/null
+++ b/arch/x86/kernel/e820.c
@@ -0,0 +1,75 @@
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/ioport.h>
+#include <linux/string.h>
+#include <linux/kexec.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/pfn.h>
+#include <linux/uaccess.h>
+#include <linux/suspend.h>
+
+#include <asm/pgtable.h>
+#include <asm/page.h>
+#include <asm/e820.h>
+#include <asm/setup.h>
+
+void __init limit_regions(struct e820map *e820, unsigned long long size)
+{
+	unsigned long long current_addr;
+	int i;
+
+	print_memory_map(e820, "limit_regions start");
+	for (i = 0; i < e820->nr_map; i++) {
+		current_addr = e820->map[i].addr + e820->map[i].size;
+		if (current_addr < size)
+			continue;
+
+		if (e820->map[i].type != E820_RAM)
+			continue;
+
+		if (e820->map[i].addr >= size) {
+			/*
+			 * This region starts past the end of the
+			 * requested size, skip it completely.
+			 */
+			e820->nr_map = i;
+		} else {
+			e820->nr_map = i + 1;
+			e820->map[i].size -= current_addr - size;
+		}
+		print_memory_map(e820, "limit_regions endfor");
+		return;
+	}
+	print_memory_map(e820, "limit_regions endfunc");
+}
+
+void __init print_memory_map(struct e820map *e820, char *who)
+{
+	int i;
+
+	for (i = 0; i < e820->nr_map; i++) {
+		printk(" %s: %016Lx - %016Lx ", who,
+			e820->map[i].addr,
+			e820->map[i].addr + e820->map[i].size);
+		switch (e820->map[i].type) {
+		case E820_RAM:	printk("(usable)\n");
+				break;
+		case E820_RESERVED:
+				printk("(reserved)\n");
+				break;
+		case E820_ACPI:
+				printk("(ACPI data)\n");
+				break;
+		case E820_NVS:
+				printk("(ACPI NVS)\n");
+				break;
+		default:	printk("type %u\n", e820->map[i].type);
+				break;
+		}
+	}
+}
+
+
--- a/arch/x86/kernel/e820_32.c
+++ b/arch/x86/kernel/e820_32.c
@@ -584,62 +584,6 @@ void __init e820_register_memory(void)
 		pci_mem_start, gapstart, gapsize);
 }
 
-void __init print_memory_map(char *who)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		printk(" %s: %016Lx - %016Lx ", who,
-			e820.map[i].addr,
-			e820.map[i].addr + e820.map[i].size);
-		switch (e820.map[i].type) {
-		case E820_RAM:	printk("(usable)\n");
-				break;
-		case E820_RESERVED:
-				printk("(reserved)\n");
-				break;
-		case E820_ACPI:
-				printk("(ACPI data)\n");
-				break;
-		case E820_NVS:
-				printk("(ACPI NVS)\n");
-				break;
-		default:	printk("type %u\n", e820.map[i].type);
-				break;
-		}
-	}
-}
-
-void __init limit_regions(unsigned long long size)
-{
-	unsigned long long current_addr;
-	int i;
-
-	print_memory_map("limit_regions start");
-	for (i = 0; i < e820.nr_map; i++) {
-		current_addr = e820.map[i].addr + e820.map[i].size;
-		if (current_addr < size)
-			continue;
-
-		if (e820.map[i].type != E820_RAM)
-			continue;
-
-		if (e820.map[i].addr >= size) {
-			/*
-			 * This region starts past the end of the
-			 * requested size, skip it completely.
-			 */
-			e820.nr_map = i;
-		} else {
-			e820.nr_map = i + 1;
-			e820.map[i].size -= current_addr - size;
-		}
-		print_memory_map("limit_regions endfor");
-		return;
-	}
-	print_memory_map("limit_regions endfunc");
-}
-
 /*
  * This function checks if any part of the range <start,end> is mapped
  * with type.
@@ -729,7 +673,7 @@ static int __init parse_memmap(char *arg
 			start_at = memparse(arg+1, &arg);
 			add_memory_region(start_at, mem_size, E820_RESERVED);
 		} else {
-			limit_regions(mem_size);
+			limit_regions(&e820, mem_size);
 			user_defined_memmap = 1;
 		}
 	}
@@ -771,5 +715,5 @@ void __init update_e820(void)
 		return;
 	e820.nr_map = nr_map;
 	printk(KERN_INFO "modified physical RAM map:\n");
-	print_memory_map("modified");
+	print_memory_map(&e820, "modified");
 }
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -761,9 +761,12 @@ char * __init machine_specific_memory_se
 
 static int __init parse_memopt(char *p)
 {
+	printk(KERN_INFO "parse_memopt\n");
 	if (!p)
 		return -EINVAL;
 	end_user_pfn = memparse(p, &p);
+	limit_regions(&e820, end_user_pfn);
+
 	end_user_pfn >>= PAGE_SHIFT;
 	return 0;
 }
@@ -809,6 +812,7 @@ static int __init parse_memmap_opt(char
 		start_at = memparse(p+1, &p);
 		add_memory_region(start_at, mem_size, E820_RESERVED);
 	} else {
+		limit_regions(&e820, mem_size);
 		end_user_pfn = (mem_size >> PAGE_SHIFT);
 	}
 	return *p == '\0' ? 0 : -EINVAL;
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -787,7 +787,7 @@ void __init setup_arch(char **cmdline_p)
 	ARCH_SETUP
 
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
-	print_memory_map(memory_setup());
+	print_memory_map(&e820, memory_setup());
 
 	copy_edd();
 
@@ -809,7 +809,7 @@ void __init setup_arch(char **cmdline_p)
 
 	if (user_defined_memmap) {
 		printk(KERN_INFO "user-defined physical RAM map:\n");
-		print_memory_map("user");
+		print_memory_map(&e820, "user");
 	}
 
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -20,6 +20,10 @@ struct e820map {
 	__u32 nr_map;
 	struct e820entry map[E820MAX];
 };
+
+void limit_regions(struct e820map *e820, unsigned long long size);
+void print_memory_map(struct e820map *e820, char *who);
+
 #endif /* __ASSEMBLY__ */
 
 #define ISA_START_ADDRESS	0xa0000
