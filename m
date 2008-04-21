Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbYDUKe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbYDUKe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbYDUKaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:19 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37945
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbYDUKaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:06 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 14/31] KVM: fix kvm_vcpu_kick vs __vcpu_run race
Date: Mon, 21 Apr 2008 13:29:40 +0300
Message-Id: <1208773797-7829-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

There is a window open between testing of pending IRQ's
and assignment of guest_mode in __vcpu_run.

Injection of IRQ's can race with __vcpu_run as follows:

CPU0                                CPU1
kvm_x86_ops->run()
vcpu->guest_mode = 0                SET_IRQ_LINE ioctl
..
kvm_x86_ops->inject_pending_irq
kvm_cpu_has_interrupt()

                                    apic_test_and_set_irr()
                                    kvm_vcpu_kick
                                    if (vcpu->guest_mode)
                                        send_ipi()

vcpu->guest_mode = 1

So move guest_mode=1 assignment before ->inject_pending_irq, and make
sure that it won't reorder after it.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5c3c9d3..0ce5563 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2802,6 +2802,13 @@ again:
 		goto out;
 	}
 
+	vcpu->guest_mode = 1;
+	/*
+	 * Make sure that guest_mode assignment won't happen after
+	 * testing the pending IRQ vector bitmap.
+	 */
+	smp_wmb();
+
 	if (vcpu->arch.exception.pending)
 		__queue_exception(vcpu);
 	else if (irqchip_in_kernel(vcpu->kvm))
@@ -2813,7 +2820,6 @@ again:
 
 	up_read(&vcpu->kvm->slots_lock);
 
-	vcpu->guest_mode = 1;
 	kvm_guest_enter();
 
 	if (vcpu->requests)
@@ -3970,11 +3976,17 @@ static void vcpu_kick_intr(void *info)
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
 	int ipi_pcpu = vcpu->cpu;
+	int cpu = get_cpu();
 
 	if (waitqueue_active(&vcpu->wq)) {
 		wake_up_interruptible(&vcpu->wq);
 		++vcpu->stat.halt_wakeup;
 	}
-	if (vcpu->guest_mode)
+	/*
+	 * We may be called synchronously with irqs disabled in guest mode,
+	 * So need not to call smp_call_function_single() in that case.
+	 */
+	if (vcpu->guest_mode && vcpu->cpu != cpu)
 		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
+	put_cpu();
 }
-- 
1.5.5

