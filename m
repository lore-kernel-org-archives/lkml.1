Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZKSNfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZKSNfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZKSNfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:35:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZKSNfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:06 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 02/35] KVM: SVM: Add tracepoint for invlpga instruction
Date: Thu, 19 Nov 2009 15:34:38 +0200
Message-Id: <1258637711-11674-3-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds a tracepoint for the event that the guest
executed the INVLPGA instruction.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c   |    3 +++
 arch/x86/kvm/trace.h |   23 +++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 78a391c..ba18fb7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1976,6 +1976,9 @@ static int invlpga_interception(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	nsvm_printk("INVLPGA\n");
 
+	trace_kvm_invlpga(svm->vmcb->save.rip, vcpu->arch.regs[VCPU_REGS_RCX],
+			  vcpu->arch.regs[VCPU_REGS_RAX]);
+
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
 	kvm_mmu_invlpg(vcpu, vcpu->arch.regs[VCPU_REGS_RAX]);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 3cc8f44..7e1f08e 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -469,6 +469,29 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
 
 	TP_printk("rip: 0x%016llx\n", __entry->rip)
 );
+
+/*
+ * Tracepoint for nested #vmexit because of interrupt pending
+ */
+TRACE_EVENT(kvm_invlpga,
+	    TP_PROTO(__u64 rip, int asid, u64 address),
+	    TP_ARGS(rip, asid, address),
+
+	TP_STRUCT__entry(
+		__field(	__u64,	rip	)
+		__field(	int,	asid	)
+		__field(	__u64,	address	)
+	),
+
+	TP_fast_assign(
+		__entry->rip		=	rip;
+		__entry->asid		=	asid;
+		__entry->address	=	address;
+	),
+
+	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx\n",
+		  __entry->rip, __entry->asid, __entry->address)
+);
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2cf4146..86596fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4988,3 +4988,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
-- 
1.6.5.2

