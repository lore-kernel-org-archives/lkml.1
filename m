Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0BLWUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:20:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041Ab0BLWUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:20:34 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, benh@kernel.crashing.org,
       paulus@samba.org, peterz@infradead.org, gorcunov@gmail.com,
       aris@redhat.com
Subject: [PATCH 4/4] [RFC][powerpc] nmi_watchdog:  support for powerpc
Date: Fri, 12 Feb 2010 17:19:21 -0500
Message-Id: <1266013161-31197-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make sure other arches compiled properly, I used powerpc as a
test bed.  It was just basic sanity checking code to see if the
infrastructure bits worked ok.  The lock up detection logic is non-existant
and the sample_period is some large made up number.

The interesting piece of the patch is the change to ppc970-pmc.c.  I had to
move the initcall from arch_init to early_init to allow the nmi_watchdog to
register with the perf_event subsystem as cpus were coming online.
Otherwise it failed with ENXIO.

This patch is just a conversation starter.  I am not sure if powerpc has a
true NMI and if this is really needed.  But since I spent some time making
it work, I thought I would throw it out there.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/powerpc/Kconfig             |    1 +
 arch/powerpc/kernel/Makefile     |    1 +
 arch/powerpc/kernel/hw_nmi.c     |   45 ++++++++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/ppc970-pmu.c |    2 +-
 4 files changed, 48 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/kernel/hw_nmi.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ba3948c..146b0b5 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -140,6 +140,7 @@ config PPC
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
 	select HAVE_PERF_EVENTS
+	select PERF_EVENTS_NMI
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index c002b04..08e3d2d 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_PPC_UDBG_16550)	+= legacy_serial.o udbg_16550.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_SWIOTLB)		+= dma-swiotlb.o
+obj-$(CONFIG_NMI_WATCHDOG)	+= hw_nmi.o
 
 pci64-$(CONFIG_PPC64)		+= pci_dn.o isa-bridge.o
 obj-$(CONFIG_PCI)		+= pci_$(CONFIG_WORD_SIZE).o $(pci64-y) \
diff --git a/arch/powerpc/kernel/hw_nmi.c b/arch/powerpc/kernel/hw_nmi.c
new file mode 100644
index 0000000..2313724
--- /dev/null
+++ b/arch/powerpc/kernel/hw_nmi.c
@@ -0,0 +1,45 @@
+/*
+ *  HW NMI watchdog support
+ *
+ *  started by Don Zickus, Copyright (C) 2010 Red Hat, Inc.
+ *
+ *  Arch specific calls to support NMI watchdog
+ *
+ *  Bits copied from original nmi.c file
+ *
+ */
+
+#include <linux/smp.h>
+//#include <linux/cpumask.h>
+//#include <linux/sched.h>
+#include <linux/percpu.h>
+#include <linux/kernel_stat.h>
+
+//#include <linux/nmi.h>
+
+static DEFINE_PER_CPU(unsigned, last_irq_sum);
+
+int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
+{
+	unsigned int sum;
+	int cpu = smp_processor_id();
+
+	/* We determine if the cpu is stuck by checking whether any
+	 * interrupts have happened since we last checked.  Of course
+	 * an nmi storm could create false positives, but the higher
+	 * level logic should account for that
+	 */
+	return 0;
+	sum = kstat_irqs_cpu(0, cpu);
+	if (__get_cpu_var(last_irq_sum) == sum) {
+		return 1;
+	} else {
+		__get_cpu_var(last_irq_sum) = sum;
+		return 0;
+	}
+}
+
+u64 hw_nmi_get_sample_period(void)
+{
+	return 10000 * 1000;
+}
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 8eff48e..d91aaf1 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -492,4 +492,4 @@ static int init_ppc970_pmu(void)
 	return register_power_pmu(&ppc970_pmu);
 }
 
-arch_initcall(init_ppc970_pmu);
+early_initcall(init_ppc970_pmu);
-- 
1.6.6.83.gc9a2

