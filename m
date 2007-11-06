Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbXKFVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbXKFVXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbXKFVXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:23:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbXKFVXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:23:04 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jeremy@goop.org, avi@qumranet.com, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: kvmclock - the host part.
Date: Tue,  6 Nov 2007 20:18:55 -0200
Message-Id: <11943875471622-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11943875433821-git-send-email-gcosta@redhat.com>
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the host part of kvm clocksource implementation. As it does
not include clockevents, it is a fairly simple implementation. We
only have to register a per-vcpu area, and start writting to it periodically.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/kvm/irq.c      |    1 +
 drivers/kvm/kvm_main.c |    2 +
 drivers/kvm/svm.c      |    1 +
 drivers/kvm/vmx.c      |    1 +
 drivers/kvm/x86.c      |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/x86.h      |   13 ++++++++++
 6 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/irq.c b/drivers/kvm/irq.c
index 22bfeee..0344879 100644
--- a/drivers/kvm/irq.c
+++ b/drivers/kvm/irq.c
@@ -92,6 +92,7 @@ void kvm_vcpu_kick_request(struct kvm_vcpu *vcpu, int request)
 
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 {
+	vcpu->time_needs_update = 1;
 	kvm_inject_apic_timer_irqs(vcpu);
 	/* TODO: PIT, RTC etc. */
 }
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 0b8edca..5834573 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -20,6 +20,7 @@
 #include "x86_emulate.h"
 #include "irq.h"
 
+#include <linux/clocksource.h>
 #include <linux/kvm.h>
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -1242,6 +1243,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		case KVM_CAP_MMU_SHADOW_CACHE_CONTROL:
 		case KVM_CAP_USER_MEMORY:
 		case KVM_CAP_SET_TSS_ADDR:
+		case KVM_CAP_CLK:
 			r = 1;
 			break;
 		default:
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 95a3489..cb8c19d 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -617,6 +617,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
 	kvm_vcpu_uninit(vcpu);
+	release_clock(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
 }
 
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index da3a339..b5edeed 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2501,6 +2501,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	kfree(vmx->host_msrs);
 	kfree(vmx->guest_msrs);
 	kvm_vcpu_uninit(vcpu);
+	release_clock(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 }
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index e905d46..d476488 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -19,6 +19,7 @@
 #include "segment_descriptor.h"
 #include "irq.h"
 
+#include <linux/clocksource.h>
 #include <linux/kvm.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
@@ -1628,6 +1629,31 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
+static void kvm_write_guest_time(struct kvm_vcpu *vcpu)
+{
+	struct timespec ts;
+	void *clock_addr;
+
+
+	if (!vcpu->clock_page)
+		return;
+
+	/* Updates version to the next odd number, indicating we're writing */
+	vcpu->hv_clock.version++;
+	/* Updating the tsc count is the first thing we do */
+	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER, &vcpu->hv_clock.last_tsc);
+	ktime_get_ts(&ts);
+	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC * (u64)ts.tv_sec);
+	vcpu->hv_clock.wc_sec = get_seconds();
+	vcpu->hv_clock.version++;
+
+	clock_addr = vcpu->clock_addr;
+	memcpy(clock_addr, &vcpu->hv_clock, sizeof(vcpu->hv_clock));
+	mark_page_dirty(vcpu->kvm, vcpu->clock_gfn);
+
+	vcpu->time_needs_update = 0;
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -1648,7 +1674,33 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
+	ret = 0;
 	switch (nr) {
+	case  KVM_HCALL_REGISTER_CLOCK: {
+		struct kvm_vcpu *dst_vcpu;
+
+		if (!((a1 < KVM_MAX_VCPUS) && (vcpu->kvm->vcpus[a1]))) {
+			ret = -KVM_EINVAL;
+			break;
+		}
+
+		dst_vcpu = vcpu->kvm->vcpus[a1];
+		dst_vcpu->clock_page = gfn_to_page(vcpu->kvm, a0 >> PAGE_SHIFT);
+
+		if (!dst_vcpu->clock_page) {
+			ret = -KVM_EINVAL;
+			break;
+		}
+		dst_vcpu->clock_gfn = a0 >> PAGE_SHIFT;
+
+		dst_vcpu->hv_clock.tsc_mult = clocksource_khz2mult(tsc_khz, 22);
+		dst_vcpu->clock_addr = kmap(dst_vcpu->clock_page);
+
+		dst_vcpu->time_needs_update = 1;
+
+		break;
+	}
+
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -1816,6 +1868,12 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu,
 					 vcpu->irq_summary == 0);
 }
 
+void kvm_update_guest_time(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->time_needs_update)
+		kvm_write_guest_time(vcpu);
+}
+
 static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	int r;
@@ -1876,6 +1934,7 @@ again:
 	vcpu->guest_mode = 1;
 	kvm_guest_enter();
 
+	kvm_update_guest_time(vcpu);
 	kvm_x86_ops->run(vcpu, kvm_run);
 
 	vcpu->guest_mode = 0;
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 663b822..7a951cc 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -15,6 +15,7 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/highmem.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
@@ -83,8 +84,20 @@ struct kvm_vcpu {
 	/* emulate context */
 
 	struct x86_emulate_ctxt emulate_ctxt;
+
+	union kvm_hv_clock hv_clock;
+	int time_needs_update;
+	struct page *clock_page;
+	void *clock_addr; /* address in host space */
+	u64 clock_gfn; /* guest frame number, physical addr */
+
 };
 
+static inline void release_clock(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->clock_page)
+		kunmap(vcpu->clock_page);
+}
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code);
 
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
-- 
1.5.0.6

