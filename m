Return-Path: <linux-kernel-owner+w=401wt.eu-S932277AbZJHKFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbZJHKFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbZJHKFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:05:17 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:50353
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932218AbZJHKFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:05:11 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KR6XB3-01-3B9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/9] KVM: SVM: Add tracepoint for nested vmrun
Date: Thu, 8 Oct 2009 12:03:13 +0200
Message-ID: <1254996199-17667-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
References: <1254996199-17667-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 08 Oct 2009 10:03:23.0588 (UTC) FILETIME=[92566040:01CA47FE]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a dedicated kvm tracepoint for a nested
vmrun.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
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
index 0d480e7..d63272c 100644
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
+	TP_printk("rip=0x%016llx vmcb=0x%016llx nrip=0x%016llx int_ctl=0x%08x "
+		  "event_inj=0x%08x npt=%s\n",
+		__entry->rip, __entry->vmcb, __entry->nested_rip,
+		__entry->int_ctl, __entry->event_inj,
+		__entry->npt ? "on" : "off")
+);
+
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11a6f2f..f1e44e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4980,3 +4980,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
-- 
1.6.4.3


