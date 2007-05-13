Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbXEMUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbXEMUid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXEMUi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:38:27 -0400
Received: from kanga.kvack.org ([66.96.29.28]:57653 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbXEMUi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:38:26 -0400
Date: Sun, 13 May 2007 16:38:16 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <76306.1226@compuserve.com>
Subject: oprofile broken in 2.6.21 SMP (was Re: Remove constructor from buffer_head)
Message-ID: <20070513203816.GI30571@kvack.org>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com> <20070504134212.c18d2d65.akpm@linux-foundation.org> <20070504143347.9a1d6a34.akpm@linux-foundation.org> <200705050122.05275.ak@suse.de> <20070504164529.f64a2985.akpm@linux-foundation.org> <20070505093119.GC26000@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505093119.GC26000@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 11:31:20AM +0200, Andi Kleen wrote:
> Hmm, after a opcontrol --reset i see the same issue now. Don't know what's 
> wrong, but it must be something different from the .20 perfctr allocation
> problem.
> 
> It looks like the daemon doesn't get any data from the kernel

I finally had time to track this down.  The breakage is caused by "[PATCH] 
x86-64: Let oprofile reserve MSR on all CPUs".  Oprofile is already calling 
the reserve functions on each CPU in the system when it sets up the MSRs.  
This results in oprofile getting a reservation failure on CPUs above 0.  The 
following makes oprofile adapt to the API change for now -- oprofile 
still needs to be modified to perform the reservations earlier during its 
initialization, but that's a little bit more involved than the immediate 
bug fix.  This only affects systems with more than 1 CPU.  This patch has 
been through limited testing (Athlon 64 X2 and Core 2, but not on the P4) on 
x86 and x86-64 (Core 2 only).

		-ben

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
index 84c3497..21fc74d 100644
--- a/arch/i386/kernel/nmi.c
+++ b/arch/i386/kernel/nmi.c
@@ -148,7 +148,7 @@ int avail_to_resrv_perfctr_nmi(unsigned int msr)
 	return 1;
 }
 
-static int __reserve_perfctr_nmi(int cpu, unsigned int msr)
+int __reserve_perfctr_nmi(int cpu, unsigned int msr)
 {
 	unsigned int counter;
 	if (cpu < 0)
@@ -162,7 +162,7 @@ static int __reserve_perfctr_nmi(int cpu, unsigned int msr)
 	return 0;
 }
 
-static void __release_perfctr_nmi(int cpu, unsigned int msr)
+void __release_perfctr_nmi(int cpu, unsigned int msr)
 {
 	unsigned int counter;
 	if (cpu < 0)
@@ -212,7 +212,7 @@ int __reserve_evntsel_nmi(int cpu, unsigned int msr)
 	return 0;
 }
 
-static void __release_evntsel_nmi(int cpu, unsigned int msr)
+void __release_evntsel_nmi(int cpu, unsigned int msr)
 {
 	unsigned int counter;
 	if (cpu < 0)
@@ -1188,5 +1188,9 @@ EXPORT_SYMBOL(reserve_perfctr_nmi);
 EXPORT_SYMBOL(release_perfctr_nmi);
 EXPORT_SYMBOL(reserve_evntsel_nmi);
 EXPORT_SYMBOL(release_evntsel_nmi);
+EXPORT_SYMBOL(__reserve_perfctr_nmi);
+EXPORT_SYMBOL(__release_perfctr_nmi);
+EXPORT_SYMBOL(__reserve_evntsel_nmi);
+EXPORT_SYMBOL(__release_evntsel_nmi);
 EXPORT_SYMBOL(disable_timer_nmi_watchdog);
 EXPORT_SYMBOL(enable_timer_nmi_watchdog);
diff --git a/arch/i386/oprofile/op_model_athlon.c b/arch/i386/oprofile/op_model_athlon.c
index 3057a19..738a579 100644
--- a/arch/i386/oprofile/op_model_athlon.c
+++ b/arch/i386/oprofile/op_model_athlon.c
@@ -45,14 +45,14 @@ static void athlon_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i=0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+		if (__reserve_perfctr_nmi(-1, MSR_K7_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
 		else
 			msrs->counters[i].addr = 0;
 	}
 
 	for (i=0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
+		if (__reserve_evntsel_nmi(-1, MSR_K7_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
 		else
 			msrs->controls[i].addr = 0;
@@ -160,11 +160,11 @@ static void athlon_shutdown(struct op_msrs const * const msrs)
 
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (CTR_IS_RESERVED(msrs,i))
-			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+			__release_perfctr_nmi(-1, MSR_K7_PERFCTR0 + i);
 	}
 	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
 		if (CTRL_IS_RESERVED(msrs,i))
-			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+			__release_evntsel_nmi(-1, MSR_K7_EVNTSEL0 + i);
 	}
 }
 
diff --git a/arch/i386/oprofile/op_model_p4.c b/arch/i386/oprofile/op_model_p4.c
index 4792592..ce096dc 100644
--- a/arch/i386/oprofile/op_model_p4.c
+++ b/arch/i386/oprofile/op_model_p4.c
@@ -413,7 +413,7 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		addr = p4_counters[VIRT_CTR(stag, i)].counter_address;
 		cccraddr = p4_counters[VIRT_CTR(stag, i)].cccr_address;
-		if (reserve_perfctr_nmi(addr)){
+		if (__reserve_perfctr_nmi(-1, addr)){
 			msrs->counters[i].addr = addr;
 			msrs->controls[i].addr = cccraddr;
 		}
@@ -422,7 +422,7 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 	/* 43 ESCR registers in three or four discontiguous group */
 	for (addr = MSR_P4_BSU_ESCR0 + stag;
 	     addr < MSR_P4_IQ_ESCR0; ++i, addr += addr_increment()) {
-		if (reserve_evntsel_nmi(addr))
+		if (__reserve_evntsel_nmi(-1, addr))
 			msrs->controls[i].addr = addr;
 	}
 
@@ -431,32 +431,32 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 	if (boot_cpu_data.x86_model >= 0x3) {
 		for (addr = MSR_P4_BSU_ESCR0 + stag;
 		     addr <= MSR_P4_BSU_ESCR1; ++i, addr += addr_increment()) {
-			if (reserve_evntsel_nmi(addr))
+			if (__reserve_evntsel_nmi(-1, addr))
 				msrs->controls[i].addr = addr;
 		}
 	} else {
 		for (addr = MSR_P4_IQ_ESCR0 + stag;
 		     addr <= MSR_P4_IQ_ESCR1; ++i, addr += addr_increment()) {
-			if (reserve_evntsel_nmi(addr))
+			if (__reserve_evntsel_nmi(-1, addr))
 				msrs->controls[i].addr = addr;
 		}
 	}
 
 	for (addr = MSR_P4_RAT_ESCR0 + stag;
 	     addr <= MSR_P4_SSU_ESCR0; ++i, addr += addr_increment()) {
-		if (reserve_evntsel_nmi(addr))
+		if (__reserve_evntsel_nmi(-1, addr))
 			msrs->controls[i].addr = addr;
 	}
 	
 	for (addr = MSR_P4_MS_ESCR0 + stag;
 	     addr <= MSR_P4_TC_ESCR1; ++i, addr += addr_increment()) { 
-		if (reserve_evntsel_nmi(addr))
+		if (__reserve_evntsel_nmi(-1, addr))
 			msrs->controls[i].addr = addr;
 	}
 	
 	for (addr = MSR_P4_IX_ESCR0 + stag;
 	     addr <= MSR_P4_CRU_ESCR3; ++i, addr += addr_increment()) { 
-		if (reserve_evntsel_nmi(addr))
+		if (__reserve_evntsel_nmi(-1, addr))
 			msrs->controls[i].addr = addr;
 	}
 
@@ -464,21 +464,21 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 
 	if (num_counters == NUM_COUNTERS_NON_HT) {		
 		/* standard non-HT CPUs handle both remaining ESCRs*/
-		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR5))
+		if (__reserve_evntsel_nmi(-1, MSR_P4_CRU_ESCR5))
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
-		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR4))
+		if (__reserve_evntsel_nmi(-1, MSR_P4_CRU_ESCR4))
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR4;
 
 	} else if (stag == 0) {
 		/* HT CPUs give the first remainder to the even thread, as
 		   the 32nd control register */
-		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR4))
+		if (__reserve_evntsel_nmi(-1, MSR_P4_CRU_ESCR4))
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR4;
 
 	} else {
 		/* and two copies of the second to the odd thread,
 		   for the 22st and 23nd control registers */
-		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR5)) {
+		if (__reserve_evntsel_nmi(-1, MSR_P4_CRU_ESCR5)) {
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
 		}
@@ -684,7 +684,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 
 	for (i = 0 ; i < num_counters ; ++i) {
 		if (CTR_IS_RESERVED(msrs,i))
-			release_perfctr_nmi(msrs->counters[i].addr);
+			__release_perfctr_nmi(-1, msrs->counters[i].addr);
 	}
 	/* some of the control registers are specially reserved in
 	 * conjunction with the counter registers (hence the starting offset).
@@ -692,7 +692,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	 */
 	for (i = num_counters ; i < num_controls ; ++i) {
 		if (CTRL_IS_RESERVED(msrs,i))
-			release_evntsel_nmi(msrs->controls[i].addr);
+			__release_evntsel_nmi(-1, msrs->controls[i].addr);
 	}
 }
 
diff --git a/arch/i386/oprofile/op_model_ppro.c b/arch/i386/oprofile/op_model_ppro.c
index c554f52..10d2c5d 100644
--- a/arch/i386/oprofile/op_model_ppro.c
+++ b/arch/i386/oprofile/op_model_ppro.c
@@ -47,14 +47,14 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i=0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
+		if (__reserve_perfctr_nmi(-1, MSR_P6_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
 		else
 			msrs->counters[i].addr = 0;
 	}
 	
 	for (i=0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
+		if (__reserve_evntsel_nmi(-1, MSR_P6_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
 		else
 			msrs->controls[i].addr = 0;
@@ -171,11 +171,11 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (CTR_IS_RESERVED(msrs,i))
-			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
+			__release_perfctr_nmi(-1, MSR_P6_PERFCTR0 + i);
 	}
 	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
 		if (CTRL_IS_RESERVED(msrs,i))
-			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
+			__release_evntsel_nmi(-1, MSR_P6_EVNTSEL0 + i);
 	}
 }
 
diff --git a/arch/x86_64/kernel/nmi.c b/arch/x86_64/kernel/nmi.c
index dfab9f1..5011a3b 100644
--- a/arch/x86_64/kernel/nmi.c
+++ b/arch/x86_64/kernel/nmi.c
@@ -135,7 +135,7 @@ int avail_to_resrv_perfctr_nmi(unsigned int msr)
 	return 1;
 }
 
-static int __reserve_perfctr_nmi(int cpu, unsigned int msr)
+int __reserve_perfctr_nmi(int cpu, unsigned int msr)
 {
 	unsigned int counter;
 	if (cpu < 0)
@@ -149,7 +149,7 @@ static int __reserve_perfctr_nmi(int cpu, unsigned int msr)
 	return 0;
 }
 
-static void __release_perfctr_nmi(int cpu, unsigned int msr)
+void __release_perfctr_nmi(int cpu, unsigned int msr)
 {
 	unsigned int counter;
 	if (cpu < 0)
@@ -198,7 +198,7 @@ int __reserve_evntsel_nmi(int cpu, unsigned int msr)
 	return 0;
 }
 
-static void __release_evntsel_nmi(int cpu, unsigned int msr)
+void __release_evntsel_nmi(int cpu, unsigned int msr)
 {
 	unsigned int counter;
 	if (cpu < 0)
@@ -1073,6 +1073,10 @@ EXPORT_SYMBOL(reserve_perfctr_nmi);
 EXPORT_SYMBOL(release_perfctr_nmi);
 EXPORT_SYMBOL(reserve_evntsel_nmi);
 EXPORT_SYMBOL(release_evntsel_nmi);
+EXPORT_SYMBOL(__reserve_perfctr_nmi);
+EXPORT_SYMBOL(__release_perfctr_nmi);
+EXPORT_SYMBOL(__reserve_evntsel_nmi);
+EXPORT_SYMBOL(__release_evntsel_nmi);
 EXPORT_SYMBOL(disable_timer_nmi_watchdog);
 EXPORT_SYMBOL(enable_timer_nmi_watchdog);
 EXPORT_SYMBOL(touch_nmi_watchdog);
diff --git a/include/asm-i386/nmi.h b/include/asm-i386/nmi.h
index b04333e..062db4d 100644
--- a/include/asm-i386/nmi.h
+++ b/include/asm-i386/nmi.h
@@ -25,6 +25,11 @@ extern void release_perfctr_nmi(unsigned int);
 extern int reserve_evntsel_nmi(unsigned int);
 extern void release_evntsel_nmi(unsigned int);
 
+extern int __reserve_perfctr_nmi(int cpu, unsigned int msr);
+extern void __release_perfctr_nmi(int cpu, unsigned int msr);
+extern int __reserve_evntsel_nmi(int cpu, unsigned int msr);
+extern void __release_evntsel_nmi(int cpu, unsigned int msr);
+
 extern void setup_apic_nmi_watchdog (void *);
 extern void stop_apic_nmi_watchdog (void *);
 extern void disable_timer_nmi_watchdog(void);
diff --git a/include/asm-x86_64/nmi.h b/include/asm-x86_64/nmi.h
index 72375e7..5d6a0b3 100644
--- a/include/asm-x86_64/nmi.h
+++ b/include/asm-x86_64/nmi.h
@@ -53,6 +53,11 @@ extern void release_perfctr_nmi(unsigned int);
 extern int reserve_evntsel_nmi(unsigned int);
 extern void release_evntsel_nmi(unsigned int);
 
+extern int __reserve_perfctr_nmi(int cpu, unsigned int msr);
+extern void __release_perfctr_nmi(int cpu, unsigned int msr);
+extern int __reserve_evntsel_nmi(int cpu, unsigned int msr);
+extern void __release_evntsel_nmi(int cpu, unsigned int msr);
+
 extern void setup_apic_nmi_watchdog (void *);
 extern void stop_apic_nmi_watchdog (void *);
 extern void disable_timer_nmi_watchdog(void);
