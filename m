Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKRJEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKRJEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYKRJD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:03:58 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:31623 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYKRJDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:03:46 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62693725"
From: Bryan Wu <cooloney@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/5] Blackfin arch: SMP supporting patchset: Blackfin CPLB related code
Date: Tue, 18 Nov 2008 17:05:06 +0800
Message-Id: <1226999108-13839-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Blackfin dual core BF561 processor can support SMP like features.
https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like

In this patch, we provide SMP extend to Blackfin CPLB related code

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/include/asm/cplb-mpu.h        |   15 ++--
 arch/blackfin/include/asm/cplb.h            |   21 +++---
 arch/blackfin/include/asm/cplbinit.h        |   57 ++++++++++++---
 arch/blackfin/include/asm/mmu_context.h     |   27 +++++--
 arch/blackfin/kernel/cplb-mpu/cacheinit.c   |    4 +-
 arch/blackfin/kernel/cplb-mpu/cplbinfo.c    |   43 +++++++----
 arch/blackfin/kernel/cplb-mpu/cplbinit.c    |   43 ++++++------
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c     |  102 ++++++++++++++-------------
 arch/blackfin/kernel/cplb-nompu/cacheinit.c |    9 ++-
 arch/blackfin/kernel/cplb-nompu/cplbinfo.c  |   55 +++++++++------
 arch/blackfin/kernel/cplb-nompu/cplbinit.c  |   89 +++++++++---------------
 arch/blackfin/kernel/cplb-nompu/cplbmgr.S   |   29 ++++----
 12 files changed, 275 insertions(+), 219 deletions(-)

diff --git a/arch/blackfin/include/asm/cplb-mpu.h b/arch/blackfin/include/asm/cplb-mpu.h
index 75c67b9..80680ad 100644
--- a/arch/blackfin/include/asm/cplb-mpu.h
+++ b/arch/blackfin/include/asm/cplb-mpu.h
@@ -28,6 +28,7 @@
  */
 #ifndef __ASM_BFIN_CPLB_MPU_H
 #define __ASM_BFIN_CPLB_MPU_H
+#include <linux/threads.h>
 
 struct cplb_entry {
 	unsigned long data, addr;
@@ -39,22 +40,22 @@ struct mem_region {
 	unsigned long icplb_data;
 };
 
-extern struct cplb_entry dcplb_tbl[MAX_CPLBS];
-extern struct cplb_entry icplb_tbl[MAX_CPLBS];
+extern struct cplb_entry dcplb_tbl[NR_CPUS][MAX_CPLBS];
+extern struct cplb_entry icplb_tbl[NR_CPUS][MAX_CPLBS];
 extern int first_switched_icplb;
 extern int first_mask_dcplb;
 extern int first_switched_dcplb;
 
-extern int nr_dcplb_miss, nr_icplb_miss, nr_icplb_supv_miss, nr_dcplb_prot;
-extern int nr_cplb_flush;
+extern int nr_dcplb_miss[], nr_icplb_miss[], nr_icplb_supv_miss[];
+extern int nr_dcplb_prot[], nr_cplb_flush[];
 
 extern int page_mask_order;
 extern int page_mask_nelts;
 
-extern unsigned long *current_rwx_mask;
+extern unsigned long *current_rwx_mask[NR_CPUS];
 
-extern void flush_switched_cplbs(void);
-extern void set_mask_dcplbs(unsigned long *);
+extern void flush_switched_cplbs(unsigned int);
+extern void set_mask_dcplbs(unsigned long *, unsigned int);
 
 extern void __noreturn panic_cplb_error(int seqstat, struct pt_regs *);
 
diff --git a/arch/blackfin/include/asm/cplb.h b/arch/blackfin/include/asm/cplb.h
index 9e8b403..5f7545d 100644
--- a/arch/blackfin/include/asm/cplb.h
+++ b/arch/blackfin/include/asm/cplb.h
@@ -30,7 +30,6 @@
 #ifndef _CPLB_H
 #define _CPLB_H
 
-#include <asm/blackfin.h>
 #include <mach/anomaly.h>
 
 #define SDRAM_IGENERIC    (CPLB_L1_CHBL | CPLB_USER_RD | CPLB_VALID | CPLB_PORTPRIO)
@@ -55,13 +54,24 @@
 #endif
 
 #define L1_DMEMORY       (CPLB_LOCK | CPLB_COMMON)
+
+#ifdef CONFIG_SMP
+#define L2_ATTR           (INITIAL_T | I_CPLB | D_CPLB)
+#define L2_IMEMORY         (CPLB_COMMON | CPLB_LOCK)
+#define L2_DMEMORY         (CPLB_COMMON | CPLB_LOCK)
+
+#else
 #ifdef CONFIG_BFIN_L2_CACHEABLE
 #define L2_IMEMORY        (SDRAM_IGENERIC)
 #define L2_DMEMORY        (SDRAM_DGENERIC)
 #else
 #define L2_IMEMORY        (CPLB_COMMON)
 #define L2_DMEMORY        (CPLB_COMMON)
-#endif
+#endif /* CONFIG_BFIN_L2_CACHEABLE */
+
+#define L2_ATTR           (INITIAL_T | SWITCH_T | I_CPLB | D_CPLB)
+#endif /* CONFIG_SMP */
+
 #define SDRAM_DNON_CHBL  (CPLB_COMMON)
 #define SDRAM_EBIU       (CPLB_COMMON)
 #define SDRAM_OOPS       (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
@@ -71,14 +81,7 @@
 #define SIZE_1M 0x00100000      /* 1M */
 #define SIZE_4M 0x00400000      /* 4M */
 
-#ifdef CONFIG_MPU
 #define MAX_CPLBS 16
-#else
-#define MAX_CPLBS (16 * 2)
-#endif
-
-#define ASYNC_MEMORY_CPLB_COVERAGE	((ASYNC_BANK0_SIZE + ASYNC_BANK1_SIZE + \
-				 ASYNC_BANK2_SIZE + ASYNC_BANK3_SIZE) / SIZE_4M)
 
 #define CPLB_ENABLE_ICACHE_P	0
 #define CPLB_ENABLE_DCACHE_P	1
diff --git a/arch/blackfin/include/asm/cplbinit.h b/arch/blackfin/include/asm/cplbinit.h
index f845b41..6bfc257 100644
--- a/arch/blackfin/include/asm/cplbinit.h
+++ b/arch/blackfin/include/asm/cplbinit.h
@@ -36,6 +36,8 @@
 #ifdef CONFIG_MPU
 
 #include <asm/cplb-mpu.h>
+extern void bfin_icache_init(struct cplb_entry *icplb_tbl);
+extern void bfin_dcache_init(struct cplb_entry *icplb_tbl);
 
 #else
 
@@ -46,8 +48,40 @@
 
 #define IN_KERNEL 1
 
-enum
-{ZERO_P, L1I_MEM, L1D_MEM, SDRAM_KERN , SDRAM_RAM_MTD, SDRAM_DMAZ, RES_MEM, ASYNC_MEM, L2_MEM};
+#define ASYNC_MEMORY_CPLB_COVERAGE  ((ASYNC_BANK0_SIZE + ASYNC_BANK1_SIZE + \
+				ASYNC_BANK2_SIZE + ASYNC_BANK3_SIZE) / SIZE_4M)
+
+#define CPLB_MEM CONFIG_MAX_MEM_SIZE
+
+/*
+* Number of required data CPLB switchtable entries
+* MEMSIZE / 4 (we mostly install 4M page size CPLBs
+* approx 16 for smaller 1MB page size CPLBs for allignment purposes
+* 1 for L1 Data Memory
+* possibly 1 for L2 Data Memory
+* 1 for CONFIG_DEBUG_HUNT_FOR_ZERO
+* 1 for ASYNC Memory
+*/
+#define MAX_SWITCH_D_CPLBS (((CPLB_MEM / 4) + 16 + 1 + 1 + 1 \
+				 + ASYNC_MEMORY_CPLB_COVERAGE) * 2)
+
+/*
+* Number of required instruction CPLB switchtable entries
+* MEMSIZE / 4 (we mostly install 4M page size CPLBs
+* approx 12 for smaller 1MB page size CPLBs for allignment purposes
+* 1 for L1 Instruction Memory
+* possibly 1 for L2 Instruction Memory
+* 1 for CONFIG_DEBUG_HUNT_FOR_ZERO
+*/
+#define MAX_SWITCH_I_CPLBS (((CPLB_MEM / 4) + 12 + 1 + 1 + 1) * 2)
+
+/* Number of CPLB table entries, used for cplb-nompu. */
+#define CPLB_TBL_ENTRIES (16 * 4)
+
+enum {
+	ZERO_P, L1I_MEM, L1D_MEM, L2_MEM, SDRAM_KERN, SDRAM_RAM_MTD, SDRAM_DMAZ,
+	RES_MEM, ASYNC_MEM, OCB_ROM
+};
 
 struct cplb_desc {
 	u32 start; /* start address */
@@ -66,8 +100,8 @@ struct cplb_tab {
 	u16 size;
 };
 
-extern u_long icplb_table[];
-extern u_long dcplb_table[];
+extern u_long icplb_tables[NR_CPUS][CPLB_TBL_ENTRIES+1];
+extern u_long dcplb_tables[NR_CPUS][CPLB_TBL_ENTRIES+1];
 
 /* Till here we are discussing about the static memory management model.
  * However, the operating envoronments commonly define more CPLB
@@ -78,15 +112,18 @@ extern u_long dcplb_table[];
  * This is how Page descriptor Table is implemented in uClinux/Blackfin.
  */
 
-extern u_long ipdt_table[];
-extern u_long dpdt_table[];
+extern u_long ipdt_tables[NR_CPUS][MAX_SWITCH_I_CPLBS+1];
+extern u_long dpdt_tables[NR_CPUS][MAX_SWITCH_D_CPLBS+1];
 #ifdef CONFIG_CPLB_INFO
-extern u_long ipdt_swapcount_table[];
-extern u_long dpdt_swapcount_table[];
+extern u_long ipdt_swapcount_tables[NR_CPUS][MAX_SWITCH_I_CPLBS];
+extern u_long dpdt_swapcount_tables[NR_CPUS][MAX_SWITCH_D_CPLBS];
 #endif
+extern void bfin_icache_init(u_long icplbs[]);
+extern void bfin_dcache_init(u_long dcplbs[]);
 
 #endif /* CONFIG_MPU */
 
-extern void generate_cplb_tables(void);
-
+#if defined(CONFIG_BFIN_DCACHE) || defined(CONFIG_BFIN_ICACHE)
+extern void generate_cplb_tables_cpu(unsigned int cpu);
+#endif
 #endif
diff --git a/arch/blackfin/include/asm/mmu_context.h b/arch/blackfin/include/asm/mmu_context.h
index 35593dd..944e29f 100644
--- a/arch/blackfin/include/asm/mmu_context.h
+++ b/arch/blackfin/include/asm/mmu_context.h
@@ -37,6 +37,10 @@
 #include <asm/pgalloc.h>
 #include <asm/cplbinit.h>
 
+/* Note: L1 stacks are CPU-private things, so we bluntly disable this
+   feature in SMP mode, and use the per-CPU scratch SRAM bank only to
+   store the PDA instead. */
+
 extern void *current_l1_stack_save;
 extern int nr_l1stack_tasks;
 extern void *l1_stack_base;
@@ -88,12 +92,15 @@ activate_l1stack(struct mm_struct *mm, unsigned long sp_base)
 static inline void switch_mm(struct mm_struct *prev_mm, struct mm_struct *next_mm,
 			     struct task_struct *tsk)
 {
+#ifdef CONFIG_MPU
+	unsigned int cpu = smp_processor_id();
+#endif
 	if (prev_mm == next_mm)
 		return;
 #ifdef CONFIG_MPU
-	if (prev_mm->context.page_rwx_mask == current_rwx_mask) {
-		flush_switched_cplbs();
-		set_mask_dcplbs(next_mm->context.page_rwx_mask);
+	if (prev_mm->context.page_rwx_mask == current_rwx_mask[cpu]) {
+		flush_switched_cplbs(cpu);
+		set_mask_dcplbs(next_mm->context.page_rwx_mask, cpu);
 	}
 #endif
 
@@ -138,9 +145,10 @@ static inline void protect_page(struct mm_struct *mm, unsigned long addr,
 
 static inline void update_protections(struct mm_struct *mm)
 {
-	if (mm->context.page_rwx_mask == current_rwx_mask) {
-		flush_switched_cplbs();
-		set_mask_dcplbs(mm->context.page_rwx_mask);
+	unsigned int cpu = smp_processor_id();
+	if (mm->context.page_rwx_mask == current_rwx_mask[cpu]) {
+		flush_switched_cplbs(cpu);
+		set_mask_dcplbs(mm->context.page_rwx_mask, cpu);
 	}
 }
 #endif
@@ -165,6 +173,9 @@ init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 static inline void destroy_context(struct mm_struct *mm)
 {
 	struct sram_list_struct *tmp;
+#ifdef CONFIG_MPU
+	unsigned int cpu = smp_processor_id();
+#endif
 
 #ifdef CONFIG_APP_STACK_L1
 	if (current_l1_stack_save == mm->context.l1_stack_save)
@@ -179,8 +190,8 @@ static inline void destroy_context(struct mm_struct *mm)
 		kfree(tmp);
 	}
 #ifdef CONFIG_MPU
-	if (current_rwx_mask == mm->context.page_rwx_mask)
-		current_rwx_mask = NULL;
+	if (current_rwx_mask[cpu] == mm->context.page_rwx_mask)
+		current_rwx_mask[cpu] = NULL;
 	free_pages((unsigned long)mm->context.page_rwx_mask, page_mask_order);
 #endif
 }
diff --git a/arch/blackfin/kernel/cplb-mpu/cacheinit.c b/arch/blackfin/kernel/cplb-mpu/cacheinit.c
index a8b712a..c6ff947 100644
--- a/arch/blackfin/kernel/cplb-mpu/cacheinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cacheinit.c
@@ -25,7 +25,7 @@
 #include <asm/cplbinit.h>
 
 #if defined(CONFIG_BFIN_ICACHE)
-void __init bfin_icache_init(void)
+void __cpuinit bfin_icache_init(struct cplb_entry *icplb_tbl)
 {
 	unsigned long ctrl;
 	int i;
@@ -43,7 +43,7 @@ void __init bfin_icache_init(void)
 #endif
 
 #if defined(CONFIG_BFIN_DCACHE)
-void __init bfin_dcache_init(void)
+void __cpuinit bfin_dcache_init(struct cplb_entry *dcplb_tbl)
 {
 	unsigned long ctrl;
 	int i;
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinfo.c b/arch/blackfin/kernel/cplb-mpu/cplbinfo.c
index 822beef..00cb2cf 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbinfo.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbinfo.c
@@ -66,32 +66,32 @@ static char *cplb_print_entry(char *buf, struct cplb_entry *tbl, int switched)
 	return buf;
 }
 
-int cplbinfo_proc_output(char *buf)
+int cplbinfo_proc_output(char *buf, void *data)
 {
 	char *p;
+	unsigned int cpu = (unsigned int)data;;
 
 	p = buf;
 
-	p += sprintf(p, "------------------ CPLB Information ------------------\n\n");
-
+	p += sprintf(p, "------------- CPLB Information on CPU%u --------------\n\n", cpu);
 	if (bfin_read_IMEM_CONTROL() & ENICPLB) {
 		p += sprintf(p, "Instruction CPLB entry:\n");
-		p = cplb_print_entry(p, icplb_tbl, first_switched_icplb);
+		p = cplb_print_entry(p, icplb_tbl[cpu], first_switched_icplb);
 	} else
 		p += sprintf(p, "Instruction CPLB is disabled.\n\n");
 
 	if (1 || bfin_read_DMEM_CONTROL() & ENDCPLB) {
 		p += sprintf(p, "Data CPLB entry:\n");
-		p = cplb_print_entry(p, dcplb_tbl, first_switched_dcplb);
+		p = cplb_print_entry(p, dcplb_tbl[cpu], first_switched_dcplb);
 	} else
 		p += sprintf(p, "Data CPLB is disabled.\n");
 
 	p += sprintf(p, "ICPLB miss: %d\nICPLB supervisor miss: %d\n",
-		     nr_icplb_miss, nr_icplb_supv_miss);
+		     nr_icplb_miss[cpu], nr_icplb_supv_miss[cpu]);
 	p += sprintf(p, "DCPLB miss: %d\nDCPLB protection fault:%d\n",
-		     nr_dcplb_miss, nr_dcplb_prot);
+		     nr_dcplb_miss[cpu], nr_dcplb_prot[cpu]);
 	p += sprintf(p, "CPLB flushes: %d\n",
-		     nr_cplb_flush);
+		     nr_cplb_flush[cpu]);
 
 	return p - buf;
 }
@@ -101,7 +101,7 @@ static int cplbinfo_read_proc(char *page, char **start, off_t off,
 {
 	int len;
 
-	len = cplbinfo_proc_output(page);
+	len = cplbinfo_proc_output(page, data);
 	if (len <= off + count)
 		*eof = 1;
 	*start = page + off;
@@ -115,20 +115,33 @@ static int cplbinfo_read_proc(char *page, char **start, off_t off,
 
 static int __init cplbinfo_init(void)
 {
-	struct proc_dir_entry *entry;
+	struct proc_dir_entry *parent, *entry;
+	unsigned int cpu;
+	unsigned char str[10];
+
+	parent = proc_mkdir("cplbinfo", NULL);
 
-	entry = create_proc_entry("cplbinfo", 0, NULL);
-	if (!entry)
-		return -ENOMEM;
+	for_each_online_cpu(cpu) {
+		sprintf(str, "cpu%u", cpu);
+		entry = create_proc_entry(str, 0, parent);
+		if (!entry)
+			return -ENOMEM;
 
-	entry->read_proc = cplbinfo_read_proc;
-	entry->data = NULL;
+		entry->read_proc = cplbinfo_read_proc;
+		entry->data = (void *)cpu;
+	}
 
 	return 0;
 }
 
 static void __exit cplbinfo_exit(void)
 {
+	unsigned int cpu;
+	unsigned char str[20];
+	for_each_online_cpu(cpu) {
+		sprintf(str, "cplbinfo/cpu%u", cpu);
+		remove_proc_entry(str, NULL);
+	}
 	remove_proc_entry("cplbinfo", NULL);
 }
 
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
index 55af729..269d2a3 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
@@ -30,13 +30,13 @@
 # error the MPU will not function safely while Anomaly 05000263 applies
 #endif
 
-struct cplb_entry icplb_tbl[MAX_CPLBS];
-struct cplb_entry dcplb_tbl[MAX_CPLBS];
+struct cplb_entry icplb_tbl[NR_CPUS][MAX_CPLBS];
+struct cplb_entry dcplb_tbl[NR_CPUS][MAX_CPLBS];
 
 int first_switched_icplb, first_switched_dcplb;
 int first_mask_dcplb;
 
-void __init generate_cplb_tables(void)
+void __init generate_cplb_tables_cpu(unsigned int cpu)
 {
 	int i_d, i_i;
 	unsigned long addr;
@@ -55,15 +55,16 @@ void __init generate_cplb_tables(void)
 	d_cache |= CPLB_L1_AOW | CPLB_WT;
 #endif
 #endif
+
 	i_d = i_i = 0;
 
 	/* Set up the zero page.  */
-	dcplb_tbl[i_d].addr = 0;
-	dcplb_tbl[i_d++].data = SDRAM_OOPS | PAGE_SIZE_1KB;
+	dcplb_tbl[cpu][i_d].addr = 0;
+	dcplb_tbl[cpu][i_d++].data = SDRAM_OOPS | PAGE_SIZE_1KB;
 
 #if 0
-	icplb_tbl[i_i].addr = 0;
-	icplb_tbl[i_i++].data = i_cache | CPLB_USER_RD | PAGE_SIZE_4KB;
+	icplb_tbl[cpu][i_i].addr = 0;
+	icplb_tbl[cpu][i_i++].data = i_cache | CPLB_USER_RD | PAGE_SIZE_4KB;
 #endif
 
 	/* Cover kernel memory with 4M pages.  */
@@ -72,28 +73,28 @@ void __init generate_cplb_tables(void)
 	i_data = i_cache | CPLB_VALID | CPLB_PORTPRIO | PAGE_SIZE_4MB;
 
 	for (; addr < memory_start; addr += 4 * 1024 * 1024) {
-		dcplb_tbl[i_d].addr = addr;
-		dcplb_tbl[i_d++].data = d_data;
-		icplb_tbl[i_i].addr = addr;
-		icplb_tbl[i_i++].data = i_data | (addr == 0 ? CPLB_USER_RD : 0);
+		dcplb_tbl[cpu][i_d].addr = addr;
+		dcplb_tbl[cpu][i_d++].data = d_data;
+		icplb_tbl[cpu][i_i].addr = addr;
+		icplb_tbl[cpu][i_i++].data = i_data | (addr == 0 ? CPLB_USER_RD : 0);
 	}
 
 	/* Cover L1 memory.  One 4M area for code and data each is enough.  */
 #if L1_DATA_A_LENGTH > 0 || L1_DATA_B_LENGTH > 0
-	dcplb_tbl[i_d].addr = L1_DATA_A_START;
-	dcplb_tbl[i_d++].data = L1_DMEMORY | PAGE_SIZE_4MB;
+	dcplb_tbl[cpu][i_d].addr = get_l1_data_a_start_cpu(cpu);
+	dcplb_tbl[cpu][i_d++].data = L1_DMEMORY | PAGE_SIZE_4MB;
 #endif
 #if L1_CODE_LENGTH > 0
-	icplb_tbl[i_i].addr = L1_CODE_START;
-	icplb_tbl[i_i++].data = L1_IMEMORY | PAGE_SIZE_4MB;
+	icplb_tbl[cpu][i_i].addr = get_l1_code_start_cpu(cpu);
+	icplb_tbl[cpu][i_i++].data = L1_IMEMORY | PAGE_SIZE_4MB;
 #endif
 
 	/* Cover L2 memory */
 #if L2_LENGTH > 0
-	dcplb_tbl[i_d].addr = L2_START;
-	dcplb_tbl[i_d++].data = L2_DMEMORY | PAGE_SIZE_1MB;
-	icplb_tbl[i_i].addr = L2_START;
-	icplb_tbl[i_i++].data = L2_IMEMORY | PAGE_SIZE_1MB;
+	dcplb_tbl[cpu][i_d].addr = L2_START;
+	dcplb_tbl[cpu][i_d++].data = L2_DMEMORY | PAGE_SIZE_1MB;
+	icplb_tbl[cpu][i_i].addr = L2_START;
+	icplb_tbl[cpu][i_i++].data = L2_IMEMORY | PAGE_SIZE_1MB;
 #endif
 
 	first_mask_dcplb = i_d;
@@ -101,7 +102,7 @@ void __init generate_cplb_tables(void)
 	first_switched_icplb = i_i;
 
 	while (i_d < MAX_CPLBS)
-		dcplb_tbl[i_d++].data = 0;
+		dcplb_tbl[cpu][i_d++].data = 0;
 	while (i_i < MAX_CPLBS)
-		icplb_tbl[i_i++].data = 0;
+		icplb_tbl[cpu][i_i++].data = 0;
 }
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
index baa52e2..76bd991 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
@@ -30,10 +30,11 @@
 
 int page_mask_nelts;
 int page_mask_order;
-unsigned long *current_rwx_mask;
+unsigned long *current_rwx_mask[NR_CPUS];
 
-int nr_dcplb_miss, nr_icplb_miss, nr_icplb_supv_miss, nr_dcplb_prot;
-int nr_cplb_flush;
+int nr_dcplb_miss[NR_CPUS], nr_icplb_miss[NR_CPUS];
+int nr_icplb_supv_miss[NR_CPUS], nr_dcplb_prot[NR_CPUS];
+int nr_cplb_flush[NR_CPUS];
 
 static inline void disable_dcplb(void)
 {
@@ -98,42 +99,42 @@ static inline int write_permitted(int status, unsigned long data)
 }
 
 /* Counters to implement round-robin replacement.  */
-static int icplb_rr_index, dcplb_rr_index;
+static int icplb_rr_index[NR_CPUS], dcplb_rr_index[NR_CPUS];
 
 /*
  * Find an ICPLB entry to be evicted and return its index.
  */
-static int evict_one_icplb(void)
+static int evict_one_icplb(unsigned int cpu)
 {
 	int i;
 	for (i = first_switched_icplb; i < MAX_CPLBS; i++)
-		if ((icplb_tbl[i].data & CPLB_VALID) == 0)
+		if ((icplb_tbl[cpu][i].data & CPLB_VALID) == 0)
 			return i;
-	i = first_switched_icplb + icplb_rr_index;
+	i = first_switched_icplb + icplb_rr_index[cpu];
 	if (i >= MAX_CPLBS) {
 		i -= MAX_CPLBS - first_switched_icplb;
-		icplb_rr_index -= MAX_CPLBS - first_switched_icplb;
+		icplb_rr_index[cpu] -= MAX_CPLBS - first_switched_icplb;
 	}
-	icplb_rr_index++;
+	icplb_rr_index[cpu]++;
 	return i;
 }
 
-static int evict_one_dcplb(void)
+static int evict_one_dcplb(unsigned int cpu)
 {
 	int i;
 	for (i = first_switched_dcplb; i < MAX_CPLBS; i++)
-		if ((dcplb_tbl[i].data & CPLB_VALID) == 0)
+		if ((dcplb_tbl[cpu][i].data & CPLB_VALID) == 0)
 			return i;
-	i = first_switched_dcplb + dcplb_rr_index;
+	i = first_switched_dcplb + dcplb_rr_index[cpu];
 	if (i >= MAX_CPLBS) {
 		i -= MAX_CPLBS - first_switched_dcplb;
-		dcplb_rr_index -= MAX_CPLBS - first_switched_dcplb;
+		dcplb_rr_index[cpu] -= MAX_CPLBS - first_switched_dcplb;
 	}
-	dcplb_rr_index++;
+	dcplb_rr_index[cpu]++;
 	return i;
 }
 
-static noinline int dcplb_miss(void)
+static noinline int dcplb_miss(unsigned int cpu)
 {
 	unsigned long addr = bfin_read_DCPLB_FAULT_ADDR();
 	int status = bfin_read_DCPLB_STATUS();
@@ -141,7 +142,7 @@ static noinline int dcplb_miss(void)
 	int idx;
 	unsigned long d_data;
 
-	nr_dcplb_miss++;
+	nr_dcplb_miss[cpu]++;
 
 	d_data = CPLB_SUPV_WR | CPLB_VALID | CPLB_DIRTY | PAGE_SIZE_4KB;
 #ifdef CONFIG_BFIN_DCACHE
@@ -168,25 +169,25 @@ static noinline int dcplb_miss(void)
 	} else if (addr >= _ramend) {
 	    d_data |= CPLB_USER_RD | CPLB_USER_WR;
 	} else {
-		mask = current_rwx_mask;
+		mask = current_rwx_mask[cpu];
 		if (mask) {
 			int page = addr >> PAGE_SHIFT;
-			int offs = page >> 5;
+			int idx = page >> 5;
 			int bit = 1 << (page & 31);
 
-			if (mask[offs] & bit)
+			if (mask[idx] & bit)
 				d_data |= CPLB_USER_RD;
 
 			mask += page_mask_nelts;
-			if (mask[offs] & bit)
+			if (mask[idx] & bit)
 				d_data |= CPLB_USER_WR;
 		}
 	}
-	idx = evict_one_dcplb();
+	idx = evict_one_dcplb(cpu);
 
 	addr &= PAGE_MASK;
-	dcplb_tbl[idx].addr = addr;
-	dcplb_tbl[idx].data = d_data;
+	dcplb_tbl[cpu][idx].addr = addr;
+	dcplb_tbl[cpu][idx].data = d_data;
 
 	disable_dcplb();
 	bfin_write32(DCPLB_DATA0 + idx * 4, d_data);
@@ -196,21 +197,21 @@ static noinline int dcplb_miss(void)
 	return 0;
 }
 
-static noinline int icplb_miss(void)
+static noinline int icplb_miss(unsigned int cpu)
 {
 	unsigned long addr = bfin_read_ICPLB_FAULT_ADDR();
 	int status = bfin_read_ICPLB_STATUS();
 	int idx;
 	unsigned long i_data;
 
-	nr_icplb_miss++;
+	nr_icplb_miss[cpu]++;
 
 	/* If inside the uncached DMA region, fault.  */
 	if (addr >= _ramend - DMA_UNCACHED_REGION && addr < _ramend)
 		return CPLB_PROT_VIOL;
 
 	if (status & FAULT_USERSUPV)
-		nr_icplb_supv_miss++;
+		nr_icplb_supv_miss[cpu]++;
 
 	/*
 	 * First, try to find a CPLB that matches this address.  If we
@@ -218,8 +219,8 @@ static noinline int icplb_miss(void)
 	 * that the instruction crosses a page boundary.
 	 */
 	for (idx = first_switched_icplb; idx < MAX_CPLBS; idx++) {
-		if (icplb_tbl[idx].data & CPLB_VALID) {
-			unsigned long this_addr = icplb_tbl[idx].addr;
+		if (icplb_tbl[cpu][idx].data & CPLB_VALID) {
+			unsigned long this_addr = icplb_tbl[cpu][idx].addr;
 			if (this_addr <= addr && this_addr + PAGE_SIZE > addr) {
 				addr += PAGE_SIZE;
 				break;
@@ -257,23 +258,23 @@ static noinline int icplb_miss(void)
 		 * Otherwise, check the x bitmap of the current process.
 		 */
 		if (!(status & FAULT_USERSUPV)) {
-			unsigned long *mask = current_rwx_mask;
+			unsigned long *mask = current_rwx_mask[cpu];
 
 			if (mask) {
 				int page = addr >> PAGE_SHIFT;
-				int offs = page >> 5;
+				int idx = page >> 5;
 				int bit = 1 << (page & 31);
 
 				mask += 2 * page_mask_nelts;
-				if (mask[offs] & bit)
+				if (mask[idx] & bit)
 					i_data |= CPLB_USER_RD;
 			}
 		}
 	}
-	idx = evict_one_icplb();
+	idx = evict_one_icplb(cpu);
 	addr &= PAGE_MASK;
-	icplb_tbl[idx].addr = addr;
-	icplb_tbl[idx].data = i_data;
+	icplb_tbl[cpu][idx].addr = addr;
+	icplb_tbl[cpu][idx].data = i_data;
 
 	disable_icplb();
 	bfin_write32(ICPLB_DATA0 + idx * 4, i_data);
@@ -283,19 +284,19 @@ static noinline int icplb_miss(void)
 	return 0;
 }
 
-static noinline int dcplb_protection_fault(void)
+static noinline int dcplb_protection_fault(unsigned int cpu)
 {
 	int status = bfin_read_DCPLB_STATUS();
 
-	nr_dcplb_prot++;
+	nr_dcplb_prot[cpu]++;
 
 	if (status & FAULT_RW) {
 		int idx = faulting_cplb_index(status);
-		unsigned long data = dcplb_tbl[idx].data;
+		unsigned long data = dcplb_tbl[cpu][idx].data;
 		if (!(data & CPLB_WT) && !(data & CPLB_DIRTY) &&
 		    write_permitted(status, data)) {
 			data |= CPLB_DIRTY;
-			dcplb_tbl[idx].data = data;
+			dcplb_tbl[cpu][idx].data = data;
 			bfin_write32(DCPLB_DATA0 + idx * 4, data);
 			return 0;
 		}
@@ -306,36 +307,37 @@ static noinline int dcplb_protection_fault(void)
 int cplb_hdr(int seqstat, struct pt_regs *regs)
 {
 	int cause = seqstat & 0x3f;
+	unsigned int cpu = smp_processor_id();
 	switch (cause) {
 	case 0x23:
-		return dcplb_protection_fault();
+		return dcplb_protection_fault(cpu);
 	case 0x2C:
-		return icplb_miss();
+		return icplb_miss(cpu);
 	case 0x26:
-		return dcplb_miss();
+		return dcplb_miss(cpu);
 	default:
 		return 1;
 	}
 }
 
-void flush_switched_cplbs(void)
+void flush_switched_cplbs(unsigned int cpu)
 {
 	int i;
 	unsigned long flags;
 
-	nr_cplb_flush++;
+	nr_cplb_flush[cpu]++;
 
 	local_irq_save(flags);
 	disable_icplb();
 	for (i = first_switched_icplb; i < MAX_CPLBS; i++) {
-		icplb_tbl[i].data = 0;
+		icplb_tbl[cpu][i].data = 0;
 		bfin_write32(ICPLB_DATA0 + i * 4, 0);
 	}
 	enable_icplb();
 
 	disable_dcplb();
 	for (i = first_switched_dcplb; i < MAX_CPLBS; i++) {
-		dcplb_tbl[i].data = 0;
+		dcplb_tbl[cpu][i].data = 0;
 		bfin_write32(DCPLB_DATA0 + i * 4, 0);
 	}
 	enable_dcplb();
@@ -343,7 +345,7 @@ void flush_switched_cplbs(void)
 
 }
 
-void set_mask_dcplbs(unsigned long *masks)
+void set_mask_dcplbs(unsigned long *masks, unsigned int cpu)
 {
 	int i;
 	unsigned long addr = (unsigned long)masks;
@@ -351,12 +353,12 @@ void set_mask_dcplbs(unsigned long *masks)
 	unsigned long flags;
 
 	if (!masks) {
-		current_rwx_mask = masks;
+		current_rwx_mask[cpu] = masks;
 		return;
 	}
 
 	local_irq_save(flags);
-	current_rwx_mask = masks;
+	current_rwx_mask[cpu] = masks;
 
 	d_data = CPLB_SUPV_WR | CPLB_VALID | CPLB_DIRTY | PAGE_SIZE_4KB;
 #ifdef CONFIG_BFIN_DCACHE
@@ -368,8 +370,8 @@ void set_mask_dcplbs(unsigned long *masks)
 
 	disable_dcplb();
 	for (i = first_mask_dcplb; i < first_switched_dcplb; i++) {
-		dcplb_tbl[i].addr = addr;
-		dcplb_tbl[i].data = d_data;
+		dcplb_tbl[cpu][i].addr = addr;
+		dcplb_tbl[cpu][i].data = d_data;
 		bfin_write32(DCPLB_DATA0 + i * 4, d_data);
 		bfin_write32(DCPLB_ADDR0 + i * 4, addr);
 		addr += PAGE_SIZE;
diff --git a/arch/blackfin/kernel/cplb-nompu/cacheinit.c b/arch/blackfin/kernel/cplb-nompu/cacheinit.c
index bd08315..3a385ae 100644
--- a/arch/blackfin/kernel/cplb-nompu/cacheinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cacheinit.c
@@ -25,9 +25,9 @@
 #include <asm/cplbinit.h>
 
 #if defined(CONFIG_BFIN_ICACHE)
-void __init bfin_icache_init(void)
+void __cpuinit bfin_icache_init(u_long icplb[])
 {
-	unsigned long *table = icplb_table;
+	unsigned long *table = icplb;
 	unsigned long ctrl;
 	int i;
 
@@ -47,9 +47,9 @@ void __init bfin_icache_init(void)
 #endif
 
 #if defined(CONFIG_BFIN_DCACHE)
-void __init bfin_dcache_init(void)
+void __cpuinit bfin_dcache_init(u_long dcplb[])
 {
-	unsigned long *table = dcplb_table;
+	unsigned long *table = dcplb;
 	unsigned long ctrl;
 	int i;
 
@@ -64,6 +64,7 @@ void __init bfin_dcache_init(void)
 	ctrl = bfin_read_DMEM_CONTROL();
 	ctrl |= DMEM_CNTR;
 	bfin_write_DMEM_CONTROL(ctrl);
+
 	SSYNC();
 }
 #endif
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinfo.c b/arch/blackfin/kernel/cplb-nompu/cplbinfo.c
index 1e74f0b..3f00809 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinfo.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinfo.c
@@ -68,22 +68,22 @@ static int cplb_find_entry(unsigned long *cplb_addr,
 	return -1;
 }
 
-static char *cplb_print_entry(char *buf, int type)
+static char *cplb_print_entry(char *buf, int type, unsigned int cpu)
 {
-	unsigned long *p_addr = dpdt_table;
-	unsigned long *p_data = dpdt_table + 1;
-	unsigned long *p_icount = dpdt_swapcount_table;
-	unsigned long *p_ocount = dpdt_swapcount_table + 1;
+	unsigned long *p_addr = dpdt_tables[cpu];
+	unsigned long *p_data = dpdt_tables[cpu] + 1;
+	unsigned long *p_icount = dpdt_swapcount_tables[cpu];
+	unsigned long *p_ocount = dpdt_swapcount_tables[cpu] + 1;
 	unsigned long *cplb_addr = (unsigned long *)DCPLB_ADDR0;
 	unsigned long *cplb_data = (unsigned long *)DCPLB_DATA0;
 	int entry = 0, used_cplb = 0;
 
 	if (type == CPLB_I) {
 		buf += sprintf(buf, "Instruction CPLB entry:\n");
-		p_addr = ipdt_table;
-		p_data = ipdt_table + 1;
-		p_icount = ipdt_swapcount_table;
-		p_ocount = ipdt_swapcount_table + 1;
+		p_addr = ipdt_tables[cpu];
+		p_data = ipdt_tables[cpu] + 1;
+		p_icount = ipdt_swapcount_tables[cpu];
+		p_ocount = ipdt_swapcount_tables[cpu] + 1;
 		cplb_addr = (unsigned long *)ICPLB_ADDR0;
 		cplb_data = (unsigned long *)ICPLB_DATA0;
 	} else
@@ -134,24 +134,24 @@ static char *cplb_print_entry(char *buf, int type)
 	return buf;
 }
 
-static int cplbinfo_proc_output(char *buf)
+static int cplbinfo_proc_output(char *buf, void *data)
 {
+	unsigned int cpu = (unsigned int)data;
 	char *p;
 
 	p = buf;
 
-	p += sprintf(p, "------------------ CPLB Information ------------------\n\n");
+	p += sprintf(p, "------------- CPLB Information on CPU%u--------------\n\n", cpu);
 
 	if (bfin_read_IMEM_CONTROL() & ENICPLB)
-		p = cplb_print_entry(p, CPLB_I);
+		p = cplb_print_entry(p, CPLB_I, cpu);
 	else
 		p += sprintf(p, "Instruction CPLB is disabled.\n\n");
 
 	if (bfin_read_DMEM_CONTROL() & ENDCPLB)
-		p = cplb_print_entry(p, CPLB_D);
+		p = cplb_print_entry(p, CPLB_D, cpu);
 	else
 		p += sprintf(p, "Data CPLB is disabled.\n");
-
 	return p - buf;
 }
 
@@ -160,7 +160,7 @@ static int cplbinfo_read_proc(char *page, char **start, off_t off,
 {
 	int len;
 
-	len = cplbinfo_proc_output(page);
+	len = cplbinfo_proc_output(page, data);
 	if (len <= off + count)
 		*eof = 1;
 	*start = page + off;
@@ -174,20 +174,33 @@ static int cplbinfo_read_proc(char *page, char **start, off_t off,
 
 static int __init cplbinfo_init(void)
 {
-	struct proc_dir_entry *entry;
+	struct proc_dir_entry *parent, *entry;
+	unsigned int cpu;
+	unsigned char str[10];
+
+	parent = proc_mkdir("cplbinfo", NULL);
 
-	entry = create_proc_entry("cplbinfo", 0, NULL);
-	if (!entry)
-		return -ENOMEM;
+	for_each_online_cpu(cpu) {
+		sprintf(str, "cpu%u", cpu);
+		entry = create_proc_entry(str, 0, parent);
+		if (!entry)
+			return -ENOMEM;
 
-	entry->read_proc = cplbinfo_read_proc;
-	entry->data = NULL;
+		entry->read_proc = cplbinfo_read_proc;
+		entry->data = (void *)cpu;
+	}
 
 	return 0;
 }
 
 static void __exit cplbinfo_exit(void)
 {
+	unsigned int cpu;
+	unsigned char str[20];
+	for_each_online_cpu(cpu) {
+		sprintf(str, "cplbinfo/cpu%u", cpu);
+		remove_proc_entry(str, NULL);
+	}
 	remove_proc_entry("cplbinfo", NULL);
 }
 
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index 2debc90..8966c70 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -27,46 +27,20 @@
 #include <asm/cplb.h>
 #include <asm/cplbinit.h>
 
-#define CPLB_MEM CONFIG_MAX_MEM_SIZE
-
-/*
-* Number of required data CPLB switchtable entries
-* MEMSIZE / 4 (we mostly install 4M page size CPLBs
-* approx 16 for smaller 1MB page size CPLBs for allignment purposes
-* 1 for L1 Data Memory
-* possibly 1 for L2 Data Memory
-* 1 for CONFIG_DEBUG_HUNT_FOR_ZERO
-* 1 for ASYNC Memory
-*/
-#define MAX_SWITCH_D_CPLBS (((CPLB_MEM / 4) + 16 + 1 + 1 + 1 \
-				 + ASYNC_MEMORY_CPLB_COVERAGE) * 2)
-
-/*
-* Number of required instruction CPLB switchtable entries
-* MEMSIZE / 4 (we mostly install 4M page size CPLBs
-* approx 12 for smaller 1MB page size CPLBs for allignment purposes
-* 1 for L1 Instruction Memory
-* possibly 1 for L2 Instruction Memory
-* 1 for CONFIG_DEBUG_HUNT_FOR_ZERO
-*/
-#define MAX_SWITCH_I_CPLBS (((CPLB_MEM / 4) + 12 + 1 + 1 + 1) * 2)
-
-
-u_long icplb_table[MAX_CPLBS + 1];
-u_long dcplb_table[MAX_CPLBS + 1];
+u_long icplb_tables[NR_CPUS][CPLB_TBL_ENTRIES+1];
+u_long dcplb_tables[NR_CPUS][CPLB_TBL_ENTRIES+1];
 
 #ifdef CONFIG_CPLB_SWITCH_TAB_L1
-# define PDT_ATTR __attribute__((l1_data))
+#define PDT_ATTR __attribute__((l1_data))
 #else
-# define PDT_ATTR
+#define PDT_ATTR
 #endif
 
-u_long ipdt_table[MAX_SWITCH_I_CPLBS + 1] PDT_ATTR;
-u_long dpdt_table[MAX_SWITCH_D_CPLBS + 1] PDT_ATTR;
-
+u_long ipdt_tables[NR_CPUS][MAX_SWITCH_I_CPLBS+1] PDT_ATTR;
+u_long dpdt_tables[NR_CPUS][MAX_SWITCH_D_CPLBS+1] PDT_ATTR;
 #ifdef CONFIG_CPLB_INFO
-u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS] PDT_ATTR;
-u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS] PDT_ATTR;
+u_long ipdt_swapcount_tables[NR_CPUS][MAX_SWITCH_I_CPLBS] PDT_ATTR;
+u_long dpdt_swapcount_tables[NR_CPUS][MAX_SWITCH_D_CPLBS] PDT_ATTR;
 #endif
 
 struct s_cplb {
@@ -93,8 +67,8 @@ static struct cplb_desc cplb_data[] = {
 		.name = "Zero Pointer Guard Page",
 	},
 	{
-		.start = L1_CODE_START,
-		.end = L1_CODE_START + L1_CODE_LENGTH,
+		.start = 0,	/* dyanmic */
+		.end = 0,	/* dynamic */
 		.psize = SIZE_4M,
 		.attr = INITIAL_T | SWITCH_T | I_CPLB,
 		.i_conf = L1_IMEMORY,
@@ -103,8 +77,8 @@ static struct cplb_desc cplb_data[] = {
 		.name = "L1 I-Memory",
 	},
 	{
-		.start = L1_DATA_A_START,
-		.end = L1_DATA_B_START + L1_DATA_B_LENGTH,
+		.start = 0,	/* dynamic */
+		.end = 0,	/* dynamic */
 		.psize = SIZE_4M,
 		.attr = INITIAL_T | SWITCH_T | D_CPLB,
 		.i_conf = 0,
@@ -117,6 +91,16 @@ static struct cplb_desc cplb_data[] = {
 		.name = "L1 D-Memory",
 	},
 	{
+		.start = L2_START,
+		.end = L2_START + L2_LENGTH,
+		.psize = SIZE_1M,
+		.attr = L2_ATTR,
+		.i_conf = L2_IMEMORY,
+		.d_conf = L2_DMEMORY,
+		.valid = (L2_LENGTH > 0),
+		.name = "L2 Memory",
+	},
+	{
 		.start = 0,
 		.end = 0,  /* dynamic */
 		.psize = 0,
@@ -165,16 +149,6 @@ static struct cplb_desc cplb_data[] = {
 		.name = "Asynchronous Memory Banks",
 	},
 	{
-		.start = L2_START,
-		.end = L2_START + L2_LENGTH,
-		.psize = SIZE_1M,
-		.attr = SWITCH_T | I_CPLB | D_CPLB,
-		.i_conf = L2_IMEMORY,
-		.d_conf = L2_DMEMORY,
-		.valid = (L2_LENGTH > 0),
-		.name = "L2 Memory",
-	},
-	{
 		.start = BOOT_ROM_START,
 		.end = BOOT_ROM_START + BOOT_ROM_LENGTH,
 		.psize = SIZE_1M,
@@ -310,7 +284,7 @@ __fill_data_cplbtab(struct cplb_tab *t, int i, u32 a_start, u32 a_end)
 	}
 }
 
-void __init generate_cplb_tables(void)
+void __init generate_cplb_tables_cpu(unsigned int cpu)
 {
 
 	u16 i, j, process;
@@ -322,8 +296,8 @@ void __init generate_cplb_tables(void)
 
 	printk(KERN_INFO "NOMPU: setting up cplb tables for global access\n");
 
-	cplb.init_i.size = MAX_CPLBS;
-	cplb.init_d.size = MAX_CPLBS;
+	cplb.init_i.size = CPLB_TBL_ENTRIES;
+	cplb.init_d.size = CPLB_TBL_ENTRIES;
 	cplb.switch_i.size = MAX_SWITCH_I_CPLBS;
 	cplb.switch_d.size = MAX_SWITCH_D_CPLBS;
 
@@ -332,11 +306,15 @@ void __init generate_cplb_tables(void)
 	cplb.switch_i.pos = 0;
 	cplb.switch_d.pos = 0;
 
-	cplb.init_i.tab = icplb_table;
-	cplb.init_d.tab = dcplb_table;
-	cplb.switch_i.tab = ipdt_table;
-	cplb.switch_d.tab = dpdt_table;
+	cplb.init_i.tab = icplb_tables[cpu];
+	cplb.init_d.tab = dcplb_tables[cpu];
+	cplb.switch_i.tab = ipdt_tables[cpu];
+	cplb.switch_d.tab = dpdt_tables[cpu];
 
+	cplb_data[L1I_MEM].start = get_l1_code_start_cpu(cpu);
+	cplb_data[L1I_MEM].end = cplb_data[L1I_MEM].start + L1_CODE_LENGTH;
+	cplb_data[L1D_MEM].start = get_l1_data_a_start_cpu(cpu);
+	cplb_data[L1D_MEM].end = get_l1_data_b_start_cpu(cpu) + L1_DATA_B_LENGTH;
 	cplb_data[SDRAM_KERN].end = memory_end;
 
 #ifdef CONFIG_MTD_UCLINUX
@@ -459,6 +437,5 @@ void __init generate_cplb_tables(void)
 	cplb.switch_d.tab[cplb.switch_d.pos] = -1;
 
 }
-
 #endif
 
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbmgr.S b/arch/blackfin/kernel/cplb-nompu/cplbmgr.S
index f5cf3ac..985f3fc 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbmgr.S
+++ b/arch/blackfin/kernel/cplb-nompu/cplbmgr.S
@@ -52,6 +52,7 @@
 #include <linux/linkage.h>
 #include <asm/blackfin.h>
 #include <asm/cplb.h>
+#include <asm/asm-offsets.h>
 
 #ifdef CONFIG_EXCPT_IRQ_SYSC_L1
 .section .l1.text
@@ -164,10 +165,9 @@ ENTRY(_cplb_mgr)
 .Lifound_victim:
 #ifdef CONFIG_CPLB_INFO
 	R7 = [P0 - 0x104];
-	P2.L = _ipdt_table;
-	P2.H = _ipdt_table;
-	P3.L = _ipdt_swapcount_table;
-	P3.H = _ipdt_swapcount_table;
+	GET_PDA(P2, R2);
+	P3 = [P2 + PDA_IPDT_SWAPCOUNT];
+	P2 = [P2 + PDA_IPDT];
 	P3 += -4;
 .Licount:
 	R2 = [P2];	/* address from config table */
@@ -208,11 +208,10 @@ ENTRY(_cplb_mgr)
 	 * range.
  	 */
 
-	P2.L = _ipdt_table;
-	P2.H = _ipdt_table;
+	GET_PDA(P3, R0);
+	P2 = [P3 + PDA_IPDT];
 #ifdef	CONFIG_CPLB_INFO
-	P3.L = _ipdt_swapcount_table;
-	P3.H = _ipdt_swapcount_table;
+	P3 = [P3 + PDA_IPDT_SWAPCOUNT];
 	P3 += -8;
 #endif
 	P0.L = _page_size_table;
@@ -469,10 +468,9 @@ ENTRY(_cplb_mgr)
 
 #ifdef CONFIG_CPLB_INFO
 	R7 = [P0 - 0x104];
-	P2.L = _dpdt_table;
-	P2.H = _dpdt_table;
-	P3.L = _dpdt_swapcount_table;
-	P3.H = _dpdt_swapcount_table;
+	GET_PDA(P2, R2);
+	P3 = [P2 + PDA_DPDT_SWAPCOUNT];
+	P2 = [P2 + PDA_DPDT];
 	P3 += -4;
 .Ldicount:
 	R2 = [P2];
@@ -541,11 +539,10 @@ ENTRY(_cplb_mgr)
 
 	R0 = I0;		/* Our faulting address */
 
-	P2.L = _dpdt_table;
-	P2.H = _dpdt_table;
+	GET_PDA(P3, R1);
+	P2 = [P3 + PDA_DPDT];
 #ifdef	CONFIG_CPLB_INFO
-	P3.L = _dpdt_swapcount_table;
-	P3.H = _dpdt_swapcount_table;
+	P3 = [P3 + PDA_DPDT_SWAPCOUNT];
 	P3 += -8;
 #endif
 
-- 
1.5.6.3
