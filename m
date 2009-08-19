Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZHSNMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZHSNMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZHSNMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:12:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50556 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/47] KVM: VMX: EPT misconfiguration handler
Date: Wed, 19 Aug 2009 16:02:08 +0300
Message-Id: <1250686963-8357-13-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Handler for EPT misconfiguration which checks for valid state
in the shadow pagetables, printing the spte on each level.

The separate WARN_ONs are useful for kerneloops.org.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6610181..94c07ad 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3227,6 +3227,89 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return kvm_mmu_page_fault(vcpu, gpa & PAGE_MASK, 0);
 }
 
+static u64 ept_rsvd_mask(u64 spte, int level)
+{
+	int i;
+	u64 mask = 0;
+
+	for (i = 51; i > boot_cpu_data.x86_phys_bits; i--)
+		mask |= (1ULL << i);
+
+	if (level > 2)
+		/* bits 7:3 reserved */
+		mask |= 0xf8;
+	else if (level == 2) {
+		if (spte & (1ULL << 7))
+			/* 2MB ref, bits 20:12 reserved */
+			mask |= 0x1ff000;
+		else
+			/* bits 6:3 reserved */
+			mask |= 0x78;
+	}
+
+	return mask;
+}
+
+static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
+				       int level)
+{
+	printk(KERN_ERR "%s: spte 0x%llx level %d\n", __func__, spte, level);
+
+	/* 010b (write-only) */
+	WARN_ON((spte & 0x7) == 0x2);
+
+	/* 110b (write/execute) */
+	WARN_ON((spte & 0x7) == 0x6);
+
+	/* 100b (execute-only) and value not supported by logical processor */
+	if (!cpu_has_vmx_ept_execute_only())
+		WARN_ON((spte & 0x7) == 0x4);
+
+	/* not 000b */
+	if ((spte & 0x7)) {
+		u64 rsvd_bits = spte & ept_rsvd_mask(spte, level);
+
+		if (rsvd_bits != 0) {
+			printk(KERN_ERR "%s: rsvd_bits = 0x%llx\n",
+					 __func__, rsvd_bits);
+			WARN_ON(1);
+		}
+
+		if (level == 1 || (level == 2 && (spte & (1ULL << 7)))) {
+			u64 ept_mem_type = (spte & 0x38) >> 3;
+
+			if (ept_mem_type == 2 || ept_mem_type == 3 ||
+			    ept_mem_type == 7) {
+				printk(KERN_ERR "%s: ept_mem_type=0x%llx\n",
+						__func__, ept_mem_type);
+				WARN_ON(1);
+			}
+		}
+	}
+}
+
+static int handle_ept_misconfig(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	u64 sptes[4];
+	int nr_sptes, i;
+	gpa_t gpa;
+
+	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
+
+	printk(KERN_ERR "EPT: Misconfiguration.\n");
+	printk(KERN_ERR "EPT: GPA: 0x%llx\n", gpa);
+
+	nr_sptes = kvm_mmu_get_spte_hierarchy(vcpu, gpa, sptes);
+
+	for (i = PT64_ROOT_LEVEL; i > PT64_ROOT_LEVEL - nr_sptes; --i)
+		ept_misconfig_inspect_spte(vcpu, sptes[i-1], i);
+
+	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
+	kvm_run->hw.hardware_exit_reason = EXIT_REASON_EPT_MISCONFIG;
+
+	return 0;
+}
+
 static int handle_nmi_window(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u32 cpu_based_vm_exec_control;
@@ -3306,8 +3389,9 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[EXIT_REASON_APIC_ACCESS]             = handle_apic_access,
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,
 	[EXIT_REASON_TASK_SWITCH]             = handle_task_switch,
-	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
 	[EXIT_REASON_MCE_DURING_VMENTRY]      = handle_machine_check,
+	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
+	[EXIT_REASON_EPT_MISCONFIG]           = handle_ept_misconfig,
 };
 
 static const int kvm_vmx_max_exit_handlers =
-- 
1.6.3.3

