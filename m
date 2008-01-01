Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYAAPik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYAAPik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbYAAPg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:29 -0500
Received: from il.qumranet.com ([82.166.9.18]:33787 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbYAAPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:24 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 07/54] KVM: VMX: Remove the secondary execute control dependency on irqchip
Date: Tue,  1 Jan 2008 17:35:33 +0200
Message-Id: <1199201780-14001-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

The state of SECONDARY_VM_EXEC_CONTROL shouldn't depend on in-kernel IRQ chip,
this patch fix this.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index fbe792d..8e43feb 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -193,11 +193,6 @@ static inline int cpu_has_secondary_exec_ctrls(void)
 		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 }
 
-static inline int vm_need_secondary_exec_ctrls(struct kvm *kvm)
-{
-	return ((cpu_has_secondary_exec_ctrls()) && (irqchip_in_kernel(kvm)));
-}
-
 static inline int cpu_has_vmx_virtualize_apic_accesses(void)
 {
 	return (vmcs_config.cpu_based_2nd_exec_ctrl &
@@ -1524,13 +1519,15 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 				CPU_BASED_CR8_LOAD_EXITING;
 #endif
 	}
-	if (!vm_need_secondary_exec_ctrls(vmx->vcpu.kvm))
-		exec_control &= ~CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, exec_control);
 
-	if (vm_need_secondary_exec_ctrls(vmx->vcpu.kvm))
-		vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
-			     vmcs_config.cpu_based_2nd_exec_ctrl);
+	if (cpu_has_secondary_exec_ctrls()) {
+		exec_control = vmcs_config.cpu_based_2nd_exec_ctrl;
+		if (!vm_need_virtualize_apic_accesses(vmx->vcpu.kvm))
+			exec_control &=
+				~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
+	}
 
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, !!bypass_guest_pf);
 	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, !!bypass_guest_pf);
-- 
1.5.3.7

