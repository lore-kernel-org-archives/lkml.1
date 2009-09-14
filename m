Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbZINUPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbZINUPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbZINUP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:15:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54130 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933610AbZINUIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 47/72] Blackfin: cleanup sync handling when enabling/disabling cplbs
Date: Mon, 14 Sep 2009 16:07:51 -0400
Message-Id: <1252958896-25150-48-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

The handling of updating the [DI]MEM_CONTROL MMRs does not follow proper
sync procedures as laid out in the Blackfin programming manual.  So rather
than audit/fix every call location, create helper functions that do the
right things in order to safely update these MMRs.  Then convert all call
sites to use these new helper functions.

While we're fixing the code, drop the workaround for anomaly 05000125 as
that anomaly applies to old versions of silicon that we do not support.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/cplb.h            |   46 +++++++++++++++++++-
 arch/blackfin/kernel/cplb-mpu/cacheinit.c   |    6 ++-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c     |   61 +++++---------------------
 arch/blackfin/kernel/cplb-nompu/cacheinit.c |    6 ++-
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c   |   33 ++------------
 arch/blackfin/mach-bf561/secondary.S        |   20 ++-------
 arch/blackfin/mach-common/entry.S           |   14 ++----
 arch/blackfin/mach-common/pm.c              |   64 +++-----------------------
 8 files changed, 84 insertions(+), 166 deletions(-)

diff --git a/arch/blackfin/include/asm/cplb.h b/arch/blackfin/include/asm/cplb.h
index c5dacf8..d18d168 100644
--- a/arch/blackfin/include/asm/cplb.h
+++ b/arch/blackfin/include/asm/cplb.h
@@ -125,4 +125,48 @@
 #define FAULT_USERSUPV  (1 << 17)
 #define FAULT_CPLBBITS  0x0000ffff
 
-#endif				/* _CPLB_H */
+#ifndef __ASSEMBLY__
+
+static inline void _disable_cplb(u32 mmr, u32 mask)
+{
+	u32 ctrl = bfin_read32(mmr) & ~mask;
+	/* CSYNC to ensure load store ordering */
+	__builtin_bfin_csync();
+	bfin_write32(mmr, ctrl);
+	__builtin_bfin_ssync();
+}
+static inline void disable_cplb(u32 mmr, u32 mask)
+{
+	u32 ctrl = bfin_read32(mmr) & ~mask;
+	CSYNC();
+	bfin_write32(mmr, ctrl);
+	SSYNC();
+}
+#define _disable_dcplb() _disable_cplb(DMEM_CONTROL, ENDCPLB)
+#define  disable_dcplb()  disable_cplb(DMEM_CONTROL, ENDCPLB)
+#define _disable_icplb() _disable_cplb(IMEM_CONTROL, ENICPLB)
+#define  disable_icplb()  disable_cplb(IMEM_CONTROL, ENICPLB)
+
+static inline void _enable_cplb(u32 mmr, u32 mask)
+{
+	u32 ctrl = bfin_read32(mmr) | mask;
+	/* CSYNC to ensure load store ordering */
+	__builtin_bfin_csync();
+	bfin_write32(mmr, ctrl);
+	__builtin_bfin_ssync();
+}
+static inline void enable_cplb(u32 mmr, u32 mask)
+{
+	u32 ctrl = bfin_read32(mmr) | mask;
+	CSYNC();
+	bfin_write32(mmr, ctrl);
+	SSYNC();
+}
+#define _enable_dcplb()  _enable_cplb(DMEM_CONTROL, ENDCPLB)
+#define  enable_dcplb()   enable_cplb(DMEM_CONTROL, ENDCPLB)
+#define _enable_icplb()  _enable_cplb(IMEM_CONTROL, ENICPLB)
+#define  enable_icplb()   enable_cplb(IMEM_CONTROL, ENICPLB)
+
+#endif		/* __ASSEMBLY__ */
+
+#endif		/* _CPLB_H */
diff --git a/arch/blackfin/kernel/cplb-mpu/cacheinit.c b/arch/blackfin/kernel/cplb-mpu/cacheinit.c
index d5a86c3..a082681 100644
--- a/arch/blackfin/kernel/cplb-mpu/cacheinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cacheinit.c
@@ -30,13 +30,14 @@ void __cpuinit bfin_icache_init(struct cplb_entry *icplb_tbl)
 	unsigned long ctrl;
 	int i;
 
-	SSYNC();
 	for (i = 0; i < MAX_CPLBS; i++) {
 		bfin_write32(ICPLB_ADDR0 + i * 4, icplb_tbl[i].addr);
 		bfin_write32(ICPLB_DATA0 + i * 4, icplb_tbl[i].data);
 	}
 	ctrl = bfin_read_IMEM_CONTROL();
 	ctrl |= IMC | ENICPLB;
+	/* CSYNC to ensure load store ordering */
+	CSYNC();
 	bfin_write_IMEM_CONTROL(ctrl);
 	SSYNC();
 }
@@ -48,7 +49,6 @@ void __cpuinit bfin_dcache_init(struct cplb_entry *dcplb_tbl)
 	unsigned long ctrl;
 	int i;
 
-	SSYNC();
 	for (i = 0; i < MAX_CPLBS; i++) {
 		bfin_write32(DCPLB_ADDR0 + i * 4, dcplb_tbl[i].addr);
 		bfin_write32(DCPLB_DATA0 + i * 4, dcplb_tbl[i].data);
@@ -63,6 +63,8 @@ void __cpuinit bfin_dcache_init(struct cplb_entry *dcplb_tbl)
 	 *  to port B
 	 */
 	ctrl |= DMEM_CNTR | PORT_PREF0 | (ANOMALY_05000287 ? PORT_PREF1 : 0);
+	/* CSYNC to ensure load store ordering */
+	CSYNC();
 	bfin_write_DMEM_CONTROL(ctrl);
 	SSYNC();
 }
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
index bcdfe9b..651b127 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
@@ -22,6 +22,7 @@
 
 #include <asm/blackfin.h>
 #include <asm/cacheflush.h>
+#include <asm/cplb.h>
 #include <asm/cplbinit.h>
 #include <asm/mmu_context.h>
 
@@ -41,46 +42,6 @@ int nr_dcplb_miss[NR_CPUS], nr_icplb_miss[NR_CPUS];
 int nr_icplb_supv_miss[NR_CPUS], nr_dcplb_prot[NR_CPUS];
 int nr_cplb_flush[NR_CPUS];
 
-static inline void disable_dcplb(void)
-{
-	unsigned long ctrl;
-	SSYNC();
-	ctrl = bfin_read_DMEM_CONTROL();
-	ctrl &= ~ENDCPLB;
-	bfin_write_DMEM_CONTROL(ctrl);
-	SSYNC();
-}
-
-static inline void enable_dcplb(void)
-{
-	unsigned long ctrl;
-	SSYNC();
-	ctrl = bfin_read_DMEM_CONTROL();
-	ctrl |= ENDCPLB;
-	bfin_write_DMEM_CONTROL(ctrl);
-	SSYNC();
-}
-
-static inline void disable_icplb(void)
-{
-	unsigned long ctrl;
-	SSYNC();
-	ctrl = bfin_read_IMEM_CONTROL();
-	ctrl &= ~ENICPLB;
-	bfin_write_IMEM_CONTROL(ctrl);
-	SSYNC();
-}
-
-static inline void enable_icplb(void)
-{
-	unsigned long ctrl;
-	SSYNC();
-	ctrl = bfin_read_IMEM_CONTROL();
-	ctrl |= ENICPLB;
-	bfin_write_IMEM_CONTROL(ctrl);
-	SSYNC();
-}
-
 /*
  * Given the contents of the status register, return the index of the
  * CPLB that caused the fault.
@@ -198,10 +159,10 @@ static noinline int dcplb_miss(unsigned int cpu)
 	dcplb_tbl[cpu][idx].addr = addr;
 	dcplb_tbl[cpu][idx].data = d_data;
 
-	disable_dcplb();
+	_disable_dcplb();
 	bfin_write32(DCPLB_DATA0 + idx * 4, d_data);
 	bfin_write32(DCPLB_ADDR0 + idx * 4, addr);
-	enable_dcplb();
+	_enable_dcplb();
 
 	return 0;
 }
@@ -288,10 +249,10 @@ static noinline int icplb_miss(unsigned int cpu)
 	icplb_tbl[cpu][idx].addr = addr;
 	icplb_tbl[cpu][idx].data = i_data;
 
-	disable_icplb();
+	_disable_icplb();
 	bfin_write32(ICPLB_DATA0 + idx * 4, i_data);
 	bfin_write32(ICPLB_ADDR0 + idx * 4, addr);
-	enable_icplb();
+	_enable_icplb();
 
 	return 0;
 }
@@ -340,19 +301,19 @@ void flush_switched_cplbs(unsigned int cpu)
 	nr_cplb_flush[cpu]++;
 
 	local_irq_save_hw(flags);
-	disable_icplb();
+	_disable_icplb();
 	for (i = first_switched_icplb; i < MAX_CPLBS; i++) {
 		icplb_tbl[cpu][i].data = 0;
 		bfin_write32(ICPLB_DATA0 + i * 4, 0);
 	}
-	enable_icplb();
+	_enable_icplb();
 
-	disable_dcplb();
+	_disable_dcplb();
 	for (i = first_switched_dcplb; i < MAX_CPLBS; i++) {
 		dcplb_tbl[cpu][i].data = 0;
 		bfin_write32(DCPLB_DATA0 + i * 4, 0);
 	}
-	enable_dcplb();
+	_enable_dcplb();
 	local_irq_restore_hw(flags);
 
 }
@@ -385,7 +346,7 @@ void set_mask_dcplbs(unsigned long *masks, unsigned int cpu)
 #endif
 	}
 
-	disable_dcplb();
+	_disable_dcplb();
 	for (i = first_mask_dcplb; i < first_switched_dcplb; i++) {
 		dcplb_tbl[cpu][i].addr = addr;
 		dcplb_tbl[cpu][i].data = d_data;
@@ -393,6 +354,6 @@ void set_mask_dcplbs(unsigned long *masks, unsigned int cpu)
 		bfin_write32(DCPLB_ADDR0 + i * 4, addr);
 		addr += PAGE_SIZE;
 	}
-	enable_dcplb();
+	_enable_dcplb();
 	local_irq_restore_hw(flags);
 }
diff --git a/arch/blackfin/kernel/cplb-nompu/cacheinit.c b/arch/blackfin/kernel/cplb-nompu/cacheinit.c
index d5a86c3..a082681 100644
--- a/arch/blackfin/kernel/cplb-nompu/cacheinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cacheinit.c
@@ -30,13 +30,14 @@ void __cpuinit bfin_icache_init(struct cplb_entry *icplb_tbl)
 	unsigned long ctrl;
 	int i;
 
-	SSYNC();
 	for (i = 0; i < MAX_CPLBS; i++) {
 		bfin_write32(ICPLB_ADDR0 + i * 4, icplb_tbl[i].addr);
 		bfin_write32(ICPLB_DATA0 + i * 4, icplb_tbl[i].data);
 	}
 	ctrl = bfin_read_IMEM_CONTROL();
 	ctrl |= IMC | ENICPLB;
+	/* CSYNC to ensure load store ordering */
+	CSYNC();
 	bfin_write_IMEM_CONTROL(ctrl);
 	SSYNC();
 }
@@ -48,7 +49,6 @@ void __cpuinit bfin_dcache_init(struct cplb_entry *dcplb_tbl)
 	unsigned long ctrl;
 	int i;
 
-	SSYNC();
 	for (i = 0; i < MAX_CPLBS; i++) {
 		bfin_write32(DCPLB_ADDR0 + i * 4, dcplb_tbl[i].addr);
 		bfin_write32(DCPLB_DATA0 + i * 4, dcplb_tbl[i].data);
@@ -63,6 +63,8 @@ void __cpuinit bfin_dcache_init(struct cplb_entry *dcplb_tbl)
 	 *  to port B
 	 */
 	ctrl |= DMEM_CNTR | PORT_PREF0 | (ANOMALY_05000287 ? PORT_PREF1 : 0);
+	/* CSYNC to ensure load store ordering */
+	CSYNC();
 	bfin_write_DMEM_CONTROL(ctrl);
 	SSYNC();
 }
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbmgr.c b/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
index 12b0308..aabbb42 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbmgr.c
@@ -48,36 +48,13 @@ int nr_cplb_flush[NR_CPUS], nr_dcplb_prot[NR_CPUS];
 #define MGR_ATTR
 #endif
 
-/*
- * We're in an exception handler.  The normal cli nop nop workaround
- * isn't going to do very much, as the only thing that can interrupt
- * us is an NMI, and the cli isn't going to stop that.
- */
-#define NOWA_SSYNC __asm__ __volatile__ ("ssync;")
-
-/* Anomaly handlers provide SSYNCs, so avoid extra if anomaly is present */
-#if ANOMALY_05000125
-
-#define bfin_write_DMEM_CONTROL_SSYNC(v)    bfin_write_DMEM_CONTROL(v)
-#define bfin_write_IMEM_CONTROL_SSYNC(v)    bfin_write_IMEM_CONTROL(v)
-
-#else
-
-#define bfin_write_DMEM_CONTROL_SSYNC(v) \
-    do { NOWA_SSYNC; bfin_write_DMEM_CONTROL(v); NOWA_SSYNC; } while (0)
-#define bfin_write_IMEM_CONTROL_SSYNC(v) \
-    do { NOWA_SSYNC; bfin_write_IMEM_CONTROL(v); NOWA_SSYNC; } while (0)
-
-#endif
-
 static inline void write_dcplb_data(int cpu, int idx, unsigned long data,
 				    unsigned long addr)
 {
-	unsigned long ctrl = bfin_read_DMEM_CONTROL();
-	bfin_write_DMEM_CONTROL_SSYNC(ctrl & ~ENDCPLB);
+	_disable_dcplb();
 	bfin_write32(DCPLB_DATA0 + idx * 4, data);
 	bfin_write32(DCPLB_ADDR0 + idx * 4, addr);
-	bfin_write_DMEM_CONTROL_SSYNC(ctrl);
+	_enable_dcplb();
 
 #ifdef CONFIG_CPLB_INFO
 	dcplb_tbl[cpu][idx].addr = addr;
@@ -88,12 +65,10 @@ static inline void write_dcplb_data(int cpu, int idx, unsigned long data,
 static inline void write_icplb_data(int cpu, int idx, unsigned long data,
 				    unsigned long addr)
 {
-	unsigned long ctrl = bfin_read_IMEM_CONTROL();
-
-	bfin_write_IMEM_CONTROL_SSYNC(ctrl & ~ENICPLB);
+	_disable_icplb();
 	bfin_write32(ICPLB_DATA0 + idx * 4, data);
 	bfin_write32(ICPLB_ADDR0 + idx * 4, addr);
-	bfin_write_IMEM_CONTROL_SSYNC(ctrl);
+	_enable_icplb();
 
 #ifdef CONFIG_CPLB_INFO
 	icplb_tbl[cpu][idx].addr = addr;
diff --git a/arch/blackfin/mach-bf561/secondary.S b/arch/blackfin/mach-bf561/secondary.S
index 097550f..f72a6af 100644
--- a/arch/blackfin/mach-bf561/secondary.S
+++ b/arch/blackfin/mach-bf561/secondary.S
@@ -85,16 +85,10 @@ ENTRY(_coreb_trampoline_start)
 	R0 = ~ENICPLB;
 	R0 = R0 & R1;
 
-	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
+	/* Disabling of CPLBs should be proceeded by a CSYNC */
+	CSYNC;
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
-	STI R2;
-#endif
 
 	/* Turn off the dcache */
 	p0.l = LO(DMEM_CONTROL);
@@ -103,16 +97,10 @@ ENTRY(_coreb_trampoline_start)
 	R0 = ~ENDCPLB;
 	R0 = R0 & R1;
 
-	/* Anomaly 05000125 */
-#ifdef ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
+	/* Disabling of CPLBs should be proceeded by a CSYNC */
+	CSYNC;
 	[p0] = R0;
 	SSYNC;
-#ifdef ANOMALY_05000125
-	STI R2;
-#endif
 
 	/* in case of double faults, save a few things */
 	p0.l = _init_retx_coreb;
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 4e8e3fe..e7eb163 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -397,8 +397,7 @@ ENTRY(_double_fault)
 
 	R5 = [P4];              /* Control Register*/
 	BITCLR(R5,ENICPLB_P);
-	SSYNC;          /* SSYNC required before writing to IMEM_CONTROL. */
-	.align 8;
+	CSYNC;          /* Disabling of CPLBs should be proceeded by a CSYNC */
 	[P4] = R5;
 	SSYNC;
 
@@ -406,8 +405,7 @@ ENTRY(_double_fault)
 	P4.H = HI(DMEM_CONTROL);
 	R5 = [P4];
 	BITCLR(R5,ENDCPLB_P);
-	SSYNC;          /* SSYNC required before writing to DMEM_CONTROL. */
-	.align 8;
+	CSYNC;          /* Disabling of CPLBs should be proceeded by a CSYNC */
 	[P4] = R5;
 	SSYNC;
 
@@ -1146,9 +1144,7 @@ ENTRY(_early_trap)
 
 	R5 = [P4];              /* Control Register*/
 	BITCLR(R5,ENICPLB_P);
-	CLI R1;
-	SSYNC;          /* SSYNC required before writing to IMEM_CONTROL. */
-	.align 8;
+	CSYNC;          /* Disabling of CPLBs should be proceeded by a CSYNC */
 	[P4] = R5;
 	SSYNC;
 
@@ -1156,11 +1152,9 @@ ENTRY(_early_trap)
 	P4.H = HI(DMEM_CONTROL);
 	R5 = [P4];
 	BITCLR(R5,ENDCPLB_P);
-	SSYNC;          /* SSYNC required before writing to DMEM_CONTROL. */
-	.align 8;
+	CSYNC;          /* Disabling of CPLBs should be proceeded by a CSYNC */
 	[P4] = R5;
 	SSYNC;
-	STI R1;
 
 	r0 = sp;        /* stack frame pt_regs pointer argument ==> r0 */
 	r1 = RETX;
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 9e7e27b..0e3d4ff 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -38,6 +38,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 
+#include <asm/cplb.h>
 #include <asm/gpio.h>
 #include <asm/dma.h>
 #include <asm/dpmc.h>
@@ -170,58 +171,6 @@ static void flushinv_all_dcache(void)
 }
 #endif
 
-static inline void dcache_disable(void)
-{
-#ifdef CONFIG_BFIN_DCACHE
-	unsigned long ctrl;
-
-#if defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK)
-	flushinv_all_dcache();
-#endif
-	SSYNC();
-	ctrl = bfin_read_DMEM_CONTROL();
-	ctrl &= ~ENDCPLB;
-	bfin_write_DMEM_CONTROL(ctrl);
-	SSYNC();
-#endif
-}
-
-static inline void dcache_enable(void)
-{
-#ifdef CONFIG_BFIN_DCACHE
-	unsigned long ctrl;
-	SSYNC();
-	ctrl = bfin_read_DMEM_CONTROL();
-	ctrl |= ENDCPLB;
-	bfin_write_DMEM_CONTROL(ctrl);
-	SSYNC();
-#endif
-}
-
-static inline void icache_disable(void)
-{
-#ifdef CONFIG_BFIN_ICACHE
-	unsigned long ctrl;
-	SSYNC();
-	ctrl = bfin_read_IMEM_CONTROL();
-	ctrl &= ~ENICPLB;
-	bfin_write_IMEM_CONTROL(ctrl);
-	SSYNC();
-#endif
-}
-
-static inline void icache_enable(void)
-{
-#ifdef CONFIG_BFIN_ICACHE
-	unsigned long ctrl;
-	SSYNC();
-	ctrl = bfin_read_IMEM_CONTROL();
-	ctrl |= ENICPLB;
-	bfin_write_IMEM_CONTROL(ctrl);
-	SSYNC();
-#endif
-}
-
 int bfin_pm_suspend_mem_enter(void)
 {
 	unsigned long flags;
@@ -258,16 +207,19 @@ int bfin_pm_suspend_mem_enter(void)
 
 	bfin_gpio_pm_hibernate_suspend();
 
-	dcache_disable();
-	icache_disable();
+#if defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK)
+	flushinv_all_dcache();
+#endif
+	_disable_dcplb();
+	_disable_icplb();
 	bf53x_suspend_l1_mem(memptr);
 
 	do_hibernate(wakeup | vr_wakeup);	/* Goodbye */
 
 	bf53x_resume_l1_mem(memptr);
 
-	icache_enable();
-	dcache_enable();
+	_enable_icplb();
+	_enable_dcplb();
 
 	bfin_gpio_pm_hibernate_restore();
 	blackfin_dma_resume();
-- 
1.6.4.2

