Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbXD2DXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbXD2DXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXD2DW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:22:59 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36229 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbXD2DWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:22:31 -0400
X-IronPort-AV: i="4.14,465,1170651600"; 
   d="scan'208"; a="28603021:sNHT24642674"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/7] blackfin arch: move revid function into global headers as inline functions
Date: Sun, 29 Apr 2007 11:23:09 +0800
Message-Id: <1177816995452-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11778169933996-git-send-email-bryan.wu@analog.com>
References: <11778169933996-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c            |   72 +++++++-----------------------
 include/asm-blackfin/mach-bf533/bf533.h |    2 +-
 include/asm-blackfin/mach-bf537/bf537.h |    2 +-
 include/asm-blackfin/mach-bf561/bf561.h |    2 +-
 include/asm-blackfin/processor.h        |   25 +++++++++++
 5 files changed, 45 insertions(+), 58 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 6a2190f..724fd7a 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -121,34 +121,6 @@ void bf53x_relocate_l1_mem(void)
 
 }
 
-/* Get the DSP Revision ID */
-static u_int get_dsp_rev_id(void)
-{
-	u_int id;
-	id = bfin_read_DSPID() & 0xffff;
-#if defined(CONFIG_BF561)
-	id>>=8;
-#endif
-	return id;
-}
-
-static inline u_int get_compiled_rev_id(void)
-{
-#if defined(CONFIG_BF_REV_0_0)
-	return 0;
-#elif defined(CONFIG_BF_REV_0_1)
-	return 1;
-#elif defined(CONFIG_BF_REV_0_2)
-	return 2;
-#elif defined(CONFIG_BF_REV_0_3)
-	return 3;
-#elif defined(CONFIG_BF_REV_0_4)
-	return 4;
-#elif defined(CONFIG_BF_REV_0_5)
-	return 5;
-#endif
-}
-
 /*
  * Initial parsing of the command line.  Currently, we support:
  *  - Controlling the linux memory size: mem=xxx[KMG]
@@ -196,7 +168,7 @@ static __init void parse_cmdline_early(char *cmdline_p)
 
 void __init setup_arch(char **cmdline_p)
 {
-	int bootmap_size, id;
+	int bootmap_size;
 	unsigned long l1_length, sclk, cclk;
 #ifdef CONFIG_MTD_UCLINUX
 	unsigned long mtd_phys = 0;
@@ -329,30 +301,23 @@ void __init setup_arch(char **cmdline_p)
 	init_mm.brk = (unsigned long)0;
 
 	init_leds();
-	id = get_dsp_rev_id();
-
-	printk(KERN_INFO
-	       "Blackfin support (C) 2004-2006 Analog Devices, Inc.\n");
-	printk(KERN_INFO "Compiled for ADSP-%s Rev. 0.%d\n", CPU,
-	       get_compiled_rev_id());
-	if (id != get_compiled_rev_id())
-		printk(KERN_ERR
-		       "Warning: Compiled for Rev %d, but running on Rev %d\n",
-			get_compiled_rev_id(), id );
-	if (id < SUPPORTED_DSPID)
-		printk(KERN_ERR
-		       "Warning: Unsupported Chip Revision ADSP-%s Rev. 0.%d detected\n",
-		       CPU, id);
-	printk(KERN_INFO
-	       "Blackfin uClinux support by http://blackfin.uclinux.org/\n");
+
+	printk(KERN_INFO "Blackfin support (C) 2004-2007 Analog Devices, Inc.\n");
+	printk(KERN_INFO "Compiled for ADSP-%s Rev 0.%d\n", CPU, bfin_compiled_revid());
+	if (bfin_revid() != bfin_compiled_revid())
+		printk(KERN_ERR "Warning: Compiled for Rev %d, but running on Rev %d\n",
+		       bfin_compiled_revid(), bfin_revid());
+	if (bfin_revid() < SUPPORTED_REVID)
+		printk(KERN_ERR "Warning: Unsupported Chip Revision ADSP-%s Rev 0.%d detected\n",
+		       CPU, bfin_revid());
+	printk(KERN_INFO "Blackfin Linux support by http://blackfin.uclinux.org/\n");
 
 	printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu Mhz System Clock\n",
 	       cclk / 1000000,  sclk / 1000000);
 
 #if defined(ANOMALY_05000273)
 	if ((cclk >> 1) <= sclk)
-		printk(KERN_ERR
-		       "\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
+		printk("\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
 #endif
 
 	printk(KERN_INFO "Board Memory: %ldMB\n", physical_mem_end >> 20);
@@ -778,21 +743,19 @@ EXPORT_SYMBOL(get_sclk);
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	char *cpu, *mmu, *fpu, *name;
-#ifdef CONFIG_BLKFIN_CACHE_LOCK
-	int lock;
-#endif
+	uint32_t revid;
 
 	u_long cclk = 0, sclk = 0;
-	u_int id, dcache_size = 0, dsup_banks = 0;
+	u_int dcache_size = 0, dsup_banks = 0;
 
 	cpu = CPU;
 	mmu = "none";
 	fpu = "none";
+	revid = bfin_revid();
 	name = bfin_board_name;
 
 	cclk = get_cclk();
 	sclk = get_sclk();
-	id = get_dsp_rev_id();
 
 	seq_printf(m, "CPU:\t\tADSP-%s Rev. 0.%d\n"
 		   "MMU:\t\t%s\n"
@@ -801,7 +764,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		   "System Clock:\t%9lu Hz\n"
 		   "BogoMips:\t%lu.%02lu\n"
 		   "Calibration:\t%lu loops\n",
-		   cpu, id, mmu, fpu,
+		   cpu, revid, mmu, fpu,
 		   cclk,
 		   sclk,
 		   (loops_per_jiffy * HZ) / 500000,
@@ -856,8 +819,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		   dsup_banks, BLKFIN_DSUBBANKS, BLKFIN_DWAYS,
 		   BLKFIN_DLINES);
 #ifdef CONFIG_BLKFIN_CACHE_LOCK
-	lock = read_iloc();
-	switch (lock) {
+	switch (read_iloc()) {
 	case WAY0_L:
 		seq_printf(m, "Way0 Locked-Down\n");
 		break;
diff --git a/include/asm-blackfin/mach-bf533/bf533.h b/include/asm-blackfin/mach-bf533/bf533.h
index 095ca36..185fc12 100644
--- a/include/asm-blackfin/mach-bf533/bf533.h
+++ b/include/asm-blackfin/mach-bf533/bf533.h
@@ -30,7 +30,7 @@
 #ifndef __MACH_BF533_H__
 #define __MACH_BF533_H__
 
-#define SUPPORTED_DSPID 2
+#define SUPPORTED_REVID 2
 
 #define OFFSET_(x) ((x) & 0x0000FFFF)
 
diff --git a/include/asm-blackfin/mach-bf537/bf537.h b/include/asm-blackfin/mach-bf537/bf537.h
index 05b664f..b8924cd 100644
--- a/include/asm-blackfin/mach-bf537/bf537.h
+++ b/include/asm-blackfin/mach-bf537/bf537.h
@@ -30,7 +30,7 @@
 #ifndef __MACH_BF537_H__
 #define __MACH_BF537_H__
 
-#define SUPPORTED_DSPID 2
+#define SUPPORTED_REVID 2
 
 /* Masks for generic ERROR IRQ demultiplexing used in int-priority-sc.c */
 
diff --git a/include/asm-blackfin/mach-bf561/bf561.h b/include/asm-blackfin/mach-bf561/bf561.h
index ded1796..96a5d3a 100644
--- a/include/asm-blackfin/mach-bf561/bf561.h
+++ b/include/asm-blackfin/mach-bf561/bf561.h
@@ -30,7 +30,7 @@
 #ifndef __MACH_BF561_H__
 #define __MACH_BF561_H__
 
-#define SUPPORTED_DSPID		0x3
+#define SUPPORTED_REVID		0x3
 
 #define OFFSET_(x) ((x) & 0x0000FFFF)
 #define L1_ISRAM		0xFFA00000
diff --git a/include/asm-blackfin/processor.h b/include/asm-blackfin/processor.h
index 299c493..997465c 100644
--- a/include/asm-blackfin/processor.h
+++ b/include/asm-blackfin/processor.h
@@ -7,6 +7,7 @@
  */
 #define current_text_addr() ({ __label__ _l; _l: &&_l;})
 
+#include <asm/blackfin.h>
 #include <asm/segment.h>
 #include <linux/compiler.h>
 
@@ -102,4 +103,28 @@ unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()    	barrier()
 
+/* Get the Silicon Revision of the chip */
+static inline uint32_t bfin_revid(void)
+{
+	/* stored in the upper 4 bits */
+	return bfin_read_CHIPID() >> 28;
+}
+
+static inline uint32_t bfin_compiled_revid(void)
+{
+#if defined(CONFIG_BF_REV_0_0)
+	return 0;
+#elif defined(CONFIG_BF_REV_0_1)
+	return 1;
+#elif defined(CONFIG_BF_REV_0_2)
+	return 2;
+#elif defined(CONFIG_BF_REV_0_3)
+	return 3;
+#elif defined(CONFIG_BF_REV_0_4)
+	return 4;
+#elif defined(CONFIG_BF_REV_0_5)
+	return 5;
+#endif
+}
+
 #endif
-- 
1.5.1.2
