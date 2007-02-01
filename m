Return-Path: <linux-kernel-owner+w=401wt.eu-S1422805AbXBAL3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422805AbXBAL3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422815AbXBAL3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:29:14 -0500
Received: from styx.suse.cz ([82.119.242.94]:54132 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422805AbXBAL3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:29:13 -0500
Message-Id: <20070201103753.849165000@jet.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
User-Agent: quilt/0.44-16.5
Date: Thu, 01 Feb 2007 10:59:57 +0100
From: jbohac@suse.cz
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: [patch 5/9] Add all the necessary structures to the vsyscall page
Content-Disposition: inline; filename=prepare_vsyscall
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The TSC-based Master Timer approximation code will need a couple of
per-CPU offsets and coefficients to approximate the value of a hardware
"Master Timer" based on the value of TSC on whichever CPU it will be
running.

We want to be able to do these approximations in a vsyscall, so we need
all this data in vsyscall-mapped pages.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>


Index: linux-2.6.20-rc5/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/vsyscall.c
+++ linux-2.6.20-rc5/arch/x86_64/kernel/vsyscall.c
@@ -278,9 +278,11 @@ static void __init map_vsyscall(void)
 {
 	extern char __vsyscall_0;
 	unsigned long physaddr_page0 = __pa_symbol(&__vsyscall_0);
+	int i;
 
 	/* Note that VSYSCALL_MAPPED_PAGES must agree with the code below. */
-	__set_fixmap(VSYSCALL_FIRST_PAGE, physaddr_page0, PAGE_KERNEL_VSYSCALL);
+	for (i = 0; i < VSYSCALL_MAPPED_PAGES; ++i)
+		__set_fixmap(VSYSCALL_FIRST_PAGE - i, physaddr_page0 + (i << 12), PAGE_KERNEL_VSYSCALL);
 }
 
 static int __init vsyscall_init(void)
Index: linux-2.6.20-rc5/include/asm-x86_64/vsyscall.h
===================================================================
--- linux-2.6.20-rc5.orig/include/asm-x86_64/vsyscall.h
+++ linux-2.6.20-rc5/include/asm-x86_64/vsyscall.h
@@ -10,7 +10,6 @@ enum vsyscall_num {
 #define VSYSCALL_START (-10UL << 20)
 #define VSYSCALL_SIZE 1024
 #define VSYSCALL_END (-2UL << 20)
-#define VSYSCALL_MAPPED_PAGES 1
 #define VSYSCALL_ADDR(vsyscall_nr) (VSYSCALL_START+VSYSCALL_SIZE*(vsyscall_nr))
 
 #ifdef __KERNEL__
@@ -24,19 +23,40 @@ enum vsyscall_num {
 #define __section_xtime __attribute__ ((unused, __section__ (".xtime"), aligned(16)))
 #define __section_xtime_lock __attribute__ ((unused, __section__ (".xtime_lock"), aligned(16)))
 
-#define VXTIME_TSC	1
+#define VXTIME_TSC	1	/* estimate MT based on rdtsc (fast; UP or synced SMP only) */
+#define VXTIME_TSCS	2	/* estimate MT based on rdtsc in a syscall with locking */
+#define VXTIME_TSCM	3	/* estimate MT based on rdtsc in a syscall, ensure monotonicity */
+#define VXTIME_TSCP	4	/* estimate MT with the help of rdtscp (fast) */
+#define VXTIME_MT	5	/* read the MT, don't estimate (slowest) */
+
+#define VXTIME_TSC_INVALID	0x1
+#define VXTIME_TSC_CPUFREQ	0x2
 
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
 
 struct vxtime_data {
+	union {
+		struct {
+			u64 tsc_slope;		/* TSC to MT coefficient */
+			u64 tsc_slope_avg;	/* average tsc_slope */
+			u64 mt_base;		/* approximated MT at the last LAPIC tick */
+			u64 mt_last;		/* MT at the last LAPIC tick */
+			u64 tsc_last;		/* TSC at the last LAPIC tick */
+			u64 last_mt_guess;	/* ensures monotonicity in temporary MT mode */
+			char tsc_invalid;	/* don't trust the TSC now (frequency changing) */
+		};
+		char pad[64];	/* cacheline alignment */
+	} cpu[NR_CPUS];
 	long hpet_address;	/* HPET base address */
-	int last;
-	unsigned long last_tsc;
-	long quot;
-	long tsc_quot;
+	u64 mt_q;		/* master timer to nsec quotient */
+	u64 mt_wall;		/* MT ticks already covered by the jiffies */
+	s64 ns_drift;		/* MT - xtime drift in the last tick in ns */
 	int mode;
 };
+#define VSYSCALL_MAPPED_PAGES (1 + (sizeof(struct vxtime_data) + 4095) / 4096)
+
+#define TSC_SLOPE_SCALE	32
 
 #define hpet_readl(a)           readl((const void __iomem *)fix_to_virt(FIX_HPET_BASE) + a)
 #define hpet_writel(d,a)        writel(d, (void __iomem *)fix_to_virt(FIX_HPET_BASE) + a)
Index: linux-2.6.20-rc5/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.20-rc5.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux-2.6.20-rc5/arch/x86_64/kernel/vmlinux.lds.S
@@ -87,13 +87,13 @@ SECTIONS
   .vsyscall_0 :	 AT(VSYSCALL_PHYS_ADDR) { *(.vsyscall_0) } :user
   __vsyscall_0 = VSYSCALL_VIRT_ADDR;
 
+  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) { *(.vsyscall_1) }
+  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) { *(.vsyscall_2) }
+  .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) { *(.vsyscall_3) }
   . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
   .xtime_lock : AT(VLOAD(.xtime_lock)) { *(.xtime_lock) }
   xtime_lock = VVIRT(.xtime_lock);
 
-  .vxtime : AT(VLOAD(.vxtime)) { *(.vxtime) }
-  vxtime = VVIRT(.vxtime);
-
   .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { *(.vgetcpu_mode) }
   vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
@@ -110,11 +110,15 @@ SECTIONS
   .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
   jiffies = VVIRT(.jiffies);
 
-  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) { *(.vsyscall_1) }
-  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) { *(.vsyscall_2) }
-  .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) { *(.vsyscall_3) }
+  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+
+  . = ALIGN(4096);
+
+  .vxtime : AT(VLOAD(.vxtime)) { *(.vxtime) }
+  vxtime = VVIRT(.vxtime);
+
+  . = (VSYSCALL_VIRT_ADDR + 4096 + (CONFIG_NR_CPUS * 64 + 40 + 4095)) & ~(4095);
 
-  . = VSYSCALL_VIRT_ADDR + 4096;
 
 #undef VSYSCALL_ADDR
 #undef VSYSCALL_PHYS_ADDR

--
