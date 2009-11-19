Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZKSNfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZKSNfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZKSNfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:35:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZKSNfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:07 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 03/35] KVM: SVM: Add tracepoint for skinit instruction
Date: Thu, 19 Nov 2009 15:34:39 +0200
Message-Id: <1258637711-11674-4-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds a tracepoint for the event that the guest
executed the SKINIT instruction. This information is
important because SKINIT is an SVM extenstion not yet
implemented by nested SVM and we may need this information
for debugging hypervisors that do not yet run on nested SVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c   |   10 +++++++++-
 arch/x86/kvm/trace.h |   22 ++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ba18fb7..8b9f6fb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1987,6 +1987,14 @@ static int invlpga_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int skinit_interception(struct vcpu_svm *svm)
+{
+	trace_kvm_skinit(svm->vmcb->save.rip, svm->vcpu.arch.regs[VCPU_REGS_RAX]);
+
+	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+	return 1;
+}
+
 static int invalid_op_interception(struct vcpu_svm *svm)
 {
 	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
@@ -2350,7 +2358,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_VMSAVE]			= vmsave_interception,
 	[SVM_EXIT_STGI]				= stgi_interception,
 	[SVM_EXIT_CLGI]				= clgi_interception,
-	[SVM_EXIT_SKINIT]			= invalid_op_interception,
+	[SVM_EXIT_SKINIT]			= skinit_interception,
 	[SVM_EXIT_WBINVD]                       = emulate_on_interception,
 	[SVM_EXIT_MONITOR]			= invalid_op_interception,
 	[SVM_EXIT_MWAIT]			= invalid_op_interception,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 7e1f08e..816e044 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -492,6 +492,28 @@ TRACE_EVENT(kvm_invlpga,
 	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx\n",
 		  __entry->rip, __entry->asid, __entry->address)
 );
+
+/*
+ * Tracepoint for nested #vmexit because of interrupt pending
+ */
+TRACE_EVENT(kvm_skinit,
+	    TP_PROTO(__u64 rip, __u32 slb),
+	    TP_ARGS(rip, slb),
+
+	TP_STRUCT__entry(
+		__field(	__u64,	rip	)
+		__field(	__u32,	slb	)
+	),
+
+	TP_fast_assign(
+		__entry->rip		=	rip;
+		__entry->slb		=	slb;
+	),
+
+	TP_printk("rip: 0x%016llx slb: 0x%08x\n",
+		  __entry->rip, __entry->slb)
+);
+
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86596fc..098e7f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4989,3 +4989,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
-- 
1.6.5.2

