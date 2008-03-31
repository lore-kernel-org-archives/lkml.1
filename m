Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbYCaOso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbYCaOso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYCaOhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:54 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51328
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYCaOhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 32/40] KVM: paravirtualized clocksource: host part
Date: Mon, 31 Mar 2008 17:37:16 +0300
Message-Id: <1206974244-9716-33-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber de Oliveira Costa <gcosta@redhat.com>

This is the host part of kvm clocksource implementation. As it does
not include clockevents, it is a fairly simple implementation. We
only have to register a per-vcpu area, and start writing to it periodically.

The area is binary compatible with xen, as we use the same shadow_info
structure.

[marcelo: fix bad_page on MSR_KVM_SYSTEM_TIME]
[avi: save full value of the msr, even if enable bit is clear]
[avi: clear previous value of time_page]

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |  113 +++++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/kvm_host.h |    7 +++
 include/asm-x86/kvm_para.h |   25 ++++++++++
 include/linux/kvm.h        |    1 +
 4 files changed, 145 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c910c7..256c0fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -19,6 +19,7 @@
 #include "irq.h"
 #include "mmu.h"
 
+#include <linux/clocksource.h>
 #include <linux/kvm.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
@@ -424,7 +425,7 @@ static u32 msrs_to_save[] = {
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
-	MSR_IA32_TIME_STAMP_COUNTER,
+	MSR_IA32_TIME_STAMP_COUNTER, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
 };
 
 static unsigned num_msrs_to_save;
@@ -482,6 +483,70 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	return kvm_set_msr(vcpu, index, *data);
 }
 
+static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
+{
+	static int version;
+	struct kvm_wall_clock wc;
+	struct timespec wc_ts;
+
+	if (!wall_clock)
+		return;
+
+	version++;
+
+	down_read(&kvm->slots_lock);
+	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
+
+	wc_ts = current_kernel_time();
+	wc.wc_sec = wc_ts.tv_sec;
+	wc.wc_nsec = wc_ts.tv_nsec;
+	wc.wc_version = version;
+
+	kvm_write_guest(kvm, wall_clock, &wc, sizeof(wc));
+
+	version++;
+	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
+	up_read(&kvm->slots_lock);
+}
+
+static void kvm_write_guest_time(struct kvm_vcpu *v)
+{
+	struct timespec ts;
+	unsigned long flags;
+	struct kvm_vcpu_arch *vcpu = &v->arch;
+	void *shared_kaddr;
+
+	if ((!vcpu->time_page))
+		return;
+
+	/* Keep irq disabled to prevent changes to the clock */
+	local_irq_save(flags);
+	kvm_get_msr(v, MSR_IA32_TIME_STAMP_COUNTER,
+			  &vcpu->hv_clock.tsc_timestamp);
+	ktime_get_ts(&ts);
+	local_irq_restore(flags);
+
+	/* With all the info we got, fill in the values */
+
+	vcpu->hv_clock.system_time = ts.tv_nsec +
+				     (NSEC_PER_SEC * (u64)ts.tv_sec);
+	/*
+	 * The interface expects us to write an even number signaling that the
+	 * update is finished. Since the guest won't see the intermediate
+	 * state, we just write "2" at the end
+	 */
+	vcpu->hv_clock.version = 2;
+
+	shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
+
+	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
+		sizeof(vcpu->hv_clock));
+
+	kunmap_atomic(shared_kaddr, KM_USER0);
+
+	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
+}
+
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
@@ -511,6 +576,44 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case MSR_IA32_MISC_ENABLE:
 		vcpu->arch.ia32_misc_enable_msr = data;
 		break;
+	case MSR_KVM_WALL_CLOCK:
+		vcpu->kvm->arch.wall_clock = data;
+		kvm_write_wall_clock(vcpu->kvm, data);
+		break;
+	case MSR_KVM_SYSTEM_TIME: {
+		if (vcpu->arch.time_page) {
+			kvm_release_page_dirty(vcpu->arch.time_page);
+			vcpu->arch.time_page = NULL;
+		}
+
+		vcpu->arch.time = data;
+
+		/* we verify if the enable bit is set... */
+		if (!(data & 1))
+			break;
+
+		/* ...but clean it before doing the actual write */
+		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
+
+		vcpu->arch.hv_clock.tsc_to_system_mul =
+					clocksource_khz2mult(tsc_khz, 22);
+		vcpu->arch.hv_clock.tsc_shift = 22;
+
+		down_read(&current->mm->mmap_sem);
+		down_read(&vcpu->kvm->slots_lock);
+		vcpu->arch.time_page =
+				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
+		up_read(&vcpu->kvm->slots_lock);
+		up_read(&current->mm->mmap_sem);
+
+		if (is_error_page(vcpu->arch.time_page)) {
+			kvm_release_page_clean(vcpu->arch.time_page);
+			vcpu->arch.time_page = NULL;
+		}
+
+		kvm_write_guest_time(vcpu);
+		break;
+	}
 	default:
 		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
 		return 1;
@@ -569,6 +672,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_EFER:
 		data = vcpu->arch.shadow_efer;
 		break;
+	case MSR_KVM_WALL_CLOCK:
+		data = vcpu->kvm->arch.wall_clock;
+		break;
+	case MSR_KVM_SYSTEM_TIME:
+		data = vcpu->arch.time;
+		break;
 	default:
 		pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
 		return 1;
@@ -696,6 +805,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SET_TSS_ADDR:
 	case KVM_CAP_EXT_CPUID:
+	case KVM_CAP_CLOCKSOURCE:
 		r = 1;
 		break;
 	case KVM_CAP_VAPIC:
@@ -771,6 +881,7 @@ out:
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
+	kvm_write_guest_time(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index da61255..0c429c8 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -261,6 +261,11 @@ struct kvm_vcpu_arch {
 	/* emulate context */
 
 	struct x86_emulate_ctxt emulate_ctxt;
+
+	gpa_t time;
+	struct kvm_vcpu_time_info hv_clock;
+	unsigned int time_offset;
+	struct page *time_page;
 };
 
 struct kvm_mem_alias {
@@ -287,6 +292,8 @@ struct kvm_arch{
 	int round_robin_prev_vcpu;
 	unsigned int tss_addr;
 	struct page *apic_access_page;
+
+	gpa_t wall_clock;
 };
 
 struct kvm_vm_stat {
diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index c6f3fd8..5ab7d3d 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -10,10 +10,35 @@
  * paravirtualization, the appropriate feature bit should be checked.
  */
 #define KVM_CPUID_FEATURES	0x40000001
+#define KVM_FEATURE_CLOCKSOURCE 0
+
+#define MSR_KVM_WALL_CLOCK  0x11
+#define MSR_KVM_SYSTEM_TIME 0x12
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
 
+/* xen binary-compatible interface. See xen headers for details */
+struct kvm_vcpu_time_info {
+	uint32_t version;
+	uint32_t pad0;
+	uint64_t tsc_timestamp;
+	uint64_t system_time;
+	uint32_t tsc_to_system_mul;
+	int8_t   tsc_shift;
+	int8_t	 pad[3];
+} __attribute__((__packed__)); /* 32 bytes */
+
+struct kvm_wall_clock {
+	uint32_t wc_version;
+	uint32_t wc_sec;
+	uint32_t wc_nsec;
+} __attribute__((__packed__));
+
+
+extern void kvmclock_init(void);
+
+
 /* This instruction is vmcall.  On non-VT architectures, it will generate a
  * trap that we will then rewrite to the appropriate instruction.
  */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c1ec04f..94540b3 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -233,6 +233,7 @@ struct kvm_vapic_addr {
 #define KVM_CAP_SET_TSS_ADDR 4
 #define KVM_CAP_VAPIC 6
 #define KVM_CAP_EXT_CPUID 7
+#define KVM_CAP_CLOCKSOURCE 8
 
 /*
  * ioctls for VM fds
-- 
1.5.4.5

