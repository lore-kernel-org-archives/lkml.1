Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbYGJSoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbYGJSoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYGJSlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:20499 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbYGJSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="11424591"
Message-Id: <20080710182238.058684000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:49 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 15/26] x64, x2apic/intr-remap: basic apic ops support
Content-Disposition: inline; filename=apic_ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce basic apic operations which handle the apic programming. This
will be used later to introduce another specific operations for x2apic.

For the perfomance critial accesses like IPI's, EOI etc, we use the
native operations as they are already referenced by different
indirections like genapic, irq_chip etc.

64bit Paravirt ops can also define their apic operations accordingly.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/apic_64.c	2008-07-10 09:52:12.000000000 -0700
+++ tree-x86/arch/x86/kernel/apic_64.c	2008-07-10 09:52:14.000000000 -0700
@@ -119,13 +119,13 @@
 	return lapic_get_version() >= 0x14;
 }
 
-void apic_wait_icr_idle(void)
+void xapic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
 		cpu_relax();
 }
 
-u32 safe_apic_wait_icr_idle(void)
+u32 safe_xapic_wait_icr_idle(void)
 {
 	u32 send_status;
 	int timeout;
@@ -141,6 +141,36 @@
 	return send_status;
 }
 
+void xapic_icr_write(u32 low, u32 id)
+{
+	apic_write(APIC_ICR2, id << 24);
+	apic_write(APIC_ICR, low);
+}
+
+u64 xapic_icr_read(void)
+{
+	u32 icr1, icr2;
+
+	icr2 = apic_read(APIC_ICR2);
+	icr1 = apic_read(APIC_ICR);
+
+	return (icr1 | ((u64)icr2 << 32));
+}
+
+static struct apic_ops xapic_ops = {
+	.read = native_apic_mem_read,
+	.write = native_apic_mem_write,
+	.write_atomic = native_apic_mem_write_atomic,
+	.icr_read = xapic_icr_read,
+	.icr_write = xapic_icr_write,
+	.wait_icr_idle = xapic_wait_icr_idle,
+	.safe_wait_icr_idle = safe_xapic_wait_icr_idle,
+};
+
+struct apic_ops __read_mostly *apic_ops = &xapic_ops;
+
+EXPORT_SYMBOL_GPL(apic_ops);
+
 /**
  * enable_NMI_through_LVT0 - enable NMI through local vector table 0
  */
Index: tree-x86/arch/x86/kernel/paravirt.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/paravirt.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/paravirt.c	2008-07-10 09:52:14.000000000 -0700
@@ -373,9 +373,11 @@
 
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
-	.apic_write = native_apic_write,
-	.apic_write_atomic = native_apic_write_atomic,
-	.apic_read = native_apic_read,
+#ifnded CONFIG_X86_64
+	.apic_write = native_apic_mem_write,
+	.apic_write_atomic = native_apic_mem_write_atomic,
+	.apic_read = native_apic_mem_read,
+#endif
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
 	.startup_ipi_hook = paravirt_nop,
Index: tree-x86/include/asm-x86/apic.h
===================================================================
--- tree-x86.orig/include/asm-x86/apic.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/apic.h	2008-07-10 09:52:14.000000000 -0700
@@ -47,32 +47,59 @@
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define apic_write native_apic_write
-#define apic_write_atomic native_apic_write_atomic
-#define apic_read native_apic_read
+#ifndef CONFIG_X86_64
+#define apic_write native_apic_mem_write
+#define apic_write_atomic native_apic_mem_write_atomic
+#define apic_read native_apic_mem_read
+#endif
 #define setup_boot_clock setup_boot_APIC_clock
 #define setup_secondary_clock setup_secondary_APIC_clock
 #endif
 
 extern int is_vsmp_box(void);
 
-static inline void native_apic_write(unsigned long reg, u32 v)
+static inline void native_apic_mem_write(u32 reg, u32 v)
 {
 	*((volatile u32 *)(APIC_BASE + reg)) = v;
 }
 
-static inline void native_apic_write_atomic(unsigned long reg, u32 v)
+static inline void native_apic_mem_write_atomic(u32 reg, u32 v)
 {
 	(void)xchg((u32 *)(APIC_BASE + reg), v);
 }
 
-static inline u32 native_apic_read(unsigned long reg)
+static inline u32 native_apic_mem_read(u32 reg)
 {
 	return *((volatile u32 *)(APIC_BASE + reg));
 }
 
+#ifdef CONFIG_X86_32
 extern void apic_wait_icr_idle(void);
 extern u32 safe_apic_wait_icr_idle(void);
+extern void apic_icr_write(u32 low, u32 id);
+#else
+
+struct apic_ops {
+	u32 (*read)(u32 reg);
+	void (*write)(u32 reg, u32 v);
+	void (*write_atomic)(u32 reg, u32 v);
+	u64 (*icr_read)(void);
+	void (*icr_write)(u32 low, u32 high);
+	void (*wait_icr_idle)(void);
+	u32 (*safe_wait_icr_idle)(void);
+};
+
+extern struct apic_ops *apic_ops;
+
+#define apic_read (apic_ops->read)
+#define apic_write (apic_ops->write)
+#define apic_write_atomic (apic_ops->write_atomic)
+#define apic_icr_read (apic_ops->icr_read)
+#define apic_icr_write (apic_ops->icr_write)
+#define apic_wait_icr_idle (apic_ops->wait_icr_idle)
+#define safe_apic_wait_icr_idle (apic_ops->safe_wait_icr_idle)
+#endif
+
 extern int get_physical_broadcast(void);
 
 #ifdef CONFIG_X86_GOOD_APIC
@@ -95,7 +122,11 @@
 	 */
 
 	/* Docs say use 0 for future compatibility */
+#ifdef CONFIG_X86_32
 	apic_write_around(APIC_EOI, 0);
+#else
+	native_apic_mem_write(APIC_EOI, 0);
+#endif
 }
 
 extern int lapic_get_maxlvt(void);
Index: tree-x86/include/asm-x86/paravirt.h
===================================================================
--- tree-x86.orig/include/asm-x86/paravirt.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/paravirt.h	2008-07-10 09:52:14.000000000 -0700
@@ -902,6 +902,7 @@
 /*
  * Basic functions accessing APICs.
  */
+#ifndef CONFIG_X86_64
 static inline void apic_write(unsigned long reg, u32 v)
 {
 	PVOP_VCALL2(pv_apic_ops.apic_write, reg, v);
@@ -916,6 +917,7 @@
 {
 	return PVOP_CALL1(unsigned long, pv_apic_ops.apic_read, reg);
 }
+#endif
 
 static inline void setup_boot_clock(void)
 {
Index: tree-x86/include/asm-x86/ipi.h
===================================================================
--- tree-x86.orig/include/asm-x86/ipi.h	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/include/asm-x86/ipi.h	2008-07-10 09:52:14.000000000 -0700
@@ -49,6 +49,12 @@
 	return SET_APIC_DEST_FIELD(mask);
 }
 
+static inline void __xapic_wait_icr_idle(void)
+{
+	while (native_apic_mem_read(APIC_ICR) & APIC_ICR_BUSY)
+		cpu_relax();
+}
+
 static inline void __send_IPI_shortcut(unsigned int shortcut, int vector,
 				       unsigned int dest)
 {
@@ -64,7 +70,7 @@
 	/*
 	 * Wait for idle.
 	 */
-	apic_wait_icr_idle();
+	__xapic_wait_icr_idle();
 
 	/*
 	 * No need to touch the target chip field
@@ -74,7 +80,7 @@
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
-	apic_write(APIC_ICR, cfg);
+	native_apic_mem_write(APIC_ICR, cfg);
 }
 
 /*
@@ -92,13 +98,13 @@
 	if (unlikely(vector == NMI_VECTOR))
 		safe_apic_wait_icr_idle();
 	else
-		apic_wait_icr_idle();
+		__xapic_wait_icr_idle();
 
 	/*
 	 * prepare target chip field
 	 */
 	cfg = __prepare_ICR2(mask);
-	apic_write(APIC_ICR2, cfg);
+	native_apic_mem_write(APIC_ICR2, cfg);
 
 	/*
 	 * program the ICR
@@ -108,7 +114,7 @@
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
-	apic_write(APIC_ICR, cfg);
+	native_apic_mem_write(APIC_ICR, cfg);
 }
 
 static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
Index: tree-x86/arch/x86/kernel/apic_32.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/apic_32.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/apic_32.c	2008-07-10 09:52:14.000000000 -0700
@@ -145,6 +145,12 @@
 	return lapic_get_version() >= 0x14;
 }
 
+void apic_icr_write(u32 low, u32 id)
+{
+	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(id));
+	apic_write_around(APIC_ICR, low);
+}
+
 void apic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
Index: tree-x86/arch/x86/kernel/smpboot.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/smpboot.c	2008-07-10 09:51:45.000000000 -0700
+++ tree-x86/arch/x86/kernel/smpboot.c	2008-07-10 09:52:14.000000000 -0700
@@ -123,7 +123,6 @@
 
 static atomic_t init_deasserted;
 
-static int boot_cpu_logical_apicid;
 
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
@@ -165,6 +164,8 @@
 #endif
 
 #ifdef CONFIG_X86_32
+static int boot_cpu_logical_apicid;
+
 u8 cpu_2_logical_apicid[NR_CPUS] __read_mostly =
 					{ [0 ... NR_CPUS-1] = BAD_APICID };
 
@@ -546,8 +547,7 @@
 			printk(KERN_CONT
 			       "a previous APIC delivery may have failed\n");
 
-		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
-		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);
+		apic_icr_write(APIC_DM_REMRD | regs[i], apicid);
 
 		timeout = 0;
 		do {
@@ -579,11 +579,9 @@
 	int maxlvt;
 
 	/* Target chip */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(logical_apicid));
-
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_write_around(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
+	apic_icr_write(APIC_DM_NMI | APIC_DEST_LOGICAL, logical_apicid);
 
 	Dprintk("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -639,13 +637,11 @@
 	/*
 	 * Turn INIT on target chip
 	 */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
 	/*
 	 * Send IPI
 	 */
-	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
-				| APIC_DM_INIT);
+	apic_icr_write(APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT,
+		       phys_apicid);
 
 	Dprintk("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -655,10 +651,8 @@
 	Dprintk("Deasserting INIT.\n");
 
 	/* Target chip */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
 	/* Send IPI */
-	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
+	apic_icr_write(APIC_INT_LEVELTRIG | APIC_DM_INIT, phys_apicid);
 
 	Dprintk("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -703,12 +697,10 @@
 		 */
 
 		/* Target chip */
-		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
 		/* Boot on the stack */
 		/* Kick the second */
-		apic_write_around(APIC_ICR, APIC_DM_STARTUP
-					| (start_eip >> 12));
+		apic_icr_write(APIC_DM_STARTUP | (start_eip >> 12),
+			       phys_apicid);
 
 		/*
 		 * Give the other CPU some time to accept the IPI.
@@ -1147,7 +1139,9 @@
 	 * Setup boot CPU information
 	 */
 	smp_store_cpu_info(0); /* Final full version of the data */
+#ifdef CONFIG_X86_32
 	boot_cpu_logical_apicid = logical_smp_processor_id();
+#endif
 	current_thread_info()->cpu = 0;  /* needed? */
 	set_cpu_sibling_map(0);
 
Index: tree-x86/arch/x86/kernel/io_apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/io_apic_64.c	2008-07-10 09:52:11.000000000 -0700
+++ tree-x86/arch/x86/kernel/io_apic_64.c	2008-07-10 09:52:14.000000000 -0700
@@ -1157,6 +1157,7 @@
 void __apicdebuginit print_local_APIC(void * dummy)
 {
 	unsigned int v, ver, maxlvt;
+	unsigned long icr;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1200,10 +1201,9 @@
 	v = apic_read(APIC_ESR);
 	printk(KERN_DEBUG "... APIC ESR: %08x\n", v);
 
-	v = apic_read(APIC_ICR);
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", v);
-	v = apic_read(APIC_ICR2);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", v);
+	icr = apic_icr_read();
+	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
Index: tree-x86/include/asm-x86/smp.h
===================================================================
--- tree-x86.orig/include/asm-x86/smp.h	2008-07-10 09:52:12.000000000 -0700
+++ tree-x86/include/asm-x86/smp.h	2008-07-10 09:52:14.000000000 -0700
@@ -165,13 +165,13 @@
 
 #ifdef CONFIG_X86_LOCAL_APIC
 
+#ifndef CONFIG_X86_64
 static inline int logical_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
 }
 
-#ifndef CONFIG_X86_64
 static inline unsigned int read_apic_id(void)
 {
 	return *(u32 *)(APIC_BASE + APIC_ID);

-- 

