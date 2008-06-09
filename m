Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbYFIW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbYFIW0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760597AbYFIWX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:23:58 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53932 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760572AbYFIWX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:23:56 -0400
Date: Tue, 10 Jun 2008 01:23:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] m68k/sun3/: possible cleanups
Message-ID: <20080609222301.GK1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the following needlessly global code static:
  - config.c: sun3_bootmem_alloc()
  - config.c: sun3_sched_init()
  - dvma.c: dvma_page()
  - idprom.c: struct Sun_Machines[]
  - mmu_emu.c: struct ctx_alloc[]
  - sun3dvma.c: iommu_use[]
  - sun3ints.c: led_pattern[]
- remove the unused sbus.c

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/sun3/Makefile     |    2 +-
 arch/m68k/sun3/config.c     |    7 ++++---
 arch/m68k/sun3/dvma.c       |    2 +-
 arch/m68k/sun3/idprom.c     |    2 +-
 arch/m68k/sun3/mmu_emu.c    |    2 +-
 arch/m68k/sun3/sbus.c       |   27 ---------------------------
 arch/m68k/sun3/sun3dvma.c   |    2 +-
 arch/m68k/sun3/sun3ints.c   |    2 +-
 include/asm-m68k/dvma.h     |    2 --
 include/asm-m68k/machines.h |    2 --
 include/asm-m68k/sbus.h     |    3 ---
 11 files changed, 10 insertions(+), 43 deletions(-)

5aebb977c3054ad73b3e2ef99c1cfa4cb3324ec7 diff --git a/arch/m68k/sun3/Makefile b/arch/m68k/sun3/Makefile
index be1a847..38ba0e0 100644
--- a/arch/m68k/sun3/Makefile
+++ b/arch/m68k/sun3/Makefile
@@ -2,6 +2,6 @@
 # Makefile for Linux arch/m68k/sun3 source directory
 #
 
-obj-y	:= sun3ints.o sun3dvma.o sbus.o idprom.o
+obj-y	:= sun3ints.o sun3dvma.o idprom.o
 
 obj-$(CONFIG_SUN3) += config.o mmu_emu.o leds.o dvma.o intersil.o
diff --git a/arch/m68k/sun3/config.c b/arch/m68k/sun3/config.c
index c0fbd27..732087d 100644
--- a/arch/m68k/sun3/config.c
+++ b/arch/m68k/sun3/config.c
@@ -36,7 +36,7 @@ extern char _text, _end;
 char sun3_reserved_pmeg[SUN3_PMEGS_NUM];
 
 extern unsigned long sun3_gettimeoffset(void);
-extern void sun3_sched_init(irq_handler_t handler);
+static void sun3_sched_init(irq_handler_t handler);
 extern void sun3_get_model (char* model);
 extern void idprom_init (void);
 extern int sun3_hwclk(int set, struct rtc_time *t);
@@ -114,7 +114,8 @@ static void sun3_halt (void)
 
 /* sun3 bootmem allocation */
 
-void __init sun3_bootmem_alloc(unsigned long memory_start, unsigned long memory_end)
+static void __init sun3_bootmem_alloc(unsigned long memory_start,
+				      unsigned long memory_end)
 {
 	unsigned long start_page;
 
@@ -164,7 +165,7 @@ void __init config_sun3(void)
 	sun3_bootmem_alloc(memory_start, memory_end);
 }
 
-void __init sun3_sched_init(irq_handler_t timer_routine)
+static void __init sun3_sched_init(irq_handler_t timer_routine)
 {
 	sun3_disable_interrupts();
         intersil_clock->cmd_reg=(INTERSIL_RUN|INTERSIL_INT_DISABLE|INTERSIL_24H_MODE);
diff --git a/arch/m68k/sun3/dvma.c b/arch/m68k/sun3/dvma.c
index d2b3093..d522eaa 100644
--- a/arch/m68k/sun3/dvma.c
+++ b/arch/m68k/sun3/dvma.c
@@ -19,7 +19,7 @@
 
 static unsigned long ptelist[120];
 
-inline unsigned long dvma_page(unsigned long kaddr, unsigned long vaddr)
+static unsigned long dvma_page(unsigned long kaddr, unsigned long vaddr)
 {
 	unsigned long pte;
 	unsigned long j;
diff --git a/arch/m68k/sun3/idprom.c b/arch/m68k/sun3/idprom.c
index dca6ab6..9a7991f 100644
--- a/arch/m68k/sun3/idprom.c
+++ b/arch/m68k/sun3/idprom.c
@@ -25,7 +25,7 @@ static struct idprom idprom_buffer;
  * of the Sparc CPU and have a meaningful IDPROM machtype value that we
  * know about.  See asm-sparc/machines.h for empirical constants.
  */
-struct Sun_Machine_Models Sun_Machines[NUM_SUN_MACHINES] = {
+static struct Sun_Machine_Models Sun_Machines[NUM_SUN_MACHINES] = {
 /* First, Sun3's */
     { .name = "Sun 3/160 Series",	.id_machtype = (SM_SUN3 | SM_3_160) },
     { .name = "Sun 3/50",		.id_machtype = (SM_SUN3 | SM_3_50) },
diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
index fb0f6a2..60f9d45 100644
--- a/arch/m68k/sun3/mmu_emu.c
+++ b/arch/m68k/sun3/mmu_emu.c
@@ -55,7 +55,7 @@ unsigned char pmeg_ctx[PMEGS_NUM];
 
 /* pointers to the mm structs for each task in each
    context. 0xffffffff is a marker for kernel context */
-struct mm_struct *ctx_alloc[CONTEXTS_NUM] = {
+static struct mm_struct *ctx_alloc[CONTEXTS_NUM] = {
     [0] = (struct mm_struct *)0xffffffff
 };
 
diff --git a/arch/m68k/sun3/sbus.c b/arch/m68k/sun3/sbus.c
deleted file mode 100644
index babdbfa..0000000
--- a/arch/m68k/sun3/sbus.c
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * SBus helper functions
- *
- * Sun3 don't have a sbus, but many of the used devices are also
- * used on Sparc machines with sbus. To avoid having a lot of
- * duplicate code, we provide necessary glue stuff to make using
- * of the sbus driver code possible.
- *
- * (C) 1999 Thomas Bogendoerfer (tsbogend@alpha.franken.de)
- */
-
-#include <linux/types.h>
-#include <linux/compiler.h>
-#include <linux/init.h>
-
-int __init sbus_init(void)
-{
-	return 0;
-}
-
-void *sparc_alloc_io (u32 address, void *virtual, int len, char *name,
-                      u32 bus_type, int rdonly)
-{
-	return (void *)address;
-}
-
-subsys_initcall(sbus_init);
diff --git a/arch/m68k/sun3/sun3dvma.c b/arch/m68k/sun3/sun3dvma.c
index 8709677..f9277e8 100644
--- a/arch/m68k/sun3/sun3dvma.c
+++ b/arch/m68k/sun3/sun3dvma.c
@@ -29,7 +29,7 @@ static inline void dvma_unmap_iommu(unsigned long a, int b)
 extern void sun3_dvma_init(void);
 #endif
 
-unsigned long iommu_use[IOMMU_TOTAL_ENTRIES];
+static unsigned long iommu_use[IOMMU_TOTAL_ENTRIES];
 
 #define dvma_index(baddr) ((baddr - DVMA_START) >> DVMA_PAGE_SHIFT)
 
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index cf93481..7364cd6 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -30,7 +30,7 @@ void sun3_enable_interrupts(void)
 	sun3_enable_irq(0);
 }
 
-int led_pattern[8] = {
+static int led_pattern[8] = {
        ~(0x80), ~(0x01),
        ~(0x40), ~(0x02),
        ~(0x20), ~(0x04),
diff --git a/include/asm-m68k/dvma.h b/include/asm-m68k/dvma.h
index e1112de..853ae15 100644
--- a/include/asm-m68k/dvma.h
+++ b/include/asm-m68k/dvma.h
@@ -63,8 +63,6 @@ static inline int dvma_map_cpu(unsigned long kaddr, unsigned long vaddr,
 	return 0;
 }
 
-extern unsigned long dvma_page(unsigned long kaddr, unsigned long vaddr);
-
 #else /* Sun3x */
 
 /* sun3x dvma page support */
diff --git a/include/asm-m68k/machines.h b/include/asm-m68k/machines.h
index da6015a..b35465d 100644
--- a/include/asm-m68k/machines.h
+++ b/include/asm-m68k/machines.h
@@ -21,8 +21,6 @@ struct Sun_Machine_Models {
 //#define NUM_SUN_MACHINES   23
 #define NUM_SUN_MACHINES  8
 
-extern struct Sun_Machine_Models Sun_Machines[NUM_SUN_MACHINES];
-
 /* The machine type in the idprom area looks like this:
  *
  * ---------------
diff --git a/include/asm-m68k/sbus.h b/include/asm-m68k/sbus.h
index 3b25c00..c8e685a 100644
--- a/include/asm-m68k/sbus.h
+++ b/include/asm-m68k/sbus.h
@@ -12,9 +12,6 @@ struct sbus_dev {
 	} reg_addrs[1];
 };
 
-extern void *sparc_alloc_io (u32, void *, int, char *, u32, int);
-#define sparc_alloc_io(a,b,c,d,e,f)	(a)
-
 #define ARCH_SUN4  0
 
 /* sbus IO functions stolen from include/asm-sparc/io.h for the serial driver */

