Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbYCSUbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbYCSUbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYCSTjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295AbYCSTjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:08 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 28/79] [PATCH] use specialized routine for setup per-cpu area
Date: Wed, 19 Mar 2008 14:25:23 -0300
Message-Id: <1205947702588-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476971309-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

We use the same routing as x86_64, moved now to setup.c.
Just with a few ifdefs inside.
Note that this routing uses prefill_possible_map().
It has the very nice side effect of allowing hotplugging of
cpus that are marked as present but disabled by acpi bios.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/Kconfig             |    2 +-
 arch/x86/kernel/Makefile     |    2 +-
 arch/x86/kernel/setup.c      |  103 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup64.c    |   77 -------------------------------
 arch/x86/kernel/smpboot_32.c |    2 +
 5 files changed, 107 insertions(+), 79 deletions(-)
 create mode 100644 arch/x86/kernel/setup.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a234ce9..5f1f381 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -121,7 +121,7 @@ config ARCH_HAS_CPU_RELAX
 	def_bool y
 
 config HAVE_SETUP_PER_CPU_AREA
-	def_bool X86_64
+	def_bool X86_64 || (X86_SMP && !X86_VOYAGER)
 
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 09b7b4e..dc333c8 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -19,7 +19,7 @@ CFLAGS_paravirt.o	:= $(nostackp)
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
-obj-y			+= setup_$(BITS).o i8259_$(BITS).o
+obj-y			+= setup_$(BITS).o i8259_$(BITS).o setup.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o setup64.o
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
new file mode 100644
index 0000000..1179aa0
--- /dev/null
+++ b/arch/x86/kernel/setup.c
@@ -0,0 +1,103 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/percpu.h>
+#include <asm/smp.h>
+#include <asm/percpu.h>
+#include <asm/sections.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+#include <asm/topology.h>
+
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
+/*
+ * Copy data used in early init routines from the initial arrays to the
+ * per cpu data areas.  These arrays then become expendable and the
+ * *_early_ptr's are zeroed indicating that the static arrays are gone.
+ */
+static void __init setup_per_cpu_maps(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+#ifdef CONFIG_SMP
+		if (per_cpu_offset(cpu)) {
+#endif
+			per_cpu(x86_cpu_to_apicid, cpu) =
+						x86_cpu_to_apicid_init[cpu];
+			per_cpu(x86_bios_cpu_apicid, cpu) =
+						x86_bios_cpu_apicid_init[cpu];
+#ifdef CONFIG_NUMA
+			per_cpu(x86_cpu_to_node_map, cpu) =
+						x86_cpu_to_node_map_init[cpu];
+#endif
+#ifdef CONFIG_SMP
+		} else
+			printk(KERN_NOTICE "per_cpu_offset zero for cpu %d\n",
+									cpu);
+#endif
+	}
+
+	/* indicate the early static arrays will soon be gone */
+	x86_cpu_to_apicid_early_ptr = NULL;
+	x86_bios_cpu_apicid_early_ptr = NULL;
+#ifdef CONFIG_NUMA
+	x86_cpu_to_node_map_early_ptr = NULL;
+#endif
+}
+
+#ifdef CONFIG_X86_32
+/*
+ * Great future not-so-futuristic plan: make i386 and x86_64 do it
+ * the same way
+ */
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+EXPORT_SYMBOL(__per_cpu_offset);
+#endif
+
+/*
+ * Great future plan:
+ * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
+ * Always point %gs to its beginning
+ */
+void __init setup_per_cpu_areas(void)
+{
+	int i;
+	unsigned long size;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	prefill_possible_map();
+#endif
+
+	/* Copy section for each CPU (we discard the original) */
+	size = PERCPU_ENOUGH_ROOM;
+
+	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
+			  size);
+	for_each_cpu_mask(i, cpu_possible_map) {
+		char *ptr;
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+		ptr = alloc_bootmem_pages(size);
+#else
+		int node = early_cpu_to_node(i);
+		if (!node_online(node) || !NODE_DATA(node))
+			ptr = alloc_bootmem_pages(size);
+		else
+			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
+#endif
+		if (!ptr)
+			panic("Cannot allocate cpu data for CPU %d\n", i);
+#ifdef CONFIG_X86_64
+		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
+#else
+		__per_cpu_offset[i] = ptr - __per_cpu_start;
+#endif
+		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+	}
+
+	/* setup percpu data maps early */
+	setup_per_cpu_maps();
+}
+
+#endif
diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index 143aa78..d4e4281 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -86,83 +86,6 @@ static int __init nonx32_setup(char *str)
 }
 __setup("noexec32=", nonx32_setup);
 
-/*
- * Copy data used in early init routines from the initial arrays to the
- * per cpu data areas.  These arrays then become expendable and the
- * *_early_ptr's are zeroed indicating that the static arrays are gone.
- */
-static void __init setup_per_cpu_maps(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-#ifdef CONFIG_SMP
-		if (per_cpu_offset(cpu)) {
-#endif
-			per_cpu(x86_cpu_to_apicid, cpu) =
-						x86_cpu_to_apicid_init[cpu];
-			per_cpu(x86_bios_cpu_apicid, cpu) =
-						x86_bios_cpu_apicid_init[cpu];
-#ifdef CONFIG_NUMA
-			per_cpu(x86_cpu_to_node_map, cpu) =
-						x86_cpu_to_node_map_init[cpu];
-#endif
-#ifdef CONFIG_SMP
-		}
-		else
-			printk(KERN_NOTICE "per_cpu_offset zero for cpu %d\n",
-									cpu);
-#endif
-	}
-
-	/* indicate the early static arrays will soon be gone */
-	x86_cpu_to_apicid_early_ptr = NULL;
-	x86_bios_cpu_apicid_early_ptr = NULL;
-#ifdef CONFIG_NUMA
-	x86_cpu_to_node_map_early_ptr = NULL;
-#endif
-}
-
-/*
- * Great future plan:
- * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
- * Always point %gs to its beginning
- */
-void __init setup_per_cpu_areas(void)
-{ 
-	int i;
-	unsigned long size;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	prefill_possible_map();
-#endif
-
-	/* Copy section for each CPU (we discard the original) */
-	size = PERCPU_ENOUGH_ROOM;
-
-	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n", size);
-	for_each_cpu_mask (i, cpu_possible_map) {
-		char *ptr;
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-		ptr = alloc_bootmem_pages(size);
-#else
-		int node = early_cpu_to_node(i);
-
-		if (!node_online(node) || !NODE_DATA(node))
-			ptr = alloc_bootmem_pages(size);
-		else
-			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
-#endif
-		if (!ptr)
-			panic("Cannot allocate cpu data for CPU %d\n", i);
-		cpu_pda(i)->data_offset = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
-	}
-
-	/* setup percpu data maps early */
-	setup_per_cpu_maps();
-} 
-
 void pda_init(int cpu)
 { 
 	struct x8664_pda *pda = cpu_pda(cpu);
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 92a5df6..bf5c9e9 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -665,6 +665,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 		unmap_cpu_to_logical_apicid(cpu);
 		cpu_clear(cpu, cpu_callout_map); /* was set here (do_boot_cpu()) */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
+		cpu_clear(cpu, cpu_possible_map);
 		cpucount--;
 	} else {
 		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
@@ -743,6 +744,7 @@ EXPORT_SYMBOL(xquad_portio);
 
 static void __init disable_smp(void)
 {
+	cpu_possible_map = cpumask_of_cpu(0);
 	smpboot_clear_io_apic_irqs();
 	phys_cpu_present_map = physid_mask_of_physid(0);
 	map_cpu_to_logical_apicid();
-- 
1.5.0.6

