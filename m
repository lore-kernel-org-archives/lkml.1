Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYLHLxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYLHLxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYLHLig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48238 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 13/45] KVM: VMX: Provide support for user space injected NMIs
Date: Mon,  8 Dec 2008 13:36:24 +0200
Message-Id: <1228736216-15787-14-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This patch adds the required bits to the VMX side for user space
injected NMIs. As with the preexisting in-kernel irqchip support, the
CPU must provide the "virtual NMI" feature for proper tracking of the
NMI blocking state.

Based on the original patch by Sheng Yang.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 38d1385..f16a62c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2360,6 +2360,7 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	++vcpu->stat.nmi_injections;
 	if (vcpu->arch.rmode.active) {
 		vmx->rmode.irq.pending = true;
 		vmx->rmode.irq.vector = NMI_VECTOR;
@@ -2428,6 +2429,30 @@ static void do_interrupt_requests(struct kvm_vcpu *vcpu,
 {
 	vmx_update_window_states(vcpu);
 
+	if (cpu_has_virtual_nmis()) {
+		if (vcpu->arch.nmi_pending && !vcpu->arch.nmi_injected) {
+			if (vcpu->arch.nmi_window_open) {
+				vcpu->arch.nmi_pending = false;
+				vcpu->arch.nmi_injected = true;
+			} else {
+				enable_nmi_window(vcpu);
+				return;
+			}
+		}
+		if (vcpu->arch.nmi_injected) {
+			vmx_inject_nmi(vcpu);
+			if (vcpu->arch.nmi_pending
+			    || kvm_run->request_nmi_window)
+				enable_nmi_window(vcpu);
+			else if (vcpu->arch.irq_summary
+				 || kvm_run->request_interrupt_window)
+				enable_irq_window(vcpu);
+			return;
+		}
+		if (!vcpu->arch.nmi_window_open || kvm_run->request_nmi_window)
+			enable_nmi_window(vcpu);
+	}
+
 	if (vcpu->arch.interrupt_window_open) {
 		if (vcpu->arch.irq_summary && !vcpu->arch.interrupt.pending)
 			kvm_do_inject_irq(vcpu);
@@ -2959,6 +2984,14 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
 	++vcpu->stat.nmi_window_exits;
 
+	/*
+	 * If the user space waits to inject a NMI, exit as soon as possible
+	 */
+	if (kvm_run->request_nmi_window && !vcpu->arch.nmi_pending) {
+		kvm_run->exit_reason = KVM_EXIT_NMI_WINDOW_OPEN;
+		return 0;
+	}
+
 	return 1;
 }
 
-- 
1.6.0.3

