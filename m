Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZCJH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZCJH4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZCJH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:56:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:56852 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZCJH4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:56:10 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: Tejun Heo <tj@kernel.org>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 5/5] percpu: use dynamic percpu allocator as the default percpu allocator
Date: Tue, 10 Mar 2009 16:53:51 +0900
Message-Id: <1236671631-9305-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 07:54:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use dynamic allocator for all archs w/o CONFIG_HAVE_SETUP_PER_CPU_AREA

This patch makes !CONFIG_HAVE_SETUP_PER_CPU_AREA archs use dynamic
percpu allocator.  The first chunk is allocated using embedding helper
and 8k is reserved for modules.  This ensures that the new allocator
behaves almost identically to the original allocator as long as static
percpu variables are concerned, so it shouldn't introduce much
breakage.

One thing which can go wrong is SHIFT_PERCPU_PTR() overflowing on
dynamic percpu variables which might end up far from __per_cpu_start
or the text if percpu address calculation makes assumptions about how
far they can be located.  alpha and s390 already have this problem for
modules because module can be located far from the percpu area and
they have special provisions for it.  However, I don't think this will
be an issue for dynamic percpu variables as their offsets are carried
in full pointer variables instead of depending on relocations.

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
* alpha
* s390

As this change makes the dynamic allocator the default one,
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is replaced with its invert -
CONFIG_HAVE_LEGACY_PER_CPU_AREA, which is added to yet-to-be converted
archs.  These archs implement their own setup_per_cpu_areas() and the
conversion is not trivial.

* powerpc(64)
* sparc(64)
* ia64

Boot and batch alloc/free tests on x86_32 with debug code (x86_32
doesn't use default first chunk initialization).  Compile tested on
sparc(32), powerpc(32) and arm.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/ia64/Kconfig      |    3 +++
 arch/powerpc/Kconfig   |    3 +++
 arch/sparc/Kconfig     |    3 +++
 arch/x86/Kconfig       |    3 ---
 include/linux/percpu.h |   12 +++++++++---
 init/main.c            |   24 ------------------------
 kernel/module.c        |    6 +++---
 mm/Makefile            |    2 +-
 mm/percpu.c            |   40 +++++++++++++++++++++++++++++++++++++++-
 9 files changed, 61 insertions(+), 35 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 153e727..f333149 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -85,6 +85,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config HAVE_LEGACY_PER_CPU_AREA
+	def_bool y
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 74cc312..892f1ad 100644
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
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index c3ea215..0125b57 100644
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
index f5cef3f..572329a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -138,9 +138,6 @@ config ARCH_HAS_CACHE_LINE_SIZE
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
-config HAVE_DYNAMIC_PER_CPU_AREA
-	def_bool y
-
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ee5615d..1daed0c 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -78,7 +78,7 @@
 
 #ifdef CONFIG_SMP
 
-#ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
+#ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
 
 /* minimum unit size, also is the maximum supported allocation size */
 #define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(64 << 10)
@@ -124,7 +124,11 @@ extern ssize_t __init pcpu_embed_first_chunk(
 
 extern void *__alloc_reserved_percpu(size_t size, size_t align);
 
-#else /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
+extern void __init setup_per_cpu_areas(void);
+#endif
+
+#else /* CONFIG_HAVE_LEGACY_PER_CPU_AREA */
 
 struct percpu_data {
 	void *ptrs[1];
@@ -138,7 +142,7 @@ struct percpu_data {
         (__typeof__(ptr))__p->ptrs[(cpu)];				\
 })
 
-#endif /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+#endif /* CONFIG_HAVE_LEGACY_PER_CPU_AREA */
 
 extern void *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void *__pdata);
@@ -163,6 +167,8 @@ static inline void free_percpu(void *p)
 	kfree(p);
 }
 
+static inline void __init setup_per_cpu_areas(void) { }
+
 #endif /* CONFIG_SMP */
 
 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
diff --git a/init/main.c b/init/main.c
index 6441083..42ae3c0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -354,7 +354,6 @@ static void __init smp_init(void)
 #define smp_init()	do { } while (0)
 #endif
 
-static inline void setup_per_cpu_areas(void) { }
 static inline void setup_nr_cpu_ids(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 
@@ -375,29 +374,6 @@ static void __init setup_nr_cpu_ids(void)
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
index f0e04d6..f9c7b86 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -368,7 +368,7 @@ static struct module *find_module(const char *name)
 
 #ifdef CONFIG_SMP
 
-#ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
+#ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
 
 static void *percpu_modalloc(unsigned long size, unsigned long align,
 			     const char *name)
@@ -393,7 +393,7 @@ static void percpu_modfree(void *freeme)
 	free_percpu(freeme);
 }
 
-#else /* ... !CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+#else /* ... CONFIG_HAVE_LEGACY_PER_CPU_AREA */
 
 /* Number of blocks used and allocated. */
 static unsigned int pcpu_num_used, pcpu_num_allocated;
@@ -528,7 +528,7 @@ static int percpu_modinit(void)
 }
 __initcall(percpu_modinit);
 
-#endif /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+#endif /* CONFIG_HAVE_LEGACY_PER_CPU_AREA */
 
 static unsigned int find_pcpusec(Elf_Ehdr *hdr,
 				 Elf_Shdr *sechdrs,
diff --git a/mm/Makefile b/mm/Makefile
index 818569b..f3a037b 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
-ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
+ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
 obj-$(CONFIG_SMP) += percpu.o
 else
 obj-$(CONFIG_SMP) += allocpercpu.o
diff --git a/mm/percpu.c b/mm/percpu.c
index 1aa5d8f..059b57a 100644
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
@@ -1324,3 +1324,41 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
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

