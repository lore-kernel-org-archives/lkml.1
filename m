Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbZBQHDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbZBQHDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 02:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZBQHDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 02:03:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:46994 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZBQHDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 02:03:36 -0500
Message-ID: <499A60F6.5080704@kernel.org>
Date: Mon, 16 Feb 2009 23:02:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fold apic_ops into genapic -v2
References: <499A1316.9000204@kernel.org> <499A136D.2040006@kernel.org>
In-Reply-To: <499A136D.2040006@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

make it simple, don't need have one extra struct
v2: fix sgi_uv compiling

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/apic.h               |   97 +++++++++---------------------
 arch/x86/include/asm/genapic.h            |   61 ++++++++++++++++++
 arch/x86/kernel/apic.c                    |   63 +------------------
 arch/x86/kernel/bigsmp_32.c               |    7 ++
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 
 arch/x86/kernel/cpu/perf_counter.c        |    2 
 arch/x86/kernel/cpu/perfctr-watchdog.c    |    2 
 arch/x86/kernel/es7000_32.c               |    7 ++
 arch/x86/kernel/genapic_64.c              |    2 
 arch/x86/kernel/genapic_flat_64.c         |   16 ++++
 arch/x86/kernel/genx2apic_cluster.c       |   11 ++-
 arch/x86/kernel/genx2apic_phys.c          |   11 ++-
 arch/x86/kernel/genx2apic_uv_x.c          |    9 ++
 arch/x86/kernel/ipi.c                     |    2 
 arch/x86/kernel/irq.c                     |    2 
 arch/x86/kernel/nmi.c                     |    2 
 arch/x86/kernel/numaq_32.c                |    7 ++
 arch/x86/kernel/probe_32.c                |    7 ++
 arch/x86/kernel/summit_32.c               |    7 ++
 arch/x86/kernel/uv_irq.c                  |    2 
 arch/x86/kernel/vmi_32.c                  |    6 -
 arch/x86/kernel/vmiclock_32.c             |    2 
 arch/x86/lguest/boot.c                    |   19 +++--
 arch/x86/xen/enlighten.c                  |   21 +++---
 25 files changed, 206 insertions(+), 163 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -92,6 +92,12 @@ static inline u32 native_apic_mem_read(u
 	return *((volatile u32 *)(APIC_BASE + reg));
 }
 
+extern void native_apic_wait_icr_idle(void);
+extern u32 native_safe_apic_wait_icr_idle(void);
+extern void native_apic_icr_write(u32 low, u32 id);
+extern u64 native_apic_icr_read(void);
+
+#ifdef CONFIG_X86_X2APIC
 static inline void native_apic_msr_write(u32 reg, u32 v)
 {
 	if (reg == APIC_DFR || reg == APIC_ID || reg == APIC_LDR ||
@@ -112,7 +118,31 @@ static inline u32 native_apic_msr_read(u
 	return low;
 }
 
-#ifdef CONFIG_X86_X2APIC
+static inline void native_x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return;
+}
+
+static inline u32 native_safe_x2apic_wait_icr_idle(void)
+{
+	/* no need to wait for icr idle in x2apic */
+	return 0;
+}
+
+static inline void native_x2apic_icr_write(u32 low, u32 id)
+{
+	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
+}
+
+static inline u64 native_x2apic_icr_read(void)
+{
+	unsigned long val;
+
+	rdmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), val);
+	return val;
+}
+
 extern int x2apic;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
@@ -146,47 +176,6 @@ static inline int x2apic_enabled(void)
 }
 #endif
 
-struct apic_ops {
-	u32 (*read)(u32 reg);
-	void (*write)(u32 reg, u32 v);
-	u64 (*icr_read)(void);
-	void (*icr_write)(u32 low, u32 high);
-	void (*wait_icr_idle)(void);
-	u32 (*safe_wait_icr_idle)(void);
-};
-
-extern struct apic_ops *apic_ops;
-
-static inline u32 apic_read(u32 reg)
-{
-	return apic_ops->read(reg);
-}
-
-static inline void apic_write(u32 reg, u32 val)
-{
-	apic_ops->write(reg, val);
-}
-
-static inline u64 apic_icr_read(void)
-{
-	return apic_ops->icr_read();
-}
-
-static inline void apic_icr_write(u32 low, u32 high)
-{
-	apic_ops->icr_write(low, high);
-}
-
-static inline void apic_wait_icr_idle(void)
-{
-	apic_ops->wait_icr_idle();
-}
-
-static inline u32 safe_apic_wait_icr_idle(void)
-{
-	return apic_ops->safe_wait_icr_idle();
-}
-
 extern int get_physical_broadcast(void);
 
 #ifdef CONFIG_X86_X2APIC
@@ -197,18 +186,6 @@ static inline void ack_x2APIC_irq(void)
 }
 #endif
 
-
-static inline void ack_APIC_irq(void)
-{
-	/*
-	 * ack_APIC_irq() actually gets compiled as a single instruction
-	 * ... yummie.
-	 */
-
-	/* Docs say use 0 for future compatibility */
-	apic_write(APIC_EOI, 0);
-}
-
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
 extern void connect_bsp_APIC(void);
@@ -256,18 +233,6 @@ static inline void disable_local_APIC(vo
 #define	SET_APIC_ID(x)		(apic->set_apic_id(x))
 #else
 
-#ifdef CONFIG_X86_LOCAL_APIC
-static inline unsigned default_get_apic_id(unsigned long x)
-{
-	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
-
-	if (APIC_XAPIC(ver))
-		return (x >> 24) & 0xFF;
-	else
-		return (x >> 24) & 0x0F;
-}
-#endif
-
 #endif
 
 #endif /* _ASM_X86_APIC_H */
Index: linux-2.6/arch/x86/include/asm/genapic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/genapic.h
+++ linux-2.6/arch/x86/include/asm/genapic.h
@@ -5,6 +5,7 @@
 
 #include <asm/mpspec.h>
 #include <asm/atomic.h>
+#include <asm/apic.h>
 
 /*
  * Copyright 2004 James Cleverdon, IBM.
@@ -83,10 +84,70 @@ struct genapic {
 	void (*smp_callin_clear_local_apic)(void);
 	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
 	void (*inquire_remote_apic)(int apicid);
+
+	/* apic ops */
+	u32 (*read)(u32 reg);
+	void (*write)(u32 reg, u32 v);
+	u64 (*icr_read)(void);
+	void (*icr_write)(u32 low, u32 high);
+	void (*wait_icr_idle)(void);
+	u32 (*safe_wait_icr_idle)(void);
 };
 
 extern struct genapic *apic;
 
+static inline u32 apic_read(u32 reg)
+{
+	return apic->read(reg);
+}
+
+static inline void apic_write(u32 reg, u32 val)
+{
+	apic->write(reg, val);
+}
+
+static inline u64 apic_icr_read(void)
+{
+	return apic->icr_read();
+}
+
+static inline void apic_icr_write(u32 low, u32 high)
+{
+	apic->icr_write(low, high);
+}
+
+static inline void apic_wait_icr_idle(void)
+{
+	apic->wait_icr_idle();
+}
+
+static inline u32 safe_apic_wait_icr_idle(void)
+{
+	return apic->safe_wait_icr_idle();
+}
+
+
+static inline void ack_APIC_irq(void)
+{
+	/*
+	 * ack_APIC_irq() actually gets compiled as a single instruction
+	 * ... yummie.
+	 */
+
+	/* Docs say use 0 for future compatibility */
+	apic_write(APIC_EOI, 0);
+}
+
+static inline unsigned default_get_apic_id(unsigned long x)
+{
+	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
+
+	if (APIC_XAPIC(ver))
+		return (x >> 24) & 0xFF;
+	else
+		return (x >> 24) & 0x0F;
+}
+
 /*
  * Warm reset vector default position:
  */
Index: linux-2.6/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic.c
+++ linux-2.6/arch/x86/kernel/apic.c
@@ -211,18 +211,13 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
-/*
- * Paravirt kernels also might be using these below ops. So we still
- * use generic apic_read()/apic_write(), which might be pointing to different
- * ops in PARAVIRT case.
- */
-void xapic_wait_icr_idle(void)
+void native_apic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
 		cpu_relax();
 }
 
-u32 safe_xapic_wait_icr_idle(void)
+u32 native_safe_apic_wait_icr_idle(void)
 {
 	u32 send_status;
 	int timeout;
@@ -238,13 +233,13 @@ u32 safe_xapic_wait_icr_idle(void)
 	return send_status;
 }
 
-void xapic_icr_write(u32 low, u32 id)
+void native_apic_icr_write(u32 low, u32 id)
 {
 	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
 	apic_write(APIC_ICR, low);
 }
 
-static u64 xapic_icr_read(void)
+u64 native_apic_icr_read(void)
 {
 	u32 icr1, icr2;
 
@@ -254,54 +249,6 @@ static u64 xapic_icr_read(void)
 	return icr1 | ((u64)icr2 << 32);
 }
 
-static struct apic_ops xapic_ops = {
-	.read = native_apic_mem_read,
-	.write = native_apic_mem_write,
-	.icr_read = xapic_icr_read,
-	.icr_write = xapic_icr_write,
-	.wait_icr_idle = xapic_wait_icr_idle,
-	.safe_wait_icr_idle = safe_xapic_wait_icr_idle,
-};
-
-struct apic_ops __read_mostly *apic_ops = &xapic_ops;
-EXPORT_SYMBOL_GPL(apic_ops);
-
-#ifdef CONFIG_X86_X2APIC
-static void x2apic_wait_icr_idle(void)
-{
-	/* no need to wait for icr idle in x2apic */
-	return;
-}
-
-static u32 safe_x2apic_wait_icr_idle(void)
-{
-	/* no need to wait for icr idle in x2apic */
-	return 0;
-}
-
-void x2apic_icr_write(u32 low, u32 id)
-{
-	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
-}
-
-static u64 x2apic_icr_read(void)
-{
-	unsigned long val;
-
-	rdmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), val);
-	return val;
-}
-
-static struct apic_ops x2apic_ops = {
-	.read = native_apic_msr_read,
-	.write = native_apic_msr_write,
-	.icr_read = x2apic_icr_read,
-	.icr_write = x2apic_icr_write,
-	.wait_icr_idle = x2apic_wait_icr_idle,
-	.safe_wait_icr_idle = safe_x2apic_wait_icr_idle,
-};
-#endif
-
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
@@ -1333,7 +1280,6 @@ void check_x2apic(void)
 	if (msr & X2APIC_ENABLE) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
 		x2apic_preenabled = x2apic = 1;
-		apic_ops = &x2apic_ops;
 	}
 }
 
@@ -1407,7 +1353,6 @@ void __init enable_IR_x2apic(void)
 
 	if (!x2apic) {
 		x2apic = 1;
-		apic_ops = &x2apic_ops;
 		enable_x2apic();
 	}
 
Index: linux-2.6/arch/x86/kernel/bigsmp_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/bigsmp_32.c
+++ linux-2.6/arch/x86/kernel/bigsmp_32.c
@@ -263,4 +263,11 @@ struct genapic apic_bigsmp = {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -24,7 +24,7 @@
 #include <linux/smp.h>
 #include <linux/sysdev.h>
 #include <linux/sysfs.h>
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/percpu.h>
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -7,7 +7,7 @@
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <asm/processor.h>
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -17,7 +17,7 @@
 #include <linux/sched.h>
 
 #include <asm/perf_counter.h>
-#include <asm/apic.h>
+#include <asm/genapic.h>
 
 static bool perf_counters_initialized __read_mostly;
 
Index: linux-2.6/arch/x86/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ linux-2.6/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -19,7 +19,7 @@
 #include <linux/nmi.h>
 #include <linux/kprobes.h>
 
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/perf_counter.h>
 
 struct nmi_watchdog_ctlblk {
Index: linux-2.6/arch/x86/kernel/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/es7000_32.c
+++ linux-2.6/arch/x86/kernel/es7000_32.c
@@ -806,4 +806,11 @@ struct genapic apic_es7000 = {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
Index: linux-2.6/arch/x86/kernel/genapic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_64.c
+++ linux-2.6/arch/x86/kernel/genapic_64.c
@@ -19,8 +19,8 @@
 #include <linux/dmar.h>
 
 #include <asm/smp.h>
-#include <asm/ipi.h>
 #include <asm/genapic.h>
+#include <asm/ipi.h>
 #include <asm/setup.h>
 
 extern struct genapic apic_flat;
Index: linux-2.6/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6/arch/x86/kernel/genapic_flat_64.c
@@ -17,8 +17,8 @@
 #include <linux/init.h>
 #include <linux/hardirq.h>
 #include <asm/smp.h>
-#include <asm/ipi.h>
 #include <asm/genapic.h>
+#include <asm/ipi.h>
 
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
@@ -229,6 +229,13 @@ struct genapic apic_flat =  {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
 
 /*
@@ -374,4 +381,11 @@ struct genapic apic_physflat =  {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
Index: linux-2.6/arch/x86/kernel/genx2apic_cluster.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6/arch/x86/kernel/genx2apic_cluster.c
@@ -7,8 +7,8 @@
 #include <linux/dmar.h>
 
 #include <asm/smp.h>
-#include <asm/ipi.h>
 #include <asm/genapic.h>
+#include <asm/ipi.h>
 
 DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 
@@ -46,7 +46,7 @@ static void
 	/*
 	 * send the IPI.
 	 */
-	x2apic_icr_write(cfg, apicid);
+	native_x2apic_icr_write(cfg, apicid);
 }
 
 /*
@@ -234,4 +234,11 @@ struct genapic apic_x2apic_cluster = {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
+
+	.read				= native_apic_msr_read,
+	.write				= native_apic_msr_write,
+	.icr_read			= native_x2apic_icr_read,
+	.icr_write			= native_x2apic_icr_write,
+	.wait_icr_idle			= native_x2apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
Index: linux-2.6/arch/x86/kernel/genx2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6/arch/x86/kernel/genx2apic_phys.c
@@ -7,8 +7,8 @@
 #include <linux/dmar.h>
 
 #include <asm/smp.h>
-#include <asm/ipi.h>
 #include <asm/genapic.h>
+#include <asm/ipi.h>
 
 static int x2apic_phys;
 
@@ -50,7 +50,7 @@ static void __x2apic_send_IPI_dest(unsig
 	/*
 	 * send the IPI.
 	 */
-	x2apic_icr_write(cfg, apicid);
+	native_x2apic_icr_write(cfg, apicid);
 }
 
 static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
@@ -220,4 +220,11 @@ struct genapic apic_x2apic_phys = {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
+
+	.read				= native_apic_msr_read,
+	.write				= native_apic_msr_write,
+	.icr_read			= native_x2apic_icr_read,
+	.icr_write			= native_x2apic_icr_write,
+	.wait_icr_idle			= native_x2apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
Index: linux-2.6/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6/arch/x86/kernel/genx2apic_uv_x.c
@@ -22,8 +22,8 @@
 #include <linux/proc_fs.h>
 #include <asm/current.h>
 #include <asm/smp.h>
-#include <asm/ipi.h>
 #include <asm/genapic.h>
+#include <asm/ipi.h>
 #include <asm/pgtable.h>
 #include <asm/uv/uv.h>
 #include <asm/uv/uv_mmrs.h>
@@ -292,6 +292,13 @@ struct genapic apic_x2apic_uv_x = {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
+
+	.read				= native_apic_msr_read,
+	.write				= native_apic_msr_write,
+	.icr_read			= native_x2apic_icr_read,
+	.icr_write			= native_x2apic_icr_write,
+	.wait_icr_idle			= native_x2apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
 
 static __cpuinit void set_x2apic_extra_bits(int pnode)
Index: linux-2.6/arch/x86/kernel/ipi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ipi.c
+++ linux-2.6/arch/x86/kernel/ipi.c
@@ -15,7 +15,7 @@
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/proto.h>
 #include <asm/ipi.h>
 
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -8,7 +8,7 @@
 #include <linux/smp.h>
 #include <linux/ftrace.h>
 
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/io_apic.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
Index: linux-2.6/arch/x86/kernel/nmi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/nmi.c
+++ linux-2.6/arch/x86/kernel/nmi.c
@@ -11,7 +11,7 @@
  *  Mikael Pettersson	: PM converted to driver model. Disable/enable API.
  */
 
-#include <asm/apic.h>
+#include <asm/genapic.h>
 
 #include <linux/nmi.h>
 #include <linux/mm.h>
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -569,4 +569,11 @@ struct genapic apic_numaq = {
 	.smp_callin_clear_local_apic	= numaq_smp_callin_clear_local_apic,
 	.store_NMI_vector		= numaq_store_NMI_vector,
 	.inquire_remote_apic		= NULL,
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
Index: linux-2.6/arch/x86/kernel/probe_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/probe_32.c
+++ linux-2.6/arch/x86/kernel/probe_32.c
@@ -127,6 +127,13 @@ struct genapic apic_default = {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
 
 extern struct genapic apic_numaq;
Index: linux-2.6/arch/x86/kernel/summit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/summit_32.c
+++ linux-2.6/arch/x86/kernel/summit_32.c
@@ -599,4 +599,11 @@ struct genapic apic_summit = {
 	.smp_callin_clear_local_apic	= NULL,
 	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
+
+	.read				= native_apic_mem_read,
+	.write				= native_apic_mem_write,
+	.icr_read			= native_apic_icr_read,
+	.icr_write			= native_apic_icr_write,
+	.wait_icr_idle			= native_apic_wait_icr_idle,
+	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
Index: linux-2.6/arch/x86/kernel/vmi_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmi_32.c
+++ linux-2.6/arch/x86/kernel/vmi_32.c
@@ -32,7 +32,7 @@
 #include <asm/io.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/processor.h>
 #include <asm/timer.h>
 #include <asm/vmi_time.h>
@@ -798,8 +798,8 @@ static inline int __init activate_vmi(vo
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-       para_fill(apic_ops->read, APICRead);
-       para_fill(apic_ops->write, APICWrite);
+       para_fill(apic->read, APICRead);
+       para_fill(apic->write, APICWrite);
 #endif
 
 	/*
Index: linux-2.6/arch/x86/kernel/vmiclock_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmiclock_32.c
+++ linux-2.6/arch/x86/kernel/vmiclock_32.c
@@ -30,7 +30,7 @@
 #include <asm/vmi_time.h>
 #include <asm/arch_hooks.h>
 #include <asm/apicdef.h>
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/timer.h>
 #include <asm/i8253.h>
 #include <asm/irq_vectors.h>
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -55,7 +55,7 @@
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
 #include <linux/pm.h>
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/lguest.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
@@ -828,13 +828,14 @@ static u32 lguest_apic_safe_wait_icr_idl
 	return 0;
 }
 
-static struct apic_ops lguest_basic_apic_ops = {
-	.read = lguest_apic_read,
-	.write = lguest_apic_write,
-	.icr_read = lguest_apic_icr_read,
-	.icr_write = lguest_apic_icr_write,
-	.wait_icr_idle = lguest_apic_wait_icr_idle,
-	.safe_wait_icr_idle = lguest_apic_safe_wait_icr_idle,
+static void set_lguest_basic_apic_ops(void)
+{
+	apic->read = lguest_apic_read;
+	apic->write = lguest_apic_write;
+	apic->icr_read = lguest_apic_icr_read;
+	apic->icr_write = lguest_apic_icr_write;
+	apic->wait_icr_idle = lguest_apic_wait_icr_idle;
+	apic->safe_wait_icr_idle = lguest_apic_safe_wait_icr_idle;
 };
 #endif
 
@@ -1035,7 +1036,7 @@ __init void lguest_init(void)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* apic read/write intercepts */
-	apic_ops = &lguest_basic_apic_ops;
+	set_lguest_basic_apic_ops();
 #endif
 
 	/* time operations */
Index: linux-2.6/arch/x86/xen/enlighten.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/enlighten.c
+++ linux-2.6/arch/x86/xen/enlighten.c
@@ -36,7 +36,7 @@
 #include <xen/hvc-console.h>
 
 #include <asm/paravirt.h>
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/page.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -554,14 +554,15 @@ static u32 xen_safe_apic_wait_icr_idle(v
         return 0;
 }
 
-static struct apic_ops xen_basic_apic_ops = {
-	.read = xen_apic_read,
-	.write = xen_apic_write,
-	.icr_read = xen_apic_icr_read,
-	.icr_write = xen_apic_icr_write,
-	.wait_icr_idle = xen_apic_wait_icr_idle,
-	.safe_wait_icr_idle = xen_safe_apic_wait_icr_idle,
-};
+static void set_xen_basic_apic_ops(void)
+{
+	apic->read = xen_apic_read;
+	apic->write = xen_apic_write;
+	apic->icr_read = xen_apic_icr_read;
+	apic->icr_write = xen_apic_icr_write;
+	apic->wait_icr_idle = xen_apic_wait_icr_idle;
+	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
+}
 
 #endif
 
@@ -898,7 +899,7 @@ asmlinkage void __init xen_start_kernel(
 	/*
 	 * set up the basic apic ops.
 	 */
-	apic_ops = &xen_basic_apic_ops;
+	set_xen_basic_apic_ops();
 #endif
 
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
Index: linux-2.6/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6/arch/x86/kernel/uv_irq.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 
-#include <asm/apic.h>
+#include <asm/genapic.h>
 #include <asm/uv/uv_irq.h>
 
 static void uv_noop(unsigned int irq)
