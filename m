Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXDAOgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXDAOgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbXDAOgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:36:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:47575 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933297AbXDAOfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 32/41] KVM: SVM: Ensure timestamp counter monotonicity
Date: Sun,  1 Apr 2007 17:35:29 +0300
Message-Id: <11754381393184-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381392527-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a vcpu is migrated from one cpu to another, its timestamp counter
may lose its monotonic property if the host has unsynced timestamp counters.
This can confuse the guest, sometimes to the point of refusing to boot.

As the rdtsc instruction is rather fast on AMD processors (7-10 cycles),
we can simply record the last host tsc when we drop the cpu, and adjust
the vcpu tsc offset when we detect that we've migrated to a different cpu.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    1 +
 drivers/kvm/svm.c |   21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index f5e343c..6d0bd7a 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -244,6 +244,7 @@ struct kvm_vcpu {
 	struct mutex mutex;
 	int   cpu;
 	int   launched;
+	u64 host_tsc;
 	struct kvm_run *run;
 	int interrupt_window_open;
 	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 0542d33..ca2642f 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -459,7 +459,6 @@ static void init_vmcb(struct vmcb *vmcb)
 {
 	struct vmcb_control_area *control = &vmcb->control;
 	struct vmcb_save_area *save = &vmcb->save;
-	u64 tsc;
 
 	control->intercept_cr_read = 	INTERCEPT_CR0_MASK |
 					INTERCEPT_CR3_MASK |
@@ -517,8 +516,7 @@ static void init_vmcb(struct vmcb *vmcb)
 
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = msrpm_base;
-	rdtscll(tsc);
-	control->tsc_offset = -tsc;
+	control->tsc_offset = 0;
 	control->int_ctl = V_INTR_MASKING_MASK;
 
 	init_seg(&save->es);
@@ -606,11 +604,26 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu)
 {
-	get_cpu();
+	int cpu;
+
+	cpu = get_cpu();
+	if (unlikely(cpu != vcpu->cpu)) {
+		u64 tsc_this, delta;
+
+		/*
+		 * Make sure that the guest sees a monotonically
+		 * increasing TSC.
+		 */
+		rdtscll(tsc_this);
+		delta = vcpu->host_tsc - tsc_this;
+		vcpu->svm->vmcb->control.tsc_offset += delta;
+		vcpu->cpu = cpu;
+	}
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	rdtscll(vcpu->host_tsc);
 	put_cpu();
 }
 
-- 
1.5.0.5

