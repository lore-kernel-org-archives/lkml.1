Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYAFOrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYAFOrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbYAFOkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:11 -0500
Received: from il.qumranet.com ([82.166.9.18]:46617 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbYAFOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 25/33] KVM: Accelerated apic support
Date: Sun,  6 Jan 2008 16:39:31 +0200
Message-Id: <1199630379-28638-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a mechanism for exposing the virtual apic tpr to the guest, and a
protocol for letting the guest update the tpr without causing a vmexit if
conditions allow (e.g. there is no interrupt pending with a higher priority
than the new tpr).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/lapic.c     |   51 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/lapic.h     |    6 +++++
 arch/x86/kvm/x86.c       |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm.h      |    7 ++++++
 include/linux/kvm_para.h |    2 +
 5 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 50c3f3a..e7513bb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -815,7 +815,8 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 
 	if (!apic)
 		return;
-	apic_set_tpr(apic, ((cr8 & 0x0f) << 4));
+	apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
+		     | (apic_get_reg(apic, APIC_TASKPRI) & 4));
 }
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
@@ -1104,3 +1105,51 @@ void kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 		hrtimer_start(timer, timer->expires, HRTIMER_MODE_ABS);
 }
 EXPORT_SYMBOL_GPL(kvm_migrate_apic_timer);
+
+void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
+{
+	u32 data;
+	void *vapic;
+
+	if (!irqchip_in_kernel(vcpu->kvm) || !vcpu->arch.apic->vapic_addr)
+		return;
+
+	vapic = kmap_atomic(vcpu->arch.apic->vapic_page, KM_USER0);
+	data = *(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr));
+	kunmap_atomic(vapic, KM_USER0);
+
+	apic_set_tpr(vcpu->arch.apic, data & 0xff);
+}
+
+void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu)
+{
+	u32 data, tpr;
+	int max_irr, max_isr;
+	struct kvm_lapic *apic;
+	void *vapic;
+
+	if (!irqchip_in_kernel(vcpu->kvm) || !vcpu->arch.apic->vapic_addr)
+		return;
+
+	apic = vcpu->arch.apic;
+	tpr = apic_get_reg(apic, APIC_TASKPRI) & 0xff;
+	max_irr = apic_find_highest_irr(apic);
+	if (max_irr < 0)
+		max_irr = 0;
+	max_isr = apic_find_highest_isr(apic);
+	if (max_isr < 0)
+		max_isr = 0;
+	data = (tpr & 0xff) | ((max_isr & 0xf0) << 8) | (max_irr << 24);
+
+	vapic = kmap_atomic(vcpu->arch.apic->vapic_page, KM_USER0);
+	*(u32 *)(vapic + offset_in_page(vcpu->arch.apic->vapic_addr)) = data;
+	kunmap_atomic(vapic, KM_USER0);
+}
+
+void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
+{
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return;
+
+	vcpu->arch.apic->vapic_addr = vapic_addr;
+}
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 447b654..676c396 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -18,6 +18,8 @@ struct kvm_lapic {
 	struct kvm_vcpu *vcpu;
 	struct page *regs_page;
 	void *regs;
+	gpa_t vapic_addr;
+	struct page *vapic_page;
 };
 int kvm_create_lapic(struct kvm_vcpu *vcpu);
 void kvm_free_lapic(struct kvm_vcpu *vcpu);
@@ -41,4 +43,8 @@ int kvm_lapic_enabled(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 void kvm_apic_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 
+void kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
+void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
+void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c2b8088..e7eac27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1173,6 +1173,19 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = 0;
 		break;
 	};
+	case KVM_SET_VAPIC_ADDR: {
+		struct kvm_vapic_addr va;
+
+		r = -EINVAL;
+		if (!irqchip_in_kernel(vcpu->kvm))
+			goto out;
+		r = -EFAULT;
+		if (copy_from_user(&va, argp, sizeof va))
+			goto out;
+		r = 0;
+		kvm_lapic_set_vapic_addr(vcpu, va.vapic_addr);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
@@ -2214,6 +2227,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	}
 
 	switch (nr) {
+	case KVM_HC_VAPIC_POLL_IRQ:
+		ret = 0;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -2421,6 +2437,29 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 					 vcpu->arch.irq_summary == 0);
 }
 
+static void vapic_enter(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	struct page *page;
+
+	if (!apic || !apic->vapic_addr)
+		return;
+
+	page = gfn_to_page(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
+	vcpu->arch.apic->vapic_page = page;
+}
+
+static void vapic_exit(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (!apic || !apic->vapic_addr)
+		return;
+
+	kvm_release_page_dirty(apic->vapic_page);
+	mark_page_dirty(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
+}
+
 static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
@@ -2435,6 +2474,8 @@ static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.mp_state = VCPU_MP_STATE_RUNNABLE;
 	}
 
+	vapic_enter(vcpu);
+
 preempted:
 	if (vcpu->guest_debug.enabled)
 		kvm_x86_ops->guest_debug_pre(vcpu);
@@ -2444,6 +2485,14 @@ again:
 	if (unlikely(r))
 		goto out;
 
+	if (vcpu->requests)
+		if (test_and_clear_bit(KVM_REQ_REPORT_TPR_ACCESS,
+				       &vcpu->requests)) {
+			kvm_run->exit_reason = KVM_EXIT_TPR_ACCESS;
+			r = 0;
+			goto out;
+		}
+
 	kvm_inject_pending_timer_irqs(vcpu);
 
 	preempt_disable();
@@ -2469,6 +2518,8 @@ again:
 	else
 		kvm_x86_ops->inject_pending_vectors(vcpu, kvm_run);
 
+	kvm_lapic_sync_to_vapic(vcpu);
+
 	vcpu->guest_mode = 1;
 	kvm_guest_enter();
 
@@ -2506,6 +2557,8 @@ again:
 	if (vcpu->arch.exception.pending && kvm_x86_ops->exception_injected(vcpu))
 		vcpu->arch.exception.pending = false;
 
+	kvm_lapic_sync_from_vapic(vcpu);
+
 	r = kvm_x86_ops->handle_exit(kvm_run, vcpu);
 
 	if (r > 0) {
@@ -2527,6 +2580,8 @@ out:
 
 	post_kvm_run_save(vcpu, kvm_run);
 
+	vapic_exit(vcpu);
+
 	return r;
 }
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 850f5ef..b27a381 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -216,6 +216,11 @@ struct kvm_tpr_access_ctl {
 	__u32 reserved[8];
 };
 
+/* for KVM_SET_VAPIC_ADDR */
+struct kvm_vapic_addr {
+	__u64 vapic_addr;
+};
+
 #define KVMIO 0xAE
 
 /*
@@ -291,5 +296,7 @@ struct kvm_tpr_access_ctl {
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
 #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO,  0x92, struct kvm_tpr_access_ctl)
+/* Available with KVM_CAP_VAPIC */
+#define KVM_SET_VAPIC_ADDR        _IOW(KVMIO,  0x93, struct kvm_vapic_addr)
 
 #endif
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index e4db25f..6af91a5 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -12,6 +12,8 @@
 /* Return values for hypercalls */
 #define KVM_ENOSYS		1000
 
+#define KVM_HC_VAPIC_POLL_IRQ            1
+
 #ifdef __KERNEL__
 /*
  * hypercalls use architecture specific
-- 
1.5.3.7

