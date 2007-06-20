Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbXFTKgS (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 20 Jun 2007 06:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761052AbXFTKfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:35:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:40751 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758129AbXFTKft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:35:49 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19FuG9DlANFUAB1y6743T/D78UN2sHlxVX5/236jp
	MRleI9FWyt5fy+
From: =?utf-8?q?Bj=C3=B6rn=20Steinbrink?= <B.Steinbrink@gmx.de>
To: eranian@hpl.hp.com
Cc: oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
        perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
        levon@movementarian.org, akpm@linux-foundation.org, mingo@elte.hu,
        =?utf-8?q?Bj=C3=B6rn=20Steinbrink?= <B.Steinbrink@gmx.de>
Subject: [PATCH 2/2] Finish separation of the performance counter allocator from the NMI watchdog
Date: Wed, 20 Jun 2007 12:35:57 +0200
Message-Id: <11823357623688-git-send-email->
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11823357591180-git-send-email->
References: <20070618103214.GA12045@atjola.homenet>
 <11823357571842-git-send-email->
 <11823357591180-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Björn Steinbrink <B.Steinbrink@gmx.de>

Remove the nmi part from all names in the performance counter allocator
and move all declarations into their own header file.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
 arch/i386/kernel/apic.c                 |    1 +
 arch/i386/kernel/cpu/perfctr-watchdog.c |   27 +++++++-------
 arch/i386/kernel/cpu/perfctr.c          |   58 +++++++++++++++---------------
 arch/i386/oprofile/nmi_int.c            |    4 +-
 arch/i386/oprofile/op_model_athlon.c    |   10 +++---
 arch/i386/oprofile/op_model_p4.c        |   28 +++++++-------
 arch/i386/oprofile/op_model_ppro.c      |   10 +++---
 arch/x86_64/kernel/apic.c               |    1 +
 arch/x86_64/kernel/time.c               |   12 +++---
 include/asm-i386/nmi.h                  |    7 ----
 include/asm-i386/perfctr.h              |   15 ++++++++
 include/asm-x86_64/nmi.h                |    7 ----
 include/asm-x86_64/perfctr.h            |   15 ++++++++
 13 files changed, 107 insertions(+), 88 deletions(-)
 create mode 100644 include/asm-i386/perfctr.h
 create mode 100644 include/asm-x86_64/perfctr.h

diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
index 88b74e3..16a5140 100644
--- a/arch/i386/kernel/apic.c
+++ b/arch/i386/kernel/apic.c
@@ -38,6 +38,7 @@
 #include <asm/hpet.h>
 #include <asm/i8253.h>
 #include <asm/nmi.h>
+#include <asm/perfctr.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 2ae39eb..d8fabd2 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -13,6 +13,7 @@
 #include <linux/nmi.h>
 #include <asm/apic.h>
 #include <asm/intel_arch_perfmon.h>
+#include <asm/perfctr.h>
 
 struct nmi_watchdog_ctlblk {
 	unsigned int cccr_msr;
@@ -165,11 +166,11 @@ static void single_msr_stop_watchdog(void)
 
 static int single_msr_reserve(void)
 {
-	if (!reserve_perfctr_nmi(wd_ops->perfctr))
+	if (!reserve_perfctr(wd_ops->perfctr))
 		return 0;
 
-	if (!reserve_evntsel_nmi(wd_ops->evntsel)) {
-		release_perfctr_nmi(wd_ops->perfctr);
+	if (!reserve_evntsel(wd_ops->evntsel)) {
+		release_perfctr(wd_ops->perfctr);
 		return 0;
 	}
 	return 1;
@@ -177,8 +178,8 @@ static int single_msr_reserve(void)
 
 static void single_msr_unreserve(void)
 {
-	release_evntsel_nmi(wd_ops->evntsel);
-	release_perfctr_nmi(wd_ops->perfctr);
+	release_evntsel(wd_ops->evntsel);
+	release_perfctr(wd_ops->perfctr);
 }
 
 static void single_msr_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
@@ -352,23 +353,23 @@ static void stop_p4_watchdog(void)
 
 static int p4_reserve(void)
 {
-	if (!reserve_perfctr_nmi(MSR_P4_IQ_PERFCTR0))
+	if (!reserve_perfctr(MSR_P4_IQ_PERFCTR0))
 		return 0;
 #ifdef CONFIG_SMP
-	if (smp_num_siblings > 1 && !reserve_perfctr_nmi(MSR_P4_IQ_PERFCTR1))
+	if (smp_num_siblings > 1 && !reserve_perfctr(MSR_P4_IQ_PERFCTR1))
 		goto fail1;
 #endif
-	if (!reserve_evntsel_nmi(MSR_P4_CRU_ESCR0))
+	if (!reserve_evntsel(MSR_P4_CRU_ESCR0))
 		goto fail2;
 	/* RED-PEN why is ESCR1 not reserved here? */
 	return 1;
  fail2:
 #ifdef CONFIG_SMP
 	if (smp_num_siblings > 1)
-		release_perfctr_nmi(MSR_P4_IQ_PERFCTR1);
+		release_perfctr(MSR_P4_IQ_PERFCTR1);
  fail1:
 #endif
-	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
+	release_perfctr(MSR_P4_IQ_PERFCTR0);
 	return 0;
 }
 
@@ -376,10 +377,10 @@ static void p4_unreserve(void)
 {
 #ifdef CONFIG_SMP
 	if (smp_num_siblings > 1)
-		release_perfctr_nmi(MSR_P4_IQ_PERFCTR1);
+		release_perfctr(MSR_P4_IQ_PERFCTR1);
 #endif
-	release_evntsel_nmi(MSR_P4_CRU_ESCR0);
-	release_perfctr_nmi(MSR_P4_IQ_PERFCTR0);
+	release_evntsel(MSR_P4_CRU_ESCR0);
+	release_perfctr(MSR_P4_IQ_PERFCTR0);
 }
 
 static void p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
diff --git a/arch/i386/kernel/cpu/perfctr.c b/arch/i386/kernel/cpu/perfctr.c
index fece4fc..cbf57ce 100644
--- a/arch/i386/kernel/cpu/perfctr.c
+++ b/arch/i386/kernel/cpu/perfctr.c
@@ -35,14 +35,14 @@ static struct perfctr_base_regs arch_perfmon_base_regs = {
  */
 #define NMI_MAX_COUNTER_BITS 66
 
-/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
- * evtsel_nmi_owner tracks the ownership of the event selection
+/* perfctr_owner tracks the ownership of the perfctr registers:
+ * evtsel_owner tracks the ownership of the event selection
  * - different performance counters/ event selection may be reserved for
  *   different subsystems this reservation system just tries to coordinate
  *   things a little
  */
-static DECLARE_BITMAP(perfctr_nmi_owner, NMI_MAX_COUNTER_BITS);
-static DECLARE_BITMAP(evntsel_nmi_owner, NMI_MAX_COUNTER_BITS);
+static DECLARE_BITMAP(perfctr_owner, NMI_MAX_COUNTER_BITS);
+static DECLARE_BITMAP(evntsel_owner, NMI_MAX_COUNTER_BITS);
 
 void __devinit probe_performance_counters(void)
 {
@@ -77,102 +77,102 @@ void __devinit probe_performance_counters(void)
 }
 
 /* converts an msr to an appropriate reservation bit */
-static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
+static inline unsigned int perfctr_msr_to_bit(unsigned int msr)
 {
 	return msr - perfctr_base_regs->perfctr;
 }
 
 /* converts an msr to an appropriate reservation bit */
 /* returns the bit offset of the event selection register */
-static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
+static inline unsigned int evntsel_msr_to_bit(unsigned int msr)
 {
 	return msr - perfctr_base_regs->evntsel;
 }
 
 /* checks for a bit availability (hack for oprofile) */
-int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
+int avail_to_resrv_perfctr_bit(unsigned int counter)
 {
 	if (!perfctr_base_regs)
 		return 0;
 
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	return (!test_bit(counter, perfctr_nmi_owner));
+	return (!test_bit(counter, perfctr_owner));
 }
 
 /* checks the an msr for availability */
-int avail_to_resrv_perfctr_nmi(unsigned int msr)
+int avail_to_resrv_perfctr(unsigned int msr)
 {
 	unsigned int counter;
 
 	if (!perfctr_base_regs)
 		return 0;
 
-	counter = nmi_perfctr_msr_to_bit(msr);
+	counter = perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	return (!test_bit(counter, perfctr_nmi_owner));
+	return (!test_bit(counter, perfctr_owner));
 }
 
-int reserve_perfctr_nmi(unsigned int msr)
+int reserve_perfctr(unsigned int msr)
 {
 	unsigned int counter;
 
 	if (!perfctr_base_regs)
 		return 0;
 
-	counter = nmi_perfctr_msr_to_bit(msr);
+	counter = perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, perfctr_nmi_owner))
+	if (!test_and_set_bit(counter, perfctr_owner))
 		return 1;
 	return 0;
 }
 
-void release_perfctr_nmi(unsigned int msr)
+void release_perfctr(unsigned int msr)
 {
 	unsigned int counter;
 
 	if (!perfctr_base_regs)
 		return;
 
-	counter = nmi_perfctr_msr_to_bit(msr);
+	counter = perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, perfctr_nmi_owner);
+	clear_bit(counter, perfctr_owner);
 }
 
-int reserve_evntsel_nmi(unsigned int msr)
+int reserve_evntsel(unsigned int msr)
 {
 	unsigned int counter;
 
 	if (!perfctr_base_regs)
 		return 0;
 
-	counter = nmi_evntsel_msr_to_bit(msr);
+	counter = evntsel_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, evntsel_nmi_owner))
+	if (!test_and_set_bit(counter, evntsel_owner))
 		return 1;
 	return 0;
 }
 
-void release_evntsel_nmi(unsigned int msr)
+void release_evntsel(unsigned int msr)
 {
 	unsigned int counter;
 
 	if (!perfctr_base_regs)
 		return;
 
-	counter = nmi_evntsel_msr_to_bit(msr);
+	counter = evntsel_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, evntsel_nmi_owner);
+	clear_bit(counter, evntsel_owner);
 }
 
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
-EXPORT_SYMBOL(reserve_perfctr_nmi);
-EXPORT_SYMBOL(release_perfctr_nmi);
-EXPORT_SYMBOL(reserve_evntsel_nmi);
-EXPORT_SYMBOL(release_evntsel_nmi);
+EXPORT_SYMBOL(avail_to_resrv_perfctr);
+EXPORT_SYMBOL(avail_to_resrv_perfctr_bit);
+EXPORT_SYMBOL(reserve_perfctr);
+EXPORT_SYMBOL(release_perfctr);
+EXPORT_SYMBOL(reserve_evntsel);
+EXPORT_SYMBOL(release_evntsel);
diff --git a/arch/i386/oprofile/nmi_int.c b/arch/i386/oprofile/nmi_int.c
index 11b7a51..b00ae99 100644
--- a/arch/i386/oprofile/nmi_int.c
+++ b/arch/i386/oprofile/nmi_int.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/kdebug.h>
-#include <asm/nmi.h>
+#include <asm/perfctr.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
  
@@ -324,7 +324,7 @@ static int nmi_create_files(struct super_block * sb, struct dentry * root)
 		 * NOTE:  assumes 1:1 mapping here (that counters are organized
 		 *        sequentially in their struct assignment).
 		 */
-		if (unlikely(!avail_to_resrv_perfctr_nmi_bit(i)))
+		if (unlikely(!avail_to_resrv_perfctr_bit(i)))
 			continue;
 
 		snprintf(buf,  sizeof(buf), "%d", i);
diff --git a/arch/i386/oprofile/op_model_athlon.c b/arch/i386/oprofile/op_model_athlon.c
index 3057a19..b1e9902 100644
--- a/arch/i386/oprofile/op_model_athlon.c
+++ b/arch/i386/oprofile/op_model_athlon.c
@@ -13,7 +13,7 @@
 #include <linux/oprofile.h>
 #include <asm/ptrace.h>
 #include <asm/msr.h>
-#include <asm/nmi.h>
+#include <asm/perfctr.h>
  
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -45,14 +45,14 @@ static void athlon_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i=0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+		if (reserve_perfctr(MSR_K7_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
 		else
 			msrs->counters[i].addr = 0;
 	}
 
 	for (i=0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
+		if (reserve_evntsel(MSR_K7_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
 		else
 			msrs->controls[i].addr = 0;
@@ -160,11 +160,11 @@ static void athlon_shutdown(struct op_msrs const * const msrs)
 
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (CTR_IS_RESERVED(msrs,i))
-			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+			release_perfctr(MSR_K7_PERFCTR0 + i);
 	}
 	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
 		if (CTRL_IS_RESERVED(msrs,i))
-			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+			release_evntsel(MSR_K7_EVNTSEL0 + i);
 	}
 }
 
diff --git a/arch/i386/oprofile/op_model_p4.c b/arch/i386/oprofile/op_model_p4.c
index 4792592..6ba5856 100644
--- a/arch/i386/oprofile/op_model_p4.c
+++ b/arch/i386/oprofile/op_model_p4.c
@@ -14,7 +14,7 @@
 #include <asm/ptrace.h>
 #include <asm/fixmap.h>
 #include <asm/apic.h>
-#include <asm/nmi.h>
+#include <asm/perfctr.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -413,7 +413,7 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		addr = p4_counters[VIRT_CTR(stag, i)].counter_address;
 		cccraddr = p4_counters[VIRT_CTR(stag, i)].cccr_address;
-		if (reserve_perfctr_nmi(addr)){
+		if (reserve_perfctr(addr)){
 			msrs->counters[i].addr = addr;
 			msrs->controls[i].addr = cccraddr;
 		}
@@ -422,7 +422,7 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 	/* 43 ESCR registers in three or four discontiguous group */
 	for (addr = MSR_P4_BSU_ESCR0 + stag;
 	     addr < MSR_P4_IQ_ESCR0; ++i, addr += addr_increment()) {
-		if (reserve_evntsel_nmi(addr))
+		if (reserve_evntsel(addr))
 			msrs->controls[i].addr = addr;
 	}
 
@@ -431,32 +431,32 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 	if (boot_cpu_data.x86_model >= 0x3) {
 		for (addr = MSR_P4_BSU_ESCR0 + stag;
 		     addr <= MSR_P4_BSU_ESCR1; ++i, addr += addr_increment()) {
-			if (reserve_evntsel_nmi(addr))
+			if (reserve_evntsel(addr))
 				msrs->controls[i].addr = addr;
 		}
 	} else {
 		for (addr = MSR_P4_IQ_ESCR0 + stag;
 		     addr <= MSR_P4_IQ_ESCR1; ++i, addr += addr_increment()) {
-			if (reserve_evntsel_nmi(addr))
+			if (reserve_evntsel(addr))
 				msrs->controls[i].addr = addr;
 		}
 	}
 
 	for (addr = MSR_P4_RAT_ESCR0 + stag;
 	     addr <= MSR_P4_SSU_ESCR0; ++i, addr += addr_increment()) {
-		if (reserve_evntsel_nmi(addr))
+		if (reserve_evntsel(addr))
 			msrs->controls[i].addr = addr;
 	}
 	
 	for (addr = MSR_P4_MS_ESCR0 + stag;
 	     addr <= MSR_P4_TC_ESCR1; ++i, addr += addr_increment()) { 
-		if (reserve_evntsel_nmi(addr))
+		if (reserve_evntsel(addr))
 			msrs->controls[i].addr = addr;
 	}
 	
 	for (addr = MSR_P4_IX_ESCR0 + stag;
 	     addr <= MSR_P4_CRU_ESCR3; ++i, addr += addr_increment()) { 
-		if (reserve_evntsel_nmi(addr))
+		if (reserve_evntsel(addr))
 			msrs->controls[i].addr = addr;
 	}
 
@@ -464,21 +464,21 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 
 	if (num_counters == NUM_COUNTERS_NON_HT) {		
 		/* standard non-HT CPUs handle both remaining ESCRs*/
-		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR5))
+		if (reserve_evntsel(MSR_P4_CRU_ESCR5))
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
-		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR4))
+		if (reserve_evntsel(MSR_P4_CRU_ESCR4))
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR4;
 
 	} else if (stag == 0) {
 		/* HT CPUs give the first remainder to the even thread, as
 		   the 32nd control register */
-		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR4))
+		if (reserve_evntsel(MSR_P4_CRU_ESCR4))
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR4;
 
 	} else {
 		/* and two copies of the second to the odd thread,
 		   for the 22st and 23nd control registers */
-		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR5)) {
+		if (reserve_evntsel(MSR_P4_CRU_ESCR5)) {
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
 		}
@@ -684,7 +684,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 
 	for (i = 0 ; i < num_counters ; ++i) {
 		if (CTR_IS_RESERVED(msrs,i))
-			release_perfctr_nmi(msrs->counters[i].addr);
+			release_perfctr(msrs->counters[i].addr);
 	}
 	/* some of the control registers are specially reserved in
 	 * conjunction with the counter registers (hence the starting offset).
@@ -692,7 +692,7 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	 */
 	for (i = num_counters ; i < num_controls ; ++i) {
 		if (CTRL_IS_RESERVED(msrs,i))
-			release_evntsel_nmi(msrs->controls[i].addr);
+			release_evntsel(msrs->controls[i].addr);
 	}
 }
 
diff --git a/arch/i386/oprofile/op_model_ppro.c b/arch/i386/oprofile/op_model_ppro.c
index c554f52..5dfd93a 100644
--- a/arch/i386/oprofile/op_model_ppro.c
+++ b/arch/i386/oprofile/op_model_ppro.c
@@ -14,7 +14,7 @@
 #include <asm/ptrace.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
-#include <asm/nmi.h>
+#include <asm/perfctr.h>
  
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -47,14 +47,14 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i=0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
+		if (reserve_perfctr(MSR_P6_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
 		else
 			msrs->counters[i].addr = 0;
 	}
 	
 	for (i=0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
+		if (reserve_evntsel(MSR_P6_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
 		else
 			msrs->controls[i].addr = 0;
@@ -171,11 +171,11 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (CTR_IS_RESERVED(msrs,i))
-			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
+			release_perfctr(MSR_P6_PERFCTR0 + i);
 	}
 	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
 		if (CTRL_IS_RESERVED(msrs,i))
-			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
+			release_evntsel(MSR_P6_EVNTSEL0 + i);
 	}
 }
 
diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 892ebf8..c08cf0f 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -33,6 +33,7 @@
 #include <asm/pgalloc.h>
 #include <asm/mach_apic.h>
 #include <asm/nmi.h>
+#include <asm/perfctr.h>
 #include <asm/idle.h>
 #include <asm/proto.h>
 #include <asm/timex.h>
diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 4a0895b..d145547 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -43,7 +43,7 @@
 #include <asm/apic.h>
 #include <asm/hpet.h>
 #include <asm/mpspec.h>
-#include <asm/nmi.h>
+#include <asm/perfctr.h>
 
 static char *timename = NULL;
 
@@ -261,7 +261,7 @@ static unsigned int __init tsc_calibrate_cpu_khz(void)
        unsigned long flags;
 
        for (i = 0; i < 4; i++)
-               if (avail_to_resrv_perfctr_nmi_bit(i))
+               if (avail_to_resrv_perfctr_bit(i))
                        break;
        no_ctr_free = (i == 4);
        if (no_ctr_free) {
@@ -270,8 +270,8 @@ static unsigned int __init tsc_calibrate_cpu_khz(void)
                wrmsrl(MSR_K7_EVNTSEL3, 0);
                rdmsrl(MSR_K7_PERFCTR3, pmc3);
        } else {
-               reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-               reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+               reserve_perfctr(MSR_K7_PERFCTR0 + i);
+               reserve_evntsel(MSR_K7_EVNTSEL0 + i);
        }
        local_irq_save(flags);
        /* start meauring cycles, incrementing from 0 */
@@ -289,8 +289,8 @@ static unsigned int __init tsc_calibrate_cpu_khz(void)
                wrmsrl(MSR_K7_PERFCTR3, pmc3);
                wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
        } else {
-               release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-               release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+               release_perfctr(MSR_K7_PERFCTR0 + i);
+               release_evntsel(MSR_K7_EVNTSEL0 + i);
        }
 
        return pmc_now * tsc_khz / (tsc_now - tsc_start);
diff --git a/include/asm-i386/nmi.h b/include/asm-i386/nmi.h
index 736af6f..e189531 100644
--- a/include/asm-i386/nmi.h
+++ b/include/asm-i386/nmi.h
@@ -18,13 +18,6 @@
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern int nmi_watchdog_enabled;
-extern void probe_performance_counters(void);
-extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
-extern int avail_to_resrv_perfctr_nmi(unsigned int);
-extern int reserve_perfctr_nmi(unsigned int);
-extern void release_perfctr_nmi(unsigned int);
-extern int reserve_evntsel_nmi(unsigned int);
-extern void release_evntsel_nmi(unsigned int);
 
 extern void setup_apic_nmi_watchdog (void *);
 extern void stop_apic_nmi_watchdog (void *);
diff --git a/include/asm-i386/perfctr.h b/include/asm-i386/perfctr.h
new file mode 100644
index 0000000..fbd4993
--- /dev/null
+++ b/include/asm-i386/perfctr.h
@@ -0,0 +1,15 @@
+/*
+ *  linux/include/asm-i386/perfctr.h
+ */
+#ifndef ASM_PERFCTR_H
+#define ASM_PERFCTR_H
+
+extern void probe_performance_counters(void);
+extern int avail_to_resrv_perfctr_bit(unsigned int);
+extern int avail_to_resrv_perfctr(unsigned int);
+extern int reserve_perfctr(unsigned int);
+extern void release_perfctr(unsigned int);
+extern int reserve_evntsel(unsigned int);
+extern void release_evntsel(unsigned int);
+
+#endif /* ASM_PERFCTR_H */
diff --git a/include/asm-x86_64/nmi.h b/include/asm-x86_64/nmi.h
index d45fc62..666462c 100644
--- a/include/asm-x86_64/nmi.h
+++ b/include/asm-x86_64/nmi.h
@@ -46,13 +46,6 @@ extern int unknown_nmi_panic;
 extern int nmi_watchdog_enabled;
 
 extern int check_nmi_watchdog(void);
-extern void probe_performance_counters(void);
-extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
-extern int avail_to_resrv_perfctr_nmi(unsigned int);
-extern int reserve_perfctr_nmi(unsigned int);
-extern void release_perfctr_nmi(unsigned int);
-extern int reserve_evntsel_nmi(unsigned int);
-extern void release_evntsel_nmi(unsigned int);
 
 extern void setup_apic_nmi_watchdog (void *);
 extern void stop_apic_nmi_watchdog (void *);
diff --git a/include/asm-x86_64/perfctr.h b/include/asm-x86_64/perfctr.h
new file mode 100644
index 0000000..9ff5c2d
--- /dev/null
+++ b/include/asm-x86_64/perfctr.h
@@ -0,0 +1,15 @@
+/*
+ *  linux/include/asm-x86_64/perfctr.h
+ */
+#ifndef ASM_PERFCTR_H
+#define ASM_PERFCTR_H
+
+extern void probe_performance_counters(void);
+extern int avail_to_resrv_perfctr_bit(unsigned int);
+extern int avail_to_resrv_perfctr(unsigned int);
+extern int reserve_perfctr(unsigned int);
+extern void release_perfctr(unsigned int);
+extern int reserve_evntsel(unsigned int);
+extern void release_evntsel(unsigned int);
+
+#endif /* ASM_PERFCTR_H */
-- 
1.5.2.1

