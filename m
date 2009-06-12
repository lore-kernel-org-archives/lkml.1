Return-Path: <linux-kernel-owner+w=401wt.eu-S1765539AbZFLQ1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765539AbZFLQ1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764745AbZFLQY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:24:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39061 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764318AbZFLQY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 06/27] Blackfin: add blackfin_invalidate_entire_icache for SMP systems
Date: Fri, 12 Jun 2009 12:24:24 -0400
Message-Id: <1244823885-22410-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The KGDB code uses this when switching processors to make sure the icache
is in a valid state.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/cache.h      |   11 ++++++++---
 arch/blackfin/include/asm/cacheflush.h |    1 +
 arch/blackfin/include/asm/cpu.h        |    1 +
 arch/blackfin/kernel/setup.c           |    3 +++
 arch/blackfin/mach-common/cache-c.c    |   14 +++++++++++++-
 arch/blackfin/mach-common/smp.c        |   11 +++++++++++
 6 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/include/asm/cache.h b/arch/blackfin/include/asm/cache.h
index 8663781..2ef669e 100644
--- a/arch/blackfin/include/asm/cache.h
+++ b/arch/blackfin/include/asm/cache.h
@@ -34,9 +34,13 @@
 #define L1_CACHE_SHIFT_MAX	5
 
 #if defined(CONFIG_SMP) && \
-    !defined(CONFIG_BFIN_CACHE_COHERENT) && \
-    defined(CONFIG_BFIN_DCACHE)
-#define __ARCH_SYNC_CORE_DCACHE
+    !defined(CONFIG_BFIN_CACHE_COHERENT)
+# if defined(CONFIG_BFIN_ICACHE)
+# define __ARCH_SYNC_CORE_ICACHE
+# endif
+# if defined(CONFIG_BFIN_DCACHE)
+# define __ARCH_SYNC_CORE_DCACHE
+# endif
 #ifndef __ASSEMBLY__
 asmlinkage void __raw_smp_mark_barrier_asm(void);
 asmlinkage void __raw_smp_check_barrier_asm(void);
@@ -51,6 +55,7 @@ static inline void smp_check_barrier(void)
 }
 
 void resync_core_dcache(void);
+void resync_core_icache(void);
 #endif
 #endif
 
diff --git a/arch/blackfin/include/asm/cacheflush.h b/arch/blackfin/include/asm/cacheflush.h
index 18bc4f7..5c17dee 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -37,6 +37,7 @@ extern void blackfin_dcache_flush_range(unsigned long start_address, unsigned lo
 extern void blackfin_dcache_invalidate_range(unsigned long start_address, unsigned long end_address);
 extern void blackfin_dflush_page(void *page);
 extern void blackfin_invalidate_entire_dcache(void);
+extern void blackfin_invalidate_entire_icache(void);
 
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff --git a/arch/blackfin/include/asm/cpu.h b/arch/blackfin/include/asm/cpu.h
index c2594ef..565b813 100644
--- a/arch/blackfin/include/asm/cpu.h
+++ b/arch/blackfin/include/asm/cpu.h
@@ -34,6 +34,7 @@ struct blackfin_cpudata {
 	unsigned int dmemctl;
 	unsigned long loops_per_jiffy;
 	unsigned long dcache_invld_count;
+	unsigned long icache_invld_count;
 };
 
 DECLARE_PER_CPU(struct blackfin_cpudata, cpu_data);
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index f5f516e..6454bab 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -1181,6 +1181,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 #ifdef __ARCH_SYNC_CORE_DCACHE
 	seq_printf(m, "SMP Dcache Flushes\t: %lu\n\n", cpudata->dcache_invld_count);
 #endif
+#ifdef __ARCH_SYNC_CORE_ICACHE
+	seq_printf(m, "SMP Icache Flushes\t: %lu\n\n", cpudata->icache_invld_count);
+#endif
 #ifdef CONFIG_BFIN_ICACHE_LOCK
 	switch ((cpudata->imemctl >> 3) & WAYALL_L) {
 	case WAY0_L:
diff --git a/arch/blackfin/mach-common/cache-c.c b/arch/blackfin/mach-common/cache-c.c
index e6ab1f8..b59ce3c 100644
--- a/arch/blackfin/mach-common/cache-c.c
+++ b/arch/blackfin/mach-common/cache-c.c
@@ -16,9 +16,21 @@
 void blackfin_invalidate_entire_dcache(void)
 {
 	u32 dmem = bfin_read_DMEM_CONTROL();
-	SSYNC();
 	bfin_write_DMEM_CONTROL(dmem & ~0xc);
 	SSYNC();
 	bfin_write_DMEM_CONTROL(dmem);
 	SSYNC();
 }
+
+/* Invalidate the Entire Instruction cache by
+ * clearing IMC bit
+ */
+void blackfin_invalidate_entire_icache(void)
+{
+	u32 imem = bfin_read_IMEM_CONTROL();
+	bfin_write_IMEM_CONTROL(imem & ~0x4);
+	SSYNC();
+	bfin_write_IMEM_CONTROL(imem);
+	SSYNC();
+}
+
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 3b8ebae..c187da2 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -468,6 +468,17 @@ void smp_icache_flush_range_others(unsigned long start, unsigned long end)
 }
 EXPORT_SYMBOL_GPL(smp_icache_flush_range_others);
 
+#ifdef __ARCH_SYNC_CORE_ICACHE
+void resync_core_icache(void)
+{
+	unsigned int cpu = get_cpu();
+	blackfin_invalidate_entire_icache();
+	++per_cpu(cpu_data, cpu).icache_invld_count;
+	put_cpu();
+}
+EXPORT_SYMBOL(resync_core_icache);
+#endif
+
 #ifdef __ARCH_SYNC_CORE_DCACHE
 unsigned long barrier_mask __attribute__ ((__section__(".l2.bss")));
 
-- 
1.6.3.1

