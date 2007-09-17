Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbXIQIsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbXIQIsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbXIQIdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:10 -0400
Received: from il.qumranet.com ([82.166.9.18]:45297 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbXIQIcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 077/104] KVM: Migrate lapic hrtimer when vcpu moves to another cpu
Date: Mon, 17 Sep 2007 10:31:59 +0200
Message-Id: <119001794986-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

This reduces overhead by accessing cachelines from the wrong node, as well
as simplifying locking.

[Qing: fix for inactive or expired one-shot timer]

Signed-off-by: Yaozu (Eddie) Dong <Eddie.Dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.h   |    1 +
 drivers/kvm/lapic.c |   14 ++++++++++++++
 drivers/kvm/svm.c   |    1 +
 drivers/kvm/vmx.c   |    4 +++-
 4 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 87baf7e..f324cfb 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -158,5 +158,6 @@ void kvm_apic_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
+void kvm_migrate_apic_timer(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 490d493..2706ec3 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -979,3 +979,17 @@ void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
 	update_divide_count(apic);
 	start_apic_timer(apic);
 }
+
+void kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->apic;
+	struct hrtimer *timer;
+
+	if (!apic)
+		return;
+
+	timer = &apic->timer.dev;
+	if (hrtimer_cancel(timer))
+		hrtimer_start(timer, timer->expires, HRTIMER_MODE_ABS);
+}
+EXPORT_SYMBOL_GPL(kvm_migrate_apic_timer);
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 00119ec..3de9ec3 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -633,6 +633,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		delta = vcpu->host_tsc - tsc_this;
 		svm->vmcb->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
+		kvm_migrate_apic_timer(vcpu);
 	}
 
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index eeecadf..f4618b9 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -441,8 +441,10 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	u64 phys_addr = __pa(vmx->vmcs);
 	u64 tsc_this, delta;
 
-	if (vcpu->cpu != cpu)
+	if (vcpu->cpu != cpu) {
 		vcpu_clear(vmx);
+		kvm_migrate_apic_timer(vcpu);
+	}
 
 	if (per_cpu(current_vmcs, cpu) != vmx->vmcs) {
 		u8 error;
-- 
1.5.3

