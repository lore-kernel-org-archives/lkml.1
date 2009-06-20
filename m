Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbZFTStU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbZFTStU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757988AbZFTSqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48135 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941AbZFTSqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH 16/25] Blackfin: decouple unrelated cache settings to get exact behavior
Date: Sat, 20 Jun 2009 14:44:39 -0400
Message-Id: <1245523488-26536-17-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

The current cache options don't really represent the hardware features.
They end up setting different aspects of the hardware so that the end
result is to turn on/off the cache.  Unfortunately, when we hit cache
problems with the hardware, it's difficult to test different settings to
root cause the problem.  The current settings also don't cleanly allow for
different caching behaviors with different regions of memory.

So split the configure options such that they properly reflect the settings
that are applied to the hardware.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig                    |   57 ++++++++++++------
 arch/blackfin/include/asm/cache.h        |    4 +-
 arch/blackfin/include/asm/cacheflush.h   |   10 ++--
 arch/blackfin/include/asm/cplb.h         |   30 +++++----
 arch/blackfin/kernel/cplb-mpu/cplbinit.c |   10 ++--
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c  |   36 ++++++++----
 arch/blackfin/kernel/setup.c             |   96 ++++++++++++++++++++++++------
 arch/blackfin/mach-common/arch_checks.c  |    4 +-
 arch/blackfin/mach-common/cpufreq.c      |    2 +-
 arch/blackfin/mach-common/pm.c           |    4 +-
 arch/blackfin/mm/init.c                  |    2 +-
 11 files changed, 175 insertions(+), 80 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 8140a2f..220635a 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -907,23 +907,41 @@ endchoice
 
 
 comment "Cache Support"
+
 config BFIN_ICACHE
 	bool "Enable ICACHE"
+	default y
+config BFIN_ICACHE_LOCK
+	bool "Enable Instruction Cache Locking"
+	depends on BFIN_ICACHE
+	default n
+config BFIN_EXTMEM_ICACHEABLE
+	bool "Enable ICACHE for external memory"
+	depends on BFIN_ICACHE
+	default y
+config BFIN_L2_ICACHEABLE
+	bool "Enable ICACHE for L2 SRAM"
+	depends on BFIN_ICACHE
+	depends on BF54x || BF561
+	default n
+
 config BFIN_DCACHE
 	bool "Enable DCACHE"
+	default y
 config BFIN_DCACHE_BANKA
 	bool "Enable only 16k BankA DCACHE - BankB is SRAM"
 	depends on BFIN_DCACHE && !BF531
 	default n
-config BFIN_ICACHE_LOCK
-	bool "Enable Instruction Cache Locking"
-
-choice
-	prompt "External memory cache policy"
+config BFIN_EXTMEM_DCACHEABLE
+	bool "Enable DCACHE for external memory"
 	depends on BFIN_DCACHE
-	default BFIN_WB if !SMP
-	default BFIN_WT if SMP
-config BFIN_WB
+	default y
+choice
+	prompt "External memory DCACHE policy"
+	depends on BFIN_EXTMEM_DCACHEABLE
+	default BFIN_EXTMEM_WRITEBACK if !SMP
+	default BFIN_EXTMEM_WRITETHROUGH if SMP
+config BFIN_EXTMEM_WRITEBACK
 	bool "Write back"
 	depends on !SMP
 	help
@@ -941,7 +959,7 @@ config BFIN_WB
 	  If you are unsure of the options and you want to be safe,
 	  then go with Write Through.
 
-config BFIN_WT
+config BFIN_EXTMEM_WRITETHROUGH
 	bool "Write through"
 	help
 	  Write Back Policy:
@@ -960,23 +978,26 @@ config BFIN_WT
 
 endchoice
 
+config BFIN_L2_DCACHEABLE
+	bool "Enable DCACHE for L2 SRAM"
+	depends on BFIN_DCACHE
+	depends on BF54x || BF561
+	default n
 choice
-	prompt "L2 SRAM cache policy"
-	depends on (BF54x || BF561)
-	default BFIN_L2_WT
-config BFIN_L2_WB
+	prompt "L2 SRAM DCACHE policy"
+	depends on BFIN_L2_DCACHEABLE
+	default BFIN_L2_WRITEBACK
+config BFIN_L2_WRITEBACK
 	bool "Write back"
 	depends on !SMP
 
-config BFIN_L2_WT
+config BFIN_L2_WRITETHROUGH
 	bool "Write through"
 	depends on !SMP
-
-config BFIN_L2_NOT_CACHED
-	bool "Not cached"
-
 endchoice
 
+
+comment "Memory Protection Unit"
 config MPU
 	bool "Enable the memory protection unit (EXPERIMENTAL)"
 	default n
diff --git a/arch/blackfin/include/asm/cache.h b/arch/blackfin/include/asm/cache.h
index 2ef669e..477050a 100644
--- a/arch/blackfin/include/asm/cache.h
+++ b/arch/blackfin/include/asm/cache.h
@@ -35,10 +35,10 @@
 
 #if defined(CONFIG_SMP) && \
     !defined(CONFIG_BFIN_CACHE_COHERENT)
-# if defined(CONFIG_BFIN_ICACHE)
+# if defined(CONFIG_BFIN_ICACHEABLE) || defined(CONFIG_BFIN_L2_ICACHEABLE)
 # define __ARCH_SYNC_CORE_ICACHE
 # endif
-# if defined(CONFIG_BFIN_DCACHE)
+# if defined(CONFIG_BFIN_DCACHEABLE) || defined(CONFIG_BFIN_L2_DCACHEABLE)
 # define __ARCH_SYNC_CORE_DCACHE
 # endif
 #ifndef __ASSEMBLY__
diff --git a/arch/blackfin/include/asm/cacheflush.h b/arch/blackfin/include/asm/cacheflush.h
index 5c17dee..7e55549 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -56,7 +56,7 @@ extern void blackfin_invalidate_entire_icache(void);
 
 static inline void flush_icache_range(unsigned start, unsigned end)
 {
-#if defined(CONFIG_BFIN_WB)
+#if defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK)
 	blackfin_dcache_flush_range(start, end);
 #endif
 
@@ -87,9 +87,9 @@ do { memcpy(dst, src, len);						\
 #else
 # define invalidate_dcache_range(start,end)	do { } while (0)
 #endif
-#if defined(CONFIG_BFIN_DCACHE) && defined(CONFIG_BFIN_WB)
+#if defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK)
 # define flush_dcache_range(start,end)		blackfin_dcache_flush_range((start), (end))
-# define flush_dcache_page(page)			blackfin_dflush_page(page_address(page))
+# define flush_dcache_page(page)		blackfin_dflush_page(page_address(page))
 #else
 # define flush_dcache_range(start,end)		do { } while (0)
 # define flush_dcache_page(page)		do { } while (0)
@@ -100,7 +100,7 @@ extern unsigned long reserved_mem_icache_on;
 
 static inline int bfin_addr_dcacheable(unsigned long addr)
 {
-#ifdef CONFIG_BFIN_DCACHE
+#ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
 	if (addr < (_ramend - DMA_UNCACHED_REGION))
 		return 1;
 #endif
@@ -109,7 +109,7 @@ static inline int bfin_addr_dcacheable(unsigned long addr)
 		addr >= _ramend && addr < physical_mem_end)
 		return 1;
 
-#ifndef CONFIG_BFIN_L2_NOT_CACHED
+#ifdef CONFIG_BFIN_L2_DCACHEABLE
 	if (addr >= L2_START && addr < L2_START + L2_LENGTH)
 		return 1;
 #endif
diff --git a/arch/blackfin/include/asm/cplb.h b/arch/blackfin/include/asm/cplb.h
index a75a6a9..c5dacf8 100644
--- a/arch/blackfin/include/asm/cplb.h
+++ b/arch/blackfin/include/asm/cplb.h
@@ -37,8 +37,6 @@
 #define L1_IMEMORY        (               CPLB_USER_RD | CPLB_VALID | CPLB_LOCK)
 #define SDRAM_INON_CHBL   (               CPLB_USER_RD | CPLB_VALID)
 
-/*Use the menuconfig cache policy here - CONFIG_BFIN_WT/CONFIG_BFIN_WB*/
-
 #if ANOMALY_05000158
 #define ANOMALY_05000158_WORKAROUND             0x200
 #else
@@ -47,10 +45,12 @@
 
 #define CPLB_COMMON	(CPLB_DIRTY | CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND)
 
-#ifdef CONFIG_BFIN_WB         /*Write Back Policy */
+#ifdef CONFIG_BFIN_EXTMEM_WRITEBACK
 #define SDRAM_DGENERIC   (CPLB_L1_CHBL | CPLB_COMMON)
-#else                           /*Write Through */
+#elif defined(CONFIG_BFIN_EXTMEM_WRITETHROUGH)
 #define SDRAM_DGENERIC   (CPLB_L1_CHBL | CPLB_WT | CPLB_L1_AOW  | CPLB_COMMON)
+#else
+#define SDRAM_DGENERIC   (CPLB_COMMON)
 #endif
 
 #define SDRAM_DNON_CHBL  (CPLB_COMMON)
@@ -61,21 +61,23 @@
 
 #ifdef CONFIG_SMP
 #define L2_ATTR          (INITIAL_T | I_CPLB | D_CPLB)
-#define L2_IMEMORY       (CPLB_COMMON)
-#define L2_DMEMORY       (CPLB_LOCK | CPLB_COMMON)
+#define L2_IMEMORY       (CPLB_COMMON | PAGE_SIZE_1MB)
+#define L2_DMEMORY       (CPLB_LOCK | CPLB_COMMON | PAGE_SIZE_1MB)
 
 #else
 #define L2_ATTR          (INITIAL_T | SWITCH_T | I_CPLB | D_CPLB)
-#define L2_IMEMORY       (SDRAM_IGENERIC)
-
-# if defined(CONFIG_BFIN_L2_WB)
-# define L2_DMEMORY      (CPLB_L1_CHBL | CPLB_COMMON)
-# elif defined(CONFIG_BFIN_L2_WT)
-# define L2_DMEMORY      (CPLB_L1_CHBL | CPLB_WT | CPLB_L1_AOW  | CPLB_COMMON)
-# elif defined(CONFIG_BFIN_L2_NOT_CACHED)
-# define L2_DMEMORY      (CPLB_COMMON)
+# if defined(CONFIG_BFIN_L2_ICACHEABLE)
+# define L2_IMEMORY      (CPLB_L1_CHBL | CPLB_USER_RD | CPLB_VALID | PAGE_SIZE_1MB)
+# else
+# define L2_IMEMORY      (               CPLB_USER_RD | CPLB_VALID | PAGE_SIZE_1MB)
+# endif
+
+# if defined(CONFIG_BFIN_L2_WRITEBACK)
+# define L2_DMEMORY      (CPLB_L1_CHBL | CPLB_COMMON | PAGE_SIZE_1MB)
+# elif defined(CONFIG_BFIN_L2_WRITETHROUGH)
+# define L2_DMEMORY      (CPLB_L1_CHBL | CPLB_WT | CPLB_L1_AOW | CPLB_COMMON | PAGE_SIZE_1MB)
 # else
-# define L2_DMEMORY      (0)
+# define L2_DMEMORY      (CPLB_COMMON | PAGE_SIZE_1MB)
 # endif
 #endif /* CONFIG_SMP */
 
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
index c006a44..36193ee 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
@@ -46,13 +46,13 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
 
 	printk(KERN_INFO "MPU: setting up cplb tables with memory protection\n");
 
-#ifdef CONFIG_BFIN_ICACHE
+#ifdef CONFIG_BFIN_EXTMEM_ICACHEABLE
 	i_cache = CPLB_L1_CHBL | ANOMALY_05000158_WORKAROUND;
 #endif
 
-#ifdef CONFIG_BFIN_DCACHE
+#ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
 	d_cache = CPLB_L1_CHBL;
-#ifdef CONFIG_BFIN_WT
+#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
 	d_cache |= CPLB_L1_AOW | CPLB_WT;
 #endif
 #endif
@@ -91,9 +91,9 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
 	/* Cover L2 memory */
 #if L2_LENGTH > 0
 	dcplb_tbl[cpu][i_d].addr = L2_START;
-	dcplb_tbl[cpu][i_d++].data = L2_DMEMORY | PAGE_SIZE_1MB;
+	dcplb_tbl[cpu][i_d++].data = L2_DMEMORY;
 	icplb_tbl[cpu][i_i].addr = L2_START;
-	icplb_tbl[cpu][i_i++].data = L2_IMEMORY | PAGE_SIZE_1MB;
+	icplb_tbl[cpu][i_i++].data = L2_IMEMORY;
 #endif
 
 	first_mask_dcplb = i_d;
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
index 784923e..bcdfe9b 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
@@ -150,15 +150,19 @@ static noinline int dcplb_miss(unsigned int cpu)
 	nr_dcplb_miss[cpu]++;
 
 	d_data = CPLB_SUPV_WR | CPLB_VALID | CPLB_DIRTY | PAGE_SIZE_4KB;
-#ifdef CONFIG_BFIN_DCACHE
+#ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
 	if (bfin_addr_dcacheable(addr)) {
 		d_data |= CPLB_L1_CHBL | ANOMALY_05000158_WORKAROUND;
-#ifdef CONFIG_BFIN_WT
+# ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
 		d_data |= CPLB_L1_AOW | CPLB_WT;
-#endif
+# endif
 	}
 #endif
-	if (addr >= physical_mem_end) {
+
+	if (L2_LENGTH && addr >= L2_START && addr < L2_START + L2_LENGTH) {
+		addr = L2_START;
+		d_data = L2_DMEMORY;
+	} else if (addr >= physical_mem_end) {
 		if (addr >= ASYNC_BANK0_BASE && addr < ASYNC_BANK3_BASE + ASYNC_BANK3_SIZE
 		    && (status & FAULT_USERSUPV)) {
 			addr &= ~0x3fffff;
@@ -235,7 +239,7 @@ static noinline int icplb_miss(unsigned int cpu)
 
 	i_data = CPLB_VALID | CPLB_PORTPRIO | PAGE_SIZE_4KB;
 
-#ifdef CONFIG_BFIN_ICACHE
+#ifdef CONFIG_BFIN_EXTMEM_ICACHEABLE
 	/*
 	 * Normal RAM, and possibly the reserved memory area, are
 	 * cacheable.
@@ -245,7 +249,10 @@ static noinline int icplb_miss(unsigned int cpu)
 		i_data |= CPLB_L1_CHBL | ANOMALY_05000158_WORKAROUND;
 #endif
 
-	if (addr >= physical_mem_end) {
+	if (L2_LENGTH && addr >= L2_START && addr < L2_START + L2_LENGTH) {
+		addr = L2_START;
+		i_data = L2_IMEMORY;
+	} else if (addr >= physical_mem_end) {
 		if (addr >= BOOT_ROM_START && addr < BOOT_ROM_START + BOOT_ROM_LENGTH
 		    && (status & FAULT_USERSUPV)) {
 			addr &= ~(1 * 1024 * 1024 - 1);
@@ -365,13 +372,18 @@ void set_mask_dcplbs(unsigned long *masks, unsigned int cpu)
 	local_irq_save_hw(flags);
 	current_rwx_mask[cpu] = masks;
 
-	d_data = CPLB_SUPV_WR | CPLB_VALID | CPLB_DIRTY | PAGE_SIZE_4KB;
-#ifdef CONFIG_BFIN_DCACHE
-	d_data |= CPLB_L1_CHBL;
-#ifdef CONFIG_BFIN_WT
-	d_data |= CPLB_L1_AOW | CPLB_WT;
-#endif
+	if (L2_LENGTH && addr >= L2_START && addr < L2_START + L2_LENGTH) {
+		addr = L2_START;
+		d_data = L2_DMEMORY;
+	} else {
+		d_data = CPLB_SUPV_WR | CPLB_VALID | CPLB_DIRTY | PAGE_SIZE_4KB;
+#ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
+		d_data |= CPLB_L1_CHBL;
+# ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
+		d_data |= CPLB_L1_AOW | CPLB_WT;
+# endif
 #endif
+	}
 
 	disable_dcplb();
 	for (i = first_mask_dcplb; i < first_switched_dcplb; i++) {
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index b2782ea..8d78928 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -117,15 +117,49 @@ void __cpuinit bfin_setup_caches(unsigned int cpu)
 	 */
 #ifdef CONFIG_BFIN_ICACHE
 	printk(KERN_INFO "Instruction Cache Enabled for CPU%u\n", cpu);
+	printk(KERN_INFO "  External memory:"
+# ifdef CONFIG_BFIN_EXTMEM_ICACHEABLE
+	       " cacheable"
+# else
+	       " uncacheable"
+# endif
+	       " in instruction cache\n");
+	if (L2_LENGTH)
+		printk(KERN_INFO "  L2 SRAM        :"
+# ifdef CONFIG_BFIN_L2_ICACHEABLE
+		       " cacheable"
+# else
+		       " uncacheable"
+# endif
+		       " in instruction cache\n");
+
+#else
+	printk(KERN_INFO "Instruction Cache Disabled for CPU%u\n", cpu);
 #endif
+
 #ifdef CONFIG_BFIN_DCACHE
-	printk(KERN_INFO "Data Cache Enabled for CPU%u"
-# if defined CONFIG_BFIN_WB
-		" (write-back)"
-# elif defined CONFIG_BFIN_WT
-		" (write-through)"
+	printk(KERN_INFO "Data Cache Enabled for CPU%u\n", cpu);
+	printk(KERN_INFO "  External memory:"
+# if defined CONFIG_BFIN_EXTMEM_WRITEBACK
+	       " cacheable (write-back)"
+# elif defined CONFIG_BFIN_EXTMEM_WRITETHROUGH
+	       " cacheable (write-through)"
+# else
+	       " uncacheable"
+# endif
+	       " in data cache\n");
+	if (L2_LENGTH)
+		printk(KERN_INFO "  L2 SRAM        :"
+# if defined CONFIG_BFIN_L2_WRITEBACK
+		       " cacheable (write-back)"
+# elif defined CONFIG_BFIN_L2_WRITETHROUGH
+		       " cacheable (write-through)"
+# else
+		       " uncacheable"
 # endif
-		"\n", cpu);
+		       " in data cache\n");
+#else
+	printk(KERN_INFO "Data Cache Disabled for CPU%u\n", cpu);
 #endif
 }
 
@@ -516,7 +550,7 @@ static __init void memory_setup(void)
 	    && ((unsigned long *)mtd_phys)[1] == ROMSB_WORD1)
 		mtd_size =
 		    PAGE_ALIGN(be32_to_cpu(((unsigned long *)mtd_phys)[2]));
-#  if (defined(CONFIG_BFIN_ICACHE) && ANOMALY_05000263)
+#  if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
 	/* Due to a Hardware Anomaly we need to limit the size of usable
 	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
 	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
@@ -544,7 +578,7 @@ static __init void memory_setup(void)
 	dma_memcpy((void *)uclinux_ram_map.phys, _end, uclinux_ram_map.size);
 #endif				/* CONFIG_MTD_UCLINUX */
 
-#if (defined(CONFIG_BFIN_ICACHE) && ANOMALY_05000263)
+#if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
 	/* Due to a Hardware Anomaly we need to limit the size of usable
 	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
 	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
@@ -1158,16 +1192,25 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		icache_size = 0;
 
 	seq_printf(m, "cache size\t: %d KB(L1 icache) "
-		"%d KB(L1 dcache%s) %d KB(L2 cache)\n",
-		icache_size, dcache_size,
-#if defined CONFIG_BFIN_WB
-		"-wb"
-#elif defined CONFIG_BFIN_WT
-		"-wt"
-#endif
-		"", 0);
-
+		"%d KB(L1 dcache) %d KB(L2 cache)\n",
+		icache_size, dcache_size, 0);
 	seq_printf(m, "%s\n", cache);
+	seq_printf(m, "external memory\t: "
+#if defined(CONFIG_BFIN_EXTMEM_ICACHEABLE)
+		   "cacheable"
+#else
+		   "uncacheable"
+#endif
+		   " in instruction cache\n");
+	seq_printf(m, "external memory\t: "
+#if defined(CONFIG_BFIN_EXTMEM_WRITEBACK)
+		      "cacheable (write-back)"
+#elif defined(CONFIG_BFIN_EXTMEM_WRITETHROUGH)
+		      "cacheable (write-through)"
+#else
+		      "uncacheable"
+#endif
+		      " in data cache\n");
 
 	if (icache_size)
 		seq_printf(m, "icache setup\t: %d Sub-banks/%d Ways, %d Lines/Way\n",
@@ -1240,8 +1283,25 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (cpu_num != num_possible_cpus() - 1)
 		return 0;
 
-	if (L2_LENGTH)
+	if (L2_LENGTH) {
 		seq_printf(m, "L2 SRAM\t\t: %dKB\n", L2_LENGTH/0x400);
+		seq_printf(m, "L2 SRAM\t\t: "
+#if defined(CONFIG_BFIN_L2_ICACHEABLE)
+			      "cacheable"
+#else
+			      "uncacheable"
+#endif
+			      " in instruction cache\n");
+		seq_printf(m, "L2 SRAM\t\t: "
+#if defined(CONFIG_BFIN_L2_WRITEBACK)
+			      "cacheable (write-back)"
+#elif defined(CONFIG_BFIN_L2_WRITETHROUGH)
+			      "cacheable (write-through)"
+#else
+			      "uncacheable"
+#endif
+			      " in data cache\n");
+	}
 	seq_printf(m, "board name\t: %s\n", bfin_board_name);
 	seq_printf(m, "board memory\t: %ld kB (0x%p -> 0x%p)\n",
 		 physical_mem_end >> 10, (void *)0, (void *)physical_mem_end);
diff --git a/arch/blackfin/mach-common/arch_checks.c b/arch/blackfin/mach-common/arch_checks.c
index da93d92..5998d86 100644
--- a/arch/blackfin/mach-common/arch_checks.c
+++ b/arch/blackfin/mach-common/arch_checks.c
@@ -74,7 +74,7 @@
 
 /* if 220 exists, can not set External Memory WB and L2 not_cached, either External Memory not_cached and L2 WB */
 #if ANOMALY_05000220 && \
-	((defined(CONFIG_BFIN_WB) && defined(CONFIG_BFIN_L2_NOT_CACHED)) || \
-	 (!defined(CONFIG_BFIN_DCACHE) && defined(CONFIG_BFIN_L2_WB)))
+	((defined(CONFIG_BFIN_EXTMEM_WRITEBACK) && !defined(CONFIG_BFIN_L2_DCACHEABLE)) || \
+	 (!defined(CONFIG_BFIN_EXTMEM_DCACHEABLE) && defined(CONFIG_BFIN_L2_WRITEBACK)))
 # error You are exposing Anomaly 220 in this config, either config L2 as Write Through, or make External Memory WB.
 #endif
diff --git a/arch/blackfin/mach-common/cpufreq.c b/arch/blackfin/mach-common/cpufreq.c
index 70e3411..85c6580 100644
--- a/arch/blackfin/mach-common/cpufreq.c
+++ b/arch/blackfin/mach-common/cpufreq.c
@@ -141,7 +141,7 @@ static int __init __bfin_cpu_init(struct cpufreq_policy *policy)
 	sclk = get_sclk() / 1000;
 
 #if ANOMALY_05000273 || ANOMALY_05000274 || \
-	(!defined(CONFIG_BF54x) && defined(CONFIG_BFIN_DCACHE))
+	(!defined(CONFIG_BF54x) && defined(CONFIG_BFIN_EXTMEM_DCACHEABLE))
 	min_cclk = sclk * 2;
 #else
 	min_cclk = sclk;
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index bce5a84..9e7e27b 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -132,7 +132,7 @@ int bf53x_resume_l1_mem(unsigned char *memptr)
 	return 0;
 }
 
-#ifdef CONFIG_BFIN_WB
+#if defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK)
 static void flushinv_all_dcache(void)
 {
 	u32 way, bank, subbank, set;
@@ -175,7 +175,7 @@ static inline void dcache_disable(void)
 #ifdef CONFIG_BFIN_DCACHE
 	unsigned long ctrl;
 
-#ifdef CONFIG_BFIN_WB
+#if defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK)
 	flushinv_all_dcache();
 #endif
 	SSYNC();
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index 014a55a..68bd0bd 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -160,7 +160,7 @@ void __init mem_init(void)
 
 	/* do not count in kernel image between _rambase and _ramstart */
 	reservedpages -= (_ramstart - _rambase) >> PAGE_SHIFT;
-#if (defined(CONFIG_BFIN_ICACHE) && ANOMALY_05000263)
+#if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
 	reservedpages += (_ramend - memory_end - DMA_UNCACHED_REGION) >> PAGE_SHIFT;
 #endif
 
-- 
1.6.3.1

