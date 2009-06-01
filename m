Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbZFAJDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbZFAJDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZFAJCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:02:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:36610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbZFAJCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:02:04 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>, Russell King <rmk@arm.linux.org.uk>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH 1/7] percpu: use dynamic percpu allocator as the default percpu allocator
Date: Mon,  1 Jun 2009 17:58:22 +0900
Message-Id: <1243846708-805-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243846708-805-1-git-send-email-tj@kernel.org>
References: <1243846708-805-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 08:58:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes most !CONFIG_HAVE_SETUP_PER_CPU_AREA archs use
dynamic percpu allocator.  The first chunk is allocated using
embedding helper and 8k is reserved for modules.  This ensures that
the new allocator behaves almost identically to the original allocator
as long as static percpu variables are concerned, so it shouldn't
introduce much breakage.

s390 and alpha use custom SHIFT_PERCPU_PTR() to work around addressing
range limit the addressing model imposes.  Unfortunately, this breaks
if the address is specified using a variable, so for now, the two
archs aren't converted.

The following architectures are affected by this change.

* sh
* arm
* cris
* mips
* sparc(32)
* blackfin
* avr32
* parisc
* m32r
* powerpc(32)

As this change makes the dynamic allocator the default one,
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is replaced with its invert -
CONFIG_HAVE_LEGACY_PER_CPU_AREA, which is added to yet-to-be converted
archs.  These archs implement their own setup_per_cpu_areas() and the
conversion is not trivial.

* powerpc(64)
* sparc(64)
* ia64
* alpha
* s390

Boot and batch alloc/free tests on x86_32 with debug code (x86_32
doesn't use default first chunk initialization).  Compile tested on
sparc(32), powerpc(32), arm and alpha.

[ Impact: use dynamic allocator for most archs w/o custom percpu setup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/Kconfig     |    3 +++
 arch/ia64/Kconfig      |    3 +++
 arch/powerpc/Kconfig   |    3 +++
 arch/s390/Kconfig      |    3 +++
 arch/sparc/Kconfig     |    3 +++
 arch/x86/Kconfig       |    3 ---
 include/linux/percpu.h |   12 +++++++++---
 init/main.c            |   24 ------------------------
 kernel/module.c        |    6 +++---
 mm/Makefile            |    2 +-
 mm/allocpercpu.c       |   28 ++++++++++++++++++++++++++++
 mm/percpu.c            |   40 +++++++++++++++++++++++++++++++++++++++-
 12 files changed, 95 insertions(+), 35 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 9fb8aae..05d8640 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -70,6 +70,9 @@ config AUTO_IRQ_AFFINITY
 	depends on SMP
 	default y
 
+config HAVE_LEGACY_PER_CPU_AREA
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 294a3b1..8e88df7 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -88,6 +88,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config HAVE_LEGACY_PER_CPU_AREA
+	def_bool y
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index cdc9a6f..664a20e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -42,6 +42,9 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
+config HAVE_LEGACY_PER_CPU_AREA
+	def_bool PPC64
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2eca5fe..686909a 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -75,6 +75,9 @@ config VIRT_CPU_ACCOUNTING
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
+config HAVE_LEGACY_PER_CPU_AREA
+	def_bool y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index cc12cd4..2e7f019 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -90,6 +90,9 @@ config AUDIT_ARCH
 	bool
 	default y
 
+config HAVE_LEGACY_PER_CPU_AREA
+	def_bool y if SPARC64
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y if SPARC64
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a6efe0a..52b17c2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -141,9 +141,6 @@ config ARCH_HAS_CACHE_LINE_SIZE
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
-config HAVE_DYNAMIC_PER_CPU_AREA
-	def_bool y
-
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 1581ff2..bbe5b2c 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -34,7 +34,7 @@
 
 #ifdef CONFIG_SMP
 
-#ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
+#ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
 
 /* minimum unit size, also is the maximum supported allocation size */
 #define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(64 << 10)
@@ -80,7 +80,7 @@ extern ssize_t __init pcpu_embed_first_chunk(
 
 extern void *__alloc_reserved_percpu(size_t size, size_t align);
 
-#else /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+#else /* CONFIG_HAVE_LEGACY_PER_CPU_AREA */
 
 struct percpu_data {
 	void *ptrs[1];
@@ -94,11 +94,15 @@ struct percpu_data {
         (__typeof__(ptr))__p->ptrs[(cpu)];				\
 })
 
-#endif /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+#endif /* CONFIG_HAVE_LEGACY_PER_CPU_AREA */
 
 extern void *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void *__pdata);
 
+#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
+extern void __init setup_per_cpu_areas(void);
+#endif
+
 #else /* CONFIG_SMP */
 
 #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
@@ -119,6 +123,8 @@ static inline void free_percpu(void *p)
 	kfree(p);
 }
 
+static inline void __init setup_per_cpu_areas(void) { }
+
 #endif /* CONFIG_SMP */
 
 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
diff --git a/init/main.c b/init/main.c
index d721dad..adb46ee 100644
--- a/init/main.c
+++ b/init/main.c
@@ -355,7 +355,6 @@ static void __init smp_init(void)
 #define smp_init()	do { } while (0)
 #endif
 
-static inline void setup_per_cpu_areas(void) { }
 static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 
@@ -376,29 +375,6 @@ static void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
-#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
-unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
-
-EXPORT_SYMBOL(__per_cpu_offset);
-
-static void __init setup_per_cpu_areas(void)
-{
-	unsigned long size, i;
-	char *ptr;
-	unsigned long nr_possible_cpus = num_possible_cpus();
-
-	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
-	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
-
-	for_each_possible_cpu(i) {
-		__per_cpu_offset[i] = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
-		ptr += size;
-	}
-}
-#endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
-
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)
 {
diff --git a/kernel/module.c b/kernel/module.c
index e797812..1559bd0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -359,7 +359,7 @@ EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
 
-#ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
+#ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
 
 static void *percpu_modalloc(unsigned long size, unsigned long align,
 			     const char *name)
@@ -384,7 +384,7 @@ static void percpu_modfree(void *freeme)
 	free_percpu(freeme);
 }
 
-#else /* ... !CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+#else /* ... CONFIG_HAVE_LEGACY_PER_CPU_AREA */
 
 /* Number of blocks used and allocated. */
 static unsigned int pcpu_num_used, pcpu_num_allocated;
@@ -519,7 +519,7 @@ static int percpu_modinit(void)
 }
 __initcall(percpu_modinit);
 
-#endif /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+#endif /* CONFIG_HAVE_LEGACY_PER_CPU_AREA */
 
 static unsigned int find_pcpusec(Elf_Ehdr *hdr,
 				 Elf_Shdr *sechdrs,
diff --git a/mm/Makefile b/mm/Makefile
index ec73c68..67838bd 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
-ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
+ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
 obj-$(CONFIG_SMP) += percpu.o
 else
 obj-$(CONFIG_SMP) += allocpercpu.o
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index dfdee6a..df34cea 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -5,6 +5,8 @@
  */
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/bootmem.h>
+#include <asm/sections.h>
 
 #ifndef cache_line_size
 #define cache_line_size()	L1_CACHE_BYTES
@@ -147,3 +149,29 @@ void free_percpu(void *__pdata)
 	kfree(__percpu_disguise(__pdata));
 }
 EXPORT_SYMBOL_GPL(free_percpu);
+
+/*
+ * Generic percpu area setup.
+ */
+#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+
+EXPORT_SYMBOL(__per_cpu_offset);
+
+void __init setup_per_cpu_areas(void)
+{
+	unsigned long size, i;
+	char *ptr;
+	unsigned long nr_possible_cpus = num_possible_cpus();
+
+	/* Copy section for each CPU (we discard the original) */
+	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
+	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
+
+	for_each_possible_cpu(i) {
+		__per_cpu_offset[i] = ptr - __per_cpu_start;
+		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+		ptr += size;
+	}
+}
+#endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
diff --git a/mm/percpu.c b/mm/percpu.c
index f780bee..d9b4059 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -43,7 +43,7 @@
  *
  * To use this allocator, arch code should do the followings.
  *
- * - define CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
+ * - drop CONFIG_HAVE_LEGACY_PER_CPU_AREA
  *
  * - define __addr_to_pcpu_ptr() and __pcpu_ptr_to_addr() to translate
  *   regular address to percpu pointer and back if they need to be
@@ -1276,3 +1276,41 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 				      reserved_size, dyn_size,
 				      pcpue_unit_size, pcpue_ptr, NULL);
 }
+
+/*
+ * Generic percpu area setup.
+ *
+ * The embedding helper is used because its behavior closely resembles
+ * the original non-dynamic generic percpu area setup.  This is
+ * important because many archs have addressing restrictions and might
+ * fail if the percpu area is located far away from the previous
+ * location.  As an added bonus, in non-NUMA cases, embedding is
+ * generally a good idea TLB-wise because percpu area can piggy back
+ * on the physical linear memory mapping which uses large page
+ * mappings on applicable archs.
+ */
+#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+EXPORT_SYMBOL(__per_cpu_offset);
+
+void __init setup_per_cpu_areas(void)
+{
+	size_t static_size = __per_cpu_end - __per_cpu_start;
+	ssize_t unit_size;
+	unsigned long delta;
+	unsigned int cpu;
+
+	/*
+	 * Always reserve area for module percpu variables.  That's
+	 * what the legacy allocator did.
+	 */
+	unit_size = pcpu_embed_first_chunk(static_size, PERCPU_MODULE_RESERVE,
+					   PERCPU_DYNAMIC_RESERVE, -1);
+	if (unit_size < 0)
+		panic("Failed to initialized percpu areas.");
+
+	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
+	for_each_possible_cpu(cpu)
+		__per_cpu_offset[cpu] = delta + cpu * unit_size;
+}
+#endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
-- 
1.6.0.2

