Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbXLZLUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbXLZLUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXLZLG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:50472 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbXLZLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Eddie Dong <eddie.dong@intel.com>
Subject: [PATCH 41/55] KVM: VMX: wbinvd exiting
Date: Wed, 26 Dec 2007 13:05:46 +0200
Message-Id: <1198667160-22953-42-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Add wbinvd VM Exit support to prepare for pass-through
device cache emulation and also enhance real time
responsiveness.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   11 ++++++++++-
 drivers/kvm/vmx.h |    2 ++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 63c230d..ad16865 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -980,7 +980,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 #endif
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		min = 0;
-		opt = SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
+		opt = SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
+			SECONDARY_EXEC_WBINVD_EXITING;
 		if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS2,
 					&_cpu_based_2nd_exec_control) < 0)
 			return -EIO;
@@ -2133,6 +2134,13 @@ static int handle_vmcall(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static int handle_wbinvd(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	skip_emulated_instruction(vcpu);
+	/* TODO: Add support for VT-d/pass-through device */
+	return 1;
+}
+
 static int handle_apic_access(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u64 exit_qualification;
@@ -2174,6 +2182,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[EXIT_REASON_VMCALL]                  = handle_vmcall,
 	[EXIT_REASON_TPR_BELOW_THRESHOLD]     = handle_tpr_below_threshold,
 	[EXIT_REASON_APIC_ACCESS]             = handle_apic_access,
+	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
 };
 
 static const int kvm_vmx_max_exit_handlers =
diff --git a/drivers/kvm/vmx.h b/drivers/kvm/vmx.h
index 6d32bc6..d52ae8d 100644
--- a/drivers/kvm/vmx.h
+++ b/drivers/kvm/vmx.h
@@ -49,6 +49,7 @@
  * Definitions of Secondary Processor-Based VM-Execution Controls.
  */
 #define SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES 0x00000001
+#define SECONDARY_EXEC_WBINVD_EXITING		0x00000040
 
 
 #define PIN_BASED_EXT_INTR_MASK                 0x00000001
@@ -223,6 +224,7 @@ enum vmcs_field {
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
 #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
 #define EXIT_REASON_APIC_ACCESS         44
+#define EXIT_REASON_WBINVD		54
 
 /*
  * Interruption-information format
-- 
1.5.3.7

