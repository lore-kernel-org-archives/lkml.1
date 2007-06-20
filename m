Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763255AbXFTKf5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 20 Jun 2007 06:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbXFTKfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:35:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:38824 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756429AbXFTKfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:35:45 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/LHjBudc3Lzoy4PnQYQ3YjkWSd6A2RHPzocgfea3
	oBwTgP6TVwIHVz
From: =?utf-8?q?Bj=C3=B6rn=20Steinbrink?= <B.Steinbrink@gmx.de>
To: eranian@hpl.hp.com
Cc: oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
        perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
        levon@movementarian.org, akpm@linux-foundation.org, mingo@elte.hu,
        =?utf-8?q?Bj=C3=B6rn=20Steinbrink?= <B.Steinbrink@gmx.de>
Subject: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Date: Wed, 20 Jun 2007 12:35:56 +0200
Message-Id: <11823357591180-git-send-email->
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11823357571842-git-send-email->
References: <20070618103214.GA12045@atjola.homenet>
 <11823357571842-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The performance counter allocator is tied to the LAPIC NMI watchdog,
rendering it unusable if the watchdog is not in use, breaking other
subsystems that try to allocate performance counters.

Fix the performance counter allocator by making it independent of the
LAPIC NMI watchdog. This also fixes a bug in the LAPIC NMI watchdog
which allocated the wrong performance counter on CPUs with PerfMon
support.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
---
 arch/i386/kernel/apic.c                 |    1 +
 arch/i386/kernel/cpu/Makefile           |    2 +-
 arch/i386/kernel/cpu/perfctr-watchdog.c |  103 +-----------------
 arch/i386/kernel/cpu/perfctr.c          |  178 +++++++++++++++++++++++++++++++
 arch/x86_64/kernel/Makefile             |    3 +-
 arch/x86_64/kernel/apic.c               |    1 +
 include/asm-i386/nmi.h                  |    1 +
 include/asm-x86_64/nmi.h                |    1 +
 8 files changed, 187 insertions(+), 103 deletions(-)
 create mode 100644 arch/i386/kernel/cpu/perfctr.c

diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
index 67824f3..88b74e3 100644
--- a/arch/i386/kernel/apic.c
+++ b/arch/i386/kernel/apic.c
@@ -1009,6 +1009,7 @@ void __devinit setup_local_APIC(void)
 	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 	apic_write_around(APIC_LVTT, value);
 
+	probe_performance_counters();
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
 }
diff --git a/arch/i386/kernel/cpu/Makefile b/arch/i386/kernel/cpu/Makefile
index 74f27a4..882364d 100644
--- a/arch/i386/kernel/cpu/Makefile
+++ b/arch/i386/kernel/cpu/Makefile
@@ -18,4 +18,4 @@ obj-$(CONFIG_X86_MCE)	+=	mcheck/
 obj-$(CONFIG_MTRR)	+= 	mtrr/
 obj-$(CONFIG_CPU_FREQ)	+=	cpufreq/
 
-obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+obj-$(CONFIG_X86_LOCAL_APIC) += perfctr.o perfctr-watchdog.o
diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index f0b6763..2ae39eb 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -8,9 +8,7 @@
    Original code for K7/P6 written by Keith Owens */
 
 #include <linux/percpu.h>
-#include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/bitops.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
 #include <asm/apic.h>
@@ -36,105 +34,8 @@ struct wd_ops {
 
 static struct wd_ops *wd_ops;
 
-/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
- * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
- */
-#define NMI_MAX_COUNTER_BITS 66
-
-/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
- * evtsel_nmi_owner tracks the ownership of the event selection
- * - different performance counters/ event selection may be reserved for
- *   different subsystems this reservation system just tries to coordinate
- *   things a little
- */
-static DECLARE_BITMAP(perfctr_nmi_owner, NMI_MAX_COUNTER_BITS);
-static DECLARE_BITMAP(evntsel_nmi_owner, NMI_MAX_COUNTER_BITS);
-
 static DEFINE_PER_CPU(struct nmi_watchdog_ctlblk, nmi_watchdog_ctlblk);
 
-/* converts an msr to an appropriate reservation bit */
-static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
-{
-	return wd_ops ? msr - wd_ops->perfctr : 0;
-}
-
-/* converts an msr to an appropriate reservation bit */
-/* returns the bit offset of the event selection register */
-static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
-{
-	return wd_ops ? msr - wd_ops->evntsel : 0;
-}
-
-/* checks for a bit availability (hack for oprofile) */
-int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
-{
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	return (!test_bit(counter, perfctr_nmi_owner));
-}
-
-/* checks the an msr for availability */
-int avail_to_resrv_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	return (!test_bit(counter, perfctr_nmi_owner));
-}
-
-int reserve_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	if (!test_and_set_bit(counter, perfctr_nmi_owner))
-		return 1;
-	return 0;
-}
-
-void release_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	clear_bit(counter, perfctr_nmi_owner);
-}
-
-int reserve_evntsel_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	if (!test_and_set_bit(counter, evntsel_nmi_owner))
-		return 1;
-	return 0;
-}
-
-void release_evntsel_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_evntsel_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	clear_bit(counter, evntsel_nmi_owner);
-}
-
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
-EXPORT_SYMBOL(reserve_perfctr_nmi);
-EXPORT_SYMBOL(release_perfctr_nmi);
-EXPORT_SYMBOL(reserve_evntsel_nmi);
-EXPORT_SYMBOL(release_evntsel_nmi);
-
 void disable_lapic_nmi_watchdog(void)
 {
 	BUG_ON(nmi_watchdog != NMI_LOCAL_APIC);
@@ -568,8 +469,8 @@ static struct wd_ops intel_arch_wd_ops = {
 	.setup = setup_intel_arch_watchdog,
 	.rearm = p6_rearm,
 	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
-	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
+	.perfctr = MSR_ARCH_PERFMON_PERFCTR1,
+	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
 static void probe_nmi_watchdog(void)
diff --git a/arch/i386/kernel/cpu/perfctr.c b/arch/i386/kernel/cpu/perfctr.c
new file mode 100644
index 0000000..fece4fc
--- /dev/null
+++ b/arch/i386/kernel/cpu/perfctr.c
@@ -0,0 +1,178 @@
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <asm/msr-index.h>
+#include <asm/intel_arch_perfmon.h>
+
+struct perfctr_base_regs {
+	unsigned int perfctr;
+	unsigned int evntsel;
+};
+
+static struct perfctr_base_regs *perfctr_base_regs;
+
+static struct perfctr_base_regs k7_base_regs = {
+	.perfctr = MSR_K7_PERFCTR0,
+	.evntsel = MSR_K7_EVNTSEL0
+};
+
+static struct perfctr_base_regs p4_base_regs = {
+	.perfctr = MSR_P4_BPU_PERFCTR0,
+	.evntsel = MSR_P4_BSU_ESCR0
+};
+
+static struct perfctr_base_regs p6_base_regs = {
+	.perfctr = MSR_P6_PERFCTR0,
+	.evntsel = MSR_P6_EVNTSEL0
+};
+
+static struct perfctr_base_regs arch_perfmon_base_regs = {
+	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
+	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0
+};
+
+/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
+ * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
+ */
+#define NMI_MAX_COUNTER_BITS 66
+
+/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
+ * evtsel_nmi_owner tracks the ownership of the event selection
+ * - different performance counters/ event selection may be reserved for
+ *   different subsystems this reservation system just tries to coordinate
+ *   things a little
+ */
+static DECLARE_BITMAP(perfctr_nmi_owner, NMI_MAX_COUNTER_BITS);
+static DECLARE_BITMAP(evntsel_nmi_owner, NMI_MAX_COUNTER_BITS);
+
+void __devinit probe_performance_counters(void)
+{
+	if (perfctr_base_regs)
+		return;
+
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
+		    boot_cpu_data.x86 != 16)
+			return;
+
+		perfctr_base_regs = &k7_base_regs;
+		break;
+
+	case X86_VENDOR_INTEL:
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+			perfctr_base_regs = &arch_perfmon_base_regs;
+			break;
+		}
+		switch (boot_cpu_data.x86) {
+		case 6:
+			perfctr_base_regs = &p6_base_regs;
+			break;
+
+		case 15:
+			perfctr_base_regs = &p4_base_regs;
+			break;
+		}
+		break;
+	}
+}
+
+/* converts an msr to an appropriate reservation bit */
+static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
+{
+	return msr - perfctr_base_regs->perfctr;
+}
+
+/* converts an msr to an appropriate reservation bit */
+/* returns the bit offset of the event selection register */
+static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
+{
+	return msr - perfctr_base_regs->evntsel;
+}
+
+/* checks for a bit availability (hack for oprofile) */
+int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
+{
+	if (!perfctr_base_regs)
+		return 0;
+
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	return (!test_bit(counter, perfctr_nmi_owner));
+}
+
+/* checks the an msr for availability */
+int avail_to_resrv_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	if (!perfctr_base_regs)
+		return 0;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	return (!test_bit(counter, perfctr_nmi_owner));
+}
+
+int reserve_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	if (!perfctr_base_regs)
+		return 0;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	if (!test_and_set_bit(counter, perfctr_nmi_owner))
+		return 1;
+	return 0;
+}
+
+void release_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	if (!perfctr_base_regs)
+		return;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	clear_bit(counter, perfctr_nmi_owner);
+}
+
+int reserve_evntsel_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	if (!perfctr_base_regs)
+		return 0;
+
+	counter = nmi_evntsel_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	if (!test_and_set_bit(counter, evntsel_nmi_owner))
+		return 1;
+	return 0;
+}
+
+void release_evntsel_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	if (!perfctr_base_regs)
+		return;
+
+	counter = nmi_evntsel_msr_to_bit(msr);
+	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
+
+	clear_bit(counter, evntsel_nmi_owner);
+}
+
+EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
+EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
+EXPORT_SYMBOL(reserve_perfctr_nmi);
+EXPORT_SYMBOL(release_perfctr_nmi);
+EXPORT_SYMBOL(reserve_evntsel_nmi);
+EXPORT_SYMBOL(release_evntsel_nmi);
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index de1de8a..cc7587d 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
 		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o bugs.o \
-		perfctr-watchdog.o
+		perfctr.o perfctr-watchdog.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
@@ -60,4 +60,5 @@ i8237-y				+= ../../i386/kernel/i8237.o
 msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
 alternative-y			+= ../../i386/kernel/alternative.o
 pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
+perfctr-y			+= ../../i386/kernel/cpu/perfctr.o
 perfctr-watchdog-y		+= ../../i386/kernel/cpu/perfctr-watchdog.o
diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 1b0e07b..892ebf8 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -453,6 +453,7 @@ void __cpuinit setup_local_APIC (void)
 			oldvalue, value);
 	}
 
+	probe_performance_counters();
 	nmi_watchdog_default();
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
diff --git a/include/asm-i386/nmi.h b/include/asm-i386/nmi.h
index fb1e133..736af6f 100644
--- a/include/asm-i386/nmi.h
+++ b/include/asm-i386/nmi.h
@@ -18,6 +18,7 @@
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern int nmi_watchdog_enabled;
+extern void probe_performance_counters(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
diff --git a/include/asm-x86_64/nmi.h b/include/asm-x86_64/nmi.h
index d0a7f53..d45fc62 100644
--- a/include/asm-x86_64/nmi.h
+++ b/include/asm-x86_64/nmi.h
@@ -46,6 +46,7 @@ extern int unknown_nmi_panic;
 extern int nmi_watchdog_enabled;
 
 extern int check_nmi_watchdog(void);
+extern void probe_performance_counters(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
-- 
1.5.2.1

