Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZKPMW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZKPMW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZKPMUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:20:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbZKPMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:43 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 40/42] KVM: SVM: Add tracepoint for nested vmrun
Date: Mon, 16 Nov 2009 14:19:41 +0200
Message-Id: <1258373983-8693-41-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds a dedicated kvm tracepoint for a nested
vmrun.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c   |    6 ++++++
 arch/x86/kvm/trace.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |    1 +
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 884bffc..907af3f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1726,6 +1726,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	/* nested_vmcb is our indicator if nested SVM is activated */
 	svm->nested.vmcb = svm->vmcb->save.rax;
 
+	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, svm->nested.vmcb,
+			       nested_vmcb->save.rip,
+			       nested_vmcb->control.int_ctl,
+			       nested_vmcb->control.event_inj,
+			       nested_vmcb->control.nested_ctl);
+
 	/* Clear internal status */
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 0d480e7..b5798e1 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -349,6 +349,39 @@ TRACE_EVENT(kvm_apic_accept_irq,
 		  __entry->coalesced ? " (coalesced)" : "")
 );
 
+/*
+ * Tracepoint for nested VMRUN
+ */
+TRACE_EVENT(kvm_nested_vmrun,
+	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
+		     __u32 event_inj, bool npt),
+	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		rip		)
+		__field(	__u64,		vmcb		)
+		__field(	__u64,		nested_rip	)
+		__field(	__u32,		int_ctl		)
+		__field(	__u32,		event_inj	)
+		__field(	bool,		npt		)
+	),
+
+	TP_fast_assign(
+		__entry->rip		= rip;
+		__entry->vmcb		= vmcb;
+		__entry->nested_rip	= nested_rip;
+		__entry->int_ctl	= int_ctl;
+		__entry->event_inj	= event_inj;
+		__entry->npt		= npt;
+	),
+
+	TP_printk("rip: 0x%016llx vmcb: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
+		  "event_inj: 0x%08x npt: %s\n",
+		__entry->rip, __entry->vmcb, __entry->nested_rip,
+		__entry->int_ctl, __entry->event_inj,
+		__entry->npt ? "on" : "off")
+);
+
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4de5bc0..3ab2f90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4984,3 +4984,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
-- 
1.6.5.2

