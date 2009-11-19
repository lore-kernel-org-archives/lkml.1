Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZKSNi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZKSNi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZKSNge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 21/35] KVM: x86 shared msr infrastructure
Date: Thu, 19 Nov 2009 15:34:57 +0200
Message-Id: <1258637711-11674-22-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various syscall-related MSRs are fairly expensive to switch.  Currently
we switch them on every vcpu preemption, which is far too often:

- if we're switching to a kernel thread (idle task, threaded interrupt,
  kernel-mode virtio server (vhost-net), for example) and back, then
  there's no need to switch those MSRs since kernel threasd won't
  be exiting to userspace.

- if we're switching to another guest running an identical OS, most likely
  those MSRs will have the same value, so there's little point in reloading
  them.

- if we're running the same OS on the guest and host, the MSRs will have
  identical values and reloading is unnecessary.

This patch uses the new user return notifiers to implement last-minute
switching, and checks the msr values to avoid unnecessary reloading.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +
 arch/x86/kvm/Kconfig            |    1 +
 arch/x86/kvm/x86.c              |   81 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0558ff8..26a74b7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -809,4 +809,7 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 
+void kvm_define_shared_msr(unsigned index, u32 msr);
+void kvm_set_shared_msr(unsigned index, u64 val);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b84e571..4cd4983 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -28,6 +28,7 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_EVENTFD
 	select KVM_APIC_ARCHITECTURE
+	select USER_RETURN_NOTIFIER
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e16cdc9..58c5cdd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -37,6 +37,7 @@
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 #include <linux/cpufreq.h>
+#include <linux/user-return-notifier.h>
 #include <trace/events/kvm.h>
 #undef TRACE_INCLUDE_FILE
 #define CREATE_TRACE_POINTS
@@ -87,6 +88,25 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
 int ignore_msrs = 0;
 module_param_named(ignore_msrs, ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
+#define KVM_NR_SHARED_MSRS 16
+
+struct kvm_shared_msrs_global {
+	int nr;
+	struct kvm_shared_msr {
+		u32 msr;
+		u64 value;
+	} msrs[KVM_NR_SHARED_MSRS];
+};
+
+struct kvm_shared_msrs {
+	struct user_return_notifier urn;
+	bool registered;
+	u64 current_value[KVM_NR_SHARED_MSRS];
+};
+
+static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
+static DEFINE_PER_CPU(struct kvm_shared_msrs, shared_msrs);
+
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "pf_fixed", VCPU_STAT(pf_fixed) },
 	{ "pf_guest", VCPU_STAT(pf_guest) },
@@ -123,6 +143,64 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+static void kvm_on_user_return(struct user_return_notifier *urn)
+{
+	unsigned slot;
+	struct kvm_shared_msr *global;
+	struct kvm_shared_msrs *locals
+		= container_of(urn, struct kvm_shared_msrs, urn);
+
+	for (slot = 0; slot < shared_msrs_global.nr; ++slot) {
+		global = &shared_msrs_global.msrs[slot];
+		if (global->value != locals->current_value[slot]) {
+			wrmsrl(global->msr, global->value);
+			locals->current_value[slot] = global->value;
+		}
+	}
+	locals->registered = false;
+	user_return_notifier_unregister(urn);
+}
+
+void kvm_define_shared_msr(unsigned slot, u32 msr)
+{
+	int cpu;
+	u64 value;
+
+	if (slot >= shared_msrs_global.nr)
+		shared_msrs_global.nr = slot + 1;
+	shared_msrs_global.msrs[slot].msr = msr;
+	rdmsrl_safe(msr, &value);
+	shared_msrs_global.msrs[slot].value = value;
+	for_each_online_cpu(cpu)
+		per_cpu(shared_msrs, cpu).current_value[slot] = value;
+}
+EXPORT_SYMBOL_GPL(kvm_define_shared_msr);
+
+static void kvm_shared_msr_cpu_online(void)
+{
+	unsigned i;
+	struct kvm_shared_msrs *locals = &__get_cpu_var(shared_msrs);
+
+	for (i = 0; i < shared_msrs_global.nr; ++i)
+		locals->current_value[i] = shared_msrs_global.msrs[i].value;
+}
+
+void kvm_set_shared_msr(unsigned slot, u64 value)
+{
+	struct kvm_shared_msrs *smsr = &__get_cpu_var(shared_msrs);
+
+	if (value == smsr->current_value[slot])
+		return;
+	smsr->current_value[slot] = value;
+	wrmsrl(shared_msrs_global.msrs[slot].msr, value);
+	if (!smsr->registered) {
+		smsr->urn.on_user_return = kvm_on_user_return;
+		user_return_notifier_register(&smsr->urn);
+		smsr->registered = true;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_set_shared_msr);
+
 unsigned long segment_base(u16 selector)
 {
 	struct descriptor_table gdt;
@@ -4815,6 +4893,9 @@ int kvm_arch_hardware_enable(void *garbage)
 		int cpu = raw_smp_processor_id();
 		per_cpu(cpu_tsc_khz, cpu) = 0;
 	}
+
+	kvm_shared_msr_cpu_online();
+
 	return kvm_x86_ops->hardware_enable(garbage);
 }
 
-- 
1.6.5.2

