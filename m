Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbXKFVT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbXKFVT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbXKFVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:19:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbXKFVTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:19:49 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jeremy@goop.org, avi@qumranet.com, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: kvmclock implementation, the guest part.
Date: Tue,  6 Nov 2007 20:18:56 -0200
Message-Id: <11943875523055-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11943875471622-git-send-email-gcosta@redhat.com>
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com> <11943875471622-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the guest part of kvm clock implementation
It does not do tsc-only timing, as tsc can have deltas
between cpus, and it did not seem worthy to me to keep
adjusting them.

We do use it, however, for fine-grained adjustment.

Other than that, time comes from the host.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/i386/Kconfig           |   10 +++
 arch/x86/kernel/Makefile_32 |    1 +
 arch/x86/kernel/kvmclock.c  |  164 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_32.c  |    5 ++
 4 files changed, 180 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/kvmclock.c

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index b4437ce..a3b45f1 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -257,6 +257,16 @@ config VMI
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
 
+config KVM_CLOCK
+	bool "KVM paravirtualized clock"
+	select PARAVIRT
+	help
+	  Turning on this option will allow you to run a paravirtualized clock
+	  when running over the KVM hypervisor. Instead of relying on a PIT
+	  (or probably other) emulation by the underlying device model, the host
+	  provides the guest with timing infrastructure, as time of day, and
+	  timer expiration.
+
 source "arch/x86/lguest/Kconfig"
 
 endif
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index b9d6798..df76d8c 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -43,6 +43,7 @@ obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
+obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
 obj-y				+= pcspeaker.o
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
new file mode 100644
index 0000000..8778d61
--- /dev/null
+++ b/arch/x86/kernel/kvmclock.c
@@ -0,0 +1,164 @@
+/*  KVM paravirtual clock driver. A clocksource implementation
+    Copyright (C) 2007 Glauber de Oliveira Costa, Red Hat Inc.
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+*/
+
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/kvm_para.h>
+#include <linux/ktime.h>
+#include <asm/arch_hooks.h>
+#include <asm/i8253.h>
+
+#include <mach_ipi.h>
+#include <irq_vectors.h>
+
+#define KVM_SCALE 22
+
+static int kvmclock = 1;
+
+static int parse_no_kvmclock(char *arg)
+{
+	kvmclock = 0;
+	return 0;
+}
+early_param("no-kvmclock", parse_no_kvmclock);
+
+/* The hypervisor will put information about time periodically here */
+union kvm_hv_clock hv_clock[NR_CPUS] __attribute__((__aligned__(PAGE_SIZE)));
+
+/*
+ * The wallclock is the time of day when we booted. Since then, some time may
+ * have elapsed since the hypervisor wrote the data. So we try to account for
+ * that. Even if the tsc is not accurate, it gives us a more accurate timing
+ * than not adjusting at all
+ */
+unsigned long kvm_get_wallclock(void)
+{
+	u64 wc_sec, delta, last_tsc;
+	struct timespec ts;
+	int version, nsec, cpu = smp_processor_id();
+
+	do {
+		version = hv_clock[cpu].version;
+		rmb();
+		last_tsc = hv_clock[cpu].last_tsc;
+		rmb();
+		wc_sec = hv_clock[cpu].wc_sec;
+		rmb();
+	} while ((hv_clock[cpu].version != version) && !(version & 1));
+
+	rdtscll(delta);
+	delta = delta - last_tsc;
+	delta = (delta * hv_clock[cpu].tsc_mult) >> KVM_SCALE;
+	nsec = do_div(delta, NSEC_PER_SEC);
+	set_normalized_timespec(&ts, wc_sec + delta, nsec);
+
+	/*
+	 * Of all mechanisms of time adjustment I've tested, this one
+	 * was the champion!
+	 */
+	return ts.tv_sec + 1;
+}
+
+int kvm_set_wallclock(unsigned long now)
+{
+	return 0;
+}
+
+/*
+ * This is our read_clock function. The host puts an tsc timestamp each time
+ * it updates a new time, and then we can use it to derive a slightly more
+ * precise notion of elapsed time, converted to nanoseconds.
+ */
+static cycle_t kvm_clock_read(void)
+{
+
+	u64 delta, last_tsc, now;
+	u32 version;
+	int cpu = smp_processor_id();
+
+	do {
+		version = hv_clock[cpu].version;
+		rmb();
+		last_tsc = hv_clock[cpu].last_tsc;
+		rmb();
+		now = hv_clock[cpu].now_ns;
+		rmb();
+	} while ((hv_clock[cpu].version != version) && !(version & 1));
+
+	delta = native_read_tsc() - last_tsc;
+	delta = (delta * hv_clock[cpu].tsc_mult) >> KVM_SCALE;
+
+	return now + delta;
+}
+
+static struct clocksource kvm_clock = {
+	.name = "kvm-clock",
+	.read = kvm_clock_read,
+	.rating = 400,
+	.mask = CLOCKSOURCE_MASK(64),
+	.mult = 1 << KVM_SCALE,
+	.shift = KVM_SCALE,
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+unsigned long long kvm_sched_clock(void)
+{
+	return kvm_clock_read();
+}
+
+static int kvm_register_clock(unsigned int cpu)
+{
+	unsigned long kvm_clock_info = __pa((unsigned long)&hv_clock[cpu]);
+	return kvm_hypercall2(KVM_HCALL_REGISTER_CLOCK, kvm_clock_info, cpu);
+}
+
+int kvm_cpu_up(unsigned int cpu)
+{
+	/*
+	 * Now that the first cpu already had this clocksource initialized,
+	 * we shouldn't fail.
+	 */
+	WARN_ON(kvm_register_clock(cpu));
+	return native_cpu_up(cpu);
+}
+
+void __init kvmclock_init(void)
+{
+	int cpu = smp_processor_id();
+	int r;
+
+	/*
+	 * If we can't use the paravirt clock, just go with
+	 * the usual timekeeping
+	 */
+	if (!kvm_para_available())
+		return;
+
+	r = kvm_register_clock(cpu);
+	if (r)
+		return;
+
+	if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)) {
+		pv_time_ops.get_wallclock = kvm_get_wallclock;
+		pv_time_ops.set_wallclock = kvm_set_wallclock;
+		pv_time_ops.sched_clock = kvm_sched_clock;
+		smp_ops.cpu_up = kvm_cpu_up;
+		clocksource_register(&kvm_clock);
+	}
+}
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index cc0e914..a6cfd47 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -44,6 +44,7 @@
 #include <linux/crash_dump.h>
 #include <linux/dmi.h>
 #include <linux/pfn.h>
+#include <linux/kvm_para.h>
 
 #include <video/edid.h>
 
@@ -617,6 +618,10 @@ void __init setup_arch(char **cmdline_p)
 
 	max_low_pfn = setup_memory();
 
+#ifdef CONFIG_KVM_CLOCK
+	kvmclock_init();
+#endif
+
 #ifdef CONFIG_VMI
 	/*
 	 * Must be after max_low_pfn is determined, and before kernel
-- 
1.5.0.6

