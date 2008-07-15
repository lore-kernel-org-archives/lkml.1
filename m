Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYGOMNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYGOMNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYGOMMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:43 -0400
Received: from il.qumranet.com ([212.179.150.194]:30326 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbYGOMMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 01/19] KVM: VMX: Fix a wrong usage of vmcs_config
Date: Tue, 15 Jul 2008 15:12:20 +0300
Message-Id: <1216123958-10717-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

The function ept_update_paging_mode_cr0() write to
CPU_BASED_VM_EXEC_CONTROL based on vmcs_config.cpu_based_exec_ctrl. That's
wrong because the variable may not consistent with the content in the
CPU_BASE_VM_EXEC_CONTROL MSR.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 332ed24..d7522aa 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1441,7 +1441,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 	if (!(cr0 & X86_CR0_PG)) {
 		/* From paging/starting to nonpaging */
 		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
-			     vmcs_config.cpu_based_exec_ctrl |
+			     vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) |
 			     (CPU_BASED_CR3_LOAD_EXITING |
 			      CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
@@ -1451,7 +1451,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 	} else if (!is_paging(vcpu)) {
 		/* From nonpaging to paging */
 		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
-			     vmcs_config.cpu_based_exec_ctrl &
+			     vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) &
 			     ~(CPU_BASED_CR3_LOAD_EXITING |
 			       CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
-- 
1.5.6.1

