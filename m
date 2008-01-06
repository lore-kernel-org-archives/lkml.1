Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbYAFOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbYAFOoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758344AbYAFOj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:46605 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbYAFOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 19/33] KVM: Move kvm_vcpu_kick() to x86.c
Date: Sun,  6 Jan 2008 16:39:25 +0200
Message-Id: <1199630379-28638-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Moving kvm_vcpu_kick() to x86.c. Since it should be
common for all archs, put its declarations in <linux/kvm_host.h>

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/irq.c       |   20 --------------------
 arch/x86/kvm/irq.h       |    2 --
 arch/x86/kvm/x86.c       |   20 ++++++++++++++++++++
 include/linux/kvm_host.h |    1 +
 4 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 07a09aa..e571475 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -63,26 +63,6 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 }
 EXPORT_SYMBOL_GPL(kvm_cpu_get_interrupt);
 
-static void vcpu_kick_intr(void *info)
-{
-#ifdef DEBUG
-	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)info;
-	printk(KERN_DEBUG "vcpu_kick_intr %p \n", vcpu);
-#endif
-}
-
-void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
-{
-	int ipi_pcpu = vcpu->cpu;
-
-	if (waitqueue_active(&vcpu->wq)) {
-		wake_up_interruptible(&vcpu->wq);
-		++vcpu->stat.halt_wakeup;
-	}
-	if (vcpu->guest_mode)
-		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
-}
-
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu)
 {
 	kvm_inject_apic_timer_irqs(vcpu);
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index c376b5b..53c7f48 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -85,6 +85,4 @@ void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_migrate_apic_timer(struct kvm_vcpu *vcpu);
 
-void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
-
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5902c5c..733bff6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3144,3 +3144,23 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 	return vcpu->arch.mp_state == VCPU_MP_STATE_RUNNABLE
 	       || vcpu->arch.mp_state == VCPU_MP_STATE_SIPI_RECEIVED;
 }
+
+static void vcpu_kick_intr(void *info)
+{
+#ifdef DEBUG
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)info;
+	printk(KERN_DEBUG "vcpu_kick_intr %p \n", vcpu);
+#endif
+}
+
+void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
+{
+	int ipi_pcpu = vcpu->cpu;
+
+	if (waitqueue_active(&vcpu->wq)) {
+		wake_up_interruptible(&vcpu->wq);
+		++vcpu->stat.halt_wakeup;
+	}
+	if (vcpu->guest_mode)
+		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
+}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a85d5b6..953b50a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -250,6 +250,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm);
 
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
+void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
 static inline void kvm_guest_enter(void)
 {
-- 
1.5.3.7

