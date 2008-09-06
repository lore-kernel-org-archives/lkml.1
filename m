Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYIFXxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYIFXxp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYIFXut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54636 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753080AbYIFXuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235037.744732000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:42 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 06/13] genapic: use get_cpumask_var operations for allbutself cpumask_ts
Content-Disposition: inline; filename=add-percpu-allbutself
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Adds a global allbutself PER_CPUMASK variable and modifies functions
    that create a temp cpumask variable for the following procedure:

	cpumask_t mask = cpu_online_map;
 
	cpu_clear(smp_processor_id(), mask);
 
	if (!cpus_empty(mask))
		XXX_send_IPI_mask(&mask, vector);

    This then becomes:

	cpumask_ptr mask;
 
	get_cpumask_var(mask, allbutself);
	*mask = cpu_online_map;
	cpu_clear(smp_processor_id(), *mask);
 
	if (!cpus_empty(*mask))
		XXX_send_IPI_mask(mask, vector);

	put_cpumask_var(mask, allbutself);

  * Note: this "allbutself" per_cpumask variable could be pre-built during
    system startup saving execution time, but would require that all the
    per_cpumask variables are updated whenever a cpu goes off- or on-line.


Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic.c                  |    3 +++
 arch/x86/kernel/genapic_flat_64.c       |   26 +++++++++++++++++++-------
 arch/x86/kernel/genx2apic_cluster.c     |   13 +++++++++----
 arch/x86/kernel/genx2apic_uv_x.c        |   13 +++++++++----
 arch/x86/kernel/smp.c                   |   28 ++++++++++++++++++++++++----
 include/asm-x86/genapic_32.h            |    2 ++
 include/asm-x86/genapic_64.h            |    4 ++++
 include/asm-x86/mach-default/mach_ipi.h |   14 ++++++++++----
 8 files changed, 80 insertions(+), 23 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/apic.c
+++ linux-2.6.tip/arch/x86/kernel/apic.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/dmar.h>
+#include <linux/cpumask_ptr.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -162,6 +163,8 @@ static DEFINE_PER_CPU(struct clock_event
 
 static unsigned long apic_phys;
 
+DEFINE_PER_CPUMASK(allbutself);
+
 /*
  * Get the LAPIC version
  */
--- linux-2.6.tip.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6.tip/arch/x86/kernel/genapic_flat_64.c
@@ -11,6 +11,7 @@
 #include <linux/errno.h>
 #include <linux/threads.h>
 #include <linux/cpumask.h>
+#include <linux/cpumask_ptr.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
@@ -87,12 +88,17 @@ static void flat_send_IPI_allbutself(int
 	int hotplug = 0;
 #endif
 	if (hotplug || vector == NMI_VECTOR) {
-		cpumask_t allbutme = cpu_online_map;
+		cpumask_ptr mask;
 
-		cpu_clear(smp_processor_id(), allbutme);
+		get_cpumask_var(mask, allbutself);
+		*mask = cpu_online_map;
+		cpu_clear(smp_processor_id(), *mask);
+
+		if (!cpus_empty(*mask))
+			flat_send_IPI_mask(mask, vector);
+
+		put_cpumask_var(mask, allbutself);
 
-		if (!cpus_empty(allbutme))
-			flat_send_IPI_mask(&allbutme, vector);
 	} else if (num_online_cpus() > 1) {
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector,APIC_DEST_LOGICAL);
 	}
@@ -205,10 +211,16 @@ static void physflat_send_IPI_mask(const
 
 static void physflat_send_IPI_allbutself(int vector)
 {
-	cpumask_t allbutme = cpu_online_map;
+	cpumask_ptr mask;
+
+	get_cpumask_var(mask, allbutself);
+	*mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), *mask);
+
+	if (!cpus_empty(*mask))
+		physflat_send_IPI_mask(mask, vector);
 
-	cpu_clear(smp_processor_id(), allbutme);
-	physflat_send_IPI_mask(&allbutme, vector);
+	put_cpumask_var(mask, allbutself);
 }
 
 static void physflat_send_IPI_all(int vector)
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_cluster.c
@@ -1,5 +1,6 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
+#include <linux/cpumask_ptr.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
@@ -71,12 +72,16 @@ static void x2apic_send_IPI_mask(const c
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
+	cpumask_ptr mask;
 
-	cpu_clear(smp_processor_id(), mask);
+	get_cpumask_var(mask, allbutself);
+	*mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), *mask);
 
-	if (!cpus_empty(mask))
-		x2apic_send_IPI_mask(&mask, vector);
+	if (!cpus_empty(*mask))
+		x2apic_send_IPI_mask(mask, vector);
+
+	put_cpumask_var(mask, allbutself);
 }
 
 static void x2apic_send_IPI_all(int vector)
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/cpumask.h>
+#include <linux/cpumask_ptr.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -135,12 +136,16 @@ static void uv_send_IPI_mask(const cpuma
 
 static void uv_send_IPI_allbutself(int vector)
 {
-	cpumask_t mask = cpu_online_map;
+	cpumask_ptr mask;
 
-	cpu_clear(smp_processor_id(), mask);
+	get_cpumask_var(mask, allbutself);
+	*mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), *mask);
 
-	if (!cpus_empty(mask))
-		uv_send_IPI_mask(&mask, vector);
+	if (!cpus_empty(*mask))
+		uv_send_IPI_mask(mask, vector);
+
+	put_cpumask_var(mask, allbutself);
 }
 
 static void uv_send_IPI_all(int vector)
--- linux-2.6.tip.orig/arch/x86/kernel/smp.c
+++ linux-2.6.tip/arch/x86/kernel/smp.c
@@ -21,6 +21,7 @@
 #include <linux/cache.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
+#include <linux/cpumask_ptr.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -128,16 +129,35 @@ void native_send_call_func_single_ipi(in
 
 void native_send_call_func_ipi(const cpumask_t *mask)
 {
-	cpumask_t allbutself;
 
-	allbutself = cpu_online_map;
-	cpu_clear(smp_processor_id(), allbutself);
+#ifndef	ARCH_DOES_NOT_HAVE_ALLBUTSELF_IPI_CALL
+	/*
+	 * Can't use global "allbutself" because many of the
+	 * genapic->send_IPI_allbutself functions use it to
+	 * expand to a mask to send to each cpu as they do not
+	 * have a single IPI call to send to "allbutself".
+	 *
+	 * This is here only for the small count NR_CPUS that actually
+	 * have one of those handy functions.
+	 *
+	 * There might be an ifdef I could use to short-circuit this out...?
+	 */
+	static DEFINE_PER_CPUMASK(smp_temp_cpumask);
+	cpumask_ptr allbutself;
+
+	get_cpumask_var(allbutself, smp_temp_cpumask);
+	*allbutself = cpu_online_map;
+	cpu_clear(smp_processor_id(), *allbutself);
 
-	if (cpus_equal(*mask, allbutself) &&
+	if (cpus_equal(*mask, *allbutself) &&
 	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
 		send_IPI_mask(*mask, CALL_FUNCTION_VECTOR);
+	put_cpumask_var(allbutself, smp_temp_cpumask);
+#else
+	send_IPI_mask(*mask, CALL_FUNCTION_VECTOR);
+#endif
 }
 
 static void stop_this_cpu(void *dummy)
--- linux-2.6.tip.orig/include/asm-x86/genapic_32.h
+++ linux-2.6.tip/include/asm-x86/genapic_32.h
@@ -2,6 +2,7 @@
 #define ASM_X86__GENAPIC_32_H
 
 #include <asm/mpspec.h>
+#include <linux/cpumask_ptr.h>
 
 /*
  * Generic APIC driver interface.
@@ -122,5 +123,6 @@ enum uv_system_type {UV_NONE, UV_LEGACY_
 #define uv_wakeup_secondary(a, b)	1
 #define uv_system_init()		do {} while (0)
 
+DECLARE_PER_CPUMASK(allbutself);
 
 #endif /* ASM_X86__GENAPIC_32_H */
--- linux-2.6.tip.orig/include/asm-x86/genapic_64.h
+++ linux-2.6.tip/include/asm-x86/genapic_64.h
@@ -1,6 +1,8 @@
 #ifndef ASM_X86__GENAPIC_64_H
 #define ASM_X86__GENAPIC_64_H
 
+#include <linux/cpumask_ptr.h>
+
 /*
  * Copyright 2004 James Cleverdon, IBM.
  * Subject to the GNU Public License, v.2
@@ -55,4 +57,6 @@ extern int uv_wakeup_secondary(int phys_
 
 extern void setup_apic_routing(void);
 
+DECLARE_PER_CPUMASK(allbutself);
+
 #endif /* ASM_X86__GENAPIC_64_H */
--- linux-2.6.tip.orig/include/asm-x86/mach-default/mach_ipi.h
+++ linux-2.6.tip/include/asm-x86/mach-default/mach_ipi.h
@@ -1,6 +1,8 @@
 #ifndef ASM_X86__MACH_DEFAULT__MACH_IPI_H
 #define ASM_X86__MACH_DEFAULT__MACH_IPI_H
 
+#include <linux/cpumask_ptr.h>
+
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
 
@@ -9,8 +11,9 @@ void __send_IPI_shortcut(unsigned int sh
 
 extern int no_broadcast;
 
-#ifdef CONFIG_X86_64
 #include <asm/genapic.h>
+
+#ifdef CONFIG_X86_64
 #define send_IPI_mask(mask, vector) (genapic->send_IPI_mask)(&(mask), vector)
 #else
 static inline void send_IPI_mask(cpumask_t mask, int vector)
@@ -22,10 +25,13 @@ static inline void send_IPI_mask(cpumask
 static inline void __local_send_IPI_allbutself(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR) {
-		cpumask_t mask = cpu_online_map;
+		cpumask_ptr mask;
 
-		cpu_clear(smp_processor_id(), mask);
-		send_IPI_mask(mask, vector);
+		get_cpumask_var(mask, allbutself);
+		*mask = cpu_online_map;
+		cpu_clear(smp_processor_id(), *mask);
+		send_IPI_mask(*mask, vector);
+		put_cpumask_var(mask, allbutself);
 	} else
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
 }

-- 
