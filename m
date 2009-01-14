Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbZANOfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbZANOfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbZANOf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:35:29 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:52200 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbZANOf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:35:28 -0500
Date: Wed, 14 Jan 2009 17:35:38 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] alpha: fix RTC on marvel
Message-ID: <20090114143538.GD10788@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike other alphas, marvel doesn't have real PC-style CMOS clock
hardware - RTC accesses are emulated via PAL calls. Unfortunately,
for unknown reason these calls work only on CPU #0. So current
implementation for arbitrary CPU makes CMOS_READ/WRITE to be
executed on CPU #0 via IPI. However, for obvious reason this
doesn't work with standard get/set_rtc_time() functions,
where a bunch of CMOS accesses is done with disabled interrupts.

Solved by making the IPI calls for entire get/set_rtc_time()
functions, not for individual CMOS accesses. Which is also
a lot more effective performance-wise.

The patch is largely based on the code from Jay Estabrook.
My changes:
- tweak asm-generic/rtc.h by adding a couple of #defines to
  avoid a massive code duplication in arch/alpha/include/asm/rtc.h;
- sys_marvel.c: fix get/set_rtc_time() return values (Jay's FIXMEs).

NOTE: this fixes *only* LIB_RTC drivers. Legacy (CONFIG_RTC) driver
wont't work on marvel. Actually I think that we should just disable
CONFIG_RTC on alpha (maybe in 2.6.30?), like most other arches -
AFAIK, all modern distributions use LIB_RTC anyway.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/include/asm/machvec.h |    4 +++
 arch/alpha/include/asm/rtc.h     |   12 ++++++--
 arch/alpha/kernel/core_marvel.c  |   10 +------
 arch/alpha/kernel/machvec_impl.h |    5 +++-
 arch/alpha/kernel/proto.h        |    2 +
 arch/alpha/kernel/sys_jensen.c   |    2 +
 arch/alpha/kernel/sys_marvel.c   |   56 +++++++++++++++++++++++++++++++++++++-
 arch/alpha/kernel/time.c         |   10 +++++++
 include/asm-generic/rtc.h        |   14 +++++++--
 9 files changed, 98 insertions(+), 17 deletions(-)

diff --git a/arch/alpha/include/asm/machvec.h b/arch/alpha/include/asm/machvec.h
index a86c083..fea4ea7 100644
--- a/arch/alpha/include/asm/machvec.h
+++ b/arch/alpha/include/asm/machvec.h
@@ -21,6 +21,7 @@ struct pci_dev;
 struct pci_ops;
 struct pci_controller;
 struct _alpha_agp_info;
+struct rtc_time;
 
 struct alpha_machine_vector
 {
@@ -94,6 +95,9 @@ struct alpha_machine_vector
 
 	struct _alpha_agp_info *(*agp_info)(void);
 
+	unsigned int (*rtc_get_time)(struct rtc_time *);
+	int (*rtc_set_time)(struct rtc_time *);
+
 	const char *vector_name;
 
 	/* NUMA information */
diff --git a/arch/alpha/include/asm/rtc.h b/arch/alpha/include/asm/rtc.h
index 4e854b1..1f7fba6 100644
--- a/arch/alpha/include/asm/rtc.h
+++ b/arch/alpha/include/asm/rtc.h
@@ -1,9 +1,15 @@
 #ifndef _ALPHA_RTC_H
 #define _ALPHA_RTC_H
 
-/*
- * Alpha uses the default access methods for the RTC.
- */
+#if defined(CONFIG_ALPHA_GENERIC)
+# define get_rtc_time		alpha_mv.rtc_get_time
+# define set_rtc_time		alpha_mv.rtc_set_time
+#else
+# if defined(CONFIG_ALPHA_MARVEL) && defined(CONFIG_SMP)
+#  define get_rtc_time		marvel_get_rtc_time
+#  define set_rtc_time		marvel_set_rtc_time
+# endif
+#endif
 
 #include <asm-generic/rtc.h>
 
diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index 9cd8dca..e302dae 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -658,16 +658,8 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 		rtc_access.data = bcd2bin(b);
 		rtc_access.function = 0x48 + !write;	/* GET/PUT_TOY */
 
-#ifdef CONFIG_SMP
-		if (smp_processor_id() != boot_cpuid)
-			smp_call_function_single(boot_cpuid,
-						 __marvel_access_rtc,
-						 &rtc_access, 1);
-		else
-			__marvel_access_rtc(&rtc_access);
-#else
 		__marvel_access_rtc(&rtc_access);
-#endif
+
 		ret = bin2bcd(rtc_access.data);
 		break;
 
diff --git a/arch/alpha/kernel/machvec_impl.h b/arch/alpha/kernel/machvec_impl.h
index 466c9df..512685f 100644
--- a/arch/alpha/kernel/machvec_impl.h
+++ b/arch/alpha/kernel/machvec_impl.h
@@ -40,7 +40,10 @@
 #define CAT1(x,y)  x##y
 #define CAT(x,y)   CAT1(x,y)
 
-#define DO_DEFAULT_RTC .rtc_port = 0x70
+#define DO_DEFAULT_RTC \
+	.rtc_port = 0x70, \
+	.rtc_get_time = common_get_rtc_time, \
+	.rtc_set_time = common_set_rtc_time
 
 #define DO_EV4_MMU							\
 	.max_asn =			EV4_MAX_ASN,			\
diff --git a/arch/alpha/kernel/proto.h b/arch/alpha/kernel/proto.h
index 708d5ca..fe14c67 100644
--- a/arch/alpha/kernel/proto.h
+++ b/arch/alpha/kernel/proto.h
@@ -145,6 +145,8 @@ extern void smp_percpu_timer_interrupt(struct pt_regs *);
 extern irqreturn_t timer_interrupt(int irq, void *dev);
 extern void common_init_rtc(void);
 extern unsigned long est_cycle_freq;
+extern unsigned int common_get_rtc_time(struct rtc_time *time);
+extern int common_set_rtc_time(struct rtc_time *time);
 
 /* smc37c93x.c */
 extern void SMC93x_Init(void);
diff --git a/arch/alpha/kernel/sys_jensen.c b/arch/alpha/kernel/sys_jensen.c
index 2c3de97..e2516f9 100644
--- a/arch/alpha/kernel/sys_jensen.c
+++ b/arch/alpha/kernel/sys_jensen.c
@@ -261,6 +261,8 @@ struct alpha_machine_vector jensen_mv __initmv = {
 	.machine_check		= jensen_machine_check,
 	.max_isa_dma_address	= ALPHA_MAX_ISA_DMA_ADDRESS,
 	.rtc_port		= 0x170,
+	.rtc_get_time		= common_get_rtc_time,
+	.rtc_set_time		= common_set_rtc_time,
 
 	.nr_irqs		= 16,
 	.device_interrupt	= jensen_device_interrupt,
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 828449c..c5a1a24 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -23,6 +23,7 @@
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
 #include <asm/vga.h>
+#include <asm/rtc.h>
 
 #include "proto.h"
 #include "err_impl.h"
@@ -426,6 +427,57 @@ marvel_init_rtc(void)
 	init_rtc_irq();
 }
 
+struct marvel_rtc_time {
+	struct rtc_time *time;
+	int retval;
+};
+
+#ifdef CONFIG_SMP
+static void
+smp_get_rtc_time(void *data)
+{
+	struct marvel_rtc_time *mrt = data;
+	mrt->retval = __get_rtc_time(mrt->time);
+}
+
+static void
+smp_set_rtc_time(void *data)
+{
+	struct marvel_rtc_time *mrt = data;
+	mrt->retval = __set_rtc_time(mrt->time);
+}
+#endif
+
+static unsigned int
+marvel_get_rtc_time(struct rtc_time *time)
+{
+#ifdef CONFIG_SMP
+	struct marvel_rtc_time mrt;
+
+	if (smp_processor_id() != boot_cpuid) {
+		mrt.time = time;
+		smp_call_function_single(boot_cpuid, smp_get_rtc_time, &mrt, 1);
+		return mrt.retval;
+	}
+#endif
+	return __get_rtc_time(time);
+}
+
+static int
+marvel_set_rtc_time(struct rtc_time *time)
+{
+#ifdef CONFIG_SMP
+	struct marvel_rtc_time mrt;
+
+	if (smp_processor_id() != boot_cpuid) {
+		mrt.time = time;
+		smp_call_function_single(boot_cpuid, smp_set_rtc_time, &mrt, 1);
+		return mrt.retval;
+	}
+#endif
+	return __set_rtc_time(time);
+}
+
 static void
 marvel_smp_callin(void)
 {
@@ -466,7 +518,9 @@ marvel_smp_callin(void)
 struct alpha_machine_vector marvel_ev7_mv __initmv = {
 	.vector_name		= "MARVEL/EV7",
 	DO_EV7_MMU,
-	DO_DEFAULT_RTC,
+	.rtc_port		= 0x70,
+	.rtc_get_time		= marvel_get_rtc_time,
+	.rtc_set_time		= marvel_set_rtc_time,
 	DO_MARVEL_IO,
 	.machine_check		= marvel_machine_check,
 	.max_isa_dma_address	= ALPHA_MAX_ISA_DMA_ADDRESS,
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index e6a2314..b04e2cb 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -46,6 +46,7 @@
 #include <asm/io.h>
 #include <asm/hwrpb.h>
 #include <asm/8253pit.h>
+#include <asm/rtc.h>
 
 #include <linux/mc146818rtc.h>
 #include <linux/time.h>
@@ -180,6 +181,15 @@ common_init_rtc(void)
 	init_rtc_irq();
 }
 
+unsigned int common_get_rtc_time(struct rtc_time *time)
+{
+	return __get_rtc_time(time);
+}
+
+int common_set_rtc_time(struct rtc_time *time)
+{
+	return __set_rtc_time(time);
+}
 
 /* Validate a computed cycle counter result against the known bounds for
    the given processor core.  There's too much brokenness in the way of
diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index 89061c1..763e3b0 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -42,7 +42,7 @@ static inline unsigned char rtc_is_updating(void)
 	return uip;
 }
 
-static inline unsigned int get_rtc_time(struct rtc_time *time)
+static inline unsigned int __get_rtc_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
@@ -108,8 +108,12 @@ static inline unsigned int get_rtc_time(struct rtc_time *time)
 	return RTC_24H;
 }
 
+#ifndef get_rtc_time
+#define get_rtc_time	__get_rtc_time
+#endif
+
 /* Set the current date and time in the real time clock. */
-static inline int set_rtc_time(struct rtc_time *time)
+static inline int __set_rtc_time(struct rtc_time *time)
 {
 	unsigned long flags;
 	unsigned char mon, day, hrs, min, sec;
@@ -190,11 +194,15 @@ static inline int set_rtc_time(struct rtc_time *time)
 	return 0;
 }
 
+#ifndef set_rtc_time
+#define set_rtc_time	__set_rtc_time
+#endif
+
 static inline unsigned int get_rtc_ss(void)
 {
 	struct rtc_time h;
 
-	get_rtc_time(&h);
+	__get_rtc_time(&h);
 	return h.tm_sec;
 }
 
