Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbXGUW3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbXGUW3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXGUW24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:28:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53266 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbXGUW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:28:54 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 1/3] clean include/asm-sparc/irq.h
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Message-Id: <E1ICNRU-0000lJ-Eo@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 21 Jul 2007 23:28:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Move stuff used only by arch/sparc/kernel/* into arch/sparc/kernel/irq.h
and into individual files in there (e.g. macros internal to sun4m_irq.c,
etc.)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/irq.c       |    2 +
 arch/sparc/kernel/irq.h       |   48 ++++++++++++++
 arch/sparc/kernel/pcic.c      |    1 +
 arch/sparc/kernel/smp.c       |    2 +
 arch/sparc/kernel/sun4c_irq.c |   15 +++++
 arch/sparc/kernel/sun4d_irq.c |    2 +
 arch/sparc/kernel/sun4d_smp.c |    1 +
 arch/sparc/kernel/sun4m_irq.c |   74 ++++++++++++++++++++++
 arch/sparc/kernel/sun4m_smp.c |    2 +
 arch/sparc/kernel/tick14.c    |    2 +
 arch/sparc/kernel/time.c      |    2 +
 include/asm-sparc/irq.h       |  136 -----------------------------------------
 12 files changed, 151 insertions(+), 136 deletions(-)
 create mode 100644 arch/sparc/kernel/irq.h

diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index f257a67..5e9af30 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -47,6 +47,8 @@
 #include <asm/cacheflush.h>
 #include <asm/irq_regs.h>
 
+#include "irq.h"
+
 #ifdef CONFIG_SMP
 #define SMP_NOP2 "nop; nop;\n\t"
 #define SMP_NOP3 "nop; nop; nop;\n\t"
diff --git a/arch/sparc/kernel/irq.h b/arch/sparc/kernel/irq.h
new file mode 100644
index 0000000..8254a86
--- /dev/null
+++ b/arch/sparc/kernel/irq.h
@@ -0,0 +1,48 @@
+#include <asm/btfixup.h>
+
+BTFIXUPDEF_CALL(void, disable_pil_irq, unsigned int)
+BTFIXUPDEF_CALL(void, enable_pil_irq, unsigned int)
+BTFIXUPDEF_CALL(void, clear_clock_irq, void)
+BTFIXUPDEF_CALL(void, clear_profile_irq, int)
+BTFIXUPDEF_CALL(void, load_profile_irq, int, unsigned int)
+
+static inline void disable_pil_irq(unsigned int irq)
+{
+	BTFIXUP_CALL(disable_pil_irq)(irq);
+}
+
+static inline void enable_pil_irq(unsigned int irq)
+{
+	BTFIXUP_CALL(enable_pil_irq)(irq);
+}
+
+static inline void clear_clock_irq(void)
+{
+	BTFIXUP_CALL(clear_clock_irq)();
+}
+
+static inline void clear_profile_irq(int irq)
+{
+	BTFIXUP_CALL(clear_profile_irq)(irq);
+}
+
+static inline void load_profile_irq(int cpu, int limit)
+{
+	BTFIXUP_CALL(load_profile_irq)(cpu, limit);
+}
+
+extern void (*sparc_init_timers)(irq_handler_t lvl10_irq);
+
+extern void claim_ticker14(irq_handler_t irq_handler,
+			   int irq,
+			   unsigned int timeout);
+
+#ifdef CONFIG_SMP
+BTFIXUPDEF_CALL(void, set_cpu_int, int, int)
+BTFIXUPDEF_CALL(void, clear_cpu_int, int, int)
+BTFIXUPDEF_CALL(void, set_irq_udt, int)
+
+#define set_cpu_int(cpu,level) BTFIXUP_CALL(set_cpu_int)(cpu,level)
+#define clear_cpu_int(cpu,level) BTFIXUP_CALL(clear_cpu_int)(cpu,level)
+#define set_irq_udt(cpu) BTFIXUP_CALL(set_irq_udt)(cpu)
+#endif
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 7917711..f2eae45 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -36,6 +36,7 @@
 #include <asm/uaccess.h>
 #include <asm/irq_regs.h>
 
+#include "irq.h"
 
 /*
  * I studied different documents and many live PROMs both from 2.30
diff --git a/arch/sparc/kernel/smp.c b/arch/sparc/kernel/smp.c
index 4fea3ac..6724ab9 100644
--- a/arch/sparc/kernel/smp.c
+++ b/arch/sparc/kernel/smp.c
@@ -33,6 +33,8 @@
 #include <asm/tlbflush.h>
 #include <asm/cpudata.h>
 
+#include "irq.h"
+
 int smp_num_cpus = 1;
 volatile unsigned long cpu_callin_map[NR_CPUS] __initdata = {0,};
 unsigned char boot_cpu_id = 0;
diff --git a/arch/sparc/kernel/sun4c_irq.c b/arch/sparc/kernel/sun4c_irq.c
index 009e891..5734a02 100644
--- a/arch/sparc/kernel/sun4c_irq.c
+++ b/arch/sparc/kernel/sun4c_irq.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include "irq.h"
 
 #include <asm/ptrace.h>
 #include <asm/processor.h>
@@ -40,6 +41,20 @@ static struct resource sun4c_timer_eb = { "sun4c_timer" };
 static struct resource sun4c_intr_eb = { "sun4c_intr" };
 #endif
 
+/* 
+ * Bit field defines for the interrupt registers on various
+ * Sparc machines.
+ */
+
+/* The sun4c interrupt register. */
+#define SUN4C_INT_ENABLE  0x01     /* Allow interrupts. */
+#define SUN4C_INT_E14     0x80     /* Enable level 14 IRQ. */
+#define SUN4C_INT_E10     0x20     /* Enable level 10 IRQ. */
+#define SUN4C_INT_E8      0x10     /* Enable level 8 IRQ. */
+#define SUN4C_INT_E6      0x08     /* Enable level 6 IRQ. */
+#define SUN4C_INT_E4      0x04     /* Enable level 4 IRQ. */
+#define SUN4C_INT_E1      0x02     /* Enable level 1 IRQ. */
+
 /* Pointer to the interrupt enable byte
  *
  * Dave Redman (djhr@tadpole.co.uk)
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index 396797e..7a09186 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -39,6 +39,8 @@
 #include <asm/cacheflush.h>
 #include <asm/irq_regs.h>
 
+#include "irq.h"
+
 /* If you trust current SCSI layer to handle different SCSI IRQs, enable this. I don't trust it... -jj */
 /* #define DISTRIBUTE_IRQS */
 
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 098c94f..89a6de9 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -36,6 +36,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpudata.h>
 
+#include "irq.h"
 #define IRQ_CROSS_CALL		15
 
 extern ctxd_t *srmmu_ctx_table_phys;
diff --git a/arch/sparc/kernel/sun4m_irq.c b/arch/sparc/kernel/sun4m_irq.c
index 91a803e..b92d6d2 100644
--- a/arch/sparc/kernel/sun4m_irq.c
+++ b/arch/sparc/kernel/sun4m_irq.c
@@ -38,11 +38,85 @@
 #include <asm/sbus.h>
 #include <asm/cacheflush.h>
 
+#include "irq.h"
+
+/* On the sun4m, just like the timers, we have both per-cpu and master
+ * interrupt registers.
+ */
+
+/* These registers are used for sending/receiving irqs from/to
+ * different cpu's.
+ */
+struct sun4m_intreg_percpu {
+	unsigned int tbt;        /* Interrupts still pending for this cpu. */
+
+	/* These next two registers are WRITE-ONLY and are only
+	 * "on bit" sensitive, "off bits" written have NO affect.
+	 */
+	unsigned int clear;  /* Clear this cpus irqs here. */
+	unsigned int set;    /* Set this cpus irqs here. */
+	unsigned char space[PAGE_SIZE - 12];
+};
+
+/*
+ * djhr
+ * Actually the clear and set fields in this struct are misleading..
+ * according to the SLAVIO manual (and the same applies for the SEC)
+ * the clear field clears bits in the mask which will ENABLE that IRQ
+ * the set field sets bits in the mask to DISABLE the IRQ.
+ *
+ * Also the undirected_xx address in the SLAVIO is defined as
+ * RESERVED and write only..
+ *
+ * DAVEM_NOTE: The SLAVIO only specifies behavior on uniprocessor
+ *             sun4m machines, for MP the layout makes more sense.
+ */
+struct sun4m_intregs {
+	struct sun4m_intreg_percpu cpu_intregs[SUN4M_NCPUS];
+	unsigned int tbt;                /* IRQ's that are still pending. */
+	unsigned int irqs;               /* Master IRQ bits. */
+
+	/* Again, like the above, two these registers are WRITE-ONLY. */
+	unsigned int clear;              /* Clear master IRQ's by setting bits here. */
+	unsigned int set;                /* Set master IRQ's by setting bits here. */
+
+	/* This register is both READ and WRITE. */
+	unsigned int undirected_target;  /* Which cpu gets undirected irqs. */
+};
+
 static unsigned long dummy;
 
 struct sun4m_intregs *sun4m_interrupts;
 unsigned long *irq_rcvreg = &dummy;
 
+/* Dave Redman (djhr@tadpole.co.uk)
+ * The sun4m interrupt registers.
+ */
+#define SUN4M_INT_ENABLE  	0x80000000
+#define SUN4M_INT_E14     	0x00000080
+#define SUN4M_INT_E10     	0x00080000
+
+#define SUN4M_HARD_INT(x)	(0x000000001 << (x))
+#define SUN4M_SOFT_INT(x)	(0x000010000 << (x))
+
+#define	SUN4M_INT_MASKALL	0x80000000	  /* mask all interrupts */
+#define	SUN4M_INT_MODULE_ERR	0x40000000	  /* module error */
+#define	SUN4M_INT_M2S_WRITE	0x20000000	  /* write buffer error */
+#define	SUN4M_INT_ECC		0x10000000	  /* ecc memory error */
+#define	SUN4M_INT_FLOPPY	0x00400000	  /* floppy disk */
+#define	SUN4M_INT_MODULE	0x00200000	  /* module interrupt */
+#define	SUN4M_INT_VIDEO		0x00100000	  /* onboard video */
+#define	SUN4M_INT_REALTIME	0x00080000	  /* system timer */
+#define	SUN4M_INT_SCSI		0x00040000	  /* onboard scsi */
+#define	SUN4M_INT_AUDIO		0x00020000	  /* audio/isdn */
+#define	SUN4M_INT_ETHERNET	0x00010000	  /* onboard ethernet */
+#define	SUN4M_INT_SERIAL	0x00008000	  /* serial ports */
+#define	SUN4M_INT_KBDMS		0x00004000	  /* keyboard/mouse */
+#define	SUN4M_INT_SBUSBITS	0x00003F80	  /* sbus int bits */
+
+#define SUN4M_INT_SBUS(x)	(1 << (x+7))
+#define SUN4M_INT_VME(x)	(1 << (x))
+
 /* These tables only apply for interrupts greater than 15..
  * 
  * any intr value below 0x10 is considered to be a soft-int
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 63ed19b..730eb57 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -31,6 +31,8 @@
 #include <asm/oplib.h>
 #include <asm/cpudata.h>
 
+#include "irq.h"
+
 #define IRQ_RESCHEDULE		13
 #define IRQ_STOP_CPU		14
 #define IRQ_CROSS_CALL		15
diff --git a/arch/sparc/kernel/tick14.c b/arch/sparc/kernel/tick14.c
index f1a7bd1..a55f046 100644
--- a/arch/sparc/kernel/tick14.c
+++ b/arch/sparc/kernel/tick14.c
@@ -25,6 +25,8 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 
+#include "irq.h"
+
 extern unsigned long lvl14_save[5];
 static unsigned long *linux_lvl14 = NULL;
 static unsigned long obp_lvl14[4];
diff --git a/arch/sparc/kernel/time.c b/arch/sparc/kernel/time.c
index f2fdbb3..6a25133 100644
--- a/arch/sparc/kernel/time.c
+++ b/arch/sparc/kernel/time.c
@@ -44,6 +44,8 @@
 #include <asm/of_device.h>
 #include <asm/irq_regs.h>
 
+#include "irq.h"
+
 DEFINE_SPINLOCK(rtc_lock);
 enum sparc_clock_type sp_clock_typ;
 DEFINE_SPINLOCK(mostek_lock);
diff --git a/include/asm-sparc/irq.h b/include/asm-sparc/irq.h
index ff520ea..4582793 100644
--- a/include/asm-sparc/irq.h
+++ b/include/asm-sparc/irq.h
@@ -14,9 +14,6 @@
 #include <asm/system.h>     /* For SUN4M_NCPUS */
 #include <asm/btfixup.h>
 
-#define __irq_ino(irq) irq
-#define __irq_pil(irq) irq
-
 #define NR_IRQS    16
 
 #define irq_canonicalize(irq)	(irq)
@@ -30,11 +27,6 @@
  */
 BTFIXUPDEF_CALL(void, disable_irq, unsigned int)
 BTFIXUPDEF_CALL(void, enable_irq, unsigned int)
-BTFIXUPDEF_CALL(void, disable_pil_irq, unsigned int)
-BTFIXUPDEF_CALL(void, enable_pil_irq, unsigned int)
-BTFIXUPDEF_CALL(void, clear_clock_irq, void)
-BTFIXUPDEF_CALL(void, clear_profile_irq, int)
-BTFIXUPDEF_CALL(void, load_profile_irq, int, unsigned int)
 
 static inline void disable_irq_nosync(unsigned int irq)
 {
@@ -51,134 +43,6 @@ static inline void enable_irq(unsigned int irq)
 	BTFIXUP_CALL(enable_irq)(irq);
 }
 
-static inline void disable_pil_irq(unsigned int irq)
-{
-	BTFIXUP_CALL(disable_pil_irq)(irq);
-}
-
-static inline void enable_pil_irq(unsigned int irq)
-{
-	BTFIXUP_CALL(enable_pil_irq)(irq);
-}
-
-static inline void clear_clock_irq(void)
-{
-	BTFIXUP_CALL(clear_clock_irq)();
-}
-
-static inline void clear_profile_irq(int irq)
-{
-	BTFIXUP_CALL(clear_profile_irq)(irq);
-}
-
-static inline void load_profile_irq(int cpu, int limit)
-{
-	BTFIXUP_CALL(load_profile_irq)(cpu, limit);
-}
-
-extern void (*sparc_init_timers)(irq_handler_t lvl10_irq);
-extern void claim_ticker14(irq_handler_t irq_handler,
-			   int irq,
-			   unsigned int timeout);
-
-#ifdef CONFIG_SMP
-BTFIXUPDEF_CALL(void, set_cpu_int, int, int)
-BTFIXUPDEF_CALL(void, clear_cpu_int, int, int)
-BTFIXUPDEF_CALL(void, set_irq_udt, int)
-
-#define set_cpu_int(cpu,level) BTFIXUP_CALL(set_cpu_int)(cpu,level)
-#define clear_cpu_int(cpu,level) BTFIXUP_CALL(clear_cpu_int)(cpu,level)
-#define set_irq_udt(cpu) BTFIXUP_CALL(set_irq_udt)(cpu)
-#endif
-
 extern int request_fast_irq(unsigned int irq, irq_handler_t handler, unsigned long flags, __const__ char *devname);
 
-/* On the sun4m, just like the timers, we have both per-cpu and master
- * interrupt registers.
- */
-
-/* These registers are used for sending/receiving irqs from/to
- * different cpu's.
- */
-struct sun4m_intreg_percpu {
-	unsigned int tbt;        /* Interrupts still pending for this cpu. */
-
-	/* These next two registers are WRITE-ONLY and are only
-	 * "on bit" sensitive, "off bits" written have NO affect.
-	 */
-	unsigned int clear;  /* Clear this cpus irqs here. */
-	unsigned int set;    /* Set this cpus irqs here. */
-	unsigned char space[PAGE_SIZE - 12];
-};
-
-/*
- * djhr
- * Actually the clear and set fields in this struct are misleading..
- * according to the SLAVIO manual (and the same applies for the SEC)
- * the clear field clears bits in the mask which will ENABLE that IRQ
- * the set field sets bits in the mask to DISABLE the IRQ.
- *
- * Also the undirected_xx address in the SLAVIO is defined as
- * RESERVED and write only..
- *
- * DAVEM_NOTE: The SLAVIO only specifies behavior on uniprocessor
- *             sun4m machines, for MP the layout makes more sense.
- */
-struct sun4m_intregs {
-	struct sun4m_intreg_percpu cpu_intregs[SUN4M_NCPUS];
-	unsigned int tbt;                /* IRQ's that are still pending. */
-	unsigned int irqs;               /* Master IRQ bits. */
-
-	/* Again, like the above, two these registers are WRITE-ONLY. */
-	unsigned int clear;              /* Clear master IRQ's by setting bits here. */
-	unsigned int set;                /* Set master IRQ's by setting bits here. */
-
-	/* This register is both READ and WRITE. */
-	unsigned int undirected_target;  /* Which cpu gets undirected irqs. */
-};
-
-extern struct sun4m_intregs *sun4m_interrupts;
-
-/* 
- * Bit field defines for the interrupt registers on various
- * Sparc machines.
- */
-
-/* The sun4c interrupt register. */
-#define SUN4C_INT_ENABLE  0x01     /* Allow interrupts. */
-#define SUN4C_INT_E14     0x80     /* Enable level 14 IRQ. */
-#define SUN4C_INT_E10     0x20     /* Enable level 10 IRQ. */
-#define SUN4C_INT_E8      0x10     /* Enable level 8 IRQ. */
-#define SUN4C_INT_E6      0x08     /* Enable level 6 IRQ. */
-#define SUN4C_INT_E4      0x04     /* Enable level 4 IRQ. */
-#define SUN4C_INT_E1      0x02     /* Enable level 1 IRQ. */
-
-/* Dave Redman (djhr@tadpole.co.uk)
- * The sun4m interrupt registers.
- */
-#define SUN4M_INT_ENABLE  	0x80000000
-#define SUN4M_INT_E14     	0x00000080
-#define SUN4M_INT_E10     	0x00080000
-
-#define SUN4M_HARD_INT(x)	(0x000000001 << (x))
-#define SUN4M_SOFT_INT(x)	(0x000010000 << (x))
-
-#define	SUN4M_INT_MASKALL	0x80000000	  /* mask all interrupts */
-#define	SUN4M_INT_MODULE_ERR	0x40000000	  /* module error */
-#define	SUN4M_INT_M2S_WRITE	0x20000000	  /* write buffer error */
-#define	SUN4M_INT_ECC		0x10000000	  /* ecc memory error */
-#define	SUN4M_INT_FLOPPY	0x00400000	  /* floppy disk */
-#define	SUN4M_INT_MODULE	0x00200000	  /* module interrupt */
-#define	SUN4M_INT_VIDEO		0x00100000	  /* onboard video */
-#define	SUN4M_INT_REALTIME	0x00080000	  /* system timer */
-#define	SUN4M_INT_SCSI		0x00040000	  /* onboard scsi */
-#define	SUN4M_INT_AUDIO		0x00020000	  /* audio/isdn */
-#define	SUN4M_INT_ETHERNET	0x00010000	  /* onboard ethernet */
-#define	SUN4M_INT_SERIAL	0x00008000	  /* serial ports */
-#define	SUN4M_INT_KBDMS		0x00004000	  /* keyboard/mouse */
-#define	SUN4M_INT_SBUSBITS	0x00003F80	  /* sbus int bits */
-
-#define SUN4M_INT_SBUS(x)	(1 << (x+7))
-#define SUN4M_INT_VME(x)	(1 << (x))
-
 #endif
-- 
1.5.3.GIT
